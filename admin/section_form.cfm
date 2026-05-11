<!--- admin/section_form.cfm — edit a single page section --->
<cfinclude template="/includes/theme_loader.cfm">
<cfset request.layout    = "admin">
<cfset request.pageTitle = "Edit Section">
<cfset request.adminPage = "page_builder">

<cfparam name="url.section_id" default="0">
<cfparam name="url.page_slug"  default="home">

<cfif val(url.section_id) GT 0>
  <cfquery name="getSection" datasource="#application.dsn#">
    SELECT * FROM page_sections
    WHERE section_id = <cfqueryparam value="#val(url.section_id)#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfif getSection.recordCount EQ 0>
    <cflocation url="/admin/page_builder.cfm?page=#url.page_slug#" addtoken="false">
  </cfif>
  <cfset s = getSection>
<cfelse>
  <cflocation url="/admin/page_builder.cfm?page=#url.page_slug#" addtoken="false">
</cfif>

<cfinclude template="/themes/biotwine/layouts/admin_open.cfm">

<cfoutput>

<div style="display:flex; align-items:center; gap:1rem; margin-bottom:1.75rem; flex-wrap:wrap;">
  <a href="/admin/page_builder.cfm?page=#htmlEditFormat(s.page_slug)#" class="btn btn-outline btn-sm">
    <i class="bi bi-arrow-left me-1"></i>Back to Page Builder
  </a>
  <div>
    <h1 style="font-size:var(--font-size-2xl); margin:0;">Edit Section</h1>
    <p style="margin:0.25rem 0 0; font-size:var(--font-size-sm); color:var(--text-muted);">#htmlEditFormat(s.section_label)# &mdash; <code>#htmlEditFormat(s.section_type)#</code></p>
  </div>
</div>

<div id="form-messages"></div>

<form
  hx-post="/admin/section_save.cfm"
  hx-target="##form-messages"
  hx-swap="innerHTML"
  enctype="multipart/form-data"
