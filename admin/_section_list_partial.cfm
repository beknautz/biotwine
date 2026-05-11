<!--- admin/_section_list_partial.cfm
      Included by section_delete.cfm, section_sort.cfm, and section_save.cfm (toggle).
      Returns the refreshed sections-list HTML for the current page_slug.
      Requires: pageSlug variable to be set by the calling file.
--->
<cfquery name="getSections" datasource="#application.dsn#">
  SELECT section_id, section_type, section_label, eyebrow, heading, sort_order, is_active
  FROM   page_sections
  WHERE  page_slug = <cfqueryparam value="#pageSlug#" cfsqltype="cf_sql_varchar">
  ORDER  BY sort_order ASC
</cfquery>

<cfif getSections.recordCount EQ 0>
<cfoutput>
<div class="admin-card" style="text-align:center; padding:3rem; color:var(--text-muted);">
  <i class="bi bi-layout-text-window" style="font-size:2.5rem; display:block; margin-bottom:1rem; opacity:0.35;"></i>
  <p style="margin:0;">No sections yet. Click <strong>Add Section</strong> to get started.</p>
</div>
</cfoutput>
<cfelse>
<cfoutput>
<cfloop query="getSections">
<div class="admin-card" style="margin-bottom:0.875rem; display:flex; align-items:center; gap:1rem; padding:1rem 1.25rem;">

  <!--- Sort arrows --->
  <div style="display:flex; flex-direction:column; gap:2px;">
    <cfif getSections.currentRow GT 1>
    <form style="margin:0;" hx-post="/admin/section_sort.cfm" hx-target="##sections-list" hx-swap="innerHTML">
      <input type="hidden" name="section_id" value="#getSections.section_id#">
      <input type="hidden" name="direction" value="up">
      <input type="hidden" name="page_slug" value="#pageSlug#">
      <button type="submit" class="btn btn-sm btn-outline" style="padding:2px 7px;" title="Move up"><i class="bi bi-chevron-up"></i></button>
    </form>
    <cfelse>
    <button class="btn btn-sm btn-outline" style="padding:2px 7px; opacity:0.3;" disabled><i class="bi bi-chevron-up"></i></button>
    </cfif>
    <cfif getSections.currentRow LT getSections.recordCount>
    <form style="margin:0;" hx-post="/admin/section_sort.cfm" hx-target="##sections-list" hx-swap="innerHTML">
      <input type="hidden" name="section_id" value="#getSections.section_id#">
      <input type="hidden" name="direction" value="down">
      <input type="hidden" name="page_slug" value="#pageSlug#">
      <button type="submit" class="btn btn-sm btn-outline" style="padding:2px 7px;" title="Move down"><i class="bi bi-chevron-down"></i></button>
    </form>
    <cfelse>
    <button class="btn btn-sm btn-outline" style="padding:2px 7px; opacity:0.3;" disabled><i class="bi bi-chevron-down"></i></button>
    </cfif>
  </div>

  <!--- Section info --->
  <div style="flex:1; min-width:0;">
    <div style="font-weight:600; font-size:var(--font-size-sm);">#htmlEditFormat(getSections.section_label)#</div>
    <div style="font-size:0.72rem; color:var(--text-muted); font-family:var(--font-mono); margin-top:2px;">#htmlEditFormat(getSections.section_type)#
      <cfif len(trim(getSections.heading))> &mdash; #htmlEditFormat(left(getSections.heading,60))##iif(len(getSections.heading) GT 60, de('…'), de(''))#</cfif>
    </div>
  </div>

  <!--- Active toggle --->
  <form style="margin:0;" hx-post="/admin/section_save.cfm" hx-target="##sections-list" hx-swap="innerHTML">
    <input type="hidden" name="action" value="toggle">
    <input type="hidden" name="section_id" value="#getSections.section_id#">
    <input type="hidden" name="page_slug" value="#pageSlug#">
    <button type="submit" class="btn btn-sm btn-outline" style="color:#iif(getSections.is_active, de('var(--color-forest)'), de('var(--text-muted)'))#;" title="#iif(getSections.is_active, de('Click to hide'), de('Click to show'))#">
      <i class="bi bi-#iif(getSections.is_active, de('eye'), de('eye-slash'))#"></i>
    </button>
  </form>

  <!--- Edit --->
  <a href="/admin/section_form.cfm?section_id=#getSections.section_id#&page_slug=#pageSlug#" class="btn btn-sm btn-outline">
    <i class="bi bi-pencil me-1"></i>Edit
  </a>

  <!--- Delete --->
  <form style="margin:0;"
    hx-post="/admin/section_delete.cfm"
    hx-target="##sections-list"
    hx-swap="innerHTML"
    hx-confirm="Delete this section? This cannot be undone.">
    <input type="hidden" name="section_id" value="#getSections.section_id#">
    <input type="hidden" name="page_slug"  value="#pageSlug#">
    <button type="submit" class="btn btn-sm btn-outline" style="color:var(--color-error);">
      <i class="bi bi-trash"></i>
    </button>
  </form>

</div>
</cfloop>
</cfoutput>
</cfif>
