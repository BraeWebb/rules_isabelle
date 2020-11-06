load("@rules_isabelle//isabelle:isabelle.bzl", "isabelle_document", "isabelle_html", "isabelle_snippet")

isabelle_document(
    name = "hello_document",
    session = "hello",
    root = "ROOT",
    srcs = [
        "Hello.thy",
    ] + glob([
        "document/**/*.tex"
    ])
)

isabelle_html(
    name = "hello_html",
    session = "hello",
    root = "ROOT",
    srcs = [
        "Hello.thy",
    ] + glob([
        "document/**/*.tex"
    ])
)

isabelle_snippet(
    name = "hello_snip",
    session = "hello",
    root = "ROOT",
    srcs = [
        "Hello.thy",
    ] + glob([
        "document/**/*.tex"
    ]),
    snippet = "snippet.tex",
)

