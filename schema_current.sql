-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 62.3.5.4
-- Generation Time: May 11, 2026 at 08:31 PM
-- Server version: 10.6.24-MariaDB
-- PHP Version: 8.2.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `biotwinedsn`
--

-- --------------------------------------------------------

--
-- Table structure for table `news`
--

CREATE TABLE `news` (
  `news_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL DEFAULT '',
  `slug` varchar(200) NOT NULL DEFAULT '',
  `body` mediumtext DEFAULT NULL,
  `excerpt` text DEFAULT NULL,
  `image` varchar(255) NOT NULL DEFAULT '',
  `pub_date` date NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `meta_title` varchar(200) NOT NULL DEFAULT '',
  `meta_desc` varchar(320) NOT NULL DEFAULT '',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `news`
--

INSERT INTO `news` (`news_id`, `title`, `slug`, `body`, `excerpt`, `image`, `pub_date`, `is_active`, `meta_title`, `meta_desc`, `created_at`, `updated_at`) VALUES
(1, '2026 Hop Season Product Availability', '2026-hop-season-availability', '<p>All BioTwine hop twine products are in stock and ready for the 2026 growing season. We have increased inventory levels across all SKUs to meet growing demand from our Pacific Northwest hop farm partners.</p><p>Order early to guarantee availability and lock in current pricing. Contact our team at (509) 865-3340 or email info@BioTwine.com.</p>', 'All BioTwine hop twine products are in stock and ready for the 2026 growing season. Order early to guarantee availability.', '', '2026-02-01', 1, '', '', '2026-03-12 11:47:28', '2026-03-12 11:47:28'),
(2, 'FSC Certified Handle Bag Twine Now Available', 'fsc-handle-bag-twine-available', '<p>BioTwine Manufacturing is pleased to announce the availability of our new FSC Certified handle bag twine (Item ##1576). This product is manufactured from post-consumer recycled kraft paper and carries full FSC Chain of Custody documentation.</p><p>It is ideal for retailers and consumer brands with sustainability commitments or ESG reporting requirements. Contact us for samples and pricing.</p>', 'Our FSC Certified post-consumer recycled handle bag twine (Item ##1576) is now available for retailers and brands with sustainability requirements.', '', '2026-01-15', 1, '', '', '2026-03-12 11:47:28', '2026-03-12 11:47:28'),
(3, 'FSC Certified Handle Bag Twine Now Available', 'news-test', '<p>BioTwine Manufacturing is pleased to announce the availability of our new FSC Certified handle bag twine (Item ##1576). This product is manufactured from post-consumer recycled kraft paper and carries full FSC Chain of Custody documentation.</p><p>It is ideal for retailers and consumer brands with sustainability commitments or ESG reporting requirements. Contact us for samples and pricing.</p>', 'Our FSC Certified post-consumer recycled handle bag twine (Item ##1576) is now available for retailers and brands with sustainability requirements.', '', '2026-01-15', 1, '', '', '2026-03-12 11:47:28', '2026-03-12 11:47:28');

-- --------------------------------------------------------

--
-- Table structure for table `pages`
--

CREATE TABLE `pages` (
  `page_id` int(11) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `nav_title` varchar(150) NOT NULL DEFAULT '',
  `page_title` varchar(200) NOT NULL DEFAULT '',
  `hero_heading` varchar(255) NOT NULL DEFAULT '',
  `hero_subhead` varchar(500) NOT NULL DEFAULT '',
  `hero_image` varchar(255) NOT NULL DEFAULT '',
  `body_content` mediumtext DEFAULT NULL,
  `meta_title` varchar(200) NOT NULL DEFAULT '',
  `meta_desc` varchar(320) NOT NULL DEFAULT '',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `has_dropdown` tinyint(1) NOT NULL DEFAULT 0,
  `layout_type` varchar(20) NOT NULL DEFAULT 'generic',
  `show_hero` tinyint(1) NOT NULL DEFAULT 0,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pages`
--

INSERT INTO `pages` (`page_id`, `slug`, `nav_title`, `page_title`, `hero_heading`, `hero_subhead`, `hero_image`, `body_content`, `meta_title`, `meta_desc`, `is_active`, `has_dropdown`, `layout_type`, `show_hero`, `sort_order`, `created_at`, `updated_at`) VALUES
(5, 'about', 'About BioTwine', 'About', 'About', '', '', '<section class=\"page-hero\">\n  <div class=\"container\">\n    <div class=\"eyebrow\">Our Story</div>\n    <h1>About BioTwine Manufacturing</h1>\n    <p>Toppenish, Washington • Since 1994</p>\n  </div>\n</section>\n\n<!--- Who We Are --->\n<section class=\"section\">\n  <div class=\"container\">\n    <div class=\"about-split\" data-fade=\"\">\n      <div>\n        <div class=\"about-image-wrap\">\n          <img src=\"/assets/uploads/img/pic1.png\" alt=\"BioTwine Manufacturing\" loading=\"lazy\">\n          <div class=\"about-cert-badge\">\n            <span class=\"badge-big\">FSC</span>\n            <span class=\"badge-small\">Certified</span>\n          </div>\n        </div>\n      </div>\n      <div>\n        <div class=\"section-eyebrow\">Who We Are</div>\n        <h2 class=\"section-title\">A Legacy Built on <em>Quality &amp; Sustainability</em></h2>\n\n<div class=\"row mt-0\">\n<div class=\"col-md-12\">\n     \n        <img src=\"/assets/uploads/img/streng2.png\" class=\"img-fluid\" alt=\"twine\">\n   \n    </div>\n</div>\n\n        <p style=\"font-size:var(--font-size-lg); color:var(--text-muted); line-height:var(--line-height-loose); margin-bottom:1.25rem;\">\n          BioTwine Manufacturing! has been supplying the Pacific Northwest hop industry, berry orchards, and handle bag manufacturers with premium biodegradable <b><i>twisted</i></b> paper twine since 1994<i><u>...</u></i></p>\n        <p style=\"color:var(--text-muted); margin-bottom:1.25rem;\">\n          With over 100 years of combined manufacturing experience, our team brings deep expertise to every spool we produce. We manufacture all of our twine from U.S. and Canadian kraft paper” materials we trust for consistent performance and responsible sourcing.\n        </p>\n        <p style=\"color:var(--text-muted);\">\n          We are proud to be FSC Chain of Custody certified, providing our customers with full traceability documentation for their sustainability programs.\n        </p>\n      </div>\n    </div>\n  </div>\n</section>\n\n<!--- Values strip --->\n<section class=\"section section-alt\">\n  <div class=\"container\">\n    <div class=\"section-header text-center\" data-fade=\"\">\n      <div class=\"section-eyebrow\">Our Commitments</div>\n      <h2 class=\"section-title\">What We Stand For</h2>\n    </div>\n    <div style=\"display:grid; grid-template-columns:repeat(auto-fill,minmax(260px,1fr)); gap:1.5rem;\">\n      <div class=\"admin-card\" style=\"padding:1.75rem;\" data-fade=\"\" data-fade-delay=\"0\">\n        <div style=\"font-size:2rem; margin-bottom:1rem;\"><br></div>\n        <h3 style=\"font-size:var(--font-size-xl); margin-bottom:0.75rem;\">FSC Certified</h3>\n        <p style=\"color:var(--text-muted); font-size:var(--font-size-sm); line-height:var(--line-height-loose);\">Our FSC Chain of Custody certification means every spool is traceable from forest to field â€” ideal for customers with sustainability commitments and ESG reporting requirements.</p>\n      </div>\n      <div class=\"admin-card\" style=\"padding:1.75rem;\" data-fade=\"\" data-fade-delay=\"100\">\n        <div style=\"font-size:2rem; margin-bottom:1rem;\"></div>\n        <h3 style=\"font-size:var(--font-size-xl); margin-bottom:0.75rem;\">100% Biodegradable</h3>\n        <p style=\"color:var(--text-muted); font-size:var(--font-size-sm); line-height:var(--line-height-loose);\">All BioTwine products are manufactured from kraft paper. They decompose naturally at season end â€” no microplastics, no cleanup, no landfill. Good for the crop and good for the land.</p>\n      </div>\n      <div class=\"admin-card\" style=\"padding:1.75rem;\" data-fade=\"\" data-fade-delay=\"200\">\n        <div style=\"font-size:2rem; margin-bottom:1rem;\"><br></div>\n        <h3 style=\"font-size:var(--font-size-xl); margin-bottom:0.75rem;\">Made in the USA</h3>\n        <p style=\"color:var(--text-muted); font-size:var(--font-size-sm); line-height:var(--line-height-loose);\">Manufactured in Toppenish, Washington, using U.S. and Canadian kraft paper. We\'re proud to support domestic manufacturing and keep supply chains short and reliable.</p>\n      </div>\n      <div class=\"admin-card\" style=\"padding:1.75rem;\" data-fade=\"\" data-fade-delay=\"300\">\n        <div style=\"font-size:2rem; margin-bottom:1rem;\"></div>\n        <h3 style=\"font-size:var(--font-size-xl); margin-bottom:0.75rem;\">Long-Term Partnerships</h3>\n        <p style=\"color:var(--text-muted); font-size:var(--font-size-sm); line-height:var(--line-height-loose);\">We\'ve partnered with Perrault Farms for 35 years. Long relationships built on performance and trust are how we do business. We\'re not a transactional supplier â€” we\'re part of the season.</p>\n      </div>\n    </div>\n  </div>\n</section>\n\n<!--- CTA --->\n<section class=\"section section-dark text-center\">\n  <div class=\"container-narrow\" data-fade=\"\">\n    <div class=\"section-eyebrow\" style=\"color:var(--color-meadow);\">Work With Us</div>\n    <h2 class=\"section-title\" style=\"color:##FFFFFF;\">Ready to Start a Conversation?</h2>\n    <p class=\"section-lead\" style=\"color:rgba(255,255,255,0.7); margin:0 auto 2rem;\">Call us at (509) 865-3340 or submit a quote request online. We\'ll get back to you within 1â€“2 business days.</p>\n    <div class=\"hero-actions\" style=\"justify-content:center;\">\n      <a href=\"/contact.cfm\" class=\"btn btn-secondary btn-lg\">Request a Quote</a>\n      <a href=\"/products.cfm\" class=\"btn btn-outline-light btn-lg\">View Products</a>\n    </div>\n  </div>\n</section>', 'about bio', 'about', 1, 0, 'custom', 0, 4, '2026-03-12 16:11:17', '2026-03-19 11:40:52'),
(6, 'home', 'Home', 'home', '', '', '', '<section class=\"hero\">\n\n  <div class=\"hero-bg\" style=\"background-image: url(\'/assets/uploads/hero/home-hero.png\');\"></div>\n  <div class=\"hero-content\">\n    <div class=\"hero-eyebrow\">Toppenish, Washington • Since 1994</div>\n    <h1>Twisted Paper Twine, Built for the Field.</h1>\n\n    <p class=\"hero-subtitle\">Over 100 years of combined manufacturing experience. Biodegradable paper twine for hop farms, berry orchards, and handle bag manufacturers.</p>\n    <div class=\"hero-actions\">\n      <a href=\"/products.cfm\" class=\"btn btn-secondary btn-lg\">View All Products</a>\n      <a href=\"/contact.cfm\" class=\"btn btn-outline-light btn-lg\">Request a Quote</a>\n    </div>\n  </div>\n  <div class=\"hero-badge\">\n    <strong style=\"font-size:1.1rem; display:block; font-family:var(--font-display);\">FSC</strong>\n    <span style=\"font-size:0.65rem; letter-spacing:0.1em; text-transform:uppercase; opacity:0.75;\">Certified</span>\n  </div>\n</section>\n\n<div class=\"stats-strip\">\n  <div class=\"container\">\n    <div class=\"stat-item\" data-fade=\"\" data-fade-delay=\"0\">\n      <span class=\"stat-number\">100+</span>\n      <span class=\"stat-label\">Years Combined Experience</span>\n    </div>\n    <div class=\"stat-item\" data-fade=\"\" data-fade-delay=\"80\">\n      <span class=\"stat-number\">35yr</span>\n      <span class=\"stat-label\">Perrault Farms Partnership</span>\n    </div>\n    <div class=\"stat-item\" data-fade=\"\" data-fade-delay=\"160\">\n      <span class=\"stat-number\">FSC</span>\n      <span class=\"stat-label\">Certified Sustainable Sourcing</span>\n    </div>\n    <div class=\"stat-item\" data-fade=\"\" data-fade-delay=\"240\">\n      <span class=\"stat-number\">100%</span>\n      <span class=\"stat-label\">Biodegradable U.S. &amp; Canadian Kraft</span>\n    </div>\n\n\n  </div>\n</div>\n\n<section class=\"section\">\n  <div class=\"container\">\n    <div class=\"about-split\">\n      <div data-fade=\"\">\n<div class=\"about-image-wrap\" style=\"bgcolor:#000000;\">\n<div style=\"padding:56.25% 0 0 0;position:relative;\"><iframe src=\"https://player.vimeo.com/video/1176801149?h=221314d00f&amp;badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479\" frameborder=\"0\" allow=\"autoplay; fullscreen; picture-in-picture; clipboard-write; encrypted-media; web-share\" referrerpolicy=\"strict-origin-when-cross-origin\" style=\"position:absolute;top:0;left:0;width:100%;height:100%;\" title=\"BioTwine Sizzle Reel\"></iframe></div>\n</div>\n     <!---   <div class=\"about-image-wrap\">\n          <img src=\"/assets/uploads/img/pic5.jpg\" alt=\"BioTwine Manufacturing facility\" loading=\"lazy\">\n          <div class=\"about-cert-badge\">\n            <span class=\"badge-big\">FSC</span>\n            <span class=\"badge-small\">Certified</span>\n          </div>\n        </div> --->\n      </div>\n      <div data-fade=\"\" data-fade-delay=\"120\">\n        <div class=\"section-eyebrow\">Who We Are</div>\n        <h2 class=\"section-title\">A Leading Manufacturer of <em>Twisted Paper Twine</em></h2>\n<div class=\"row mt-0\">\n<div class=\"col-md-12\">\n     \n        <img src=\"/assets/uploads/img/streng2.png\" class=\"img-fluid\" alt=\"twine\">\n   \n    </div>\n</div>\n        <p class=\"Textbody\" style=\"margin: 0in; font-size: 12pt; font-family: &quot;Times New Roman&quot;, serif; color: rgb(0, 0, 0); background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;\"><span style=\"font-family: &quot;DM Sans&quot;;\">BioTwine Manufacturing has been supplying the hop industry, berry orchards, and handle bag manufacturers with premium biodegradable twisted paper twine since 1994.</span></p><p class=\"Textbody\" style=\"margin: 0in; font-size: 12pt; font-family: &quot;Times New Roman&quot;, serif; color: rgb(0, 0, 0); background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;\"><span style=\"font-family: &quot;DM Sans&quot;;\"><br></span><span style=\"font-family: &quot;DM Sans&quot;; font-size: 12pt;\">All of our twine is manufactured from U.S. and Canadian kraft paper. We are committed to environmentally responsible, biodegradable products that support sustainable agriculture </span><b style=\"font-family: &quot;DM Sans&quot;; font-size: 12pt;\">and Handle Bag manufacturing.</b></p><p class=\"Textbody\" style=\"margin: 0in; font-size: 12pt; font-family: &quot;Times New Roman&quot;, serif; color: rgb(0, 0, 0); background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;\"><b style=\"font-family: &quot;DM Sans&quot;; font-size: 12pt;\"><br></b></p>\n        <div style=\"display:flex; gap:1rem; flex-wrap:wrap;\">\n          <a href=\"/about.cfm\" class=\"btn btn-outline\">Our Story</a>\n          <a href=\"/products.cfm\" class=\"btn btn-primary\">View Products</a>\n        </div>\n      </div>\n    </div>\n  </div>\n</section>\n<section>\n  <div class=\"row\">\n\n    <div class=\"col-md-3 col-6 mb-4\">\n      <div class=\"image-card\">\n        <img src=\"/assets/uploads/img/pic1.jpg\" class=\"img-fluid\" alt=\"Manufacturing\">\n      </div>\n    </div>\n\n    <div class=\"col-md-3 col-6 mb-4\">\n      <div class=\"image-card\">\n         <img src=\"/assets/uploads/img/pic2.jpg\" class=\"img-fluid\" alt=\"Manufacturing\">\n      </div>\n    </div>\n\n    <div class=\"col-md-3 col-6 mb-4\">\n      <div class=\"image-card\">\n        <img src=\"/assets/uploads/img/pic3.jpg\" class=\"img-fluid\" alt=\"Manufacturing\">\n      </div>\n    </div>\n\n    <div class=\"col-md-3 col-6 mb-4\">\n      <div class=\"image-card\">\n        <img src=\"/assets/uploads/img/pic4.jpg\" class=\"img-fluid\" alt=\"Manufacturing\">\n      </div>\n    </div>\n\n  </div>\n</section>\n\n<section class=\"section section-dark text-center\">\n  <div class=\"container-narrow\" data-fade=\"\">\n    <div class=\"section-eyebrow\" style=\"color:var(--color-meadow);\">Get in Touch</div>\n    <h2 class=\"section-title\" style=\"color:#FFFFFF; margin-bottom:1rem;\">Ready to Order or Need a Custom Quote?</h2>\n    <p class=\"section-lead\" style=\"color:rgba(255,255,255,0.7); margin: 0 auto 2rem;\">\n      Our team is available Monday–Friday, 8am–5pm. Call us at (509) 865-3340 or submit a quote request online.\n    </p>\n    <div class=\"hero-actions\" style=\"justify-content:center;\">\n      <a href=\"/contact.cfm\" class=\"btn btn-secondary btn-lg\">Request a Quote</a>\n      <a href=\"tel:5098653340\" class=\"btn btn-outline-light btn-lg\"><i class=\"bi bi-telephone me-1\"></i>(509) 865-3340</a>\n    </div>\n  </div>\n</section>', 'BioTwine', 'BioTwine', 1, 0, 'custom', 0, 5, '2026-03-12 16:17:38', '2026-05-11 15:51:11'),
(7, 'products', 'Products', 'Products', '', '', '', '<section class=\"page-hero\">\n  <div class=\"container\">\n    <div class=\"eyebrow\">BioTwine Manufacturing</div>\n    <h1>Our Products</h1>\n    <p>Premium biodegradable twisted paper twine &amp; engineered for the field.</p>\n  </div>\n</section>\n\n<!--- PRODUCT CATEGORY ANCHOR NAV  --->\n<div style=\"background:var(--bg-card); border-bottom:1px solid var(--border-color); position:sticky; top:var(--nav-height); z-index:50;\">\n  <div class=\"container\" style=\"display:flex; gap:0;\">\n    <a href=\"#hop\" style=\"padding: 1rem 1.5rem; font-size: var(--font-size-sm); font-weight: 600; color: var(--text-body); border-bottom: 2px solid transparent; text-decoration: none; transition: color 150ms, border-color 150ms;\" onmouseover=\"this.style.borderBottomColor=\'var(--color-forest)\'\" onmouseout=\"this.style.borderBottomColor=\'transparent\'\">Hop Twine</a>\n    <a href=\"#handle\" style=\"padding: 1rem 1.5rem; font-size: var(--font-size-sm); font-weight: 600; color: var(--text-body); border-bottom: 2px solid transparent; text-decoration: none; transition: color 150ms, border-color 150ms;\" onmouseover=\"this.style.borderBottomColor=\'var(--color-forest)\'\" onmouseout=\"this.style.borderBottomColor=\'transparent\'\">Handle Bag Twine</a>\n    <a href=\"#other\" style=\"padding: 1rem 1.5rem; font-size: var(--font-size-sm); font-weight: 600; color: var(--text-body); border-bottom: 2px solid transparent; text-decoration: none; transition: color 150ms, border-color 150ms;\" onmouseover=\"this.style.borderBottomColor=\'var(--color-forest)\'\" onmouseout=\"this.style.borderBottomColor=\'transparent\'\">Arching &amp; Other</a>\n  </div>\n</div>\n\n<!--- HOP TWINE SECTION --->\n<cfif hopproducts.recordcount=\"\" gt=\"\" 0=\"\">\n<section class=\"section\" id=\"hop\">\n  <div class=\"container\">\n    <div class=\"section-header\" data-fade=\"\">\n      <div class=\"section-eyebrow\">Hop Industry</div>\n      <h2 class=\"section-title\">Hop Twine</h2>\n      <p class=\"section-lead\">Biodegradable twisted paper twine engineered for Pacific Northwest hop farms. Fully biodegradable at season end.</p>\n    </div>\n    <div class=\"product-grid\">\n      <cfloop query=\"hopProducts\">\n      <div class=\"product-card\" data-fade=\"\" data-fade-delay=\"#(currentRow * 80)#\">\n        <div class=\"product-card-img\" style=\"background:var(--bg-card-alt); display:flex; align-items:center; justify-content:center; height:180px;\">\n          <cfif len(trim(image))=\"\">\n            <img src=\"/assets/uploads/products/#htmlEditFormat(image)#\" alt=\"#htmlEditFormat(name)#\" style=\"width:100%;height:180px;object-fit:cover;\">\n          <cfelse>\n            <span style=\"font-size:3rem;\">ðŸŒ¿</span>\n          </cfelse></cfif>\n        </div>\n        <div class=\"product-card-body\">\n          <cfif len(trim(badge))=\"\">\n            <span class=\"product-badge badge-kraft\">#htmlEditFormat(badge)#</span>\n          </cfif>\n          <h3>#htmlEditFormat(name)#</h3>\n          <cfif len(trim(item_number))=\"\">\n            <p style=\"font-size:0.75rem; color:var(--text-muted); font-family:var(--font-mono); margin-bottom:0.5rem;\">Item ##: #htmlEditFormat(item_number)#</p>\n          </cfif>\n          <p>#htmlEditFormat(description)#</p>\n          <a href=\"/contact.cfm?product=#urlEncodedFormat(name)#\" class=\"btn btn-primary\">Request Quote</a>\n        </div>\n      </div>\n      </cfloop>\n    </div>\n  </div>\n</section>\n</cfif>\n\n<!--- HANDLE BAG SECTION --->\n<cfif handleproducts.recordcount=\"\" gt=\"\" 0=\"\">\n<section class=\"section section-alt\" id=\"handle\">\n  <div class=\"container\">\n    <div class=\"section-header\" data-fade=\"\">\n      <div class=\"section-eyebrow\">Retail &amp; Packaging</div>\n      <h2 class=\"section-title\">Handle Bag Twine</h2>\n      <p class=\"section-lead\">Consistent tensile strength and diameter for automated bag manufacturing lines. FSC certified options available for sustainability programs.</p>\n    </div>\n    <div class=\"product-grid\">\n      <cfloop query=\"handleProducts\">\n      <div class=\"product-card\" data-fade=\"\" data-fade-delay=\"#(currentRow * 80)#\">\n        <div class=\"product-card-img\" style=\"background:var(--bg-card-alt); display:flex; align-items:center; justify-content:center; height:180px;\">\n          <cfif len(trim(image))=\"\">\n            <img src=\"/assets/uploads/products/#htmlEditFormat(image)#\" alt=\"#htmlEditFormat(name)#\" style=\"width:100%;height:180px;object-fit:cover;\">\n          <cfelse>\n            <span style=\"font-size:3rem;\">ðŸ§µ</span>\n          </cfelse></cfif>\n        </div>\n        <div class=\"product-card-body\">\n          <cfif len(trim(badge))=\"\">\n            <span class=\"product-badge badge-fsc\">#htmlEditFormat(badge)#</span>\n          </cfif>\n          <h3>#htmlEditFormat(name)#</h3>\n          <cfif len(trim(item_number))=\"\">\n            <p style=\"font-size:0.75rem; color:var(--text-muted); font-family:var(--font-mono); margin-bottom:0.5rem;\">Item ##: #htmlEditFormat(item_number)#</p>\n          </cfif>\n          <p>#htmlEditFormat(description)#</p>\n          <a href=\"/contact.cfm?product=#urlEncodedFormat(name)#\" class=\"btn btn-primary\">Request Quote</a>\n        </div>\n      </div>\n      </cfloop>\n    </div>\n  </div>\n</section>\n</cfif>\n\n<!--- THER SECTION --->\n<cfif otherproducts.recordcount=\"\" gt=\"\" 0=\"\">\n<section class=\"section\" id=\"other\">\n  <div class=\"container\">\n    <div class=\"section-header\" data-fade=\"\">\n      <div class=\"section-eyebrow\">Berry Orchards &amp; More</div>\n      <h2 class=\"section-title\">Arching &amp; Other Twine</h2>\n      <p class=\"section-lead\">Center-pull configurations for berry orchard applications and other agricultural uses.</p>\n    </div>\n    <div class=\"product-grid\">\n      <cfloop query=\"otherProducts\">\n      <div class=\"product-card\" data-fade=\"\" data-fade-delay=\"#(currentRow * 80)#\">\n        <div class=\"product-card-img\" style=\"background:var(--bg-card-alt); display:flex; align-items:center; justify-content:center; height:180px;\">\n          <span style=\"font-size:3rem;\">ðŸŒ¾</span>\n        </div>\n        <div class=\"product-card-body\">\n          <cfif len(trim(badge))=\"\">\n            <span class=\"product-badge\">#htmlEditFormat(badge)#</span>\n          </cfif>\n          <h3>#htmlEditFormat(name)#</h3>\n          <cfif len(trim(item_number))=\"\">\n            <p style=\"font-size:0.75rem; color:var(--text-muted); font-family:var(--font-mono); margin-bottom:0.5rem;\">Item ##: #htmlEditFormat(item_number)#</p>\n          </cfif>\n          <p>#htmlEditFormat(description)#</p>\n          <a href=\"/contact.cfm?product=#urlEncodedFormat(name)#\" class=\"btn btn-primary\">Request Quote</a>\n        </div>\n      </div>\n      </cfloop>\n    </div>\n  </div>\n</section>\n</cfif>\n\n<!--- CTA --->\n<section class=\"section section-dark text-center\">\n  <div class=\"container-narrow\" data-fade=\"\">\n    <div class=\"section-eyebrow\" style=\"color:var(--color-meadow);\">Let\'s Talk</div>\n    <h2 class=\"section-title\" style=\"color:##FFFFFF;\">Need a Custom Specification or Volume Pricing?</h2>\n    <p class=\"section-lead\" style=\"color:rgba(255,255,255,0.7); margin:0 auto 2rem;\">Our team can work with you on custom twine specifications, volume pricing, and delivery logistics.</p>\n    <a href=\"/contact.cfm\" class=\"btn btn-secondary btn-lg\">Contact Us Today</a>\n  </div>\n</section>', 'Twin Products', 'BioTwine products', 1, 0, 'custom', 0, 0, '2026-03-17 12:49:55', '2026-05-11 16:27:25');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `category` varchar(100) NOT NULL DEFAULT 'hop',
  `name` varchar(200) NOT NULL DEFAULT '',
  `item_number` varchar(50) NOT NULL DEFAULT '',
  `description` text DEFAULT NULL,
  `specs` text DEFAULT NULL,
  `image` varchar(255) NOT NULL DEFAULT '',
  `badge` varchar(100) NOT NULL DEFAULT '',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `category`, `name`, `item_number`, `description`, `specs`, `image`, `badge`, `is_active`, `is_featured`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, 'hop', 'Regular Hop Twine', '1500', 'Standard weight twisted paper twine for hop training. Compatible with most mechanical stringing equipment. Made from U.S. and Canadian kraft paper.', NULL, 'hopTwineProducts.jpg', '', 1, 0, 1, '2026-03-12 11:47:28', '2026-03-17 13:14:23'),
