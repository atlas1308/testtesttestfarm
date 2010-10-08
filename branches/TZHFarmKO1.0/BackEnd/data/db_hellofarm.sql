-- phpMyAdmin SQL Dump
-- version 2.11.7
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Aug 06, 2010 at 10:47 AM
-- Server version: 5.0.67
-- PHP Version: 5.2.9-2

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `db_hellofarm`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_gifts`
--

DROP TABLE IF EXISTS `tbl_gifts`;
CREATE TABLE IF NOT EXISTS `tbl_gifts` (
  `id` int(10) NOT NULL COMMENT '自动编号',
  `uid` varchar(20) default NULL COMMENT '用户UID',
  `touid` varchar(20) default NULL COMMENT '接收者UID',
  `itemid` smallint(5) NOT NULL default '0' COMMENT '礼物ID',
  `message` varchar(200) NOT NULL COMMENT '附言',
  `sendtime` datetime NOT NULL default '0000-00-00 00:00:00' COMMENT '递送时间',
  `received` tinyint(1) NOT NULL default '0' COMMENT '是否查收',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='礼物数据表';

--
-- Dumping data for table `tbl_gifts`
--


-- --------------------------------------------------------

--
-- Table structure for table `tbl_level`
--

DROP TABLE IF EXISTS `tbl_level`;
CREATE TABLE IF NOT EXISTS `tbl_level` (
  `level` smallint(5) NOT NULL COMMENT '等级',
  `min_exp` int(10) unsigned NOT NULL default '0' COMMENT '最小经验',
  `max_exp` int(10) unsigned NOT NULL default '0' COMMENT '最大经验',
  PRIMARY KEY  (`level`),
  KEY `max_exp` (`max_exp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='等级数据表';

--
-- Dumping data for table `tbl_level`
--

