<!--- /admin/settings_save.cfm — HTMX POST handler --->
<cfparam name="form.site_name"          default="">
<cfparam name="form.site_tagline"       default="">
<cfparam name="form.contact_email"      default="">
<cfparam name="form.phone"              default="">
<cfparam name="form.address_line1"      default="">
<cfparam name="form.address_line2"      default="">
<cfparam name="form.address_city_state" default="">
<cfparam name="form.hours"              default="">
<cfparam name="form.hero_heading"       default="">
<cfparam name="form.hero_subhead"       default="">
<cfparam name="form.hero_image"         default="">

<cfset settingsToSave = {
  "site_name":          trim(form.site_name),
  "site_tagline":       trim(form.site_tagline),
  "contact_email":      trim(form.contact_email),
  "phone":              trim(form.phone),
  "address_line1":      trim(form.address_line1),
  "address_line2":      trim(form.address_line2),
  "address_city_state": trim(form.address_city_state),
  "hours":              trim(form.hours),
  "hero_heading":       trim(form.hero_heading),
  "hero_subhead":       trim(form.hero_subhead),
  "hero_image":         trim(form.hero_image)
}>

<cftry>
  <cfloop collection="#settingsToSave#" item="local.sKey">
    <cfquery datasource="#application.dsn#">
      INSERT INTO settings (setting_key, setting_value)
      VALUES (
        <cfqueryparam value="#local.sKey#"                  cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#settingsToSave[local.sKey]#"  cfsqltype="cf_sql_varchar">
      )
      ON DUPLICATE KEY UPDATE
        setting_value = <cfqueryparam value="#settingsToSave[local.sKey]#" cfsqltype="cf_sql_varchar">
    </cfquery>
  </cfloop>

  <div class="alert alert-success">Settings saved successfully.</div>

  <cfcatch type="database">
    <cflog file="app_errors" text="settings_save.cfm error: #cfcatch.message# — #cfcatch.detail#">
    <div class="alert alert-danger">An error occurred saving settings. Please try again.</div>
  </cfcatch>
</cftry>