(2, 'hop', 'Heavy Hop Twine', '1500.1', 'Heavier gauge twisted paper twine for high-yielding hop varieties that require extra support throughout the growing season.', NULL, 'hopTwineProducts.jpg', '', 1, 0, 2, '2026-03-12 11:47:28', '2026-03-17 13:14:43'),
(3, 'hop', 'MAX Hop Twine', '1551', 'Our premium MAX formula twine is engineered for next-generation high-yield varieties. 2 pallets strings over 14.5 acres with no prep — put it on the tractor and go.', NULL, 'hopTwineProducts.jpg', 'Most Popular', 1, 1, 3, '2026-03-12 11:47:28', '2026-03-17 13:14:49'),
(4, 'hop', 'Berry Ties', '1560', 'Biodegradable paper ties for securing hop bines to training twine at the base. Quick to apply, compostable at end of season.', NULL, 'hopTwineProducts.jpg', '', 1, 0, 4, '2026-03-12 11:47:28', '2026-03-30 22:42:44'),
(5, 'handle', 'Virgin Kraft Handle Twine', '1575', 'Twisted paper twine for retail handle bag manufacturing. Consistent diameter and tensile strength for automated bag production lines.', NULL, 'twineHandle.jpg', '', 1, 0, 5, '2026-03-12 11:47:28', '2026-03-17 13:17:27'),
(6, 'handle', 'FSC Certified Handle Bag Twine', '1576', 'FSC Chain of Custody certified handle bag twine made from post-consumer recycled kraft. Available documentation for sustainability reporting.', NULL, 'twineHandle.jpg', 'FSC Certified', 1, 1, 6, '2026-03-12 11:47:28', '2026-03-17 13:16:36'),
(7, 'hop', 'Center Pull Arching Twine', '1570', 'Center-pull configuration for berry orchard arching applications. Smooth feed for high-speed pneumatic tying equipment.', NULL, 'hopTwineProducts.jpg', '', 1, 0, 7, '2026-03-12 11:47:28', '2026-03-17 13:16:10'),
(8, 'handle', 'Bleached White Handle Twine', '1580', 'Twisted paper twine for retail handle bag manufacturing. Consistent diameter and tensile strength for automated bag production lines.', NULL, 'twineHandle.jpg', '', 1, 0, 5, '2026-03-12 11:47:28', '2026-03-17 13:18:04'),
(10, 'hop', 'Hop Ties', '1555', '22 inches long, 8,000 strings per box, 100 pound breaking strength', NULL, 'hopTwineProducts.jpg', '', 1, 0, 4, '2026-03-12 11:47:28', '2026-03-30 22:44:45'),
(11, 'hop', 'Center Pull HOR', '1565', 'Breaking strength 100 pounds, 10 pounds per ball, 170 feet per pound', NULL, 'hopTwineProducts.jpg', '', 1, 0, 4, '2026-03-12 11:47:28', '2026-03-30 22:47:23');

