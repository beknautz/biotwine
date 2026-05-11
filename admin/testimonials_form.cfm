<!--- /admin/testimonials_form.cfm --->
<cfinclude template="/includes/theme_loader.cfm">
<cfparam name="url.testimonial_id" default="0">
<cfset isNew = NOT val(url.testimonial_id)>
<cfset request.layout    = "admin">
<cfset request.pageTitle = "#iif(isNew,de('New Testimonial'),de('Edit Testimonial'))#">
<cfset request.adminPage = "testimonials">

<cfif NOT isNew>
  <cftry>
    <cfquery name="getRecord" datasource="#application.dsn#">
      SELECT * FROM testimonials
      WHERE testimonial_id = <cfqueryparam value="#url.testimonial_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getRecord.recordCount EQ 0><cflocation url="/admin/testimonials_list.cfm" addtoken="false"></cfif>
    <cfcatch type="database"><cflocation url="/admin/testimonials_list.cfm" addtoken="false"></cfcatch>
  </cftry>
</cfif>

<cfparam name="getRecord.testimonial_id" default="0">
<cfparam name="getRecord.quote"          default="">
<cfparam name="getRecord.company"        default="">
<cfparam name="getRecord.location"       default="">
<cfparam name="getRecord.years_partner"  default="">
<cfparam name="getRecord.is_active"      default="1">
<cfparam name="getRecord.sort_order"     default="0">

<cfinclude template="/themes/biotwine/layouts/admin_open.cfm">

<!--- Summernote CSS --->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-bs5.min.css">

<cfoutput>
<div style="margin-bottom:1rem;"><a href="/admin/testimonials_list.cfm" style="font-size:var(--font-size-sm); color:var(--text-muted);">&larr; Back to Testimonials</a></div>

<div class="admin-card">
  <div class="admin-card-header">
    <h2><cfif isNew>New Testimonial<cfelse>Edit Testimonial</cfif></h2>
  </div>
  <div class="admin-card-body">
    <div id="form-messages"></div>
    <form hx-post="/admin/testimonials_save.cfm" hx-target="##form-messages" hx-swap="innerHTML" hx-indicator="##save-spinner" class="admin-form">
      <input type="hidden" name="testimonial_id" value="#getRecord.testimonial_id#">

      <div class="form-group" style="margin-bottom:1.25rem;">
        <label>Quote / Testimonial *</label>
        <div style="font-size:0.75rem; color:var(--text-muted); margin-bottom:0.4rem;">
          You can include images (e.g. a farm logo) using the image insert button in the toolbar.
        </div>
        <textarea name="quote" id="testimonial_quote" class="form-control" required>#getRecord.quote#</textarea>
      </div>

      <div style="display:grid; grid-template-columns:1fr 1fr; gap:1.25rem;">
        <div class="form-group">
          <label>Company *</label>
          <input type="text" name="company" class="form-control" value="#htmlEditFormat(getRecord.company)#" required placeholder="Perrault Farms">
        </div>
        <div class="form-group">
          <label>Location</label>
          <input type="text" name="location" class="form-control" value="#htmlEditFormat(getRecord.location)#" placeholder="Yakima Valley, WA">
        </div>
        <div class="form-group">
          <label>Years Partnership (optional)</label>
          <input type="text" name="years_partner" class="form-control" value="#htmlEditFormat(getRecord.years_partner)#" placeholder="35 years">
        </div>
        <div class="form-group">
          <label>Sort Order</label>
          <input type="number" name="sort_order" class="form-control" value="#val(getRecord.sort_order)#" min="0">
        </div>
      </div>

      <div class="form-group" style="margin-top:0.75rem;">
        <label style="display:flex; align-items:center; gap:0.5rem; cursor:pointer; font-weight:400;">
          <input type="hidden" name="is_active" value="0">
          <input type="checkbox" name="is_active" value="1" <cfif getRecord.is_active>checked</cfif> style="width:16px;height:16px;">
          Active (show on site)
        </label>
      </div>

      <div style="margin-top:1.5rem; display:flex; gap:1rem;">
        <button type="submit" class="btn btn-primary">
          <span id="save-spinner" class="htmx-indicator me-1"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" style="animation:spin 1s linear infinite; vertical-align:middle;"><path d="M12 2a10 10 0 0 1 10 10"/></svg></span>
          Save
        </button>
        <a href="/admin/testimonials_list.cfm" class="btn btn-outline">Cancel</a>
      </div>
    </form>
  </div>
</div>
<style>@keyframes spin { to { transform:rotate(360deg); } }</style>
</cfoutput>

<cfinclude template="/themes/biotwine/layouts/admin_close.cfm">

<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-bs5.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {

  var $quote = jQuery('#testimonial_quote');
  $quote.summernote({
    height: 260,
    placeholder: 'Enter testimonial text. Use the image button to embed a logo.',
    toolbar: [
      ['style',  ['bold', 'italic', 'underline', 'clear']],
      ['para',   ['ul', 'ol']],
      ['insert', ['link', 'picture', 'hr']],
      ['view',   ['codeview']]
    ]
  });

  document.querySelector('form').addEventListener('htmx:configRequest', function (e) {
    e.detail.parameters['quote'] = $quote.summernote('code');
  });

});
</script>
