xquery version "1.0-ml" encoding "UTF-8";

import module namespace test = "http://www.marklogic.com/test" at "/lib/test.xqy";
import module namespace xqdoc="http://github.com/xquery/xquerydoc" at "/xquery/ml-xquerydoc.xq";

declare variable $distpath as xs:string external;
declare variable $example as xs:string external;
declare variable $expected as xs:string external;
declare variable $t as xs:string external;

let $expect := xdmp:document-get(fn:concat($distpath,$expected))
let $actual  := xqdoc:parse(xdmp:quote(xdmp:document-get(fn:concat($distpath,$example)))) 
  return
    <tests name="simple" t="{$t}" example="{$example}" expected="{$expected}">
    <test name="default.xqy test">
      <expected>{$expect}</expected>
      <actual>{$actual}</actual>
    </test>
    </tests>