>
  <input type="hidden" name="action"     value="update">
  <input type="hidden" name="section_id" value="#s.section_id#">
  <input type="hidden" name="page_slug"  value="#htmlEditFormat(s.page_slug)#">
  <input type="hidden" name="section_type" value="#htmlEditFormat(s.section_type)#">

  <!--- ── BASIC META ──────────────────────────────────────────────────────── --->
  <div class="admin-card" style="margin-bottom:1.25rem;">
    <div class="admin-card-header"><h2>Section Info</h2></div>
    <div class="admin-card-body">
      <div class="mb-3">
        <label class="form-label">Internal Label <span style="color:var(--text-muted); font-weight:400;">(admin only)</span></label>
        <input type="text" name="section_label" class="form-control" value="#htmlEditFormat(s.section_label)#">
      </div>
      <div class="mb-3">
        <label class="form-label">Active</label>
        <div>
          <label style="display:inline-flex; align-items:center; gap:0.5rem; cursor:pointer; font-size:var(--font-size-sm);">
            <input type="checkbox" name="is_active" value="1" #iif(s.is_active, de('checked'), de(''))#>
            Show this section on the page
          </label>
        </div>
      </div>
    </div>
  </div>

  <!--- ── HERO ──────────────────────────────────────────────────────────────── --->
  <cfif s.section_type EQ "hero" OR s.section_type EQ "page_hero">
  <div class="admin-card" style="margin-bottom:1.25rem;">
    <div class="admin-card-header"><h2>Headline</h2></div>
    <div class="admin-card-body">
      <cfif s.section_type EQ "hero">
      <div class="mb-3">
        <label class="form-label">Eyebrow Text <span style="color:var(--text-muted); font-weight:400;">(small tag above headline)</span></label>
        <input type="text" name="eyebrow" class="form-control" value="#htmlEditFormat(s.eyebrow)#" placeholder="e.g. Toppenish, Washington • Since 1994">
      </div>
      </cfif>
      <cfif s.section_type EQ "page_hero">
      <div class="mb-3">
        <label class="form-label">Eyebrow Text</label>
        <input type="text" name="eyebrow" class="form-control" value="#htmlEditFormat(s.eyebrow)#">
      </div>
      </cfif>
      <div class="mb-3">
        <label class="form-label">Headline <span style="color:##C0392B;">*</span></label>
        <input type="text" name="heading" class="form-control" value="#htmlEditFormat(s.heading)#">
      </div>
      <div class="mb-3">
        <label class="form-label">Subheading / Subtitle</label>
        <textarea name="subheading" class="form-control" rows="2">#htmlEditFormat(s.subheading)#</textarea>
      </div>
    </div>
  </div>

  <cfif s.section_type EQ "hero">
  <div class="admin-card" style="margin-bottom:1.25rem;">
    <div class="admin-card-header"><h2>Background Image</h2></div>
    <div class="admin-card-body">
      <div class="mb-3">
        <label class="form-label">Image Path or URL</label>
        <div style="display:flex; gap:0.5rem; align-items:center;">
          <input type="text" name="image" id="hero_image_field" class="form-control" value="#htmlEditFormat(s.image)#" placeholder="/assets/uploads/hero/filename.jpg">
          <label class="btn btn-outline" style="cursor:pointer; white-space:nowrap;">
            Upload <input type="file" accept="image/*" style="display:none;" onchange="btUploadImage(this,'hero_image_field','hero_image_preview','hero')">
          </label>
        </div>
        <div id="hero_image_preview" style="margin-top:0.5rem;">
          <cfif len(trim(s.image)) AND NOT findNoCase("vimeo",s.image) AND NOT findNoCase("youtube",s.image)>
            <img src="#htmlEditFormat(s.image)#" style="max-height:120px; border-radius:6px; border:1px solid var(--border-color);" onerror="this.style.display='none'">
          </cfif>
        </div>
      </div>
    </div>
  </div>

  <div class="admin-card" style="margin-bottom:1.25rem;">
    <div class="admin-card-header"><h2>Buttons</h2></div>
    <div class="admin-card-body">
      <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;" class="mb-3">
        <div>
          <label class="form-label">Button 1 Label</label>
          <input type="text" name="cta_label" class="form-control" value="#htmlEditFormat(s.cta_label)#" placeholder="View All Products">
        </div>
        <div>
          <label class="form-label">Button 1 URL</label>
          <input type="text" name="cta_url" class="form-control" value="#htmlEditFormat(s.cta_url)#" placeholder="/products.cfm">
        </div>
      </div>
      <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">
        <div>
          <label class="form-label">Button 2 Label</label>
          <input type="text" name="cta2_label" class="form-control" value="#htmlEditFormat(s.cta2_label)#" placeholder="Request a Quote">
        </div>
        <div>
          <label class="form-label">Button 2 URL</label>
          <input type="text" name="cta2_url" class="form-control" value="#htmlEditFormat(s.cta2_url)#" placeholder="/contact.cfm">
        </div>
      </div>
    </div>
  </div>
  </cfif>
  </cfif>

  <!--- ── ABOUT SPLIT ──────────────────────────────────────────────────────── --->
  <cfif s.section_type EQ "about_split">
  <div class="admin-card" style="margin-bottom:1.25rem;">
    <div class="admin-card-header"><h2>Headline</h2></div>
    <div class="admin-card-body">
      <div class="mb-3">
        <label class="form-label">Eyebrow Text</label>
        <input type="text" name="eyebrow" class="form-control" value="#htmlEditFormat(s.eyebrow)#" placeholder="e.g. Who We Are">
      </div>
      <div class="mb-3">
        <label class="form-label">Heading <span style="color:##C0392B;">*</span> <span style="color:var(--text-muted); font-weight:400;">(HTML allowed: &lt;em&gt;, &lt;strong&gt;)</span></label>
        <input type="text" name="heading" class="form-control" value="#s.heading#">
      </div>
    </div>
  </div>
  <div class="admin-card" style="margin-bottom:1.25rem;">
    <div class="admin-card-header"><h2>Image or Video</h2></div>
    <div class="admin-card-body">
      <div class="mb-3">
        <label class="form-label">Image path <strong>or</strong> Vimeo/YouTube embed URL</label>
        <div style="display:flex; gap:0.5rem; align-items:center;">
          <input type="text" name="image" id="split_image_field" class="form-control" value="#htmlEditFormat(s.image)#" placeholder="/assets/uploads/img/photo.jpg  or  https://player.vimeo.com/video/...">
          <label class="btn btn-outline" style="cursor:pointer; white-space:nowrap;">
            Upload <input type="file" accept="image/*" style="display:none;" onchange="btUploadImage(this,'split_image_field','split_image_preview','img')">
          </label>
        </div>
        <p style="font-size:0.75rem; color:var(--text-muted); margin-top:0.35rem;">Paste a Vimeo or YouTube player URL to show a video instead of an image.</p>
        <div id="split_image_preview" style="margin-top:0.5rem;">
          <cfif len(trim(s.image)) AND NOT findNoCase("vimeo",s.image) AND NOT findNoCase("youtube",s.image) AND NOT findNoCase("player.",s.image)>
            <img src="#htmlEditFormat(s.image)#" style="max-height:120px; border-radius:6px; border:1px solid var(--border-color);" onerror="this.style.display='none'">
          <cfelseif findNoCase("vimeo",s.image) OR findNoCase("youtube",s.image)>
            <div style="font-size:0.8rem; color:var(--text-muted); padding:0.5rem; background:var(--bg-section); border-radius:4px;"><i class="bi bi-play-circle me-1"></i>Video embed: #htmlEditFormat(s.image)#</div>
          </cfif>
        </div>
      </div>
      <div class="mb-3">
        <label class="form-label">Image Alt Text</label>
        <input type="text" name="image_alt" class="form-control" value="#htmlEditFormat(s.image_alt)#" placeholder="Descriptive text for screen readers">
      </div>
    </div>
  </div>
  <div class="admin-card" style="margin-bottom:1.25rem;">
    <div class="admin-card-header"><h2>Body Text</h2></div>
    <div class="admin-card-body">
      <textarea id="about_body" name="body_text" class="form-control" rows="8">#s.body_text#</textarea>
    </div>
  </div>
  <div class="admin-card" style="margin-bottom:1.25rem;">
    <div class="admin-card-header"><h2>Buttons</h2></div>
    <div class="admin-card-body">
      <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;" class="mb-3">
        <div>
          <label class="form-label">Button 1 Label</label>
          <input type="text" name="cta_label" class="form-control" value="#htmlEditFormat(s.cta_label)#">
        </div>
        <div>
          <label class="form-label">Button 1 URL</label>
          <input type="text" name="cta_url" class="form-control" value="#htmlEditFormat(s.cta_url)#">
        </div>
      </div>
      <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">
        <div>
          <label class="form-label">Button 2 Label</label>
          <input type="text" name="cta2_label" class="form-control" value="#htmlEditFormat(s.cta2_label)#">
        </div>
        <div>
          <label class="form-label">Button 2 URL</label>
          <input type="text" name="cta2_url" class="form-control" value="#htmlEditFormat(s.cta2_url)#">
        </div>
      </div>
    </div>
  </div>
  </cfif>

  <!--- ── CTA DARK ─────────────────────────────────────────────────────────── --->
  <cfif s.section_type EQ "cta_dark">
  <div class="admin-card" style="margin-bottom:1.25rem;">
    <div class="admin-card-header"><h2>CTA Content</h2></div>
    <div class="admin-card-body">
      <div class="mb-3">
        <label class="form-label">Eyebrow</label>
        <input type="text" name="eyebrow" class="form-control" value="#htmlEditFormat(s.eyebrow)#" placeholder="e.g. Get in Touch">
      </div>
      <div class="mb-3">
        <label class="form-label">Heading <span style="color:##C0392B;">*</span></label>
        <input type="text" name="heading" class="form-control" value="#htmlEditFormat(s.heading)#">
      </div>
      <div class="mb-3">
        <label class="form-label">Subheading</label>
        <textarea name="subheading" class="form-control" rows="3">#htmlEditFormat(s.subheading)#</textarea>
      </div>
      <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;" class="mb-3">
        <div>
          <label class="form-label">Button 1 Label</label>
          <input type="text" name="cta_label" class="form-control" value="#htmlEditFormat(s.cta_label)#">
        </div>
        <div>
          <label class="form-label">Button 1 URL</label>
          <input type="text" name="cta_url" class="form-control" value="#htmlEditFormat(s.cta_url)#">
        </div>
      </div>
      <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">
        <div>
          <label class="form-label">Button 2 Label</label>
          <input type="text" name="cta2_label" class="form-control" value="#htmlEditFormat(s.cta2_label)#">
        </div>
        <div>
          <label class="form-label">Button 2 URL</label>
          <input type="text" name="cta2_url" class="form-control" value="#htmlEditFormat(s.cta2_url)#">
        </div>
      </div>
    </div>
  </div>
  </cfif>

  <!--- ── STATS ─────────────────────────────────────────────────────────────── --->
  <cfif s.section_type EQ "stats">
  <div class="admin-card" style="margin-bottom:1.25rem;">
    <div class="admin-card-header">
      <h2>Stats Items</h2>
      <button type="button" class="btn btn-sm btn-outline" onclick="addStatRow()"><i class="bi bi-plus-lg me-1"></i>Add Stat</button>
    </div>
    <div class="admin-card-body">
      <p style="font-size:var(--font-size-sm); color:var(--text-muted); margin-bottom:1rem;">Each stat shows a large number/value and a small label beneath it.</p>
      <div id="stats-rows">
        <cfset statItems = []>
        <cftry><cfset statItems = deserializeJSON(s.extra_data)><cfcatch></cfcatch></cftry>
        <cfif isArray(statItems) AND arrayLen(statItems)>
          <cfloop array="#statItems#" index="si" item="st">
          <div class="stat-row" style="display:flex; gap:0.75rem; align-items:center; margin-bottom:0.625rem;">
            <input type="text" name="stat_number[]" class="form-control" value="#htmlEditFormat(st.number)#" placeholder="e.g. 100+" style="max-width:130px;">
            <input type="text" name="stat_label[]"  class="form-control" value="#htmlEditFormat(st.label)#"  placeholder="e.g. Years Experience">
            <button type="button" onclick="this.closest('.stat-row').remove()" class="btn btn-sm btn-outline" style="color:var(--color-error);" title="Remove"><i class="bi bi-trash"></i></button>
          </div>
          </cfloop>
        <cfelse>
          <div class="stat-row" style="display:flex; gap:0.75rem; align-items:center; margin-bottom:0.625rem;">
            <input type="text" name="stat_number[]" class="form-control" placeholder="e.g. 100+" style="max-width:130px;">
            <input type="text" name="stat_label[]"  class="form-control" placeholder="e.g. Years Experience">
            <button type="button" onclick="this.closest('.stat-row').remove()" class="btn btn-sm btn-outline" style="color:var(--color-error);" title="Remove"><i class="bi bi-trash"></i></button>
          </div>
        </cfif>
      </div>
      <input type="hidden" name="extra_data" id="stats_extra_data">
    </div>
  </div>
  </cfif>

  <!--- ── VALUES GRID ──────────────────────────────────────────────────────── --->
  <cfif s.section_type EQ "values">
  <div class="admin-card" style="margin-bottom:1.25rem;">
    <div class="admin-card-header"><h2>Section Header</h2></div>
    <div class="admin-card-body">
      <div class="mb-3">
        <label class="form-label">Eyebrow</label>
        <input type="text" name="eyebrow" class="form-control" value="#htmlEditFormat(s.eyebrow)#">
      </div>
      <div class="mb-3">
        <label class="form-label">Heading</label>
        <input type="text" name="heading" class="form-control" value="#htmlEditFormat(s.heading)#">
      </div>
    </div>
  </div>
  <div class="admin-card" style="margin-bottom:1.25rem;">
    <div class="admin-card-header">
      <h2>Value Cards</h2>
      <button type="button" class="btn btn-sm btn-outline" onclick="addValueRow()"><i class="bi bi-plus-lg me-1"></i>Add Card</button>
    </div>
    <div class="admin-card-body">
      <div id="values-rows">
        <cfset valueItems = []>
        <cftry><cfset valueItems = deserializeJSON(s.extra_data)><cfcatch></cfcatch></cftry>
        <cfif isArray(valueItems) AND arrayLen(valueItems)>
          <cfloop array="#valueItems#" index="vi" item="vl">
          <div class="value-row admin-card" style="margin-bottom:0.875rem; padding:1rem; background:var(--bg-section);">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:0.5rem;">
              <strong style="font-size:var(--font-size-sm);">Card #vi#</strong>
              <button type="button" onclick="this.closest('.value-row').remove()" class="btn btn-sm btn-outline" style="color:var(--color-error);"><i class="bi bi-trash"></i></button>
            </div>
            <div class="mb-2">
              <label class="form-label" style="font-size:0.8rem;">Card Heading</label>
              <input type="text" name="val_heading[]" class="form-control" value="#htmlEditFormat(vl.heading)#">
            </div>
            <div>
              <label class="form-label" style="font-size:0.8rem;">Card Text</label>
              <textarea name="val_text[]" class="form-control" rows="3">#htmlEditFormat(vl.text)#</textarea>
            </div>
          </div>
          </cfloop>
        <cfelse>
          <div class="value-row admin-card" style="margin-bottom:0.875rem; padding:1rem; background:var(--bg-section);">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:0.5rem;">
              <strong style="font-size:var(--font-size-sm);">Card 1</strong>
              <button type="button" onclick="this.closest('.value-row').remove()" class="btn btn-sm btn-outline" style="color:var(--color-error);"><i class="bi bi-trash"></i></button>
            </div>
            <div class="mb-2">
              <label class="form-label" style="font-size:0.8rem;">Card Heading</label>
              <input type="text" name="val_heading[]" class="form-control">
            </div>
            <div>
              <label class="form-label" style="font-size:0.8rem;">Card Text</label>
              <textarea name="val_text[]" class="form-control" rows="3"></textarea>
            </div>
          </div>
        </cfif>
      </div>
      <input type="hidden" name="extra_data" id="values_extra_data">
    </div>
  </div>
  </cfif>

  <!--- ── GALLERY ──────────────────────────────────────────────────────────── --->
  <cfif s.section_type EQ "gallery">
  <div class="admin-card" style="margin-bottom:1.25rem;">
    <div class="admin-card-header">
      <h2>Gallery Images</h2>
      <button type="button" class="btn btn-sm btn-outline" onclick="addGalleryRow()"><i class="bi bi-plus-lg me-1"></i>Add Image</button>
    </div>
    <div class="admin-card-body">
      <div id="gallery-rows">
        <cfset galleryItems = []>
        <cftry><cfset galleryItems = deserializeJSON(s.extra_data)><cfcatch></cfcatch></cftry>
        <cfif isArray(galleryItems) AND arrayLen(galleryItems)>
          <cfloop array="#galleryItems#" index="gi" item="gal">
          <div class="gallery-row" style="display:flex; gap:0.75rem; align-items:center; margin-bottom:0.625rem;">
            <div style="flex:1; display:flex; gap:0.5rem; align-items:center;">
              <input type="text" name="gal_image[]" class="form-control gallery-img-input" value="#htmlEditFormat(gal.image)#" placeholder="/assets/uploads/img/photo.jpg">
              <label class="btn btn-outline btn-sm" style="cursor:pointer; white-space:nowrap;">
                Upload <input type="file" accept="image/*" style="display:none;" onchange="btUploadGalleryImage(this, this.closest('.gallery-row'))">
              </label>
            </div>
            <input type="text" name="gal_alt[]" class="form-control" value="#htmlEditFormat(gal.alt)#" placeholder="Alt text" style="max-width:200px;">
            <button type="button" onclick="this.closest('.gallery-row').remove()" class="btn btn-sm btn-outline" style="color:var(--color-error);"><i class="bi bi-trash"></i></button>
          </div>
          </cfloop>
        <cfelse>
          <div class="gallery-row" style="display:flex; gap:0.75rem; align-items:center; margin-bottom:0.625rem;">
            <div style="flex:1; display:flex; gap:0.5rem; align-items:center;">
              <input type="text" name="gal_image[]" class="form-control gallery-img-input" placeholder="/assets/uploads/img/photo.jpg">
              <label class="btn btn-outline btn-sm" style="cursor:pointer; white-space:nowrap;">
                Upload <input type="file" accept="image/*" style="display:none;" onchange="btUploadGalleryImage(this, this.closest('.gallery-row'))">
              </label>
            </div>
            <input type="text" name="gal_alt[]" class="form-control" placeholder="Alt text" style="max-width:200px;">
            <button type="button" onclick="this.closest('.gallery-row').remove()" class="btn btn-sm btn-outline" style="color:var(--color-error);"><i class="bi bi-trash"></i></button>
          </div>
        </cfif>
      </div>
      <input type="hidden" name="extra_data" id="gallery_extra_data">
    </div>
  </div>
  </cfif>

  <!--- ── SAVE BAR ──────────────────────────────────────────────────────────── --->
  <div style="position:sticky; bottom:0; background:var(--bg-card); border-top:1px solid var(--border-color); padding:1rem 1.25rem; display:flex; gap:1rem; align-items:center; z-index:100; margin-top:1rem;">
    <button type="submit" id="save-btn" class="btn btn-primary btn-lg">
      <i class="bi bi-check2 me-1"></i>Save Section
    </button>
    <a href="/admin/page_builder.cfm?page=#htmlEditFormat(s.page_slug)#" class="btn btn-outline btn-lg">Cancel</a>
    <span id="save-spinner" class="htmx-indicator ms-2" style="color:var(--text-muted); font-size:var(--font-size-sm);">Saving…</span>
  </div>

