<!--- /admin/categories_delete.cfm — HTMX POST handler --->
<cfparam name="form.category_id" default="0">

<cfif NOT val(form.category_id)>
  <cfabort>
</cfif>

<cftry>
  <cfquery datasource="#application.dsn#">
    DELETE FROM product_categories
    WHERE category_id = <cfqueryparam value="#form.category_id#" cfsqltype="cf_sql_integer">
  </cfquery>
  <!--- Return empty string — HTMX removes the row via outerHTML swap --->
  <cfcatch type="database">
    <cflog file="app_errors" text="categories_delete.cfm: #cfcatch.message#">
    <cfoutput>
    <tr id="catrow-#htmlEditFormat(form.category_id)#">
      <td colspan="7" style="color:var(--color-danger); padding:0.75rem 1rem;">Delete failed. Please try again.</td>
    </tr>
    </cfoutput>
  </cfcatch>
</cftry>