-- --------------------------------------------------------

--
-- Table structure for table `quote_requests`
--

CREATE TABLE `quote_requests` (
  `quote_id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL DEFAULT '',
  `last_name` varchar(100) NOT NULL DEFAULT '',
  `company` varchar(200) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '',
  `phone` varchar(50) NOT NULL DEFAULT '',
  `product_interest` varchar(200) NOT NULL DEFAULT '',
  `message` text DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `submitted_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `setting_id` int(11) NOT NULL,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text NOT NULL DEFAULT '',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`setting_id`, `setting_key`, `setting_value`, `updated_at`) VALUES
(1, 'active_theme', 'biotwine', '2026-03-12 11:47:28'),
(2, 'site_name', 'BioTwine Manufacturing', '2026-03-12 11:47:28'),
(3, 'site_tagline', 'Twisted Paper Twine, Built for the Field.', '2026-03-12 11:47:28'),
(4, 'contact_email', 'info@biotwine.com', '2026-03-12 11:47:28'),
(5, 'phone', '(509) 865-3340', '2026-03-12 11:47:28'),
(6, 'address_line1', '210 South Division Street', '2026-03-12 11:47:28'),
(7, 'address_line2', 'P.O. Box 430', '2026-03-12 11:47:28'),
(8, 'address_city_state', 'Toppenish, WA 98948', '2026-03-12 11:47:28'),
(9, 'hours', 'Monday–Friday: 8:00am–5:00pm', '2026-03-12 11:47:28'),
(10, 'hero_heading', 'Twisted Paper Twine, Built for the Field.', '2026-03-12 11:47:28'),
(11, 'hero_subhead', 'Over 100 years of combined manufacturing experience. Biodegradable paper twine for the hop industry, berry orchards, and handle bag manufacturers — sourced from U.S. and Canadian materials.', '2026-03-12 11:47:28'),
(12, 'hero_image', '/assets/uploads/hero/home-hero.jpg', '2026-03-12 11:47:28'),
(13, 'google_analytics', '', '2026-03-12 11:47:28'),
(14, 'nav_cta_label', 'Request a Quote', '2026-03-12 15:16:43'),
(15, 'nav_cta_url', '/contact.cfm', '2026-03-12 15:16:43'),
(16, 'home_slug', 'home', '2026-03-12 16:21:51');

