module dlang.docmain;

import std.algorithm;
import std.range;
import std.array;
import std.getopt;
import std.process;
import std.stdio;
import std.path;
import std.file;
import std.regex;

import vibe.core.log;

import ddox.main;

void buildFileList(string rootDir) {
    enum runtimeRE = ctRegex!`unittest\.d$|gcstub|aaA.d$|cpuid.d$`;
    enum phobosRE = ctRegex!`unittest\.d$|format\.d$|linux|osx`;

    File file = File("files.txt", "w");

    chain(
        dirEntries(buildPath(rootDir, "..", "druntime", "src"), "*.d", SpanMode.depth)
        .filter!(x => !x.name.matchFirst(runtimeRE)),
        dirEntries(buildPath(rootDir, "..", "phobos"), "*.d", SpanMode.depth)
        .filter!(x => !x.name.matchFirst(phobosRE)),
    )
    .map!(x => x.name.absolutePath.buildNormalizedPath)
    .joiner("\n")
    .copy(file.lockingTextWriter);
}

void buildDocJSON() {
    auto dmd = spawnProcess([
        "dmd",
        "-c",
        "-o-",
        "-version=StdDdoc",
        "-Dfdummy.html",
        "-Xfdocs.json",
        "@files.txt",
    ]);

    if (wait(dmd) != 0) {
        throw new Error("Compiling JSON failed!");
    }
}

int dlangDocMain(string rootDir, string[] args) {
    buildFileList(rootDir);
    buildDocJSON();

    string git_target = "master";
    getopt(args, std.getopt.config.passThrough,
        "git-target", &git_target);
    environment["GIT_TARGET"] = git_target;
    setLogFormat(FileLogger.Format.plain);

    auto filterResult = cmdFilterDocs([
        args[0],
        "filter",
        "docs.json",
        "--min-protection=Protected",
        "--only-documented",
        "--ex=gc.",
        "--ex=rt.",
        "--ex=core.internal.",
        // C modules will be hidden and otherwise documented.
        "--ex=core.stdc.",
        "--ex=core.sys.posix.",
        "--ex=core.sys.linux.",
        "--ex=core.sys.freebsd.",
        "--ex=core.sys.windows.windows",
        "--ex=core.sys.osx.",
        "--ex=std.internal.",
        "--ex=std.c.",
    ]);

    if (filterResult) {
        throw new Error("Failed to filter the docs!");
    }

    return 0;
}
