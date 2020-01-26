load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository", "new_git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//third_party:sorbet_version.bzl", "SORBET_SHALLOW_SINCE", "SORBET_VERSION")

# We define our externals here instead of directly in WORKSPACE
# because putting the `new_git_repository` calls here instead of there
# works around https://github.com/bazelbuild/bazel/issues/1465 when
# passing `build_file` to the `new_git_repository`.
def sorbet_llvm_externals():
    use_local = False
    if not use_local:
        git_repository(
            name = "com_stripe_ruby_typer",
            remote = "https://github.com/sorbet/sorbet.git",
            commit = SORBET_VERSION,
            shallow_since = SORBET_SHALLOW_SINCE,
        )
    else:
        native.local_repository(
            name = "com_stripe_ruby_typer",
            path = "../sorbet/",
        )

    http_archive(
        name = "llvm",
        url = "https://github.com/llvm/llvm-project/archive/c1a0a213378a458fbea1a5c77b315c7dce08fd05.tar.gz", # llvm 9.0.1
        build_file = "@com_stripe_sorbet_llvm//third_party/llvm:llvm.autogenerated.BUILD",
        sha256 = "81a1a2ef99a780759b03dbcc926f11ce75acbdf227c1c66cce6f2057b58a962b",
        strip_prefix = "llvm-project-c1a0a213378a458fbea1a5c77b315c7dce08fd05/llvm",
    )

    http_archive(
        name = "zlib_archive",
        url = "https://zlib.net/zlib-1.2.11.tar.gz",
        build_file = "@com_stripe_sorbet_llvm//third_party:zlib.BUILD",
        sha256 = "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1",
        strip_prefix = "zlib-1.2.11",
    )

    http_archive(
        name = "sorbet_ruby",
        url = "https://cache.ruby-lang.org/pub/ruby/2.6/ruby-2.6.5.tar.gz",
        sha256 = "66976b716ecc1fd34f9b7c3c2b07bbd37631815377a2e3e85a5b194cfdcbed7d",
        strip_prefix = "ruby-2.6.5",
        build_file = "@com_stripe_sorbet_llvm//third_party/ruby:ruby.BUILD",
    )
