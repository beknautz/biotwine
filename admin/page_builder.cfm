<!--- admin/page_builder.cfm — visual page section manager --->
<cfinclude template="/includes/theme_loader.cfm">
<cfset request.layout    = "admin">
<cfset request.pageTitle = "Page Builder">
<cfset request.adminPage = "page_builder">

<cfparam name="url.page" default="home">
<cfset validPages = "home,about,products,contact">
<cfif NOT listFindNoCase(validPages, url.page)>
  <cfset url.page = "home">
</cfif>
<cfset currentPage = lCase(url.page)>
<!--- pageSlug needed by _section_list_partial.cfm --->
<cfset pageSlug = currentPage>

<cfinclude template="/themes/biotwine/layouts/admin_open.cfm">

<cfoutput>

<div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:1.75rem; flex-wrap:wrap; gap:1rem;">
  <div>
    <h1 style="font-size:var(--font-size-2xl); margin:0;">Page Builder</h1>
    <p style="color:var(--text-muted); margin:0.25rem 0 0; font-size:var(--font-size-sm);">Add, edit, reorder, and toggle sections for each page.</p>
  </div>
  <button class="btn btn-primary" onclick="document.getElementById('add-modal').style.display='flex'">
    <i class="bi bi-plus-lg me-1"></i> Add Section
  </button>
</div>

<!--- Page tabs --->
<div style="display:flex; gap:0; border-bottom:2px solid var(--border-color); margin-bottom:1.75rem; overflow-x:auto;">
  <cfloop list="#validPages#" index="pg">
  <a href="/admin/page_builder.cfm?page=#pg#"
     style="padding:0.75rem 1.5rem; font-size:var(--font-size-sm); font-weight:600; text-decoration:none; white-space:nowrap; border-bottom:2px solid <cfif pg EQ currentPage>var(--color-forest)<cfelse>transparent</cfif>; margin-bottom:-2px; color:<cfif pg EQ currentPage>var(--color-forest)<cfelse>var(--text-muted)</cfif>;">
    #uCase(left(pg,1))##lCase(right(pg,len(pg)-1))#
  </a>
  </cfloop>
</div>

<!--- Sections list (also the HTMX swap target) --->
<div id="sections-list">
</cfoutput>
  <cfinclude template="/admin/_section_list_partial.cfm">
<cfoutput>
</div>

<!--- Add Section Modal --->
<div id="add-modal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.55); z-index:1000; align-items:center; justify-content:center;">
  <div style="background:var(--bg-card); border-radius:var(--border-radius-lg); width:min(500px,95vw); padding:2rem; box-shadow:var(--shadow-xl); position:relative;">
    <button onclick="document.getElementById('add-modal').style.display='none'" style="position:absolute; top:1rem; right:1rem; background:none; border:none; cursor:pointer; font-size:1.4rem; color:var(--text-muted); line-height:1;">&times;</button>
    <h2 style="font-size:var(--font-size-xl); margin:0 0 1.25rem;">Add New Section</h2>
    <form method="post" action="/admin/section_save.cfm">
      <input type="hidden" name="page_slug" value="#htmlEditFormat(currentPage)#">
      <input type="hidden" name="action"    value="add">
      <div class="mb-3">
        <label class="form-label">Section Type <span style="color:##C0392B;">*</span></label>
        <select name="section_type" class="form-control" required>
          <option value="">-- Choose a type --</option>
          <cfif currentPage EQ "home">
          <option value="hero">Hero — Full-width banner with background image</option>
          <option value="stats">Stats Bar — Row of numbers/stats</option>
          <option value="about_split">About Split — Image (or video) + text side by side</option>
          <option value="gallery">Photo Gallery — Grid of images</option>
          <option value="testimonials">Testimonials Carousel</option>
          <option value="cta_dark">Dark CTA — Call-to-action strip</option>
          <cfelseif currentPage EQ "about">
          <option value="page_hero">Page Header — Title at top of page</option>
          <option value="about_split">About Split — Image + text side by side</option>
          <option value="values">Values Grid — Feature cards (2×2)</option>
          <option value="cta_dark">Dark CTA — Call-to-action strip</option>
          <cfelseif currentPage EQ "products">
          <option value="page_hero">Page Header — Title at top of page</option>
          <option value="cta_dark">Dark CTA — Call-to-action strip</option>
          <cfelseif currentPage EQ "contact">
          <option value="page_hero">Page Header — Title at top of page</option>
          </cfif>
        </select>
      </div>
      <div class="mb-3">
        <label class="form-label">Internal Label <span style="color:var(--text-muted); font-weight:400;">(admin only, not shown on site)</span></label>
        <input type="text" name="section_label" class="form-control" placeholder="e.g. Homepage Hero">
      </div>
      <div style="display:flex; gap:0.75rem; justify-content:flex-end; margin-top:1.5rem;">
        <button type="button" class="btn btn-outline" onclick="document.getElementById('add-modal').style.display='none'">Cancel</button>
        <button type="submit" class="btn btn-primary">Create &amp; Edit</button>
      </div>
    </form>
  </div>
</div>

<script>
document.getElementById('add-modal').addEventListener('click', function(e) {
  if (e.target === this) this.style.display = 'none';
});
</script>

</cfoutput>

<cfinclude template="/themes/biotwine/layouts/admin_close.cfm">
