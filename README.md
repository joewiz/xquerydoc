#xquerydoc v0.1

Parses [xqDoc](http://xqdoc.org/source.html) style comments from XQuery and generates a set of API
level html documentation, implemented in pure XQuery v1.0.

The xquerydoc commandline uses [XML Calabash](http://xmlcalabash.com) (which ships with [Saxon](http://www.saxonica.com)) though 
as xquerydoc is implemented in pure XQuery v1.0 you may also invoke
from most XQuery processors (Saxon, MarkLogic, XQilla, eXist ...).

## Features

* parsing of XQuery 1.0, XQuery 3.0, XQuery Update, XQuery Full Text, and other variants (MarkLogic)
* pure XQuery parsing of xqdoc comments
* generation of simple, customizable documentation
* support for html, markdown, raw output formats
* recursive directory processing
* Invoke from commandline or from within your own XQuery applications

## For the impatient

I. download a zipped installer (from top level directory),
unzip, click and follow GUI installer instructions or run the
following one liner.

```
curl https://github.com/downloads/xquery/xquerydoc/xquerydoc-0.1.jar | sh
```

II. change directory to your applications directory which contains xquery

III. invoke xquerydoc to generate api docs ```xquerydoc```


## Dependencies

To run the commandline version you will need Java 1.5 or higher installed

xquerydoc ships with Norman Walsh's [XML Calabash](http://xmlcalabash.com/), an XProc processor
implemented in Java and runs xquerydoc via xproc xquerydoc step.

Note that Java and XProc processor is not required as you could always run
xquerydoc directly from XQuery itself (see below).


## Installation

### Windows

windows support coming soon!

### Mac/Unix/Linux

Download the xquerydoc installer from https://github.com/xquery/xquerydoc/downloads

Double click the installation package or run 

```bash
java -jar xquerydoc-0.1.jar
```

which will start a step by step graphical installation.

Alternatively you could always clone a copy from github

https://github.com/xquery/xquerydoc


## Usage

### Commandline

The *xquerydoc* script can be invoked from the commandline. To get
started using xquerydoc just execute it with no options in a directory
containing XQuery. 

```bash
xquerydoc
```

xquerydoc will recursively search through for .xq, .xqy, .xqm and .xql
files and will generate html documentation placing the results in a default directory
named *xqdocs*. Your XQuery most follow xqDoc [coding conventions](https://github.com/xquery/xquerydoc/wiki/xqDoc-comment-style-example).

Note many people try to run xquerydoc on xquerydoc ... which is good
but realise that there are some _HUGE_ parser files written in xquery
which will take a long time to generate docs for; suggest you test on
your own xquery source code.

Alternately you may supply xquerydoc with options, to specify the
directory containing XQuery, where you want to output documentation as
well as format of documentation.

```bash
xquerydoc -x xquery dir -o output dir -f format
```

There are four supported formats;

* *html* - outputs xquery documentation format
* *xqdoc* - outputs original xqdoc xml
* *markdown* - outputs markdown format
* *raw* - outputs direct from parser, though you could opt to [download xqueryparser.xq](https://github.com/jpcs/xqueryparser.xq)

we soon hope to support other formats (like xslfo, text, docbook, etc...).

### Invoking xquerydoc from XQuery

As xquerydoc is itself written in pure XQuery v1.0 you may invoke it
directly from xquery. You will find the xquerydoc modules under *src/xquery*.

The following example illustrates how to do this, using saxon XQuery
processor.

####XQuery v1.0 Example (Saxon)
```xquery
xquery version "1.0" encoding "UTF-8";

import module namespace xqdoc="http://github.com/xquery/xquerydoc" at "src/xquery/xquerydoc.xq";

xqp:parse-XQuery(fn:collection('/some/xquery/?select=file.xqy;unparsed=yes')) 

```

Note that we are using the SAXON convention with fn:collection to
bring in an unparsed xquery file.

This function invoke will emit xqdoc markup (akin to
[xqueryx](http://www.w3.org/TR/xqueryx/)), like the following listing. 

```xml
<doc:xqdoc xmlns:doc="http://www.xqdoc.org/1.0">
  <doc:control>
    <!--Generated by xquerydoc: http://github.com/xquery/xquerydoc-->
    <doc:date/>
    <doc:version>N/A
    </doc:version>
  </doc:control>
  <doc:module type="main">
    <doc:uri/>
    <doc:comment>
      <doc:description>   This main module controls the
      presentation of the home page for  xqDoc.  The home page
      will list all of the library and main modules  contained in
      the 'xqDoc' collection.  The mainline function invokes only
      the  method to generate the HTML for the xqDoc home page.
      A parameter of type   xs:boolean is passed to indicate
      whether links on the page should be constructed   to static
      HTML pages (for off-line viewing) or to XQuery scripts for
dynamic  real-time viewing. 
      </doc:description>
      <doc:author> Darin McBeath
      </doc:author>
      <doc:since> June 9, 2006
      </doc:since>
      <doc:version> 1.3
      </doc:version>
    </doc:comment>
  </doc:module>
  <doc:variables/>
  <doc:functions/>
</doc:xqdoc>
```

It is  relatively easy to take this XML and style it using
provided XSLT stylesheets provided for under *src/lib*. 

### Integration

Read more about how to integrate xquerydoc using [xquery](https://github.com/xquery/xquerydoc/wiki/Invoke-xquerydoc-from-XQuery) or [XProc](https://github.com/xquery/xquerydoc/wiki/Invoke-xquerydoc-from-XProc).

## API Docs

Yup we eat our own dog chow, view API docs here.

* html format docs (NOTE-rearranging docs)
* [markdown format docs](https://github.com/xquery/xquerydoc/tree/master/xqdoc)

Note that we do not include documentation for the parser xquery files
as they are frankly *HUGE*.

##Credit, Acknowledgements

xquerydoc created by Jim Fuller, John Snelson

Thanks to [Darin McBeath](http://xqdoc.org/history.html) for creating
the original xqDoc, which xquerydoc borrows heavily. xqDoc is released under the
Apache License, Version 2.0

The [XQuery parser](https://github.com/jpcs/xqueryparser.xq) itself is now a
separate library under Apache License, Version 2.

XQuery parsers were generated from EBNF using Gunther Rademacher's
excellent http://www.bottlecaps.de/rex/

Norman Walsh's xproc processor XML Calabash is
[available](http://xmlcalabash.org) under either the GPLv2 or Sun's CDDL license 

Michael Kay's [Saxon](http://www.saxonica.com) XQuery and XSLT 2.0
Processor is released under the Mozilla Public License

[Prettify](http://code.google.com/p/google-code-prettify/) (used by
api doc and testsuite)  is released under Apache License, Version 2.0

XQuery prettify 'brush' was provided by Patrick Wied (as part of a MarkLogic
bounty contest ;) ) and can be obtained [here](http://www.patrick-wied.at/static/xquery/prettify/) 


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

##FAQ

*How do I output xqdoc markup from commandline ?*

To see the original underlying xqdoc output from the commandline,
invoke the following command, setting the -f switch to xqdoc.

```bash
xquerydoc -x /some/directory/with/xquery/ -o /desired/output -f xqdoc
```

*How do I output raw parser output from commandline ?*

The output from the parser can be generated using the raw format

```bash
xquerydoc -x /some/directory/with/xquery/ -o /desired/output -f raw
```

*Why a pure XQuery v1.0 implementation ?*

This means you can generate api level documentation using just XQuery
! Need we say more ?

*Why use XML Calabash XProc and Java ?*

As we are applying an XQuery process and an XSLT process on a set of
xquery documents it seemed like a good match for the commandline
invokation. You can of course use the XQuery v1.0 libraries without
XProc but you will need to apply XSLT stylesheets using your own
processors capabilities.

Using XProc means we use Java, which has good cross platform
characteristics effectively requiring us to maintain a single version
of the commandline.

*xquerydoc does not seem to parse correctly !*

We are very interested in parsing as correctly as possible so please
submit issue to https://github.com/xquery/xquerydoc/issues

*Doesn't work!*

Please make an issue submission here

https://github.com/xquery/xquerydoc/issues

##More Info

https://github.com/xquery/xquerydoc



