<!--- news.cfm — Public news listing --->
<cfinclude template="/includes/theme_loader.cfm">
<cfset request.layout    = "default">
<cfset request.pageTitle = "News &amp; Announcements">

<cftry>
  <cfquery name="getNews" datasource="#application.dsn#">
    SELECT news_id, title, slug, excerpt, pub_date, image
    FROM news
    WHERE is_active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
    ORDER BY pub_date DESC
  </cfquery>
  <cfcatch type="database">
    <cfset getNews = queryNew("news_id,title,slug,excerpt,pub_date,image")>
  </cfcatch>
</cftry>

<cfinclude template="/themes/biotwine/layouts/default_open.cfm">

<cfoutput>

<section class="page-hero">
  <div class="container">
    <div class="eyebrow">BioTwine Manufacturing</div>
    <h1>News &amp; Announcements</h1>
    <p>Product availability updates, new certifications, and company news.</p>
  </div>
</section>

<section class="section">
  <div class="container">
    <cfif getNews.recordCount GT 0>
    <div class="news-grid">
      <cfloop query="getNews">
      <div class="news-card" data-fade data-fade-delay="#(currentRow * 60)#">
        <cfif len(trim(image))>
          <cfset newsImgSrc = iif(left(image,1) EQ "/", de(image), de("/assets/uploads/img/" & image))>
          <img src="#htmlEditFormat(newsImgSrc)#" alt="#htmlEditFormat(title)#" style="width:100%;height:160px;object-fit:cover;border-radius:var(--border-radius);margin-bottom:1rem;" loading="lazy">
        </cfif>
        <div class="news-date">#dateFormat(pub_date, "mmmm d, yyyy")#</div>
        <h3><a href="/news_detail.cfm?slug=#urlEncodedFormat(slug)#">#htmlEditFormat(title)#</a></h3>
        <cfif len(trim(excerpt))>
          <p style="font-size:var(--font-size-sm); color:var(--text-muted);">#htmlEditFormat(excerpt)#</p>
        </cfif>
        <a href="/news_detail.cfm?slug=#urlEncodedFormat(slug)#" style="font-size:var(--font-size-sm); font-weight:600; color:var(--color-forest);">Read More &rarr;</a>
      </div>
      </cfloop>
    </div>
    <cfelse>
    <div style="text-align:center; padding:4rem 0; color:var(--text-muted);">
      <i class="bi bi-newspaper" style="font-size:3rem; display:block; margin-bottom:1rem; opacity:0.3;"></i>
      No news articles published yet.
    </div>
    </cfif>
  </div>
</section>

</cfoutput>

<cfinclude template="/themes/biotwine/layouts/default_close.cfm">
