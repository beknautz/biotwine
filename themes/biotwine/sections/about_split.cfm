<!--- sections/about_split.cfm — two-column: image/video left, text right --->
<cfset isVideo = (len(trim(image)) AND (findNoCase("vimeo",image) OR findNoCase("youtube",image) OR findNoCase("player.",image)))>
<cfoutput>
<section class="section">
  <div class="container">
    <div class="about-split">
      <div data-fade="">
        <cfif isVideo>
        <div class="about-image-wrap">
          <div style="padding:56.25% 0 0 0; position:relative;">
            <iframe src="#htmlEditFormat(image)#" frameborder="0"
              allow="autoplay; fullscreen; picture-in-picture; clipboard-write; encrypted-media"
              referrerpolicy="strict-origin-when-cross-origin"
              style="position:absolute; top:0; left:0; width:100%; height:100%;"
              title="#htmlEditFormat(image_alt)#"></iframe>
          </div>
        </div>
        <cfelse>
        <div class="about-image-wrap">
          <img src="#htmlEditFormat(image)#" alt="#htmlEditFormat(image_alt)#" loading="lazy">
          <div class="about-cert-badge">
            <span class="badge-big">FSC</span>
            <span class="badge-small">Certified</span>
          </div>
        </div>
        </cfif>
      </div>
      <div data-fade="" data-fade-delay="120">
        <cfif len(trim(eyebrow))>
        <div class="section-eyebrow">#htmlEditFormat(eyebrow)#</div>
        </cfif>
        <h2 class="section-title">#heading#</h2>
        <cfif len(trim(body_text))>
        #body_text#
        </cfif>
        <cfif len(trim(cta_label)) OR len(trim(cta2_label))>
        <div style="display:flex; gap:1rem; flex-wrap:wrap; margin-top:1.5rem;">
          <cfif len(trim(cta_label))>
          <a href="#htmlEditFormat(cta_url)#" class="btn btn-outline">#htmlEditFormat(cta_label)#</a>
          </cfif>
          <cfif len(trim(cta2_label))>
          <a href="#htmlEditFormat(cta2_url)#" class="btn btn-primary">#htmlEditFormat(cta2_label)#</a>
          </cfif>
        </div>
        </cfif>
      </div>
    </div>
  </div>
</section>
</cfoutput>
