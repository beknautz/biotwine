<!--- home.cfm — shell template, content managed in DB via pages table --->
<cfinclude template="/includes/theme_loader.cfm">
<cfset request.layout    = "default">
<cfset request.pageTitle = "home">
<cfset request.metaDesc  = "BioTwine">
<cfset request.slug      = "home">
<cfinclude template="/includes/page_loader.cfm">
<cfinclude template="/themes/biotwine/layouts/default_open.cfm">
<cfoutput>#request.page.body_content#</cfoutput>
<cfinclude template="/themes/biotwine/layouts/default_close.cfm">

