# 对GEAR的更新 导入一下sql，并删除已有的GEAR地图数据或者将is_multi更新为1

ALTER TABLE `tbl_map` CHANGE `products` `products` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' COMMENT '产品数量',
CHANGE `raw_materials` `raw_materials` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' COMMENT '饲料数量' ;


ALTER TABLE `tbl_map` ADD `is_multi` TINYINT( 1 ) UNSIGNED NOT NULL DEFAULT '0' COMMENT '是否多产品' AFTER `raw_materials` ;

UPDATE `tbl_map` SET is_multi =1 WHERE `itemid` IN (SELECT `id` FROM `tbl_store` WHERE `is_multi` =1) ;