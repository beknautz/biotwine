<!--- sections/testimonials.cfm — rotating testimonials carousel --->
<cfquery name="getTestimonials" datasource="#application.dsn#">
  SELECT testimonial_id, quote, company, location, years_partner
  FROM   testimonials
  WHERE  is_active = 1
  ORDER  BY sort_order ASC, testimonial_id ASC
</cfquery>

<cfif getTestimonials.recordCount EQ 0><cfabort></cfif>

<cfoutput>
<section class="section-testimonials">
  <div class="container">

    <cfif len(trim(eyebrow))>
    <div class="section-eyebrow" style="text-align:center;">#htmlEditFormat(eyebrow)#</div>
    </cfif>
    <cfif len(trim(heading))>
    <h2 class="section-title" style="text-align:center;">#heading#</h2>
    </cfif>

    <div class="testimonial-carousel" id="testimonial-carousel-#section_id#" data-autoplay="5000">

      <div class="testimonial-track">
        <cfloop query="getTestimonials">
        <div class="testimonial-slide<cfif getTestimonials.currentRow EQ 1> is-active</cfif>">
          <blockquote class="testimonial-quote">
            <p>#quote#</p>
          </blockquote>
          <div class="testimonial-meta">
            <strong class="testimonial-company">#htmlEditFormat(company)#</strong>
            <cfif len(trim(location))>
            <span class="testimonial-location">#htmlEditFormat(location)#</span>
            </cfif>
            <cfif len(trim(years_partner))>
            <span class="testimonial-years">#htmlEditFormat(years_partner)# partner</span>
            </cfif>
          </div>
        </div>
        </cfloop>
      </div>

      <cfif getTestimonials.recordCount GT 1>
      <div class="testimonial-controls">
        <button class="testimonial-prev" aria-label="Previous testimonial">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg>
        </button>
        <div class="testimonial-dots">
          <cfloop query="getTestimonials">
          <button class="testimonial-dot<cfif getTestimonials.currentRow EQ 1> is-active</cfif>" data-index="#getTestimonials.currentRow - 1#" aria-label="Go to testimonial #getTestimonials.currentRow#"></button>
          </cfloop>
        </div>
        <button class="testimonial-next" aria-label="Next testimonial">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
        </button>
      </div>
      </cfif>

    </div>
  </div>
</section>

<cfif getTestimonials.recordCount GT 1>
<script>
(function() {
  var carousel = document.getElementById('testimonial-carousel-#section_id#');
  if (!carousel) return;
  var slides = carousel.querySelectorAll('.testimonial-slide');
  var dots   = carousel.querySelectorAll('.testimonial-dot');
  var prev   = carousel.querySelector('.testimonial-prev');
  var next   = carousel.querySelector('.testimonial-next');
  var total  = slides.length;
  var current = 0;
  var timer;
  var delay = parseInt(carousel.dataset.autoplay) || 5000;

  function goTo(n) {
    slides[current].classList.remove('is-active');
    dots[current].classList.remove('is-active');
    current = (n + total) % total;
    slides[current].classList.add('is-active');
    dots[current].classList.add('is-active');
  }

  function startAuto() {
    clearInterval(timer);
    timer = setInterval(function() { goTo(current + 1); }, delay);
  }

  if (next) next.addEventListener('click', function() { goTo(current + 1); startAuto(); });
  if (prev) prev.addEventListener('click', function() { goTo(current - 1); startAuto(); });
  dots.forEach(function(dot) {
    dot.addEventListener('click', function() { goTo(parseInt(this.dataset.index)); startAuto(); });
  });

  // Pause on hover
  carousel.addEventListener('mouseenter', function() { clearInterval(timer); });
  carousel.addEventListener('mouseleave', startAuto);

  startAuto();
}());
</script>
</cfif>

</cfoutput>
