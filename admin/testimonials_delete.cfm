<!--- /admin/testimonials_delete.cfm --->
<cfparam name="form.testimonial_id" default="0">
<cfif NOT val(form.testimonial_id)><cfabort></cfif>
<cftry>
  <cfquery datasource="#application.dsn#">
    DELETE FROM testimonials
    WHERE testimonial_id = <cfqueryparam value="#form.testimonial_id#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfcatch type="database">
    <cflog file="app_errors" text="testimonials_delete.cfm: #cfcatch.message#">
  </cfcatch>
</cftry>
