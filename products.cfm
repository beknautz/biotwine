<!--- /products.cfm — DB-driven product listing --->
<cfinclude template="/includes/theme_loader.cfm">
<cfset request.layout    = "default">
<cfset request.pageTitle = "Products">
<cfset request.metaDesc  = "BioTwine Manufacturing — premium biodegradable twisted paper twine for hop farms, berry orchards, and handle bag manufacturers.">

<!--- Load active categories --->
<cftry>
  <cfquery name="getCategories" datasource="#application.dsn#">
    SELECT category_id, slug, nav_label, eyebrow, heading, description, section_alt
    FROM   product_categories
    WHERE  is_active = 1
    ORDER  BY sort_order ASC
  </cfquery>
  <cfcatch type="database">
    <cflog file="app_errors" text="products.cfm categories query: #cfcatch.message#">
    <cfset getCategories = queryNew("category_id,slug,nav_label,eyebrow,heading,description,section_alt")>
  </cfcatch>
</cftry>

<!--- Load all active products once, split by category in the loop --->
<cftry>
  <cfquery name="getAllProducts" datasource="#application.dsn#">
    SELECT product_id, category, name, item_number, description, image, badge
    FROM   products
    WHERE  is_active = 1
    ORDER  BY sort_order ASC, name ASC
  </cfquery>
  <cfcatch type="database">
    <cflog file="app_errors" text="products.cfm products query: #cfcatch.message#">
    <cfset getAllProducts = queryNew("product_id,category,name,item_number,description,image,badge")>
  </cfcatch>
</cftry>

<cfinclude template="/themes/biotwine/layouts/default_open.cfm">

<cfoutput>

<!--- Page hero --->
<section class="page-hero">
  <div class="container">
    <div class="eyebrow">BioTwine Manufacturing</div>
    <h1>Our Products</h1>
    <p>Premium biodegradable twisted paper twine &amp; engineered for the field.</p>
  </div>
</section>

<!--- Sticky category anchor nav --->
<cfif getCategories.recordCount GT 0>
<div style="background:var(--bg-card); border-bottom:1px solid var(--border-color); position:sticky; top:var(--nav-height); z-index:50;">
  <div class="container" style="display:flex; gap:0; overflow-x:auto;">
    <cfloop query="getCategories">
    <a href="###htmlEditFormat(slug)#" style="padding:1rem 1.5rem; font-size:var(--font-size-sm); font-weight:600; color:var(--text-body); border-bottom:2px solid transparent; text-decoration:none; white-space:nowrap; transition:color 150ms, border-color 150ms;" onmouseover="this.style.borderBottomColor='var(--color-forest)'" onmouseout="this.style.borderBottomColor='transparent'">#htmlEditFormat(nav_label)#</a>
    </cfloop>
  </div>
</div>
</cfif>

<!--- Category sections --->
<cfloop query="getCategories">
  <cfset catSlug = slug>
  <cfset catAlt  = section_alt>

  <!--- Filter products for this category --->
  <cfquery name="catProducts" dbtype="query">
    SELECT * FROM getAllProducts
    WHERE  category = '#catSlug#'
  </cfquery>

  <cfif catProducts.recordCount GT 0>
  <section class="section#iif(catAlt, de(' section-alt'), de(''))#" id="#htmlEditFormat(catSlug)#">
    <div class="container">
      <div class="section-header" data-fade="">
        <div class="section-eyebrow">#htmlEditFormat(eyebrow)#</div>
        <h2 class="section-title">#htmlEditFormat(heading)#</h2>
        <cfif len(trim(description))>
          <p class="section-lead">#htmlEditFormat(description)#</p>
        </cfif>
      </div>
      <div class="product-grid">
        <cfloop query="catProducts">
        <div class="product-card" data-fade="" data-fade-delay="#(catProducts.currentRow * 80)#">
          <div class="product-card-img" style="background:var(--bg-card-alt); display:flex; align-items:center; justify-content:center; height:180px;">
            <cfif len(trim(image))>
              <img src="/assets/uploads/products/#htmlEditFormat(image)#" alt="#htmlEditFormat(name)#" style="width:100%; height:180px; object-fit:cover;">
            <cfelse>
              <span style="font-size:3rem;">🌿</span>
            </cfif>
          </div>
          <div class="product-card-body">
            <cfif len(trim(badge))>
              <span class="product-badge badge-kraft">#htmlEditFormat(badge)#</span>
            </cfif>
            <h3>#htmlEditFormat(name)#</h3>
            <cfif len(trim(item_number))>
              <p style="font-size:0.75rem; color:var(--text-muted); font-family:var(--font-mono); margin-bottom:0.5rem;">Item ##: #htmlEditFormat(item_number)#</p>
            </cfif>
            <cfif len(trim(description))>
              <p>#htmlEditFormat(description)#</p>
            </cfif>
            <a href="/contact.cfm?product=#urlEncodedFormat(name)#" class="btn btn-primary">Request Quote</a>
          </div>
        </div>
        </cfloop>
      </div>
    </div>
  </section>
  </cfif>

</cfloop>

<!--- CTA --->
<section class="section section-dark text-center">
  <div class="container-narrow" data-fade="">
    <div class="section-eyebrow" style="color:var(--color-meadow);">Let's Talk</div>
    <h2 class="section-title" style="color:#FFFFFF;">Need a Custom Specification or Volume Pricing?</h2>
    <p class="section-lead" style="color:rgba(255,255,255,0.7); margin:0 auto 2rem;">Our team can work with you on custom twine specifications, volume pricing, and delivery logistics.</p>
    <a href="/contact.cfm" class="btn btn-secondary btn-lg">Contact Us Today</a>
  </div>
</section>

</cfoutput>

<cfinclude template="/themes/biotwine/layouts/default_close.cfm">
