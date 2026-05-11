<!--- admin/upload_image.cfm
      Accepts Base64 data URL (imageData) + filename + folder via POST.
      Uses Java FileOutputStream to write directly to destination — no CF temp file.
      Returns JSON: {ok:true, url:"/assets/uploads/folder/file.jpg"}
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

  <!--- Validate Base64 data URL --->
  <cfif NOT len(trim(form.imageData)) OR NOT findNoCase("base64,", form.imageData)>
    <cfoutput>{"ok":false,"error":"No valid image data received."}</cfoutput>
    <cfabort>
  </cfif>

  <!--- Split data URL into prefix and payload --->
  <cfset b64Data   = listRest(form.imageData, ",")>
  <cfset dataPrefix = listFirst(form.imageData, ",")>

  <!--- Determine extension --->
  <cfset mimeType = lCase(reReplaceNoCase(dataPrefix, "data:([^;]+);.*", "\1"))>
  <cfset ext = "jpg">
  <cfif mimeType EQ "image/png">  <cfset ext = "png">  </cfif>
  <cfif mimeType EQ "image/gif">  <cfset ext = "gif">  </cfif>
  <cfif mimeType EQ "image/webp"> <cfset ext = "webp"> </cfif>

  <!--- Build timestamped safe filename --->
  <cfset origBase  = listFirst(trim(form.filename), ".")>
  <cfset safeName  = lCase(reReplaceNoCase(origBase, "[^a-z0-9\-_]", "-", "ALL"))>
  <cfset safeName  = left(reReplace(safeName, "-+", "-", "ALL"), 80)>
  <cfset stamp     = dateFormat(now(), "yyyymmdd") & timeFormat(now(), "HHmmss")>
  <cfset finalName = "#safeName#-#stamp#.#ext#">

  <!--- Resolve destination directory --->
  <cfset uploadDir = expandPath("/assets/uploads/#folder#/")>
  <cfif NOT directoryExists(uploadDir)>
    <cfdirectory action="create" directory="#uploadDir#" mode="755">
  </cfif>

  <!--- Decode Base64 to Java byte array --->
  <cfset decoder    = createObject("java", "java.util.Base64").getDecoder()>
  <cfset byteArray  = decoder.decode(javaCast("string", b64Data))>

  <!--- Write directly via Java FileOutputStream — zero temp files --->
  <cfset destPath = uploadDir & finalName>
  <cfset fos = createObject("java", "java.io.FileOutputStream").init(destPath)>
  <cfset fos.write(byteArray)>
  <cfset fos.close()>

  <cfset fileUrl = "/assets/uploads/#folder#/#finalName#">
  <cfoutput>{"ok":true,"filename":"#jsStringFormat(finalName)#","url":"#jsStringFormat(fileUrl)#"}</cfoutput>

  <cfcatch type="any">
    <cflog file="app_errors" text="upload_image.cfm error: #cfcatch.message# — #cfcatch.detail#">
    <cfoutput>{"ok":false,"error":"#jsStringFormat(cfcatch.message)#"}</cfoutput>
  </cfcatch>
</cftry>
