<!--- /admin/quotes_list.cfm --->
<cfinclude template="/includes/theme_loader.cfm">
<cfset request.layout    = "admin">
<cfset request.pageTitle = "Quote Requests">
<cfset request.adminPage = "quotes">

<cfparam name="url.quote_id" default="0">

<!--- Mark as read if opened directly --->
<cfif val(url.quote_id)>
  <cftry>
    <cfquery datasource="#application.dsn#">
      UPDATE quote_requests SET is_read = 1
      WHERE quote_id = <cfqueryparam value="#url.quote_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfcatch type="database"></cfcatch>
  </cftry>
</cfif>

<cftry>
  <cfquery name="getQuotes" datasource="#application.dsn#">
    SELECT quote_id, first_name, last_name, company, email, phone, product_interest, message, is_read, submitted_at
    FROM quote_requests
    ORDER BY submitted_at DESC
  </cfquery>
  <cfcatch type="database">
    <cflog file="app_errors" text="quotes_list.cfm: #cfcatch.message#">
    <cfset getQuotes = queryNew("quote_id,first_name,last_name,company,email,phone,product_interest,message,is_read,submitted_at")>
  </cfcatch>
</cftry>

<cfinclude template="/themes/biotwine/layouts/admin_open.cfm">

<cfoutput>

<!--- Detail panel if a quote_id is selected --->
<cfif val(url.quote_id)>
  <cfloop query="getQuotes">
    <cfif getQuotes.quote_id EQ url.quote_id>
    <div class="admin-card" style="margin-bottom:1.5rem;">
      <div class="admin-card-header">
        <h2><i class="bi bi-envelope-open me-2" style="color:var(--color-kraft);"></i>Quote Request Detail</h2>
        <a href="/admin/quotes_list.cfm" class="btn btn-sm btn-outline">Back to All</a>
      </div>
      <div class="admin-card-body">
        <div style="display:grid; grid-template-columns:1fr 1fr; gap:1.5rem;">
          <div>
            <div style="font-size:0.7rem; letter-spacing:0.12em; text-transform:uppercase; color:var(--text-muted); margin-bottom:0.25rem;">Name</div>
            <div style="font-weight:600;">#htmlEditFormat(getQuotes.first_name)# #htmlEditFormat(getQuotes.last_name)#</div>
          </div>
          <div>
            <div style="font-size:0.7rem; letter-spacing:0.12em; text-transform:uppercase; color:var(--text-muted); margin-bottom:0.25rem;">Company</div>
            <div>#htmlEditFormat(getQuotes.company)#</div>
          </div>
          <div>
            <div style="font-size:0.7rem; letter-spacing:0.12em; text-transform:uppercase; color:var(--text-muted); margin-bottom:0.25rem;">Email</div>
            <div><a href="mailto:#htmlEditFormat(getQuotes.email)#">#htmlEditFormat(getQuotes.email)#</a></div>
          </div>
          <div>
            <div style="font-size:0.7rem; letter-spacing:0.12em; text-transform:uppercase; color:var(--text-muted); margin-bottom:0.25rem;">Phone</div>
            <div>#htmlEditFormat(getQuotes.phone)#</div>
          </div>
          <div>
            <div style="font-size:0.7rem; letter-spacing:0.12em; text-transform:uppercase; color:var(--text-muted); margin-bottom:0.25rem;">Product of Interest</div>
            <div>#htmlEditFormat(getQuotes.product_interest)#</div>
          </div>
          <div>
            <div style="font-size:0.7rem; letter-spacing:0.12em; text-transform:uppercase; color:var(--text-muted); margin-bottom:0.25rem;">Submitted</div>
            <div>#dateTimeFormat(getQuotes.submitted_at, "mmm d, yyyy h:mm tt")#</div>
          </div>
          <div style="grid-column:1/-1;">
            <div style="font-size:0.7rem; letter-spacing:0.12em; text-transform:uppercase; color:var(--text-muted); margin-bottom:0.25rem;">Message</div>
            <div style="white-space:pre-wrap; font-size:var(--font-size-sm); color:var(--text-body);">#htmlEditFormat(getQuotes.message)#</div>
          </div>
        </div>
      </div>
    </div>
    </cfif>
  </cfloop>
</cfif>

<!--- Full list table --->
<div class="admin-card">
  <div class="admin-card-header">
    <h2><i class="bi bi-envelope me-2" style="color:var(--color-kraft);"></i>All Quote Requests (#getQuotes.recordCount#)</h2>
  </div>
  <div style="overflow-x:auto;">
    <table class="admin-table">
      <thead>
        <tr>
          <th>Name</th>
          <th>Company</th>
          <th>Email</th>
          <th>Product</th>
          <th>Date</th>
          <th>Status</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <cfif getQuotes.recordCount GT 0>
          <cfloop query="getQuotes">
          <tr id="qrow-#quote_id#" style="<cfif NOT is_read>font-weight:500; background:#FFFBF0;</cfif>">
            <td>#htmlEditFormat(first_name)# #htmlEditFormat(last_name)#</td>
            <td>#htmlEditFormat(company)#</td>
            <td><a href="mailto:#htmlEditFormat(email)#" style="font-size:var(--font-size-sm);">#htmlEditFormat(email)#</a></td>
            <td>#htmlEditFormat(product_interest)#</td>
            <td style="white-space:nowrap; font-size:var(--font-size-sm);">#dateFormat(submitted_at,"mmm d, yyyy")#</td>
            <td>
              <cfif NOT is_read>
                <span class="badge badge-warning">New</span>
              <cfelse>
                <span class="badge badge-secondary">Read</span>
              </cfif>
            </td>
            <td style="white-space:nowrap;">
              <a href="/admin/quotes_list.cfm?quote_id=#quote_id#" class="btn btn-sm btn-outline">View</a>
              <button
                class="btn btn-sm btn-danger"
                hx-post="/admin/quotes_delete.cfm"
                hx-vals='{"quote_id": "#quote_id#"}'
                hx-target="##qrow-#quote_id#"
                hx-swap="outerHTML swap:300ms"
                hx-confirm="Delete this quote request?"
              >Delete</button>
            </td>
          </tr>
          </cfloop>
        <cfelse>
          <tr>
            <td colspan="7" style="text-align:center; color:var(--text-muted); padding:3rem;">
              No quote requests yet.
            </td>
          </tr>
        </cfif>
      </tbody>
    </table>
  </div>
</div>

</cfoutput>

<cfinclude template="/themes/biotwine/layouts/admin_close.cfm">
