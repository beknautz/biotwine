-- Run on biotwinedsn — creates the page_sections table and seeds all 4 pages
-- 2026-05-11

DROP TABLE IF EXISTS `page_sections`;

CREATE TABLE `page_sections` (
  `section_id`    int(11) NOT NULL AUTO_INCREMENT,
  `page_slug`     varchar(50)  NOT NULL,
  `section_type`  varchar(50)  NOT NULL,
  `section_label` varchar(100) NOT NULL DEFAULT '',
  `eyebrow`       varchar(150) NOT NULL DEFAULT '',
  `heading`       varchar(255) NOT NULL DEFAULT '',
  `subheading`    text         DEFAULT NULL,
  `body_text`     mediumtext   DEFAULT NULL,
  `image`         varchar(255) NOT NULL DEFAULT '',
  `image_alt`     varchar(255) NOT NULL DEFAULT '',
  `cta_label`     varchar(100) NOT NULL DEFAULT '',
  `cta_url`       varchar(255) NOT NULL DEFAULT '',
  `cta2_label`    varchar(100) NOT NULL DEFAULT '',
  `cta2_url`      varchar(255) NOT NULL DEFAULT '',
  `extra_data`    text         DEFAULT NULL,
  `is_active`     tinyint(1)   NOT NULL DEFAULT 1,
  `sort_order`    int(11)      NOT NULL DEFAULT 0,
  `created_at`    datetime     NOT NULL DEFAULT current_timestamp(),
  `updated_at`    datetime     NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`section_id`),
  KEY `idx_page_slug` (`page_slug`, `sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- ── HOME PAGE ────────────────────────────────────────────────────────────────

INSERT INTO `page_sections` (`page_slug`,`section_type`,`section_label`,`eyebrow`,`heading`,`subheading`,`body_text`,`image`,`image_alt`,`cta_label`,`cta_url`,`cta2_label`,`cta2_url`,`extra_data`,`is_active`,`sort_order`) VALUES

('home','hero','Homepage Hero',
 'Toppenish, Washington • Since 1994',
 'Twisted Paper Twine, Built for the Field.',
 'Over 100 years of combined manufacturing experience. Biodegradable paper twine for hop farms, berry orchards, and handle bag manufacturers.',
 NULL,
 '/assets/uploads/hero/home-hero.png','',
 'View All Products','/products.cfm',
 'Request a Quote','/contact.cfm',
 NULL,1,1),

('home','stats','Stats Bar',
 '','','',NULL,'','','','','','',
 '[{"number":"100+","label":"Years Combined Experience"},{"number":"35yr","label":"Perrault Farms Partnership"},{"number":"FSC","label":"Certified Sustainable Sourcing"},{"number":"100%","label":"Biodegradable U.S. & Canadian Kraft"}]',
 1,2),

('home','about_split','About Split',
 'Who We Are',
 'A Leading Manufacturer of <em>Twisted Paper Twine</em>',
 NULL,
 '<p>BioTwine Manufacturing has been supplying the hop industry, berry orchards, and handle bag manufacturers with premium biodegradable twisted paper twine since 1994.</p><p>All of our twine is manufactured from U.S. and Canadian kraft paper. We are committed to environmentally responsible, biodegradable products that support sustainable agriculture and Handle Bag manufacturing.</p>',
 'https://player.vimeo.com/video/1176801149?h=221314d00f&badge=0&autopause=0&player_id=0&app_id=58479','BioTwine Sizzle Reel',
 'Our Story','/about.cfm',
 'View Products','/products.cfm',
 NULL,1,3),

('home','gallery','Photo Gallery',
 '','','',NULL,'','','','','','',
 '[{"image":"/assets/uploads/img/Pic1.jpg","alt":"BioTwine Manufacturing"},{"image":"/assets/uploads/img/Pic2.jpg","alt":"BioTwine Manufacturing"},{"image":"/assets/uploads/img/Pic3.jpg","alt":"BioTwine Manufacturing"},{"image":"/assets/uploads/img/Pic4.jpg","alt":"BioTwine Manufacturing"}]',
 1,4),

('home','testimonials','Customer Testimonials',
 'What Our Customers Say',
 'Trusted by Farmers &amp; Manufacturers',
 NULL,NULL,'','','','','',NULL,1,5),

('home','cta_dark','Contact CTA',
 'Get in Touch',
 'Ready to Order or Need a Custom Quote?',
 'Our team is available Monday–Friday, 8am–5pm. Call us at (509) 865-3340 or submit a quote request online.',
 NULL,'','',
 'Request a Quote','/contact.cfm',
 '(509) 865-3340','tel:5098653340',
 NULL,1,6);


-- ── ABOUT PAGE ───────────────────────────────────────────────────────────────

INSERT INTO `page_sections` (`page_slug`,`section_type`,`section_label`,`eyebrow`,`heading`,`subheading`,`body_text`,`image`,`image_alt`,`cta_label`,`cta_url`,`cta2_label`,`cta2_url`,`extra_data`,`is_active`,`sort_order`) VALUES

('about','page_hero','Page Header',
 'Our Story',
 'About BioTwine Manufacturing',
 'Toppenish, Washington • Since 1994',
 NULL,'','','','','','',NULL,1,1),

('about','about_split','Company Story',
 'Who We Are',
 'A Legacy Built on Quality &amp; Sustainability',
 NULL,
 '<p>BioTwine Manufacturing has been supplying the Pacific Northwest hop industry, berry orchards, and handle bag manufacturers with premium biodegradable twisted paper twine since 1994.</p><p>With over 100 years of combined manufacturing experience, our team brings deep expertise to every spool we produce. We manufacture all of our twine from U.S. and Canadian kraft paper — materials we trust for consistent performance and responsible sourcing.</p><p>We are proud to be FSC Chain of Custody certified, providing our customers with full traceability documentation for their sustainability programs.</p>',
 '/assets/uploads/img/Pic1.png','BioTwine Manufacturing',
 '','','','',NULL,1,2),

('about','values','Values Grid',
 'Our Commitments','What We Stand For','',NULL,'','','','','','',
 '[{"heading":"FSC Certified","text":"Our FSC Chain of Custody certification means every spool is traceable from forest to field — ideal for customers with sustainability commitments and ESG reporting requirements."},{"heading":"100% Biodegradable","text":"All BioTwine products are manufactured from kraft paper. They decompose naturally at season end — no microplastics, no cleanup, no landfill. Good for the crop and good for the land."},{"heading":"Made in the USA","text":"Manufactured in Toppenish, Washington, using U.S. and Canadian kraft paper. We''re proud to support domestic manufacturing and keep supply chains short and reliable."},{"heading":"Long-Term Partnerships","text":"We''ve partnered with Perrault Farms for 35 years. Long relationships built on performance and trust are how we do business. We''re not a transactional supplier — we''re part of the season."}]',
 1,3),

('about','cta_dark','Contact CTA',
 'Work With Us',
 'Ready to Start a Conversation?',
 'Call us at (509) 865-3340 or submit a quote request online. We''ll get back to you within 1–2 business days.',
 NULL,'','',
 'Request a Quote','/contact.cfm',
 'View Products','/products.cfm',
 NULL,1,4);


-- ── PRODUCTS PAGE ────────────────────────────────────────────────────────────

INSERT INTO `page_sections` (`page_slug`,`section_type`,`section_label`,`eyebrow`,`heading`,`subheading`,`body_text`,`image`,`image_alt`,`cta_label`,`cta_url`,`cta2_label`,`cta2_url`,`extra_data`,`is_active`,`sort_order`) VALUES

('products','page_hero','Page Header',
 'BioTwine Manufacturing',
 'Our Products',
 'Premium biodegradable twisted paper twine &amp; engineered for the field.',
 NULL,'','','','','','',NULL,1,1),

('products','cta_dark','Contact CTA',
 'Let''s Talk',
 'Need a Custom Specification or Volume Pricing?',
 'Our team can work with you on custom twine specifications, volume pricing, and delivery logistics.',
 NULL,'','',
 'Contact Us Today','/contact.cfm',
 '','',NULL,1,2);


-- ── CONTACT PAGE ─────────────────────────────────────────────────────────────

INSERT INTO `page_sections` (`page_slug`,`section_type`,`section_label`,`eyebrow`,`heading`,`subheading`,`body_text`,`image`,`image_alt`,`cta_label`,`cta_url`,`cta2_label`,`cta2_url`,`extra_data`,`is_active`,`sort_order`) VALUES

('contact','page_hero','Page Header',
 'Get in Touch',
 'Contact Us &amp; Request a Quote',
 'Our team is ready to help. Fill out the form below or give us a call.',
 NULL,'','','','','','',NULL,1,1);


ALTER TABLE `page_sections`
  MODIFY `section_id` int(11) NOT NULL AUTO_INCREMENT;
