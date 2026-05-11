<!--- /admin/products_form.cfm --->
<cfinclude template="/includes/theme_loader.cfm">
<cfparam name="url.product_id" default="0">

<cfset isNew = NOT val(url.product_id)>
<cfset request.layout    = "admin">
<cfset request.pageTitle = "#iif(isNew,de('New Product'),de('Edit Product'))#">
<cfset request.adminPage = "products">

<cfif NOT isNew>
  <cftry>
    <cfquery name="getRecord" datasource="#application.dsn#">
      SELECT * FROM products
      WHERE product_id = <cfqueryparam value="#url.product_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getRecord.recordCount EQ 0>
      <cflocation url="/admin/products_list.cfm" addtoken="false">
    </cfif>
    <cfcatch type="database">
      <cflocation url="/admin/products_list.cfm" addtoken="false">
    </cfcatch>
  </cftry>
</cfif>

<!--- Defaults for new record --->
<cfparam name="getRecord.product_id"  default="0">
<cfparam name="getRecord.category"    default="hop">
<cfparam name="getRecord.name"        default="">
<cfparam name="getRecord.item_number" default="">
<cfparam name="getRecord.description" default="">
<cfparam name="getRecord.specs"       default="">
<cfparam name="getRecord.image"       default="">
<cfparam name="getRecord.badge"       default="">
<cfparam name="getRecord.is_active"   default="1">
<cfparam name="getRecord.is_featured" default="0">
<cfparam name="getRecord.sort_order"  default="0">

<cfinclude template="/themes/biotwine/layouts/admin_open.cfm">

<cfoutput>

<div style="margin-bottom:1rem;">
  <a href="/admin/products_list.cfm" style="font-size:var(--font-size-sm); color:var(--text-muted);">&larr; Back to Products</a>
</div>

<div class="admin-card">
  <div class="admin-card-header">
    <h2><cfif isNew>New Product<cfelse>Edit: #htmlEditFormat(getRecord.name)#</cfif></h2>
  </div>
  <div class="admin-card-body">

    <div id="form-messages"></div>

    <form
      hx-post="/admin/products_save.cfm"
      hx-target="##form-messages"
      hx-swap="innerHTML"
      hx-indicator="##save-spinner"
      class="admin-form"
    >
      <input type="hidden" name="product_id" value="#getRecord.product_id#">

      <div style="display:grid; grid-template-columns:1fr 1fr; gap:1.25rem;">

        <div class="form-group" style="grid-column:1/-1;">
          <label>Product Name *</label>
          <input type="text" name="name" class="form-control" value="#htmlEditFormat(getRecord.name)#" required placeholder="e.g. MAX Hop Twine">
        </div>

        <div class="form-group">
          <label>Item Number</label>
          <input type="text" name="item_number" class="form-control" value="#htmlEditFormat(getRecord.item_number)#" placeholder="e.g. BT-120">
        </div>

        <div class="form-group">
          <label>Category *</label>
          <select name="category" class="form-control">
            <option value="hop"    <cfif getRecord.category EQ "hop">selected</cfif>>Hop Twine</option>
            <option value="handle" <cfif getRecord.category EQ "handle">selected</cfif>>Handle Bag Twine</option>
            <option value="other"  <cfif getRecord.category EQ "other">selected</cfif>>Arching &amp; Other</option>
          </select>
        </div>

        <div class="form-group" style="grid-column:1/-1;">
          <label>Description</label>
          <textarea name="description" class="form-control" rows="4" placeholder="Product description visible on products page...">#htmlEditFormat(getRecord.description)#</textarea>
        </div>

        <div class="form-group" style="grid-column:1/-1;">
          <label>Specifications (optional — one per line, e.g. "Weight: 12 lb")</label>
          <textarea name="specs" class="form-control" rows="5" placeholder="Tensile Strength: Diameter: 2mm;Roll Length: 4,000 ft">#htmlEditFormat(getRecord.specs)#</textarea>
        </div>

        <div class="form-group">
          <label>Badge Label (optional)</label>
          <input type="text" name="badge" class="form-control" value="#htmlEditFormat(getRecord.badge)#" placeholder="e.g. Most Popular, FSC Certified">
        </div>

        <div class="form-group">
          <label>Product Image</label>
          <div style="display:flex; gap:0.5rem; align-items:center;">
            <input type="text" name="image" id="prod_image_field" class="form-control"
              value="#htmlEditFormat(getRecord.image)#" placeholder="product-name.jpg">
            <label class="btn btn-outline" style="cursor:pointer; white-space:nowrap; margin:0; padding:0.45rem 0.75rem;">
              Upload
              <input type="file" accept="image/jpeg,image/png,image/gif,image/webp" style="display:none;"
                onchange="btUploadImage(this,'prod_image_field','prod_image_preview','products')">
            </label>
          </div>
          <div id="prod_image_preview" style="margin-top:0.5rem;">
            <cfif len(trim(getRecord.image))>
              <cfif left(trim(getRecord.image),1) EQ "/">
                <cfset prevSrc = trim(getRecord.image)>
              <cfelse>
                <cfset prevSrc = "/assets/uploads/products/" & trim(getRecord.image)>
              </cfif>
              <img src="#htmlEditFormat(prevSrc)#"
                style="max-height:72px; border-radius:4px; border:1px solid var(--border-color);"
                onerror="this.style.display='none'">
            </cfif>
          </div>
        </div>

        <div class="form-group">
          <label>Sort Order</label>
          <input type="number" name="sort_order" class="form-control" value="#val(getRecord.sort_order)#" min="0">
        </div>

        <div class="form-group" style="display:flex; gap:1.5rem; align-items:center; padding-top:1.5rem;">
          <label style="display:flex; align-items:center; gap:0.5rem; cursor:pointer; font-weight:400;">
            <input type="hidden" name="is_active" value="0">
            <input type="checkbox" name="is_active" value="1" <cfif getRecord.is_active>checked</cfif> style="width:16px;height:16px;">
            Active (show on site)
          </label>
          <label style="display:flex; align-items:center; gap:0.5rem; cursor:pointer; font-weight:400;">
            <input type="hidden" name="is_featured" value="0">
            <input type="checkbox" name="is_featured" value="1" <cfif getRecord.is_featured>checked</cfif> style="width:16px;height:16px;">
            Featured on homepage
          </label>
        </div>

      </div>

      <div style="margin-top:1.5rem; display:flex; gap:1rem; align-items:center;">
        <button type="submit" class="btn btn-primary">
          <span id="save-spinner" class="htmx-indicator me-1">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" style="animation:spin 1s linear infinite; vertical-align:middle;"><path d="M12 2a10 10 0 0 1 10 10"/></svg>
          </span>
          Save Product
        </button>
        <a href="/admin/products_list.cfm" class="btn btn-outline">Cancel</a>
      </div>

    </form>

  </div>
</div>

<style>@keyframes spin { to { transform:rotate(360deg); } }</style>

</cfoutput>

<cfinclude template="/themes/biotwine/layouts/admin_close.cfm">
