<cfcomponent>

    <cfset this.name               = "BioTwine">
    <cfset this.sessionManagement  = true>
    <cfset this.applicationTimeout = createTimeSpan(0,8,0,0)>
    <cfset this.setClientCookies   = true>

    <!---
        ── Database Configuration ──────────────────────────────
        ColdFusion datasource name pointing to your MySQL database.
    --->
    <cfset this.DSN = "biotwineDSN">


    <cffunction name="onApplicationStart" access="public" returntype="void" output="false">

        <cfset application.dsn      = this.DSN>
        <cfset application.siteRoot = getDirectoryFromPath(getCurrentTemplatePath())>
        <cfset application.siteName = "BioTwine Manufacturing">
        <cfset application.logDir   = application.siteRoot & "logs\">
        <cfset this.LOG_DIR         = application.logDir>

        <!--- Ensure log directory exists --->
        <cfif NOT directoryExists(application.logDir)>
            <cftry>
                <cfdirectory action="create" directory="#application.logDir#">
                <cfcatch><!--- non-fatal ---></cfcatch>
            </cftry>
        </cfif>

        <!--- Cache settings & content on app start --->
        <cfset loadSiteCache()>

    </cffunction>


    <cffunction name="loadSiteCache" access="private" returntype="void" output="false">

        <!--- Settings --->
        <cftry>
            <cfquery name="local.qS" datasource="#application.dsn#">
                SELECT setting_key, setting_value FROM bt_settings
            </cfquery>
            <cfset application.settings = {}>
            <cfloop query="local.qS">
                <cfset application.settings[local.qS.setting_key] = local.qS.setting_value>
            </cfloop>
            <cfcatch>
                <cfset application.settings = {}>
            </cfcatch>
        </cftry>

        <!--- Content --->
        <cftry>
            <cfquery name="local.qC" datasource="#application.dsn#">
                SELECT section, content_key, content_value FROM bt_content
            </cfquery>
            <cfset application.content = {}>
            <cfloop query="local.qC">
                <cfif NOT structKeyExists(application.content, local.qC.section)>
                    <cfset application.content[local.qC.section] = {}>
                </cfif>
                <cfset application.content[local.qC.section][local.qC.content_key] = local.qC.content_value>
            </cfloop>
            <cfcatch>
                <cfset application.content = {}>
            </cfcatch>
        </cftry>

    </cffunction>


    <cffunction name="onRequestStart" access="public" returntype="void" output="false">
        <cfargument name="targetPage" type="string" required="true">

        <!--- Pass static assets through --->
        <cfif reFindNoCase("\.(css|js|png|jpg|gif|svg|ico|woff2?)$", arguments.targetPage)>
            <cfreturn>
        </cfif>

        <!--- Convenience request helpers --->
        <cfset request.dsn      = application.dsn>
        <cfset request.settings = application.settings>
        <cfset request.content  = application.content>

        <!--- Helper: get setting --->
        <cfset request.gs = function(k, d="") {
            return structKeyExists(request.settings, k) ? request.settings[k] : d;
        }>

        <!--- Helper: get content value --->
        <cfset request.gc = function(s, k, d="") {
            if (structKeyExists(request.content, s) AND structKeyExists(request.content[s], k)) {
                return request.content[s][k];
            }
            return d;
        }>

        <!--- Refresh cache on ?refresh=1 (admin convenience) --->
        <cfif structKeyExists(URL,"refresh") AND URL.refresh EQ 1>
            <cfset loadSiteCache()>
            <cfset request.settings = application.settings>
            <cfset request.content  = application.content>
        </cfif>

    </cffunction>


    <!---
        ── Error Handling Configuration ────────────────────────
        DEV_MODE = true  shows full stack trace in browser
        DEV_MODE = false shows friendly message only
        Log files are always written regardless of this setting.
    --->
    <cfset this.DEV_MODE = true>
    <cfset this.LOG_DIR  = "">


    <cffunction name="onError" access="public" returntype="void" output="true">
        <cfargument name="Exception" type="any"    required="true">
        <cfargument name="EventName" type="string" required="false" default="">

        <!--- Collect into local vars — safe across cfinclude boundaries --->
        <cfset local.errMsg      = "">
        <cfset local.errDetail   = "">
        <cfset local.errType     = "Application">
        <cfset local.errSQL      = "">
        <cfset local.errCode     = "">
        <cfset local.errCFType   = "">
        <cfset local.errOccurred = now()>
        <cfset local.errURI      = CGI.SCRIPT_NAME & (len(CGI.QUERY_STRING) ? "?" & CGI.QUERY_STRING : "")>
        <cfset local.errIP       = CGI.REMOTE_ADDR>
        <cfset local.errFrames   = []>
        <cfset local.devMode     = this.DEV_MODE>

        <cftry>
            <cfif structKeyExists(arguments.Exception,"message")>
                <cfset local.errMsg = arguments.Exception.message>
            </cfif>
            <cfif structKeyExists(arguments.Exception,"detail")>
                <cfset local.errDetail = arguments.Exception.detail>
            </cfif>
            <cfif structKeyExists(arguments.Exception,"sql")>
                <cfset local.errSQL = arguments.Exception.sql>
            </cfif>
            <cfif structKeyExists(arguments.Exception,"errorCode")>
                <cfset local.errCode = arguments.Exception.errorCode>
            </cfif>
            <cfif structKeyExists(arguments.Exception,"type")>
                <cfset local.errCFType = arguments.Exception.type>
            </cfif>
            <cfif structKeyExists(arguments.Exception,"tagContext") AND isArray(arguments.Exception.tagContext)>
                <cfset local.errFrames = arguments.Exception.tagContext>
            </cfif>
            <cfcatch><!--- extraction is best-effort ---></cfcatch>
        </cftry>

        <!--- Classify error type --->
        <cftry>
            <cfset local.msgLower = lCase(local.errMsg & " " & local.errDetail)>
            <cfif findNoCase("datasource", local.msgLower) OR findNoCase("connection", local.msgLower) OR findNoCase("mysql", local.msgLower)>
                <cfset local.errType = "Database">
            <cfelseif findNoCase("template", local.msgLower) OR findNoCase("not found", local.msgLower)>
                <cfset local.errType = "Template Not Found">
            <cfelseif findNoCase("variable", local.msgLower) OR findNoCase("undefined", local.msgLower) OR findNoCase("expression", local.msgLower)>
                <cfset local.errType = "Variable / Expression">
            <cfelseif findNoCase("query", local.msgLower) OR findNoCase("sql", local.msgLower)>
                <cfset local.errType = "SQL / Query">
            <cfelseif findNoCase("security", local.msgLower) OR findNoCase("csrf", local.msgLower)>
                <cfset local.errType = "Security">
            <cfelseif findNoCase("file", local.msgLower) OR findNoCase("upload", local.msgLower)>
                <cfset local.errType = "File / Upload">
            </cfif>
            <cfcatch><!--- classification is best-effort ---></cfcatch>
        </cftry>

        <!--- Write log file --->
        <cftry>
            <cfset local.logDir = getDirectoryFromPath(getCurrentTemplatePath()) & "logs\">
            <cfif NOT directoryExists(local.logDir)>
                <cfdirectory action="create" directory="#local.logDir#">
            </cfif>
            <cfset local.logFile    = local.logDir & "error_" & dateFormat(now(),"yyyy-mm-dd") & ".log">
            <cfset local.firstFrame = (arrayLen(local.errFrames) ? " AT=" & local.errFrames[1].template & " line " & local.errFrames[1].line : "")>
            <cfset local.logLine    =
                "[" & dateTimeFormat(now(),"yyyy-mm-dd HH:nn:ss") & "]"
                & " [" & local.errType & "]"
                & " URI=" & local.errURI
                & " IP=" & local.errIP
                & " EVENT=" & arguments.EventName
                & " MSG=" & local.errMsg
                & (len(local.errDetail) ? " DETAIL=" & local.errDetail : "")
                & local.firstFrame
                & chr(10)>
            <cffile action="append" file="#local.logFile#" output="#local.logLine#" addnewline="false" fixnewline="false">
            <cfcatch><!--- never let log failure cause a secondary error ---></cfcatch>
        </cftry>

        <!--- Render error page — fully inlined to avoid cfinclude path issues --->
        <cfcontent reset="true">
        <cfoutput><!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Error &mdash; BioTwine Manufacturing</title>
