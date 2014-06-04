/**
 * This program finds diet files in our 'basic'
 * view directory and writes them all to a plaintext file.
 */

import std.file;
import std.algorithm;
import std.range;
import std.stdio;

void main(string[] argv) {
    if (!exists("compile_time_blobs")) {
        mkdir("compile_time_blobs");
    }

    enum basicDir = "views/basic";
    auto basicViewFile = File("compile_time_blobs/basic_view_list", "w");

    dirEntries("views/basic", "*.dt", SpanMode.breadth, false)
    .map!(x => x.name["views/".length .. $])
    .joiner("\n")
    .copy(basicViewFile.lockingTextWriter);
}