INSERT INTO `tbl_level` (`level`, `min_exp`, `max_exp`) VALUES
(1, 0, 30),
(2, 30, 70),
(3, 70, 120),
(4, 120, 280),
(5, 280, 500),
(6, 500, 750),
(7, 750, 1050),
(8, 1050, 1450),
(9, 1450, 1950),
(10, 1950, 2500),
(11, 2500, 3100),
(12, 3100, 3800),
(13, 3800, 4600),
(14, 4600, 5500),
(15, 5500, 6500),
(16, 6500, 7600),
(17, 7600, 8800),
(18, 8800, 10300),
(19, 10300, 11900),
(20, 11900, 13750),
(21, 13750, 15600),
(22, 15600, 18100),
(23, 18100, 20600),
(24, 20600, 23400),
(25, 23400, 26600),
(26, 26600, 30500),
(27, 30500, 35000),
(28, 35000, 40000),
(29, 40000, 45500),
(30, 45500, 51500),
(31, 51500, 58000),
(32, 58000, 65000),
(33, 65000, 72500),
(34, 72500, 80500),
(35, 80500, 89000),
(36, 89000, 98000),
(37, 98000, 107500),
(38, 107500, 117500),
(39, 117500, 128000),
(40, 128000, 139000),
(41, 139000, 150500),
(42, 150500, 162500),
(43, 162500, 175000),
(44, 175000, 188000),
(45, 188000, 201500),
(46, 201500, 215500),
(47, 215500, 230000),
(48, 230000, 245000),
(49, 245000, 260500),
(50, 260500, 276500),
(51, 276500, 293000),
(52, 293000, 310000),
(53, 310000, 327500),
(54, 327500, 345500),
(55, 345500, 364000),
(56, 364000, 383000),
(57, 383000, 402500),
(58, 402500, 422500),
(59, 422500, 443000),
(60, 443000, 464000),
(61, 464000, 485500),
(62, 485500, 507500),
(63, 507500, 530000),
(64, 530000, 553000),
(65, 553000, 576500),
(66, 576500, 600500),
(67, 600500, 625000),
(68, 625000, 650000),
(69, 650000, 675500),
(70, 675500, 701500),
(71, 701500, 728000),
(72, 728000, 755000),
(73, 755000, 782500),
(74, 782500, 810500),
(75, 810500, 10000000);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_map`
--

DROP TABLE IF EXISTS `tbl_map`;
CREATE TABLE IF NOT EXISTS `tbl_map` (
  `id` int(10) unsigned NOT NULL auto_increment COMMENT '自动编号',
  `uid` varchar(20) NOT NULL COMMENT '用户UID',
  `map_x` smallint(5) unsigned NOT NULL COMMENT 'X坐标',
  `map_y` smallint(5) unsigned NOT NULL COMMENT 'Y坐标',
  `itemid` smallint(5) unsigned default '1' COMMENT '物品ID',
  `start_time` int(10) unsigned default '0' COMMENT '种植时间',
  `flipped` tinyint(1) unsigned default '0' COMMENT '是否旋转',
  `animals` tinyint(1) unsigned default '0' COMMENT '动物数量',
  `products` tinyint(1) unsigned default '0' COMMENT '产品数量',
  `raw_materials` tinyint(1) unsigned default '0' COMMENT '饲料数量',
  PRIMARY KEY  (`id`),
  KEY `uid` (`uid`),
  KEY `uid_x_y` (`uid`,`map_x`,`map_y`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='地图数据表' AUTO_INCREMENT=151 ;

--
-- Dumping data for table `tbl_map`
--

INSERT INTO `tbl_map` (`id`, `uid`, `map_x`, `map_y`, `itemid`, `start_time`, `flipped`, `animals`, `products`, `raw_materials`) VALUES
(1, '703118330', 3, 29, 48, 1278951444, 0, 0, 0, 0),
(2, '703118330', 3, 22, 1, 0, 0, 0, 0, 0),
(3, '703118330', 8, 12, 4, 1280007980, 0, 0, 0, 0),
(4, '703118330', 12, 12, 4, 1280007980, 0, 0, 0, 0),
(5, '703118330', 16, 12, 4, 1280007980, 0, 0, 0, 0),
(6, '703118330', 20, 12, 4, 1280007980, 0, 0, 0, 0),
(7, '703118330', 24, 12, 4, 1280007980, 0, 0, 0, 0),
(8, '703118330', 28, 12, 4, 1280007980, 0, 0, 0, 0),
(9, '703118330', 28, 18, 4, 1280007980, 0, 0, 0, 0),
(10, '703118330', 28, 22, 1, 0, 0, 0, 0, 0),
(11, '703118330', 22, 18, 4, 1280007980, 0, 0, 0, 0),
(12, '703118330', 18, 18, 4, 1280007980, 0, 0, 0, 0),
(13, '703118330', 18, 22, 4, 1280007980, 0, 0, 0, 0),
(14, '703118330', 18, 26, 4, 1280007980, 0, 0, 0, 0),
(15, '703118330', 22, 26, 4, 1280007980, 0, 0, 0, 0),
(16, '703118330', 22, 22, 4, 1280007980, 0, 0, 0, 0),
(17, '703118330', 12, 16, 1, 0, 0, 0, 0, 0),
(18, '703118330', 8, 16, 1, 0, 0, 0, 0, 0),
(19, '703118330', 12, 20, 1, 0, 0, 0, 0, 0),
(20, '703118330', 8, 20, 1, 0, 0, 0, 0, 0),
(21, '703118330', 8, 24, 1, 0, 0, 0, 0, 0),
(22, '703118330', 12, 24, 1, 0, 0, 0, 0, 0),
(23, '703118330', 12, 28, 1, 0, 0, 0, 0, 0),
(24, '703118330', 8, 28, 1, 0, 0, 0, 0, 0),
(25, '703118330', 28, 26, 1, 0, 0, 0, 0, 0),
(26, '703118330', 22, 32, 4, 1280007980, 0, 0, 0, 0),
(27, '703118330', 18, 32, 4, 1280007980, 0, 0, 0, 0),
(28, '703118330', 18, 36, 4, 1280007980, 0, 0, 0, 0),
(29, '703118330', 18, 40, 4, 1280007980, 0, 0, 0, 0),
(30, '703118330', 22, 40, 4, 1280007980, 0, 0, 0, 0),
(31, '703118330', 22, 36, 1, 0, 0, 0, 0, 0),
(32, '703118330', 8, 32, 1, 0, 0, 0, 0, 0),
(33, '703118330', 12, 32, 1, 0, 0, 0, 0, 0),
(34, '703118330', 12, 36, 4, 1280007980, 0, 0, 0, 0),
(35, '703118330', 8, 36, 4, 1280007980, 0, 0, 0, 0),
(36, '703118330', 8, 40, 4, 1280007980, 0, 0, 0, 0),
(37, '703118330', 12, 40, 4, 1280007980, 0, 0, 0, 0),
(38, '703118330', 0, 48, 4, 1280007980, 0, 0, 0, 0),
(39, '703118330', 0, 52, 4, 1280007980, 0, 0, 0, 0),
(40, '703118330', 0, 56, 4, 1280007980, 0, 0, 0, 0),
(41, '703118330', 4, 56, 4, 1280007980, 0, 0, 0, 0),
(42, '703118330', 4, 52, 4, 1280007980, 0, 0, 0, 0),
(43, '703118330', 4, 48, 4, 1280007980, 0, 0, 0, 0),
(44, '703118330', 8, 48, 4, 1280007980, 0, 0, 0, 0),
(45, '703118330', 8, 52, 4, 1280007980, 0, 0, 0, 0),
(46, '703118330', 8, 56, 9, 1278951597, 0, 0, 0, 0),
(47, '703118330', 12, 56, 4, 1280007980, 0, 0, 0, 0),
(48, '703118330', 12, 52, 4, 1280007980, 0, 0, 0, 0),
(49, '703118330', 12, 48, 9, 1278951597, 0, 0, 0, 0),
(50, '703118330', 16, 48, 4, 1280007980, 0, 0, 0, 0),
(51, '703118330', 16, 52, 9, 1278951609, 0, 0, 0, 0),
(52, '703118330', 16, 56, 4, 1280007980, 0, 0, 0, 0),
(53, '703118330', 20, 56, 4, 1280007980, 0, 0, 0, 0),
(54, '703118330', 20, 52, 1, 0, 0, 0, 0, 0),
(55, '703118330', 20, 48, 4, 1280007980, 0, 0, 0, 0),
(56, '703118330', 24, 48, 4, 1280007980, 0, 0, 0, 0),
(57, '703118330', 24, 52, 1, 0, 0, 0, 0, 0),
(58, '703118330', 24, 56, 4, 1280007980, 0, 0, 0, 0),
(59, '703118330', 28, 56, 4, 1280007980, 0, 0, 0, 0),
(60, '703118330', 28, 52, 4, 1280007980, 0, 0, 0, 0),
(61, '703118330', 28, 48, 1, 0, 0, 0, 0, 0),
(62, '703118330', 48, 17, 5, 0, 1, 0, 3, 0),
(63, '703118330', 4, 37, 4, 1280007980, 0, 0, 0, 0),
(64, '703118330', 32, 12, 4, 1280007980, 0, 0, 0, 0),
(65, '703118330', 36, 12, 4, 1280007980, 0, 0, 0, 0),
(66, '703118330', 40, 12, 4, 1280007980, 0, 0, 0, 0),
(67, '703118330', 32, 18, 1, 0, 0, 0, 0, 0),
(68, '703118330', 36, 18, 1, 0, 0, 0, 0, 0),
(69, '703118330', 40, 18, 1, 0, 0, 0, 0, 0),
(70, '703118330', 40, 22, 1, 0, 0, 0, 0, 0),
(71, '703118330', 36, 22, 1, 0, 0, 0, 0, 0),
(72, '703118330', 32, 22, 4, 1280007980, 0, 0, 0, 0),
(73, '703118330', 32, 26, 1, 0, 0, 0, 0, 0),
(74, '703118330', 36, 26, 1, 0, 0, 0, 0, 0),
(75, '703118330', 40, 26, 1, 0, 0, 0, 0, 0),
(76, '703118330', 44, 26, 1, 0, 0, 0, 0, 0),
(77, '703118330', 44, 22, 1, 0, 0, 0, 0, 0),
(78, '703118330', 44, 18, 1, 0, 0, 0, 0, 0),
(79, '703118330', 44, 12, 1, 0, 0, 0, 0, 0),
(80, '703118330', 32, 48, 1, 0, 0, 0, 0, 0),
(81, '703118330', 32, 52, 1, 0, 0, 0, 0, 0),
(82, '703118330', 32, 56, 4, 1280007980, 0, 0, 0, 0),
(83, '703118330', 36, 56, 1, 0, 0, 0, 0, 0),
(84, '703118330', 36, 52, 1, 0, 0, 0, 0, 0),
(85, '703118330', 36, 48, 1, 0, 0, 0, 0, 0),
(86, '703118330', 40, 48, 1, 0, 0, 0, 0, 0),
(87, '703118330', 40, 52, 1, 0, 0, 0, 0, 0),
(88, '703118330', 40, 56, 1, 0, 0, 0, 0, 0),
(89, '703118330', 44, 56, 1, 0, 0, 0, 0, 0),
(90, '703118330', 44, 52, 1, 0, 0, 0, 0, 0),
(91, '703118330', 44, 48, 1, 0, 0, 0, 0, 0),
(92, '703118330', 48, 48, 1, 0, 0, 0, 0, 0),
(93, '703118330', 48, 52, 1, 0, 0, 0, 0, 0),
(94, '703118330', 48, 56, 1, 0, 0, 0, 0, 0),
(95, '703118330', 52, 52, 1, 0, 0, 0, 0, 0),
(96, '703118330', 56, 56, 1, 0, 0, 0, 0, 0),
(97, '703118330', 52, 56, 1, 0, 0, 0, 0, 0),
(98, '703118330', 56, 52, 132, 1280921206, 0, 0, 0, 0),
(99, '703118330', 56, 48, 1, 0, 0, 0, 0, 0),
(100, '703118330', 52, 48, 1, 0, 0, 0, 0, 0),
(101, '703118330', 56, 43, 1, 0, 0, 0, 0, 0),
(102, '703118330', 38, 31, 87, 1280921032, 0, 0, 0, 0),
(103, '703118330', 38, 35, 87, 1280921032, 0, 0, 0, 0),
(104, '703118330', 38, 35, 87, 1280921032, 0, 0, 0, 0),
(105, '703118330', 38, 35, 87, 1280921032, 0, 0, 0, 0),
(106, '703118330', 38, 35, 87, 1280921032, 0, 0, 0, 0),
(107, '703118330', 38, 35, 87, 1280921032, 0, 0, 0, 0),
(108, '703118330', 38, 35, 87, 1280921032, 0, 0, 0, 0),
(109, '703118330', 38, 35, 87, 1280921032, 0, 0, 0, 0),
(110, '703118330', 38, 35, 87, 1280921032, 0, 0, 0, 0),
(111, '703118330', 38, 35, 87, 1280921032, 0, 0, 0, 0),
(112, '703118330', 38, 39, 87, 1280921032, 0, 0, 0, 0),
(113, '703118330', 38, 43, 87, 1280921042, 0, 0, 0, 0),
(114, '703118330', 0, 0, 4, 1281007965, 0, 0, 0, 0),
(115, '703118330', 4, 4, 4, 1281007975, 0, 0, 0, 0),
(116, '703118330', 8, 8, 4, 1281007975, 0, 0, 0, 0),
(117, '703118330', 8, 0, 4, 1281007965, 0, 0, 0, 0),
(118, '703118330', 12, 4, 4, 1281007965, 0, 0, 0, 0),
(119, '703118330', 16, 0, 4, 1281007965, 0, 0, 0, 0),
(120, '703118330', 17, 8, 4, 1281007975, 0, 0, 0, 0),
(121, '703118330', 20, 4, 4, 1281007975, 0, 0, 0, 0),
(122, '703118330', 24, 0, 4, 1281007965, 0, 0, 0, 0),
(123, '703118330', 24, 8, 4, 1281007975, 0, 0, 0, 0),
(124, '703118330', 0, 7, 4, 1281007975, 0, 0, 0, 0),
(125, '703118330', 28, 4, 4, 1281007975, 0, 0, 0, 0),
(126, '703118330', 32, 0, 4, 1281007965, 0, 0, 0, 0),
(127, '703118330', 32, 8, 4, 1281007975, 0, 0, 0, 0),
(128, '703118330', 36, 4, 4, 1281007975, 0, 0, 0, 0),
(129, '703118330', 40, 0, 4, 1281007965, 0, 0, 0, 0),
(130, '703118330', 40, 8, 4, 1281007980, 0, 0, 0, 0),
(131, '703118330', 44, 4, 1, 0, 0, 0, 0, 0),
(132, '703118330', 48, 8, 4, 1281007980, 0, 0, 0, 0),
(133, '703118330', 48, 0, 4, 1281007965, 0, 0, 0, 0),
(134, '703118330', 52, 4, 4, 1281007965, 0, 0, 0, 0),
(135, '703118330', 56, 8, 4, 1281007980, 0, 0, 0, 0),
(136, '703118330', 56, 0, 4, 1281007965, 0, 0, 0, 0),
(137, '703118330', 52, 12, 1, 0, 0, 0, 0, 0),
(138, '703118330', 48, 12, 1, 0, 0, 0, 0, 0),
(139, '703118330', 56, 12, 4, 1280007980, 0, 0, 0, 0),
(140, '703118330', 42, 31, 87, 1280921032, 0, 0, 0, 0),
(141, '703118330', 42, 35, 87, 1280921032, 0, 0, 0, 0),
(142, '703118330', 42, 39, 87, 1280921032, 0, 0, 0, 0),
(143, '703118330', 42, 43, 132, 1280921080, 0, 0, 0, 0),
(144, '703118330', 4, 12, 4, 1280007980, 0, 0, 0, 0),
(145, '703118330', 0, 12, 1, 0, 0, 0, 0, 0),
(146, '703118330', 52, 43, 1, 0, 0, 0, 0, 0),
(147, '703118330', 4, 16, 1, 0, 0, 0, 0, 0),
(148, '703118330', 48, 30, 5, 0, 1, 0, 3, 0),
(149, '703118330', 26, 32, 11, 1281032884, 0, 5, 0, 5),
(150, '703118330', 26, 40, 11, 1281032751, 0, 4, 0, 4);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_neighbors`
--