<link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@700;900&family=Barlow:wght@400;500&display=swap" rel="stylesheet">
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Barlow',sans-serif;background:##1A3508;color:##E8DFC8;min-height:100vh;display:flex;flex-direction:column;align-items:center;justify-content:center;padding:40px 20px}
.w{width:100%;max-width:820px}
.logo{font-family:'Barlow Condensed',sans-serif;font-size:1rem;font-weight:900;letter-spacing:.2em;text-transform:uppercase;color:rgba(255,255,255,.35);margin-bottom:28px;display:flex;align-items:center;gap:10px}
.logo em{color:##62AA20;font-style:normal}
.dot{width:6px;height:6px;border-radius:50%;background:##62AA20;flex-shrink:0}
.card{background:##0c110a;border:1px solid rgba(98,170,32,.2);border-top:3px solid ##62AA20;border-radius:4px;overflow:hidden}
.head{padding:24px 28px;border-bottom:1px solid rgba(255,255,255,.06);display:flex;align-items:center;gap:14px}
.icon{width:44px;height:44px;flex-shrink:0;background:rgba(200,120,16,.15);border:1px solid rgba(200,120,16,.3);border-radius:4px;display:flex;align-items:center;justify-content:center;font-size:1.3rem}
.etype{font-family:'Barlow Condensed',sans-serif;font-size:.6rem;font-weight:700;letter-spacing:.28em;text-transform:uppercase;color:##C87810;margin-bottom:4px}
.etitle{font-family:'Barlow Condensed',sans-serif;font-size:1.4rem;font-weight:900;letter-spacing:.06em;text-transform:uppercase;color:##fff}
.msg{margin:20px 28px;padding:14px 18px;background:rgba(255,255,255,.03);border-left:3px solid rgba(200,120,16,.5);border-radius:0 4px 4px 0;font-size:.92rem;color:rgba(232,223,200,.85);line-height:1.7}
.acts{padding:0 28px 24px;display:flex;gap:10px;flex-wrap:wrap}
.btn{display:inline-flex;align-items:center;gap:6px;font-family:'Barlow Condensed',sans-serif;font-size:.7rem;font-weight:900;letter-spacing:.18em;text-transform:uppercase;padding:9px 20px;border-radius:4px;text-decoration:none;border:2px solid transparent;cursor:pointer;transition:all .2s}
.bp{background:##62AA20;color:##fff}.bp:hover{background:##4D8C1A;color:##fff}
.bo{background:transparent;color:rgba(255,255,255,.5);border-color:rgba(255,255,255,.15)}.bo:hover{border-color:rgba(255,255,255,.4);color:##E8DFC8}
.dev{border-top:1px solid rgba(255,255,255,.06)}
.dtog{width:100%;background:rgba(255,255,255,.02);border:none;cursor:pointer;font-family:'Barlow Condensed',sans-serif;font-size:.65rem;font-weight:700;letter-spacing:.24em;text-transform:uppercase;color:##557040;padding:12px 28px;text-align:left;display:flex;align-items:center;gap:10px;transition:all .2s}
.dtog:hover{color:##E8DFC8;background:rgba(255,255,255,.04)}
.caret{margin-left:auto;transition:transform .2s}.dtog.open .caret{transform:rotate(180deg)}
.dbody{display:none;padding:20px 28px 28px}.dbody.open{display:block}
.mg{display:grid;grid-template-columns:1fr 1fr;gap:12px 24px;margin-bottom:20px}
.ml{font-family:'Barlow Condensed',sans-serif;font-size:.56rem;font-weight:700;letter-spacing:.26em;text-transform:uppercase;color:##62AA20;margin-bottom:3px}
.mv{font-size:.82rem;color:rgba(255,255,255,.65);word-break:break-all}
.sh{font-family:'Barlow Condensed',sans-serif;font-size:.58rem;font-weight:700;letter-spacing:.26em;text-transform:uppercase;color:rgba(255,255,255,.3);border-bottom:1px solid rgba(255,255,255,.06);padding-bottom:6px;margin:20px 0 12px}
pre{background:##030603;border:1px solid rgba(255,255,255,.07);border-radius:4px;padding:14px 16px;font-family:Consolas,monospace;font-size:.76rem;color:rgba(255,255,255,.55);overflow-x:auto;white-space:pre-wrap;word-break:break-word;line-height:1.65;max-height:340px;overflow-y:auto}
.fr{display:flex;gap:12px;align-items:baseline;padding:5px 0;border-bottom:1px solid rgba(255,255,255,.04)}
.fl{font-family:monospace;color:##62AA20;min-width:40px;text-align:right;font-size:.78rem;flex-shrink:0}
.ff{font-size:.73rem;color:rgba(255,255,255,.45);word-break:break-all}
.ft{font-size:.72rem;color:##C4A06A;flex-shrink:0}
.sw{background:##030603;border:1px solid rgba(255,255,255,.07);border-radius:4px;padding:8px 14px;max-height:280px;overflow-y:auto}
.foot{margin-top:20px;font-size:.74rem;color:rgba(255,255,255,.22);text-align:center}
</style>
</head>
<body>
<div class="w">
<div class="logo"><div class="dot"></div><em>Bio</em>Twine Manufacturing</div>
<div class="card">
  <div class="head">
    <div class="icon"></div>
    <div>
      <div class="etype">#htmlEditFormat(local.errType)# Error</div>
      <div class="etitle">#(local.devMode ? "Application Error" : "We'll Be Right Back")#</div>
    </div>
  </div>
  <div class="msg">#(local.devMode ? htmlEditFormat(local.errMsg) : "An unexpected error occurred. Please try again or contact us if the problem persists.")#</div>
  <div class="acts">
    <a href="/" class="btn bp"> Return Home</a>
    <a href="/products.cfm" class="btn bo">View Products</a>
    <a href="/contact.cfm" class="btn bo">Contact Us</a>
  </div>
  <cfif local.devMode>
  <div class="dev">
    <button class="dtog open" onclick="this.classList.toggle('open');document.getElementById('db').classList.toggle('open')">
       Developer Diagnostics
      <svg class="caret" width="11" height="11" viewBox="0 0 11 11" fill="none"><path d="M1.5 3.5L5.5 7.5L9.5 3.5" stroke="currentColor" stroke-width="1.5"/></svg>
    </button>
    <div class="dbody open" id="db">
      <div class="mg">
        <div><div class="ml">Timestamp</div><div class="mv">#dateTimeFormat(local.errOccurred,"yyyy-mm-dd HH:nn:ss")#</div></div>
        <div><div class="ml">URI</div><div class="mv">#htmlEditFormat(local.errURI)#</div></div>
        <div><div class="ml">CF Error Type</div><div class="mv">#htmlEditFormat(len(local.errCFType) ? local.errCFType : "n/a")#</div></div>
        <div><div class="ml">Event</div><div class="mv">#htmlEditFormat(len(arguments.EventName) ? arguments.EventName : "onRequest")#</div></div>
        <cfif len(local.errCode)><div><div class="ml">Error Code</div><div class="mv">#htmlEditFormat(local.errCode)#</div></div></cfif>
        <div><div class="ml">Remote IP</div><div class="mv">#htmlEditFormat(local.errIP)#</div></div>
      </div>
      <cfif len(local.errDetail)>
        <div class="sh">Detail</div>
        <pre>#htmlEditFormat(local.errDetail)#</pre>
      </cfif>
      <cfif len(local.errSQL)>
        <div class="sh">SQL Statement</div>
        <pre>#htmlEditFormat(local.errSQL)#</pre>
      </cfif>
      <cfif arrayLen(local.errFrames)>
        <div class="sh">Stack Trace</div>
        <div class="sw">
        <cfloop array="#local.errFrames#" item="local.f">
          <div class="fr">
            <span class="fl">#htmlEditFormat(structKeyExists(local.f,"line") ? local.f.line : "?")#</span>
            <span class="ff">#htmlEditFormat(structKeyExists(local.f,"template") ? local.f.template : "")#</span>
            <cfif structKeyExists(local.f,"id") AND len(trim(local.f.id))><span class="ft">&lt;#htmlEditFormat(local.f.id)#&gt;</span></cfif>
          </div>
        </cfloop>
        </div>
      </cfif>
      <div class="sh">Request Snapshot</div>
      <pre>METHOD  : #CGI.REQUEST_METHOD#
HOST    : #htmlEditFormat(CGI.HTTP_HOST)#
REFERER : #htmlEditFormat(CGI.HTTP_REFERER)#
AGENT   : #htmlEditFormat(CGI.HTTP_USER_AGENT)#</pre>
    </div>
  </div>
  </cfif>
</div>
<div class="foot">Error logged at #timeFormat(local.errOccurred,"HH:nn:ss")# &mdash; BioTwine Manufacturing</div>
</div>
</body>
</html></cfoutput>

        <cfreturn>
    </cffunction>

</cfcomponent>