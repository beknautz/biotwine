<!--- /admin/categories_list.cfm --->
<cfinclude template="/includes/theme_loader.cfm">
<cfset request.layout    = "admin">
<cfset request.pageTitle = "Product Categories">
<cfset request.adminPage = "categories">

<cftry>
  <cfquery name="getCategories" datasource="#application.dsn#">
    SELECT c.category_id, c.slug, c.nav_label, c.eyebrow, c.heading, c.is_active, c.sort_order,
           (SELECT COUNT(*) FROM products p WHERE p.category = c.slug AND p.is_active = 1) AS product_count
    FROM   product_categories c
    ORDER  BY c.sort_order ASC
  </cfquery>
  <cfcatch type="database">
    <cflog file="app_errors" text="categories_list.cfm: #cfcatch.message#">
    <cfset getCategories = queryNew("category_id,slug,nav_label,eyebrow,heading,is_active,sort_order,product_count")>
  </cfcatch>
</cftry>

<cfinclude template="/themes/biotwine/layouts/admin_open.cfm">

<cfoutput>

<div class="admin-card">
  <div class="admin-card-header">
    <h2><i class="bi bi-tags me-2" style="color:var(--color-forest);"></i>Product Categories</h2>
    <a href="/admin/categories_form.cfm" class="btn btn-sm btn-primary">+ New Category</a>
  </div>

  <div style="padding:0.75rem 1.25rem; background:var(--bg-card-alt); border-bottom:1px solid var(--border-color); font-size:var(--font-size-sm); color:var(--text-muted);">
    Categories control the sections on the Products page — their names, descriptions, and display order. Products are assigned to categories individually.
  </div>

  <div style="overflow-x:auto;">
    <table class="admin-table">
      <thead>
        <tr>
          <th>Sort</th>
          <th>Nav Label</th>
          <th>Eyebrow / Heading</th>
          <th>Slug</th>
          <th>Products</th>
          <th>Active</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <cfif getCategories.recordCount GT 0>
          <cfloop query="getCategories">
          <tr id="catrow-#category_id#">
            <td style="color:var(--text-muted); font-size:var(--font-size-sm);">#sort_order#</td>
            <td><strong>#htmlEditFormat(nav_label)#</strong></td>
            <td>
              <span style="font-size:var(--font-size-xs); color:var(--text-muted); text-transform:uppercase; letter-spacing:0.08em;">#htmlEditFormat(eyebrow)#</span><br>
              #htmlEditFormat(heading)#
            </td>
            <td style="font-family:var(--font-mono); font-size:0.8rem; color:var(--text-muted);">#htmlEditFormat(slug)#</td>
            <td><span class="badge badge-secondary">#product_count#</span></td>
            <td>
              <cfif is_active>
                <span class="badge badge-success">Active</span>
              <cfelse>
                <span class="badge badge-danger">Inactive</span>
              </cfif>
            </td>
            <td style="white-space:nowrap;">
              <a href="/admin/categories_form.cfm?category_id=#category_id#" class="btn btn-sm btn-outline">Edit</a>
              <button
                class="btn btn-sm btn-danger"
                hx-post="/admin/categories_delete.cfm"
                hx-vals='{"category_id": "#category_id#"}'
                hx-target="##catrow-#category_id#"
                hx-swap="outerHTML swap:300ms"
                hx-confirm="Delete category '#htmlEditFormat(nav_label)#'? Products in this category will still exist but won't appear on the products page."
              >Delete</button>
            </td>
          </tr>
          </cfloop>
        <cfelse>
          <tr>
            <td colspan="7" style="text-align:center; color:var(--text-muted); padding:3rem;">
              No categories yet. <a href="/admin/categories_form.cfm">Add the first one.</a>
            </td>
          </tr>
        </cfif>
      </tbody>
    </table>
  </div>
</div>

</cfoutput>

<cfinclude template="/themes/biotwine/layouts/admin_close.cfm">
