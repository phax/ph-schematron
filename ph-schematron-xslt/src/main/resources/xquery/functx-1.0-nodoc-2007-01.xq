<!--

    Copyright (C) 2014-2021 Philip Helger (www.helger.com)
    philip[at]helger[dot]com

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

            http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

-->
(:~

 : --------------------------------
 : The FunctX XQuery Function Library
 : --------------------------------

 : Copyright (C) 2007 Datypic

 : This library is free software; you can redistribute it and/or
 : modify it under the terms of the GNU Lesser General Public
 : License as published by the Free Software Foundation; either
 : version 2.1 of the License.

 : This library is distributed in the hope that it will be useful,
 : but WITHOUT ANY WARRANTY; without even the implied warranty of
 : MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 : Lesser General Public License for more details.

 : You should have received a copy of the GNU Lesser General Public
 : License along with this library; if not, write to the Free Software
 : Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

 : For more information on the FunctX XQuery library, contact contrib@functx.com.

 : @version 1.0
 : @see     http://www.xqueryfunctions.com
 :
 : Changes by Philip Helger: change from XQuery library to module
 :) 
declare namespace  functx = "http://www.functx.com" ;
 
declare function functx:add-attributes 
  ( $elements as element()* ,
    $attrNames as xs:QName* ,
    $attrValues as xs:anyAtomicType* )  as element()? {
       
   for $element in $elements
   return element { node-name($element)}
                  { for $attrName at $seq in $attrNames
                    return if ($element/@*[node-name(.) = $attrName])
                           then ()
                           else attribute {$attrName}
                                          {$attrValues[$seq]},
                    $element/@*,
                    $element/node() }
 } ;

declare function functx:add-months 
  ( $date as xs:anyAtomicType? ,
    $months as xs:integer )  as xs:date? {
       
   xs:date($date) + functx:yearMonthDuration(0,$months)
 } ;

declare function functx:add-or-update-attributes 
  ( $elements as element()* ,
    $attrNames as xs:QName* ,
    $attrValues as xs:anyAtomicType* )  as element()? {
       
   for $element in $elements
   return element { node-name($element)}
                  { for $attrName at $seq in $attrNames
                    return attribute {$attrName}
                                     {$attrValues[$seq]},
                    $element/@*[not(node-name(.) = $attrNames)],
                    $element/node() }
 } ;

declare function functx:all-whitespace 
  ( $arg as xs:string? )  as xs:boolean {
       
   normalize-space($arg) = ''
 } ;

declare function functx:are-distinct-values 
  ( $seq as xs:anyAtomicType* )  as xs:boolean {
       
   count(distinct-values($seq)) = count($seq)
 } ;

declare function functx:atomic-type 
  ( $values as xs:anyAtomicType* )  as xs:string* {
       
 for $val in $values
 return
 (if ($val instance of xs:untypedAtomic) then 'xs:untypedAtomic'
 else if ($val instance of xs:anyURI) then 'xs:anyURI'
 else if ($val instance of xs:ENTITY) then 'xs:ENTITY'
 else if ($val instance of xs:ID) then 'xs:ID'
 else if ($val instance of xs:NMTOKEN) then 'xs:NMTOKEN'
 else if ($val instance of xs:language) then 'xs:language'
 else if ($val instance of xs:NCName) then 'xs:NCName'
 else if ($val instance of xs:Name) then 'xs:Name'
 else if ($val instance of xs:token) then 'xs:token'
 else if ($val instance of xs:normalizedString)
         then 'xs:normalizedString'
 else if ($val instance of xs:string) then 'xs:string'
 else if ($val instance of xs:QName) then 'xs:QName'
 else if ($val instance of xs:boolean) then 'xs:boolean'
 else if ($val instance of xs:base64Binary) then 'xs:base64Binary'
 else if ($val instance of xs:hexBinary) then 'xs:hexBinary'
 else if ($val instance of xs:byte) then 'xs:byte'
 else if ($val instance of xs:short) then 'xs:short'
 else if ($val instance of xs:int) then 'xs:int'
 else if ($val instance of xs:long) then 'xs:long'
 else if ($val instance of xs:unsignedByte) then 'xs:unsignedByte'
 else if ($val instance of xs:unsignedShort) then 'xs:unsignedShort'
 else if ($val instance of xs:unsignedInt) then 'xs:unsignedInt'
 else if ($val instance of xs:unsignedLong) then 'xs:unsignedLong'
 else if ($val instance of xs:positiveInteger)
         then 'xs:positiveInteger'
 else if ($val instance of xs:nonNegativeInteger)
         then 'xs:nonNegativeInteger'
 else if ($val instance of xs:negativeInteger)
         then 'xs:negativeInteger'
 else if ($val instance of xs:nonPositiveInteger)
         then 'xs:nonPositiveInteger'
 else if ($val instance of xs:integer) then 'xs:integer'
 else if ($val instance of xs:decimal) then 'xs:decimal'
 else if ($val instance of xs:float) then 'xs:float'
 else if ($val instance of xs:double) then 'xs:double'
 else if ($val instance of xs:date) then 'xs:date'
 else if ($val instance of xs:time) then 'xs:time'
 else if ($val instance of xs:dateTime) then 'xs:dateTime'
 else if ($val instance of xs:dayTimeDuration)
         then 'xs:dayTimeDuration'
 else if ($val instance of xs:yearMonthDuration)
         then 'xs:yearMonthDuration'
 else if ($val instance of xs:duration) then 'xs:duration'
 else if ($val instance of xs:gMonth) then 'xs:gMonth'
 else if ($val instance of xs:gYear) then 'xs:gYear'
 else if ($val instance of xs:gYearMonth) then 'xs:gYearMonth'
 else if ($val instance of xs:gDay) then 'xs:gDay'
 else if ($val instance of xs:gMonthDay) then 'xs:gMonthDay'
 else 'unknown')
 } ;

