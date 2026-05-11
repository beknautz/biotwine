<!--- /page.cfm — Generic page router --->
<cfinclude template="/includes/theme_loader.cfm">

<cfparam name="url.slug" default="">

<cfset cleanSlug = lCase(trim(reReplace(url.slug, "[^a-z0-9\-]", "", "ALL")))>

<cfif NOT len(cleanSlug)>
    <cflocation url="/index.cfm" addtoken="false">
</cfif>

<cftry>
    <cfquery name="getPage" datasource="#application.dsn#">
        SELECT page_id, slug, page_title, nav_title,
               hero_heading, hero_subhead, hero_image,
               body_content, meta_title, meta_desc,
               show_hero, layout_type, is_active
        FROM pages
        WHERE slug      = <cfqueryparam value="#cleanSlug#" cfsqltype="cf_sql_varchar">
          AND is_active = <cfqueryparam value="1"           cfsqltype="cf_sql_integer">
    </cfquery>
    <cfcatch type="database">
        <cflog file="app_errors" text="page.cfm query error: #cfcatch.message# — #cfcatch.detail#">
        <cflocation url="/index.cfm" addtoken="false">
    </cfcatch>
</cftry>

<!--- 404 if not found or marked as custom (custom pages have their own .cfm file) --->
<cfif getPage.recordCount EQ 0 OR getPage.layout_type EQ "custom">
    <cfheader statuscode="404" statustext="Not Found">
    <cfinclude template="/themes/biotwine/layouts/default_open.cfm">
    <cfoutput>
    <section class="section">
      <div class="container-narrow text-center" style="padding: 5rem 1rem;">
        <div class="section-eyebrow">404</div>
        <h1 class="section-title">Page Not Found</h1>
        <p style="color:var(--text-muted); margin-bottom:2rem;">
          The page you're looking for doesn't exist or has been moved.
        </p>
        <a href="/index.cfm" class="btn btn-primary">Back to Home</a>
      </div>
    </section>
    </cfoutput>
    <cfinclude template="/themes/biotwine/layouts/default_close.cfm">
    <cfabort>
</cfif>

<!--- Set layout vars --->
<cfset request.layout    = "default">
<cfset request.pageTitle = len(trim(getPage.meta_title)) ? getPage.meta_title : getPage.page_title>
<cfset request.metaDesc  = getPage.meta_desc>

<cfinclude template="/themes/biotwine/layouts/default_open.cfm">

<cfoutput>

<!--- ── HERO (only if show_hero = 1 and hero_heading populated) ── --->
<cfif getPage.show_hero AND len(trim(getPage.hero_heading))>
<section class="hero">
  <cfif len(trim(getPage.hero_image))>
  <div class="hero-bg" style="background-image: url('#htmlEditFormat(getPage.hero_image)#');"></div>
  </cfif>
  <div class="hero-content">
    <h1>#htmlEditFormat(getPage.hero_heading)#</h1>
    <cfif len(trim(getPage.hero_subhead))>
    <p class="hero-subtitle">#htmlEditFormat(getPage.hero_subhead)#</p>
    </cfif>
  </div>
</section>
<cfelse>
<!--- Page title header for non-hero pages --->
<div class="page-header-strip">
  <div class="container">
    <h1 class="page-header-title">#htmlEditFormat(getPage.page_title)#</h1>
  </div>
</div>
</cfif>

<!--- ── BODY CONTENT ── --->
<section class="section">
  <div class="container-narrow">
    <cfif len(trim(getPage.body_content))>
      #getPage.body_content#
    </cfif>
  </div>
</section>

</cfoutput>

<cfinclude template="/themes/biotwine/layouts/default_close.cfm">
