import std.algorithm;
import std.array;
import std.typetuple;

import vibe.http.server;
import vibe.http.fileserver;
import vibe.appmain;

template StaticArrayToExpressionTuple(alias array) {
    import std.typetuple;

    static if (array.length == 0) {
        alias StaticArrayToExpressionTuple = TypeTuple!();
    } else {
        alias StaticArrayToExpressionTuple = Impl!(array.length - 1);

        private template Impl(size_t index) {
            static if (index == 0) {
                alias Impl = TypeTuple!(array[index]);
            } else {
                alias Impl = TypeTuple!(Impl!(index - 1), array[index]);
            }
        }
    }
}

/**
 * Convert a slice at compile time to a static array.
 *
 * Note: This doesn't account for a 0-size slice.
 */
template SliceToStaticArray(alias slice) {
    enum typeof(slice[0])[slice.length] SliceToStaticArray = slice[0 .. $];
}

/**
 * Convert a slice known at compile time to an expression tuple.
 *
 * Note: This doesn't account for a 0-size slice.
 */
template SliceToExpressionTuple(alias slice) {
    enum SliceToExpressionTuple =
        StaticArrayToExpressionTuple!(SliceToStaticArray!slice);
}

alias Request = HTTPServerRequest;
alias Response = HTTPServerResponse;

template basicPage(string templatePath) {
    void basicPage(Request request, Response response) {
        response.render!(templatePath, request);
    }
}

template changelogPage(string thisVersion) {
    void changelogPage(Request request, Response response) {
        response.render!(
            "changelog/" ~ thisVersion ~ ".dt",
            request,
            thisVersion
        );
    }
}

// TODO: This uses an HTML style redirect.
// This needs replacing with something else.
template redirectPage(string toURL) {
    void redirectPage(Request request, Response response) {
        response.redirect(toURL, 301);
    }
}

// Load the list of basic view files we got from a pre-build step.
enum basicFileTuple = SliceToExpressionTuple!(
    import("basic_view_list").split("\n")
);

enum changelogTuple = TypeTuple!(
    "2.000",
    "2.001",
    "2.002",
    "2.003",
    "2.004",
    "2.005",
    "2.006",
    "2.007",
    "2.008",
    "2.009",
    "2.010",
    "2.011",
    "2.012",
    "2.013",
    "2.014",
    "2.015",
    "2.016",
    "2.017",
    "2.018",
    "2.019",
    "2.020",
    "2.021",
    "2.022",
    "2.023",
    "2.025",
    "2.026",
    "2.027",
    "2.028",
    "2.029",
    "2.030",
    "2.031",
    "2.032",
    "2.033",
    "2.034",
    "2.035",
    "2.036",
    "2.037",
    "2.038",
    "2.039",
    "2.040",
    "2.041",
    "2.042",
    "2.043",
    "2.044",
    "2.045",
    "2.046",
    "2.047",
    "2.048",
    "2.049",
    "2.050",
    "2.051",
    "2.052",
    "2.053",
    "2.054",
    "2.055",
    "2.056",
    "2.057",
    "2.058",
    "2.059",
    "2.060",
    "2.061",
    "2.062",
    "2.063",
    "2.064",
    "2.065",
);

shared static this() {
    import vibe.http.router;

    auto settings = new HTTPServerSettings;
    settings.port = 8010;

    auto fileSettings = new HTTPFileServerSettings;
    fileSettings.serverPathPrefix = "/static";

    auto router = new URLRouter;

    foreach(dietFilename; basicFileTuple) {
        // Set up routes with compiled templates for each file that we found.
        router.get(
            "/" ~ dietFilename["basic/".length .. $ - ".dt".length],
            &basicPage!dietFilename
        );
    }

    foreach(thisVersion; changelogTuple) {
        router.get("/changelog/" ~ thisVersion, &changelogPage!thisVersion);
    }

    router
    .get("/", &basicPage!"index.dt")
    // Old page URLs are 301 redirected to the new URLs.
    .get("/download.html", &redirectPage!"/download")
    .get("/changelog.html", &redirectPage!"/changelog")
    .get("/static/*", serveStaticFiles("../static/", fileSettings))
    ;

    listenHTTP(settings, router);
}
