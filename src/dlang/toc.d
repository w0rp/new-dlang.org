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
import std.regex;

import vibe.textfilter.html;

enum HeadingLevel : ubyte {
    h1 = 1,
    h2,
    h3,
    h4,
    h5,
    h6
}

struct HeadingEntry {
    string anchor;
    string title;
    HeadingLevel level;

    @safe pure nothrow
    this(HeadingLevel level, string anchor, string title) {
        this.level = level;
        this.anchor = anchor;
        this.title = title;
    }
}

/**
 * A table of contents object for writing headings to.
 *
 * The table of contents can be written after adding headings
 * with .write("My Title Here")
 */
struct TableOfContents {
    private HeadingEntry[] _entries;

    @safe pure nothrow
    @property
    const(HeadingEntry)[] entries() const {
        return _entries;
    }

    @safe pure nothrow
    void removeFirst() {
        _entries = _entries[1 .. $];
    }

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
        if (_entries.length == 0) {
            return "";
        }

        auto result = appender!string();

        result.put(`<div id="toc"><header>`);
        filterHTMLEscape(result, heading);
        result.put(`</header>`);

        byte zeroLevel = 0;
        byte headingLevel = 0;

        if (entries.length > 0) {
            zeroLevel = cast(byte) (entries[0].level - 1);
            headingLevel = cast(byte) (zeroLevel);
        }

        foreach(index, ref entry; entries) {
            byte diff = cast(byte) (entry.level - headingLevel);

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
            filterHTMLEscape(result, entry.anchor);
            result.put(`">`);
            filterHTMLEscape(result, entry.title);
            result.put(`</a>`);

            // Set the level to the current one.
            headingLevel = cast(byte) entry.level;
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
    toc._entries ~= entry;

    auto result = appender!string();

    return `<h%d id="%s">%s <a class="toc-link" href="#%s">&para;</a></h1>`
    .format(
        cast(ubyte) entry.level,
        htmlEscape(entry.anchor),
        htmlEscape(entry.title),
        htmlEscape(entry.anchor)
    );
}

public void addHeading(ref TableOfContents toc, HeadingEntry entry) {
    toc._entries ~= entry;
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


TableOfContents tocFromHTML(string html) {
    import arsd.dom;

    TableOfContents toc;
    HeadingLevel level;

    auto document = new Document();
    document.parseGarbage("<div>" ~ html ~ "</div>");

    elementLoop: foreach(element; document.root.tree()) {
        switch (element.tagName) {
        case "h1":
            level = HeadingLevel.h1;
        break;
        case "h2":
            level = HeadingLevel.h2;
        break;
        case "h3":
            level = HeadingLevel.h3;
        break;
        case "h4":
            level = HeadingLevel.h4;
        break;
        case "h5":
            level = HeadingLevel.h5;
        break;
        case "h6":
            level = HeadingLevel.h6;
        break;
        default:
            continue elementLoop;
        }

        string id = element.getAttribute("id");
        string title = element.innerText();

        if (id.length == 0) {
            // Get the ID automatically from the title.
            id = title.toLower().strip().replace(" ", "-");
        }

        toc.addHeading(HeadingEntry(level, id, title));
    }

    return toc;
}
