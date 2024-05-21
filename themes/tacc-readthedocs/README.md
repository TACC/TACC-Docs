# ReadTheDocs Theme: TACC Overrides

These files help fix parts of this theme that conflict with TACC design.

Files here should come **only** from the [relevant MkDocs theme][mkd-themes].

## Rules

1. Theme files should[^1] be of the version we have installed.
2. Changes must[^2] start and end with comments ` TACC: ` and ` /TACC `.
3. Changes should be minimal[^3].

[^1]: Edge use cases for other versions are possible but not expected.
[^2]: Yes, a diff with the original shows what changed; but highlighting changes reminds editors these files are clones.
[^3]: If you have any doubt, check with a major active maintainer of the relevant code.

[mkd-themes]: https://github.com/mkdocs/mkdocs/tree/1.4.2/mkdocs/themes/
