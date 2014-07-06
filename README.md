# dlang.org Redesign

This is a project for redesigning dlang.org.

## Building

First, you should use dub to build the druntime and phobos documentation.
First, clone druntime and phobos to the same directory you cloned this
repository to, and checkout the stable D dlanguage version for each repository
to match your DMD compiler in each repository. Then you will be able to
build the documentation.

```
dub run --config=documentation
```

If you make changes to the diet templates used for the documentation, remember
to rebuild the documentation and run again to see the results.

```
dub build --force --config=documentation
dub run --config=documentation
```

To run the site itself, use dub again.

```
dub run
```
