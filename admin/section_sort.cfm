<!--- admin/section_sort.cfm — move section up or down and return updated list --->
<cfinclude template="/includes/theme_loader.cfm">

<cfparam name="form.section_id" default="0">
<cfparam name="form.direction"  default="up">
<cfparam name="form.page_slug"  default="home">

<cfset pageSlug  = lCase(trim(form.page_slug))>
<cfset sectionId = val(form.section_id)>

<!--- Get current sort_order --->
<cfquery name="getCurrent" datasource="#application.dsn#">
  SELECT sort_order FROM page_sections
  WHERE  section_id = <cfqueryparam value="#sectionId#" cfsqltype="cf_sql_integer">
  AND    page_slug  = <cfqueryparam value="#pageSlug#"  cfsqltype="cf_sql_varchar">
</cfquery>

<cfif getCurrent.recordCount>
  <cfset curSort = getCurrent.sort_order>

  <cfif form.direction EQ "up">
    <!--- Find next lower sort_order --->
    <cfquery name="getSwap" datasource="#application.dsn#">
      SELECT section_id, sort_order FROM page_sections
      WHERE  page_slug  = <cfqueryparam value="#pageSlug#" cfsqltype="cf_sql_varchar">
      AND    sort_order < <cfqueryparam value="#curSort#"  cfsqltype="cf_sql_integer">
      ORDER  BY sort_order DESC LIMIT 1
    </cfquery>
  <cfelse>
    <!--- Find next higher sort_order --->
    <cfquery name="getSwap" datasource="#application.dsn#">
      SELECT section_id, sort_order FROM page_sections
      WHERE  page_slug  = <cfqueryparam value="#pageSlug#" cfsqltype="cf_sql_varchar">
      AND    sort_order > <cfqueryparam value="#curSort#"  cfsqltype="cf_sql_integer">
      ORDER  BY sort_order ASC LIMIT 1
    </cfquery>
  </cfif>

  <cfif getSwap.recordCount>
    <cfset swapSort = getSwap.sort_order>
    <cfset swapId   = getSwap.section_id>
    <!--- Swap the two sort_order values --->
    <cfquery datasource="#application.dsn#">
      UPDATE page_sections SET sort_order = <cfqueryparam value="#swapSort#" cfsqltype="cf_sql_integer">
      WHERE  section_id = <cfqueryparam value="#sectionId#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfquery datasource="#application.dsn#">
      UPDATE page_sections SET sort_order = <cfqueryparam value="#curSort#" cfsqltype="cf_sql_integer">
      WHERE  section_id = <cfqueryparam value="#swapId#" cfsqltype="cf_sql_integer">
    </cfquery>
  </cfif>
</cfif>

<cfinclude template="/admin/_section_list_partial.cfm">
