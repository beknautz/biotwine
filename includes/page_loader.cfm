<!---
    /includes/page_loader.cfm
    Reusable snippet — load a page record from DB by slug into request.page struct.
    Usage: set request.slug BEFORE including this file.
    Result: request.page struct with all page columns.
    Redirects to /index.cfm if slug not found or page is inactive.
--->
<cfparam name="request.slug" default="">

<cfif NOT len(trim(request.slug))>
    <cflocation url="/index.cfm" addtoken="false">
</cfif>

<cftry>
    <cfquery name="loadPage" datasource="#application.dsn#">
        SELECT page_id, slug, nav_title, page_title,
               hero_heading, hero_subhead, hero_image,
               body_content, meta_title, meta_desc,
               show_hero, layout_type, is_active
        FROM pages
        WHERE slug      = <cfqueryparam value="#trim(request.slug)#" cfsqltype="cf_sql_varchar">
          AND is_active = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfcatch type="database">
        <cflog file="app_errors" text="page_loader.cfm query error: #cfcatch.message# — #cfcatch.detail#">
        <cflocation url="/index.cfm" addtoken="false">
    </cfcatch>
</cftry>

<cfif loadPage.recordCount EQ 0>
    <cfheader statuscode="404" statustext="Not Found">
    <cfinclude template="/themes/biotwine/layouts/default_open.cfm">
    <cfoutput>
    <section class="section">
      <div class="container-narrow text-center" style="padding:5rem 1rem;">
        <div class="section-eyebrow">404</div>
        <h1 class="section-title">Page Not Found</h1>
        <p style="color:var(--text-muted); margin-bottom:2rem;">
          The page you&rsquo;re looking for doesn&rsquo;t exist or has been moved.
        </p>
        <a href="/index.cfm" class="btn btn-primary">Back to Home</a>
      </div>
    </section>
    </cfoutput>
    <cfinclude template="/themes/biotwine/layouts/default_close.cfm">
    <cfabort>
</cfif>

<!--- Expose as request.page struct for the calling template --->
<cfset request.page = {
    page_id      : loadPage.page_id,
    slug         : loadPage.slug,
    nav_title    : loadPage.nav_title,
    page_title   : loadPage.page_title,
    hero_heading : loadPage.hero_heading,
    hero_subhead : loadPage.hero_subhead,
    hero_image   : loadPage.hero_image,
    body_content : loadPage.body_content,
    meta_title   : loadPage.meta_title,
    meta_desc    : loadPage.meta_desc,
    show_hero    : loadPage.show_hero,
    layout_type  : loadPage.layout_type
}>

<!--- Allow meta overrides from calling template if already set --->
<cfif NOT len(trim(request.pageTitle))>
    <cfset request.pageTitle = len(trim(request.page.meta_title)) ? request.page.meta_title : request.page.page_title>
</cfif>
<cfif NOT len(trim(request.metaDesc))>
    <cfset request.metaDesc = request.page.meta_desc>
</cfif>
