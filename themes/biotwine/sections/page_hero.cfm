<!--- sections/page_hero.cfm — simple page header used on About, Products, Contact --->
<cfoutput>
<section class="page-hero">
  <div class="container">
    <cfif len(trim(eyebrow))>
    <div class="eyebrow">#htmlEditFormat(eyebrow)#</div>
    </cfif>
    <h1>#heading#</h1>
    <cfif len(trim(subheading))>
    <p>#subheading#</p>
    </cfif>
  </div>
</section>
</cfoutput>
