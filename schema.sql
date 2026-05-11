-- ============================================================
-- BioTwine Manufacturing — Database Schema
-- Engine: MySQL 8.0 | Charset: utf8mb4
-- ============================================================

-- ── Users ────────────────────────────────────────────────────
CREATE TABLE `users` (
  `user_id`    INT(11)      NOT NULL AUTO_INCREMENT,
  `email`      VARCHAR(255) NOT NULL,
  `password`   VARCHAR(255) NOT NULL,
  `first_name` VARCHAR(100) NOT NULL DEFAULT '',
  `last_name`  VARCHAR(100) NOT NULL DEFAULT '',
  `role`       VARCHAR(50)  NOT NULL DEFAULT 'editor',
  `is_active`  TINYINT(1)   NOT NULL DEFAULT 1,
  `created_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Pages (CMS static pages) ─────────────────────────────────
CREATE TABLE `pages` (
  `page_id`      INT(11)      NOT NULL AUTO_INCREMENT,
  `slug`         VARCHAR(100) NOT NULL,
  `nav_title`    VARCHAR(150) NOT NULL DEFAULT '',
  `page_title`   VARCHAR(200) NOT NULL DEFAULT '',
  `hero_heading` VARCHAR(255) NOT NULL DEFAULT '',
  `hero_subhead` VARCHAR(500) NOT NULL DEFAULT '',
  `hero_image`   VARCHAR(255) NOT NULL DEFAULT '',
  `body_content` MEDIUMTEXT,
  `meta_title`   VARCHAR(200) NOT NULL DEFAULT '',
  `meta_desc`    VARCHAR(320) NOT NULL DEFAULT '',
  `is_active`    TINYINT(1)   NOT NULL DEFAULT 1,
  `sort_order`   INT(11)      NOT NULL DEFAULT 0,
  `created_at`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`page_id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Products ─────────────────────────────────────────────────
CREATE TABLE `products` (
  `product_id`   INT(11)      NOT NULL AUTO_INCREMENT,
  `category`     VARCHAR(100) NOT NULL DEFAULT 'hop',  -- hop | handle | other
  `name`         VARCHAR(200) NOT NULL DEFAULT '',
  `item_number`  VARCHAR(50)  NOT NULL DEFAULT '',
  `description`  TEXT,
  `specs`        TEXT,                                  -- JSON blob of spec rows
  `image`        VARCHAR(255) NOT NULL DEFAULT '',
  `badge`        VARCHAR(100) NOT NULL DEFAULT '',      -- e.g. "Most Popular", "FSC Certified"
  `is_active`    TINYINT(1)   NOT NULL DEFAULT 1,
  `is_featured`  TINYINT(1)   NOT NULL DEFAULT 0,
  `sort_order`   INT(11)      NOT NULL DEFAULT 0,
  `created_at`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── News / Announcements ──────────────────────────────────────
CREATE TABLE `news` (
  `news_id`    INT(11)      NOT NULL AUTO_INCREMENT,
  `title`      VARCHAR(255) NOT NULL DEFAULT '',
  `slug`       VARCHAR(200) NOT NULL DEFAULT '',
  `body`       MEDIUMTEXT,
  `excerpt`    TEXT,
  `image`      VARCHAR(255) NOT NULL DEFAULT '',
  `pub_date`   DATE         NOT NULL,
  `is_active`  TINYINT(1)   NOT NULL DEFAULT 1,
  `meta_title` VARCHAR(200) NOT NULL DEFAULT '',
  `meta_desc`  VARCHAR(320) NOT NULL DEFAULT '',
  `created_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`news_id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Testimonials ─────────────────────────────────────────────
CREATE TABLE `testimonials` (
  `testimonial_id` INT(11)      NOT NULL AUTO_INCREMENT,
  `quote`          TEXT         NOT NULL,
  `company`        VARCHAR(200) NOT NULL DEFAULT '',
  `location`       VARCHAR(200) NOT NULL DEFAULT '',
  `years_partner`  VARCHAR(50)  NOT NULL DEFAULT '',
  `is_active`      TINYINT(1)   NOT NULL DEFAULT 1,
  `sort_order`     INT(11)      NOT NULL DEFAULT 0,
  `created_at`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`testimonial_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Quote Requests (Contact form submissions) ─────────────────
CREATE TABLE `quote_requests` (
  `quote_id`    INT(11)      NOT NULL AUTO_INCREMENT,
  `first_name`  VARCHAR(100) NOT NULL DEFAULT '',
  `last_name`   VARCHAR(100) NOT NULL DEFAULT '',
  `company`     VARCHAR(200) NOT NULL DEFAULT '',
  `email`       VARCHAR(255) NOT NULL DEFAULT '',
  `phone`       VARCHAR(50)  NOT NULL DEFAULT '',
  `product_interest` VARCHAR(200) NOT NULL DEFAULT '',
  `message`     TEXT,
  `is_read`     TINYINT(1)   NOT NULL DEFAULT 0,
  `submitted_at` DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`quote_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Site Settings ─────────────────────────────────────────────
CREATE TABLE `settings` (
  `setting_id`    INT(11)      NOT NULL AUTO_INCREMENT,
  `setting_key`   VARCHAR(100) NOT NULL,
  `setting_value` TEXT         NOT NULL DEFAULT '',
  `updated_at`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`setting_id`),
  UNIQUE KEY `setting_key` (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Seed settings ─────────────────────────────────────────────
INSERT INTO `settings` (`setting_key`, `setting_value`) VALUES
  ('active_theme',       'biotwine'),
  ('site_name',          'BioTwine Manufacturing'),
  ('site_tagline',       'Twisted Paper Twine, Built for the Field.'),
  ('contact_email',      'info@biotwine.com'),
  ('phone',              '(509) 865-3340'),
  ('address_line1',      '210 South Division Street'),
  ('address_line2',      'P.O. Box 430'),
  ('address_city_state', 'Toppenish, WA 98948'),
  ('hours',              'Monday–Friday: 8:00am–5:00pm'),
  ('hero_heading',       'Twisted Paper Twine, Built for the Field.'),
  ('hero_subhead',       'Over 100 years of combined manufacturing experience. Biodegradable paper twine for the hop industry, berry orchards, and handle bag manufacturers — sourced from U.S. and Canadian materials.'),
  ('hero_image',         '/assets/uploads/hero/home-hero.jpg'),
  ('google_analytics',   '');

-- ── Seed initial admin user (password: changeme123 — update immediately) ──
-- bcrypt hash of "changeme123" for testing only
INSERT INTO `users` (`email`, `password`, `first_name`, `last_name`, `role`, `is_active`)
VALUES ('admin@biotwine.com', '$2a$12$placeholder_hash_change_me', 'Admin', 'User', 'admin', 1);

-- ── Seed sample products ──────────────────────────────────────
INSERT INTO `products` (`category`, `name`, `item_number`, `description`, `badge`, `is_active`, `is_featured`, `sort_order`)
VALUES
  ('hop', 'Regular Hop Twine', 'BT-100', 'Standard weight twisted paper twine for hop training. Compatible with most mechanical stringing equipment. Made from U.S. and Canadian kraft paper.', '', 1, 0, 1),
  ('hop', 'Heavy Hop Twine', 'BT-110', 'Heavier gauge twisted paper twine for high-yielding hop varieties that require extra support throughout the growing season.', '', 1, 0, 2),
  ('hop', 'MAX Hop Twine', 'BT-120', 'Our premium MAX formula twine is engineered for next-generation high-yield varieties. 2 pallets strings over 14.5 acres with no prep — put it on the tractor and go.', 'Most Popular', 1, 1, 3),
  ('hop', 'Hop Ties', 'BT-130', 'Biodegradable paper ties for securing hop bines to training twine at the base. Quick to apply, compostable at end of season.', '', 1, 0, 4),
  ('handle', 'Standard Handle Bag Twine', 'BT-200', 'Twisted paper twine for retail handle bag manufacturing. Consistent diameter and tensile strength for automated bag production lines.', '', 1, 0, 5),
  ('handle', 'FSC Certified Handle Bag Twine', 'BT-210', 'FSC Chain of Custody certified handle bag twine made from post-consumer recycled kraft. Available documentation for sustainability reporting.', 'FSC Certified', 1, 1, 6),
  ('other', 'Center Pull Arching Twine', 'BT-300', 'Center-pull configuration for berry orchard arching applications. Smooth feed for high-speed pneumatic tying equipment.', '', 1, 0, 7);

-- ── Seed sample news ──────────────────────────────────────────
INSERT INTO `news` (`title`, `slug`, `excerpt`, `body`, `pub_date`, `is_active`)
VALUES
  ('2026 Hop Season Product Availability', '2026-hop-season-availability',
   'All BioTwine hop twine products are in stock and ready for the 2026 growing season. Order early to guarantee availability.',
   '<p>All BioTwine hop twine products are in stock and ready for the 2026 growing season. We have increased inventory levels across all SKUs to meet growing demand from our Pacific Northwest hop farm partners.</p><p>Order early to guarantee availability and lock in current pricing. Contact our team at (509) 865-3340 or email info@BioTwine.com.</p>',
   '2026-02-01', 1),
  ('FSC Certified Handle Bag Twine Now Available', 'fsc-handle-bag-twine-available',
   'Our FSC Certified post-consumer recycled handle bag twine (Item ##1576) is now available for retailers and brands with sustainability requirements.',
   '<p>BioTwine Manufacturing is pleased to announce the availability of our new FSC Certified handle bag twine (Item ##1576). This product is manufactured from post-consumer recycled kraft paper and carries full FSC Chain of Custody documentation.</p><p>It is ideal for retailers and consumer brands with sustainability commitments or ESG reporting requirements. Contact us for samples and pricing.</p>',
   '2026-01-15', 1);

-- ── Seed sample testimonial ───────────────────────────────────
INSERT INTO `testimonials` (`quote`, `company`, `location`, `years_partner`, `is_active`, `sort_order`)
VALUES
  ("BioTwine''s MAX Paper Twine has proven to perform exceptionally well, especially with the new high-yielding varieties we grow. 2 pallets of this twine will string over 14.5 acres with no prep. Put the twine on the tractor and go.",
   'Perrault Farms', 'Yakima Valley, WA', '35 years', 1, 1);