declare function functx:avg-empty-is-zero 
  ( $values as xs:anyAtomicType* ,
    $allNodes as node()* )  as xs:double {
       
   if (empty($allNodes))
   then 0
   else sum($values[string(.) != '']) div count($allNodes)
 } ;

declare function functx:between-exclusive 
  ( $value as xs:anyAtomicType? ,
    $minValue as xs:anyAtomicType ,
    $maxValue as xs:anyAtomicType )  as xs:boolean {
       
   $value > $minValue and $value < $maxValue
 } ;

declare function functx:between-inclusive 
  ( $value as xs:anyAtomicType? ,
    $minValue as xs:anyAtomicType ,
    $maxValue as xs:anyAtomicType )  as xs:boolean {
       
   $value >= $minValue and $value <= $maxValue
 } ;

declare function functx:camel-case-to-words 
  ( $arg as xs:string? ,
    $delim as xs:string )  as xs:string {
       
   concat(substring($arg,1,1),
             replace(substring($arg,2),'(\p{Lu})',
                        concat($delim, '$1')))
 } ;

declare function functx:capitalize-first 
  ( $arg as xs:string? )  as xs:string? {
       
   concat(upper-case(substring($arg,1,1)),
             substring($arg,2))
 } ;

declare function functx:change-element-names-deep 
  ( $nodes as node()* ,
    $oldNames as xs:QName* ,
    $newNames as xs:QName* )  as node()* {
       
  if (count($oldNames) != count($newNames))
  then error(xs:QName('functx:Different_number_of_names'))
  else
   for $node in $nodes
   return if ($node instance of element())
          then element
                 {functx:if-empty
                    ($newNames[index-of($oldNames,
                                           node-name($node))],
                     node-name($node)) }
                 {$node/@*,
                  functx:change-element-names-deep($node/node(),
                                           $oldNames, $newNames)}
          else if ($node instance of document-node())
          then functx:change-element-names-deep($node/node(),
                                           $oldNames, $newNames)
          else $node
 } ;

declare function functx:change-element-ns-deep 
  ( $nodes as node()* ,
    $newns as xs:string ,
    $prefix as xs:string )  as node()* {
       
  for $node in $nodes
  return if ($node instance of element())
         then (element
               {QName ($newns,
                          concat($prefix,
                                    if ($prefix = '')
                                    then ''
                                    else ':',
                                    local-name($node)))}
               {$node/@*,
                functx:change-element-ns-deep($node/node(),
                                           $newns, $prefix)})
         else if ($node instance of document-node())
         then functx:change-element-ns-deep($node/node(),
                                           $newns, $prefix)
         else $node
 } ;

declare function functx:change-element-ns 
  ( $elements as element()* ,
    $newns as xs:string ,
    $prefix as xs:string )  as element()? {
       
   for $element in $elements
   return
   element {QName ($newns,
                      concat($prefix,
                                if ($prefix = '')
                                then ''
                                else ':',
                                local-name($element)))}
           {$element/@*, $element/node()}
 } ;

declare function functx:chars 
  ( $arg as xs:string? )  as xs:string* {
       
   for $ch in string-to-codepoints($arg)
   return codepoints-to-string($ch)
 } ;

declare function functx:contains-any-of 
  ( $arg as xs:string? ,
    $searchStrings as xs:string* )  as xs:boolean {
       
   some $searchString in $searchStrings
   satisfies contains($arg,$searchString)
 } ;

declare function functx:contains-case-insensitive 
  ( $arg as xs:string? ,
    $substring as xs:string )  as xs:boolean? {
       
   contains(upper-case($arg), upper-case($substring))
 } ;

declare function functx:contains-word 
  ( $arg as xs:string? ,
    $word as xs:string )  as xs:boolean {
       
   matches(upper-case($arg),
           concat('^(.*\W)?',
                     upper-case(functx:escape-for-regex($word)),
                     '(\W.*)?$'))
 } ;

declare function functx:copy-attributes 
  ( $copyTo as element() ,
    $copyFrom as element() )  as element() {
       
   element { node-name($copyTo)}
           { $copyTo/@*[not(node-name(.) = $copyFrom/@*/node-name(.))],
             $copyFrom/@*,
             $copyTo/node() }

 } ;

declare function functx:date 
  ( $year as xs:anyAtomicType ,
    $month as xs:anyAtomicType ,
    $day as xs:anyAtomicType )  as xs:date {
       
   xs:date(
     concat(
       functx:pad-integer-to-length(xs:integer($year),4),'-',
       functx:pad-integer-to-length(xs:integer($month),2),'-',
       functx:pad-integer-to-length(xs:integer($day),2)))
 } ;

declare function functx:dateTime 
  ( $year as xs:anyAtomicType ,
    $month as xs:anyAtomicType ,
    $day as xs:anyAtomicType ,
    $hour as xs:anyAtomicType ,
    $minute as xs:anyAtomicType ,
    $second as xs:anyAtomicType )  as xs:dateTime {
       
   xs:dateTime(
     concat(functx:date($year,$month,$day),'T',
             functx:time($hour,$minute,$second)))
 } ;

