<!--- /admin/upload_image.cfm — HTMX/fetch POST handler --->
<!--- Accepts multipart POST with: file (the image), folder (products|img|hero|testimonials) --->
<!--- Returns JSON: {"ok":true,"filename":"...","url":"..."} or {"ok":false,"error":"..."} --->

<cfcontent type="application/json; charset=utf-8">

<cfparam name="form.folder" default="img">

<!--- Whitelist upload destinations --->
<cfset allowedFolders = ["products", "img", "hero", "testimonials"]>
<cfif NOT arrayFindNoCase(allowedFolders, form.folder)>
  <cfset form.folder = "img">
</cfif>

<cfset uploadDir = expandPath("/assets/uploads/#form.folder#/")>

<cftry>

  <cfif NOT directoryExists(uploadDir)>
    <cfdirectory action="create" directory="#uploadDir#">
  </cfif>

  <cffile
    action="upload"
    fileField="file"
    destination="#uploadDir#"
    nameConflict="makeUnique"
    accept="image/jpeg,image/png,image/gif,image/webp"
  >

  <cfset filename = cffile.serverFile>
  <cfset fileUrl  = "/assets/uploads/#form.folder#/#filename#">

  <cfoutput>{"ok":true,"filename":"#jsStringFormat(filename)#","url":"#jsStringFormat(fileUrl)#"}</cfoutput>

<cfcatch>
  <cflog file="app_errors" text="upload_image.cfm error: #cfcatch.message# — #cfcatch.detail#">
  <cfoutput>{"ok":false,"error":"#jsStringFormat(cfcatch.message)#"}</cfoutput>
</cfcatch>
</cftry>
