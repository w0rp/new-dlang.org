import dlang.servermain : dlangServerMain;

int main(string args[]) {
    version(documentation) {
        import dlang.docmain : dlangDocMain;

        return dlangDocMain(args);
    } else {
        import dlang.servermain : dlangServerMain;

        return dlangServerMain(args);
    }
}