declare function functx:day-in-year 
  ( $date as xs:anyAtomicType? )  as xs:integer? {
       
  days-from-duration(
      xs:date($date) - functx:first-day-of-year($date)) + 1
 } ;

declare function functx:day-of-week-abbrev-en 
  ( $date as xs:anyAtomicType? )  as xs:string? {
       
   ('Sun', 'Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat')
   [functx:day-of-week($date) + 1]
 } ;

declare function functx:day-of-week-name-en 
  ( $date as xs:anyAtomicType? )  as xs:string? {
       
   ('Sunday', 'Monday', 'Tuesday', 'Wednesday',
    'Thursday', 'Friday', 'Saturday')
      [functx:day-of-week($date) + 1]
 } ;

declare function functx:day-of-week 
  ( $date as xs:anyAtomicType? )  as xs:integer? {
       
  if (empty($date))
  then ()
  else xs:integer((xs:date($date) - xs:date('1901-01-06'))
          div xs:dayTimeDuration('P1D')) mod 7
 } ;

declare function functx:dayTimeDuration 
  ( $days as xs:decimal? ,
    $hours as xs:decimal? ,
    $minutes as xs:decimal? ,
    $seconds as xs:decimal? )  as xs:dayTimeDuration {
       
    (xs:dayTimeDuration('P1D') * functx:if-empty($days,0)) +
    (xs:dayTimeDuration('PT1H') * functx:if-empty($hours,0)) +
    (xs:dayTimeDuration('PT1M') * functx:if-empty($minutes,0)) +
    (xs:dayTimeDuration('PT1S') * functx:if-empty($seconds,0))
 } ;

