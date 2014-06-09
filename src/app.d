import std.algorithm;
import std.range;
import std.array;
import std.string;
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

enum changelogTuple = SliceToExpressionTuple!(
    chain(
        iota(1, 24),
        iota(25, 66)
    )
    .map!(x => "2.%03d".format(x))
    .array
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
