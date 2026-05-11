<!--- sections/values.cfm — 2x2 value cards grid --->
<cftry>
  <cfset valueItems = deserializeJSON(extra_data)>
  <cfcatch><cfset valueItems = []></cfcatch>
</cftry>
<cfoutput>
<section class="section section-values">
  <div class="container">
    <cfif len(trim(eyebrow))>
    <div class="section-eyebrow" style="text-align:center;">#htmlEditFormat(eyebrow)#</div>
    </cfif>
    <cfif len(trim(heading))>
    <h2 class="section-title" style="text-align:center;">#heading#</h2>
    </cfif>
    <cfif isArray(valueItems) AND arrayLen(valueItems)>
    <div class="values-grid">
      <cfloop array="#valueItems#" index="vi" item="val">
      <div class="value-card" data-fade="" data-fade-delay="#((vi-1)*80)#">
        <h3 class="value-heading">#htmlEditFormat(val.heading)#</h3>
        <p class="value-text">#htmlEditFormat(val.text)#</p>
      </div>
      </cfloop>
    </div>
    </cfif>
  </div>
</section>
</cfoutput>
