<!--- /includes/theme_loader.cfm --->
<cfparam name="request.layout"   default="default">
<cfparam name="request.pageTitle" default="">
<cfparam name="request.metaDesc"  default="">

<cfif NOT structKeyExists(application, "theme")>
  <cfset application.theme    = "biotwine">
  <cfset application.themeURL = "/themes/biotwine">
</cfif>

<cfset request.themeURL        = application.themeURL>
<cfset request.partialsPath    = "/themes/#application.theme#/partials/">
<cfset request.componentsPath  = "/themes/#application.theme#/components/">
