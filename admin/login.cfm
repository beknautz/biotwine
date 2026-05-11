<!--- /admin/login.cfm --->
<cfinclude template="/includes/theme_loader.cfm">
<cfset request.layout    = "bare">
<cfset request.pageTitle = "Admin Login">

<cfparam name="form.email"    default="">
<cfparam name="form.password" default="">
<cfset loginError = "">

<cfif structKeyExists(form,"submit")>
  <cfif len(trim(form.email)) AND len(trim(form.password))>
    <cftry>
      <cfquery name="getUser" datasource="#application.dsn#">
        SELECT user_id, first_name, last_name, password, role, is_active
        FROM users
        WHERE email = <cfqueryparam value="#trim(lCase(form.email))#" cfsqltype="cf_sql_varchar">
      </cfquery>

      <cfif getUser.recordCount AND getUser.is_active>
        <!--- Use BCrypt check — replace with your CF BCrypt implementation --->
        <!--- For now using a placeholder; integrate GenerateSecretKey/hash as needed --->
        <cfif getUser.password EQ hash(trim(form.password),"SHA-256")>
          <cfset session.btLoggedIn = true>
          <cfset session.userID     = getUser.user_id>
          <cfset session.role       = getUser.role>
          <cfset session.firstName  = getUser.first_name>
          <cflocation url="/admin/dashboard.cfm" addtoken="false">
        <cfelse>
          <cfset loginError = "Invalid email or password.">
        </cfif>
      <cfelse>
        <cfset loginError = "Invalid email or password.">
      </cfif>
      <cfcatch type="database">
        <cfset loginError = "A system error occurred. Please try again.">
        <cflog file="app_errors" text="Login DB error: #cfcatch.message#">
      </cfcatch>
    </cftry>
  <cfelse>
    <cfset loginError = "Please enter your email and password.">
  </cfif>
</cfif>

<cfinclude template="/themes/biotwine/layouts/bare_open.cfm">

<cfoutput>
<div style="text-align:center; margin-bottom:2rem;">
  <div style="font-family:var(--font-display); font-size:1.75rem; font-weight:700; color:##FFFFFF;">
    <span style="color:var(--color-kraft-light); font-style:italic;">Bio</span>Twine
  </div>
  <div style="font-size:0.65rem; letter-spacing:0.2em; text-transform:uppercase; color:rgba(255,255,255,0.4); margin-top:4px;">CMS Administration</div>
</div>

<div style="background:##FFFFFF; border-radius:var(--border-radius-lg); padding:2rem; box-shadow:var(--shadow-lg);">
  <h1 style="font-size:1.35rem; margin-bottom:1.5rem; text-align:center; color:var(--text-heading);">Sign In</h1>

  <cfif len(loginError)>
    <div class="alert alert-danger">#htmlEditFormat(loginError)#</div>
  </cfif>

  <form method="post" action="/admin/login.cfm">
    <input type="hidden" name="submit" value="1">
    <div class="mb-3">
      <label class="form-label">Email Address</label>
      <input type="email" name="email" class="form-control" value="#htmlEditFormat(form.email)#" placeholder="admin@biotwine.com" required autofocus>
    </div>
    <div class="mb-3">
      <label class="form-label">Password</label>
      <input type="password" name="password" class="form-control" placeholder="••••••••" required>
    </div>
    <button type="submit" class="btn btn-primary" style="width:100%; justify-content:center; border-radius:var(--border-radius);">Sign In</button>
  </form>
</div>

<div style="text-align:center; margin-top:1.5rem; font-size:var(--font-size-xs); color:rgba(255,255,255,0.3);">
  BioTwine Manufacturing CMS &bull; <a href="/" style="color:rgba(255,255,255,0.3); text-decoration:underline;">&larr; Back to site</a>
</div>
</cfoutput>

<cfinclude template="/themes/biotwine/layouts/bare_close.cfm">
