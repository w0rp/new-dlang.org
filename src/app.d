import vibe.http.server;
import vibe.http.fileserver;
import vibe.appmain;

template basicPage(string templatePath) {
    void basicPage(HTTPServerRequest request, HTTPServerResponse response) {
        response.render!(templatePath, request);
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
    .get("/static/*", serveStaticFiles("../static/", fileSettings))
    ;

    listenHTTP(settings, router);
}
