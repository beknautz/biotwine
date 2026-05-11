<cfparam name="form.page_id" default="0">

<cfif NOT val(form.page_id)>
    <cfabort>
</cfif>

<cftry>
    <cfquery datasource="#application.dsn#">
        DELETE FROM pages
        WHERE page_id = <cfqueryparam value="#form.page_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <!--- Return empty string — HTMX outerHTML swap removes the row --->
    <cfcatch type="database">
        <cflog file="app_errors" text="pages_delete.cfm DB error: #cfcatch.message# — #cfcatch.detail#">
    </cfcatch>
</cftry>
