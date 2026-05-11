<!--- /admin/news_delete.cfm --->
<cfparam name="form.news_id" default="0">
<cfif NOT val(form.news_id)><cfabort></cfif>
<cftry>
  <cfquery datasource="#application.dsn#">
    DELETE FROM news
    WHERE news_id = <cfqueryparam value="#form.news_id#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfcatch type="database">
    <cflog file="app_errors" text="news_delete.cfm error: #cfcatch.message#">
  </cfcatch>
</cftry>
