<!--- /admin/news_save.cfm — HTMX POST handler --->
<cfparam name="form.news_id"    default="0">
<cfparam name="form.title"      default="">
<cfparam name="form.slug"       default="">
<cfparam name="form.excerpt"    default="">
<cfparam name="form.body"       default="">
<cfparam name="form.image"      default="">
<cfparam name="form.pub_date"   default="#dateFormat(now(),'yyyy-mm-dd')#">
<cfparam name="form.is_active"  default="0">
<cfparam name="form.meta_title" default="">
<cfparam name="form.meta_desc"  default="">

<cfif NOT len(trim(form.title)) OR NOT len(trim(form.slug))>
  <div class="alert alert-danger">Title and slug are required.</div>
  <cfabort>
</cfif>

<!--- Sanitize slug --->
<cfset cleanSlug = lCase(rEReplaceNoCase(rEReplaceNoCase(trim(form.slug), "[^a-z0-9\-]", "", "ALL"), "-+", "-", "ALL"))>

<cfif NOT len(cleanSlug)>
  <div class="alert alert-danger">Slug contains invalid characters. Use only letters, numbers, and hyphens.</div>
  <cfabort>
</cfif>

<cfif NOT isDate(form.pub_date)>
  <div class="alert alert-danger">Please enter a valid publish date.</div>
  <cfabort>
</cfif>

<cftry>
  <cfif val(form.news_id)>
    <cfquery datasource="#application.dsn#">
      UPDATE news SET
        title      = <cfqueryparam value="#trim(form.title)#"      cfsqltype="cf_sql_varchar">,
        slug       = <cfqueryparam value="#cleanSlug#"             cfsqltype="cf_sql_varchar">,
        excerpt    = <cfqueryparam value="#trim(form.excerpt)#"    cfsqltype="cf_sql_varchar">,
        body       = <cfqueryparam value="#trim(form.body)#"       cfsqltype="cf_sql_varchar">,
        image      = <cfqueryparam value="#trim(form.image)#"      cfsqltype="cf_sql_varchar">,
        pub_date   = <cfqueryparam value="#dateFormat(form.pub_date,'yyyy-mm-dd')#" cfsqltype="cf_sql_date">,
        is_active  = <cfqueryparam value="#form.is_active#"        cfsqltype="cf_sql_bit">,
        meta_title = <cfqueryparam value="#trim(form.meta_title)#" cfsqltype="cf_sql_varchar">,
        meta_desc  = <cfqueryparam value="#trim(form.meta_desc)#"  cfsqltype="cf_sql_varchar">,
        updated_at = NOW()
      WHERE news_id = <cfqueryparam value="#form.news_id#" cfsqltype="cf_sql_integer">
    </cfquery>
  <cfelse>
    <cfquery datasource="#application.dsn#">
      INSERT INTO news (title, slug, excerpt, body, image, pub_date, is_active, meta_title, meta_desc, created_at, updated_at)
      VALUES (
        <cfqueryparam value="#trim(form.title)#"      cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#cleanSlug#"             cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.excerpt)#"    cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.body)#"       cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.image)#"      cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#dateFormat(form.pub_date,'yyyy-mm-dd')#" cfsqltype="cf_sql_date">,
        <cfqueryparam value="#form.is_active#"        cfsqltype="cf_sql_bit">,
        <cfqueryparam value="#trim(form.meta_title)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.meta_desc)#"  cfsqltype="cf_sql_varchar">,
        NOW(), NOW()
      )
    </cfquery>
  </cfif>

  <div class="alert alert-success">
    <strong>Saved!</strong> &ldquo;#htmlEditFormat(trim(form.title))#&rdquo; has been saved.
    <a href="/admin/news_list.cfm" style="margin-left:0.5rem; font-weight:600;">Back to list &rarr;</a>
  </div>

  <cfcatch type="database">
    <cflog file="app_errors" text="news_save.cfm error: #cfcatch.message# — #cfcatch.detail#">
    <cfif findNoCase("Duplicate", cfcatch.message) OR findNoCase("slug", cfcatch.message)>
      <div class="alert alert-danger">That slug is already in use. Please choose a different URL slug.</div>
    <cfelse>
      <div class="alert alert-danger">A database error occurred. Please try again.</div>
    </cfif>
  </cfcatch>
</cftry>
