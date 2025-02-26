<!--
%\VignetteEngine{simplermarkdown::mdweave_to_html}
%\VignetteIndexEntry{Overview of support for the Data Package specification v2}
-->

---
title: Overview of support for the Datapackage Specification v2
author: Jan van der Laan
css: "style.css"
---


Note that any property can always be obtained and set using `dpproperty()` and
`dpproperty<-()` respectively. Therefore, when specific support for a property
is missing from the table below, this poperty can still be obtained and set. 

## Data Package

<table>
  <thead>
    <tr><th>Property</th><th>Getting</th><th>Setting</th></tr>
  </thead><tbody>
    <tr>
      <td><code>resources</code></td>
      <td class="complete"><code>dp_resource()</code>, <code>dp_resource_names()</code></td>
      <td class="complete"><code>dp_resource<-()</code>,
      <code>cp_resources<-()</code></td>
    </tr><tr>
      <td><code>$schema</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>name</code></td>
      <td class="complete"><code>dp_name()</code></td>
      <td class="complete"><code>dp_name<-()</code></td>
    </tr><tr>
      <td><code>id </code></td>
      <td class="complete"><code>dp_id()</code></td>
      <td class="complete"><code>dp_id<-()</code></td>
    </tr><tr>
      <td><code>licenses</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>title</code></td>
      <td class="complete"><code>dp_title()</code></td>
      <td class="complete"><code>dp_title<-()</code></td>
    </tr><tr>
      <td><code>description</code></td>
      <td class="complete"><code>dp_description()</code></td>
      <td class="complete"><code>dp_description<-()</code></td>
    </tr><tr>
      <td><code>homepage</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>image</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>version</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>created</code></td>
      <td class="complete"><code>dp_created()</code></td>
      <td class="complete"><code>dp_created<-()</code></td>
    </tr><tr>
      <td><code>keywords</code></td>
      <td class="complete"><code>dp_keywords()</code></td>
      <td class="complete"><code>dp_keywords<-()</code></td>
    </tr><tr>
      <td><code>contributors</code></td>
      <td class="complete"><code>dp_contributors()</code></td>
      <td class="complete"><code>dp_contributors<-()</code>,
      <code>dp_add_contributor()</code>, <code>dp_new_contributor()</code></td>
    </tr><tr>
      <td><code>sources</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr>
  </tbody>
</table>

## Data Resource

<table>
  <thead>
    <tr><th>Property</th><th>Getting</th><th>Setting</th></tr>
  </thead><tbody>
    <tr>
      <td><code>name</code></td>
      <td class="complete"><code>dp_name()</code></td>
      <td class="complete"><code>dp_name<-()</code></td>
    </tr><tr>
      <td><code>path</code></td>
      <td class="complete"><code>dp_path()</code></td>
      <td class="complete"><code>dp_path<-()</code></td>
    </tr><tr>
      <td><code>data</code></td>
      <td class="complete"><code>dp_get_data()</code> returns data either from 'data'
      property or by reading from the 'path'.</td>
      <td class="partial">It is possible to write data to file using
      <code>dp_write_data()</code>, but not to the 'data' property inside the
      <code>datapackage.json</code></td>
    </tr><tr>
      <td><code>type</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>$schema</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>title</code></td>
      <td class="complete"><code>dp_title()</code></td>
      <td class="complete"><code>dp_title<-()</code></td>
    </tr><tr>
      <td><code>description</code></td>
      <td class="complete"><code>dp_description()</code></td>
      <td class="complete"><code>dp_description<-()</code></td>
    </tr><tr>
      <td><code>format</code></td>
      <td class="complete"><code>dp_format()</code>,
      <code>dp_get_data()</code> will use the 'format' as the primary
      determinant for the reader to use to read the data.</td>
      <td class="complete"><code>dp_format<-()</code></td>
    </tr><tr>
      <td><code>mediatype</code></td>
      <td class="complete"><code>dp_mediatype()</code>, when 'format' is missing
      'mediatype' will be used to determine which reader to use for reading the
      data by <code>dp_get_data()</code></td>
      <td class="complete"><code>dp_mediatype<-()</code>,
      <code>dp_generate_dataresource()</code></td>
    </tr><tr>
      <td><code>encoding</code></td>
      <td class="complete"><code>dp_encoding()</code></td>
      <td class="complete"><code>dp_encoding<-()</code></td>
    </tr><tr>
      <td><code>bytes</code></td>
      <td class="complete"><code>dp_bytes()</code><sup>a</sup></td>
      <td class="complete"><code>dp_bytes<-()</code><sup>a</sup></td>
    </tr><tr>
      <td><code>hash</code></td>
      <td class="complete"><code>dp_hash()</code><sup>a</sup></td>
      <td class="complete"><code>dp_hash<-()</code><sup>a</sup></td>
    </tr><tr>
      <td><code>sources</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>licences</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr>
  </tbody>
