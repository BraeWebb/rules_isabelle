load("@isabelle//:provider.bzl", "IsabelleProvider")

def _isabelle_test_impl(ctx):
    executable = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.write(
        output = executable,
        content = " ".join([
            ctx.executable._isabelle_test.path,
            ctx.executable._compiler.path,
            ctx.file.root.dirname,
            ctx.attr.session,
        ]),
        is_executable=True
    )
    executables = ctx.runfiles(files = [ctx.executable._isabelle_test, ctx.executable._compiler])
    srcs = ctx.runfiles(files = ctx.files.srcs + [ctx.file.root])
    runfiles = executables.merge(srcs)
    return [DefaultInfo(executable = executable, runfiles = runfiles)]

_isabelle_args = {
    "session": attr.string(mandatory = True),
    "root": attr.label(
        mandatory = True,
        allow_single_file = True,
    ),
    "srcs": attr.label_list(mandatory = True, allow_files = True),
    "_compiler": attr.label(
        default = "@isabelle//:Isabelle/bin/isabelle",
        allow_single_file = True,
        executable = True,
        cfg = "host",
    ),
    "_isabelle_provider": attr.label(
        default = "@isabelle//:provider",
        providers = [IsabelleProvider],
        cfg = "host",
    )
}

isabelle_test = rule(
    implementation = _isabelle_test_impl,
    test = True,
    attrs = dict(_isabelle_args.items() + {
        "_isabelle_test": attr.label(
            default = "isabelle_test.sh",
            allow_single_file = True,
            executable = True,
            cfg = "host",
        )
    }.items()),
)