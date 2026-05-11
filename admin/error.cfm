<!--- /admin/error.cfm — Generic error handler output (called from Application.cfc onError) --->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Error — BioTwine CMS</title>
  <style>
    body { font-family: system-ui, sans-serif; background: #1C2E1C; color: #F5F0E8; display:flex; align-items:center; justify-content:center; min-height:100vh; margin:0; }
    .box { background: rgba(255,255,255,0.06); border:1px solid rgba(255,255,255,0.12); border-radius:8px; padding:2.5rem 3rem; max-width:500px; text-align:center; }
    h1 { font-size:1.5rem; margin-bottom:0.75rem; }
    p { color:rgba(255,255,255,0.65); font-size:0.95rem; }
    a { color:#C49A2A; }
  </style>
</head>
<body>
  <div class="box">
    <div style="font-size:2.5rem; margin-bottom:1rem;">⚠️</div>
    <h1>Something went wrong</h1>
    <p>An unexpected error occurred. Please <a href="/admin/dashboard.cfm">return to the dashboard</a> or contact your system administrator.</p>
    <cfif isDefined("Exception") AND structKeyExists(Exception,"message")>
      <cfif isDefined("session.role") AND session.role EQ "admin">
        <pre style="text-align:left; background:rgba(0,0,0,0.3); padding:1rem; border-radius:4px; font-size:0.75rem; margin-top:1.5rem; overflow:auto; color:rgba(255,255,255,0.7);"><cfoutput>#htmlEditFormat(Exception.message)#</cfoutput></pre>
      </cfif>
    </cfif>
  </div>
</body>
</html>
