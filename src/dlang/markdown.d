module dlang.markdown;

import vibe.textfilter.markdown;
import vibe.core.file;

string compileMarkdownFile(string filename) {
    return filterMarkdown(
        readFileUTF8(filename),
        MarkdownFlags.backtickCodeBlocks
    );
}