</form>

<script>
// ── Summernote for body_text -------------------------------------------------
<cfif s.section_type EQ "about_split">
document.addEventListener('DOMContentLoaded', function() {
  if (typeof jQuery !== 'undefined' && jQuery.fn.summernote) {
    jQuery('##about_body').summernote({
      height: 300,
      toolbar: [
        ['style', ['bold','italic','underline','clear']],
        ['para', ['ul','ol']],
        ['insert', ['link','picture','hr']],
        ['view', ['codeview']]
      ],
      callbacks: {
        onImageUpload: function(files) {
          var fd = new FormData();
          fd.append('file', files[0]);
          fd.append('folder', 'img');
          fetch('/admin/upload_image.cfm', {method:'POST', body:fd})
            .then(r => r.json())
            .then(d => { if (d.ok) jQuery('##about_body').summernote('insertImage', d.url); });
        }
      }
    });
    document.querySelector('form').addEventListener('htmx:configRequest', function(e) {
      e.detail.parameters['body_text'] = jQuery('##about_body').summernote('code');
    });
  }
});
</cfif>

// ── Stats repeater ----------------------------------------------------------
function addStatRow() {
  var row = document.createElement('div');
  row.className = 'stat-row';
  row.style.cssText = 'display:flex; gap:0.75rem; align-items:center; margin-bottom:0.625rem;';
  row.innerHTML = '<input type="text" name="stat_number[]" class="form-control" placeholder="e.g. 100+" style="max-width:130px;">'
    + '<input type="text" name="stat_label[]" class="form-control" placeholder="e.g. Years Experience">'
    + '<button type="button" onclick="this.closest(\'.stat-row\').remove()" class="btn btn-sm btn-outline" style="color:var(--color-error);" title="Remove"><i class="bi bi-trash"></i></button>';
  document.getElementById('stats-rows').appendChild(row);
}

