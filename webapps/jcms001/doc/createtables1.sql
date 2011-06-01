# phpMyAdmin MySQL-Dump
# version 2.4.0-rc1
# http://www.phpmyadmin.net/ (download page)
#
# Host: localhost
# Erstellungszeit: 24. Mai 2003 um 02:17
# Server Version: 3.23.52
# PHP-Version: 4.2.2
# Datenbank: `metatron`
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `jcms_contentnodes`
#

DROP TABLE IF EXISTS jcms_contentnodes;
CREATE TABLE jcms_contentnodes (
  cn_key int(11) NOT NULL auto_increment,
  cn_stamp timestamp(14) NOT NULL,
  cn_ref_node int(11) default NULL,
  cn_acl text,
  cn_meta text,
  cn_content longtext,
  cn_data1 int(11) default NULL,
  cn_data2 int(11) default NULL,
  cn_status varchar(12) default NULL,
  cn_owner int(11) default NULL,
  cn_xchar varchar(64) default NULL,
  cn_xint int(11) default NULL,
  cn_xdate date default NULL,
  cn_xtext text,
  cn_version varchar(32) default 'standard',
  PRIMARY KEY  (cn_key)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `jcms_dtd`
#

DROP TABLE IF EXISTS jcms_dtd;
CREATE TABLE jcms_dtd (
  dt_key int(11) NOT NULL auto_increment,
  dt_type varchar(64) default NULL,
  dt_stamp timestamp(14) NOT NULL,
  dt_owner int(11) default NULL,
  dt_name varchar(64) default NULL,
  dt_description text,
  dt_xchar varchar(64) default NULL,
  dt_xint int(11) default NULL,
  dt_xdate date default NULL,
  dt_xtext text,
  PRIMARY KEY  (dt_key)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `jcms_dtddata`
#

DROP TABLE IF EXISTS jcms_dtddata;
CREATE TABLE jcms_dtddata (
  dd_key int(11) NOT NULL auto_increment,
  dd_type varchar(64) default NULL,
  dd_stamp timestamp(14) NOT NULL,
  dd_owner int(11) default NULL,
  dd_ref_dtd int(11) default NULL,
  dd_name varchar(64) default NULL,
  dd_alias varchar(128) default NULL,
  dd_fieldtype varchar(16) default NULL,
  dd_defaultvalue text,
  dd_readproc text,
  dd_writeproc text,
  dd_xchar varchar(64) default NULL,
  dd_xint int(11) default NULL,
  dd_xdate date default NULL,
  dd_xtext text,
  dd_size1 int(11) default NULL,
  dd_size2 int(11) default NULL,
  dd_size3 int(11) default NULL,
  PRIMARY KEY  (dd_key)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `jcms_nodes`
#

DROP TABLE IF EXISTS jcms_nodes;
CREATE TABLE jcms_nodes (
  no_key int(11) NOT NULL auto_increment,
  no_name varchar(250) default NULL,
  no_type varchar(16) default NULL,
  no_stamp timestamp(14) NOT NULL,
  no_subtype varchar(16) default NULL,
  no_level int(11) default NULL,
  no_ref_child int(11) default NULL,
  no_ref_parent int(11) default NULL,
  no_acl text,
  no_meta text,
  no_data1 int(11) default NULL,
  no_data2 int(11) default NULL,
  no_status varchar(8) default NULL,
  no_owner int(11) default NULL,
  no_xchar varchar(64) default NULL,
  no_xint int(11) default NULL,
  no_xdate date default NULL,
  no_xtext text,
  PRIMARY KEY  (no_key)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `jcms_templates`
#

DROP TABLE IF EXISTS jcms_templates;
CREATE TABLE jcms_templates (
  te_key int(11) NOT NULL auto_increment,
  te_name varchar(250) default NULL,
  te_type varchar(16) default NULL,
  te_stamp timestamp(14) NOT NULL,
  te_subtype varchar(16) default NULL,
  te_source text,
  te_properties text,
  te_ref_dtds text,
  te_ref_node int(11) default NULL,
  te_ref_site int(11) default NULL,
  te_status varchar(8) default NULL,
  te_owner int(11) default NULL,
  te_xchar varchar(64) default NULL,
  te_xint int(11) default NULL,
  te_xdate date default NULL,
  te_xtext text,
  PRIMARY KEY  (te_key)
) TYPE=MyISAM;

