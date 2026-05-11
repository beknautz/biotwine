<!--- admin/section_delete.cfm — delete a page section and return updated list --->
<cfinclude template="/includes/theme_loader.cfm">

<cfparam name="form.section_id" default="0">
<cfparam name="form.page_slug"  default="home">

<cfset pageSlug = lCase(trim(form.page_slug))>

<cftry>
  <cfquery datasource="#application.dsn#">
    DELETE FROM page_sections
    WHERE section_id = <cfqueryparam value="#val(form.section_id)#" cfsqltype="cf_sql_integer">
  </cfquery>

  <!--- Resequence sort_order --->
  <cfquery name="getRemainder" datasource="#application.dsn#">
    SELECT section_id FROM page_sections
    WHERE  page_slug = <cfqueryparam value="#pageSlug#" cfsqltype="cf_sql_varchar">
    ORDER  BY sort_order ASC
  </cfquery>
  <cfloop query="getRemainder" index="rowNum">
    <cfquery datasource="#application.dsn#">
      UPDATE page_sections SET sort_order = #getRemainder.currentRow#
      WHERE  section_id = <cfqueryparam value="#getRemainder.section_id#" cfsqltype="cf_sql_integer">
    </cfquery>
  </cfloop>

  <cfcatch type="database">
    <cflog file="app_errors" text="section_delete: #cfcatch.message#">
  </cfcatch>
</cftry>

<cfinclude template="/admin/_section_list_partial.cfm">
