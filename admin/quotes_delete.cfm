<!--- /admin/quotes_delete.cfm --->
<cfparam name="form.quote_id" default="0">
<cfif NOT val(form.quote_id)><cfabort></cfif>
<cftry>
  <cfquery datasource="#application.dsn#">
    DELETE FROM quote_requests
    WHERE quote_id = <cfqueryparam value="#form.quote_id#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfcatch type="database">
    <cflog file="app_errors" text="quotes_delete.cfm error: #cfcatch.message#">
  </cfcatch>
</cftry>
