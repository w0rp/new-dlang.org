import std.algorithm;
import std.array;

import vibe.http.server;
import vibe.http.fileserver;
import vibe.appmain;

template ArrayExpressionTuple(alias array) {
    import std.typetuple;

    static if (array.length == 0) {
        alias ArrayExpressionTuple = TypeTuple!();
    } else {
        alias ArrayExpressionTuple = Impl!(array.length - 1);

        private template Impl(size_t index) {
            static if (index == 0) {
                alias Impl = TypeTuple!(array[index]);
            } else {
                alias Impl = TypeTuple!(Impl!(index - 1), array[index]);
            }
        }
    }
}

alias Request = HTTPServerRequest;
alias Response = HTTPServerResponse;

template basicPage(string templatePath) {
    void basicPage(Request request, Response response) {
        response.render!(templatePath, request);
    }
}

// TODO: This uses an HTML style redirect.
// This needs replacing with something else.
template redirectPage(string toURL) {
    void redirectPage(Request request, Response response) {
        response.redirect(toURL, 301);
    }
}


shared static this() {
    import vibe.http.router;

    auto settings = new HTTPServerSettings;
    settings.port = 8010;

    auto fileSettings = new HTTPFileServerSettings;
    fileSettings.serverPathPrefix = "/static";

    auto router = new URLRouter;

    enum basicFileList = import("basic_view_list").split("\n");

    enum string[basicFileList.length] staticList =
        basicFileList[0 .. basicFileList.length];

    enum basicFileTuple = ArrayExpressionTuple!staticList;

    foreach(dietFilename; basicFileTuple) {
        router.get(
            "/" ~ dietFilename["basic/".length .. $ - ".dt".length],
            &basicPage!dietFilename
        );
    }

    router
    .get("/", &basicPage!"index.dt")
    //.get("/download", &basicPage!"download.dt")
    //.get("/changelog", &basicPage!"changelog.dt")
    // Old page URLs are 301 redirected to the new URLs.
    .get("/download.html", &redirectPage!"/download")
    .get("/changelog.html", &redirectPage!"/changelog")
    .get("/static/*", serveStaticFiles("../static/", fileSettings))
    ;

    listenHTTP(settings, router);
}
