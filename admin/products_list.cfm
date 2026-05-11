<!--- /admin/products_list.cfm --->
<cfinclude template="/includes/theme_loader.cfm">
<cfset request.layout    = "admin">
<cfset request.pageTitle = "Products">
<cfset request.adminPage = "products">

<cftry>
  <cfquery name="getProducts" datasource="#application.dsn#">
    SELECT product_id, category, name, item_number, badge, is_active, is_featured, sort_order
    FROM products
    ORDER BY sort_order ASC, name ASC
  </cfquery>
  <cfcatch type="database">
    <cflog file="app_errors" text="products_list.cfm: #cfcatch.message#">
    <cfset getProducts = queryNew("product_id,category,name,item_number,badge,is_active,is_featured,sort_order")>
  </cfcatch>
</cftry>

<cfinclude template="/themes/biotwine/layouts/admin_open.cfm">

<cfoutput>

<div class="admin-card">
  <div class="admin-card-header">
    <h2><i class="bi bi-box-seam me-2" style="color:var(--color-forest);"></i>Products</h2>
    <a href="/admin/products_form.cfm" class="btn btn-sm btn-primary">+ New Product</a>
  </div>

  <div style="overflow-x:auto;">
    <table class="admin-table">
      <thead>
        <tr>
          <th>Name</th>
          <th>Item ##</th>
          <th>Category</th>
          <th>Badge</th>
          <th>Featured</th>
          <th>Active</th>
          <th>Sort</th>
          <th></th>
        </tr>
      </thead>
      <tbody id="products-tbody">
        <cfif getProducts.recordCount GT 0>
          <cfloop query="getProducts">
          <tr id="row-#product_id#">
            <td><strong>#htmlEditFormat(name)#</strong></td>
            <td style="font-family:var(--font-mono); font-size:0.8rem;">#htmlEditFormat(item_number)#</td>
            <td><span class="badge badge-secondary">#htmlEditFormat(category)#</span></td>
            <td>
              <cfif len(trim(badge))>
                <span class="badge badge-success">#htmlEditFormat(badge)#</span>
              </cfif>
            </td>
            <td>
              <cfif is_featured>
                <span class="badge badge-success">Yes</span>
              <cfelse>
                <span class="badge badge-secondary">No</span>
              </cfif>
            </td>
            <td>
              <cfif is_active>
                <span class="badge badge-success">Active</span>
              <cfelse>
                <span class="badge badge-danger">Inactive</span>
              </cfif>
            </td>
            <td style="color:var(--text-muted); font-size:var(--font-size-sm);">#sort_order#</td>
            <td style="white-space:nowrap;">
              <a href="/admin/products_form.cfm?product_id=#product_id#" class="btn btn-sm btn-outline">Edit</a>
              <button
                class="btn btn-sm btn-danger"
                hx-post="/admin/products_delete.cfm"
                hx-vals='{"product_id": "#product_id#"}'
                hx-target="##row-#product_id#"
                hx-swap="outerHTML swap:300ms"
                hx-confirm="Delete product '#htmlEditFormat(name)#'? This cannot be undone."
              >Delete</button>
            </td>
          </tr>
          </cfloop>
        <cfelse>
          <tr>
            <td colspan="8" style="text-align:center; color:var(--text-muted); padding:3rem;">
              No products yet. <a href="/admin/products_form.cfm">Add the first one.</a>
            </td>
          </tr>
        </cfif>
      </tbody>
    </table>
  </div>
</div>

</cfoutput>

<cfinclude template="/themes/biotwine/layouts/admin_close.cfm">
