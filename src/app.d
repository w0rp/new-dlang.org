import dlang.servermain : dlangServerMain;

int main(string args[]) {
    // exe is in root/bin/new-dlang.org
    import std.path;
    immutable root = buildPath(args[0].dirName, "..");

    version(documentation) {
        import dlang.docmain : dlangDocMain;

        return dlangDocMain(root, args);
    } else {
        import dlang.servermain : dlangServerMain;

        return dlangServerMain(root, args);
    }
}
