<!--- /admin/news_list.cfm --->
<cfinclude template="/includes/theme_loader.cfm">
<cfset request.layout    = "admin">
<cfset request.pageTitle = "News">
<cfset request.adminPage = "news">

<cftry>
  <cfquery name="getNews" datasource="#application.dsn#">
    SELECT news_id, title, slug, pub_date, is_active, created_at
    FROM news
    ORDER BY pub_date DESC
  </cfquery>
  <cfcatch type="database">
    <cflog file="app_errors" text="news_list.cfm: #cfcatch.message#">
    <cfset getNews = queryNew("news_id,title,slug,pub_date,is_active,created_at")>
  </cfcatch>
</cftry>

<cfinclude template="/themes/biotwine/layouts/admin_open.cfm">

<cfoutput>

<div class="admin-card">
  <div class="admin-card-header">
    <h2><i class="bi bi-newspaper me-2" style="color:var(--color-kraft);"></i>News &amp; Announcements</h2>
    <a href="/admin/news_form.cfm" class="btn btn-sm btn-primary">+ New Article</a>
  </div>

  <div style="overflow-x:auto;">
    <table class="admin-table">
      <thead>
        <tr>
          <th>Title</th>
          <th>Slug</th>
          <th>Publish Date</th>
          <th>Status</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <cfif getNews.recordCount GT 0>
          <cfloop query="getNews">
          <tr id="row-#news_id#">
            <td><strong>#htmlEditFormat(title)#</strong></td>
            <td style="font-family:var(--font-mono); font-size:0.75rem; color:var(--text-muted);">#htmlEditFormat(slug)#</td>
            <td>#dateFormat(pub_date, "mmm d, yyyy")#</td>
            <td>
              <cfif is_active>
                <span class="badge badge-success">Published</span>
              <cfelse>
                <span class="badge badge-secondary">Draft</span>
              </cfif>
            </td>
            <td style="white-space:nowrap;">
              <a href="/news_detail.cfm?slug=#urlEncodedFormat(slug)#" target="_blank" class="btn btn-sm btn-outline" title="View on site"><i class="bi bi-eye"></i></a>
              <a href="/admin/news_form.cfm?news_id=#news_id#" class="btn btn-sm btn-outline">Edit</a>
              <button
                class="btn btn-sm btn-danger"
                hx-post="/admin/news_delete.cfm"
                hx-vals='{"news_id": "#news_id#"}'
                hx-target="##row-#news_id#"
                hx-swap="outerHTML swap:300ms"
                hx-confirm="Delete '#htmlEditFormat(title)#'?"
              >Delete</button>
            </td>
          </tr>
          </cfloop>
        <cfelse>
          <tr>
            <td colspan="5" style="text-align:center; color:var(--text-muted); padding:3rem;">
              No articles yet. <a href="/admin/news_form.cfm">Write the first one.</a>
            </td>
          </tr>
        </cfif>
      </tbody>
    </table>
  </div>
</div>

</cfoutput>

<cfinclude template="/themes/biotwine/layouts/admin_close.cfm">
