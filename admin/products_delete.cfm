<!--- /admin/products_delete.cfm --->
<cfparam name="form.product_id" default="0">

<cfif NOT val(form.product_id)>
  <cfabort>
</cfif>

<cftry>
  <cfquery datasource="#application.dsn#">
    DELETE FROM products
    WHERE product_id = <cfqueryparam value="#form.product_id#" cfsqltype="cf_sql_integer">
  </cfquery>
  <!--- Return empty string — HTMX outerHTML swap removes the row --->
  <cfcatch type="database">
    <cflog file="app_errors" text="products_delete.cfm error: #cfcatch.message#">
  </cfcatch>
</cftry>
