<?xml version="1.0" encoding="utf-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
   <title>ISO Schematron rules</title>
   <!-- This file generated 2023-07-05T09:58:16Z by 'extract-isosch.xsl'. -->
   <!-- ********************* -->
   <!-- namespaces, declared: -->
   <!-- ********************* -->
   <ns prefix="tei" uri="http://www.tei-c.org/ns/1.0"/>
   <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
   <ns prefix="rng" uri="http://relaxng.org/ns/structure/1.0"/>
   <!-- ********************* -->
   <!-- namespaces, implicit: -->
   <!-- ********************* -->
   <ns prefix="dcr" uri="http://www.isocat.org/ns/dcr"/>
   <ns prefix="xi" uri="http://www.w3.org/2001/XInclude"/>
   <!-- ************ -->
   <!-- constraints: -->
   <!-- ************ -->
   <pattern id="schematron-constraint-hsp_cataloguing-att.datable.w3c-att-datable-w3c-when-1">
      <rule context="tei:*[@when]">
         <report test="@notBefore|@notAfter|@from|@to" role="nonfatal">The @when attribute cannot be used with any other att.datable.w3c attributes.</report>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-att.datable.w3c-att-datable-w3c-from-2">
      <rule context="tei:*[@from]">
         <report test="@notBefore" role="nonfatal">The @from and @notBefore attributes cannot be used together.</report>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-att.datable.w3c-att-datable-w3c-to-3">
      <rule context="tei:*[@to]">
         <report test="@notAfter" role="nonfatal">The @to and @notAfter attributes cannot be used together.</report>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-att.datable-calendar-calendar-4">
      <rule context="tei:*[@calendar]">
         <assert test="string-length(.) gt 0"> @calendar indicates one or more systems or calendars to
              which the date represented by the content of this element belongs, but this
              <name/> element has no textual content.</assert>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-att.measurement-att-measurement-unitRef-5">
      <rule context="tei:*[@unitRef]">
         <report test="@unit" role="info">The @unit attribute may be unnecessary when @unitRef is present.</report>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-att.typed-subtypeTyped-6">
      <rule context="tei:*[@subtype]">
         <assert test="@type">The <name/> element should not be categorized in detail with @subtype unless also categorized in general with @type</assert>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-att.pointing-targetLang-targetLang-7">
      <rule context="tei:*[not(self::tei:schemaSpec)][@targetLang]">
         <assert test="@target">@targetLang should only be used on <name/> if @target is specified.</assert>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-att.spanning-spanTo-spanTo-2-8">
      <rule context="tei:*[@spanTo]">
         <assert test="id(substring(@spanTo,2)) and following::*[@xml:id=substring(current()/@spanTo,2)]">
The element indicated by @spanTo (<value-of select="@spanTo"/>) must follow the current element <name/>
         </assert>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-att.styleDef-schemeVersion-schemeVersionRequiresScheme-9">
      <rule context="tei:*[@schemeVersion]">
         <assert test="@scheme and not(@scheme = 'free')">
              @schemeVersion can only be used if @scheme is specified.
            </assert>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-p-abstractModel-structure-p-10">
      <rule context="tei:p">
         <report test="not(ancestor::tei:floatingText) and (ancestor::tei:p or ancestor::tei:ab)          and not(parent::tei:exemplum                |parent::tei:item                |parent::tei:note                |parent::tei:q                |parent::tei:quote                |parent::tei:remarks                |parent::tei:said                |parent::tei:sp                |parent::tei:stage                |parent::tei:cell                |parent::tei:figure                )">
        Abstract model violation: Paragraphs may not occur inside other paragraphs or ab elements.
      </report>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-p-abstractModel-structure-l-11">
      <rule context="tei:p">
         <report test="(ancestor::tei:l or ancestor::tei:lg) and not(parent::tei:figure or parent::tei:note or ancestor::tei:floatingText)">
        Abstract model violation: Lines may not contain higher-level structural elements such as div, p, or ab, unless p is a child of figure or note, or is a descendant of floatingText.
      </report>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-desc-deprecationInfo-only-in-deprecated-12">
      <rule context="tei:desc[ @type eq 'deprecationInfo']">
         <assert test="../@validUntil">Information about a
        deprecation should only be present in a specification element
        that is being deprecated: that is, only an element that has a
        @validUntil attribute should have a child &lt;desc
        type="deprecationInfo"&gt;.</assert>
      </rule>
   </pattern>
   <pattern id="isoNormDate">
      <rule context="tei:surrogates/tei:bibl/tei:date">
         <assert test="@when[matches(.,'^[1,2]\d{3}-[0,1]\d{1}-\d{2}$')]"> @when
                      requires a date in the standard form: yyyy-mm-dd. </assert>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-ptr-ptrAtts-14">
      <rule context="tei:ptr">
         <report test="@target and @cRef">Only one of the
