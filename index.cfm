<!--- index.cfm — Homepage controller. Loads home page content from DB. --->
<cfinclude template="/includes/theme_loader.cfm">

<cfset request.layout   = "default">
<cfset request.metaDesc = "BioTwine Manufacturing — Premium biodegradable twisted paper twine for hop farms, berry orchards, and handle bag manufacturers. Toppenish, WA since 1994.">

<!--- Resolve home slug from settings cache, fallback to 'home' --->
<cfset request.slug = structKeyExists(application.settings, "home_slug") ? application.settings["home_slug"] : "home">

<!--- Load the home page record (sets request.page, request.pageTitle, request.metaDesc) --->
<cfinclude template="/includes/page_loader.cfm">

<!--- ── DYNAMIC DATA QUERIES ─────────────────────────────────────── --->

<!--- Featured products --->
<cftry>
    <cfquery name="getFeatured" datasource="#application.dsn#">
        SELECT product_id, name, item_number, description, badge, image, category
        FROM products
        WHERE is_active  = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
          AND is_featured = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
        ORDER BY sort_order ASC
        LIMIT 3
    </cfquery>
    <cfcatch type="database">
        <cfset getFeatured = queryNew("product_id,name,item_number,description,badge,image,category")>
    </cfcatch>
</cftry>

<!--- Latest news --->
<cftry>
    <cfquery name="getNews" datasource="#application.dsn#">
        SELECT news_id, title, slug, excerpt, pub_date
        FROM news
        WHERE is_active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
        ORDER BY pub_date DESC
        LIMIT 3
    </cfquery>
    <cfcatch type="database">
        <cfset getNews = queryNew("news_id,title,slug,excerpt,pub_date")>
    </cfcatch>
</cftry>

<!--- Featured testimonial --->
<cftry>
    <cfquery name="getTestimonial" datasource="#application.dsn#">
        SELECT quote, company, location, years_partner
        FROM testimonials
        WHERE is_active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
        ORDER BY sort_order ASC
        LIMIT 1
    </cfquery>
    <cfcatch type="database">
        <cfset getTestimonial = queryNew("quote,company,location,years_partner")>
    </cfcatch>
</cftry>

<!--- ── LAYOUT OPEN ────────────────────────────────────────────────── --->
<cfinclude template="/themes/biotwine/layouts/default_open.cfm">

<cfoutput>

<!--- ══════════════════════════════════════════════════════════════
      EDITABLE CONTENT — hero, stats strip, who we are, CTA
      Managed via Summernote in the Pages CMS (slug: home)
      ══════════════════════════════════════════════════════════════ --->
#request.page.body_content#

<!--- ══════════════════════════════════════════════════════════════
      PRODUCTS — dynamic, always live from DB
      ══════════════════════════════════════════════════════════════ --->
<cfif getFeatured.recordCount GT 0>
<section class="section section-alt">
  <div class="container">
    <div class="section-header text-center" data-fade>
      <div class="section-eyebrow">Our Products</div>
      <h2 class="section-title">Two Product Lines. <em>One Source of Excellence.</em></h2>
    </div>
    <div class="product-grid">
      <cfloop query="getFeatured">
      <div class="product-card" data-fade data-fade-delay="#(currentRow * 100)#">
        <div class="product-card-img" style="background: var(--bg-card-alt);">
          <cfif len(trim(image))>
            <img src="/assets/uploads/products/#htmlEditFormat(image)#" alt="#htmlEditFormat(name)#" style="width:100%;height:200px;object-fit:cover;">
          <cfelse>
            <span style="font-size:3rem;">🌿</span>
          </cfif>
        </div>
        <div class="product-card-body">
          <cfif len(trim(badge))>
            <span class="product-badge badge-kraft">#htmlEditFormat(badge)#</span>
          </cfif>
          <h3>#htmlEditFormat(name)#</h3>
          <p>#htmlEditFormat(description)#</p>
          <a href="/products.cfm###htmlEditFormat(category)#" class="btn btn-outline">Learn More &rarr;</a>
        </div>
      </div>
      </cfloop>
    </div>
    <div class="text-center" style="margin-top:2.5rem;" data-fade>
      <a href="/products.cfm" class="btn btn-primary btn-lg">View All Products</a>
    </div>
  </div>
</section>
</cfif>

<!--- ══════════════════════════════════════════════════════════════
      TESTIMONIAL — dynamic, always live from DB
      ══════════════════════════════════════════════════════════════ --->
<cfif getTestimonial.recordCount GT 0>
<section class="testimonial-section">
  <div class="container-narrow">
    <div data-fade>
      <p class="testimonial-body">&ldquo;#getTestimonial.quote#&rdquo;</p>
      <div class="testimonial-attribution">
        <strong>#htmlEditFormat(getTestimonial.company)#</strong>
        #htmlEditFormat(getTestimonial.location)#
        <cfif len(trim(getTestimonial.years_partner))>
          &bull; #htmlEditFormat(getTestimonial.years_partner)# partnership
        </cfif>
      </div>
    </div>
  </div>
</section>
</cfif>

<!--- ══════════════════════════════════════════════════════════════
      NEWS — dynamic, always live from DB
      ══════════════════════════════════════════════════════════════ --->
<cfif getNews.recordCount GT 0>
<section class="section">
  <div class="container">
    <div class="section-header" data-fade>
      <div class="section-eyebrow">Latest News</div>
      <h2 class="section-title">News &amp; Announcements</h2>
    </div>
    <div class="news-grid">
      <cfloop query="getNews">
      <div class="news-card" data-fade data-fade-delay="#(currentRow * 80)#">
        <div class="news-date">#dateFormat(pub_date, "mmmm d, yyyy")#</div>
        <h3><a href="/news_detail.cfm?slug=#urlEncodedFormat(slug)#">#htmlEditFormat(title)#</a></h3>
        <cfif len(trim(excerpt))>
          <p style="font-size:var(--font-size-sm); color:var(--text-muted);">#htmlEditFormat(excerpt)#</p>
        </cfif>
        <a href="/news_detail.cfm?slug=#urlEncodedFormat(slug)#" style="font-size:var(--font-size-sm); font-weight:600; color:var(--color-forest);">Read More &rarr;</a>
      </div>
      </cfloop>
    </div>
    <div style="margin-top:2rem;" data-fade>
      <a href="/news.cfm" class="btn btn-outline">All News</a>
    </div>
  </div>
</section>
</cfif>

</cfoutput>

<!--- ── LAYOUT CLOSE ─────────────────────────────────────────────── --->
<cfinclude template="/themes/biotwine/layouts/default_close.cfm">
