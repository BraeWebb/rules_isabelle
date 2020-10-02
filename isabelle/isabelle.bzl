# def _isabelle_test_impl(ctx):
#     isabelle_workdir = ctx.actions.declare_directory(".isabelle")

#     ctx.actions.run(
#         executable = ctx.executable._compiler,
#         env = {"HOME": "."},
#         arguments = [
#             "build", "-d", ctx.file.root.dirname, ctx.attr.session
#         ],
#         inputs = depset(
#             direct = [ctx.file.root] + ctx.files.srcs,
#         ),
#         outputs = [isabelle_workdir],
#         tools = [ctx.executable._compiler],
#     )

#     return [DefaultInfo(files = depset([isabelle_workdir]))]


# isabelle_test = rule(
#     implementation = _isabelle_test_impl,
#     attrs = {
#         "session": attr.string(mandatory = True),
#         "root": attr.label(
#             mandatory = True,
#             allow_single_file = True,
#         ),
#         "srcs": attr.label_list(mandatory = True, allow_files = True),
#         "_compiler": attr.label(
#             default = "@isabelle//:bin/isabelle",
#             allow_single_file = True,
#             executable = True,
#             cfg = "host",
#         )
#     },
#     test = True,
# )

def _isabelle_document_impl(ctx):
    output_document = ctx.actions.declare_file(ctx.label.name + ".pdf")

    # ctx.actions.run(
    #     executable = ctx.executable._compiler,
    #     env = {"HOME": "."},
    #     arguments = [
    #         "build", 
    #         "-d", ctx.file.root.dirname, 
    #         "-o", "document=pdf",
    #         "-o", "document_output=" + output_directory.abspath,
    #          ctx.attr.session
    #     ],
    #     inputs = depset(
    #         direct = [ctx.file.root] + ctx.files.srcs,
    #     ),
    #     outputs = [isabelle_workdir, output_directory, tmp_document],
    #     tools = [ctx.executable._compiler],
    # )

    ctx.actions.run(
        executable = ctx.executable._build_document,
        arguments = [
            ctx.executable._compiler.path,
            ctx.file.root.dirname,
            ctx.attr.session,
            output_document.path
        ],
        inputs = depset(
            direct = [ctx.file.root] + ctx.files.srcs,
        ),
        outputs = [output_document],
        tools = [ctx.executable._compiler]
    )

    return [DefaultInfo(files = depset([output_document]))]


isabelle_document = rule(
    implementation = _isabelle_document_impl,
    attrs = {
        "session": attr.string(mandatory = True),
        "root": attr.label(
            mandatory = True,
            allow_single_file = True,
        ),
        "srcs": attr.label_list(mandatory = True, allow_files = True),
        "_compiler": attr.label(
            default = "@isabelle//:bin/isabelle",
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
