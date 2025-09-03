
## Encoding changes to simplify and make compliant with EpiDoc and TEI Publisher best practice recommendations

* `TEI/@type` with values `partial` for inscription parts and `complete` for the entire (possibly reconstructed) inscription
* `TEI/@xml:id` with EDEP inventory number

* *digital editor* (person who does data entry and revision) recorded in `titleStmt` as `editor` with `@role` set to `digital`

other editorial roles may be added in `taxonomy.xml` under `pb-editor-roles` taxonomy

```xml
<taxonomy xml:id="pb-editor-role">
    <category xml:id="digital">
        <catDesc>Digital editor</catDesc>
    </category>
</taxonomy>
```

## drop `msPart`

### former `msIdentifier` section

  - move `msPart/msIdentifier` content (Trismegistos ID and the repository where the object is currently archived) to `sourceDesc/msDesc/msIdentifier`
  - factor out inventory number from `msPart/msIdentifier/repository` to `<idno type="inventory">` (to be understood as referring to the inventory number of the object in the sibling `repository` element)
  - remove `<repository>Epigraphische Datenbank Heidelberg</repository>` from `sourceDesc/msDesc/msIdentifier` as this information is already represented in `publicationStmt/authority`

  expected end result something like below, with 4 pieces of information:
    - repository where the object is currently archived (`repository` identified via `@key` with GND identifier, where available)
    - inventory number in this repository (`idno` with `@type="inventory`)
    - trismegistos number where available (`idno` with `@type="TM"`)
    - edep identifier (`idno` with `@type="EDEp"`)

```xml
  <sourceDesc>
    <msDesc>
        <msIdentifier>
            <repository key="https://d-nb.info/gnd/1055016-1">München, Staatliche
                Antikensammlung</repository>
            <idno type="inventory">NI 6979</idno>
            <idno type="TM">522587</idno>
            <idno type="EDEp">E0000030</idno>
        </msIdentifier>
    ...
    </msDesc>
  </sourceDesc>  
```

### former `history` section content

relocate content (`origPlace` and two types of `provenance`) to `sourceDesc/msDesc`

**NB** `origPlace` must be inserted after `origDate` in `origin`

### all references 

relocate to `sourceDesc/listBibl` as nested `listBibl` elements with `@type` (just copy overything over)

### `msContents`

relocate wholesale to `sourceDesc/msDesc`

### `layoutDesc`

relocate to `sourceDesc/msDesc/physDesc/objectDesc`

### `handDesc`

relocate to `sourceDesc/msDesc/physDesc`

### `supportDesc`

- relocate `condition` to `sourceDesc/msDesc/physDesc/objectDesc/supportDesc`


## `rs`

- change `rs type="decoration` to `note` with `@corresp` and relocate to `sourceDesc/msDesc/physDesc/objectDesc/supportDesc/support` (could also use `ref` but elsewhere `note` is more fitting, so for consistency let's stick with that)
- change other cases of `rs` usage to `note` with `@type`

**NB** `rs` was just wrong to use as it is design to represent references to named objects in the text; it makes no sense as an empty element or placeholder to put classifications onto

## Languages
  
- remove `textLang` element
- add `profileDesc/langUsage`
- `language` with empty `@ident` serves to enter a free form note on languages

```xml
<!-- Replaces mainLang - use repeat with option to mark one as main -->
<langUsage>
    <language ident="">Additional comments or elaboration on languages</language>
    <language ana="main" ident="lat"/>
    <language ident="nxm"/>
</langUsage>
```

## Verification

- change `<note type="verification"` to `respStmt` entries in the `titleStmt`

```xml
<respStmt>
    <resp when="1885">autopsy</resp>
    <persName>Helbig</persName>
</respStmt>
<respStmt>
    <resp>photo</resp>
    <persName>Kajava</persName>
</respStmt>
```

## type of inscription (simplify `msContent`)

instead of using `msItem` with nested content, factor out verification (see above) and reduce function of `msContents` to info on type of inscription and corresponding free text note (`summary`)

```xml
<msContents class="https://www.eagle-network.eu/voc/typeins/lod/80">
    <summary>Tituli sacri; Titulus Fortunae</summary>
</msContents>
```

## partials

* `<TEI type="partial" id="EDEP-007-a" corresp="EDEP-007">`
* Use EDEP ID E0000028 as example


Fields going into project-specific profile:

* TM ID: replace with a repeat which has configurable (one or more) identifiers, e.g. wikidata, taisho ...
* Drop "transmission", use type on listBibl to denote bibliographic type. By default this includes: previous editions and bibliography. For EDEp additionally images and transmittions (in same order as currently)
* Description of object / free form: project specific, not in base
* Metric and ligature
* Historical relevance

## CHANGES

* Repository:

  + 'GND Key' in 'Repository Key'
  + additionally: specify inventary ID in additional field
  + checkbox <repository ana="lost"> means: the object is lost


* Digital images should be a separate block
* Description/Decoration gets an additional, optional free form field: description of decoration
* Type of monument and type of inscription could go into the same block after dropping msPart
* handDesc/handNote letter size:
```xml
<dimensions>
                                        <!-- Add to form -->
                                        <height min="" max="" unit="cm"></height>
                                        <width min="" max="" unit="cm"></width>
                                    </dimensions>
```
* Languages:
  + becomes repeat with checkbox for main language
  + free form field for other language information

  <textLang mainLang="lat"/>
```
<!-- Replaces mainLang - use repeat with option to mark one as main -->
<langUsage>
  <language ana="main" ident="lat"></language>
  <language ident="nxm">Numidian</language>
  <language ident="">Free form comment</language>
</langUsage>
```
* allow more than one editor with different @role

## Other TODOs

* check the consequences of dropping msPart
* Information buttons should always be next to the box title, not in the editor toolbar
* check use of `rs` via `ref`:

```xml
<!-- change: replace rs with ref where applicable -->
                                        <ref type="decoration" target="https://www.eagle-network.eu/voc/decor/lod/1000">
                                            <!-- free form text goes here (situative) -->
                                        </ref>
```
