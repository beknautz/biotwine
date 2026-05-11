<!--- admin/section_save.cfm — insert / update / toggle for page_sections --->
<cfinclude template="/includes/theme_loader.cfm">

<cfparam name="form.action"       default="update">
<cfparam name="form.section_id"   default="0">
<cfparam name="form.page_slug"    default="home">
<cfparam name="form.section_type" default="">
<cfparam name="form.section_label" default="">
<cfparam name="form.eyebrow"      default="">
<cfparam name="form.heading"      default="">
<cfparam name="form.subheading"   default="">
<cfparam name="form.body_text"    default="">
<cfparam name="form.image"        default="">
<cfparam name="form.image_alt"    default="">
<cfparam name="form.cta_label"    default="">
<cfparam name="form.cta_url"      default="">
<cfparam name="form.cta2_label"   default="">
<cfparam name="form.cta2_url"     default="">
<cfparam name="form.extra_data"   default="">
<cfparam name="form.is_active"    default="0">

<cfset pageSlug = lCase(trim(form.page_slug))>
<cfset validPages = "home,about,products,contact">
<cfif NOT listFindNoCase(validPages, pageSlug)>
  <cfset pageSlug = "home">
</cfif>

<!--- ── TOGGLE visibility ───────────────────────────────────────────────── --->
<cfif form.action EQ "toggle">
  <cftry>
    <cfquery datasource="#application.dsn#">
      UPDATE page_sections
      SET    is_active = CASE WHEN is_active = 1 THEN 0 ELSE 1 END
      WHERE  section_id = <cfqueryparam value="#val(form.section_id)#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfcatch type="database">
      <cflog file="app_errors" text="section_save toggle: #cfcatch.message#">
    </cfcatch>
  </cftry>
  <!--- Return refreshed section list --->
  <cfinclude template="/admin/_section_list_partial.cfm">
  <cfabort>
</cfif>

<!--- ── ADD new blank section ───────────────────────────────────────────── --->
<cfif form.action EQ "add">
  <cfset sType  = trim(form.section_type)>
  <cfset sLabel = len(trim(form.section_label)) ? trim(form.section_label) : sType>

  <!--- Determine next sort_order --->
  <cfquery name="getMax" datasource="#application.dsn#">
    SELECT COALESCE(MAX(sort_order),0)+1 AS next_sort
    FROM   page_sections
    WHERE  page_slug = <cfqueryparam value="#pageSlug#" cfsqltype="cf_sql_varchar">
  </cfquery>

  <cftry>
    <cfquery name="newSection" datasource="#application.dsn#" result="insertResult">
      INSERT INTO page_sections
        (page_slug, section_type, section_label, sort_order, is_active)
      VALUES
        (<cfqueryparam value="#pageSlug#"          cfsqltype="cf_sql_varchar">,
         <cfqueryparam value="#sType#"             cfsqltype="cf_sql_varchar">,
         <cfqueryparam value="#sLabel#"            cfsqltype="cf_sql_varchar">,
         <cfqueryparam value="#getMax.next_sort#"  cfsqltype="cf_sql_integer">,
         1)
    </cfquery>
    <cfset newId = insertResult.generatedKey>
    <cfcatch type="database">
      <cfoutput><div class="alert alert-error">Error creating section: #htmlEditFormat(cfcatch.message)#</div></cfoutput>
      <cfabort>
    </cfcatch>
  </cftry>

  <!--- Redirect to edit form for the new section --->
  <cflocation url="/admin/section_form.cfm?section_id=#newId#&page_slug=#pageSlug#" addtoken="false">
</cfif>

<!--- ── UPDATE existing section ─────────────────────────────────────────── --->
<cfif form.action EQ "update">
  <cftry>
    <cfquery datasource="#application.dsn#">
      UPDATE page_sections SET
        section_label = <cfqueryparam value="#trim(form.section_label)#"  cfsqltype="cf_sql_varchar">,
        eyebrow       = <cfqueryparam value="#trim(form.eyebrow)#"        cfsqltype="cf_sql_varchar">,
        heading       = <cfqueryparam value="#trim(form.heading)#"        cfsqltype="cf_sql_varchar">,
        subheading    = <cfqueryparam value="#trim(form.subheading)#"     cfsqltype="cf_sql_varchar">,
        body_text     = <cfqueryparam value="#trim(form.body_text)#"      cfsqltype="cf_sql_longvarchar">,
        image         = <cfqueryparam value="#trim(form.image)#"          cfsqltype="cf_sql_varchar">,
        image_alt     = <cfqueryparam value="#trim(form.image_alt)#"      cfsqltype="cf_sql_varchar">,
        cta_label     = <cfqueryparam value="#trim(form.cta_label)#"      cfsqltype="cf_sql_varchar">,
        cta_url       = <cfqueryparam value="#trim(form.cta_url)#"        cfsqltype="cf_sql_varchar">,
        cta2_label    = <cfqueryparam value="#trim(form.cta2_label)#"     cfsqltype="cf_sql_varchar">,
        cta2_url      = <cfqueryparam value="#trim(form.cta2_url)#"       cfsqltype="cf_sql_varchar">,
        extra_data    = <cfqueryparam value="#trim(form.extra_data)#"     cfsqltype="cf_sql_longvarchar">,
        is_active     = <cfqueryparam value="#iif(form.is_active EQ 1,1,0)#" cfsqltype="cf_sql_tinyint">
      WHERE section_id = <cfqueryparam value="#val(form.section_id)#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfcatch type="database">
      <cfoutput><div class="alert alert-error" style="padding:1rem; border-radius:6px; background:##fee; border:1px solid ##fcc; color:##900; margin-bottom:1rem;">
        <strong>Save failed:</strong> #htmlEditFormat(cfcatch.message)#
      </div></cfoutput>
      <cfabort>
    </cfcatch>
  </cftry>

  <cfoutput>
  <div class="alert" style="padding:1rem; border-radius:6px; background:##f0faf3; border:1px solid ##b6e6c5; color:##1a6633; margin-bottom:1rem; display:flex; align-items:center; gap:0.5rem;">
    <i class="bi bi-check-circle-fill"></i> Section saved successfully.
    <a href="/admin/page_builder.cfm?page=#htmlEditFormat(pageSlug)#" style="margin-left:auto; font-size:var(--font-size-sm);">Back to Page Builder</a>
  </div>
  </cfoutput>
</cfif>
