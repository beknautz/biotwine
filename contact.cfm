<!--- contact.cfm — Contact & Quote Request --->
<cfinclude template="/includes/theme_loader.cfm">
<cfset request.layout    = "default">
<cfset request.pageTitle = "Contact Us &amp; Request a Quote">
<cfparam name="url.product" default="">

<cfinclude template="/themes/biotwine/layouts/default_open.cfm">

<cfoutput>

<section class="page-hero">
  <div class="container">
    <div class="eyebrow">Get in Touch</div>
    <h1>Contact Us &amp; Request a Quote</h1>
    <p>Our team is ready to help. Fill out the form below or give us a call.</p>
  </div>
</section>

<section class="section">
  <div class="container">
    <div style="display:grid; grid-template-columns:1fr 380px; gap:4rem; align-items:start;">

      <!--- QUOTE FORM --->
      <div>
        <h2 style="font-size:var(--font-size-2xl); margin-bottom:1.75rem;">Request a Quote</h2>
        <div id="form-messages"></div>

        <form
          hx-post="/contact_save.cfm"
          hx-target="##form-messages"
          hx-swap="innerHTML"
          hx-indicator="##submit-spinner"
          novalidate
        >

          <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;" class="mb-3">
            <div>
              <label class="form-label">First Name <span style="color:##C0392B;">*</span></label>
              <input type="text" name="first_name" class="form-control" required placeholder="Jane">
            </div>
            <div>
              <label class="form-label">Last Name <span style="color:##C0392B;">*</span></label>
              <input type="text" name="last_name" class="form-control" required placeholder="Smith">
            </div>
          </div>

          <div class="mb-3">
            <label class="form-label">Company</label>
            <input type="text" name="company" class="form-control" placeholder="Your Farm or Business">
          </div>

          <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;" class="mb-3">
            <div>
              <label class="form-label">Email <span style="color:##C0392B;">*</span></label>
              <input type="email" name="email" class="form-control" required placeholder="jane@example.com">
            </div>
            <div>
              <label class="form-label">Phone</label>
              <input type="tel" name="phone" class="form-control" placeholder="(509) 555-0100">
            </div>
          </div>

          <div class="mb-3">
            <label class="form-label">Product of Interest</label>
            <select name="product_interest" class="form-control">
              <option value="">-- Select a product --</option>
              <option value="Hop Twine — Regular" <cfif url.product EQ "Hop Twine — Regular">selected</cfif>>Hop Twine — Regular</option>
              <option value="Hop Twine — Heavy"   <cfif url.product EQ "Hop Twine — Heavy">selected</cfif>>Hop Twine — Heavy</option>
              <option value="MAX Hop Twine"        <cfif url.product EQ "MAX Hop Twine">selected</cfif>>MAX Hop Twine</option>
              <option value="Hop Ties"             <cfif url.product EQ "Hop Ties">selected</cfif>>Hop Ties</option>
              <option value="Handle Bag Twine"     <cfif url.product EQ "Handle Bag Twine">selected</cfif>>Handle Bag Twine</option>
              <option value="FSC Handle Bag Twine" <cfif url.product EQ "FSC Handle Bag Twine">selected</cfif>>FSC Certified Handle Bag Twine</option>
              <option value="Arching Twine"        <cfif url.product EQ "Arching Twine">selected</cfif>>Center Pull Arching Twine</option>
              <option value="Other / Not Sure">Other / Not Sure</option>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label">Message</label>
            <textarea name="message" class="form-control" rows="5" placeholder="Tell us about your needs — quantities, timing, delivery location..."></textarea>
          </div>

          <button type="submit" class="btn btn-primary btn-lg">
            <span id="submit-spinner" class="htmx-indicator me-2">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="animation:spin 1s linear infinite;">
                <circle cx="12" cy="12" r="10" stroke-opacity="0.25"/><path d="M12 2a10 10 0 0 1 10 10"/>
              </svg>
            </span>
            Send Request
          </button>

        </form>
      </div>

      <!--- CONTACT INFO --->
      <div style="padding-top:0.5rem;">
        <div class="admin-card" style="margin-bottom:1.5rem;">
          <div class="admin-card-body">
            <h3 style="font-size:var(--font-size-lg); margin-bottom:1.25rem;">Contact Information</h3>
            <div style="display:flex; flex-direction:column; gap:1rem;">
              <div style="display:flex; gap:0.875rem; align-items:flex-start;">
                <i class="bi bi-geo-alt" style="color:var(--color-kraft); font-size:1.1rem; margin-top:2px; flex-shrink:0;"></i>
                <div style="font-size:var(--font-size-sm); line-height:1.7; color:var(--text-muted);">
                  210 South Division Street<br>
                  P.O. Box 430<br>
                  Toppenish, WA 98948
                </div>
              </div>
              <div style="display:flex; gap:0.875rem; align-items:center;">
                <i class="bi bi-telephone" style="color:var(--color-kraft); font-size:1.1rem; flex-shrink:0;"></i>
                <a href="tel:5098653340" style="font-size:var(--font-size-base); font-weight:600; color:var(--text-body);">(509) 865-3340</a>
              </div>
              <div style="display:flex; gap:0.875rem; align-items:center;">
                <i class="bi bi-envelope" style="color:var(--color-kraft); font-size:1.1rem; flex-shrink:0;"></i>
                <a href="mailto:info@BioTwine.com" style="font-size:var(--font-size-sm); color:var(--text-muted);">info@BioTwine.com</a>
              </div>
              <div style="display:flex; gap:0.875rem; align-items:flex-start;">
                <i class="bi bi-clock" style="color:var(--color-kraft); font-size:1.1rem; margin-top:2px; flex-shrink:0;"></i>
                <div style="font-size:var(--font-size-sm); color:var(--text-muted);">Monday–Friday<br>8:00am–5:00pm Pacific</div>
              </div>
            </div>
          </div>
        </div>

        <div style="background:var(--bg-section-dark); border-radius:var(--border-radius-lg); padding:1.5rem; color:##FFFFFF;">
          <div style="font-size:0.7rem; letter-spacing:0.15em; text-transform:uppercase; color:var(--color-meadow); font-weight:600; margin-bottom:0.75rem;">Our Certifications</div>
          <div style="display:flex; flex-direction:column; gap:0.625rem;">
            <div style="display:flex; align-items:center; gap:0.6rem; font-size:var(--font-size-sm); color:rgba(255,255,255,0.82);">
              <i class="bi bi-patch-check-fill" style="color:var(--color-kraft-light);"></i>
              FSC Certified — Chain of Custody Documentation Available
            </div>
            <div style="display:flex; align-items:center; gap:0.6rem; font-size:var(--font-size-sm); color:rgba(255,255,255,0.82);">
              <i class="bi bi-recycle" style="color:var(--color-kraft-light);"></i>
              100% Biodegradable — U.S. &amp; Canadian Kraft Paper
            </div>
            <div style="display:flex; align-items:center; gap:0.6rem; font-size:var(--font-size-sm); color:rgba(255,255,255,0.82);">
              <i class="bi bi-flag-fill" style="color:var(--color-kraft-light);"></i>
              Made in USA — Toppenish, Washington
            </div>
          </div>
        </div>
      </div>

    </div>
  </div>
</section>

<style>
  @keyframes spin { to { transform: rotate(360deg); } }
  @media (max-width:768px) {
    .contact-grid { grid-template-columns: 1fr !important; }
  }
</style>

</cfoutput>

<cfinclude template="/themes/biotwine/layouts/default_close.cfm">
