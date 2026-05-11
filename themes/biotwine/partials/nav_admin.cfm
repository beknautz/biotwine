<aside class="admin-sidebar" id="admin-sidebar">

  <div class="admin-sidebar-header">
    <div class="admin-sidebar-logo">
      <span>Bio</span>Twine
      <span class="admin-label">CMS Admin</span>
    </div>
  </div>

  <nav class="admin-nav">

    <div class="admin-nav-section">Main</div>
    <a href="/admin/dashboard.cfm" class="<cfif structKeyExists(request,'adminPage') AND request.adminPage EQ 'dashboard'>active</cfif>">
      <i class="bi bi-speedometer2 nav-icon"></i> Dashboard
    </a>

    <div class="admin-nav-section">Content</div>
    <a href="/admin/page_builder.cfm" class="<cfif structKeyExists(request,'adminPage') AND request.adminPage EQ 'page_builder'>active</cfif>">
      <i class="bi bi-layout-text-window nav-icon"></i> Page Builder
    </a>
    <a href="/admin/pages_list.cfm" class="<cfif structKeyExists(request,'adminPage') AND request.adminPage EQ 'pages'>active</cfif>">
      <i class="bi bi-file-earmark-text nav-icon"></i> Pages
    </a>
    <a href="/admin/news_list.cfm" class="<cfif structKeyExists(request,'adminPage') AND request.adminPage EQ 'news'>active</cfif>">
      <i class="bi bi-newspaper nav-icon"></i> News
    </a>
    <a href="/admin/products_list.cfm" class="<cfif structKeyExists(request,'adminPage') AND request.adminPage EQ 'products'>active</cfif>">
      <i class="bi bi-box-seam nav-icon"></i> Products
    </a>
    <a href="/admin/categories_list.cfm" class="<cfif structKeyExists(request,'adminPage') AND request.adminPage EQ 'categories'>active</cfif>">
      <i class="bi bi-tags nav-icon"></i> Categories
    </a>
    <a href="/admin/testimonials_list.cfm" class="<cfif structKeyExists(request,'adminPage') AND request.adminPage EQ 'testimonials'>active</cfif>">
      <i class="bi bi-chat-quote nav-icon"></i> Testimonials
    </a>

    <div class="admin-nav-section">Leads</div>
    <a href="/admin/quotes_list.cfm" class="<cfif structKeyExists(request,'adminPage') AND request.adminPage EQ 'quotes'>active</cfif>">
      <i class="bi bi-envelope nav-icon"></i> Quote Requests
    </a>

    <div class="admin-nav-section">Settings</div>
    <a href="/admin/settings.cfm" class="<cfif structKeyExists(request,'adminPage') AND request.adminPage EQ 'settings'>active</cfif>">
      <i class="bi bi-gear nav-icon"></i> Site Settings
    </a>
    <a href="/admin/users_list.cfm" class="<cfif structKeyExists(request,'adminPage') AND request.adminPage EQ 'users'>active</cfif>">
      <i class="bi bi-people nav-icon"></i> Users
    </a>

    <div class="admin-nav-section">Site</div>
    <a href="/" target="_blank">
      <i class="bi bi-box-arrow-up-right nav-icon"></i> View Site
    </a>
    <a href="/admin/logout.cfm">
      <i class="bi bi-box-arrow-left nav-icon"></i> Logout
    </a>

  </nav>

</aside>
