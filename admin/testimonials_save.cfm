<!--- /admin/testimonials_save.cfm --->
<cfparam name="form.testimonial_id" default="0">
<cfparam name="form.quote"          default="">
<cfparam name="form.company"        default="">
<cfparam name="form.location"       default="">
<cfparam name="form.years_partner"  default="">
<cfparam name="form.is_active"      default="0">
<cfparam name="form.sort_order"     default="0">

<cfif NOT len(trim(form.quote)) OR NOT len(trim(form.company))>
  <div class="alert alert-danger">Quote and Company are required.</div>
  <cfabort>
</cfif>

<cftry>
  <cfif val(form.testimonial_id)>
    <cfquery datasource="#application.dsn#">
      UPDATE testimonials SET
        quote         = <cfqueryparam value="#trim(form.quote)#"         cfsqltype="cf_sql_varchar">,
        company       = <cfqueryparam value="#trim(form.company)#"       cfsqltype="cf_sql_varchar">,
        location      = <cfqueryparam value="#trim(form.location)#"      cfsqltype="cf_sql_varchar">,
        years_partner = <cfqueryparam value="#trim(form.years_partner)#" cfsqltype="cf_sql_varchar">,
        is_active     = <cfqueryparam value="#form.is_active#"           cfsqltype="cf_sql_bit">,
        sort_order    = <cfqueryparam value="#val(form.sort_order)#"     cfsqltype="cf_sql_integer">,
        updated_at    = NOW()
      WHERE testimonial_id = <cfqueryparam value="#form.testimonial_id#" cfsqltype="cf_sql_integer">
    </cfquery>
  <cfelse>
    <cfquery datasource="#application.dsn#">
      INSERT INTO testimonials (quote, company, location, years_partner, is_active, sort_order, created_at, updated_at)
      VALUES (
        <cfqueryparam value="#trim(form.quote)#"         cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.company)#"       cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.location)#"      cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.years_partner)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#form.is_active#"           cfsqltype="cf_sql_bit">,
        <cfqueryparam value="#val(form.sort_order)#"     cfsqltype="cf_sql_integer">,
        NOW(), NOW()
      )
    </cfquery>
  </cfif>
  <div class="alert alert-success">Testimonial saved. <a href="/admin/testimonials_list.cfm" style="font-weight:600;">Back to list &rarr;</a></div>
  <cfcatch type="database">
    <cflog file="app_errors" text="testimonials_save.cfm: #cfcatch.message#">
    <div class="alert alert-danger">A database error occurred. Please try again.</div>
  </cfcatch>
</cftry>