attributes @target and @cRef may be supplied on <name/>.</report>
      </rule>
   </pattern>
   <pattern id="typeAndTarget">
      <rule context="tei:surrogates/tei:bibl/tei:ref">
         <assert test="(@type and @target)">if ref has a type a target is
                      required</assert>
      </rule>
   </pattern>
   <pattern>
      <rule context="tei:ref">
         <assert test="@target or @type">You must provide either @target or
                      @type.</assert>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-ref-refAtts-17">
      <rule context="tei:ref">
         <report test="@target and @cRef">Only one of the
  attributes @target' and @cRef' may be supplied on <name/>
         </report>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-list-gloss-list-must-have-labels-18">
      <rule context="tei:list[@type='gloss']">
         <assert test="tei:label">The content of a "gloss" list should include a sequence of one or more pairs of a label element followed by an item element</assert>
      </rule>
   </pattern>
   <pattern id="indexTermHead">
      <rule context="tei:msDesc/tei:head/tei:index/tei:term[@type eq 'material_type']">
         <assert test=".= ('','paper','linen','palm','papyrus','parchment','other')">
                      If type="material_type", text should contain 'paper', 'linen', 'palm',
                      'papyrus', 'parchment', 'other' or should stay empty. </assert>
      </rule>
      <rule context="tei:index/tei:term[@type eq 'measure_noOfLeaves']">
         <assert test=".[matches(.,'^[0-9]*?$')]">The content may only contain
                      numbers</assert>
      </rule>
      <rule context="tei:index/tei:term[@type='height']">
         <assert test=".[matches(.,'^([0-9]+(,5)?)?$')]">Value of height may only be
                      an integer or must be a float which ends with ,5 or is empty</assert>
      </rule>
      <rule context="tei:index/tei:term[@type='width']">
         <assert test=".[matches(.,'^([0-9]+(,5)?)?$')]">Value of width may only be
                      an integer or must be a float which ends with ,5 or is empty</assert>
      </rule>
      <rule context="tei:index/tei:term[@type='depth']">
         <assert test=".[matches(.,'^([0-9]+(,5)?)?$')]">Value of depth may only be
                      an integer or must be a float which ends with ,5 or is empty</assert>
      </rule>
      <rule context="tei:term[@type='dimensions_typeOfInformation']">
         <assert test=". =('','deduced','factual')"> If
                      type="dimensions_typeOfInformation" then content should be 'deduced' or
                      'factual' or should stay empty. </assert>
      </rule>
      <rule context="tei:term[@type='format']">
         <assert test=".= ('','folio','quarto','octavo','smaller than octavo','larger than folio','other','oblong','square','long and narrow')"> folio, quarto, octavo, other, smaller than octavo, larger than folio,
                      oblong, long and narrow, square or empty </assert>
      </rule>
      <rule context="tei:term[@type='format_typeOfInformation']">
         <assert test=".=('','deduced','factual', 'computed')"> deduced, factual or
                      empty. </assert>
      </rule>
      <rule context="tei:term[@type='origDate_type']">
         <assert test=". = ('','dated','datable')"> If type="origDate_type", content
                      should be dated or datable or empty </assert>
      </rule>
      <rule context="tei:index/tei:term[@type='origDate_notBefore']">
         <assert test=".[matches(.,'^((\-?[0-9]{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01]))|(\-?[0-9]{4}\-(0[1-9]|1[012]))|(\-?[0-9]{4}))?$')]"> The content should contain a date (year); several date-types are allowed:
                      YYYY-MM-DD, -YYYY-MM-DD, YYYY-MM , -YYYY-MM or YYYY.</assert>
      </rule>
      <rule context="tei:index/tei:term[@type='origDate_notAfter']">
         <assert test=".[matches(.,'^((\-?[0-9]{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01]))|(\-?[0-9]{4}\-(0[1-9]|1[012]))|(\-?[0-9]{4}))?$')]"> The content should contain a date (year); several date-types are allowed:
                      YYYY-MM-DD, -YYYY-MM-DD, YYYY-MM , -YYYY-MM or YYYY. </assert>
      </rule>
      <rule context="tei:msDesc/tei:head/tei:index/tei:term[@type eq 'form']">
         <assert test=".= ('', 'codex', 'collection', 'composite', 'leporello', 'sammelband', 'fragment', 'printWithManuscriptParts', 'hostVolume', 'singleSheet', 'scroll', 'other')"> If @type="form", Text should contain 'codex', 'collection', 'composite',
                      'leporello', 'sammelband', 'fragment', 'singleSheet',
                      'printWithManuscriptParts', 'hostVolume', 'scroll', 'other' or should stay
                      empty</assert>
      </rule>
      <rule context="tei:index/tei:term[@type eq 'status']">
         <assert test=". = ('','missing','existent','destroyed','dismembered','unknown','displaced')"> If @type="status", content should be: 'existent', 'missing', 'destroyed',
                      'unknown','displaced' or should stay empty </assert>
      </rule>
      <rule context="tei:term[@type='decoration']">
         <assert test=". =('','yes','no')"> If type="decoration" then content should
                      be 'yes' or 'no' or empty</assert>
      </rule>
      <rule context="tei:term[@type='musicNotation']">
         <assert test=". =('','yes','no')"> If type="musicNotation" then content
                      should be 'yes' or 'no' or empty.</assert>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-relatedItem-targetorcontent1-20">
      <rule context="tei:relatedItem">
         <report test="@target and count( child::* ) &gt; 0">