</table>

<sup>a</sup> The number of bytes and the hash can be set and get. There is no functionality
to check is the file indeed has the specified number of bytes or hash and/or to
automatically calculate this from the given file(s).

## Tabular Data Resource

<table>
  <thead>
    <tr><th>Property</th><th>Getting</th><th>Setting</th></tr>
  </thead><tbody>
    <tr>
      <td><code>dialect</code></td>
      <td class="partial">See 'Table Dialect'. There is no function to
      specifically get the 'dialect' information. The data resource is passed to
      the reader functions that will access this information.</td>
      <td class="partial">See 'Table Dialect'. The writer functions will use
      this information when writing. There is no specific function to change
      this information. By default the, safe, default values will be used.</td>
    </tr><tr>
      <td><code>schema</code></td>
      <td class="complete"><code>dp_schema()</code>, also see 'Table Schema'</td>
      <td class="partial">`dp_generate_dataresource()` will generate appropiate
      schema for a given data set.</td>
    </tr>
  </tbody>
</table>


## Table Dialect

As mentioned above, the 'dialect' property cannot be directly set. The table
below indicates what properties are recognised when reading and writing data.
The items are marked as support or not or irrelevant based on the support by the
CSV reader and writer.

<table>
  <thead>
    <tr><th>Property</th><th>Reading</th><th>Writing</th></tr>
  </thead><tbody>
    <tr>
      <td><code>$schema</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>header</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr>
      <td><code>headerRows</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>headerJoin</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>commentRows</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>commentChar</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr>
      <td><code>delimiter</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr>
      <td><code>lineTerminator</code></td>
      <td class="complete">CSV<sup>a</sup></td>
      <td class="complete">CSV<sup>a</sup></td>
    </tr><tr>
      <td><code>quoteChar</code></td>
      <td class="complete">CSV<sup>b</sup></td>
      <td class="complete">CSV<sup>b</sup></td>
    </tr><tr>
      <td><code>doubleQuote</code></td>
      <td class="complete">CSV<sup>c</sup></td>
      <td class="complete">CSV<sup>c</sup></td>
    </tr><tr>
      <td><code>escapeChar</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>nullSequence</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr>
      <td><code>skipInitialSpace</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr>
      <td><code>property</code></td>
      <td class="irrelevant"></td>
      <td class="irrelevant"></td>
    </tr><tr>
      <td><code>itemType</code></td>
      <td class="irrelevant"></td>
      <td class="irrelevant"></td>
    </tr><tr>
      <td><code>itemKeys</code></td>
      <td class="irrelevant"></td>
      <td class="irrelevant"></td>
    </tr><tr>
      <td><code>sheetNumber</code></td>
      <td class="irrelevant"></td>
      <td class="irrelevant"></td>
    </tr><tr>
      <td><code>sheetName</code></td>
      <td class="irrelevant"></td>
      <td class="irrelevant"></td>
    </tr><tr>
      <td><code>table</code></td>
      <td class="irrelevant"></td>
      <td class="irrelevant"></td>
    </tr>
  </tbody>
</table>

<sup>a</sup> Only <code>\\n</code>/<code>\\r</code> or <code>\\r\\n</code> is accepted.

<sup>b</sup> Only '<code>"</code>' is accepted.

<sup>c</sup> Only '<code>true</code>' is accepted.

## Table Schema

<table>
  <thead>
    <tr><th>Property</th><th>Getting</th><th>Setting</th></tr>
  </thead><tbody>
    <tr>
      <td><code>$schema</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>fields</code></td>
      <td class="complete"><code>dp_field()</code>, <code>dp_field_names()</code></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>fieldsMatch</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>missingValues</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>primaryKeys</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>uniqueKeys</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>foreignKeys</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr>
  </tbody>
</table>

## Field Descriptor

<table>
  <thead>
    <tr><th>Property</th><th>Getting</th><th>Setting</th></tr>
  </thead><tbody>
    <tr>
      <td><code>name</code></td>
      <td class="complete"><code>dp_name()</code>; also used by <code>dp_get_data()</code>.</td>
      <td class="complete"><code>dp_name<-()</code></td>
    </tr><tr>
      <td><code>type</code></td>
      <td class="partial">Used by <code>dp_get_data()</code>.</td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>format</code></td>
      <td class="complete"><code>dp_format()</code></td>
      <td class="complete"><code>dp_format<-()</code></td>
    </tr><tr>
      <td><code>title</code></td>
      <td class="complete"><code>dp_title()</code></td>
      <td class="complete"><code>dp_title<-()</code></td>
    </tr><tr>
      <td><code>description</code></td>
      <td class="complete"><code>dp_description()</code></td>
      <td class="complete"><code>dp_description<-()</code></td>
    </tr><tr>
      <td><code>example</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>constraints</code></td>
      <td class="partial">Used by <code>dp_check_field()</code> and
      <code>dp_check_dataresource()</code>; see 'Field Constraints'.</td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>categories</code></td>
      <td class="partial">Used by <code>dp_categorieslist()</code> and <code>dp_get_data()</code>.</td>
      <td class="partial">Used by <code>dp_write_data()</code> and
      <code>dp_generate_dataresource()</code>.</td>
    </tr><tr>
      <td><code>categoriesOrdered</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>missingValues</code></td>
      <td class="partial">Used by <code>dp_get_data()</code>.</td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>refType</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr>
  </tbody>
