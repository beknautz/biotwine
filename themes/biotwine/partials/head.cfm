<cfoutput>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><cfif structKeyExists(request,"pageTitle") AND len(request.pageTitle)>#htmlEditFormat(request.pageTitle)# — </cfif>BioTwine Manufacturing</title>
<meta name="description" content="<cfif structKeyExists(request,'metaDesc') AND len(request.metaDesc)>#htmlEditFormat(request.metaDesc)#<cfelse>BioTwine Manufacturing — Premium biodegradable twisted paper twine for the hop industry, berry orchards, and handle bag manufacturers. Toppenish, WA since 1994.</cfif>">

<!-- Preconnect for Google Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;0,900;1,400;1,600&family=DM+Sans:wght@300;400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">

<!-- Bootstrap 5 CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

<!-- Bootstrap Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

<!-- Theme CSS -->
<link rel="stylesheet" href="#application.themeURL#/css/variables.css">
<link rel="stylesheet" href="#application.themeURL#/css/main.css">

<!-- HTMX -->
<script src="https://unpkg.com/htmx.org@1.9.10"></script>

<link rel="icon" type="image/svg+xml" href="#application.themeURL#/img/favicon.svg">
</cfoutput>
