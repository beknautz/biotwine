<!--- contact_save.cfm — HTMX POST handler for quote request form --->
<cfparam name="form.first_name"       default="">
<cfparam name="form.last_name"        default="">
<cfparam name="form.company"          default="">
<cfparam name="form.email"            default="">
<cfparam name="form.phone"            default="">
<cfparam name="form.product_interest" default="">
<cfparam name="form.message"          default="">

<!--- Basic validation --->
<cfif NOT len(trim(form.first_name)) OR NOT len(trim(form.last_name)) OR NOT len(trim(form.email))>
  <div class="alert alert-danger">Please fill in all required fields (First Name, Last Name, Email).</div>
  <cfabort>
</cfif>

<cfif NOT isValid("email", trim(form.email))>
  <div class="alert alert-danger">Please enter a valid email address.</div>
  <cfabort>
</cfif>

<cftry>
  <cfquery datasource="#application.dsn#">
    INSERT INTO quote_requests (first_name, last_name, company, email, phone, product_interest, message, submitted_at)
    VALUES (
      <cfqueryparam value="#trim(form.first_name)#"       cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#trim(form.last_name)#"        cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#trim(form.company)#"          cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#trim(form.email)#"            cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#trim(form.phone)#"            cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#trim(form.product_interest)#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#trim(form.message)#"          cfsqltype="cf_sql_varchar">,
      NOW()
    )
  </cfquery>

  <!--- Send notification email (adjust address as needed) --->
  <cftry>
    <cfmail
      to="info@biotwine.com"
      from="noreply@biotwine.com"
      subject="New Quote Request from #trim(form.first_name)# #trim(form.last_name)# — BioTwine.com"
      type="text"
    >
New quote request submitted on BioTwine.com.

Name:    #trim(form.first_name)# #trim(form.last_name)#
Company: #trim(form.company)#
Email:   #trim(form.email)#
Phone:   #trim(form.phone)#
Product: #trim(form.product_interest)#

Message:
#trim(form.message)#

---
Review in admin: https://biotwine.com/admin/quotes_list.cfm
    </cfmail>
    <cfcatch type="any">
      <!--- Email failure is non-fatal — log but don't expose error --->
      <cflog file="app_errors" text="Quote email send failed: #cfcatch.message#">
    </cfcatch>
  </cftry>

  <div class="alert alert-success" style="font-size:var(--font-size-base); padding:1.25rem 1.5rem;">
    <strong style="display:block; margin-bottom:0.4rem;">Thank you, #htmlEditFormat(trim(form.first_name))#!</strong>
    Your quote request has been received. A member of our team will be in touch within 1–2 business days.
  </div>

  <cfcatch type="database">
    <cflog file="app_errors" text="contact_save.cfm DB error: #cfcatch.message# — #cfcatch.detail#">
    <div class="alert alert-danger">An error occurred saving your request. Please call us directly at (509) 865-3340.</div>
  </cfcatch>
</cftry>
