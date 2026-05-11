<!--- /admin/testimonials_list.cfm --->
<cfinclude template="/includes/theme_loader.cfm">
<cfset request.layout    = "admin">
<cfset request.pageTitle = "Testimonials">
<cfset request.adminPage = "testimonials">

<cftry>
  <cfquery name="getTestimonials" datasource="#application.dsn#">
    SELECT testimonial_id, company, location, years_partner, is_active, sort_order,
           LEFT(quote, 80) AS quote_preview
    FROM testimonials
    ORDER BY sort_order ASC, created_at DESC
  </cfquery>
  <cfcatch type="database">
    <cfset getTestimonials = queryNew("testimonial_id,company,location,years_partner,is_active,sort_order,quote_preview")>
  </cfcatch>
</cftry>

<cfinclude template="/themes/biotwine/layouts/admin_open.cfm">

<cfoutput>

<div class="admin-card">
  <div class="admin-card-header">
    <h2><i class="bi bi-chat-quote me-2" style="color:var(--color-meadow);"></i>Testimonials</h2>
    <a href="/admin/testimonials_form.cfm" class="btn btn-sm btn-primary">+ New Testimonial</a>
  </div>
  <div style="overflow-x:auto;">
    <table class="admin-table">
      <thead>
        <tr><th>Company</th><th>Location</th><th>Preview</th><th>Active</th><th>Sort</th><th></th></tr>
      </thead>
      <tbody>
        <cfif getTestimonials.recordCount GT 0>
          <cfloop query="getTestimonials">
          <tr id="row-#testimonial_id#">
            <td><strong>#htmlEditFormat(company)#</strong></td>
            <td>#htmlEditFormat(location)#</td>
            <td style="font-size:var(--font-size-sm); color:var(--text-muted); font-style:italic;">&ldquo;#htmlEditFormat(quote_preview)#&hellip;&rdquo;</td>
            <td><cfif is_active><span class="badge badge-success">Yes</span><cfelse><span class="badge badge-secondary">No</span></cfif></td>
            <td style="font-size:var(--font-size-sm); color:var(--text-muted);">#sort_order#</td>
            <td style="white-space:nowrap;">
              <a href="/admin/testimonials_form.cfm?testimonial_id=#testimonial_id#" class="btn btn-sm btn-outline">Edit</a>
              <button
                class="btn btn-sm btn-danger"
                hx-post="/admin/testimonials_delete.cfm"
                hx-vals='{"testimonial_id": "#testimonial_id#"}'
                hx-target="##row-#testimonial_id#"
                hx-swap="outerHTML swap:300ms"
                hx-confirm="Delete this testimonial?"
              >Delete</button>
            </td>
          </tr>
          </cfloop>
        <cfelse>
          <tr><td colspan="6" style="text-align:center; color:var(--text-muted); padding:3rem;">No testimonials yet.</td></tr>
        </cfif>
      </tbody>
    </table>
  </div>
</div>

</cfoutput>

<cfinclude template="/themes/biotwine/layouts/admin_close.cfm">