-- --------------------------------------------------------

--
-- Table structure for table `testimonials`
--

CREATE TABLE `testimonials` (
  `testimonial_id` int(11) NOT NULL,
  `quote` text NOT NULL,
  `company` varchar(200) NOT NULL DEFAULT '',
  `location` varchar(200) NOT NULL DEFAULT '',
  `years_partner` varchar(50) NOT NULL DEFAULT '',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `testimonials`
--

INSERT INTO `testimonials` (`testimonial_id`, `quote`, `company`, `location`, `years_partner`, `is_active`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, 'BioTwine\'\'s MAX Paper Twine has proven to perform exceptionally well, especially with the new high-yielding varieties we grow. 2 pallets of this twine will string over 14.5 acres with no prep. Put the twine on the tractor and go.<p align=\"center\"><img src=\"/assets/uploads/testimonials/perraultfarms.png\" ></p>', 'Perrault Farms', 'Yakima Valley, WA', '35 years', 1, 1, '2026-03-12 11:47:28', '2026-03-17 13:24:32');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `first_name` varchar(100) NOT NULL DEFAULT '',
  `last_name` varchar(100) NOT NULL DEFAULT '',
  `role` varchar(50) NOT NULL DEFAULT 'editor',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `email`, `password`, `first_name`, `last_name`, `role`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'admin@biotwine.com', 'a0561fd649cdb6baa784055f051bad796ea0afef17fca38219549deeba4e8c1a', 'Admin', 'User', 'admin', 1, '2026-03-12 11:47:28', '2026-03-12 14:50:15');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`news_id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `pages`
--
ALTER TABLE `pages`
  ADD PRIMARY KEY (`page_id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `quote_requests`
--
ALTER TABLE `quote_requests`
  ADD PRIMARY KEY (`quote_id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`setting_id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`);

--
-- Indexes for table `testimonials`
--
ALTER TABLE `testimonials`
  ADD PRIMARY KEY (`testimonial_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `news`
--
ALTER TABLE `news`
  MODIFY `news_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `pages`
--
ALTER TABLE `pages`
  MODIFY `page_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `quote_requests`
--
ALTER TABLE `quote_requests`
  MODIFY `quote_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `setting_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `testimonials`
--
ALTER TABLE `testimonials`
  MODIFY `testimonial_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
