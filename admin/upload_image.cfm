<!--- admin/upload_image.cfm
      Accepts a Base64 data URL (imageData) + filename + folder via POST.
      Decodes and writes the file to /assets/uploads/<folder>/.
      Returns JSON: {ok:true, url:"/assets/uploads/folder/filename.jpg"}

      Uses cffile action="write" (binary) rather than cffile action="upload"
      to avoid the Java sandbox FilePermission error on CF2023 shared hosting.
--->
<cfcontent type="application/json; charset=utf-8">

<cfparam name="form.imageData" default="">
<cfparam name="form.filename"  default="">
<cfparam name="form.folder"    default="img">

<cftry>
  <!--- Validate folder whitelist --->
  <cfset folder = lCase(trim(form.folder))>
  <cfif NOT listFindNoCase("products,img,hero,testimonials", folder)>
    <cfset folder = "img">
  </cfif>

  <!--- Validate imageData --->
  <cfif NOT len(trim(form.imageData)) OR NOT findNoCase("base64,", form.imageData)>
    <cfoutput>{"ok":false,"error":"No valid image data received."}</cfoutput>
    <cfabort>
  </cfif>

  <!--- Extract mime type and Base64 payload from data URL --->
  <!--- Format: data:image/jpeg;base64,/9j/4AAQ... --->
  <cfset dataPrefix = listFirst(form.imageData, ",")>
  <cfset b64Data    = listRest(form.imageData, ",")>

  <!--- Determine file extension from mime type in prefix --->
  <cfset mimeType = "image/jpeg">
  <cfif findNoCase("image/", dataPrefix)>
    <cfset mimeType = lCase(reReplaceNoCase(dataPrefix, "data:([^;]+);.*", "\1"))>
  </cfif>
  <cfset ext = "jpg">
  <cfif mimeType EQ "image/png">  <cfset ext = "png">  </cfif>
  <cfif mimeType EQ "image/gif">  <cfset ext = "gif">  </cfif>
  <cfif mimeType EQ "image/webp"> <cfset ext = "webp"> </cfif>

  <!--- Build a safe, timestamped filename --->
  <cfset origBase  = listFirst(trim(form.filename), ".")>
  <cfset safeName  = lCase(reReplaceNoCase(origBase, "[^a-z0-9\-_]", "-", "ALL"))>
  <cfset safeName  = reReplace(safeName, "-+", "-", "ALL")>
  <cfset safeName  = left(safeName, 80)>
  <cfset stamp     = dateFormat(now(), "yyyymmdd") & timeFormat(now(), "HHmmss")>
  <cfset finalName = "#safeName#-#stamp#.#ext#">

  <!--- Resolve save path and create directory if needed --->
  <cfset uploadDir = expandPath("/assets/uploads/#folder#/")>
  <cfif NOT directoryExists(uploadDir)>
    <cfdirectory action="create" directory="#uploadDir#" mode="755">
  </cfif>

  <!--- Decode Base64 → binary and write directly (no temp file involved) --->
  <cfset binaryData = toBinary(b64Data)>
  <cffile action="write"
          file="#uploadDir##finalName#"
          output="#binaryData#"
          addnewline="false">

  <cfset fileUrl = "/assets/uploads/#folder#/#finalName#">
  <cfoutput>{"ok":true,"filename":"#jsStringFormat(finalName)#","url":"#jsStringFormat(fileUrl)#"}</cfoutput>

  <cfcatch type="any">
    <cflog file="app_errors" text="upload_image.cfm error: #cfcatch.message# — #cfcatch.detail#">
    <cfoutput>{"ok":false,"error":"#jsStringFormat(cfcatch.message)#"}</cfoutput>
  </cfcatch>
</cftry>
