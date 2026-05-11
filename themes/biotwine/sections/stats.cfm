<!--- sections/stats.cfm — horizontal stats bar --->
<cftry>
  <cfset statItems = deserializeJSON(extra_data)>
  <cfcatch><cfset statItems = []></cfcatch>
</cftry>
<cfif isArray(statItems) AND arrayLen(statItems)>
<cfoutput>
<div class="stats-strip">
  <div class="container">
    <cfloop array="#statItems#" index="i" item="stat">
    <div class="stat-item" data-fade="" data-fade-delay="#((i-1)*80)#">
      <span class="stat-number">#htmlEditFormat(stat.number)#</span>
      <span class="stat-label">#htmlEditFormat(stat.label)#</span>
    </div>
    </cfloop>
  </div>
</div>
</cfoutput>
</cfif>
