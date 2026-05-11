-- Run this on the biotwinedsn database to enable editable product categories
-- 2026-05-11

CREATE TABLE `product_categories` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `slug` varchar(50) NOT NULL,
  `nav_label` varchar(100) NOT NULL DEFAULT '',
  `eyebrow` varchar(150) NOT NULL DEFAULT '',
  `heading` varchar(200) NOT NULL DEFAULT '',
  `description` text DEFAULT NULL,
  `section_alt` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `product_categories` (`slug`, `nav_label`, `eyebrow`, `heading`, `description`, `section_alt`, `is_active`, `sort_order`) VALUES
('hop',    'Hop Twine',       'Hop Industry',         'Hop Twine',             'Biodegradable twisted paper twine engineered for Pacific Northwest hop farms. Fully biodegradable at season end.',                                                          0, 1, 1),
('handle', 'Handle Bag Twine','Retail & Packaging',   'Handle Bag Twine',      'Consistent tensile strength and diameter for automated bag manufacturing lines. FSC certified options available for sustainability programs.',                               1, 1, 2),
('other',  'Arching & Other', 'Berry Orchards & More','Arching & Other Twine', 'Center-pull configurations for berry orchard applications and other agricultural uses.',                                                                                    0, 1, 3);

ALTER TABLE `product_categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
