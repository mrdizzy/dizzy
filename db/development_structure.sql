CREATE TABLE `binaries` (
  `id` int(11) NOT NULL auto_increment,
  `binary_data` mediumblob,
  `type` varchar(255) default NULL,
  `content_type` varchar(255) default NULL,
  `size` int(11) default NULL,
  `filename` varchar(255) default NULL,
  `content_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `fk_content_binaries` (`content_id`),
  CONSTRAINT `fk_content_binaries` FOREIGN KEY (`content_id`) REFERENCES `___temp_dreamhost_restore_20090126_035259`.`contents` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `categories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `permalink` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `categories_contents` (
  `category_id` int(11) NOT NULL default '0',
  `content_id` int(11) NOT NULL default '0',
  KEY `fk_content_categories_contents` (`content_id`),
  KEY `fk_category_categories_contents` (`category_id`),
  CONSTRAINT `fk_category_categories_contents` FOREIGN KEY (`category_id`) REFERENCES `___temp_dreamhost_restore_20090126_035259`.`categories` (`id`),
  CONSTRAINT `fk_content_categories_contents` FOREIGN KEY (`content_id`) REFERENCES `___temp_dreamhost_restore_20090126_035259`.`contents` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL auto_increment,
  `body` text,
  `subject` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `parent_id` int(11) default NULL,
  `content_id` int(11) NOT NULL default '0',
  `created_at` datetime default NULL,
  `new` tinyint(1) default '1',
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_content_comments` (`content_id`),
  KEY `fk_comment_comments` (`parent_id`),
  CONSTRAINT `fk_comment_comments` FOREIGN KEY (`parent_id`) REFERENCES `comments` (`id`),
  CONSTRAINT `fk_content_comments` FOREIGN KEY (`content_id`) REFERENCES `___temp_dreamhost_restore_20090126_035259`.`contents` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `companies` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(40) default NULL,
  `description` varchar(255) default NULL,
  `visible` tinyint(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `contents` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(255) default NULL,
  `title` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `date` datetime default NULL,
  `content` text,
  `permalink` varchar(255) default NULL,
  `version_id` int(11) default NULL,
  `user` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `contents_contents` (
  `content_id` int(11) NOT NULL default '0',
  `related_id` int(11) NOT NULL default '0',
  KEY `fk_secondary_content_contents` (`related_id`),
  KEY `fk_main_content_contents` (`content_id`),
  CONSTRAINT `fk_main_content_contents` FOREIGN KEY (`content_id`) REFERENCES `___temp_dreamhost_restore_20090126_035259`.`contents` (`id`),
  CONSTRAINT `fk_secondary_content_contents` FOREIGN KEY (`related_id`) REFERENCES `___temp_dreamhost_restore_20090126_035259`.`contents` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `markdowns` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `messages` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `name` varchar(255) default NULL,
  `message` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `portfolio_items` (
  `id` int(11) NOT NULL auto_increment,
  `portfolio_type_id` int(11) NOT NULL default '0',
  `company_id` int(11) NOT NULL default '0',
  `size` int(11) default NULL,
  `data` blob,
  PRIMARY KEY  (`id`),
  KEY `portfolio_type_id` (`portfolio_type_id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `fk_company_portfolio_items` FOREIGN KEY (`company_id`) REFERENCES `___temp_dreamhost_restore_20090126_035259`.`companies` (`id`),
  CONSTRAINT `fk_portfolio_type_portfolio_items` FOREIGN KEY (`portfolio_type_id`) REFERENCES `portfolio_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `portfolio_types` (
  `id` int(11) NOT NULL auto_increment,
  `description` varchar(40) default NULL,
  `column_space` int(11) default NULL,
  `position` int(11) default NULL,
  `header_binary` blob,
  `visible` tinyint(1) default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL default '',
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `versions` (
  `id` int(11) NOT NULL auto_increment,
  `version_number` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('10');

INSERT INTO schema_migrations (version) VALUES ('11');

INSERT INTO schema_migrations (version) VALUES ('12');

INSERT INTO schema_migrations (version) VALUES ('13');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('20081204220440');

INSERT INTO schema_migrations (version) VALUES ('20081208231219');

INSERT INTO schema_migrations (version) VALUES ('20081208231312');

INSERT INTO schema_migrations (version) VALUES ('20081216175718');

INSERT INTO schema_migrations (version) VALUES ('20081216175905');

INSERT INTO schema_migrations (version) VALUES ('20081216215513');

INSERT INTO schema_migrations (version) VALUES ('20081218132651');

INSERT INTO schema_migrations (version) VALUES ('20090116001346');

INSERT INTO schema_migrations (version) VALUES ('20090603225630');

INSERT INTO schema_migrations (version) VALUES ('20090823223345');

INSERT INTO schema_migrations (version) VALUES ('3');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('5');

INSERT INTO schema_migrations (version) VALUES ('6');

INSERT INTO schema_migrations (version) VALUES ('7');

INSERT INTO schema_migrations (version) VALUES ('8');

INSERT INTO schema_migrations (version) VALUES ('9');