// ── Values repeater ---------------------------------------------------------
var _valCount = document.querySelectorAll('.value-row').length;
function addValueRow() {
  _valCount++;
  var row = document.createElement('div');
  row.className = 'value-row admin-card';
  row.style.cssText = 'margin-bottom:0.875rem; padding:1rem; background:var(--bg-section);';
  row.innerHTML = '<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:0.5rem;">'
    + '<strong style="font-size:var(--font-size-sm);">Card ' + _valCount + '</strong>'
    + '<button type="button" onclick="this.closest(\'.value-row\').remove()" class="btn btn-sm btn-outline" style="color:var(--color-error);"><i class="bi bi-trash"></i></button>'
    + '</div>'
    + '<div class="mb-2"><label class="form-label" style="font-size:0.8rem;">Card Heading</label>'
    + '<input type="text" name="val_heading[]" class="form-control"></div>'
    + '<div><label class="form-label" style="font-size:0.8rem;">Card Text</label>'
    + '<textarea name="val_text[]" class="form-control" rows="3"></textarea></div>';
  document.getElementById('values-rows').appendChild(row);
}

// ── Gallery repeater --------------------------------------------------------
function addGalleryRow() {
  var row = document.createElement('div');
  row.className = 'gallery-row';
  row.style.cssText = 'display:flex; gap:0.75rem; align-items:center; margin-bottom:0.625rem;';
  row.innerHTML = '<div style="flex:1; display:flex; gap:0.5rem; align-items:center;">'
    + '<input type="text" name="gal_image[]" class="form-control gallery-img-input" placeholder="/assets/uploads/img/photo.jpg">'
    + '<label class="btn btn-outline btn-sm" style="cursor:pointer; white-space:nowrap;">Upload '
    + '<input type="file" accept="image/*" style="display:none;" onchange="btUploadGalleryImage(this, this.closest(\'.gallery-row\'))">'
    + '</label></div>'
    + '<input type="text" name="gal_alt[]" class="form-control" placeholder="Alt text" style="max-width:200px;">'
    + '<button type="button" onclick="this.closest(\'.gallery-row\').remove()" class="btn btn-sm btn-outline" style="color:var(--color-error);"><i class="bi bi-trash"></i></button>';
  document.getElementById('gallery-rows').appendChild(row);
}

