workspace(name = "rules_isabelle")

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "bazel_latex",
    # fetch a fork to allow non-bazel built latex to work
    remote = "https://github.com/BraeWebb/bazel-latex",
    commit = "d76b36b3f4a4a681d9b2a537c4f007cd490c7b5e"
)

load("@bazel_latex//:repositories.bzl", "latex_repositories")

latex_repositories()
