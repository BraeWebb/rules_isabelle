load("@bazel_latex//:latex.bzl", "latex_document")
load("@isabelle//:provider.bzl", "IsabelleProvider")


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


def _isabelle_html_impl(ctx):
    output_website = ctx.actions.declare_directory(ctx.label.name + "_web")

    ctx.actions.run(
        executable = ctx.executable._build_html,
        arguments = [
            ctx.executable._compiler.path,
            ctx.file.root.dirname,
            ctx.attr.session,
            output_website.path,
            ctx.attr._isabelle_provider[IsabelleProvider].release,
        ],
        inputs = depset(
            direct = [ctx.file.root] + ctx.files.srcs,
        ),
        outputs = [output_website],
        tools = [
            ctx.executable._compiler,
            ctx.executable._pdflatex,
        ]
    )

    return [DefaultInfo(files = depset([output_website]))]

def _isabelle_snippet_impl(ctx):
    ctx.actions.run(
        executable = ctx.executable._build_snippet,
        arguments = [
            ctx.executable._compiler.path,
            ctx.file.root.dirname,
            ctx.attr.session,
            ctx.outputs.snippet.path,
        ],
        inputs = depset(
            direct = [ctx.file.root] + ctx.files.srcs,
        ),
        outputs = [ctx.outputs.snippet],
        tools = [
            ctx.executable._compiler,
            ctx.executable._pdflatex,
        ]
    )

    return [DefaultInfo(files = depset([ctx.outputs.snippet]))]


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
    "_pdflatex": attr.label(
        default = "pdflatex",
        allow_single_file = True,
        executable = True,
        cfg = "host"
    ),
    "_isabelle_provider": attr.label(
        default = "@isabelle//:provider",
        providers = [IsabelleProvider],
        cfg = "host",
    )
}

_isabelle_document = rule(
    implementation = _isabelle_document_impl,
    attrs = dict(_isabelle_args.items() + {
        "_build_document": attr.label(
            default = "build_document.sh",
            allow_single_file = True,
            executable = True,
            cfg = "host",
        ),
        "output_main": attr.output(
            mandatory = True,
        ),
        "output_srcs": attr.output(
            mandatory = True,
        ),
    }.items()),
)

isabelle_html = rule(
    implementation = _isabelle_html_impl,
    attrs = dict(_isabelle_args.items() + {
        "_build_html": attr.label(
            default = "build_html.sh",
            allow_single_file = True,
            executable = True,
            cfg = "host"
        )
    }.items()),
)

isabelle_snippet = rule(
    implementation = _isabelle_snippet_impl,
    attrs = dict(_isabelle_args.items() + {
        "snippet": attr.output(),
        "_build_snippet": attr.label(
            default = "build_snippet.sh",
            allow_single_file = True,
            executable = True,
            cfg = "host"
        )
    }.items()),
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