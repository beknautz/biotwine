<!--- /admin/categories_form.cfm --->
<cfinclude template="/includes/theme_loader.cfm">
<cfparam name="url.category_id" default="0">

<cfset isNew = NOT val(url.category_id)>
<cfset request.layout    = "admin">
<cfset request.pageTitle = "#iif(isNew,de('New Category'),de('Edit Category'))#">
<cfset request.adminPage = "categories">

<cfif NOT isNew>
  <cftry>
    <cfquery name="getRecord" datasource="#application.dsn#">
      SELECT * FROM product_categories
      WHERE  category_id = <cfqueryparam value="#url.category_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getRecord.recordCount EQ 0>
      <cflocation url="/admin/categories_list.cfm" addtoken="false">
    </cfif>
    <cfcatch type="database">
      <cflocation url="/admin/categories_list.cfm" addtoken="false">
    </cfcatch>
  </cftry>
</cfif>

<cfparam name="getRecord.category_id"  default="0">
<cfparam name="getRecord.slug"         default="">
<cfparam name="getRecord.nav_label"    default="">
<cfparam name="getRecord.eyebrow"      default="">
<cfparam name="getRecord.heading"      default="">
<cfparam name="getRecord.description"  default="">
<cfparam name="getRecord.section_alt"  default="0">
<cfparam name="getRecord.is_active"    default="1">
<cfparam name="getRecord.sort_order"   default="0">

<cfinclude template="/themes/biotwine/layouts/admin_open.cfm">

<cfoutput>

<div style="margin-bottom:1rem;">
  <a href="/admin/categories_list.cfm" style="font-size:var(--font-size-sm); color:var(--text-muted);">&larr; Back to Categories</a>
</div>

<div class="admin-card">
  <div class="admin-card-header">
    <h2><cfif isNew>New Category<cfelse>Edit: #htmlEditFormat(getRecord.nav_label)#</cfif></h2>
  </div>
  <div class="admin-card-body">

    <div id="form-messages"></div>

    <form
      hx-post="/admin/categories_save.cfm"
      hx-target="##form-messages"
      hx-swap="innerHTML"
      hx-indicator="##save-spinner"
      class="admin-form"
    >
      <input type="hidden" name="category_id" value="#getRecord.category_id#">

      <div style="display:grid; grid-template-columns:1fr 1fr; gap:1.25rem;">

        <div class="form-group" style="grid-column:1/-1;">
          <label>Nav Label * <span style="font-weight:400; color:var(--text-muted);">— appears in the sticky tab bar on the Products page</span></label>
          <input type="text" name="nav_label" class="form-control" value="#htmlEditFormat(getRecord.nav_label)#" required placeholder="e.g. Hop Twine">
        </div>

        <div class="form-group">
          <label>Slug * <span style="font-weight:400; color:var(--text-muted);">— must match the <code>category</code> value on products</span></label>
          <input type="text" name="slug" class="form-control" value="#htmlEditFormat(getRecord.slug)#" required
            placeholder="hop" style="font-family:var(--font-mono);"
            <cfif NOT isNew>readonly title="Slug cannot be changed after creation — it links products to this category."</cfif>>
          <cfif NOT isNew>
            <div style="font-size:0.75rem; color:var(--text-muted); margin-top:0.3rem;">Slug is locked after creation to preserve product assignments.</div>
          </cfif>
        </div>

        <div class="form-group">
          <label>Sort Order</label>
          <input type="number" name="sort_order" class="form-control" value="#val(getRecord.sort_order)#" min="0">
        </div>

        <div class="form-group">
          <label>Eyebrow <span style="font-weight:400; color:var(--text-muted);">— small label above the section heading</span></label>
          <input type="text" name="eyebrow" class="form-control" value="#htmlEditFormat(getRecord.eyebrow)#" placeholder="e.g. Hop Industry">
        </div>

        <div class="form-group">
          <label>Section Heading</label>
          <input type="text" name="heading" class="form-control" value="#htmlEditFormat(getRecord.heading)#" placeholder="e.g. Hop Twine">
        </div>

        <div class="form-group" style="grid-column:1/-1;">
          <label>Description <span style="font-weight:400; color:var(--text-muted);">— shown below the section heading</span></label>
          <textarea name="description" class="form-control" rows="3" placeholder="Brief description of this product category...">#htmlEditFormat(getRecord.description)#</textarea>
        </div>

        <div class="form-group" style="display:flex; gap:2rem; align-items:center; padding-top:0.5rem;">
          <label style="display:flex; align-items:center; gap:0.5rem; cursor:pointer; font-weight:400;">
            <input type="hidden" name="is_active" value="0">
            <input type="checkbox" name="is_active" value="1" <cfif getRecord.is_active>checked</cfif> style="width:16px;height:16px;">
            Active (show on Products page)
          </label>
          <label style="display:flex; align-items:center; gap:0.5rem; cursor:pointer; font-weight:400;">
            <input type="hidden" name="section_alt" value="0">
            <input type="checkbox" name="section_alt" value="1" <cfif getRecord.section_alt>checked</cfif> style="width:16px;height:16px;">
            Alternate background (light grey)
          </label>
        </div>

      </div>

      <div style="margin-top:1.5rem; display:flex; gap:1rem; align-items:center;">
        <button type="submit" class="btn btn-primary">
          <span id="save-spinner" class="htmx-indicator me-1">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" style="animation:spin 1s linear infinite; vertical-align:middle;"><path d="M12 2a10 10 0 0 1 10 10"/></svg>
          </span>
          <cfif isNew>Create Category<cfelse>Save Changes</cfif>
        </button>
        <a href="/admin/categories_list.cfm" class="btn btn-outline">Cancel</a>
        <cfif NOT isNew>
          <a href="/products.cfm###htmlEditFormat(getRecord.slug)#" class="btn btn-outline" target="_blank" style="margin-left:auto;">
            <i class="bi bi-box-arrow-up-right me-1"></i> View on Site
          </a>
        </cfif>
      </div>

    </form>
  </div>
</div>

<style>@keyframes spin { to { transform:rotate(360deg); } }</style>

</cfoutput>

<cfinclude template="/themes/biotwine/layouts/admin_close.cfm">
