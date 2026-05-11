<!--- news_detail.cfm — Public single news article --->
<cfinclude template="/includes/theme_loader.cfm">
<cfparam name="url.slug" default="">

<cfif NOT len(trim(url.slug))>
  <cflocation url="/news.cfm" addtoken="false">
</cfif>

<cftry>
  <cfquery name="getArticle" datasource="#application.dsn#">
    SELECT news_id, title, slug, excerpt, body, image, pub_date, meta_title, meta_desc
    FROM news
    WHERE slug      = <cfqueryparam value="#trim(url.slug)#" cfsqltype="cf_sql_varchar">
      AND is_active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
  </cfquery>
  <cfif getArticle.recordCount EQ 0>
    <cflocation url="/news.cfm" addtoken="false">
  </cfif>
  <cfcatch type="database">
    <cflocation url="/news.cfm" addtoken="false">
  </cfcatch>
</cftry>

<cfset request.layout    = "default">
<cfset request.pageTitle = len(getArticle.meta_title) ? getArticle.meta_title : getArticle.title>
<cfset request.metaDesc  = len(getArticle.meta_desc) ? getArticle.meta_desc : getArticle.excerpt>

<cfinclude template="/themes/biotwine/layouts/default_open.cfm">

<cfoutput>

<section class="page-hero">
  <div class="container">
    <div class="eyebrow">#dateFormat(getArticle.pub_date, "mmmm d, yyyy")#</div>
    <h1>#htmlEditFormat(getArticle.title)#</h1>
  </div>
</section>

<section class="section">
  <div class="container-narrow">

    <ul class="breadcrumb">
      <li><a href="/">Home</a></li>
      <li><a href="/news.cfm">News</a></li>
      <li class="active">#htmlEditFormat(getArticle.title)#</li>
    </ul>

    <cfif len(trim(getArticle.image))>
      <cfif left(trim(getArticle.image),1) EQ "/">
        <cfset artImgSrc = trim(getArticle.image)>
      <cfelse>
        <cfset artImgSrc = "/assets/uploads/img/" & trim(getArticle.image)>
      </cfif>
      <img src="#htmlEditFormat(artImgSrc)#" alt="#htmlEditFormat(getArticle.title)#" style="width:100%;border-radius:var(--border-radius-lg);margin-bottom:2rem;" loading="lazy">
    </cfif>

    <div style="font-size:var(--font-size-lg); line-height:var(--line-height-loose); color:var(--text-body);">
      #getArticle.body#
    </div>

    <hr class="divider">

    <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:1rem;">
      <a href="/news.cfm" style="font-size:var(--font-size-sm); font-weight:600; color:var(--color-forest);">&larr; All News</a>
      <a href="/contact.cfm" class="btn btn-secondary">Request a Quote</a>
    </div>

  </div>
</section>

</cfoutput>

<cfinclude template="/themes/biotwine/layouts/default_close.cfm">
