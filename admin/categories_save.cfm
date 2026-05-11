<!--- /admin/categories_save.cfm — HTMX POST handler --->
<cfparam name="form.category_id"  default="0">
<cfparam name="form.slug"         default="">
<cfparam name="form.nav_label"    default="">
<cfparam name="form.eyebrow"      default="">
<cfparam name="form.heading"      default="">
<cfparam name="form.description"  default="">
<cfparam name="form.section_alt"  default="0">
<cfparam name="form.is_active"    default="0">
<cfparam name="form.sort_order"   default="0">

<!--- Hidden+checkbox sends "0,1" when checked; resolve to 0 or 1 --->
<cfset form.is_active   = iif(listFindNoCase(form.is_active,   "1"), 1, 0)>
<cfset form.section_alt = iif(listFindNoCase(form.section_alt, "1"), 1, 0)>

<!--- Validation --->
<cfif NOT len(trim(form.nav_label))>
  <div class="alert alert-danger">Nav label is required.</div>
  <cfabort>
</cfif>
<cfif NOT len(trim(form.slug))>
  <div class="alert alert-danger">Slug is required.</div>
  <cfabort>
</cfif>

<!--- Sanitize slug: lowercase, alphanumeric + hyphens only --->
<cfset cleanSlug = lCase(rEReplaceNoCase(trim(form.slug), '[^a-z0-9\-]', '', 'ALL'))>

<cftry>
  <cfif val(form.category_id)>
    <!--- UPDATE — slug is locked, use existing value --->
    <cfquery datasource="#application.dsn#">
      UPDATE product_categories SET
        nav_label   = <cfqueryparam value="#trim(form.nav_label)#"   cfsqltype="cf_sql_varchar">,
        eyebrow     = <cfqueryparam value="#trim(form.eyebrow)#"     cfsqltype="cf_sql_varchar">,
        heading     = <cfqueryparam value="#trim(form.heading)#"     cfsqltype="cf_sql_varchar">,
        description = <cfqueryparam value="#trim(form.description)#" cfsqltype="cf_sql_varchar">,
        section_alt = <cfqueryparam value="#form.section_alt#"       cfsqltype="cf_sql_tinyint">,
        is_active   = <cfqueryparam value="#form.is_active#"         cfsqltype="cf_sql_tinyint">,
        sort_order  = <cfqueryparam value="#val(form.sort_order)#"   cfsqltype="cf_sql_integer">,
        updated_at  = NOW()
      WHERE category_id = <cfqueryparam value="#form.category_id#" cfsqltype="cf_sql_integer">
    </cfquery>
  <cfelse>
    <!--- INSERT --->
    <cfquery datasource="#application.dsn#">
      INSERT INTO product_categories (slug, nav_label, eyebrow, heading, description, section_alt, is_active, sort_order, created_at, updated_at)
      VALUES (
        <cfqueryparam value="#cleanSlug#"                 cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.nav_label)#"      cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.eyebrow)#"        cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.heading)#"        cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.description)#"    cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#form.section_alt#"          cfsqltype="cf_sql_tinyint">,
        <cfqueryparam value="#form.is_active#"            cfsqltype="cf_sql_tinyint">,
        <cfqueryparam value="#val(form.sort_order)#"      cfsqltype="cf_sql_integer">,
        NOW(), NOW()
      )
    </cfquery>
  </cfif>

  <div class="alert alert-success">
    <strong>Saved!</strong> Category &ldquo;#htmlEditFormat(trim(form.nav_label))#&rdquo; has been saved.
    <a href="/admin/categories_list.cfm" style="margin-left:0.5rem; font-weight:600;">Back to list &rarr;</a>
  </div>

  <cfcatch type="database">
    <cfif findNoCase("Duplicate entry", cfcatch.message)>
      <div class="alert alert-danger">A category with that slug already exists. Choose a different slug.</div>
    <cfelse>
      <cflog file="app_errors" text="categories_save.cfm: #cfcatch.message# — #cfcatch.detail#">
      <div class="alert alert-danger">A database error occurred. Please try again.</div>
    </cfif>
  </cfcatch>
</cftry>
