<!--- products.cfm — shell template, content managed in DB via pages table --->
<cfinclude template="/includes/theme_loader.cfm">
<cfset request.layout    = "default">
<cfset request.pageTitle = "Products">
<cfset request.metaDesc  = "BioTwine products">
<cfset request.slug      = "products">
<cfinclude template="/includes/page_loader.cfm">
<cfinclude template="/themes/biotwine/layouts/default_open.cfm">
<cfoutput>#request.page.body_content#</cfoutput>
<cfinclude template="/themes/biotwine/layouts/default_close.cfm">

