<cfinclude template="/includes/theme_loader.cfm">

<cfset request.layout    = "admin">
<cfset request.pageTitle = "Pages">

<cftry>
    <cfquery name="getPages" datasource="#application.dsn#">
        SELECT page_id, nav_title, page_title, slug, has_dropdown, layout_type, is_active, sort_order, created_at
        FROM pages
        ORDER BY sort_order ASC, created_at DESC
    </cfquery>
    <cfcatch type="database">
        <cflog file="app_errors" text="pages_list.cfm query error: #cfcatch.message# — #cfcatch.detail#">
        <cfset getPages = queryNew("page_id,nav_title,page_title,slug,is_active,sort_order,created_at")>
    </cfcatch>
</cftry>

<cfinclude template="/themes/#application.theme#/layouts/admin_open.cfm">

<cfoutput>
<div class="d-flex justify-content-between align-items-center mb-4">
    <h1 class="h3 mb-0">Pages</h1>
    <a href="pages_form.cfm" class="btn btn-primary">
        <i class="bi bi-plus-lg me-1"></i> New Page
    </a>
</div>

<cfif getPages.recordCount EQ 0>
    <div class="alert alert-info">No pages found. <a href="pages_form.cfm">Create the first one.</a></div>
<cfelse>
    <div class="card">
        <div class="card-body p-0">
            <table class="table table-bordered table-hover mb-0">
                <thead class="table-dark">
                    <tr>
                        <th style="width:60px">Order</th>
                        <th>Nav Title</th>
                        <th>Page Title</th>
                        <th>Slug</th>
                        <th style="width:80px">Active</th>
                        <th style="width:90px">Dropdown</th>
                        <th style="width:90px">Layout</th>
                        <th>Created</th>
                        <th style="width:130px"></th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop query="getPages">
                    <tr id="row-#page_id#">
                        <td class="text-center">#sort_order#</td>
                        <td>#htmlEditFormat(nav_title)#</td>
                        <td>#htmlEditFormat(page_title)#</td>
                        <td><code>#htmlEditFormat(slug)#</code></td>
                        <td class="text-center">
                            <cfif is_active>
                                <span class="badge bg-success">Yes</span>
                            <cfelse>
                                <span class="badge bg-secondary">No</span>
                            </cfif>
                        </td>
                        <td class="text-center">
                            <cfif has_dropdown>
                                <span class="badge bg-info text-dark">Yes</span>
                            <cfelse>
                                <span class="text-muted">—</span>
                            </cfif>
                        </td>
                        <td class="text-center">
                            <cfif layout_type EQ "custom">
                                <span class="badge bg-warning text-dark">Custom</span>
                            <cfelse>
                                <span class="badge bg-secondary">Generic</span>
                            </cfif>
                        </td>
                        <td>#dateFormat(created_at, "mmm d, yyyy")#</td>
                        <td>
                            <a href="pages_form.cfm?page_id=#page_id#" class="btn btn-sm btn-secondary">
                                <i class="bi bi-pencil"></i> Edit
                            </a>
                            <button
                                class="btn btn-sm btn-danger"
                                hx-post="pages_delete.cfm"
                                hx-vals='{"page_id": "#page_id#"}'
                                hx-target="##row-#page_id#"
                                hx-swap="outerHTML swap:300ms"
                                hx-confirm="Delete '#htmlEditFormat(nav_title)#'? This cannot be undone."
                            >
                                <i class="bi bi-trash"></i>
                            </button>
                        </td>
                    </tr>
                    </cfloop>
                </tbody>
            </table>
        </div>
    </div>
</cfif>
</cfoutput>

<cfinclude template="/themes/#application.theme#/layouts/admin_close.cfm">
