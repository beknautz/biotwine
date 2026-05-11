<cfsilent>
<!---
    /themes/biotwine/partials/nav_public.cfm
    Loads nav pages from DB + CTA settings from application.settings cache.
    Requires: application.settings (loaded in onApplicationStart via loadSiteCache)
              application.dsn
--->

<!--- Get CTA from settings cache --->
<cfset navCtaLabel = structKeyExists(application.settings, "nav_cta_label") ? application.settings["nav_cta_label"] : "Request a Quote">
<cfset navCtaUrl   = structKeyExists(application.settings, "nav_cta_url")   ? application.settings["nav_cta_url"]   : "/contact.cfm">
<cfset navPhone    = structKeyExists(application.settings, "phone")          ? application.settings["phone"]          : "">

<!--- Load nav pages from DB --->
<cftry>
    <cfquery name="getNavPages" datasource="#application.dsn#">
        SELECT page_id, nav_title, slug, has_dropdown, layout_type
        FROM pages
        WHERE is_active = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
        ORDER BY sort_order ASC, page_id ASC
    </cfquery>
    <cfcatch type="database">
        <cflog file="app_errors" text="nav_public.cfm query error: #cfcatch.message#">
        <cfset getNavPages = queryNew("page_id,nav_title,slug,has_dropdown")>
    </cfcatch>
</cftry>
</cfsilent>
<style>
/* ── Mobile nav (scoped here so it works even if main.css is cached) ── */
@media (max-width: 768px) {
  .nav-links-wrap          { display: none; }
  .nav-phone               { display: none !important; }
  .nav-hamburger           { display: flex !important; }

  .nav-links-wrap.mob-open {
    display: block;
    position: fixed;
    top: 64px;
    left: 0;
    right: 0;
    bottom: 0;
    background: ##1C2E1C;
    overflow-y: auto;
    z-index: 999;
    padding: 0.5rem 0 2rem;
  }
  .nav-links-wrap.mob-open .nav-links {
    display: flex !important;
    flex-direction: column;
    gap: 0;
    list-style: none;
    margin: 0;
    padding: 0 1rem;
  }
  .nav-links-wrap.mob-open .nav-links > li > a {
    display: block;
    padding: 0.9rem 1rem;
    font-size: 1rem;
    color: rgba(255,255,255,0.85);
    border-bottom: 1px solid rgba(255,255,255,0.07);
    letter-spacing: 0.02em;
    font-weight: 500;
    text-decoration: none;
  }
  .nav-links-wrap.mob-open .nav-links > li > a:hover { color: ##fff; }
  .nav-links-wrap.mob-open .dropdown-menu {
    position: static !important;
    display: block !important;
    opacity: 1 !important;
    visibility: visible !important;
    transform: none !important;
    box-shadow: none !important;
    border: none !important;
    background: rgba(255,255,255,0.06);
    border-radius: 4px;
    margin: 0 0 0.25rem 1rem;
    padding: 0.25rem 0;
  }
  .nav-links-wrap.mob-open .dropdown-menu a {
    display: block;
    padding: 0.55rem 1rem;
    font-size: 0.875rem;
    color: rgba(255,255,255,0.65);
    text-decoration: none;
    border-radius: 3px;
    font-weight: 400;
    letter-spacing: 0;
    text-transform: none;
  }
  .nav-links-wrap.mob-open .dropdown-menu a:hover {
    background: rgba(255,255,255,0.08);
    color: ##fff;
  }
  .nav-links-wrap.mob-open .btn-nav-cta {
    display: block !important;
    text-align: center;
    margin: 1rem;
    padding: 0.85rem 1.25rem !important;
    border-radius: 6px !important;
    font-size: 1rem !important;
    background: ##8B6914 !important;
    color: ##fff !important;
  }
  /* Hamburger → X */
  .nav-hamburger.mob-active span:nth-child(1) { transform: translateY(7px) rotate(45deg); }
  .nav-hamburger.mob-active span:nth-child(2) { opacity: 0; transform: scaleX(0); }
  .nav-hamburger.mob-active span:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }
  .nav-hamburger span { transition: transform 220ms ease, opacity 180ms ease; }
}
</style>

<nav class="site-nav" id="site-nav">
  <div class="nav-inner">

    <!-- Logo -->
    <a href="/index.cfm" class="nav-logo">
		<img src="assets/uploads/img/logo.png" style="height: 90px;" alt="BioTwine" >
 <!--     <span class="logo-bio"><span>Bio</span>Twine</span>
      <span class="logo-tagline">Manufacturing</span> --->
    </a>

    <!-- Nav links (desktop + mobile overlay) -->
    <div class="nav-links-wrap" id="nav-links-wrap">
      <ul class="nav-links">

        <cfoutput query="getNavPages">
        <cfsilent>
            <!--- Resolve URL: "home" slug → /index.cfm, all others → /slug.cfm --->
            <cfset pageUrl = (slug EQ "home") ? "/index.cfm" : ((layout_type EQ "generic") ? "/page.cfm?slug=#slug#" : "/#slug#.cfm")>
        </cfsilent>
        <li>
          <a href="#pageUrl#">#htmlEditFormat(nav_title)#<cfif has_dropdown> ▾</cfif></a>
          <cfif has_dropdown>
          <ul class="dropdown-menu">
            <!---
                Dropdown items are hardcoded per slug since each page
                controls its own anchor structure.
                Add cfif blocks here as new dropdown pages are added.
            --->
            <cfif slug EQ "products">
              <li><a href="/products.cfm##hop">Hop Twine</a></li>
              <li><a href="/products.cfm##handle">Handle Bag Twine</a></li>
              <li><a href="/products.cfm##other">Arching &amp; Other</a></li>
            </cfif>
          </ul>
          </cfif>
        </li>
        </cfoutput>

        <!--- CTA button — always last --->
        <cfoutput>
        <li>
          <a href="#xmlFormat(navCtaUrl)#" class="btn-nav-cta">#htmlEditFormat(navCtaLabel)#</a>
        </li>
        </cfoutput>

      </ul>
    </div>

    <cfif len(trim(navPhone))>
    <cfoutput>
    <div class="nav-phone d-none d-lg-block">
      <a href="tel:#reReplace(navPhone, '[^0-9]', '', 'ALL')#">#htmlEditFormat(navPhone)#</a>
    </div>
    </cfoutput>
    </cfif>

    <!-- Mobile hamburger -->
    <button class="nav-hamburger" id="nav-hamburger" aria-label="Open menu" aria-expanded="false">
      <span></span>
      <span></span>
      <span></span>
    </button>

  </div>
</nav>

<script>
(function () {
  var btn  = document.getElementById('nav-hamburger');
  var wrap = document.getElementById('nav-links-wrap');
  if (!btn || !wrap) return;

  btn.addEventListener('click', function (e) {
    e.stopPropagation();
    var isOpen = wrap.classList.toggle('mob-open');
    btn.classList.toggle('mob-active', isOpen);
    btn.setAttribute('aria-expanded', isOpen);
  });

  /* Close when any link inside the menu is tapped */
  wrap.addEventListener('click', function (e) {
    if (e.target.tagName === 'A') {
      wrap.classList.remove('mob-open');
      btn.classList.remove('mob-active');
      btn.setAttribute('aria-expanded', false);
    }
  });

  /* Close on outside tap */
  document.addEventListener('click', function (e) {
    if (!wrap.contains(e.target) && !btn.contains(e.target)) {
      wrap.classList.remove('mob-open');
      btn.classList.remove('mob-active');
      btn.setAttribute('aria-expanded', false);
    }
  });
}());
</script>
