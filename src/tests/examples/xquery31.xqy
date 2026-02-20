xquery version "3.1";

(:~
 : Module demonstrating XQuery 3.1 features.
 : @version 1.0
 :)
module namespace demo="http://example.com/xquery31-demo";

(:~
 : Builds a map from a sequence of key-value pairs.
 : @param $keys sequence of string keys
 : @param $values sequence of corresponding values
 : @return a map from keys to values
 :)
declare function demo:build-map($keys as xs:string*, $values as item()*) as map(xs:string, item()) {
  map:merge(
    for-each-pair($keys, $values, function($k, $v) { map { $k: $v } })
  )
};

(:~
 : Returns the squares of a sequence of integers as an array.
 : @param $nums input integers
 : @return array of squared values
 :)
declare function demo:squares($nums as xs:integer*) as array(xs:integer) {
  array { $nums ! (. * .) }
};

(:~
 : Demonstrates the arrow operator for readability.
 : @param $s input string
 : @return uppercased, normalized string
 :)
declare function demo:transform($s as xs:string) as xs:string {
  $s => fn:normalize-space() => fn:upper-case()
};
