# External Libraries

TACC/TACC-Docs uses external libraries with unintutive relationships.

Packages:

- [MkDocs]
  - uses [Python-Markdown]\
    <small>(which is [normally installed as **`markdown`**][python-markdown-install],\
    but [MkDocs installs it as **`Markdown`**][mkdocs-python-markdown-install])</small>
  - _supports_ [**many** Python-Markdown extensions][python-markdown-exts]
  - _enables_ [**some** Python-Markdown extensions][mkdocs-to-python-markdown] by default\
    <small>(TACC-Docs enables some (in [./mkdocs.yml][tacc-docs-mkdocs-config]) via `markdown_extensions`)</small>
  - offers:
    - [MkDocs Theme][mkdocs-mkdocs-theme]\
    <small>(which is the default theme)</small>
    - [ReadTheDocs Theme][mkdocs-rtd-theme]\
    <small>(which is what TACC/TACC-Docs both [uses][tacc-docs-mkdocs-config]—see `theme`—and [extends](./themes/readthedocs))</small>
- [PyMdown-Extensions]\
  <small>(which are extensions for [Python-Markdown])</small>\
  <small>(TACC-Docs enables some (in [./mkdocs.yml][tacc-docs-mkdocs-config]) via `pymdownx.__extname__`)</small>
- [mkdocs-macros]
  - allows [Jinja] syntax
  - allows Python macros

Styles:

- [TACC/Core-Styles]
- [Bootstrap-4]
- [HighlightJS]
- [TUP-CMS]

[MkDocs]: https://www.mkdocs.org/
[mkdocs-to-python-markdown]: https://www.mkdocs.org/user-guide/configuration/#formatting-options
[mkdocs-python-markdown-install]: https://github.com/mkdocs/mkdocs/blob/1.4.2/pyproject.toml#L188
[mkdocs-mkdocs-theme]: https://github.com/mkdocs/mkdocs/tree/1.4.2/mkdocs/themes/mkdocs
[mkdocs-rtd-theme]: https://github.com/mkdocs/mkdocs/tree/1.4.2/mkdocs/themes/readthedocs

[Python-Markdown]: https://github.com/Python-Markdown/markdown/
[python-markdown-install]: https://github.com/Python-Markdown/markdown/#documentation
[python-markdown-exts]: https://python-markdown.github.io/extensions/

[PyMdown-Extensions]: https://facelessuser.github.io/pymdown-extensions
[tacc-docs-mkdocs-config]: ./mkdocs.yml

[mkdocs-macros]: https://mkdocs-macros-plugin.readthedocs.io/

[Jinja]: http://jinja.pocoo.org/docs/2.10/templates/

[TACC/Core-Styles]: https://github.com/TACC/Core-Styles
[Bootstrap-4]: https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.css
[HighlightJS]: https://highlightjs.org/
[TUP-CMS]: https://github.com/TACC/tup-ui/tree/main/apps/tup-cms

[TACC website]: https://tacc.utexas.edu
