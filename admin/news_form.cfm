<!--- /admin/news_form.cfm --->
<cfinclude template="/includes/theme_loader.cfm">
<cfparam name="url.news_id" default="0">

<cfset isNew = NOT val(url.news_id)>
<cfset request.layout    = "admin">
<cfset request.pageTitle = "#iif(isNew,de('New Article'),de('Edit Article'))#">
<cfset request.adminPage = "news">

<cfif NOT isNew>
  <cftry>
    <cfquery name="getRecord" datasource="#application.dsn#">
      SELECT * FROM news
      WHERE news_id = <cfqueryparam value="#url.news_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getRecord.recordCount EQ 0>
      <cflocation url="/admin/news_list.cfm" addtoken="false">
    </cfif>
    <cfcatch type="database">
      <cflocation url="/admin/news_list.cfm" addtoken="false">
    </cfcatch>
  </cftry>
</cfif>

<cfparam name="getRecord.news_id"    default="0">
<cfparam name="getRecord.title"      default="">
<cfparam name="getRecord.slug"       default="">
<cfparam name="getRecord.excerpt"    default="">
<cfparam name="getRecord.body"       default="">
<cfparam name="getRecord.image"      default="">
<cfparam name="getRecord.pub_date"   default="#dateFormat(now(),'yyyy-mm-dd')#">
<cfparam name="getRecord.is_active"  default="1">
<cfparam name="getRecord.meta_title" default="">
<cfparam name="getRecord.meta_desc"  default="">

<cfinclude template="/themes/biotwine/layouts/admin_open.cfm">

<!--- Summernote CSS --->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-bs5.min.css">

<cfoutput>

<div style="margin-bottom:1rem;">
  <a href="/admin/news_list.cfm" style="font-size:var(--font-size-sm); color:var(--text-muted);">&larr; Back to News</a>
</div>

<div class="admin-card">
  <div class="admin-card-header">
    <h2><cfif isNew>New Article<cfelse>Edit: #htmlEditFormat(getRecord.title)#</cfif></h2>
  </div>
  <div class="admin-card-body">

    <div id="form-messages"></div>

    <form
      hx-post="/admin/news_save.cfm"
      hx-target="##form-messages"
      hx-swap="innerHTML"
      hx-indicator="##save-spinner"
      class="admin-form"
    >
      <input type="hidden" name="news_id" value="#getRecord.news_id#">

      <div style="display:grid; grid-template-columns:1fr; gap:1.25rem;">

        <div class="form-group">
          <label>Title *</label>
          <input type="text" name="title" class="form-control" value="#htmlEditFormat(getRecord.title)#" required
            placeholder="Article headline..."
            oninput="if(!this.dataset.slugEdited) document.getElementById('slug-field').value = this.value.toLowerCase().replace(/[^a-z0-9\s-]/g,'').replace(/\s+/g,'-').replace(/-+/g,'-').trim()">
        </div>

        <div class="form-group">
          <label>URL Slug *</label>
          <input type="text" id="slug-field" name="slug" class="form-control" value="#htmlEditFormat(getRecord.slug)#" required
            placeholder="url-friendly-slug" style="font-family:var(--font-mono);"
            oninput="this.dataset.slugEdited='1'">
          <div style="font-size:0.75rem; color:var(--text-muted); margin-top:0.3rem;">URL: /news_detail.cfm?slug=<strong>your-slug</strong></div>
        </div>

        <div class="form-group">
          <label>Excerpt (shown on news listing)</label>
          <textarea name="excerpt" class="form-control" rows="3" placeholder="Brief summary...">#htmlEditFormat(getRecord.excerpt)#</textarea>
        </div>

        <div class="form-group">
          <label>Body Content</label>
          <textarea name="body" id="news_body" class="form-control">#getRecord.body#</textarea>
        </div>

        <div style="display:grid; grid-template-columns:1fr 1fr; gap:1.25rem;">
          <div class="form-group">
            <label>Publish Date *</label>
            <input type="date" name="pub_date" class="form-control" value="#dateFormat(getRecord.pub_date,'yyyy-mm-dd')#" required>
          </div>
          <div class="form-group">
            <label>Hero Image</label>
            <div style="display:flex; gap:0.5rem; align-items:center;">
              <input type="text" name="image" id="news_image_field" class="form-control"
                value="#htmlEditFormat(getRecord.image)#" placeholder="filename.jpg">
              <label class="btn btn-outline" style="cursor:pointer; white-space:nowrap; margin:0; padding:0.45rem 0.75rem;">
                Upload
                <input type="file" accept="image/jpeg,image/png,image/gif,image/webp" style="display:none;"
                  onchange="btUploadImage(this,'news_image_field','news_image_preview','img')">
              </label>
            </div>
            <div id="news_image_preview" style="margin-top:0.5rem;">
              <cfif len(trim(getRecord.image))>
                <img src="/assets/uploads/img/#htmlEditFormat(getRecord.image)#"
                  style="max-height:72px; border-radius:4px; border:1px solid var(--border-color);"
                  onerror="this.style.display='none'">
              </cfif>
            </div>
          </div>
        </div>

        <hr style="border-color:var(--border-color); margin:0.5rem 0;">

        <div style="display:grid; grid-template-columns:1fr 1fr; gap:1.25rem;">
          <div class="form-group">
            <label>Meta Title (SEO)</label>
            <input type="text" name="meta_title" class="form-control" value="#htmlEditFormat(getRecord.meta_title)#" placeholder="Leave blank to use article title">
          </div>
          <div class="form-group">
            <label>Meta Description (SEO)</label>
            <input type="text" name="meta_desc" class="form-control" value="#htmlEditFormat(getRecord.meta_desc)#" placeholder="150–160 characters">
          </div>
        </div>

        <div class="form-group">
          <label style="display:flex; align-items:center; gap:0.5rem; cursor:pointer; font-weight:400;">
            <input type="hidden" name="is_active" value="0">
            <input type="checkbox" name="is_active" value="1" <cfif getRecord.is_active>checked</cfif> style="width:16px;height:16px;">
            Published (visible on site)
          </label>
        </div>

      </div>

      <div style="margin-top:1.5rem; display:flex; gap:1rem; align-items:center;">
        <button type="submit" class="btn btn-primary">
          <span id="save-spinner" class="htmx-indicator me-1">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" style="animation:spin 1s linear infinite; vertical-align:middle;"><path d="M12 2a10 10 0 0 1 10 10"/></svg>
          </span>
          Save Article
        </button>
        <a href="/admin/news_list.cfm" class="btn btn-outline">Cancel</a>
      </div>

    </form>
  </div>
</div>

<style>@keyframes spin { to { transform:rotate(360deg); } }</style>

</cfoutput>

<cfinclude template="/themes/biotwine/layouts/admin_close.cfm">

<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-bs5.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {

  // ── Summernote on body ───────────────────────────────────────────
  var $body = jQuery('#news_body');
  $body.summernote({
    height: 380,
    placeholder: 'Full article body...',
    toolbar: [
      ['style',   ['bold', 'italic', 'underline', 'clear']],
      ['para',    ['ul', 'ol', 'paragraph']],
      ['insert',  ['link', 'picture', 'hr']],
      ['view',    ['codeview', 'fullscreen']],
      ['history', ['undo', 'redo']]
    ]
  });

  // Sync Summernote → textarea before HTMX submits
  document.querySelector('form').addEventListener('htmx:configRequest', function (e) {
    e.detail.parameters['body'] = $body.summernote('code');
  });

});

// btUploadImage provided by admin.js
</script>
