load("@bazel_latex//:latex.bzl", "latex_document")

def _isabelle_document_impl(ctx):
    ctx.actions.run(
        executable = ctx.executable._build_document,
        arguments = [
            ctx.executable._compiler.path,
            ctx.executable._pdflatex.path,
            ctx.file.root.dirname,
            ctx.attr.session,
            ctx.outputs.output_main.path,
            ctx.outputs.output_srcs.path,
        ],
        inputs = depset(
            direct = [ctx.file.root] + ctx.files.srcs,
        ),
        outputs = [ctx.outputs.output_main, ctx.outputs.output_srcs],
        tools = [
            ctx.executable._compiler,
            ctx.executable._pdflatex,
        ]
    )


_isabelle_document = rule(
    implementation = _isabelle_document_impl,
    attrs = {
        "session": attr.string(mandatory = True),
        "root": attr.label(
            mandatory = True,
            allow_single_file = True,
        ),
        "srcs": attr.label_list(mandatory = True, allow_files = True),
        "output_main": attr.output(
            mandatory = True,
        ),
        "output_srcs": attr.output(
            mandatory = True,
        ),
        "_compiler": attr.label(
            default = "@isabelle//:Isabelle/bin/isabelle",
            allow_single_file = True,
            executable = True,
            cfg = "host",
        ),
        "_pdflatex": attr.label(
            default = "pdflatex",
            allow_single_file = True,
            executable = True,
            cfg = "host",
        ),
        "_build_document": attr.label(
            default = "build_document.sh",
            allow_single_file = True,
            executable = True,
            cfg = "host"
        )
    },
)


def isabelle_document(
    name,
    session,
    root,
    srcs,
    packages = [],
):
    _isabelle_document(
        name = "%{name}_doc",
        session = session,
        root = root,
        srcs = srcs,
    
        output_main = name + "_root.tex",
        output_srcs = name + "_doc"
    )

    latex_document(
        name = name,
        main = name + "_root.tex",
        srcs = [
            name + "_doc",
            # Isabelle latex external deps
            "@bazel_latex//packages:color",
            "@bazel_latex//packages:hyperref",
            "@bazel_latex//packages:ulem",
        ] + packages,
        inputs = [name + "_doc"],
    )