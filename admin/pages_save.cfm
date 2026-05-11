<cfparam name="form.page_id"      default="0">
<cfparam name="form.slug"         default="">
<cfparam name="form.nav_title"    default="">
<cfparam name="form.page_title"   default="">
<cfparam name="form.hero_heading" default="">
<cfparam name="form.hero_subhead" default="">
<cfparam name="form.hero_image"   default="">
<cfparam name="form.body_content" default="">
<cfparam name="form.meta_title"   default="">
<cfparam name="form.meta_desc"    default="">
<cfparam name="form.is_active"    default="0">
<cfparam name="form.has_dropdown" default="0">
<cfparam name="form.layout_type"  default="generic">
<cfparam name="form.show_hero"    default="0">
<cfparam name="form.sort_order"   default="0">

<!--- Normalize checkboxes — hidden+checkbox submit "0,1" when checked --->
<cfset isActive    = (listLast(trim(form.is_active))    EQ 1) ? 1 : 0>
<cfset hasDropdown = (listLast(trim(form.has_dropdown)) EQ 1) ? 1 : 0>
<cfset showHero    = (listLast(trim(form.show_hero))    EQ 1) ? 1 : 0>

<!--- Sanitize layout_type — only allow known values --->
<cfset layoutType = (form.layout_type EQ "custom") ? "custom" : "generic">

<!--- Web root path for shell file writing --->
<cfset webRoot = "D:\home\biotwine.com\wwwroot\">

<!--- Basic validation --->
<cfif NOT len(trim(form.nav_title)) OR NOT len(trim(form.page_title)) OR NOT len(trim(form.slug))>
    <cfoutput>
    <div class="alert alert-danger">
        <i class="bi bi-exclamation-triangle me-2"></i>
        Nav Title, Page Title, and Slug are required.
    </div>
    </cfoutput>
    <cfabort>
</cfif>

<!--- Sanitize slug --->
<cfset cleanSlug = lCase(trim(form.slug))>
<cfset cleanSlug = reReplace(cleanSlug, "[^a-z0-9\-]", "-", "ALL")>
<cfset cleanSlug = reReplace(cleanSlug, "-{2,}", "-", "ALL")>
<cfset cleanSlug = reReplace(cleanSlug, "^-|-$", "", "ALL")>

<!--- Protected shells — never auto-delete these even if switching to generic --->
<cfset protectedSlugs = "index,home,products,contact,news,news_detail">

