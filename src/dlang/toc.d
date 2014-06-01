module dlang.toc;

/**
 * This module defines table of contents functionality for use in diet templates.
 *
 * A table of contents objects can be loaded in a base template with some diet code.
 *
 * - import dlang.toc;
 * - TableOfContents toc;
 *
 * Then the entries can be added with heading being produced at the same time.
 *
 * |!= h2(toc, "h2-anchor", "Level 2 Heading Title")
 * ...
 * |!= h3(toc, "h3-anchor", "Level 3 Heading Title")
 *
 * Functions for headings 1 to 6 are defined.
 *
 * Then later, the table of contents can be printed out.
 *
 * |!= toc.write("Table of Contents")
 */

import std.array;
import std.string;

import vibe.textfilter.html;

private enum HeadingLevel : ubyte {
    h1 = 1,
    h2,
    h3,
    h4,
    h5,
    h6
}

private struct HeadingEntry {
    string _anchor;
    string _title;
    HeadingLevel _level;

    @safe pure nothrow
    this(HeadingLevel level, string anchor, string title) {
        _level = level;
        _anchor = anchor;
        _title = title;
    }
}

/**
 * A table of contents object for writing headings to.
 *
 * The table of contents can be written after adding headings
 * with .write("My Title Here")
 */
struct TableOfContents {
    private HeadingEntry[] entries;

    /**
     * Produce the table of contents as a string.
     *
     * Params:
     *     heading = A heading to use in the output.
     *
     * Returns:
     *     The table of contents as HTML.
     */
    string write(string heading) const {
        auto result = appender!string();

        result.put(`<div id="toc"><header>`);
        filterHTMLEscape(result, heading);
        result.put(`</header>`);

        byte zeroLevel = 0;
        byte headingLevel = 0;

        if (entries.length > 0) {
            zeroLevel = cast(byte) (entries[0]._level - 1);
            headingLevel = cast(byte) (zeroLevel);
        }

        foreach(index, ref entry; entries) {
            byte diff = cast(byte) (entry._level - headingLevel);

            if (diff > 0) {
                // Open as many levels as we bump up.
                foreach(i; 0 .. diff) {
                    result.put(`<ul><li>`);
                }
            } else if (diff < 0) {
                // Close as many levels as we move down.
                foreach(i; 0 .. -diff) {
                    result.put(`</li></ul>`);
                }

                result.put(`<li>`);
            } else if (index > 0) {
                result.put(`</li><li>`);
            }

            // Write the link out.
            result.put(`<a href="#`);
            filterHTMLEscape(result, entry._anchor);
            result.put(`">`);
            filterHTMLEscape(result, entry._title);
            result.put(`</a>`);

            // Set the level to the current one.
            headingLevel = cast(byte) entry._level;
        }

        // Close any lists left open now, by using the last
        // set tree depth.
        foreach(index; 0 .. headingLevel - zeroLevel) {
            result.put(`</li></ul>`);
        }

        result.put(`</div>`);

        return result.data;
    }
}

private string writeHeading(ref TableOfContents toc, HeadingEntry entry) {
    toc.entries ~= entry;

    auto result = appender!string();

    return `<h%d id="%s">%s <a class="toc-link" href="#%s">&para;</a></h1>`
    .format(
        cast(ubyte) entry._level,
        htmlEscape(entry._anchor),
        htmlEscape(entry._title),
        htmlEscape(entry._anchor)
    );
}

/**
 * Produce a heading as HTML, and add it to the table of contents.
 *
 * Params:
 *     toc = The table of contents to write to.
 *     anchor = An anchor ID to use for the heading.
 *     title = A title to use for the heading.
 *
 * Returns:
 *     The HTML representation of the heading.
 */
string h1(ref TableOfContents toc, string anchor, string title) {
    return writeHeading(toc, HeadingEntry(HeadingLevel.h1, anchor, title));
}

/// ditto
string h2(ref TableOfContents toc, string anchor, string title) {
    return writeHeading(toc, HeadingEntry(HeadingLevel.h2, anchor, title));
}

/// ditto
string h3(ref TableOfContents toc, string anchor, string title) {
    return writeHeading(toc, HeadingEntry(HeadingLevel.h3, anchor, title));
}

/// ditto
string h4(ref TableOfContents toc, string anchor, string title) {
    return writeHeading(toc, HeadingEntry(HeadingLevel.h4, anchor, title));
}

/// ditto
string h5(ref TableOfContents toc, string anchor, string title) {
    return writeHeading(toc, HeadingEntry(HeadingLevel.h5, anchor, title));
}

/// ditto
string h6(ref TableOfContents toc, string anchor, string title) {
    return writeHeading(toc, HeadingEntry(HeadingLevel.h6, anchor, title));
}
