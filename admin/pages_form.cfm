<cfinclude template="/includes/theme_loader.cfm">

<cfparam name="url.page_id" default="0">

<cfset isEdit = val(url.page_id) GT 0>

<!--- Load existing record if editing --->
<cfif isEdit>
    <cftry>
        <cfquery name="getPage" datasource="#application.dsn#">
            SELECT *
            FROM pages
            WHERE page_id = <cfqueryparam value="#url.page_id#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfcatch type="database">
            <cflog file="app_errors" text="pages_form.cfm load error: #cfcatch.message# — #cfcatch.detail#">
            <cflocation url="pages_list.cfm" addtoken="false">
        </cfcatch>
    </cftry>
    <cfif getPage.recordCount EQ 0>
        <cflocation url="pages_list.cfm" addtoken="false">
    </cfif>
</cfif>

<!--- Safe defaults --->
<cfparam name="getPage.page_id"      default="0">
<cfparam name="getPage.slug"         default="">
<cfparam name="getPage.nav_title"    default="">
<cfparam name="getPage.page_title"   default="">
<cfparam name="getPage.hero_heading" default="">
<cfparam name="getPage.hero_subhead" default="">
<cfparam name="getPage.hero_image"   default="">
<cfparam name="getPage.body_content" default="">
<cfparam name="getPage.meta_title"   default="">
<cfparam name="getPage.meta_desc"    default="">
<cfparam name="getPage.is_active"    default="1">
<cfparam name="getPage.has_dropdown" default="0">
<cfparam name="getPage.layout_type"  default="generic">
<cfparam name="getPage.show_hero"    default="0">
<cfparam name="getPage.sort_order"   default="0">

<cfset request.layout    = "admin">
<cfset request.pageTitle = "#iif(isEdit, de('Edit Page'), de('New Page'))#">

<cfinclude template="/themes/#application.theme#/layouts/admin_open.cfm">

<cfoutput>
<!--- Summernote CSS --->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-bs5.min.css">

<div class="d-flex justify-content-between align-items-center mb-4">
    <h1 class="h3 mb-0">#iif(isEdit, de('Edit Page'), de('New Page'))#</h1>
    <a href="pages_list.cfm" class="btn btn-outline-secondary">
        <i class="bi bi-arrow-left me-1"></i> Back to Pages
    </a>
</div>

<div id="form-messages"></div>

<form
    hx-post="pages_save.cfm"
    hx-target="##form-messages"
    hx-swap="innerHTML"
    hx-indicator="##save-spinner"