DROP TABLE IF EXISTS `tbl_neighbors`;
CREATE TABLE IF NOT EXISTS `tbl_neighbors` (
  `uid` varchar(20) NOT NULL default '0' COMMENT '用户UID',
  `nuid` varchar(20) NOT NULL default '0' COMMENT '邻居UID',
  `nusername` varchar(15) NOT NULL COMMENT '邻居姓名',
  `gid` smallint(6) unsigned NOT NULL default '0' COMMENT '邻居分组',
  `message` varchar(50) NOT NULL COMMENT '留言',
  `status` tinyint(1) NOT NULL default '0' COMMENT '状态',
  `datetime` datetime NOT NULL default '0000-00-00 00:00:00' COMMENT '请求时间',
  PRIMARY KEY  (`uid`,`nuid`),
  KEY `nuid` (`nuid`),
  KEY `status` (`uid`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='邻居数据表';

--
-- Dumping data for table `tbl_neighbors`
--

INSERT INTO `tbl_neighbors` (`uid`, `nuid`, `nusername`, `gid`, `message`, `status`, `datetime`) VALUES
('703118330', '1560424778', 'test', 0, '', 1, '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_storage`
--

DROP TABLE IF EXISTS `tbl_storage`;
CREATE TABLE IF NOT EXISTS `tbl_storage` (
  `uid` varchar(20) NOT NULL COMMENT '用户UID',
  `itemid` smallint(5) unsigned NOT NULL COMMENT '物品ID',
  `num` smallint(5) unsigned NOT NULL COMMENT '数量',
  UNIQUE KEY `uid` (`uid`,`itemid`),
  KEY `userid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='仓库数据表';

--
-- Dumping data for table `tbl_storage`
--

INSERT INTO `tbl_storage` (`uid`, `itemid`, `num`) VALUES
('703118330', 1, 0),
('703118330', 2, 0),
('703118330', 5, 0),
('703118330', 13, 0),
('703118330', 15, 0),
('703118330', 17, 64),
('703118330', 21, 15),
('703118330', 49, 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_store`
--

DROP TABLE IF EXISTS `tbl_store`;
CREATE TABLE IF NOT EXISTS `tbl_store` (
  `id` smallint(5) NOT NULL default '0' COMMENT '自动编号',
  `name` varchar(30) NOT NULL COMMENT '名称',
  `type` varchar(20) NOT NULL COMMENT '主分类',
  `kind` varchar(20) default NULL COMMENT '子分类',
  `desc` varchar(200) default NULL COMMENT '描述',
  `url` varchar(20) NOT NULL COMMENT 'URL路径',
  `exp` smallint(5) NOT NULL default '0' COMMENT '经验',
  `level` smallint(5) default NULL COMMENT '等级',
  `map_object` tinyint(1) NOT NULL default '0' COMMENT '是否地图物品',
  `buyable` tinyint(1) NOT NULL default '0' COMMENT '能否购买',
  `price` int(10) default NULL COMMENT '购买价格',
  `size_x` tinyint(3) default NULL COMMENT '占用地块X大小',
  `size_y` tinyint(3) default NULL COMMENT '占用地块Y大小',
  `sell_price` int(10) default NULL COMMENT '卖出价格',
  `collect_in` int(10) default NULL COMMENT '收获时长',
  `buy_gift` tinyint(1) default NULL COMMENT '作为礼物购买',
  `stages` tinyint(3) default NULL COMMENT '成长阶段',
  `constructible` tinyint(1) default NULL COMMENT '能否建造',
  `depth` varchar(100) default NULL COMMENT '深度',
  `flipable` tinyint(1) default NULL COMMENT '可否反转',
  `friends_needed` smallint(2) default NULL COMMENT '必须好友数',
  `giftable` tinyint(1) default NULL COMMENT '是否礼物',
  `gift_level` smallint(2) default NULL COMMENT '礼物等级',
  `gift_priority` smallint(2) default NULL COMMENT '礼物优先级',
  `growing_percent` varchar(5) default NULL COMMENT '成长百分比',
  `is_multi` tinyint(1) default NULL COMMENT '是否可操作多个物品',
  `is_tall` tinyint(1) default NULL COMMENT '是否高物品',
  `need_animals` tinyint(1) default NULL COMMENT '是否需要动物',
  `animal` varchar(10) default NULL COMMENT '动物ID',
  `raw_material` varchar(200) default NULL COMMENT '饲料',
  `max_animals` tinyint(3) default NULL COMMENT '最大动物数',
  `max_instances` tinyint(3) default NULL COMMENT '最大距离',
  `neighbors` smallint(2) default NULL COMMENT '邻居',
  `not_in_popup` tinyint(1) default NULL COMMENT '不显示在弹窗',
  `object_needed` smallint(3) default NULL,
  `op` smallint(5) default NULL COMMENT '可用点数',
  `percent` varchar(5) default NULL,
  `producer` smallint(5) default NULL COMMENT '生产者',
  `product_name` varchar(20) default NULL COMMENT '产品名称',
  `materials` varchar(500) default NULL COMMENT '加工材料',
  `product` varchar(200) default NULL COMMENT '产物ID',
  `rp_price` smallint(5) default NULL COMMENT 'rp价格',
  `sell_for` smallint(5) default NULL,
  `show_name` tinyint(1) default NULL,
  `sprinkler` smallint(3) default NULL,
  `store_pos` tinyint(3) default NULL COMMENT '存储位个数',
  `story` varchar(16) default NULL,
  `tall_object` tinyint(1) default NULL COMMENT '是否超高物品',
  `trade_for` smallint(5) default NULL COMMENT '兑换点数',
  `tree_spacing` smallint(1) default NULL COMMENT '植物间距',
  `upgradeable` tinyint(1) default NULL COMMENT '可否升级',
  `upgrade_levels` varchar(500) default NULL COMMENT '升级等级列表',
  `uses` smallint(5) default NULL COMMENT '使用次数',
  `action` varchar(20) default NULL COMMENT '操作',
  `add_on` smallint(5) default NULL COMMENT '宿主ID',
  `size` smallint(3) default NULL COMMENT '扩展地图尺寸',
  `complete_size_x` tinyint(3) default NULL COMMENT '完成后X大小',
  `complete_size_y` tinyint(3) default NULL COMMENT '完成后Y大小',
  PRIMARY KEY  (`id`),
  KEY `buyable` (`buyable`),
  KEY `giftable` (`giftable`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商店数据表';

--
-- Dumping data for table `tbl_store`
--

INSERT INTO `tbl_store` (`id`, `name`, `type`, `kind`, `desc`, `url`, `exp`, `level`, `map_object`, `buyable`, `price`, `size_x`, `size_y`, `sell_price`, `collect_in`, `buy_gift`, `stages`, `constructible`, `depth`, `flipable`, `friends_needed`, `giftable`, `gift_level`, `gift_priority`, `growing_percent`, `is_multi`, `is_tall`, `need_animals`, `animal`, `raw_material`, `max_animals`, `max_instances`, `neighbors`, `not_in_popup`, `object_needed`, `op`, `percent`, `producer`, `product_name`, `materials`, `product`, `rp_price`, `sell_for`, `show_name`, `sprinkler`, `store_pos`, `story`, `tall_object`, `trade_for`, `tree_spacing`, `upgradeable`, `upgrade_levels`, `uses`, `action`, `add_on`, `size`, `complete_size_x`, `complete_size_y`) VALUES
(1, 'Soil', 'soil', NULL, NULL, 'soil', 1, NULL, 1, 1, 15, 4, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 'Tomatoes', 'seeds', 'tomato', NULL, 'tomatoes', 1, 7, 1, 0, 20, 4, 4, NULL, 57600, NULL, 5, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '14', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 'Wheat', 'seeds', 'wheat', NULL, 'wheat', 1, 3, 1, 0, 35, 4, 4, NULL, 43200, NULL, 5, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(4, 'Clover', 'seeds', 'clover', NULL, 'clover', 1, 1, 1, 0, 15, 4, 4, NULL, 14400, NULL, 5, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(5, 'Holstein Cow', 'animals', 'cow', NULL, 'cow_black', 25, 9, 1, 0, 2500, 10, 12, 50, 60, NULL, NULL, NULL, NULL, 1, NULL, 1, 2, NULL, NULL, NULL, NULL, NULL, NULL, '15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '17', NULL, NULL, NULL, NULL, 3, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(6, 'Dutch Mill', 'buildings', 'mill', NULL, 'mill', 75, 15, 1, 0, 7500, 10, 12, 150, 45, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '18', NULL, NULL, NULL, NULL, NULL, NULL, 1, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(7, 'Rain', 'special_events', NULL, 'reduce crops growth time by 25%', 'rain', 100, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.25', NULL, NULL, NULL, NULL, 8, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'rain', NULL, NULL, NULL, NULL),
(8, 'Ketchup Wiz', 'gear', 'ketchup', NULL, 'ketchup_machine', 18, 16, 1, 0, 3000, 8, 10, 60, 45, NULL, NULL, NULL, NULL, 1, NULL, 1, 13, NULL, NULL, NULL, NULL, NULL, NULL, '14', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(9, 'Corn', 'seeds', 'corn', NULL, 'corn', 1, 5, 1, 0, 60, 4, 4, NULL, 72000, NULL, 5, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(10, 'Cheese Master', 'gear', 'cheese', NULL, 'cheese_machine', 45, 13, 1, 0, 4500, 8, 8, 90, 30, NULL, NULL, NULL, NULL, 1, NULL, 1, 8, NULL, NULL, NULL, NULL, NULL, NULL, '17', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(11, 'Chicken Coop', 'gear', 'chicken_coop', NULL, 'chicken_coop', 9, 6, 1, 0, 900, 10, 8, 20, 120, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, 1, '12', '13', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12, 'Chicken', 'animals', 'chicken', NULL, 'chicken', 3, 11, 0, 0, 250, NULL, NULL, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, 11, NULL, NULL, NULL),
(13, 'Corn', 'products', NULL, NULL, 'corn_p', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, NULL, NULL, NULL, NULL, 80, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(14, 'Tomatoes', 'products', NULL, NULL, 'tomatoes_p', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, 37, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(15, 'Clover', 'products', NULL, NULL, 'clover_p', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, NULL, NULL, NULL, NULL, 20, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(16, 'Wheat', 'products', NULL, NULL, 'wheat_p', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, 48, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(17, 'Milk', 'products', NULL, NULL, 'milk', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(18, 'Flour', 'products', NULL, NULL, 'flour', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6, NULL, NULL, NULL, NULL, 62, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(19, 'Ketchup', 'products', NULL, NULL, 'ketchup', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, NULL, NULL, NULL, NULL, 55, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(20, 'Cheese', 'products', NULL, NULL, 'cheese', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(21, 'Eggs', 'products', NULL, NULL, 'eggs', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11, NULL, NULL, NULL, NULL, 102, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(22, '', 'expand_ranch', NULL, NULL, 'expand-x17', 0, NULL, 0, 0, 15000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'expand', NULL, 68, NULL, NULL),
(23, '', 'expand_ranch', NULL, NULL, 'expand-x17', 550, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'expand', NULL, 68, NULL, NULL),
(24, '', 'expand_ranch', NULL, NULL, 'expand-x19', 0, NULL, 0, 0, 35000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'expand', NULL, 76, NULL, NULL),
(25, '', 'expand_ranch', NULL, NULL, 'expand-x19', 850, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'expand', NULL, 76, NULL, NULL),
(26, '', 'expand_ranch', NULL, NULL, 'expand-x21', 0, NULL, 0, 0, 75000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'expand', NULL, 84, NULL, NULL),
(27, '', 'expand_ranch', NULL, NULL, 'expand-x21', 1150, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 50, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'expand', NULL, 84, NULL, NULL),
(28, '', 'expand_ranch', NULL, NULL, 'expand-x23', 0, NULL, 0, 0, 150000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'expand', NULL, 92, NULL, NULL),
(29, '', 'expand_ranch', NULL, NULL, 'expand-x23', 1450, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 60, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'expand', NULL, 92, NULL, NULL),
(30, '', 'expand_ranch', NULL, NULL, 'expand-x25', 0, NULL, 0, 0, 350000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'expand', NULL, 100, NULL, NULL),
(31, '', 'expand_ranch', NULL, NULL, 'expand-x25', 1750, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 70, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'expand', NULL, 100, NULL, NULL),
(32, 'Carrots', 'seeds', NULL, NULL, 'carrots', 1, 8, 1, 0, 75, 4, 4, NULL, 28800, NULL, 5, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(33, 'Carrots', 'products', NULL, NULL, 'carrots_p', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(34, 'Angora Rabbit', 'animals', 'rabbit', NULL, 'rabbit', 35, 14, 1, 0, 3500, 8, 8, 70, 90, NULL, NULL, NULL, NULL, 1, NULL, 1, 12, NULL, NULL, NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '35', NULL, NULL, NULL, NULL, 8, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(35, 'Angora Hair', 'products', NULL, NULL, 'angora_hair', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 34, NULL, NULL, NULL, NULL, 94, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(36, 'Sheep', 'animals', 'sheep', NULL, 'sheep', 30, 12, 1, 0, 3000, 10, 8, 60, 90, NULL, NULL, NULL, NULL, 1, NULL, 1, 9, NULL, NULL, NULL, NULL, NULL, NULL, '16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '37', NULL, NULL, NULL, NULL, 7, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(37, 'Wool', 'products', NULL, NULL, 'wool', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 36, NULL, NULL, NULL, NULL, 63, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(38, 'Organic Fertilizer', 'special_events', 'fertilizer', 'reduce a crop''s growth time by 25% - 200 uses', 'fertilizer', 100, NULL, 1, 0, NULL, 2, 2, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.25', NULL, NULL, NULL, NULL, 8, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 200, 'fertilize', NULL, NULL, NULL, NULL),
(39, 'Organic Fertilizer', 'special_events', 'fertilizer', 'reduce a crop''s growth time by 25% - 450 uses', 'fertilizer', 250, NULL, 1, 0, NULL, 2, 2, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.25', NULL, NULL, NULL, NULL, 15, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 450, 'fertilize', NULL, NULL, NULL, NULL),
(40, 'Organic Fertilizer', 'special_events', 'fertilizer', 'reduce a crop''s growth time by 25% - 1000 uses', 'fertilizer', 450, NULL, 1, 0, NULL, 2, 2, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.25', NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1000, 'fertilize', NULL, NULL, NULL, NULL),
(41, 'Grapes', 'seeds', NULL, NULL, 'grapes', 1, 10, 1, 0, 105, 4, 4, NULL, 36000, NULL, 5, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(42, 'Grapes', 'products', NULL, NULL, 'grapes_p', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 41, NULL, NULL, NULL, NULL, 116, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(43, 'Winemaker', 'gear', 'wine', NULL, 'wine_machine', 55, 18, 1, 0, 5500, 8, 8, 110, 60, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(44, 'Wine', 'products', NULL, NULL, 'wine', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 43, NULL, NULL, NULL, NULL, 130, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(45, 'Beehive', 'animals', 'hive', NULL, 'hive', 20, 4, 1, 0, 2000, 4, 6, 40, 30, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '4', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '46', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(46, 'Honey', 'products', NULL, NULL, 'honey', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, NULL, 5, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(47, 'Starline Beehive', 'animals', 'hive', NULL, 'black_hive', 250, 1, 1, 0, NULL, 4, 6, 1500, 20, 1, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '4', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '46', 15, NULL, NULL, NULL, 2, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(48, 'Apple Tree', 'trees', 'apple', NULL, 'apple_tree', 4, 2, 1, 0, 415, 2, 2, 50, 57600, NULL, 5, NULL, NULL, NULL, NULL, 1, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '49', NULL, NULL, NULL, NULL, NULL, NULL, 1, 25, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(49, 'Apples', 'products', NULL, NULL, 'apples', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 48, NULL, NULL, NULL, NULL, 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(50, 'Hay Bale', 'decorations', NULL, NULL, 'hay_bale', 2, 3, 1, 1, 225, 3, 3, 25, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(51, 'Orchard Hay Bale', 'decorations', NULL, NULL, 'green_hay_bale', 25, 1, 1, 1, NULL, 3, 3, 200, NULL, 1, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL, NULL, NULL, 2, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(54, 'Wooden Barrel', 'decorations', NULL, NULL, 'wooden_barrel', 3, 5, 1, 1, 275, 3, 3, 35, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(55, 'Ayrshire Cow', 'animals', 'cow', NULL, 'cow_pink', 700, 1, 1, 0, NULL, 10, 12, 3500, 40, 1, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '17', 35, NULL, NULL, NULL, 4, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(56, 'Montbéliarde Cow', 'animals', 'cow', NULL, 'cow_brown', 1250, 1, 1, 0, NULL, 10, 12, 5500, 20, 1, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '17', 55, NULL, NULL, NULL, 5, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(57, 'Orange Tree', 'trees', 'orange', NULL, 'orange_tree', 8, 17, 1, 0, 850, 2, 2, 100, 72000, NULL, 5, NULL, NULL, NULL, NULL, 1, 17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '58', NULL, NULL, NULL, NULL, NULL, NULL, 1, 25, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(58, 'Oranges', 'products', NULL, NULL, 'oranges', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, NULL, 28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(59, 'Cherry Tree', 'trees', 'cherry', NULL, 'cherry_tree', 6, 9, 1, 0, 625, 2, 2, 75, 64800, NULL, 5, NULL, NULL, NULL, NULL, 1, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '60', NULL, NULL, NULL, NULL, NULL, NULL, 1, 25, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(60, 'Cherries', 'products', NULL, NULL, 'cherries', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 59, NULL, NULL, NULL, NULL, 20, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(61, 'Jam''r', 'gear', 'jam', NULL, 'jam_machine', 70, 20, 1, 0, 7000, 8, 8, 140, 60, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'a:2:{i:0;a:8:{i:0;i:42;i:1;i:49;i:2;i:58;i:3;i:60;i:4;i:84;i:5;i:86;i:6;i:88;i:7;i:133;}i:1;i:46;}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Jam', NULL, 'a:8:{i:0;i:62;i:1;i:63;i:2;i:64;i:3;i:65;i:4;i:89;i:5;i:90;i:6;i:91;i:7;i:134;}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(62, 'Grape Jam', 'products', NULL, NULL, 'grape_jam', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 61, NULL, NULL, NULL, NULL, 135, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(63, 'Apple Jam', 'products', NULL, NULL, 'apple_jam', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 61, NULL, NULL, NULL, NULL, 37, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(64, 'Orange Jam', 'products', NULL, NULL, 'orange_jam', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 61, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(65, 'Cherry Jam', 'products', NULL, NULL, 'cherry_jam', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 61, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(66, '', 'expand_ranch', NULL, NULL, 'expand-x27', 0, NULL, 0, 0, 750000, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'expand', NULL, 108, NULL, NULL),
(67, '', 'expand_ranch', NULL, NULL, 'expand-x27', 2100, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 80, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'expand', NULL, 108, NULL, NULL),
(68, '', 'expand_ranch', NULL, NULL, 'expand-x29', 0, NULL, 0, 0, 1500000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'expand', NULL, 116, NULL, NULL),
(69, '', 'expand_ranch', NULL, NULL, 'expand-x29', 2500, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 90, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'expand', NULL, 116, NULL, NULL),
(70, 'Baker', 'gear', 'bread', NULL, 'bread_machine', 85, 22, 1, 0, 8500, 8, 8, 170, 90, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'a:3:{i:0;a:1:{i:0;i:18;}i:1;i:21;i:2;i:17;}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Bread', NULL, 'a:1:{i:0;i:71;}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(71, 'Bread', 'products', NULL, NULL, 'bread', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 70, NULL, NULL, NULL, NULL, 285, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(72, '150 OP', 'automation', 'operations', '150 automatic\r\noperations', 'op_150', 10, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 150, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'automation', NULL, NULL, NULL, NULL),
(73, '500 OP', 'automation', 'operations', '500 automatic\r\noperations', 'op_500', 35, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 500, NULL, NULL, NULL, NULL, NULL, 3, NULL, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'automation', NULL, NULL, NULL, NULL),
(74, '1500 OP', 'automation', 'operations', '1500 automatic\r\noperations', 'op_1500', 85, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1500, NULL, NULL, NULL, NULL, NULL, 7, NULL, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'automation', NULL, NULL, NULL, NULL),
(75, '3500 OP', 'automation', 'operations', '3500 automatic\r\noperations', 'op_3500', 250, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3500, NULL, NULL, NULL, NULL, NULL, 15, NULL, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'automation', NULL, NULL, NULL, NULL),
(76, '7500 OP', 'automation', 'operations', '7500 automatic\r\noperations', 'op_7500', 550, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7500, NULL, NULL, NULL, NULL, NULL, 30, NULL, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'automation', NULL, NULL, NULL, NULL),
(77, '15000 OP', 'automation', 'operations', '15000 automatic\r\noperations', 'op_15000', 1150, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15000, NULL, NULL, NULL, NULL, NULL, 50, NULL, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'automation', NULL, NULL, NULL, NULL),
(78, 'Weaver', 'gear', 'textile', NULL, 'textile_machine', 105, 24, 1, 0, 10500, 8, 8, 230, 60, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'a:1:{i:0;a:2:{i:0;i:37;i:1;i:35;}}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Sweater', NULL, 'a:2:{i:0;i:79;i:1;i:80;}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(79, 'Wool Sweater', 'products', NULL, NULL, 'wool_sweater', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 78, NULL, NULL, NULL, NULL, 95, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(80, 'Angora Sweater', 'products', NULL, NULL, 'angora_sweater', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 78, NULL, NULL, NULL, NULL, 118, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(81, 'Banana Tree', 'trees', 'bananas', NULL, 'banana_tree', 9, 21, 1, 0, 975, 2, 2, 120, 79200, NULL, 5, NULL, NULL, NULL, NULL, 1, 22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '82', NULL, NULL, NULL, NULL, NULL, NULL, 1, 25, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(82, 'Bananas', 'products', NULL, NULL, 'bananas', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 48, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(83, 'Blueberries', 'seeds', 'blueberry', NULL, 'blueberries', 1, 19, 1, 0, 85, 4, 4, NULL, 10800, NULL, 5, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '84', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(84, 'Blueberries', 'products', NULL, NULL, 'blueberries_p', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 83, NULL, NULL, NULL, NULL, 91, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(85, 'Blackberries', 'seeds', 'blackberry', NULL, 'blackberries', 1, 23, 1, 0, 125, 4, 4, NULL, 21600, NULL, 5, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '86', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(86, 'Blackberries', 'products', NULL, NULL, 'blackberries_p', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 85, NULL, NULL, NULL, NULL, 135, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(87, 'Raspberries', 'seeds', 'raspberry', NULL, 'raspberries', 1, 27, 1, 0, 95, 4, 4, NULL, 18000, NULL, 5, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '88', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(88, 'Raspberries', 'products', NULL, NULL, 'raspberries_p', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 87, NULL, NULL, NULL, NULL, 104, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(89, 'Blueberry Jam', 'products', NULL, NULL, 'blueberry_jam', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 61, NULL, NULL, NULL, NULL, 97, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(90, 'Blackberry Jam', 'products', NULL, NULL, 'blackberry_jam', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 61, NULL, NULL, NULL, NULL, 145, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(91, 'Raspberry Jam', 'products', NULL, NULL, 'raspberry_jam', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 61, NULL, NULL, NULL, NULL, 113, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(92, 'Milky White Fence', 'decorations', 'fence', NULL, 'fence', 3, 4, 1, 1, 375, 6, 1, 8, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(93, 'Greenhouse', 'buildings', 'greenhouse', 'reduce growth time for crops inside by 40%', 'greenhouse_big', 150, 10, 1, 0, 15000, 18, 26, 1500, NULL, NULL, NULL, 1, NULL, 1, NULL, 0, NULL, NULL, '0.4', NULL, NULL, NULL, NULL, '4', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'a:2:{i:0;O:8:"stdClass":2:{s:2:"id";i:121;s:3:"qty";i:30;}i:1;O:8:"stdClass":2:{s:2:"id";i:122;s:3:"qty";i:20;}}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(94, 'Ruby Red Fence', 'decorations', 'fence', NULL, 'fence_red', 7, 20, 1, 1, 750, 6, 1, 16, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(95, 'Space Black Fence', 'decorations', 'fence', NULL, 'fence_black', 7, 10, 1, 1, 750, 6, 1, 16, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(96, 'Yosemite Blue Fence', 'decorations', 'fence', NULL, 'fence_blue', 7, 15, 1, 1, 750, 6, 1, 16, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(97, 'Bumble Bee Yellow Fence', 'decorations', 'fence', NULL, 'fence_yellow', 7, 17, 1, 1, 750, 6, 1, 16, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(98, 'Amazon Green Fence', 'decorations', 'fence', NULL, 'fence_green', 7, 13, 1, 1, 750, 6, 1, 16, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(99, 'Choco Brown Fence', 'decorations', 'fence', NULL, 'fence_brown', 7, 7, 1, 1, 750, 6, 1, 16, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(100, 'Woodpile', 'decorations', 'woodpile', NULL, 'woodpile', 6, 12, 1, 1, 650, 4, 4, 13, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(101, 'Fire Pit', 'decorations', 'fire_pit', NULL, 'fire_pit', 165, 1, 1, 1, NULL, 4, 4, 1100, NULL, 1, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11, NULL, NULL, NULL, 13, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(102, 'Birdbath', 'decorations', 'birdbath', NULL, 'birdbath', 150, 30, 1, 1, 15000, 2, 2, 300, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(103, 'Lamp Post', 'decorations', 'lamp_post', NULL, 'lamp_post', 75, 25, 1, 1, 7500, 2, 2, 150, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(104, 'Garden Lantern', 'decorations', 'garden_lantern', NULL, 'garden_lantern', 450, 1, 1, 1, NULL, 2, 2, 2500, NULL, 1, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, 21, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(105, 'Bird Feeder', 'decorations', 'bird_feeder', NULL, 'bird_feeder', 42, 26, 1, 1, 4200, 2, 2, 84, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(107, 'Watering Can', 'decorations', 'watering_can', NULL, 'watering_can', 12, 18, 1, 1, 1250, 2, 2, 25, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(108, 'Picnic Basket', 'decorations', 'picnic_basket', NULL, 'picnic_basket', 28, 8, 1, 1, 2800, 2, 2, 56, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(109, 'Sundial', 'decorations', 'sundial', NULL, 'sundial', 23, 19, 1, 1, 2300, 2, 2, 46, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(110, 'Wagon Wheel', 'decorations', 'wagon_wheel', NULL, 'wagon_wheel_flowers', 350, 1, 1, 1, NULL, 4, 2, 1800, NULL, 1, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18, NULL, NULL, NULL, 23, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(111, 'Wagon Wheel', 'decorations', 'wagon_wheel', NULL, 'wagon_wheel_pole', 350, 1, 1, 1, NULL, 2, 4, 1800, NULL, 1, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18, NULL, NULL, NULL, 24, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(112, 'Ranch Bell', 'decorations', 'ranch_bell', NULL, 'ranch_bell', 37, 11, 1, 1, 3750, 2, 4, 75, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(113, 'Axe and Block', 'decorations', 'axe_and_block', NULL, 'axe_and_block', 275, 1, 1, 1, NULL, 2, 2, 1500, NULL, 1, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15, NULL, NULL, NULL, 15, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(114, 'Small Yard', 'expand_ranch', NULL, 'Accepts trees, machines, animals and decorations', 'expand-north', 2800, NULL, 0, 0, 150000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'expand_top_map', NULL, 8, NULL, NULL),
(115, 'Small Yard', 'expand_ranch', NULL, 'Accepts trees, machines, animals and decorations', 'expand-north', 2800, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 60, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'expand_top_map', NULL, 8, NULL, NULL),
(116, 'Medium Yard', 'expand_ranch', NULL, 'Accepts trees, machines, animals and decorations', 'expand-north', 3200, NULL, 0, 0, 350000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'expand_top_map', NULL, 16, NULL, NULL),
(117, 'Medium Yard', 'expand_ranch', NULL, 'Accepts trees, machines, animals and decorations', 'expand-north', 3200, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 70, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'expand_top_map', NULL, 16, NULL, NULL),
(118, 'Large Yard', 'expand_ranch', NULL, 'Accepts trees, machines, animals and decorations', 'expand-north', 3700, NULL, 0, 0, 750000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'expand_top_map', NULL, 24, NULL, NULL),
(119, 'Large Yard', 'expand_ranch', NULL, 'Accepts trees, machines, animals and decorations', 'expand-north', 3700, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 80, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'expand_top_map', NULL, 24, NULL, NULL),
(120, '25 OP', 'automation', 'operations', '25 automatic\r\noperations', 'op_25', 0, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 10, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'automation', NULL, NULL, NULL, NULL),
(121, 'Glass Pane', 'materials', 'glass_pane', 'needed for Greenhouse', 'glass_pane', 10, 10, 0, 1, NULL, NULL, NULL, 100, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 11, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL, 'construction', NULL, NULL, NULL, NULL),
(122, 'Pipe Stack', 'materials', 'pipe_stack', 'needed for Greenhouse', 'pipe_stack', 10, 10, 0, 1, NULL, NULL, NULL, 100, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 11, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL, 'construction', NULL, NULL, NULL, NULL),
(123, 'Brick Mill', 'buildings', 'multi_mill', NULL, 'mill_brown', 95, 15, 1, 0, 9500, 10, 12, 190, 35, NULL, NULL, 1, NULL, 1, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'a:1:{i:0;a:2:{i:0;i:13;i:1;i:16;}}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Flour', 'a:7:{i:0;O:8:"stdClass":2:{s:2:"id";i:124;s:3:"qty";i:35;}i:1;O:8:"stdClass":2:{s:2:"id";i:130;s:3:"qty";i:25;}i:2;O:8:"stdClass":2:{s:2:"id";i:131;s:3:"qty";i:18;}i:3;O:8:"stdClass":2:{s:2:"id";i:129;s:3:"qty";i:4;}i:4;O:8:"stdClass":2:{s:2:"id";i:125;s:3:"qty";i:1;}i:5;O:8:"stdClass":2:{s:2:"id";i:127;s:3:"qty";i:1;}i:6;O:8:"stdClass":2:{s:2:"id";i:128;s:3:"qty";i:1;}}', 'a:2:{i:0;i:126;i:1;i:18;}', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(124, 'Brick', 'materials', 'brick', 'needed for Brick Mill', 'brick', 10, 15, 0, 1, NULL, NULL, NULL, 100, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 16, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL, 'construction', NULL, NULL, NULL, NULL),
(125, 'Cogwheel', 'materials', 'cogwheel', 'needed for Brick Mill', 'cogwheel', 100, 15, 0, 1, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, 10, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL, NULL, NULL, 250, NULL, NULL, NULL, NULL, 'construction', NULL, NULL, NULL, NULL),
(126, 'Cornmeal', 'products', NULL, NULL, 'cornmeal', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 123, NULL, NULL, NULL, NULL, 105, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(127, 'Shaft', 'materials', 'connector_shaft', 'needed for Brick Mill', 'connector_shaft', 100, 15, 0, 1, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, 10, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL, NULL, NULL, 250, NULL, NULL, NULL, NULL, 'construction', NULL, NULL, NULL, NULL),
(128, 'Grinding Stone', 'materials', 'grinding_stone', 'needed for Brick Mill', 'grinding_stone', 150, 15, 0, 1, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, 15, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15, NULL, NULL, NULL, NULL, NULL, NULL, 375, NULL, NULL, NULL, NULL, 'construction', NULL, NULL, NULL, NULL),
(129, 'Sail', 'materials', 'sail', 'needed for Brick Mill', 'sail', 30, 15, 0, 1, NULL, NULL, NULL, 150, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 16, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL, 'construction', NULL, NULL, NULL, NULL),
(130, 'Shingle Tile', 'materials', 'shingle_tile', 'needed for Brick Mill', 'shingle_tile', 10, 15, 0, 1, NULL, NULL, NULL, 100, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 16, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL, 'construction', NULL, NULL, NULL, NULL),
(131, 'Wood Beam', 'materials', 'wooden_beam', 'needed for Brick Mill, Water Well', 'wooden_beam', 10, 15, 0, 1, NULL, NULL, NULL, 100, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 16, 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL, 'construction', NULL, NULL, NULL, NULL),
(132, 'Strawberries', 'seeds', 'strawberry', NULL, 'strawberries', 1, 29, 1, 0, 185, 4, 4, NULL, 32400, NULL, 5, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '133', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(133, 'Strawberries', 'products', NULL, NULL, 'strawberries_p', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 132, NULL, NULL, NULL, NULL, 199, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(134, 'Strawberry Jam', 'products', NULL, NULL, 'strawberry_jam', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 61, NULL, NULL, NULL, NULL, 214, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(135, 'Azalea Pink Fence', 'decorations', 'fence', NULL, 'fence_pink', 7, 23, 1, 1, 750, 6, 1, 16, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(136, 'A-Frame house', 'buildings', 'house', NULL, 'a_frame_house', 2350, 25, 1, 1, 235000, 12, 10, 4700, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(137, 'Cottage', 'buildings', 'house', NULL, 'cottage', 900, 16, 1, 1, 90000, 7, 9, 1800, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(138, 'Eco House', 'buildings', 'house', NULL, 'eco_house', 3750, 33, 1, 1, 375000, 9, 11, 7500, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `tbl_store` (`id`, `name`, `type`, `kind`, `desc`, `url`, `exp`, `level`, `map_object`, `buyable`, `price`, `size_x`, `size_y`, `sell_price`, `collect_in`, `buy_gift`, `stages`, `constructible`, `depth`, `flipable`, `friends_needed`, `giftable`, `gift_level`, `gift_priority`, `growing_percent`, `is_multi`, `is_tall`, `need_animals`, `animal`, `raw_material`, `max_animals`, `max_instances`, `neighbors`, `not_in_popup`, `object_needed`, `op`, `percent`, `producer`, `product_name`, `materials`, `product`, `rp_price`, `sell_for`, `show_name`, `sprinkler`, `store_pos`, `story`, `tall_object`, `trade_for`, `tree_spacing`, `upgradeable`, `upgrade_levels`, `uses`, `action`, `add_on`, `size`, `complete_size_x`, `complete_size_y`) VALUES
(139, 'Log Cabin', 'buildings', 'house', NULL, 'log_cabin', 5250, 37, 1, 1, 525000, 12, 12, 10500, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(140, 'Manor', 'buildings', 'house', NULL, 'manor', 12500, 43, 1, 1, 1250000, 16, 15, 25000, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(141, 'Water Well', 'buildings', 'water_well', 'reduce growth time for irrigated crops by 15%', 'water_well', 250, 20, 1, 1, 25000, 8, 8, 2500, NULL, NULL, NULL, 1, 'O:8:"stdClass":5:{i:1;i:50;i:2;i:75;i:3;i:125;i:4;i:200;i:5;i:300;}', 1, NULL, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'a:5:{i:0;O:8:"stdClass":2:{s:2:"id";i:144;s:3:"qty";i:25;}i:1;O:8:"stdClass":2:{s:2:"id";i:131;s:3:"qty";i:8;}i:2;O:8:"stdClass":2:{s:2:"id";i:143;s:3:"qty";i:15;}i:3;O:8:"stdClass":2:{s:2:"id";i:145;s:3:"qty";i:1;}i:4;O:8:"stdClass":2:{s:2:"id";i:146;s:3:"qty";i:1;}}', NULL, NULL, NULL, NULL, 142, NULL, NULL, NULL, NULL, NULL, 1, 'O:8:"stdClass":4:{i:2;a:2:{i:0;O:8:"stdClass":2:{s:2:"id";i:144;s:3:"qty";i:25;}i:1;O:8:"stdClass":2:{s:2:"id";i:143;s:3:"qty";i:15;}}i:3;a:2:{i:0;O:8:"stdClass":2:{s:2:"id";i:144;s:3:"qty";i:35;}i:1;O:8:"stdClass":2:{s:2:"id";i:143;s:3:"qty";i:25;}}i:4;a:2:{i:0;O:8:"stdClass":2:{s:2:"id";i:144;s:3:"qty";i:45;}i:1;O:8:"stdClass":2:{s:2:"id";i:143;s:3:"qty";i:35;}}i:5;a:2:{i:0;O:8:"stdClass":2:{s:2:"id";i:144;s:3:"qty";i:55;}i:1;O:8:"stdClass":2:{s:2:"id";i:143;s:3:"qty";i:45;}}}', NULL, NULL, NULL, NULL, 4, 8),
(142, 'Sprinkler', 'materials', 'sprinkler', 'needed for irrigation', 'sprinkler', 10, 20, 0, 1, NULL, NULL, NULL, 100, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 21, 10, '0.15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 141, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, 'sprinkler', NULL, 10, NULL, NULL, NULL, NULL, 'irrigation', NULL, NULL, NULL, NULL),
(143, 'Irrigation Pipes', 'materials', 'irrigation_pipes', 'needed for Water Well', 'irrigation_pipes', 10, 20, 0, 1, NULL, NULL, NULL, 100, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 21, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL, 'construction', NULL, NULL, NULL, NULL),
(144, 'Stone', 'materials', 'stone', 'needed for Water Well', 'stone', 10, 20, 0, 1, NULL, NULL, NULL, 100, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 21, 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL, 'construction', NULL, NULL, NULL, NULL),
(145, 'Water Pump', 'materials', 'water_pump', 'needed for Water Well', 'water_pump', 150, 20, 0, 1, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, 15, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15, NULL, NULL, NULL, NULL, 'help_friend_well', NULL, 375, NULL, NULL, NULL, NULL, 'construction', NULL, NULL, NULL, NULL),
(146, 'Drill Gear', 'materials', 'drill_gear', 'needed for Water Well', 'drill_gear', 200, 20, 0, 1, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, 20, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20, NULL, NULL, NULL, NULL, 'help_friend_well', NULL, 500, NULL, NULL, NULL, NULL, 'construction', NULL, NULL, NULL, NULL),
(147, 'Potatoes', 'seeds', 'potato', NULL, 'potatoes', 1, 32, 1, 0, 115, 4, 4, NULL, 64800, NULL, 5, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '148', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(148, 'Potatoes', 'products', NULL, NULL, 'potatoes_p', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 33, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 147, NULL, NULL, NULL, NULL, 135, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(149, 'Green Lettuce', 'seeds', 'green_lettuce', NULL, 'green_lettuce', 1, 35, 1, 0, 160, 4, 4, NULL, 28800, NULL, 5, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '150', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(150, 'Green Lettuce', 'products', NULL, NULL, 'green_lettuce_p', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 149, NULL, NULL, NULL, NULL, 170, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(151, 'Red Peppers', 'seeds', 'red_peppers', NULL, 'red_peppers', 1, 39, 1, 0, 225, 4, 4, NULL, 50400, NULL, 5, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '152', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(152, 'Red Peppers', 'products', NULL, NULL, 'red_peppers_p', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 40, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 151, NULL, NULL, NULL, NULL, 245, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(153, 'Pumpkins', 'seeds', 'pumpkins', NULL, 'pumpkins', 1, 45, 1, 0, 260, 4, 4, NULL, 54000, NULL, 5, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '154', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(154, 'Pumpkins', 'products', NULL, NULL, 'pumpkins_p', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 153, NULL, NULL, NULL, NULL, 282, NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(155, 'Cool Packer', 'gear', 'packing', NULL, 'packing_machine', 125, 28, 1, 0, 12500, 4, 12, 140, 45, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'a:1:{i:0;a:4:{i:0;i:33;i:1;i:150;i:2;i:152;i:3;i:148;}}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Pack', NULL, 'a:4:{i:0;i:156;i:1;i:157;i:2;i:158;i:3;i:159;}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(156, 'Packed Carrots', 'products', NULL, NULL, 'carrots_pack', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 155, NULL, NULL, NULL, NULL, 100, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(157, 'Packed Lettuce', 'products', NULL, NULL, 'green_lettuce_pack', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 155, NULL, NULL, NULL, NULL, 185, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(158, 'Packed Peppers', 'products', NULL, NULL, 'peppers_pack', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 155, NULL, NULL, NULL, NULL, 270, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(159, 'Packed Potatoes', 'products', NULL, NULL, 'potatoes_pack', 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 155, NULL, NULL, NULL, NULL, 165, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user`
--

DROP TABLE IF EXISTS `tbl_user`;
CREATE TABLE IF NOT EXISTS `tbl_user` (
  `uid` varchar(20) NOT NULL COMMENT '用户UID',
  `uname` varchar(30) NOT NULL COMMENT '用户名称',
  `email` varchar(50) NOT NULL COMMENT 'email地址',
  `plat_uid` varchar(30) NOT NULL COMMENT '平台用户ID',
  `level` smallint(3) NOT NULL default '1' COMMENT '等级',
  `experience` int(10) NOT NULL default '0' COMMENT '经验',
  `coins` int(10) NOT NULL default '0' COMMENT '金币',
  `reward_points` int(10) NOT NULL default '0' COMMENT '农场金币',
  `op` int(10) NOT NULL default '0' COMMENT '自动化工具数',
  `addtime` datetime NOT NULL COMMENT '注册时间',
  `logintime` datetime NOT NULL COMMENT '最后登录时间',
  `loginip` varchar(15) NOT NULL COMMENT '登录IP',
  `status` tinyint(1) NOT NULL COMMENT '用户状态',
  PRIMARY KEY  (`uid`),
  UNIQUE KEY `plat_uid` (`plat_uid`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户数据表';

--
-- Dumping data for table `tbl_user`
--

INSERT INTO `tbl_user` (`uid`, `uname`, `email`, `plat_uid`, `level`, `experience`, `coins`, `reward_points`, `op`, `addtime`, `logintime`, `loginip`, `status`) VALUES
('1560424778', '1560424778', '', '1560424778', 10, 10000, 10000, 10000, 10000, '2010-07-31 16:50:14', '2010-07-31 16:50:14', '', 1),
('703118330', 'test', 'test@test.com', '1000000', 30, 20810, 38726, 5660, 5660, '2010-07-21 21:20:48', '2010-07-21 21:20:51', '', 1),
('803118331', '803118331', '', '803118331', 1, 0, 0, 0, 0, '2010-07-31 23:47:56', '2010-07-31 23:47:56', '', 1);
