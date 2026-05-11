<!--- /admin/dashboard.cfm --->
<cfinclude template="/includes/theme_loader.cfm">
<cfset request.layout    = "admin">
<cfset request.pageTitle = "Dashboard">
<cfset request.adminPage = "dashboard">

<cftry>
  <cfquery name="getCounts" datasource="#application.dsn#">
    SELECT
      (SELECT COUNT(*) FROM products      WHERE is_active = 1) AS product_count,
      (SELECT COUNT(*) FROM news          WHERE is_active = 1) AS news_count,
      (SELECT COUNT(*) FROM quote_requests WHERE is_read  = 0) AS unread_quotes,
      (SELECT COUNT(*) FROM quote_requests)                    AS total_quotes,
      (SELECT COUNT(*) FROM testimonials  WHERE is_active = 1) AS testimonial_count
  </cfquery>
  <cfcatch type="database">
    <cfset getCounts = queryNew("product_count,news_count,unread_quotes,total_quotes,testimonial_count","integer,integer,integer,integer,integer")>
    <cfset queryAddRow(getCounts)>
    <cfset getCounts.product_count[1]     = 0>
    <cfset getCounts.news_count[1]        = 0>
    <cfset getCounts.unread_quotes[1]     = 0>
    <cfset getCounts.total_quotes[1]      = 0>
    <cfset getCounts.testimonial_count[1] = 0>
  </cfcatch>
</cftry>

<cftry>
  <cfquery name="getRecentQuotes" datasource="#application.dsn#">
    SELECT quote_id, first_name, last_name, company, email, product_interest, submitted_at, is_read
    FROM quote_requests
    ORDER BY submitted_at DESC
    LIMIT 5
  </cfquery>
  <cfcatch type="database">
    <cfset getRecentQuotes = queryNew("quote_id,first_name,last_name,company,email,product_interest,submitted_at,is_read")>
  </cfcatch>
</cftry>

<cfinclude template="/themes/biotwine/layouts/admin_open.cfm">

<cfoutput>

<!--- Stat cards --->
<div class="dash-stats">
  <div class="dash-stat-card">
    <div class="dash-stat-label">Active Products</div>
    <div class="dash-stat-number">#getCounts.product_count#</div>
  </div>
  <div class="dash-stat-card accent-kraft">
    <div class="dash-stat-label">News Articles</div>
    <div class="dash-stat-number">#getCounts.news_count#</div>
  </div>
  <div class="dash-stat-card accent-meadow">
    <div class="dash-stat-label">Unread Quotes</div>
    <div class="dash-stat-number">#getCounts.unread_quotes#</div>
  </div>
  <div class="dash-stat-card accent-light">
    <div class="dash-stat-label">Total Quote Requests</div>
    <div class="dash-stat-number">#getCounts.total_quotes#</div>
  </div>
</div>

<!--- Recent quote requests table --->
<div class="admin-card">
  <div class="admin-card-header">
    <h2><i class="bi bi-envelope me-2" style="color:var(--color-kraft);"></i>Recent Quote Requests</h2>
    <a href="/admin/quotes_list.cfm" class="btn btn-sm btn-outline">View All</a>
  </div>
  <cfif getRecentQuotes.recordCount GT 0>
  <div style="overflow-x:auto;">
    <table class="admin-table">
      <thead>
        <tr>
          <th>Name</th>
          <th>Company</th>
          <th>Product</th>
          <th>Date</th>
          <th>Status</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <cfloop query="getRecentQuotes">
        <tr>
          <td>
            <strong>#htmlEditFormat(first_name)# #htmlEditFormat(last_name)#</strong><br>
            <span style="font-size:0.75rem; color:var(--text-muted);">#htmlEditFormat(email)#</span>
          </td>
          <td>#htmlEditFormat(company)#</td>
          <td>#htmlEditFormat(product_interest)#</td>
          <td style="white-space:nowrap;">#dateFormat(submitted_at,"mmm d, yyyy")#</td>
          <td>
            <cfif NOT is_read>
              <span class="badge badge-warning">New</span>
            <cfelse>
              <span class="badge badge-secondary">Read</span>
            </cfif>
          </td>
          <td>
            <a href="/admin/quotes_list.cfm?quote_id=#quote_id#" class="btn btn-sm btn-outline">View</a>
          </td>
        </tr>
        </cfloop>
      </tbody>
    </table>
  </div>
  <cfelse>
  <div class="admin-card-body" style="text-align:center; color:var(--text-muted); padding:2.5rem;">
    <i class="bi bi-inbox" style="font-size:2rem; display:block; margin-bottom:0.75rem; opacity:0.4;"></i>
    No quote requests yet.
  </div>
  </cfif>
</div>

<!--- Quick links --->
<div style="display:grid; grid-template-columns:repeat(auto-fill, minmax(200px,1fr)); gap:1rem; margin-top:1.5rem;">
  <a href="/admin/products_list.cfm" class="admin-card" style="padding:1.25rem; display:flex; align-items:center; gap:0.875rem; text-decoration:none; color:var(--text-body); transition:box-shadow var(--transition-fast);" onmouseover="this.style.boxShadow='var(--shadow-md)'" onmouseout="this.style.boxShadow=''">
    <i class="bi bi-box-seam" style="font-size:1.5rem; color:var(--color-forest);"></i>
    <div><strong style="display:block; font-size:var(--font-size-sm);">Manage Products</strong><span style="font-size:var(--font-size-xs); color:var(--text-muted);">Add, edit, reorder</span></div>
  </a>
  <a href="/admin/news_list.cfm" class="admin-card" style="padding:1.25rem; display:flex; align-items:center; gap:0.875rem; text-decoration:none; color:var(--text-body); transition:box-shadow var(--transition-fast);" onmouseover="this.style.boxShadow='var(--shadow-md)'" onmouseout="this.style.boxShadow=''">
    <i class="bi bi-newspaper" style="font-size:1.5rem; color:var(--color-kraft);"></i>
    <div><strong style="display:block; font-size:var(--font-size-sm);">Manage News</strong><span style="font-size:var(--font-size-xs); color:var(--text-muted);">Add, edit, publish</span></div>
  </a>
  <a href="/admin/testimonials_list.cfm" class="admin-card" style="padding:1.25rem; display:flex; align-items:center; gap:0.875rem; text-decoration:none; color:var(--text-body); transition:box-shadow var(--transition-fast);" onmouseover="this.style.boxShadow='var(--shadow-md)'" onmouseout="this.style.boxShadow=''">
    <i class="bi bi-chat-quote" style="font-size:1.5rem; color:var(--color-meadow);"></i>
    <div><strong style="display:block; font-size:var(--font-size-sm);">Testimonials</strong><span style="font-size:var(--font-size-xs); color:var(--text-muted);">Add, manage</span></div>
  </a>
  <a href="/admin/settings.cfm" class="admin-card" style="padding:1.25rem; display:flex; align-items:center; gap:0.875rem; text-decoration:none; color:var(--text-body); transition:box-shadow var(--transition-fast);" onmouseover="this.style.boxShadow='var(--shadow-md)'" onmouseout="this.style.boxShadow=''">
    <i class="bi bi-gear" style="font-size:1.5rem; color:var(--text-muted);"></i>
    <div><strong style="display:block; font-size:var(--font-size-sm);">Site Settings</strong><span style="font-size:var(--font-size-xs); color:var(--text-muted);">Hero, contact info</span></div>
  </a>
</div>

</cfoutput>

<cfinclude template="/themes/biotwine/layouts/admin_close.cfm">
