xquery version "1.0" encoding "UTF-8";

import module namespace xqdoc="http://github.com/xquery/xquerydoc"
  at "../xquery/xquerydoc.xq";

declare variable $distpath as xs:string external;
declare variable $expected as xs:string external;
declare variable $example  as xs:string external;

let $expectedpath := fn:concat('file://', $distpath, $expected)
let $expect       := fn:doc($expectedpath)
let $xquerypath   := fn:concat('file://', $distpath, fn:replace($example, '\?select=', '/'))
let $xquery       := fn:unparsed-text($xquerypath)
let $actual       := xqdoc:parse($xquery, 'test')

return
  <tests expected="{$expectedpath}" example="{$example}">
    <test desc="generate xqdoc">
      <expected>{$expect}</expected>
      <actual>{$actual}</actual>
    </test>
  </tests>
