import vibe.http.server;
import vibe.http.fileserver;
import vibe.appmain;

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

    router
    .get("/", &basicPage!"index.dt")
    // Old page URLs are 301 redirected to the new URLs.
    .get("/download.html", &redirectPage!"/download")
    .get("/download", &basicPage!"download.dt")
    .get("/static/*", serveStaticFiles("../static/", fileSettings))
    ;

    listenHTTP(settings, router);
}
