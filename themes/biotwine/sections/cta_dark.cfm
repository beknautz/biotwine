<!--- sections/cta_dark.cfm — dark-background call-to-action strip --->
<cfoutput>
<section class="section-cta-dark">
  <div class="container" style="text-align:center;">
    <cfif len(trim(eyebrow))>
    <div class="section-eyebrow" style="color:rgba(255,255,255,0.65);">#htmlEditFormat(eyebrow)#</div>
    </cfif>
    <h2 class="section-title" style="color:##fff;">#heading#</h2>
    <cfif len(trim(subheading))>
    <p style="color:rgba(255,255,255,0.8); max-width:600px; margin:0 auto 2rem;">#htmlEditFormat(subheading)#</p>
    </cfif>
    <cfif len(trim(cta_label)) OR len(trim(cta2_label))>
    <div style="display:flex; gap:1rem; justify-content:center; flex-wrap:wrap;">
      <cfif len(trim(cta_label))>
      <a href="#htmlEditFormat(cta_url)#" class="btn btn-secondary btn-lg">#htmlEditFormat(cta_label)#</a>
      </cfif>
      <cfif len(trim(cta2_label))>
      <a href="#htmlEditFormat(cta2_url)#" class="btn btn-outline-light btn-lg">#htmlEditFormat(cta2_label)#</a>
      </cfif>
    </div>
    </cfif>
  </div>
</section>
</cfoutput>
