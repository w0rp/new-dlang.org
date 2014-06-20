/**
 * This structure implements a range for UTF8 strings which does not
 * do any decoding. Code units are left exactly as they are.
 */
struct UTF8Range {
private:
    string slice;
public:
    ///
    @disable this();

    ///
    @safe pure nothrow
    this(string slice) {
        this.slice = slice;
    }

    ///
    @safe pure nothrow
    UTF8Range save() const {
        return this;
    }

    ///
    @safe pure nothrow
    @property
    bool empty() const {
        return slice.length == 0;
    }

    ///
    @safe pure nothrow
    @property
    char front() const {
        return slice[0];
    }

    ///
    @safe pure nothrow
    void popFront() {
        slice = slice[1 .. $];
    }

    ///
    @safe pure nothrow
    @property
    char back() const {
        return slice[$ - 1];
    }

    ///
    @safe pure nothrow
    void popBack() {
        slice = slice[0 .. $ - 1];
    }

    ///
    @safe pure nothrow
    @property
    size_t length() const {
        return slice.length;
    }

    ///
    @safe pure nothrow
    @property
    char opIndex(size_t index) const {
        return slice[index];
    }
}

/**
 * A convenience function for creating a UTF8Range.
 */
@safe pure nothrow
UTF8Range utf8range(string slice) {
    return UTF8Range(slice);
}
