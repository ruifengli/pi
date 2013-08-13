# Pi Engine schema
# http://pialog.org
# Author: Taiwen Jiang <taiwenjiang@tsinghua.org.cn>
# --------------------------------------------------------

# ------------------------------------------------------
# User
# >>>>

# user ID: the unique identity in the system
# user identity: the user's unique identity, generated by the system or sent from other systems like openID
# all local data of a user should be indexed by user ID

# User account and authentication data
CREATE TABLE `{account}` (
  `id`              int(10)         unsigned    NOT NULL    auto_increment,
  `identity`        varchar(32)     NOT NULL,
  `credential`      varchar(255)    NOT NULL default '',    # Credential hash
  `salt`            varchar(255)    NOT NULL default '',    # Hash salt
  `email`           varchar(64)     NOT NULL,
  `name`            varchar(255)    NOT NULL,

  `active`          tinyint(1)      NOT NULL default '0',
  `disabled`        tinyint(1)      NOT NULL default '0',

  PRIMARY KEY  (`id`),
  UNIQUE KEY `identity` (`identity`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `name` (`name`),
);

# Profile schema for basic fields
CREATE TABLE `{profile}` (
  `id`              int(10)         unsigned    NOT NULL    auto_increment,
  `uid`             int(10)         unsigned    NOT NULL,
  `gender`          varchar(255)    NOT NULL default '',
  `fullname`        varchar(255)    NOT NULL default '',
  `birthdate`       varchar(10)     NOT NULL default '',    # YYYY-mm-dd
  `location`        varchar(255)    NOT NULL default '',
  `signature`       varchar(255)    NOT NULL default '',
  `bio`             text,
  `avatar`          text,           # Link to avatar image, or email for gravatar

  PRIMARY KEY  (`id`),
  UNIQUE KEY `user` (`uid`)
);

# Entity meta for custom user profile fields
CREATE TABLE `{custom}` (
  `id`              int(10)         unsigned    NOT NULL    auto_increment,
  `uid`             int(10)         unsigned    NOT NULL,
  `field`           varchar(64)     NOT NULL,   # Custom field name
  `value`           text,

  PRIMARY KEY  (`id`),
  UNIQUE KEY  `field` (`uid`, `field`)
);

# Entity meta for all profile fields: account, basic profile and custom fields
CREATE TABLE `{field}` (
  `id`              smallint(5)     unsigned    NOT NULL    auto_increment,
  `name`            varchar(64)     NOT NULL,
  `module`          varchar(64)     NOT NULL default '',
  `title`           varchar(255)    NOT NULL default '',
  `edit`            text,           # callback options for edit
  `filter`          text,           # callback options for output filtering

  `type`            ENUM('custom', 'account', 'profile', 'compound'),   # Field type, default as custom
  `is_edit`         tinyint(1)      NOT NULL default '0',   # Is editable by user
  `is_search`       tinyint(1)      NOT NULL default '0',   # Is searchable
  `is_display`      tinyint(1)      NOT NULL default '0',   # Display on profile page
  `active`          tinyint(1)      NOT NULL default '0',   # Is active

  PRIMARY KEY  (`id`),
  UNIQUE KEY  `name` (`name`)
);

# Entity meta compound fields
CREATE TABLE `{compound_field}` (
  `id`              smallint(5)     unsigned    NOT NULL    auto_increment,
  `name`            varchar(64)     NOT NULL,
  `compound`        varchar(64)     NOT NULL default '',
  `title`           varchar(255)    NOT NULL default '',
  `edit`            text,           # callback options for edit
  `filter`          text,           # callback options for output filtering

  `active`          tinyint(1)      NOT NULL default '0',   # Is active

  PRIMARY KEY  (`id`),
  UNIQUE KEY  `name` (`compound`, `name`)
);

# Timeline meta
CREATE TABLE `{timeline}` (
  `id`              int(10)         unsigned    NOT NULL    auto_increment,
  `name`            varchar(64)     NOT NULL    default '',
  `title`           varchar(255)    NOT NULL    default '',
  `module`          varchar(64)     NOT NULL    default '',
  `icon`            text,
  `active`          tinyint(1)      NOT NULL default '0',   # Is active

  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`module`, `name`)
);

# Activity meta
CREATE TABLE `{activity}` (
  `id`              int(10)         unsigned    NOT NULL    auto_increment,
  `name`            varchar(64)     NOT NULL    default '',
  `title`           varchar(255)    NOT NULL    default '',
  `module`          varchar(64)     NOT NULL    default '',
  `link`            text,
  `icon`            text,
  `active`          tinyint(1)      NOT NULL default '0',   # Is active

  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`module`, `name`)
);

