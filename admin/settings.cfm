<!--- /admin/settings.cfm --->
<cfinclude template="/includes/theme_loader.cfm">
<cfset request.layout    = "admin">
<cfset request.pageTitle = "Site Settings">
<cfset request.adminPage = "settings">

<cftry>
  <cfquery name="getSettings" datasource="#application.dsn#">
    SELECT setting_key, setting_value FROM settings ORDER BY setting_key ASC
  </cfquery>
  <cfset s = {}>
  <cfloop query="getSettings">
    <cfset s[setting_key] = setting_value>
  </cfloop>
  <cfcatch type="database">
    <cfset s = {}>
  </cfcatch>
</cftry>

<!--- Defaults --->
<cfparam name="s.site_name"          default="BioTwine Manufacturing">
<cfparam name="s.site_tagline"       default="Twisted Paper Twine, Built for the Field.">
<cfparam name="s.contact_email"      default="info@biotwine.com">
<cfparam name="s.phone"              default="(509) 865-3340">
<cfparam name="s.address_line1"      default="210 South Division Street">
<cfparam name="s.address_line2"      default="P.O. Box 430">
<cfparam name="s.address_city_state" default="Toppenish, WA 98948">
<cfparam name="s.hours"              default="Monday–Friday: 8:00am–5:00pm">
<cfparam name="s.hero_heading"       default="">
<cfparam name="s.hero_subhead"       default="">
<cfparam name="s.hero_image"         default="">

<cfinclude template="/themes/biotwine/layouts/admin_open.cfm">

<cfoutput>

<div class="admin-card">
  <div class="admin-card-header">
    <h2><i class="bi bi-gear me-2" style="color:var(--text-muted);"></i>Site Settings</h2>
  </div>
  <div class="admin-card-body">

    <div id="form-messages"></div>

    <form
      hx-post="/admin/settings_save.cfm"
      hx-target="##form-messages"
      hx-swap="innerHTML"
      hx-indicator="##save-spinner"
      class="admin-form"
    >

      <h3 style="font-family:var(--font-body); font-size:var(--font-size-sm); letter-spacing:0.12em; text-transform:uppercase; color:var(--text-muted); margin:0 0 1rem; padding-bottom:0.5rem; border-bottom:1px solid var(--border-color);">General</h3>

      <div style="display:grid; grid-template-columns:1fr 1fr; gap:1.25rem; margin-bottom:1.75rem;">
        <div class="form-group">
          <label>Site Name</label>
          <input type="text" name="site_name" class="form-control" value="#htmlEditFormat(s.site_name)#">
        </div>
        <div class="form-group">
          <label>Site Tagline</label>
          <input type="text" name="site_tagline" class="form-control" value="#htmlEditFormat(s.site_tagline)#">
        </div>
      </div>

      <h3 style="font-family:var(--font-body); font-size:var(--font-size-sm); letter-spacing:0.12em; text-transform:uppercase; color:var(--text-muted); margin:0 0 1rem; padding-bottom:0.5rem; border-bottom:1px solid var(--border-color);">Homepage Hero</h3>

      <div style="display:grid; grid-template-columns:1fr; gap:1.25rem; margin-bottom:1.75rem;">
        <div class="form-group">
          <label>Hero Heading</label>
          <input type="text" name="hero_heading" class="form-control" value="#htmlEditFormat(s.hero_heading)#" placeholder="Twisted Paper Twine, Built for the Field.">
        </div>
        <div class="form-group">
          <label>Hero Subheading</label>
          <textarea name="hero_subhead" class="form-control" rows="3">#htmlEditFormat(s.hero_subhead)#</textarea>
        </div>
        <div class="form-group">
          <label>Hero Background Image</label>
          <div style="display:flex; gap:0.5rem; align-items:center;">
            <input type="text" name="hero_image" id="hero_image_field" class="form-control"
              value="#htmlEditFormat(s.hero_image)#" placeholder="/assets/uploads/hero/home-hero.jpg">
            <label class="btn btn-outline" style="cursor:pointer; white-space:nowrap; margin:0; padding:0.45rem 0.75rem;">
              Upload
              <input type="file" accept="image/jpeg,image/png,image/gif,image/webp" style="display:none;"
                onchange="btUploadImage(this,'hero_image_field','hero_image_preview','hero')">
            </label>
          </div>
          <div id="hero_image_preview" style="margin-top:0.5rem;">
            <cfif len(trim(s.hero_image))>
              <img src="#htmlEditFormat(s.hero_image)#"
                style="max-height:72px; border-radius:4px; border:1px solid var(--border-color);"
                onerror="this.style.display='none'">
            </cfif>
          </div>
        </div>
      </div>

      <h3 style="font-family:var(--font-body); font-size:var(--font-size-sm); letter-spacing:0.12em; text-transform:uppercase; color:var(--text-muted); margin:0 0 1rem; padding-bottom:0.5rem; border-bottom:1px solid var(--border-color);">Contact Information</h3>

      <div style="display:grid; grid-template-columns:1fr 1fr; gap:1.25rem; margin-bottom:1.75rem;">
        <div class="form-group">
          <label>Contact Email</label>
          <input type="email" name="contact_email" class="form-control" value="#htmlEditFormat(s.contact_email)#">
        </div>
        <div class="form-group">
          <label>Phone</label>
          <input type="text" name="phone" class="form-control" value="#htmlEditFormat(s.phone)#">
        </div>
        <div class="form-group">
          <label>Address Line 1</label>
          <input type="text" name="address_line1" class="form-control" value="#htmlEditFormat(s.address_line1)#">
        </div>
        <div class="form-group">
          <label>Address Line 2</label>
          <input type="text" name="address_line2" class="form-control" value="#htmlEditFormat(s.address_line2)#">
        </div>
        <div class="form-group">
          <label>City, State, ZIP</label>
          <input type="text" name="address_city_state" class="form-control" value="#htmlEditFormat(s.address_city_state)#">
        </div>
        <div class="form-group">
          <label>Business Hours</label>
          <input type="text" name="hours" class="form-control" value="#htmlEditFormat(s.hours)#">
        </div>
      </div>

      <div style="display:flex; gap:1rem; align-items:center;">
        <button type="submit" class="btn btn-primary">
          <span id="save-spinner" class="htmx-indicator me-1">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" style="animation:spin 1s linear infinite; vertical-align:middle;"><path d="M12 2a10 10 0 0 1 10 10"/></svg>
          </span>
          Save Settings
        </button>
      </div>

    </form>
  </div>
</div>

<style>@keyframes spin { to { transform:rotate(360deg); } }</style>

</cfoutput>

<cfinclude template="/themes/biotwine/layouts/admin_close.cfm">

<!--- btUploadImage provided by admin.js --->
