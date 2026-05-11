<!--- sections/hero.cfm — full-width homepage hero with background image --->
<!--- Expects cfloop query variables: heading, subheading, eyebrow, image, cta_label, cta_url, cta2_label, cta2_url --->
<cfoutput>
<section class="hero">
  <cfif len(trim(image))>
  <div class="hero-bg" style="background-image: url('#htmlEditFormat(image)#');"></div>
  </cfif>
  <div class="hero-content">
    <cfif len(trim(eyebrow))>
    <div class="hero-eyebrow">#htmlEditFormat(eyebrow)#</div>
    </cfif>
    <h1>#heading#</h1>
    <cfif len(trim(subheading))>
    <p class="hero-subtitle">#htmlEditFormat(subheading)#</p>
    </cfif>
    <cfif len(trim(cta_label)) OR len(trim(cta2_label))>
    <div class="hero-actions">
      <cfif len(trim(cta_label))>
      <a href="#htmlEditFormat(cta_url)#" class="btn btn-secondary btn-lg">#htmlEditFormat(cta_label)#</a>
      </cfif>
      <cfif len(trim(cta2_label))>
      <a href="#htmlEditFormat(cta2_url)#" class="btn btn-outline-light btn-lg">#htmlEditFormat(cta2_label)#</a>
      </cfif>
    </div>
    </cfif>
  </div>
  <div class="hero-badge">
    <strong style="font-size:1.1rem; display:block; font-family:var(--font-display);">FSC</strong>
    <span style="font-size:0.65rem; letter-spacing:0.1em; text-transform:uppercase; opacity:0.75;">Certified</span>
  </div>
</section>
</cfoutput>
