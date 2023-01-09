<?xml version="1.0" encoding="UTF-8"?>
<!--

    Copyright (C) 2020-2023 Philip Helger (www.helger.com)
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
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    queryBinding="xslt2">
    <title>Validation using Schematron rules</title>
    <ns prefix="cat" 
        uri="http://www.iro.umontreal.ca/lapalme/wine-catalog"/>
    <xsl:key name="colors" match="/cellar-book/cat:wine-catalog/cat:wine"
        use="cat:properties/cat:color"/>
    
    <pattern>
        <rule context="wine">
            <report test="rating/@stars>1 and not(comment)"> 
                There should be a comment for a wine with more than one star.
            </report>
        </rule>
    </pattern>
    
    <pattern>
        <rule context="cellar">
            <let name="nbBottles" value="sum(wine/quantity)"/>
            <!-- nb of bottles of each color in the cellar -->
            <let name="winesFromCellar" value="/cellar-book/cellar/wine"/>
            <let name="colors" value="/cellar-book/cat:wine-catalog/cat:wine"/>
            <let name="nbReds" 
             value="sum($winesFromCellar[@code='red']/quantity)"/>
            <let name="nbWhites" 
             value="sum($winesFromCellar[@code='white']/quantity)"/>
            <let name="nbRosés" 
             value="sum($winesFromCellar[@code='rosé']/quantity)"/>
            <let name="nbColors" value="$nbReds+$nbWhites+$nbRosés"/>
            <report test="$nbBottles &lt; 10">
                Only <value-of select="$nbBottles"/> bottles left in the cellar.
            </report>
            <!-- check for a well balanced cellar!!! -->
            <assert test="$nbReds>$nbColors div 3">
                Not enough reds (<value-of select="$nbReds"/> over 
                <value-of select="$nbColors"/>) left in the cellar.
            </assert>
            <assert test="$nbWhites>$nbColors div 4">
                Not enough whites (<value-of select="$nbWhites"/> over 
                <value-of select="$nbColors"/>) left in the cellar.
            </assert>
            <assert test="$nbRosés>$nbColors div 4">
                Not enough rosés (<value-of select="$nbRosés"/> over 
                <value-of select="$nbColors"/>) left in the cellar.
            </assert>
            <!-- check for consistency within number of bottles -->
            <assert test="$nbBottles=$nbColors">
                Inconsistent count of bottles: total is <value-of select="$nbBottles"/> 
                but the count by colors is <value-of select="$nbColors"/>: 
                (<value-of select="$nbReds"/> reds, <value-of select="$nbWhites"/> 
                whites and <value-of select="$nbRosés"/> rosés).
            </assert>
        </rule>
    </pattern>
    
    <pattern abstract="true" id="spacesAtStartEnd">
        <rule context="comment|cat:comment|cat:food-pairing|cat:tasting-note">
            <report test="starts-with($elem,' ') or 
                          substring($elem,string-length($elem))=' '">
                A <value-of select="name($elem)"/> element within a <name/> 
                should not start or end with a space.
            </report>
        </rule>
    </pattern>
    <pattern is-a="spacesAtStartEnd">
        <param name="elem" value="cat:bold"/>
    </pattern>
    <pattern is-a="spacesAtStartEnd">
        <param name="elem" value="cat:emph"/>
    </pattern>
    
</schema>