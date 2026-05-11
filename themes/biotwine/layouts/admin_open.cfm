<!DOCTYPE html>
<html lang="en">
<head>
  <cfinclude template="/themes/biotwine/partials/head.cfm">
  <cfoutput>
  <link rel="stylesheet" href="#application.themeURL#/css/admin.css">
  </cfoutput>
</head>
<body class="theme-biotwine layout-admin">

<cfinclude template="/themes/biotwine/partials/nav_admin.cfm">

<div class="admin-main" id="admin-main">

  <div class="admin-topbar">
    <button class="admin-menu-toggle d-lg-none btn btn-sm btn-outline-secondary me-2" aria-label="Toggle menu">
      <i class="bi bi-list"></i>
    </button>
    <cfoutput>
    <h1 class="admin-page-title"><cfif structKeyExists(request,"pageTitle")>#htmlEditFormat(request.pageTitle)#<cfelse>Admin</cfif></h1>
    </cfoutput>
    <div class="admin-user-info">
      <span class="d-none d-md-inline">
        <cfoutput><cfif structKeyExists(session,"firstName")>#htmlEditFormat(session.firstName)#<cfelse>Admin</cfif></cfoutput>
      </span>
      <div class="admin-avatar">
        <cfoutput><cfif structKeyExists(session,"firstName")>#uCase(left(session.firstName,1))#<cfelse>A</cfif></cfoutput>
      </div>
    </div>
  </div>

  <div class="admin-content">
    <cfinclude template="/themes/biotwine/partials/flash.cfm">
