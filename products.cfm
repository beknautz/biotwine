<!--- products.cfm — DB-driven product listing with page_sections for hero/cta --->
<cfinclude template="/includes/theme_loader.cfm">
<cfset request.layout    = "default">
<cfset request.pageTitle = "Products">
<cfset request.metaDesc  = "BioTwine Manufacturing — premium biodegradable twisted paper twine for hop farms, berry orchards, and handle bag manufacturers.">

<!--- Page sections (hero, cta_dark) --->
<cfquery name="getSections" datasource="#application.dsn#">
  SELECT section_id, section_type, eyebrow, heading, subheading, body_text,
         image, image_alt, cta_label, cta_url, cta2_label, cta2_url, extra_data
  FROM   page_sections
  WHERE  page_slug = 'products'
  AND    is_active = 1
  ORDER  BY sort_order ASC
</cfquery>

<!--- Active categories --->
<cftry>
  <cfquery name="getCategories" datasource="#application.dsn#">
    SELECT category_id, slug, nav_label, eyebrow, heading, description, section_alt
    FROM   product_categories
    WHERE  is_active = 1
    ORDER  BY sort_order ASC
  </cfquery>
  <cfcatch type="database">
    <cflog file="app_errors" text="products.cfm categories: #cfcatch.message#">
    <cfset getCategories = queryNew("category_id,slug,nav_label,eyebrow,heading,description,section_alt")>
  </cfcatch>
</cftry>

<cfinclude template="/themes/biotwine/layouts/default_open.cfm">

<!--- Page hero from page_sections --->
<cfloop query="getSections">
  <cfif getSections.section_type EQ "page_hero">
    <cfinclude template="/themes/biotwine/sections/page_hero.cfm">
  </cfif>
</cfloop>

<cfoutput>

<!--- Sticky category anchor nav --->
<cfif getCategories.recordCount GT 0>
<div style="background:var(--bg-card); border-bottom:1px solid var(--border-color); position:sticky; top:var(--nav-height); z-index:50;">
  <div class="container" style="display:flex; gap:0; overflow-x:auto;">
    <cfloop query="getCategories">
    <a href="###htmlEditFormat(getCategories.slug)#" style="padding:1rem 1.5rem; font-size:var(--font-size-sm); font-weight:600; color:var(--text-body); border-bottom:2px solid transparent; text-decoration:none; white-space:nowrap; transition:color 150ms,border-color 150ms;" onmouseover="this.style.borderBottomColor='var(--color-forest)'" onmouseout="this.style.borderBottomColor='transparent'">#htmlEditFormat(getCategories.nav_label)#</a>
    </cfloop>
  </div>
</div>
</cfif>

</cfoutput>

<!--- Category sections — direct query per category to avoid QoQ inside cfloop --->
<cfloop query="getCategories">
  <cfset catSlug    = getCategories.slug>
  <cfset catAlt     = getCategories.section_alt>
  <cfset catEyebrow = getCategories.eyebrow>
  <cfset catHeading = getCategories.heading>
  <cfset catDesc    = getCategories.description>

  <cftry>
    <cfquery name="catProducts" datasource="#application.dsn#">
      SELECT product_id, name, item_number, description, image, badge
      FROM   products
      WHERE  is_active  = 1
      AND    category   = <cfqueryparam value="#catSlug#" cfsqltype="cf_sql_varchar">
      ORDER  BY sort_order ASC, name ASC
    </cfquery>
    <cfcatch type="database">
      <cfset catProducts = queryNew("product_id,name,item_number,description,image,badge")>
    </cfcatch>
  </cftry>

  <cfif catProducts.recordCount GT 0>
  <cfoutput>
  <section class="section#iif(catAlt, de(' section-alt'), de(''))#" id="#htmlEditFormat(catSlug)#">
    <div class="container">
      <div class="section-header" data-fade="">
        <div class="section-eyebrow">#htmlEditFormat(catEyebrow)#</div>
        <h2 class="section-title">#htmlEditFormat(catHeading)#</h2>
        <cfif len(trim(catDesc))>
          <p class="section-lead">#htmlEditFormat(catDesc)#</p>
        </cfif>
      </div>
      <div class="product-grid">
        <cfloop query="catProducts">
        <div class="product-card" data-fade="" data-fade-delay="#(catProducts.currentRow * 80)#">
          <div class="product-card-img" style="background:var(--bg-card-alt); display:flex; align-items:center; justify-content:center; height:180px;">
            <cfif len(trim(catProducts.image))>
              <cfset prodImgSrc = iif(left(catProducts.image,1) EQ "/", de(catProducts.image), de("/assets/uploads/products/" & catProducts.image))>
              <img src="#htmlEditFormat(prodImgSrc)#" alt="#htmlEditFormat(catProducts.name)#" style="width:100%; height:180px; object-fit:cover;">
            <cfelse>
              <span style="font-size:3rem;">🌿</span>
            </cfif>
          </div>
          <div class="product-card-body">
            <cfif len(trim(catProducts.badge))>
              <span class="product-badge badge-kraft">#htmlEditFormat(catProducts.badge)#</span>
            </cfif>
            <h3>#htmlEditFormat(catProducts.name)#</h3>
            <cfif len(trim(catProducts.item_number))>
              <p style="font-size:0.75rem; color:var(--text-muted); font-family:var(--font-mono); margin-bottom:0.5rem;">Item ##: #htmlEditFormat(catProducts.item_number)#</p>
            </cfif>
            <cfif len(trim(catProducts.description))>
              <p>#htmlEditFormat(catProducts.description)#</p>
            </cfif>
            <a href="/contact.cfm?product=#urlEncodedFormat(catProducts.name)#" class="btn btn-primary">Request Quote</a>
          </div>
        </div>
        </cfloop>
      </div>
    </div>
  </section>
  </cfoutput>
  </cfif>

</cfloop>

<!--- CTA from page_sections --->
<cfloop query="getSections">
  <cfif getSections.section_type EQ "cta_dark">
    <cfinclude template="/themes/biotwine/sections/cta_dark.cfm">
  </cfif>
</cfloop>

<cfinclude template="/themes/biotwine/layouts/default_close.cfm">