</table>


## Field Types

As mentioned above, the field descriptors cannot be directly modified or read
from.  The table below indicates what properties are recognised when reading and
writing data.  The items are marked as support or not or irrelevant based on the
support by the CSV reader and writer.

When a type is not supported the data will be read as a character string.

<table>
  <thead>
    <tr><th>Property</th><th>Reading</th><th>Writing</th></tr>
  </thead><tbody>
    <tr>
      <td><code>string</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr class="sub">
      <td><code>format</code></td>
      <td class="irrelevant"></td>
      <td class="irrelevant"></td>
    </tr><tr>
      <td><code>number</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr class="sub">
      <td><code>NaN, INF, -INF</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr class="sub">
      <td><code>exponent</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr class="sub">
      <td><code>decimalChar</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr class="sub">
      <td><code>groupChar</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr class="sub">
      <td><code>bareNumber</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr>
      <td><code>integer</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr class="sub">
      <td><code>groupChar</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr class="sub">
      <td><code>bareNumber</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr>
      <td><code>boolean</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr class="sub">
      <td><code>trueValues</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr class="sub">
      <td><code>falseValues</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr>
      <td><code>object</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>array</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>list</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr class="sub">
      <td><code>delimiter</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr class="sub">
      <td><code>itemType</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>datetime</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr class="sub">
      <td><code>format ("default", "<PATTERN>", "any")</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr>
      <td><code>date</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr class="sub">
      <td><code>format ("default", "<PATTERN>", "any")</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr>
      <td><code>time</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr class="sub">
      <td><code>format ("default", "<PATTERN>", "any")</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr>
      <td><code>year</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr>
      <td><code>yearmonth</code></td>
      <td class="complete">CSV</td>
      <td class="complete">CSV</td>
    </tr><tr>
      <td><code>duration</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>geopoint</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr class="sub">
      <td><code>format ("default", "array", "object")</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>geojson</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr class="sub">
      <td><code>format ("default", "topojson")</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr><tr>
      <td><code>any</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr>
  </tbody>
</table>


## Field Constraints

The functions `dp_check_dataresource()` and `dp_check_field()` checks if a given
`data.frame` or vector is valid given the Data Resource or Field Descriptor. By
default these will also check any constraints of fields. The default CSV and
fixed width readers will not run these checks. 


<table>
  <thead>
    <tr><th>Property</th><th>Checking constraints</th><th>Getting</th><th>Setting</th></tr>
  </thead><tbody>
    <tr>
      <td><code>required</code></td>
      <td class="complete"><code>dp_check_field()</code>,
          <code>dp_check_dataresource(..., constraints = TRUE)</code> </td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr>
    <tr>
      <td><code>unique</code></td>
      <td class="complete"><code>dp_check_field()</code>,
          <code>dp_check_dataresource(..., constraints = TRUE)</code> </td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr>
    <tr>
      <td><code>minLength</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr>
    <tr>
      <td><code>maxLength</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr>
    <tr>
      <td><code>minimum</code></td>
      <td class="complete"><code>dp_check_field()</code>,
          <code>dp_check_dataresource(..., constraints = TRUE)</code> </td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr>
    <tr>
      <td><code>maximum</code></td>
      <td class="complete"><code>dp_check_field()</code>,
          <code>dp_check_dataresource(..., constraints = TRUE)</code> </td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr>
    <tr>
      <td><code>exclusiveMinimum</code></td>
      <td class="complete"><code>dp_check_field()</code>,
          <code>dp_check_dataresource(..., constraints = TRUE)</code> </td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr>
    <tr>
      <td><code>exclusiveMaximum</code></td>
      <td class="complete"><code>dp_check_field()</code>,
          <code>dp_check_dataresource(..., constraints = TRUE)</code> </td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr>
    <tr>
      <td><code>jsonSchema</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr>
    <tr>
      <td><code>pattern</code></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr>
    <tr>
      <td><code>enum</code></td>
      <td class="complete"><code>dp_check_field()</code>,
          <code>dp_check_dataresource(..., constraints = TRUE)</code> </td>
      <td class="incomplete"></td>
      <td class="incomplete"></td>
    </tr>
  </tbody>
</table>