# Quicklinks
CREATE TABLE `{quicklink}` (
  `id`              int(10)         unsigned    NOT NULL    auto_increment,
  `name`            varchar(64)     NOT NULL    default '',
  `title`           varchar(255)    NOT NULL    default '',
  `module`          varchar(64)     NOT NULL    default '',
  `link`            text,
  `icon`            text,
  `active`          tinyint(1)      NOT NULL default '0',   # Is active

  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`module`, `name`)
);

# Timeline for user activities
CREATE TABLE `{timeline_log}` (
  `id`              int(10)         unsigned    NOT NULL    auto_increment,
  `uid`             int(10)         unsigned    NOT NULL,
  `timeline`        varchar(64)     NOT NULL    default '',
  `module`          varchar(64)     NOT NULL    default '',
  `message`         text,
  `link`            text,
  `time`            int(11)         unsigned    NOT NULL,

  PRIMARY KEY  (`id`),
  KEY (`uid`)
);


# Social networking tool
CREATE TABLE `{tool}` (
  `id`              int(10)         unsigned    NOT NULL    auto_increment,
  `uid`             int(10)         unsigned    NOT NULL,
  `title`           varchar(64)     NOT NULL    default '',
  `identitifer`     text,
  `order`           int(11)         unsigned    NOT NULL,

  PRIMARY KEY  (`id`),
  KEY (`uid`)
);

# Address
CREATE TABLE `{address}` (
  `id`              int(10)         unsigned    NOT NULL    auto_increment,
  `uid`             int(10)         unsigned    NOT NULL,
  `postcode`        varchar(64)     NOT NULL    default '',
  `country`         varchar(64)     NOT NULL    default '',
  `province`        varchar(64)     NOT NULL    default '',
  `city`            varchar(64)     NOT NULL    default '',
  `stree`           varchar(64)     NOT NULL    default '',
  `office`          varchar(64)     NOT NULL    default '',
  `order`           int(11)         unsigned    NOT NULL defualt '5',

  PRIMARY KEY  (`id`),
  KEY (`uid`)
);

# Education
CREATE TABLE `{education}` (
  `id`              int(10)         unsigned    NOT NULL    auto_increment,
  `uid`             int(10)         unsigned    NOT NULL,
  `school`          varchar(64)     NOT NULL    default '',
  `major`           varchar(64)     NOT NULL    default '',
  `degree`          varchar(64)     NOT NULL    default '',
  `class`           varchar(64)     NOT NULL    default '',
  `start`           varchar(64)     NOT NULL    default '',
  `end`             varchar(64)     NOT NULL    default '',
  `order`           int(11)         unsigned    NOT NULL defualt '5',

  PRIMARY KEY  (`id`),
  KEY (`uid`)
);

# Work
CREATE TABLE `{work}` (
  `id`              int(10)         unsigned    NOT NULL    auto_increment,
  `uid`             int(10)         unsigned    NOT NULL,
  `company`         varchar(64)     NOT NULL    default '',
  `departmetn`      varchar(64)     NOT NULL    default '',
  `title`           varchar(64)     NOT NULL    default '',
  `description`     text,
  `start`           varchar(64)     NOT NULL    default '',
  `end`             varchar(64)     NOT NULL    default '',
  `order`           int(11)         unsigned    NOT NULL defualt '5',

  PRIMARY KEY  (`id`),
  KEY (`uid`)
);

# ------------------------------------------------------

# user custom contents
CREATE TABLE `{repo}` (
  `id`              int(10)         unsigned    NOT NULL    auto_increment,
  `uid`             int(10)         unsigned    NOT NULL default '0',
  `module`          varchar(64)     NOT NULL    default '',
  `type`            varchar(64)     NOT NULL    default '',
  `content`         text,

  PRIMARY KEY  (`id`),
  UNIQUE KEY `user_content` (`uid`, `module`, `type`)
);

# user-role links for regular
CREATE TABLE `{role}` (
  `id`              int(10)         unsigned    NOT NULL    auto_increment,
  `uid`             int(10)         unsigned    NOT NULL,
  `role`            varchar(64)     NOT NULL    default '',
   `section`        varchar(64)     NOT NULL    default 'front',

  PRIMARY KEY  (`id`),
  UNIQUE KEY `user` (`section`, `uid`)
);