<cftry>

    <!--- Check slug uniqueness --->
    <cfquery name="checkSlug" datasource="#application.dsn#">
        SELECT page_id FROM pages
        WHERE slug = <cfqueryparam value="#cleanSlug#" cfsqltype="cf_sql_varchar">
        <cfif val(form.page_id)>
            AND page_id != <cfqueryparam value="#form.page_id#" cfsqltype="cf_sql_integer">
        </cfif>
    </cfquery>

    <cfif checkSlug.recordCount GT 0>
        <cfoutput>
        <div class="alert alert-danger">
            <i class="bi bi-exclamation-triangle me-2"></i>
            The slug "<strong>#htmlEditFormat(cleanSlug)#</strong>" is already in use. Please choose a different slug.
        </div>
        </cfoutput>
        <cfabort>
    </cfif>

    <!--- On UPDATE: get the previous slug and layout_type so we can
          rename/delete shell files if either changed --->
    <cfif val(form.page_id)>
        <cfquery name="getPrev" datasource="#application.dsn#">
            SELECT slug, layout_type FROM pages
            WHERE page_id = <cfqueryparam value="#form.page_id#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfset prevSlug   = getPrev.recordCount ? getPrev.slug        : "">
        <cfset prevLayout = getPrev.recordCount ? getPrev.layout_type : "generic">
    </cfif>

    <!--- ── DB WRITE ──────────────────────────────────────────── --->
    <cfif val(form.page_id)>
        <!--- UPDATE --->
        <cfquery datasource="#application.dsn#">
            UPDATE pages SET
                slug         = <cfqueryparam value="#cleanSlug#"               cfsqltype="cf_sql_varchar">,
                nav_title    = <cfqueryparam value="#trim(form.nav_title)#"    cfsqltype="cf_sql_varchar">,
                page_title   = <cfqueryparam value="#trim(form.page_title)#"   cfsqltype="cf_sql_varchar">,
                hero_heading = <cfqueryparam value="#trim(form.hero_heading)#" cfsqltype="cf_sql_varchar">,
                hero_subhead = <cfqueryparam value="#trim(form.hero_subhead)#" cfsqltype="cf_sql_varchar">,
                hero_image   = <cfqueryparam value="#trim(form.hero_image)#"   cfsqltype="cf_sql_varchar">,
                body_content = <cfqueryparam value="#trim(form.body_content)#" cfsqltype="cf_sql_longvarchar">,
                meta_title   = <cfqueryparam value="#trim(form.meta_title)#"   cfsqltype="cf_sql_varchar">,
                meta_desc    = <cfqueryparam value="#trim(form.meta_desc)#"    cfsqltype="cf_sql_varchar">,
                is_active    = <cfqueryparam value="#isActive#"                cfsqltype="cf_sql_integer">,
                has_dropdown = <cfqueryparam value="#hasDropdown#"             cfsqltype="cf_sql_integer">,
                layout_type  = <cfqueryparam value="#layoutType#"              cfsqltype="cf_sql_varchar">,
                show_hero    = <cfqueryparam value="#showHero#"                cfsqltype="cf_sql_integer">,
                sort_order   = <cfqueryparam value="#val(form.sort_order)#"    cfsqltype="cf_sql_integer">,
                updated_at   = NOW()
            WHERE page_id = <cfqueryparam value="#form.page_id#" cfsqltype="cf_sql_integer">
        </cfquery>
    <cfelse>
        <!--- INSERT --->
        <cfquery datasource="#application.dsn#" result="insertResult">
            INSERT INTO pages (
                slug, nav_title, page_title,
                hero_heading, hero_subhead, hero_image,
                body_content, meta_title, meta_desc,
                is_active, has_dropdown, layout_type, show_hero,
                sort_order, created_at, updated_at
            ) VALUES (
                <cfqueryparam value="#cleanSlug#"               cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#trim(form.nav_title)#"    cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#trim(form.page_title)#"   cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#trim(form.hero_heading)#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#trim(form.hero_subhead)#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#trim(form.hero_image)#"   cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#trim(form.body_content)#" cfsqltype="cf_sql_longvarchar">,
                <cfqueryparam value="#trim(form.meta_title)#"   cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#trim(form.meta_desc)#"    cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#isActive#"                cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#hasDropdown#"             cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#layoutType#"              cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#showHero#"                cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#val(form.sort_order)#"    cfsqltype="cf_sql_integer">,
                NOW(), NOW()
            )
        </cfquery>
        <cfset newPageID = insertResult.generatedKey>
    </cfif>

    <!--- ── SHELL FILE MANAGEMENT ────────────────────────────── --->
    <cfset shellMsg = "">

    <cfif layoutType EQ "custom">

        <!--- Build the shell file content --->
        <cfset metaDescValue = len(trim(form.meta_desc)) ? trim(form.meta_desc) : trim(form.page_title)>
        <cfset shellContent = '<!--- ' & cleanSlug & '.cfm — shell template, content managed in DB via pages table --->' & Chr(10)>
        <cfset shellContent = shellContent & '<cfinclude template="/includes/theme_loader.cfm">' & Chr(10)>
        <cfset shellContent = shellContent & '<cfset request.layout    = "default">' & Chr(10)>
        <cfset shellContent = shellContent & '<cfset request.pageTitle = "' & trim(form.page_title) & '">' & Chr(10)>
        <cfset shellContent = shellContent & '<cfset request.metaDesc  = "' & replace(metaDescValue, '"', '&quot;', 'ALL') & '">' & Chr(10)>
        <cfset shellContent = shellContent & '<cfset request.slug      = "' & cleanSlug & '">' & Chr(10)>
        <cfset shellContent = shellContent & '<cfinclude template="/includes/page_loader.cfm">' & Chr(10)>
        <cfset shellContent = shellContent & '<cfinclude template="/themes/biotwine/layouts/default_open.cfm">' & Chr(10)>
        <cfset shellContent = shellContent & '<cfoutput>##request.page.body_content##</cfoutput>' & Chr(10)>
        <cfset shellContent = shellContent & '<cfinclude template="/themes/biotwine/layouts/default_close.cfm">' & Chr(10)>

        <cfset newShellPath = webRoot & cleanSlug & ".cfm">

        <!--- If slug changed on an existing custom page, delete the old shell --->
        <cfif val(form.page_id) AND prevLayout EQ "custom" AND prevSlug NEQ cleanSlug>
            <cfset oldShellPath = webRoot & prevSlug & ".cfm">
            <cfif fileExists(oldShellPath) AND NOT listFind(protectedSlugs, prevSlug)>
                <cffile action="delete" file="#oldShellPath#">
                <cfset shellMsg = " Old shell (" & prevSlug & ".cfm) removed.">
            </cfif>
        </cfif>

        <!--- Write the new/updated shell --->
        <cftry>
            <cffile action="write" file="#newShellPath#" output="#shellContent#" charset="utf-8">
            <cfset shellMsg = shellMsg & " Shell file (#cleanSlug#.cfm) created/updated automatically.">
            <cfcatch type="any">
                <cflog file="app_errors" text="pages_save.cfm shell write error: #cfcatch.message#">
                <cfset shellMsg = shellMsg & " Warning: could not write shell file — check CF write permissions on web root.">
            </cfcatch>
        </cftry>

    <cfelseif val(form.page_id) AND prevLayout EQ "custom" AND layoutType EQ "generic">
        <!--- Switched from custom → generic: delete the old shell if safe --->
        <cfset oldShellPath = webRoot & cleanSlug & ".cfm">
        <cfif fileExists(oldShellPath) AND NOT listFind(protectedSlugs, cleanSlug)>
            <cftry>
                <cffile action="delete" file="#oldShellPath#">
                <cfset shellMsg = " Shell file (#cleanSlug#.cfm) removed — page now routes through page.cfm.">
                <cfcatch type="any">
                    <cflog file="app_errors" text="pages_save.cfm shell delete error: #cfcatch.message#">
                    <cfset shellMsg = " Warning: could not delete old shell file.">
                </cfcatch>
            </cftry>
        </cfif>
    </cfif>

    <!--- ── SUCCESS RESPONSE ─────────────────────────────────── --->
    <cfif val(form.page_id)>
        <cfoutput>
        <div class="alert alert-success">
            <i class="bi bi-check-circle me-2"></i>
            Page updated successfully.<cfif len(shellMsg)> <small class="text-muted">#shellMsg#</small></cfif>
        </div>
        </cfoutput>
    <cfelse>
        <cfoutput>
        <div class="alert alert-success">
            <i class="bi bi-check-circle me-2"></i>
            Page created successfully.<cfif len(shellMsg)> <small class="text-muted">#shellMsg#</small></cfif>
            <a href="pages_form.cfm?page_id=#newPageID#" class="alert-link">Edit it now</a>
            or <a href="pages_list.cfm" class="alert-link">return to list</a>.
        </div>
        </cfoutput>
    </cfif>

    <cfcatch type="database">
        <cflog file="app_errors" text="pages_save.cfm DB error: #cfcatch.message# — #cfcatch.detail#">
        <cfoutput>
        <div class="alert alert-danger">
            <i class="bi bi-exclamation-triangle me-2"></i>
            <strong>DB Error:</strong> #htmlEditFormat(cfcatch.message)#<br>
            <strong>Detail:</strong> #htmlEditFormat(cfcatch.detail)#
        </div>
        </cfoutput>
    </cfcatch>

</cftry>
