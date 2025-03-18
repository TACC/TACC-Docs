# Markdown Extensions

You can extend the functionality of your MkDocs site.

_MkDocs offers a [generic guide to extending a MkDocs site](https://www.mkdocs.org/user-guide/configuration/#markdown_extensions){target="_blank"}._

[TOC]

## Configuration

### Minimum

Users of TACC MkDocs Theme should enable these extensions:

```yaml
markdown_extensions:
  - toc:
      permalink: "" # i.e. `true` but without "¶"
      permalink_class: headerlink fa fa-link
      permalink_title: Link to Heading
```

### Typical

Standard TACC documentation websites with this theme use:

```yaml
markdown_extensions:
  - extra
  - admonition
  - toc:
      permalink: "" # i.e. `true` but without "¶"
      permalink_class: headerlink fa fa-link
      permalink_title: Link to Heading
  - pymdownx.blocks.admonition
  - pymdownx.blocks.details
  - pymdownx.blocks.html
  - pymdownx.blocks.tab
  - pymdownx.superfences
  - pymdownx.inlinehilite
  - pymdownx.saneheaders
```

## Demos

The TACC MkDocs Theme enhances the UI of these extensions:

<style id="demo-toc-css">
    /* to prevent column header from wrapping ONLY in this table */
    .demo-toc th { white-space: nowrap; }
    /* to prevent tables from stretching to fill row height */
    .demo-toc { align-items: start; }
    /* to prevent tables from overlapping each other */
    .demo-toc.grid > table { width: fit-content; }
</style>

<div class="grid demo-toc" markdown="block">

| from [Python-Markdown](https://python-markdown.github.io/extensions/) | Reference |
| - | - |
| [Abbreviations](#abbreviations) | [extra: `abbr`](https://python-markdown.github.io/extensions/abbreviations/) |
| [HTML Attributes](#html-attributes) | [extra: `attr_list`](https://python-markdown.github.io/extensions/attr_list/) |
| [Definition Lists](#definition-lists) | [extra: `def_list`](https://python-markdown.github.io/extensions/definition_lists/) |
| [Code Blocks](#fenced-code-blocks) | [extra: `fenced_code`](https://python-markdown.github.io/extensions/fenced_code_blocks/) |
| [Footnotes](#footnotes) | [extra: `footnotes`](https://python-markdown.github.io/extensions/footnotes/) |
| [Markdown in HTML](#markdown-in-html) | [extra: `md_in_html`](https://python-markdown.github.io/extensions/md_in_html/) |
| [Tables](#tables) | [extra: `tables`](https://python-markdown.github.io/extensions/tables/) |
| [Alerts & Notes](#admonitions) | [`admonition`](https://python-markdown.github.io/extensions/admonition/) |
| [Table of Contents](#toc) | [`toc`](https://python-markdown.github.io/extensions/toc/) |

| of [PyMdown Extensions](https://facelessuser.github.io/pymdown-extensions/#extensions) | Reference |
| - | - |
| [Alerts & Notes](#pymdownx-admonition) | [`blocks.admonition`](https://facelessuser.github.io/pymdown-extensions/extensions/blocks/plugins/admonition/) |
| [Collapsible Content](#pymdownx-details) | [`blocks.details`](https://facelessuser.github.io/pymdown-extensions/extensions/blocks/plugins/details/) |
| [HTML (via Blocks)](#pymdownx-html) | [`blocks.html`](https://facelessuser.github.io/pymdown-extensions/extensions/blocks/plugins/html/) |
| [Tabs (via Blocks)](#pymdownx-tab) | [`blocks.tab`](https://facelessuser.github.io/pymdown-extensions/extensions/blocks/plugins/tab/) |
| [Tabbed Content](#pymdownx-tabbed) [⚠️](#pymdownx-tabbed-warning) | [`tabbed`](https://facelessuser.github.io/pymdown-extensions/extensions/tabbed/) |

</div>

<style id="usage-examples-css">
    /* to make grid use rows on narrow screens */
    .grid { grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); }

    /* to reduce space between blocks in grid */
    .grid { gap: 20px; }
    .grid > :is(
        pre,
        .admonition,
        .tabbed-set
    ) { margin-block: 0; }
</style>

### from [Python-Markdown](https://python-markdown.github.io/extensions/)

#### Abbreviation

/// note | Syntax

```markdown
The HTML and CSS specifications are maintained by the W3C.

*[HTML]: Hypertext Markup Language
*[CSS]: Cascading Style Sheets
*[W3C]: World Wide Web Consortium
```

///
/// hint | Result

The HTML and CSS specifications are maintained by the W3C.

*[HTML]: Hypertext Markup Language
*[CSS]: Cascading Style Sheets
*[W3C]: World Wide Web Consortium

///

#### Attribute Lists

/// note | Syntax

```markdown
This is a paragraph with custom class and ID. (Inspect element to see.)
{: .class-name #custom-id }
```

///
/// hint | Result

This is a paragraph with custom class and ID. (Inspect element to see.)
{: .class-name #custom-id }

///

#### Definition Lists

/// note | Syntax

```markdown
Term
: Definition of the term
: Another definition

HTML
: Hypertext Markup Language
: The standard markup language for web pages
```

///
/// hint | Result

Term
: Definition of the term
: Another definition

HTML
: Hypertext Markup Language
: The standard markup language for web pages

///

#### Fenced Code Blocks

/// note | Syntax

````markdown
```shell
echo "Hello, World!" > /tmp/output.txt
```
````

///
/// hint | Result

```shell
echo "Hello, World!" > /tmp/output.txt
```

///

#### Footnotes

<div class="grid" markdown="block">

/// note | Syntax

```markdown
A sentence with a footnote.[^1]

[^1]: The footnote content.
```

///
/// hint | Result

A sentence with a footnote.[^1]

[^1]: The footnote content.

///

</div>

#### Markdown in HTML

//// note | Syntax

```markdown
<div markdown="block">

I am in a `<div>` with markdown enabled.

</div>
```

////
//// hint | Result

<div markdown="block">

I am in a `<div>` with markdown enabled.

</div>

////

#### Tables

<div class="grid" markdown="block">

/// note | Syntax

```markdown
| Header 1 | Header 2 |
|----------|----------|
| Cell 1   | Cell 2   |
| Cell 3   | Cell 4   |
```

///
/// hint | Result

| Header 1 | Header 2 |
|----------|----------|
| Cell 1   | Cell 2   |
| Cell 3   | Cell 4   |

///

</div>

#### Admonitions

/// note | Syntax

```markdown
!!! note "Custom Title"
    This is a note with a custom title.

!!! warning
    You can include blocks in admonitions, e.g.

    ```shell
    echo "Hello from an admonition!"
    ```
```

///
/// hint | Result

!!! note "Custom Title"
    This is a note with a custom title.

!!! tip
    You can include blocks in admonitions, e.g.

    ```shell
    echo "Hello from an admonition!"
    ```

///

#### Table of Contents { #toc }

/// html | div.grid

//// note | Syntax

```markdown
[TOC]
```

////
//// hint | Result
(on this page) (truncated)

<style id="toc-css">
    /* to hide deeply nested TOC items */
    .toc ul ul ul ul { display: none; }
</style>

[TOC]

////

///

### of [PyMdown Extensions](https://facelessuser.github.io/pymdown-extensions/#extensions)

#### Admonition { #pymdownx-admonition }

/// note | Syntax

//// details | Simple Syntax
    open: true
///// html | div.grid

```markdown
/// note | Custom Title
This is a message with a custom title.
///
```

```markdown
/// tip
You can include blocks in admonitions, e.g.

````shell
echo "Hello from an admonition!"
````
///
```

/////
////
//// details | Explicit Syntax
///// html | div.grid

```markdown
/// admonition | Custom Title
    type: note

This is a message with a custom title.
///
```

```markdown
/// admonition
    type: tip

You can include blocks in admonitions, e.g.

````shell
echo "Hello from an admonition!"
````
///
```

/////
////

///
/// hint | Result

<div class="grid" markdown="block">

///// note | Custom Title
This is a note with a custom title.
/////
///// tip
You can include blocks in admonitions, e.g.

```bash
echo "Hello from an admonition!"
```
/////

</div>

///

#### Details/Summary { #pymdownx-details }

<div class="grid" markdown="block">

/// note | Syntax

```markdown
??? "Click to expand"
    This content is collapsible.
```

///
/// hint | Result

??? "Click to expand"
    This content is collapsible.

///

</div>

#### HTML { #pymdownx-html }

<div class="grid" markdown="block">

/// note | Syntax

```markdown
/// html | div
I am in a `<div>` with markdown enabled.
///
```

///
/// hint | Result

//// html | div
I am in a `<div>` with markdown enabled.
////

///

</div>

#### Tab { #pymdownx-tab }

/// note | Syntax

```markdown
/// tab | Tab 1
Content for first tab
///

/// tab | Tab 2
Content for second tab
///
```

///
/// hint | Result

//// tab | Tab 1
Content for first tab
////

//// tab | Tab 2
Content for second tab
////

///

#### Tabbed { #pymdownx-tabbed }

/// caution | Deprecated
    attrs: { id: pymdownx-tabbed-warning }
This extension is deprecated. Try the [`blocks.tab`](#pymdownx-tab) extension instead.
///

/// note | Syntax

```markdown
=== "Tab 1"
    Content for first tab

=== "Tab 2"
    Content for second tab
```

///

<div class="grid" markdown="block">

/// hint | Result
(if supported)

//// tab | Tab 1
Content for first tab
////

//// tab | Tab 2
Content for second tab
////

///
/// error | Result
(if disabled)

=== "Tab 1"
    Content for first tab

=== "Tab 2"
    Content for second tab

///

</div>