declare function functx:days-in-month 
  ( $date as xs:anyAtomicType? )  as xs:integer? {
       
   if (month-from-date(xs:date($date)) = 2 and
       functx:is-leap-year($date))
   then 29
   else
   (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
    [month-from-date(xs:date($date))]
 } ;

declare function functx:depth-of-node 
  ( $node as node()? )  as xs:integer {
       
   count($node/ancestor-or-self::node())
 } ;

declare function functx:distinct-attribute-names 
  ( $nodes as node()* )  as xs:string* {
       
   distinct-values($nodes//@*/name(.))
 } ;

declare function functx:distinct-deep 
  ( $nodes as node()* )  as node()* {
       
    for $seq in (1 to count($nodes))
    return $nodes[$seq][not(functx:is-node-in-sequence-deep-equal(
                          .,$nodes[position() < $seq]))]
 } ;

declare function functx:distinct-element-names 
  ( $nodes as node()* )  as xs:string* {
       
   distinct-values($nodes/descendant-or-self::*/name(.))
 } ;

declare function functx:distinct-element-paths 
  ( $nodes as node()* )  as xs:string* {
       
   distinct-values(functx:path-to-node($nodes/descendant-or-self::*))
 } ;

declare function functx:distinct-nodes 
  ( $nodes as node()* )  as node()* {
       
    for $seq in (1 to count($nodes))
    return $nodes[$seq][not(functx:is-node-in-sequence(
                                .,$nodes[position() < $seq]))]
 } ;

declare function functx:duration-from-timezone 
  ( $timezone as xs:string )  as xs:dayTimeDuration {
       
   xs:dayTimeDuration(
     if (not(matches($timezone,'Z|[\+\-]\d{2}:\d{2}')))
     then error(xs:QName('functx:Invalid_Timezone_Value'))
     else if ($timezone = 'Z')
     then 'PT0S'
     else replace($timezone,'\+?(\d{2}):\d{2}','PT$1H')
        )
 } ;

declare function functx:dynamic-path 
  ( $parent as node() ,
    $path as xs:string )  as item()* {
       
  let $nextStep := functx:substring-before-if-contains($path,'/')
  let $restOfSteps := substring-after($path,'/')
  for $child in
    ($parent/*[functx:name-test(name(),$nextStep)],
     $parent/@*[functx:name-test(name(),
                              substring-after($nextStep,'@'))])
  return if ($restOfSteps)
         then functx:dynamic-path($child, $restOfSteps)
         else $child
 } ;

declare function functx:escape-for-regex 
  ( $arg as xs:string? )  as xs:string {
       
   replace($arg,
           '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
 } ;

declare function functx:exclusive-or 
  ( $arg1 as xs:boolean? ,
    $arg2 as xs:boolean? )  as xs:boolean? {
       
   $arg1 != $arg2
 } ;

declare function functx:first-day-of-month 
  ( $date as xs:anyAtomicType? )  as xs:date? {
       
   functx:date(year-from-date(xs:date($date)),
            month-from-date(xs:date($date)),
            1)
 } ;

declare function functx:first-day-of-year 
  ( $date as xs:anyAtomicType? )  as xs:date? {
       
   functx:date(year-from-date(xs:date($date)), 1, 1)
 } ;

declare function functx:first-node 
  ( $nodes as node()* )  as node()? {
       
   ($nodes/.)[1]
 } ;

declare function functx:follows-not-descendant 
  ( $a as node()? ,
    $b as node()? )  as xs:boolean {
       
   $a >> $b and empty($b intersect $a/ancestor::node())
 } ;

declare function functx:format-as-title-en 
  ( $titles as xs:string* )  as xs:string* {
       
   let $wordsToMoveToEnd := ('A', 'An', 'The')
   for $title in $titles
   let $firstWord := functx:substring-before-match($title,'\W')
   return if ($firstWord = $wordsToMoveToEnd)
          then replace($title,'(.*?)\W(.*)', '$2, $1')
          else $title
 } ;

declare function functx:fragment-from-uri 
  ( $uri as xs:string? )  as xs:string? {
       
   substring-after($uri,'#')
 } ;

declare function functx:get-matches-and-non-matches 
  ( $string as xs:string? ,
    $regex as xs:string )  as element()* {
       
   let $iomf := functx:index-of-match-first($string, $regex)
   return
   if (empty($iomf))
   then <non-match>{$string}</non-match>
   else
   if ($iomf > 1)
   then (<non-match>{substring($string,1,$iomf - 1)}</non-match>,
         functx:get-matches-and-non-matches(
            substring($string,$iomf),$regex))
   else
   let $length :=
      string-length($string) -
      string-length(functx:replace-first($string, $regex,''))
   return (<match>{substring($string,1,$length)}</match>,
           if (string-length($string) > $length)
           then functx:get-matches-and-non-matches(
              substring($string,$length + 1),$regex)
           else ())
 } ;

declare function functx:get-matches 
  ( $string as xs:string? ,
    $regex as xs:string )  as xs:string* {
       
   functx:get-matches-and-non-matches($string,$regex)/
     string(self::match)
 } ;

declare function functx:has-element-only-content 
  ( $element as element() )  as xs:boolean {
       
   not($element/text()[normalize-space(.) != '']) and $element/*
 } ;

declare function functx:has-empty-content 
  ( $element as element() )  as xs:boolean {
       
   not($element/node())
 } ;

declare function functx:has-mixed-content 
  ( $element as element() )  as xs:boolean {
       
   $element/text()[normalize-space(.) != ''] and $element/*
 } ;

declare function functx:has-simple-content 
  ( $element as element() )  as xs:boolean {
       
   $element/text() and not($element/*)
 } ;

declare function functx:id-from-element 
  ( $element as element()? )  as xs:string? {
       
  data(($element/@*[id(.) is ..])[1])
 } ;

declare function functx:id-untyped 
  ( $node as node()* ,
    $id as xs:anyAtomicType )  as element()* {
       
  $node//*[@* = $id]
 } ;

declare function functx:if-absent 
  ( $arg as item()* ,
    $value as item()* )  as item()* {
       
    if (exists($arg))
    then $arg
    else $value
 } ;

declare function functx:if-empty 
  ( $arg as item()? ,
    $value as item()* )  as item()* {
       
  if (string($arg) != '')
  then data($arg)
  else $value
 } ;

declare function functx:index-of-deep-equal-node 
  ( $nodes as node()* ,
    $nodeToFind as node() )  as xs:integer* {
       
  for $seq in (1 to count($nodes))
  return $seq[deep-equal($nodes[$seq],$nodeToFind)]
 } ;

declare function functx:index-of-match-first 
  ( $arg as xs:string? ,
    $pattern as xs:string )  as xs:integer? {
       
  if (matches($arg,$pattern))
  then string-length(tokenize($arg, $pattern)[1]) + 1
  else ()
 } ;

declare function functx:index-of-node 
  ( $nodes as node()* ,
    $nodeToFind as node() )  as xs:integer* {
       
  for $seq in (1 to count($nodes))
  return $seq[$nodes[$seq] is $nodeToFind]
 } ;

declare function functx:index-of-string-first 
  ( $arg as xs:string? ,
    $substring as xs:string )  as xs:integer? {
       
  if (contains($arg, $substring))
  then string-length(substring-before($arg, $substring))+1
  else ()
 } ;

declare function functx:index-of-string-last 
  ( $arg as xs:string? ,
    $substring as xs:string )  as xs:integer? {
       
  functx:index-of-string($arg, $substring)[last()]
 } ;

declare function functx:index-of-string 
  ( $arg as xs:string? ,
    $substring as xs:string )  as xs:integer* {
       
  if (contains($arg, $substring))
  then (string-length(substring-before($arg, $substring))+1,
        for $other in
           functx:index-of-string(substring-after($arg, $substring),
                               $substring)
        return
          $other +
          string-length(substring-before($arg, $substring)) +
          string-length($substring))
  else ()
 } ;

declare function functx:insert-string 
  ( $originalString as xs:string? ,
    $stringToInsert as xs:string? ,
    $pos as xs:integer )  as xs:string {
       
   concat(substring($originalString,1,$pos - 1),
             $stringToInsert,
             substring($originalString,$pos))
 } ;

declare function functx:is-a-number 
  ( $value as xs:anyAtomicType? )  as xs:boolean {
       
   string(number($value)) != 'NaN'
 } ;

declare function functx:is-absolute-uri 
  ( $uri as xs:string? )  as xs:boolean {
       
   matches($uri,'^[a-z]+:')
 } ;

declare function functx:is-ancestor 
  ( $node1 as node() ,
    $node2 as node() )  as xs:boolean {
       
   exists($node1 intersect $node2/ancestor::node())
 } ;

declare function functx:is-descendant 
  ( $node1 as node() ,
    $node2 as node() )  as xs:boolean {
       
   boolean($node2 intersect $node1/ancestor::node())
 } ;

declare function functx:is-leap-year 
  ( $date as xs:anyAtomicType? )  as xs:boolean {
       
    for $year in xs:integer(substring(string($date),1,4))
    return ($year mod 4 = 0 and
            $year mod 100 != 0) or
            $year mod 400 = 0
 } ;

declare function functx:is-node-among-descendants-deep-equal 
  ( $node as node()? ,
    $seq as node()* )  as xs:boolean {
       
   some $nodeInSeq in $seq/descendant-or-self::*/(.|@*)
   satisfies deep-equal($nodeInSeq,$node)
 } ;

declare function functx:is-node-among-descendants 
  ( $node as node()? ,
    $seq as node()* )  as xs:boolean {
       
   some $nodeInSeq in $seq/descendant-or-self::*/(.|@*)
   satisfies $nodeInSeq is $node
 } ;

declare function functx:is-node-in-sequence-deep-equal 
  ( $node as node()? ,
    $seq as node()* )  as xs:boolean {
       
   some $nodeInSeq in $seq satisfies deep-equal($nodeInSeq,$node)
 } ;

declare function functx:is-node-in-sequence 
  ( $node as node()? ,
    $seq as node()* )  as xs:boolean {
       
   some $nodeInSeq in $seq satisfies $nodeInSeq is $node
 } ;

declare function functx:is-value-in-sequence 
  ( $value as xs:anyAtomicType? ,
    $seq as xs:anyAtomicType* )  as xs:boolean {
       
   $value = $seq
 } ;

declare function functx:last-day-of-month 
  ( $date as xs:anyAtomicType? )  as xs:date? {
       
   functx:date(year-from-date(xs:date($date)),
            month-from-date(xs:date($date)),
            functx:days-in-month($date))
 } ;

declare function functx:last-day-of-year 
  ( $date as xs:anyAtomicType? )  as xs:date? {
       
   functx:date(year-from-date(xs:date($date)), 12, 31)
 } ;

declare function functx:last-node 
  ( $nodes as node()* )  as node()? {
       
   ($nodes/.)[last()]
 } ;

declare function functx:leaf-elements 
  ( $root as node()? )  as element()* {
       
   $root/descendant-or-self::*[not(*)]
 } ;

declare function functx:left-trim 
  ( $arg as xs:string? )  as xs:string {
       
   replace($arg,'^\s+','')
 } ;

declare function functx:line-count 
  ( $arg as xs:string? )  as xs:integer {
       
   count(functx:lines($arg))
 } ;

declare function functx:lines 
  ( $arg as xs:string? )  as xs:string* {
       
   tokenize($arg, '(\r\n?|\n\r?)')
 } ;

declare function functx:max-depth 
  ( $root as node()? )  as xs:integer? {
       
   if ($root/*)
   then max($root/*/functx:max-depth(.)) + 1
   else 1
 } ;

declare function functx:max-determine-type 
  ( $seq as xs:anyAtomicType* )  as xs:anyAtomicType? {
       
   if (every $value in $seq satisfies ($value castable as xs:double))
   then max(for $value in $seq return xs:double($value))
   else max(for $value in $seq return xs:string($value))
 } ;

declare function functx:max-line-length 
  ( $arg as xs:string? )  as xs:integer {
       
   max(
     for $line in functx:lines($arg)
     return string-length($line))
 } ;

declare function functx:max-node 
  ( $nodes as node()* )  as node()* {
       
   $nodes[. = max($nodes)]
 } ;

declare function functx:max-string 
  ( $strings as xs:anyAtomicType* )  as xs:string? {
       
   max(for $string in $strings return string($string))
 } ;

declare function functx:min-determine-type 
  ( $seq as xs:anyAtomicType* )  as xs:anyAtomicType? {
       
   if (every $value in $seq satisfies ($value castable as xs:double))
   then min(for $value in $seq return xs:double($value))
   else min(for $value in $seq return xs:string($value))
 } ;

declare function functx:min-node 
  ( $nodes as node()* )  as node()* {
       
   $nodes[. = min($nodes)]
 } ;

declare function functx:min-non-empty-string 
  ( $strings as xs:string* )  as xs:string? {
       
   min($strings[. != ''])
 } ;

declare function functx:min-string 
  ( $strings as xs:anyAtomicType* )  as xs:string? {
       
   min(for $string in $strings return string($string))
 } ;

declare function functx:mmddyyyy-to-date 
  ( $dateString as xs:string? )  as xs:date? {
       
   if (empty($dateString))
   then ()
   else if (not(matches($dateString,
                        '^\D*(\d{2})\D*(\d{2})\D*(\d{4})\D*$')))
   then error(xs:QName('functx:Invalid_Date_Format'))
   else xs:date(replace($dateString,
                        '^\D*(\d{2})\D*(\d{2})\D*(\d{4})\D*$',
                        '$3-$1-$2'))
 } ;

declare function functx:month-abbrev-en 
  ( $date as xs:anyAtomicType? )  as xs:string? {
       
   ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')
    [month-from-date(xs:date($date))]
 } ;

declare function functx:month-name-en 
  ( $date as xs:anyAtomicType? )  as xs:string? {
       
   ('January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December')
   [month-from-date(xs:date($date))]
 } ;

declare function functx:name-test 
  ( $testname as xs:string? ,
    $names as xs:string* )  as xs:boolean {
       
$testname = $names
or
$names = '*'
or
functx:substring-after-if-contains($testname,':') =
   (for $name in $names
   return substring-after($name,'*:'))
or
substring-before($testname,':') =
   (for $name in $names[contains(.,':*')]
   return substring-before($name,':*'))
 } ;

declare function functx:namespaces-in-use 
  ( $root as node()? )  as xs:anyURI* {
       
   distinct-values(
      $root/descendant-or-self::*/(.|@*)/namespace-uri(.))
 } ;

declare function functx:next-day 
  ( $date as xs:anyAtomicType? )  as xs:date? {
       
   xs:date($date) + xs:dayTimeDuration('P1D')
 } ;

declare function functx:node-kind 
  ( $nodes as node()* )  as xs:string* {
       
 for $node in $nodes
 return
 if ($node instance of element()) then 'element'
 else if ($node instance of attribute()) then 'attribute'
 else if ($node instance of text()) then 'text'
 else if ($node instance of document-node()) then 'document-node'
 else if ($node instance of comment()) then 'comment'
 else if ($node instance of processing-instruction())
         then 'processing-instruction'
 else 'unknown'
 } ;

declare function functx:non-distinct-values 
  ( $seq as xs:anyAtomicType* )  as xs:anyAtomicType* {
       
   for $val in distinct-values($seq)
   return $val[count($seq[. = $val]) > 1]
 } ;

declare function functx:number-of-matches 
  ( $arg as xs:string? ,
    $pattern as xs:string )  as xs:integer {
       
   count(tokenize($arg,$pattern)) - 1
 } ;

declare function functx:open-ref-document 
  ( $refNode as node() )  as document-node() {
       
   if (base-uri($refNode))
   then doc(resolve-uri($refNode, base-uri($refNode)))
   else doc(resolve-uri($refNode))
 } ;

declare function functx:ordinal-number-en 
  ( $num as xs:integer? )  as xs:string {
       
   concat(xs:string($num),
         if (matches(xs:string($num),'[04-9]$|1[1-3]$')) then 'th'
         else if (ends-with(xs:string($num),'1')) then 'st'
         else if (ends-with(xs:string($num),'2')) then 'nd'
         else if (ends-with(xs:string($num),'3')) then 'rd'
         else '')
 } ;

declare function functx:pad-integer-to-length 
  ( $integerToPad as xs:anyAtomicType? ,
    $length as xs:integer )  as xs:string {
       
   if ($length < string-length(string($integerToPad)))
   then error(xs:QName('functx:Integer_Longer_Than_Length'))
   else concat
         (functx:repeat-string(
            '0',$length - string-length(string($integerToPad))),
          string($integerToPad))
 } ;

declare function functx:pad-string-to-length 
  ( $stringToPad as xs:string? ,
    $padChar as xs:string ,
    $length as xs:integer )  as xs:string {
       
   substring(
     string-join (
       ($stringToPad, for $i in (1 to $length) return $padChar)
       ,'')
    ,1,$length)
 } ;

declare function functx:path-to-node-with-pos 
  ( $node as node()? )  as xs:string {
       
string-join(
  for $ancestor in $node/ancestor-or-self::*
  let $sibsOfSameName := $ancestor/../*[name() = name($ancestor)]
  return concat(name($ancestor),
   if (count($sibsOfSameName) <= 1)
   then ''
   else concat(
      '[',functx:index-of-node($sibsOfSameName,$ancestor),']'))
 , '/')
 } ;

declare function functx:path-to-node 
  ( $nodes as node()* )  as xs:string* {
       
$nodes/string-join(ancestor-or-self::*/name(.), '/')
 } ;

declare function functx:precedes-not-ancestor 
  ( $a as node()? ,
    $b as node()? )  as xs:boolean {
       
   $a << $b and empty($a intersect $b/ancestor::node())
 } ;

declare function functx:previous-day 
  ( $date as xs:anyAtomicType? )  as xs:date? {
       
   xs:date($date) - xs:dayTimeDuration('P1D')
 } ;

declare function functx:remove-attributes-deep 
  ( $nodes as node()* ,
    $names as xs:string* )  as node()* {
       
   for $node in $nodes
   return if ($node instance of element())
          then  element { node-name($node)}
                { $node/@*[not(functx:name-test(name(),$names))],
                  functx:remove-attributes-deep($node/node(), $names)}
          else if ($node instance of document-node())
          then functx:remove-attributes-deep($node/node(), $names)
          else $node
 } ;

declare function functx:remove-attributes 
  ( $elements as element()* ,
    $names as xs:string* )  as element() {
       
   for $element in $elements
   return element
     {node-name($element)}
     {$element/@*[not(functx:name-test(name(),$names))],
      $element/node() }
 } ;

declare function functx:remove-elements-deep 
  ( $nodes as node()* ,
    $names as xs:string* )  as node()* {
       
   for $node in $nodes
   return
     if ($node instance of element())
     then if (functx:name-test(name($node),$names))
          then ()
          else element { node-name($node)}
                { $node/@*,
                  functx:remove-elements-deep($node/node(), $names)}
     else if ($node instance of document-node())
     then functx:remove-elements-deep($node/node(), $names)
     else $node
 } ;

declare function functx:remove-elements-not-contents 
  ( $nodes as node()* ,
    $names as xs:string* )  as node()* {
       
   for $node in $nodes
   return
    if ($node instance of element())
    then if (functx:name-test(name($node),$names))
         then functx:remove-elements-not-contents($node/node(), $names)
         else element {node-name($node)}
              {$node/@*,
              functx:remove-elements-not-contents($node/node(),$names)}
    else if ($node instance of document-node())
    then functx:remove-elements-not-contents($node/node(), $names)
    else $node
 } ;

declare function functx:remove-elements 
  ( $elements as element()* ,
    $names as xs:string* )  as element()* {
       
   for $element in $elements
   return element
     {node-name($element)}
     {$element/@*,
      $element/node()[not(functx:name-test(name(),$names))] }
 } ;

declare function functx:repeat-string 
  ( $stringToRepeat as xs:string? ,
    $count as xs:integer )  as xs:string {
       
   string-join((for $i in 1 to $count return $stringToRepeat),
                        '')
 } ;

declare function functx:replace-beginning 
  ( $arg as xs:string? ,
    $pattern as xs:string ,
    $replacement as xs:string )  as xs:string {
       
   replace($arg, concat('^.*?', $pattern), $replacement)
 } ;

declare function functx:replace-element-values 
  ( $elements as element()* ,
    $values as xs:anyAtomicType* )  as element()* {
       
   for $element at $seq in $elements
   return element { node-name($element)}
             { $element/@*,
               $values[$seq] }
 } ;

declare function functx:replace-first 
  ( $arg as xs:string? ,
    $pattern as xs:string ,
    $replacement as xs:string )  as xs:string {
       
   replace($arg, concat('(^.*?)', $pattern),
             concat('$1',$replacement))
 } ;

declare function functx:replace-multi 
  ( $arg as xs:string? ,
    $changeFrom as xs:string* ,
    $changeTo as xs:string* )  as xs:string? {
       
   if (count($changeFrom) > 0)
   then functx:replace-multi(
          replace($arg, $changeFrom[1],
                     functx:if-absent($changeTo[1],'')),
          $changeFrom[position() > 1],
          $changeTo[position() > 1])
   else $arg
 } ;

declare function functx:reverse-string 
  ( $arg as xs:string? )  as xs:string {
       
   codepoints-to-string(reverse(string-to-codepoints($arg)))
 } ;

declare function functx:right-trim 
  ( $arg as xs:string? )  as xs:string {
       
   replace($arg,'\s+$','')
 } ;

declare function functx:scheme-from-uri 
  ( $uri as xs:string? )  as xs:string? {
       
   substring-before($uri,':')
 } ;

declare function functx:sequence-deep-equal 
  ( $seq1 as item()* ,
    $seq2 as item()* )  as xs:boolean {
       
  every $i in 1 to max((count($seq1),count($seq2)))
  satisfies deep-equal($seq1[$i],$seq2[$i])
 } ;

declare function functx:sequence-node-equal-any-order 
  ( $seq1 as node()* ,
    $seq2 as node()* )  as xs:boolean {
       
  not( ($seq1 except $seq2, $seq2 except $seq1))
 } ;

declare function functx:sequence-node-equal 
  ( $seq1 as node()* ,
    $seq2 as node()* )  as xs:boolean {
       
  every $i in 1 to max((count($seq1),count($seq2)))
  satisfies $seq1[$i] is $seq2[$i]
 } ;

declare function functx:sequence-type 
  ( $items as item()* )  as xs:string {
       
concat(
  if (empty($items))
  then 'empty-sequence()'
  else if (every $val in $items
           satisfies $val instance of xs:anyAtomicType)
  then if (count(distinct-values(functx:atomic-type($items)))
           > 1)
  then 'xs:anyAtomicType'
  else functx:atomic-type($items[1])
  else if (some $val in $items
           satisfies $val instance of xs:anyAtomicType)
  then 'item()'
  else if (count(distinct-values(functx:node-kind($items))) > 1)
  then 'node()'
  else concat(functx:node-kind($items[1]),'()')
  ,
  if (count($items) > 1)
  then '+' else '')
   } ;

declare function functx:siblings-same-name 
  ( $element as element()? )  as element()* {
       
   $element/../*[node-name(.) = node-name($element)]
   except $element
 } ;

declare function functx:siblings 
  ( $node as node()? )  as node()* {
       
   $node/../node() except $node
 } ;

declare function functx:sort-as-numeric 
  ( $seq as item()* )  as item()* {
       
   for $item in $seq
   order by number($item)
   return $item
 } ;

declare function functx:sort-case-insensitive 
  ( $seq as item()* )  as item()* {
       
   for $item in $seq
   order by upper-case(string($item))
   return $item
 } ;

declare function functx:sort-document-order 
  ( $seq as node()* )  as node()* {
       
   $seq/.
 } ;

declare function functx:sort 
  ( $seq as item()* )  as item()* {
       
   for $item in $seq
   order by $item
   return $item
 } ;

declare function functx:substring-after-if-contains 
  ( $arg as xs:string? ,
    $delim as xs:string )  as xs:string? {
       
   if (contains($arg,$delim))
   then substring-after($arg,$delim)
   else $arg
 } ;

declare function functx:substring-after-last-match 
  ( $arg as xs:string? ,
    $regex as xs:string )  as xs:string {
       
   replace($arg,concat('^.*',$regex),'')
 } ;

declare function functx:substring-after-last 
  ( $arg as xs:string? ,
    $delim as xs:string )  as xs:string {
       
   replace ($arg,concat('^.*',functx:escape-for-regex($delim)),'')
 } ;

declare function functx:substring-after-match 
  ( $arg as xs:string? ,
    $regex as xs:string )  as xs:string? {
       
   replace($arg,concat('^.*?',$regex),'')
 } ;

declare function functx:substring-before-if-contains 
  ( $arg as xs:string? ,
    $delim as xs:string )  as xs:string? {
       
   if (contains($arg,$delim))
   then substring-before($arg,$delim)
   else $arg
 } ;

declare function functx:substring-before-last-match 
  ( $arg as xs:string? ,
    $regex as xs:string )  as xs:string? {
       
   replace($arg,concat('^(.*)',$regex,'.*'),'$1')
 } ;

declare function functx:substring-before-last 
  ( $arg as xs:string? ,
    $delim as xs:string )  as xs:string {
       
   if (matches($arg, functx:escape-for-regex($delim)))
   then replace($arg,
            concat('^(.*)', functx:escape-for-regex($delim),'.*'),
            '$1')
   else ''
 } ;

declare function functx:substring-before-match 
  ( $arg as xs:string? ,
    $regex as xs:string )  as xs:string {
       
   tokenize($arg,$regex)[1]
 } ;

declare function functx:time 
  ( $hour as xs:anyAtomicType ,
    $minute as xs:anyAtomicType ,
    $second as xs:anyAtomicType )  as xs:time {
       
   xs:time(
     concat(
       functx:pad-integer-to-length(xs:integer($hour),2),':',
       functx:pad-integer-to-length(xs:integer($minute),2),':',
       functx:pad-integer-to-length(xs:integer($second),2)))
 } ;

declare function functx:timezone-from-duration 
  ( $duration as xs:dayTimeDuration )  as xs:string {
       
   if (string($duration) = ('PT0S','-PT0S'))
   then 'Z'
   else if (matches(string($duration),'-PT[1-9]H'))
   then replace(string($duration),'PT([1-9])H','0$1:00')
   else if (matches(string($duration),'PT[1-9]H'))
   then replace(string($duration),'PT([1-9])H','+0$1:00')
   else if (matches(string($duration),'-PT1[0-4]H'))
   then replace(string($duration),'PT(1[0-4])H','$1:00')
   else if (matches(string($duration),'PT1[0-4]H'))
   then replace(string($duration),'PT(1[0-4])H','+$1:00')
   else error(xs:QName('functx:Invalid_Duration_Value'))
 } ;

declare function functx:total-days-from-duration 
  ( $duration as xs:dayTimeDuration? )  as xs:decimal? {
       
   $duration div xs:dayTimeDuration('P1D')
 } ;

declare function functx:total-hours-from-duration 
  ( $duration as xs:dayTimeDuration? )  as xs:decimal? {
       
   $duration div xs:dayTimeDuration('PT1H')
 } ;

declare function functx:total-minutes-from-duration 
  ( $duration as xs:dayTimeDuration? )  as xs:decimal? {
       
   $duration div xs:dayTimeDuration('PT1M')
 } ;

declare function functx:total-months-from-duration 
  ( $duration as xs:yearMonthDuration? )  as xs:decimal? {
       
   $duration div xs:yearMonthDuration('P1M')
 } ;

declare function functx:total-seconds-from-duration 
  ( $duration as xs:dayTimeDuration? )  as xs:decimal? {
       
   $duration div xs:dayTimeDuration('PT1S')
 } ;

declare function functx:total-years-from-duration 
  ( $duration as xs:yearMonthDuration? )  as xs:decimal? {
       
   $duration div xs:yearMonthDuration('P1Y')
 } ;

declare function functx:trim 
  ( $arg as xs:string? )  as xs:string {
       
   replace(replace($arg,'\s+$',''),'^\s+','')
 } ;

declare function functx:update-attributes 
  ( $elements as element()* ,
    $attrNames as xs:QName* ,
    $attrValues as xs:anyAtomicType* )  as element()? {
       
   for $element in $elements
   return element { node-name($element)}
                  { for $attrName at $seq in $attrNames
                    return if ($element/@*[node-name(.) = $attrName])
                           then attribute {$attrName}
                                     {$attrValues[$seq]}
                           else (),
                    $element/@*[not(node-name(.) = $attrNames)],
                    $element/node() }
 } ;

declare function functx:value-except 
  ( $arg1 as xs:anyAtomicType* ,
    $arg2 as xs:anyAtomicType* )  as xs:anyAtomicType* {
       
  distinct-values($arg1[not(.=$arg2)])
 } ;

declare function functx:value-intersect 
  ( $arg1 as xs:anyAtomicType* ,
    $arg2 as xs:anyAtomicType* )  as xs:anyAtomicType* {
       
  distinct-values($arg1[.=$arg2])
 } ;

declare function functx:value-union 
  ( $arg1 as xs:anyAtomicType* ,
    $arg2 as xs:anyAtomicType* )  as xs:anyAtomicType* {
       
  distinct-values(($arg1, $arg2))
 } ;

declare function functx:word-count 
  ( $arg as xs:string? )  as xs:integer {
       
   count(tokenize($arg, '\W+')[. != ''])
 } ;

declare function functx:words-to-camel-case 
  ( $arg as xs:string? )  as xs:string {
       
     string-join((tokenize($arg,'\s+')[1],
       for $word in tokenize($arg,'\s+')[position() > 1]
       return functx:capitalize-first($word))
      ,'')
 } ;

declare function functx:wrap-values-in-elements 
  ( $values as xs:anyAtomicType* ,
    $elementName as xs:QName )  as element()* {
       
   for $value in $values
   return element {$elementName} {$value}
 } ;

declare function functx:yearMonthDuration 
  ( $years as xs:decimal? ,
    $months as xs:integer? )  as xs:yearMonthDuration {
       
    (xs:yearMonthDuration('P1M') * functx:if-empty($months,0)) +
    (xs:yearMonthDuration('P1Y') * functx:if-empty($years,0))
 } ;

(: Dummy call so that this is not a libary... :)
functx:words-to-camel-case("bla")
