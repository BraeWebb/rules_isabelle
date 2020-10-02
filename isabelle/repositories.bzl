load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

BINARY_URL = "https://isabelle.in.tum.de/website-Isabelle{0}/dist/Isabelle{0}_{1}.tar.gz"
SUPPORTED_RELEASES = [
    "2020",
    "2019",
]
PLATFORMS = {
    "linux": "linux",
    "macos": "macos",
}

SHAS = {
    "2020": {
        "linux": "633aff864d6647bd175cf831e7513e3fd0cd06beacbf29a5c6c66d4de1522bae",
        "macos": "bd0353ee15b9371729e94548c849864d14531eb2e9125fde48122b4da32bd9e9"
    },
    "2019": {
        "linux": "2f6b204410e1343fe6e46739ea06c3c7c1b8be20941222227c1cda2090451996",
        "macos": "a422bc02a985182440eff0943735db8c9ae4b67190ed47d08c8d968385179a80"
    }
}

def _binary_url(release, platform):
    return BINARY_URL.format(release, platform)

def _binary_sha(release, platform):
    return SHAS[release][platform]

def _binary_prefix(release, platform):
    prefix = "Isabelle" + release
    if platform == "macos":
        prefix += ".app"
    return prefix

def _isabelle_repository_impl(ctx):
    release = ctx.attr.release
    if release not in SUPPORTED_RELEASES:
        fail("Unsupported release version: " + release + 
             " (" + ", ".join(SUPPORTED_RELEASES) + ") supported")

    platform = ctx.os.name
    if platform not in PLATFORMS:
        fail("Unsupported operating system: " + platform +
             " (" + ", ".join(PLATFORMS) + ") supported")
    
    remote = _binary_url(release, platform)
    sha = _binary_sha(release, platform)
    prefix = _binary_prefix(release, platform)

    ctx.download_and_extract(
        url = [remote],
        sha256 = sha,
        stripPrefix = prefix,
    )

    ctx.file("BUILD", """
exports_files(glob(["bin/**/*"]))
""")


_isabelle_repository = repository_rule(
    attrs = {
        "release": attr.string(default = "2020"),
    },
    implementation = _isabelle_repository_impl,
)

def isabelle_repository(release="2020"):
    _isabelle_repository(
        name = "isabelle",
        release = release
    )
