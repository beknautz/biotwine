<!--- about.cfm — renders sections from page_sections table --->
<cfinclude template="/includes/theme_loader.cfm">
<cfset request.layout    = "default">
<cfset request.pageTitle = "About BioTwine Manufacturing">
<cfset request.metaDesc  = "About BioTwine Manufacturing — FSC Certified paper twine manufacturer in Toppenish, Washington. Over 100 years of combined experience.">

<cfquery name="getSections" datasource="#application.dsn#">
  SELECT section_id, section_type, eyebrow, heading, subheading, body_text,
         image, image_alt, cta_label, cta_url, cta2_label, cta2_url, extra_data
  FROM   page_sections
  WHERE  page_slug = 'about'
  AND    is_active = 1
  ORDER  BY sort_order ASC
</cfquery>

<cfinclude template="/themes/biotwine/layouts/default_open.cfm">

<cfloop query="getSections">
  <cfswitch expression="#getSections.section_type#">
    <cfcase value="page_hero">
      <cfinclude template="/themes/biotwine/sections/page_hero.cfm">
    </cfcase>
    <cfcase value="about_split">
      <cfinclude template="/themes/biotwine/sections/about_split.cfm">
    </cfcase>
    <cfcase value="values">
      <cfinclude template="/themes/biotwine/sections/values.cfm">
    </cfcase>
    <cfcase value="cta_dark">
      <cfinclude template="/themes/biotwine/sections/cta_dark.cfm">
    </cfcase>
  </cfswitch>
</cfloop>

<cfinclude template="/themes/biotwine/layouts/default_close.cfm">