// Gallery image upload
function btUploadGalleryImage(input, row) {
  if (!input.files || !input.files[0]) return;
  var fd = new FormData();
  fd.append('file', input.files[0]);
  fd.append('folder', 'img');
  fetch('/admin/upload_image.cfm', {method:'POST', body:fd})
    .then(r => r.json())
    .then(function(d) {
      if (d.ok) {
        row.querySelector('.gallery-img-input').value = d.url;
      } else {
        alert('Upload failed: ' + (d.error || 'unknown error'));
      }
    });
}

// ── Pre-submit: pack repeater data into hidden extra_data fields ------------
document.querySelector('form').addEventListener('htmx:configRequest', function(e) {
  <cfif s.section_type EQ "stats">
  var nums   = document.querySelectorAll('[name="stat_number[]"]');
  var labels = document.querySelectorAll('[name="stat_label[]"]');
  var items  = [];
  for (var i = 0; i < nums.length; i++) {
    if (nums[i].value.trim()) {
      items.push({number: nums[i].value.trim(), label: labels[i].value.trim()});
    }
  }
  document.getElementById('stats_extra_data').value = JSON.stringify(items);
  e.detail.parameters['extra_data'] = JSON.stringify(items);
  </cfif>
  <cfif s.section_type EQ "values">
  var heads  = document.querySelectorAll('[name="val_heading[]"]');
  var texts  = document.querySelectorAll('[name="val_text[]"]');
  var items  = [];
  for (var i = 0; i < heads.length; i++) {
    if (heads[i].value.trim()) {
      items.push({heading: heads[i].value.trim(), text: texts[i].value.trim()});
    }
  }
  document.getElementById('values_extra_data').value = JSON.stringify(items);
  e.detail.parameters['extra_data'] = JSON.stringify(items);
  </cfif>
  <cfif s.section_type EQ "gallery">
  var imgs = document.querySelectorAll('[name="gal_image[]"]');
  var alts = document.querySelectorAll('[name="gal_alt[]"]');
  var items = [];
  for (var i = 0; i < imgs.length; i++) {
    if (imgs[i].value.trim()) {
      items.push({image: imgs[i].value.trim(), alt: alts[i].value.trim()});
    }
  }
  document.getElementById('gallery_extra_data').value = JSON.stringify(items);
  e.detail.parameters['extra_data'] = JSON.stringify(items);
  </cfif>
});
</script>

</cfoutput>

<cfinclude template="/themes/biotwine/layouts/admin_close.cfm">
