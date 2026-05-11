<!--- home.cfm — renders sections from page_sections table --->
<cfinclude template="/includes/theme_loader.cfm">
<cfset request.layout    = "default">
<cfset request.pageTitle = "BioTwine Manufacturing — Twisted Paper Twine">
<cfset request.metaDesc  = "BioTwine Manufacturing — premium biodegradable twisted paper twine for hop farms, berry orchards, and handle bag manufacturers. FSC Certified. Since 1994.">

<cfquery name="getSections" datasource="#application.dsn#">
  SELECT section_id, section_type, eyebrow, heading, subheading, body_text,
         image, image_alt, cta_label, cta_url, cta2_label, cta2_url, extra_data
  FROM   page_sections
  WHERE  page_slug = 'home'
  AND    is_active = 1
  ORDER  BY sort_order ASC
</cfquery>

<cfinclude template="/themes/biotwine/layouts/default_open.cfm">

<cfloop query="getSections">
  <cfswitch expression="#getSections.section_type#">
    <cfcase value="hero">
      <cfinclude template="/themes/biotwine/sections/hero.cfm">
    </cfcase>
    <cfcase value="stats">
      <cfinclude template="/themes/biotwine/sections/stats.cfm">
    </cfcase>
    <cfcase value="about_split">
      <cfinclude template="/themes/biotwine/sections/about_split.cfm">
    </cfcase>
    <cfcase value="gallery">
      <cfinclude template="/themes/biotwine/sections/gallery.cfm">
    </cfcase>
    <cfcase value="testimonials">
      <cfinclude template="/themes/biotwine/sections/testimonials.cfm">
    </cfcase>
    <cfcase value="cta_dark">
      <cfinclude template="/themes/biotwine/sections/cta_dark.cfm">
    </cfcase>
  </cfswitch>
</cfloop>

<cfinclude template="/themes/biotwine/layouts/default_close.cfm">
