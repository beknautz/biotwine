<!--- admin/upload_image.cfm
      Accepts Base64 data URL (imageData) + filename + folder via POST.
      Uses Java FileOutputStream to write directly to destination — no CF temp file.
      Returns JSON: {ok:true, url:"/assets/uploads/folder/file.jpg"}
--->
<cfcontent type="application/json; charset=utf-8">

<cftry>
  <!--- Read JSON body (sent as application/json by admin.js) --->
  <cfset requestBody = toString(getHTTPRequestData().content)>
  <cfif NOT len(trim(requestBody))>
    <cfoutput>{"ok":false,"error":"Empty request body."}</cfoutput>
    <cfabort>
  </cfif>
  <cfset postData = deserializeJSON(requestBody)>
  <cfparam name="postData.imageData" default="">
  <cfparam name="postData.filename"  default="">
  <cfparam name="postData.folder"    default="img">

  <!--- Validate folder whitelist --->
  <cfset folder = lCase(trim(postData.folder))>
  <cfif NOT listFindNoCase("products,img,hero,testimonials,news", folder)>
    <cfset folder = "img">
  </cfif>

  <!--- Validate Base64 data URL --->
  <cfif NOT len(trim(postData.imageData)) OR NOT findNoCase("base64,", postData.imageData)>
    <cfoutput>{"ok":false,"error":"No valid image data received."}</cfoutput>
    <cfabort>
  </cfif>

  <!--- Split data URL into prefix and payload --->
  <cfset b64Data    = listRest(postData.imageData, ",")>
  <cfset dataPrefix = listFirst(postData.imageData, ",")>

  <!--- Determine extension --->
  <cfset mimeType = lCase(reReplaceNoCase(dataPrefix, "data:([^;]+);.*", "\1"))>
  <cfset ext = "jpg">
  <cfif mimeType EQ "image/png">  <cfset ext = "png">  </cfif>
  <cfif mimeType EQ "image/gif">  <cfset ext = "gif">  </cfif>
  <cfif mimeType EQ "image/webp"> <cfset ext = "webp"> </cfif>

  <!--- Build timestamped safe filename --->
  <cfset origBase  = listFirst(trim(postData.filename), ".")>
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
