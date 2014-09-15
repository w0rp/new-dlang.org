module dlang.servermain;

import std.algorithm;
import std.range;
import std.array;
import std.string;
import std.typetuple;

import vibe.http.server;
import vibe.http.fileserver;
import vibe.core.file;
import vibe.vibe : finalizeCommandLineOptions, lowerPrivileges, runEventLoop;
import vibe.http.router;

import dlang.markdown;

alias Request = HTTPServerRequest;
alias Response = HTTPServerResponse;

enum markdownDir = "../markdown";
enum basicDir = "../markdown/basic";

/**
 * Handle basic pages by rendering Markdown content.
 */
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

auto redirectPage(string toURL) {
    return (Request request, Response response) {
        response.redirect(toURL, 301);
    };
}

/**
 * Set up routing on "/library/" for the D library documentation.
 *
 * The HTML for the documentation pages will be served directly without
 * generating HTML files.
 */
void routeDocs(URLRouter router) {
    import std.file : readText;

    import vibe.inet.url;
    import vibe.data.json;

    import ddox.entities;
    import ddox.settings;
    import ddox.htmlserver;
    import ddox.ddox;
    import ddox.jsonparser;

    auto generatorSettings = new GeneratorSettings();

    generatorSettings.siteUrl = URL("/library/");
    generatorSettings.fileNameStyle = MethodStyle.lowerUnderscored;

    auto ddoxSettings = new DdoxSettings();

    Package pack;

    {
        auto text = readText("docs.json");
        pack = parseJsonDocs(parseJson(text));
    }

    registerApiDocs(router, pack, generatorSettings);
}

int dlangServerMain(string rootDir, string args[]) {
    import ddox.ddoc : setDefaultDdocMacroFiles, setOverrideDdocMacroFiles;

    // Set global scope ddoc files to be loaded for documentation pages.
    import std.path : buildPath;

    immutable ddocDir = buildPath(rootDir, "src", "ddoc");
    setDefaultDdocMacroFiles([
        buildPath(ddocDir, "std.ddoc"),
        buildPath(ddocDir, "std-ddox.ddoc"),
    ]);

    setOverrideDdocMacroFiles([
        buildPath(ddocDir, "std-ddox-override.ddoc"),
    ]);

    auto settings = new HTTPServerSettings;
    settings.port = 8010;

    auto fileSettings = new HTTPFileServerSettings;
    fileSettings.serverPathPrefix = "/static";

    auto docFileSettings = new HTTPFileServerSettings;
    docFileSettings.serverPathPrefix = "/library";

    auto router = new URLRouter;

    router
    // Old page URLs are 301 redirected to the new URLs.
    .get("/download.html", redirectPage("/download"))
    .get("/changelog.html", redirectPage("/changelog"))
    // This should stay forever.
    .get("/library/?", redirectPage("/library/index.html"))
    .get("/static/*", serveStaticFiles(buildPath(rootDir, "static/"), fileSettings))
    // Handle everything else with basic Markdown files.
    .get("/*", &basicPage)
    ;

    // Set up routing for library files.
    routeDocs(router);

    listenHTTP(settings, router);

    if (!finalizeCommandLineOptions())
        return 1;

    lowerPrivileges();
    runEventLoop();

    return 0;
}