If the @target attribute on <name/> is used, the
relatedItem element must be empty</report>
         <assert test="@target or child::*">A relatedItem element should have either a 'target' attribute
        or a child element to indicate the related bibliographic item</assert>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-l-abstractModel-structure-l-21">
      <rule context="tei:l">
         <report test="ancestor::tei:l[not(.//tei:note//tei:l[. = current()])]">
        Abstract model violation: Lines may not contain lines or lg elements.
      </report>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-lg-atleast1oflggapl-22">
      <rule context="tei:lg">
         <assert test="count(descendant::tei:lg|descendant::tei:l|descendant::tei:gap) &gt; 0">An lg element
        must contain at least one child l, lg, or gap element.</assert>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-lg-abstractModel-structure-l-23">
      <rule context="tei:lg">
         <report test="ancestor::tei:l[not(.//tei:note//tei:lg[. = current()])]">
        Abstract model violation: Lines may not contain line groups.
      </report>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-textLang-textLang.check-24">
      <rule context="//tei:textLang/@mainLang | //tei:textLang/@otherLangs | //@xml:lang">
         <assert test="every $code in tokenize(., ' ') satisfies matches($code, '^[a-z]{2,3}(-|$)')"
                 role="error">Codes in <value-of select="name(.)"/> attributes must conform
                    to BCP 47 (https://tools.ietf.org/html/bcp47), starting with an ISO 639 code for
                    the language, then optionally further codes for the script (ISO 15924), region,
                    transliteration, etc.</assert>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-div-abstractModel-structure-l-27">
      <rule context="tei:div">
         <report test="(ancestor::tei:l or ancestor::tei:lg) and not(ancestor::tei:floatingText)">
        Abstract model violation: Lines may not contain higher-level structural elements such as div, unless div is a descendant of floatingText.
      </report>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-div-abstractModel-structure-p-28">
      <rule context="tei:div">
         <report test="(ancestor::tei:p or ancestor::tei:ab) and not(ancestor::tei:floatingText)">
        Abstract model violation: p and ab may not contain higher-level structural elements such as div, unless div is a descendant of floatingText.
      </report>
      </rule>
   </pattern>
   <pattern id="msPart_fragment">
      <rule context="tei:msPart[@type eq 'fragment']">
         <assert test="not(                       following-sibling::tei:msPart[@type eq 'binding'])"> Only
                      msPart in the following order are allowed: binding, fragment, booklet, accMat, 
                      other </assert>
      </rule>
   </pattern>
   <pattern id="msPart_booklet">
      <rule context="tei:msPart[@type eq 'booklet']">
         <assert test="not(                       following-sibling::tei:msPart[@type eq 'binding'] or                        following-sibling::tei:msPart[@type eq 'fragment'])"> Only
                      msPart in the following order are allowed: binding, fragment, booklet, accMat, 
                      other </assert>
      </rule>
   </pattern>
   <pattern id="msPart_accMat">
      <rule context="tei:msPart[@type eq 'accMat']">
         <assert test="not(                       following-sibling::tei:msPart[@type eq 'binding'] or                        following-sibling::tei:msPart[@type eq 'fragment'] or                        following-sibling::tei:msPart[@type eq 'booklet'])"> Only
                      msPart in the following order are allowed: binding, fragment, booklet, accMat, 
                      other </assert>
      </rule>
   </pattern>
   <pattern id="msPart_other">
      <rule context="tei:msPart[@type eq 'other']">
         <assert test="not(                       following-sibling::tei:msPart[@type eq 'binding'] or                        following-sibling::tei:msPart[@type eq 'fragment'] or                        following-sibling::tei:msPart[@type eq 'booklet'] or                        following-sibling::tei:msPart[@type eq 'accMat'])"> Only
                      msPart in the following order are allowed: binding, fragment, booklet, accMat, 
                      other </assert>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-catchwords-catchword_in_msDesc-30">
      <rule context="tei:catchwords">
         <assert test="ancestor::tei:msDesc or ancestor::tei:egXML">The <name/> element should not be used outside of msDesc.</assert>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-dimensions-duplicateDim-31">
      <rule context="tei:dimensions">
         <report test="count(tei:width)&gt; 1">
The element <name/> may appear once only
      </report>
         <report test="count(tei:height)&gt; 1">
The element <name/> may appear once only
      </report>
         <report test="count(tei:depth)&gt; 1">
The element <name/> may appear once only
      </report>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-secFol-secFol_in_msDesc-32">
      <rule context="tei:secFol">
         <assert test="ancestor::tei:msDesc or ancestor::tei:egXML">The <name/> element should not be used outside of msDesc.</assert>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-signatures-signatures_in_msDesc-33">
      <rule context="tei:signatures">
         <assert test="ancestor::tei:msDesc or ancestor::tei:egXML">The <name/> element should not be used outside of msDesc.</assert>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-msIdentifier-msId_minimal-34">
      <rule context="tei:msIdentifier">
         <report test="not(parent::tei:msPart) and (local-name(*[1])='idno' or local-name(*[1])='altIdentifier' or normalize-space(.)='')">An msIdentifier must contain either a repository or location.</report>
      </rule>
   </pattern>
   <pattern id="ÄußeresKunst">
      <rule context="tei:physDesc/tei:decoDesc/tei:decoNote">
         <assert test="@type eq 'form' "> It's possible to describe some illuminated
                      aspects of a manuscript here </assert>
      </rule>
   </pattern>
   <pattern id="booklet">
      <rule context="tei:msPart[@type eq 'booklet']/tei:head/tei:index/tei:term[@type eq 'form']">
         <assert test="(.='booklet') or (.='')"> If msPart @type = 'booklet', then
                      form should be 'booklet' or be empty </assert>
      </rule>
      <rule context="tei:msPart[@type eq 'booklet']/tei:head/tei:index/tei:term[@type eq 'material_type']">
         <assert test=".= ('','paper','linen','palm','papyrus','parchment','other')">
                      If type="material_type", text should contain 'paper', 'linen', 'palm',
                      'papyrus', 'parchment', 'other' or should stay empty </assert>
      </rule>
   </pattern>
   <pattern id="binding">
      <rule context="tei:msPart[@type eq 'binding']/tei:head/tei:index/tei:term[@type eq 'material_type']">
         <assert test=".=('','wood','leather','parchment','textile materials','gold','silver','copper','brass','other')"> If msPart type="binding", material_type should contain
                      'wood','leather','parchment','textile
                      materials','gold','silver','copper','brass', 'other' or should stay empty
                    </assert>
      </rule>
      <rule context="tei:msPart[@type eq 'binding']/tei:head/tei:index/tei:term[@type eq 'form']">
         <assert test="(.='binding') or (.='')"> If msPart @type = 'binding', then
                      form should be 'binding' or be empty </assert>
      </rule>
   </pattern>
   <pattern id="accMat">
      <rule context="tei:msPart[@type eq 'accMat']/tei:head/tei:index/tei:term[@type eq 'material_type']">
         <assert test=".= ('','paper','linen','palm','papyrus','parchment','other')">
                      If type="accMat", material_type should contain 'paper', 'linen', 'palm',
                      'papyrus', 'parchment', 'other' or should stay empty. </assert>
      </rule>
      <rule context="tei:msPart[@type eq 'accMat']/tei:head/tei:index/tei:term[@type eq 'form']">
         <assert test=".=('','loose insert')"> If msPart @type = 'accMat',
                      then form should be 'loose insert' or be empty </assert>
      </rule>
   </pattern>
   <pattern id="fragment">
      <rule context="tei:msPart[@type eq 'fragment']/tei:head/tei:index/tei:term[@type eq 'material_type']">
         <assert test=".= ('','paper','linen','palm','papyrus','parchment','other')">
                      If msPart type="fragment" material_type should contain 'paper', 'linen',
                      'palm', 'papyrus', 'parchment', 'other' or should stay empty. </assert>
      </rule>
      <rule context="tei:msPart[@type eq 'fragment']/tei:head/tei:index/tei:term[@type eq 'form']">
         <assert test="(.='fragment') or (.='')"> If msPart @type = 'fragment', then
                      form should be 'fragment' or be empty </assert>
      </rule>
   </pattern>
   <pattern id="msPartInmsPartStandard">
      <rule context="tei:msPart[@type eq 'binding' or @type eq 'fragment' or @type eq 'accMat']/tei:msPart">
         <assert test="@type eq 'accMat' or @type eq 'fragment' or @type eq 'other'">
                      Only bindings, accMat and a fragment may contain further msParts with the
                      following types: accMat, fragment or other </assert>
      </rule>
   </pattern>
   <pattern id="msPartInmsPartBooklet">
      <rule context="tei:msPart[@type eq 'booklet']/tei:msPart">
         <assert test="@type eq 'fragment' or @type eq 'booklet' or @type eq 'accMat' or @type eq 'other'"> Only booklets may contain further msParts with the following types: accMat
                      fragment, booklets and other</assert>
      </rule>
   </pattern>
   <pattern id="msPartInmsPartStandardForm">
      <rule context="tei:msPart/tei:msPart[@type eq 'fragment']/tei:head/tei:index/tei:term[@type eq 'form']">
         <assert test="(.='fragment') or (.='')"> If msPart @type = 'fragment', then
                      form should be 'fragment' or be empty </assert>
      </rule>
      <rule context="tei:msPart/tei:msPart[@type eq 'accMat']/tei:head/tei:index/tei:term[@type eq 'form']">
         <assert test="(.='accMat') or (.='')"> If msPart @type = 'accMat', then form
                      should be 'accMat' or be empty </assert>
      </rule>
      <rule context="tei:msPart/tei:msPart[@type eq 'booklet']/tei:head/tei:index/tei:term[@type eq 'form']">
         <assert test="(.='booklet') or (.='')">If msPart @type = 'booklet' then form
                      should be 'booklet' or be empty </assert>
      </rule>
   </pattern>
   <pattern id="idnoKomponenteSonstiges">
      <rule context="tei:msPart[@type eq 'other']/tei:msIdentifier/tei:idno">
         <assert test=".=('Sonstiges')"> If msPart @type = 'other' then idno contains
                      'Sonstiges' </assert>
      </rule>
   </pattern>
   <pattern id="childKomponenteSonstiges">
      <rule context="tei:msPart[@type eq 'other']">
         <assert test="tei:p">msPart type="other" may only contain p Elements
                    </assert>
      </rule>
   </pattern>
   <pattern id="msPartoneP">
      <rule context="tei:msPart[@type eq 'booklet' or @type eq 'fragment' or @type eq 'binding' or @type eq 'accMat']">
         <assert test="count(tei:msPart[@type='other']) &lt; 2">only one msPart
                      type='other' is allowed in one msPart</assert>
      </rule>
   </pattern>
   <pattern id="msPartnoP">
      <rule context="tei:msPart[@type eq 'booklet' or @type eq 'fragment' or @type eq 'binding' or @type eq 'accMat']">
         <report test=". != tei:p">booklet, fragment, binding, accMat may not contain a
                      p Element as direct child</report>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-relation-reforkeyorname-37">
      <rule context="tei:relation">
         <assert test="@ref or @key or @name">One of the attributes  'name', 'ref' or 'key' must be supplied</assert>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-relation-activemutual-38">
      <rule context="tei:relation">
         <report test="@active and @mutual">Only one of the attributes @active and @mutual may be supplied</report>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-relation-activepassive-39">
      <rule context="tei:relation">
         <report test="@passive and not(@active)">the attribute 'passive' may be supplied only if the attribute 'active' is supplied</report>
      </rule>
   </pattern>
   <pattern id="schematron-constraint-hsp_cataloguing-objectIdentifier-objectIdentifier_minimal-40">
      <rule context="tei:objectIdentifier">
         <report test="not(count(*) gt 0)">An objectIdentifier must contain at minimum a single piece of locating or identifying information.</report>
      </rule>
   </pattern>
   <!-- *********** -->
   <!-- deprecated: -->
   <!-- *********** -->
   <pattern>
      <rule context="tei:unicodeName">
         <report test="true()" role="nonfatal">
                  WARNING: use of deprecated element — The <name/> element will be removed from the TEI on 2022-02-15. 
                </report>
      </rule>
   </pattern>
</schema>
