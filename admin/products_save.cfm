<!--- /admin/products_save.cfm — HTMX POST handler --->
<cfparam name="form.product_id"  default="0">
<cfparam name="form.category"    default="hop">
<cfparam name="form.name"        default="">
<cfparam name="form.item_number" default="">
<cfparam name="form.description" default="">
<cfparam name="form.specs"       default="">
<cfparam name="form.image"       default="">
<cfparam name="form.badge"       default="">
<cfparam name="form.is_active"   default="0">
<cfparam name="form.is_featured" default="0">
<cfparam name="form.sort_order"  default="0">

<cfif NOT len(trim(form.name))>
  <div class="alert alert-danger">Product name is required.</div>
  <cfabort>
</cfif>

<cftry>
  <cfif val(form.product_id)>
    <!--- UPDATE --->
    <cfquery datasource="#application.dsn#">
      UPDATE products SET
        category    = <cfqueryparam value="#trim(form.category)#"    cfsqltype="cf_sql_varchar">,
        name        = <cfqueryparam value="#trim(form.name)#"        cfsqltype="cf_sql_varchar">,
        item_number = <cfqueryparam value="#trim(form.item_number)#" cfsqltype="cf_sql_varchar">,
        description = <cfqueryparam value="#trim(form.description)#" cfsqltype="cf_sql_varchar">,
        specs       = <cfqueryparam value="#trim(form.specs)#"       cfsqltype="cf_sql_varchar">,
        image       = <cfqueryparam value="#trim(form.image)#"       cfsqltype="cf_sql_varchar">,
        badge       = <cfqueryparam value="#trim(form.badge)#"       cfsqltype="cf_sql_varchar">,
        is_active   = <cfqueryparam value="#form.is_active#"         cfsqltype="cf_sql_bit">,
        is_featured = <cfqueryparam value="#form.is_featured#"       cfsqltype="cf_sql_bit">,
        sort_order  = <cfqueryparam value="#val(form.sort_order)#"   cfsqltype="cf_sql_integer">,
        updated_at  = NOW()
      WHERE product_id = <cfqueryparam value="#form.product_id#" cfsqltype="cf_sql_integer">
    </cfquery>
  <cfelse>
    <!--- INSERT --->
    <cfquery datasource="#application.dsn#">
      INSERT INTO products (category, name, item_number, description, specs, image, badge, is_active, is_featured, sort_order, created_at, updated_at)
      VALUES (
        <cfqueryparam value="#trim(form.category)#"    cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.name)#"        cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.item_number)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.description)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.specs)#"       cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.image)#"       cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.badge)#"       cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#form.is_active#"         cfsqltype="cf_sql_bit">,
        <cfqueryparam value="#form.is_featured#"       cfsqltype="cf_sql_bit">,
        <cfqueryparam value="#val(form.sort_order)#"   cfsqltype="cf_sql_integer">,
        NOW(), NOW()
      )
    </cfquery>
  </cfif>

  <div class="alert alert-success">
    <strong>Saved!</strong> Product &ldquo;#htmlEditFormat(trim(form.name))#&rdquo; has been saved.
    <a href="/admin/products_list.cfm" style="margin-left:0.5rem; font-weight:600;">Back to list &rarr;</a>
  </div>

  <cfcatch type="database">
    <cflog file="app_errors" text="products_save.cfm error: #cfcatch.message# — #cfcatch.detail#">
    <div class="alert alert-danger">A database error occurred. Please try again.</div>
  </cfcatch>
</cftry>
