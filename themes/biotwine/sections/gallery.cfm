<!--- sections/gallery.cfm — masonry/grid photo gallery --->
<cftry>
  <cfset galleryItems = deserializeJSON(extra_data)>
  <cfcatch><cfset galleryItems = []></cfcatch>
</cftry>
<cfif isArray(galleryItems) AND arrayLen(galleryItems)>
<cfoutput>
<section class="section section-gallery">
  <div class="container">
    <div class="gallery-grid">
      <cfloop array="#galleryItems#" index="gi" item="gItem">
      <div class="gallery-item" data-fade="" data-fade-delay="#((gi-1)*60)#">
        <img src="#htmlEditFormat(gItem.image)#" alt="#htmlEditFormat(gItem.alt)#" loading="lazy">
      </div>
      </cfloop>
    </div>
  </div>
</section>
</cfoutput>
</cfif>
