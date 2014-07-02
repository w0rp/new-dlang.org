import std.algorithm;
import std.range;
import std.array;
import std.string;
import std.typetuple;

import vibe.http.server;
import vibe.http.fileserver;
import vibe.core.file;
import vibe.appmain;

import dlang.markdown;

alias Request = HTTPServerRequest;
alias Response = HTTPServerResponse;

enum markdownDir = "../markdown";
enum basicDir = "../markdown/basic";

void basicPage(Request request, Response response) {
    import std.path;
    import std.file;
    import std.stdio;
    import dlang.toc;

    if (!request.path.find("..").empty) {
        // Factor out paths going up a directory, for security.
        return;
    }

    if (request.path.endsWith(".sidebar")
    || request.path == "/index") {
        // Remove paths for special filenames.
        return;
    }

    string markdownFilename;
    string sidebarFilename;

    if (request.path == "/") {
        markdownFilename = "../markdown/basic/index.md";
        sidebarFilename = "../markdown/basic/index.sidebar.md";
    } else {
        markdownFilename = buildPath(basicDir, request.path[1 .. $] ~ ".md");
        sidebarFilename = buildPath(
            basicDir,
            request.path[1 .. $] ~ ".sidebar.md"
        );
    }

    if (!exists(markdownFilename) || !isFile(markdownFilename)) {
        return;
    }

    string title = "D Programming Language";
    string mainContent = compileMarkdownFile(markdownFilename);
    string sidebarContent;

    if (exists(sidebarFilename) && isFile(sidebarFilename)) {
        sidebarContent = readFileUTF8(sidebarFilename);
    } else {
        TableOfContents toc = tocFromHTML(mainContent);

        if (toc.entries.length > 0 && toc.entries[0].level == HeadingLevel.h1) {
            title = toc.entries[0].title ~  " - " ~ title;
            toc.removeFirst();
        }

        sidebarContent = toc.write("On This Page");
    }

    response.render!(
        "basic_page.dt",
        title,
        mainContent,
        sidebarContent,
    );
}

// TODO: This uses an HTML style redirect.
// This needs replacing with something else.
auto redirectPage(string toURL) {
    return (Request request, Response response) {
        response.redirect(toURL, 301);
    };
}

shared static this() {
    import vibe.http.router;

    auto settings = new HTTPServerSettings;
    settings.port = 8010;

    auto fileSettings = new HTTPFileServerSettings;
    fileSettings.serverPathPrefix = "/static";

    auto router = new URLRouter;

    router
    // Old page URLs are 301 redirected to the new URLs.
    .get("/download.html", redirectPage("/download"))
    .get("/changelog.html", redirectPage("/changelog"))
    .get("/static/*", serveStaticFiles("../static/", fileSettings))
    // Handle everything else with basic Markdown files.
    .get("/*", &basicPage)
    ;

    listenHTTP(settings, router);
}
