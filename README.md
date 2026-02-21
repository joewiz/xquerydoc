# xquerydoc

Parses [xqDoc](http://xqdoc.org/source.html) style comments from XQuery and generates a set of API
level HTML documentation, implemented in pure XQuery.

The xquerydoc commandline uses [XML Calabash](http://xmlcalabash.com) (an XProc processor) though
as xquerydoc is implemented in pure XQuery you may also invoke it
from most XQuery processors (Saxon, eXist, XQilla, ...).

## Features

* parsing of XQuery 1.0, XQuery 3.0, XQuery 3.1, XQuery Update, XQuery Full Text
* pure XQuery parsing of xqDoc comments
* generation of simple, customizable documentation
* support for html, markdown, raw output formats
* recursive directory processing
* invoke from commandline or from within your own XQuery applications

## Dependencies

### Running the test suite

- **Java 11+**
- **Maven 3.x** — downloads Saxon HE 12.4 automatically:

```bash
mvn dependency:copy-dependencies -DoutputDirectory=target/dependency
```

Then run the tests:

```bash
bash bin/run-saxon-tests.sh
```

### Using the commandline tool (`xquerydoc` script)

- **Java 11+**
- **[XML Calabash](http://xmlcalabash.com/)** (XProc 1.0 processor) — must be on your `PATH`
  as `calabash`, or set `CALABASH_HOME` to its install directory.
  Calabash ships with Saxon; version 1.x (Saxon 9.x) is required for the XProc pipeline.

Install Calabash via Homebrew on macOS:

```bash
brew install calabash
```

## Installation

Clone the repository:

```bash
git clone https://github.com/xquery/xquerydoc.git
cd xquerydoc
```

Download Saxon HE for testing:

```bash
mvn dependency:copy-dependencies -DoutputDirectory=target/dependency
```

## Usage

### Commandline

The `xquerydoc` script can be invoked from the commandline. To get
started, execute it with no options in a directory containing XQuery.

```bash
xquerydoc
```

xquerydoc will recursively search for `.xq`, `.xqy`, `.xqm` and `.xql`
files and generate HTML documentation in a directory named `xqdocs`.
Your XQuery should follow xqDoc [coding conventions](https://github.com/xquery/xquerydoc/wiki/xqDoc-comment-style-example).

Supply options to specify the XQuery directory, output location, and format:

```bash
xquerydoc -x <xquery-dir> -o <output-dir> -f <format>
```

Supported formats:

* `html` — HTML documentation (default)
* `xqdoc` — raw xqDoc XML
* `markdown` — Markdown format
* `raw` — direct parser output

### Invoking xquerydoc from XQuery

As xquerydoc is itself written in pure XQuery you may invoke it
directly. You will find the xquerydoc modules under `src/xquery`.

```xquery
xquery version "1.0" encoding "UTF-8";

import module namespace xqdoc="http://github.com/xquery/xquerydoc"
  at "src/xquery/xquerydoc.xq";

xqdoc:parse(fn:unparsed-text('/some/xquery/file.xqy'))
```

This emits xqDoc XML markup. It is easy to style this using the
XSLT stylesheets provided under `src/lib`.

### Integration

Read more about how to integrate xquerydoc using [XQuery](https://github.com/xquery/xquerydoc/wiki/Invoke-xquerydoc-from-XQuery) or [XProc](https://github.com/xquery/xquerydoc/wiki/Invoke-xquerydoc-from-XProc).

## CI

Tests run automatically on GitHub Actions on every push to `master` and on pull requests.
The workflow downloads Saxon HE via Maven and runs `bin/run-saxon-tests.sh`.

## API Docs

* [markdown format docs](https://github.com/xquery/xquerydoc/tree/master/xqdoc)

## Credit & Acknowledgements

xquerydoc created by Jim Fuller, John Snelson

Thanks to [Darin McBeath](http://xqdoc.org/history.html) for creating
the original xqDoc, which xquerydoc borrows heavily from. xqDoc is released under the
Apache License, Version 2.0.

The [XQuery parser](https://github.com/jpcs/xqueryparser.xq) is a
separate library under Apache License, Version 2.0.

XQuery parsers were generated from EBNF using Gunther Rademacher's
excellent http://www.bottlecaps.de/rex/

Norman Walsh's XProc processor XML Calabash is
[available](http://xmlcalabash.org) under either the GPLv2 or Sun's CDDL license.

Michael Kay's [Saxon](http://www.saxonica.com) XQuery and XSLT Processor
is released under the Mozilla Public License.

[Prettify](http://code.google.com/p/google-code-prettify/) (used in
HTML output) is released under Apache License, Version 2.0.

XQuery prettify brush provided by Patrick Wied and available [here](http://www.patrick-wied.at/static/xquery/prettify/).

Andy Bunce [apb2006] — Windows batch script and raw format fixes.

## License

xquerydoc is released under Apache License v2.0

Copyright 2011, 2012 Jim Fuller, John Snelson

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## FAQ

*How do I output xqdoc markup from the commandline?*

```bash
xquerydoc -x /some/directory/with/xquery/ -o /desired/output -f xqdoc
```

*How do I output raw parser output from the commandline?*

```bash
xquerydoc -x /some/directory/with/xquery/ -o /desired/output -f raw
```

*Why a pure XQuery implementation?*

This means you can generate API documentation using just XQuery —
no additional tooling required for the parsing step.

*xquerydoc does not seem to parse correctly!*

Please submit an issue at https://github.com/xquery/xquerydoc/issues

## More Info

https://github.com/xquery/xquerydoc