>
    <input type="hidden" name="page_id" value="#getPage.page_id#">

    <div class="row g-4">

        <!--- LEFT COLUMN --->
        <div class="col-lg-8">

            <!--- Basic Info --->
            <div class="card mb-4">
                <div class="card-header fw-semibold">Page Info</div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Nav Title <span class="text-danger">*</span></label>
                            <input type="text" name="nav_title" class="form-control"
                                value="#htmlEditFormat(getPage.nav_title)#" required
                                placeholder="Appears in navigation">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Page Title <span class="text-danger">*</span></label>
                            <input type="text" name="page_title" class="form-control"
                                value="#htmlEditFormat(getPage.page_title)#" required
                                placeholder="H1 heading on the page">
                        </div>
                        <div class="col-md-8">
                            <label class="form-label">Slug <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text text-muted">/</span>
                                <input type="text" name="slug" class="form-control"
                                    value="#htmlEditFormat(getPage.slug)#" required
                                    placeholder="privacy-policy">
                            </div>
                            <div class="form-text">URL-friendly, lowercase, hyphens only</div>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Sort Order</label>
                            <input type="number" name="sort_order" class="form-control"
                                value="#getPage.sort_order#" min="0">
                        </div>
                    </div>
                </div>
            </div>

            <!--- Hero Section (shown/hidden based on layout_type + show_hero) --->
            <div class="card mb-4" id="hero-card">
                <div class="card-header fw-semibold">Hero Section</div>
                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label">Hero Heading</label>
                        <input type="text" name="hero_heading" class="form-control"
                            value="#htmlEditFormat(getPage.hero_heading)#"
                            placeholder="Large headline in the hero banner">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Hero Subheading</label>
                        <textarea name="hero_subhead" class="form-control" rows="3"
                            placeholder="Supporting text below the hero heading">#htmlEditFormat(getPage.hero_subhead)#</textarea>
                    </div>
                    <div class="mb-0">
                        <label class="form-label">Hero Image</label>
                        <input type="text" name="hero_image" class="form-control"
                            value="#htmlEditFormat(getPage.hero_image)#"
                            placeholder="/assets/uploads/hero/filename.jpg">
                        <div class="form-text">Relative path or full URL to the hero background image</div>
                    </div>
                </div>
            </div>

            <!--- Body Content — Summernote WYSIWYG --->
            <div class="card mb-4">
                <div class="card-header fw-semibold">Body Content</div>
                <div class="card-body">
                    <textarea name="body_content" id="body_content" class="form-control">#getPage.body_content#</textarea>
                    <div class="form-text mt-2">
                        <i class="bi bi-info-circle me-1"></i>
                        For <strong>generic</strong> pages this content is rendered directly on the public page.
                        For <strong>custom</strong> pages this is stored for reference — the layout file controls display.
                    </div>
                </div>
            </div>

            <!--- SEO --->
            <div class="card mb-4">
                <div class="card-header fw-semibold">SEO</div>
                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label">Meta Title</label>
                        <input type="text" name="meta_title" class="form-control"
                            value="#htmlEditFormat(getPage.meta_title)#"
                            placeholder="Overrides page title in &lt;title&gt; tag">
                        <div class="form-text">Recommended: 50–60 characters</div>
                    </div>
                    <div class="mb-0">
                        <label class="form-label">Meta Description</label>
                        <textarea name="meta_desc" class="form-control" rows="3"
                            placeholder="Search engine snippet description">#htmlEditFormat(getPage.meta_desc)#</textarea>
                        <div class="form-text">Recommended: 150–160 characters</div>
                    </div>
                </div>
            </div>

        </div>

        <!--- RIGHT COLUMN --->
        <div class="col-lg-4">

            <!--- Publish Settings --->
            <div class="card mb-4">
                <div class="card-header fw-semibold">Publish</div>
                <div class="card-body">
                    <div class="form-check form-switch mb-3">
                        <input type="hidden" name="is_active" value="0">
                        <input type="checkbox" name="is_active" value="1"
                            class="form-check-input" id="is_active"
                            #iif(getPage.is_active, de('checked'), de(''))#>
                        <label class="form-check-label" for="is_active">Active (visible on site)</label>
                    </div>
                    <div class="form-check form-switch mb-3">
                        <input type="hidden" name="has_dropdown" value="0">
                        <input type="checkbox" name="has_dropdown" value="1"
                            class="form-check-input" id="has_dropdown"
                            #iif(getPage.has_dropdown, de('checked'), de(''))#>
                        <label class="form-check-label" for="has_dropdown">Has dropdown menu</label>
                    </div>

                    <button type="submit" class="btn btn-primary w-100">
                        <span id="save-spinner" class="htmx-indicator spinner-border spinner-border-sm me-1"></span>
                        <i class="bi bi-floppy me-1"></i>
                        #iif(isEdit, de('Save Changes'), de('Create Page'))#
                    </button>

                    <cfif isEdit>
                    <div class="mt-3 pt-3 border-top">
                        <cfif getPage.layout_type EQ "generic">
                        <a href="/page.cfm?slug=#urlEncodedFormat(getPage.slug)#" class="btn btn-outline-secondary btn-sm w-100" target="_blank">
                            <i class="bi bi-box-arrow-up-right me-1"></i> View Page
                        </a>
                        <cfelse>
                        <a href="/#htmlEditFormat(getPage.slug)#.cfm" class="btn btn-outline-secondary btn-sm w-100" target="_blank">
                            <i class="bi bi-box-arrow-up-right me-1"></i> View Page
                        </a>
                        </cfif>
                    </div>
                    </cfif>
                </div>
            </div>

            <!--- Layout Type --->
            <div class="card mb-4">
                <div class="card-header fw-semibold">Layout Type</div>
                <div class="card-body">
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="radio" name="layout_type"
                            id="layout_generic" value="generic"
                            #iif(getPage.layout_type EQ 'generic', de('checked'), de(''))#>
                        <label class="form-check-label" for="layout_generic">
                            <strong>Generic</strong>
                            <div class="form-text mt-0">Rendered by <code>page.cfm</code> router. Body content controls the page.</div>
                        </label>
                    </div>
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="radio" name="layout_type"
                            id="layout_custom" value="custom"
                            #iif(getPage.layout_type EQ 'custom', de('checked'), de(''))#>
                        <label class="form-check-label" for="layout_custom">
                            <strong>Custom</strong>
                            <div class="form-text mt-0">Has its own <code>/#htmlEditFormat(getPage.slug)#.cfm</code> file with a unique layout.</div>
                        </label>
                    </div>

                    <!--- Show hero toggle — only relevant for generic pages --->
                    <div id="hero-toggle-wrap" class="pt-2 border-top">
                        <div class="form-check form-switch">
                            <input type="hidden" name="show_hero" value="0">
                            <input type="checkbox" name="show_hero" value="1"
                                class="form-check-input" id="show_hero"
                                #iif(getPage.show_hero, de('checked'), de(''))#>
                            <label class="form-check-label" for="show_hero">Show hero section</label>
                        </div>
                        <div class="form-text">Only applies to generic pages.</div>
                    </div>
                </div>
            </div>

        </div>
    </div>

</form>

</cfoutput>

<cfinclude template="/themes/#application.theme#/layouts/admin_close.cfm">

<!--- jQuery + Summernote load AFTER Bootstrap JS (which is in admin_close) --->
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-bs5.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    var editor = document.getElementById('body_content');
    if (typeof jQuery === 'undefined' || !editor) return;

    jQuery(editor).summernote({
        height: 400,
        placeholder: 'Enter page content here...',
        toolbar: [
            ['style',   ['bold', 'italic', 'underline', 'clear']],
            ['font',    ['strikethrough', 'superscript', 'subscript']],
            ['para',    ['ul', 'ol', 'paragraph']],
            ['insert',  ['link', 'picture', 'hr']],
            ['view',    ['codeview', 'fullscreen']],
            ['history', ['undo', 'redo']]
        ]
    });

    // HTMX: sync Summernote HTML to textarea before form submission
    document.querySelector('form').addEventListener('htmx:configRequest', function(e) {
        e.detail.parameters['body_content'] = jQuery(editor).summernote('code');
    });

    // Layout type radio — toggle hero card visibility
    function toggleHeroCard() {
        var isGeneric = document.getElementById('layout_generic').checked;
        document.getElementById('hero-card').style.display        = isGeneric ? '' : 'none';
        document.getElementById('hero-toggle-wrap').style.display = isGeneric ? '' : 'none';
    }

    document.getElementById('layout_generic').addEventListener('change', toggleHeroCard);
    document.getElementById('layout_custom').addEventListener('change', toggleHeroCard);
    toggleHeroCard(); // run on load
});
</script>
