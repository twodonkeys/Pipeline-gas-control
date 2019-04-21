/*
 Navicat Premium Data Transfer

 Source Server         : gw
 Source Server Type    : MySQL
 Source Server Version : 50725
 Source Host           : localhost:3306
 Source Schema         : gw

 Target Server Type    : MySQL
 Target Server Version : 50725
 File Encoding         : 65001

 Date: 21/04/2019 16:43:16
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for abb2mysql
-- ----------------------------
DROP TABLE IF EXISTS `abb2mysql`;
CREATE TABLE `abb2mysql`  (
  `ID` int(4) NOT NULL AUTO_INCREMENT,
  `gl` int(4) NOT NULL,
  `rfl` int(4) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `slsj_sp` float(8, 1) NOT NULL,
  `slsj` float(8, 1) NOT NULL,
  `sfsj_sp` float(8, 1) NOT NULL,
  `sfsj` float(8, 1) NOT NULL,
  `fqwd_sp` float(8, 1) NOT NULL,
  `fqwd` float(8, 1) NOT NULL,
  `sfwd_sp` float(8, 1) NOT NULL,
  `sfwd` float(8, 1) NOT NULL,
  `zgyl_sp` float(8, 1) NOT NULL,
  `zgyl` float(8, 1) NOT NULL,
  `slsj_bias` float GENERATED ALWAYS AS ((`slsj_sp` - `slsj`)) STORED NULL,
  `sfsj_bias` float GENERATED ALWAYS AS ((`sfsj_sp` - `sfsj`)) STORED NULL,
  `fqwd_bias` float GENERATED ALWAYS AS ((`fqwd_sp` - `fqwd`)) STORED NULL,
  `sfwd_bias` float GENERATED ALWAYS AS ((`sfwd_sp` - `sfwd`)) STORED NULL,
  `zgyl_bias` float GENERATED ALWAYS AS ((`zgyl_sp` - `zgyl`)) STORED NULL,
  `hlsj` float(8, 0) NOT NULL,
  `slsj_next_wait` float GENERATED ALWAYS AS ((`slsj_bias` + `hlsj`)) STORED NULL,
  `biasb_current` float(4, 2) NOT NULL DEFAULT 0.50,
  `biasb_next` float(4, 2) NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `rfl_num`(`rfl`) USING BTREE,
  INDEX `gl_num`(`gl`) USING BTREE,
  CONSTRAINT `gl_num` FOREIGN KEY (`gl`) REFERENCES `gl` (`gl`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `rfl_num` FOREIGN KEY (`rfl`) REFERENCES `rfl` (`rfl`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of abb2mysql
-- ----------------------------
INSERT INTO `abb2mysql` VALUES (1, 1, 11, 1, 60.0, 45.0, 60.0, 10.0, 400.0, 300.0, 1080.0, 1050.0, 16.0, 15.0, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, 15, DEFAULT, 1.00, 0.20);
INSERT INTO `abb2mysql` VALUES (2, 1, 12, 1, 60.0, 5.0, 60.0, 9.0, 400.0, 300.0, 1080.0, 1050.0, 16.0, 15.0, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, 13, DEFAULT, 0.50, 0.20);
INSERT INTO `abb2mysql` VALUES (3, 1, 13, 0, 60.0, 0.0, 60.0, 8.0, 400.0, 300.0, 1080.0, 1050.0, 16.0, 15.0, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, 10, DEFAULT, 0.50, 0.20);
INSERT INTO `abb2mysql` VALUES (4, 2, 21, 1, 60.0, 10.0, 60.0, 7.0, 400.0, 300.0, 1080.0, 1050.0, 16.0, 15.0, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, 8, DEFAULT, 0.50, 0.20);
INSERT INTO `abb2mysql` VALUES (5, 2, 22, 0, 60.0, 0.0, 60.0, 6.0, 400.0, 300.0, 1080.0, 1050.0, 16.0, 15.0, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, 15, DEFAULT, 0.50, 0.20);
INSERT INTO `abb2mysql` VALUES (6, 2, 23, 1, 60.0, 59.0, 60.0, 5.0, 400.0, 300.0, 1080.0, 1050.0, 16.0, 15.0, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, 10, DEFAULT, 0.50, 0.20);
INSERT INTO `abb2mysql` VALUES (7, 3, 31, 0, 90.0, 0.0, 90.0, 4.0, 400.0, 300.0, 1080.0, 1050.0, 16.0, 15.0, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, 15, DEFAULT, 0.50, 0.20);
INSERT INTO `abb2mysql` VALUES (8, 3, 32, 0, 90.0, 0.0, 90.0, 3.0, 400.0, 300.0, 1080.0, 1050.0, 16.0, 15.0, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, 13, DEFAULT, 0.50, 0.20);
INSERT INTO `abb2mysql` VALUES (9, 3, 33, 1, 90.0, 75.0, 90.0, 2.0, 400.0, 300.0, 1080.0, 1050.0, 16.0, 15.0, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, 15, DEFAULT, 0.50, 0.20);
INSERT INTO `abb2mysql` VALUES (10, 3, 34, 1, 90.0, 10.0, 90.0, 1.0, 400.0, 300.0, 1080.0, 1050.0, 16.0, 15.0, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, 14, DEFAULT, 0.50, 0.20);

-- ----------------------------
-- Table structure for gl
-- ----------------------------
DROP TABLE IF EXISTS `gl`;
CREATE TABLE `gl`  (
  `ID` int(64) NOT NULL AUTO_INCREMENT,
  `gl` int(4) NOT NULL,
  `mode` int(4) NOT NULL DEFAULT 2,
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `gl`(`gl`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gl
-- ----------------------------
INSERT INTO `gl` VALUES (1, 1, 2);
INSERT INTO `gl` VALUES (2, 2, 2);
INSERT INTO `gl` VALUES (3, 3, 2);

-- ----------------------------
-- Table structure for history_11
-- ----------------------------
DROP TABLE IF EXISTS `history_11`;
CREATE TABLE `history_11`  (
  `ID` int(24) NOT NULL AUTO_INCREMENT,
  `TIME` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `slsj` float(8, 1) UNSIGNED NOT NULL,
  `sfsj` float(8, 1) NOT NULL,
  `sfwd` float(8, 1) NOT NULL,
  `fqwd` float(8, 1) NOT NULL,
  `zgyl` float(8, 1) NOT NULL,
  `hlsj` float(8, 1) NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for history_12
-- ----------------------------
DROP TABLE IF EXISTS `history_12`;
CREATE TABLE `history_12`  (
  `ID` int(24) NOT NULL AUTO_INCREMENT,
  `TIME` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `slsj` float(8, 1) UNSIGNED NOT NULL,
  `sfsj` float(8, 1) NOT NULL,
  `sfwd` float(8, 1) NOT NULL,
  `fqwd` float(8, 1) NOT NULL,
  `zgyl` float(8, 1) NOT NULL,
  `hlsj` float(8, 1) NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for history_13
-- ----------------------------
DROP TABLE IF EXISTS `history_13`;
CREATE TABLE `history_13`  (
  `ID` int(24) NOT NULL AUTO_INCREMENT,
  `TIME` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `slsj` float(8, 1) UNSIGNED NOT NULL,
  `sfsj` float(8, 1) NOT NULL,
  `sfwd` float(8, 1) NOT NULL,
  `fqwd` float(8, 1) NOT NULL,
  `zgyl` float(8, 1) NOT NULL,
  `hlsj` float(8, 1) NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for history_21
-- ----------------------------
DROP TABLE IF EXISTS `history_21`;
CREATE TABLE `history_21`  (
  `ID` int(24) NOT NULL AUTO_INCREMENT,
  `TIME` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `slsj` float(8, 1) UNSIGNED NOT NULL,
  `sfsj` float(8, 1) NOT NULL,
  `sfwd` float(8, 1) NOT NULL,
  `fqwd` float(8, 1) NOT NULL,
  `zgyl` float(8, 1) NOT NULL,
  `hlsj` float(8, 1) NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for history_22
-- ----------------------------
DROP TABLE IF EXISTS `history_22`;
CREATE TABLE `history_22`  (
  `ID` int(24) NOT NULL AUTO_INCREMENT,
  `TIME` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `slsj` float(8, 1) UNSIGNED NOT NULL,
  `sfsj` float(8, 1) NOT NULL,
  `sfwd` float(8, 1) NOT NULL,
  `fqwd` float(8, 1) NOT NULL,
  `zgyl` float(8, 1) NOT NULL,
  `hlsj` float(8, 1) NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for history_23
-- ----------------------------
DROP TABLE IF EXISTS `history_23`;
CREATE TABLE `history_23`  (
  `ID` int(24) NOT NULL AUTO_INCREMENT,
  `TIME` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `slsj` float(8, 1) UNSIGNED NOT NULL,
  `sfsj` float(8, 1) NOT NULL,
  `sfwd` float(8, 1) NOT NULL,
  `fqwd` float(8, 1) NOT NULL,
  `zgyl` float(8, 1) NOT NULL,
  `hlsj` float(8, 1) NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for history_31
-- ----------------------------
DROP TABLE IF EXISTS `history_31`;
CREATE TABLE `history_31`  (
  `ID` int(24) NOT NULL AUTO_INCREMENT,
  `TIME` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `slsj` float(8, 1) UNSIGNED NOT NULL,
  `sfsj` float(8, 1) NOT NULL,
  `sfwd` float(8, 1) NOT NULL,
  `fqwd` float(8, 1) NOT NULL,
  `zgyl` float(8, 1) NOT NULL,
  `hlsj` float(8, 1) NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for history_32
-- ----------------------------
DROP TABLE IF EXISTS `history_32`;
CREATE TABLE `history_32`  (
  `ID` int(24) NOT NULL AUTO_INCREMENT,
  `TIME` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `slsj` float(8, 1) UNSIGNED NOT NULL,
  `sfsj` float(8, 1) NOT NULL,
  `sfwd` float(8, 1) NOT NULL,
  `fqwd` float(8, 1) NOT NULL,
  `zgyl` float(8, 1) NOT NULL,
  `hlsj` float(8, 1) NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for history_33
-- ----------------------------
DROP TABLE IF EXISTS `history_33`;
CREATE TABLE `history_33`  (
  `ID` int(24) NOT NULL AUTO_INCREMENT,
  `TIME` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `slsj` float(8, 1) UNSIGNED NOT NULL,
  `sfsj` float(8, 1) NOT NULL,
  `sfwd` float(8, 1) NOT NULL,
  `fqwd` float(8, 1) NOT NULL,
  `zgyl` float(8, 1) NOT NULL,
  `hlsj` float(8, 1) NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for history_34
-- ----------------------------
DROP TABLE IF EXISTS `history_34`;
CREATE TABLE `history_34`  (
  `ID` int(24) NOT NULL AUTO_INCREMENT,
  `TIME` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `slsj` float(8, 1) UNSIGNED NOT NULL,
  `sfsj` float(8, 1) NOT NULL,
  `sfwd` float(8, 1) NOT NULL,
  `fqwd` float(8, 1) NOT NULL,
  `zgyl` float(8, 1) NOT NULL,
  `hlsj` float(8, 1) NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for py2mysql
-- ----------------------------
DROP TABLE IF EXISTS `py2mysql`;
CREATE TABLE `py2mysql`  (
  `ID` int(64) NOT NULL AUTO_INCREMENT,
  `add` tinyint(1) NOT NULL DEFAULT 1,
  `sub` tinyint(1) NOT NULL DEFAULT 1,
  `sum` int(4) NOT NULL,
  `b` int(4) NOT NULL,
  `sum_bias` int(11) GENERATED ALWAYS AS ((`sum` - `b`)) STORED NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of py2mysql
-- ----------------------------
INSERT INTO `py2mysql` VALUES (1, 1, 1, 6, 6, DEFAULT);

-- ----------------------------
-- Table structure for py2mysql_sf
-- ----------------------------
DROP TABLE IF EXISTS `py2mysql_sf`;
CREATE TABLE `py2mysql_sf`  (
  `ID` int(4) NOT NULL AUTO_INCREMENT,
  `rfl_sf` int(4) NOT NULL DEFAULT 0,
  `sfsj_left` float(8, 0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `rfl_sl`(`rfl_sf`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of py2mysql_sf
-- ----------------------------
INSERT INTO `py2mysql_sf` VALUES (1, 13, 52);
INSERT INTO `py2mysql_sf` VALUES (2, 22, 54);
INSERT INTO `py2mysql_sf` VALUES (3, 31, 86);
INSERT INTO `py2mysql_sf` VALUES (4, 32, 87);
INSERT INTO `py2mysql_sf` VALUES (5, 0, 0);
INSERT INTO `py2mysql_sf` VALUES (6, 0, 0);
INSERT INTO `py2mysql_sf` VALUES (7, 0, 0);
INSERT INTO `py2mysql_sf` VALUES (8, 0, 0);
INSERT INTO `py2mysql_sf` VALUES (9, 0, 0);
INSERT INTO `py2mysql_sf` VALUES (10, 0, 0);

-- ----------------------------
-- Table structure for py2mysql_sl
-- ----------------------------
DROP TABLE IF EXISTS `py2mysql_sl`;
CREATE TABLE `py2mysql_sl`  (
  `ID` int(4) NOT NULL AUTO_INCREMENT,
  `rfl_sl` int(4) NOT NULL DEFAULT 0,
  `slsj_current_left` float(8, 0) NOT NULL,
  `slsj_next_wait` float(8, 0) NOT NULL,
  `bias` float(8, 0) NOT NULL DEFAULT 0,
  `bias_modified` float(8, 0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `rfl_sl`(`rfl_sl`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of py2mysql_sl
-- ----------------------------
INSERT INTO `py2mysql_sl` VALUES (1, 23, 1, 11, 0, 0);
INSERT INTO `py2mysql_sl` VALUES (2, 11, 15, 30, -4, -3);
INSERT INTO `py2mysql_sl` VALUES (3, 33, 15, 30, 15, 7);
INSERT INTO `py2mysql_sl` VALUES (4, 21, 50, 58, -20, -1);
INSERT INTO `py2mysql_sl` VALUES (5, 12, 55, 68, 3, 1);
INSERT INTO `py2mysql_sl` VALUES (6, 34, 80, 94, -12, 0);
INSERT INTO `py2mysql_sl` VALUES (7, 0, 0, 0, 0, 0);
INSERT INTO `py2mysql_sl` VALUES (8, 0, 0, 0, 0, 0);
INSERT INTO `py2mysql_sl` VALUES (9, 0, 0, 0, 0, 0);
INSERT INTO `py2mysql_sl` VALUES (10, 0, 0, 0, 0, 0);

-- ----------------------------
-- Table structure for rfl
-- ----------------------------
DROP TABLE IF EXISTS `rfl`;
CREATE TABLE `rfl`  (
  `ID` int(4) NOT NULL,
  `rfl` int(4) NOT NULL,
  `gl_num` int(4) NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `rlf`(`rfl`) USING BTREE,
  INDEX `gl_num`(`gl_num`) USING BTREE,
  CONSTRAINT `rfl_ibfk_1` FOREIGN KEY (`gl_num`) REFERENCES `gl` (`gl`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of rfl
-- ----------------------------
INSERT INTO `rfl` VALUES (1, 11, 1);
INSERT INTO `rfl` VALUES (2, 12, 1);
INSERT INTO `rfl` VALUES (3, 13, 1);
INSERT INTO `rfl` VALUES (4, 21, 2);
INSERT INTO `rfl` VALUES (5, 22, 2);
INSERT INTO `rfl` VALUES (6, 23, 2);
INSERT INTO `rfl` VALUES (7, 31, 3);
INSERT INTO `rfl` VALUES (8, 32, 3);
INSERT INTO `rfl` VALUES (9, 33, 3);
INSERT INTO `rfl` VALUES (10, 34, 3);

SET FOREIGN_KEY_CHECKS = 1;
