-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.4.14-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Copiando estrutura do banco de dados para ckf2
DROP DATABASE IF EXISTS `ckf2`;
CREATE DATABASE IF NOT EXISTS `ckf2` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `ckf2`;

-- Copiando estrutura para tabela ckf2.characters
DROP TABLE IF EXISTS `characters`;
CREATE TABLE IF NOT EXISTS `characters` (
  `charid` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `characterName` varchar(50) NOT NULL,
  `age` int(11) unsigned DEFAULT 0,
  `level` int(11) DEFAULT 1,
  `xp` int(11) DEFAULT 0,
  `groups` text NOT NULL DEFAULT '{}',
  `charTable` text NOT NULL DEFAULT '{}',
  `skin` text NOT NULL DEFAULT '{}',
  `clothes` text DEFAULT '{}',
  `weapons` text NOT NULL DEFAULT '{}',
  `is_dead` int(11) DEFAULT 0,
  `money` int(11) NOT NULL DEFAULT 20000,
  `prisonTime` int(11) NOT NULL,
  `hairInfo` text NOT NULL DEFAULT '[]',
  `vip` text DEFAULT 'NENHUM',
  `timestamp` text DEFAULT '0',
  `phone` text DEFAULT NULL,
  `eyecolor` int(11) DEFAULT 0,
  `health` int(11) DEFAULT 200,
  PRIMARY KEY (`charid`),
  KEY `FK_characters_users` (`user_id`),
  CONSTRAINT `FK_characters_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela ckf2.characters_homes
DROP TABLE IF EXISTS `characters_homes`;
CREATE TABLE IF NOT EXISTS `characters_homes` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `charid` int(11) DEFAULT NULL,
  `houseName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `charid` (`charid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela ckf2.characters_vehicles
DROP TABLE IF EXISTS `characters_vehicles`;
CREATE TABLE IF NOT EXISTS `characters_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `charid` int(11) DEFAULT NULL,
  `vehicle` varchar(255) DEFAULT NULL,
  `plate` varchar(255) DEFAULT NULL,
  `custom` varchar(9999) DEFAULT NULL,
  `items` text NOT NULL DEFAULT '{}',
  `imageURL` text DEFAULT NULL,
  `tracker` int(11) DEFAULT 0,
  `trunk` int(11) DEFAULT NULL,
  `timestamp` text DEFAULT 'NENHUM',
  PRIMARY KEY (`id`),
  KEY `charid` (`charid`),
  CONSTRAINT `FK_vehchests_characters` FOREIGN KEY (`charid`) REFERENCES `characters` (`charid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela ckf2.chests
DROP TABLE IF EXISTS `chests`;
CREATE TABLE IF NOT EXISTS `chests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `charid` int(11) DEFAULT NULL,
  `position` text NOT NULL DEFAULT '{}[]',
  `type` int(11) NOT NULL,
  `capacity` int(11) NOT NULL,
  `items` text DEFAULT '{}',
  `house` text DEFAULT NULL,
  `faction` text DEFAULT '{}',
  PRIMARY KEY (`id`),
  KEY `FK_chests_characters` (`charid`),
  CONSTRAINT `FK_chests_characters` FOREIGN KEY (`charid`) REFERENCES `characters` (`charid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela ckf2.criminal_records
DROP TABLE IF EXISTS `criminal_records`;
CREATE TABLE IF NOT EXISTS `criminal_records` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `charid` int(11) NOT NULL DEFAULT 0,
  `criminal_record` text DEFAULT NULL,
  `avatarURL` text DEFAULT 'https://i.imgur.com/PqVvr8V.png',
  `register_by` text DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `charid` (`charid`),
  CONSTRAINT `characterid` FOREIGN KEY (`charid`) REFERENCES `characters` (`charid`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para procedure ckf2.getData
DROP PROCEDURE IF EXISTS `getData`;
DELIMITER //
CREATE PROCEDURE `getData`(
	IN `typeData` VARCHAR(10),
	IN `id` INT(8),
	IN `chave` TEXT
)
BEGIN
	IF (chave = 'all' && typeData = 'clothes') THEN
		SELECT clothes as Value FROM characters WHERE charid = id;
	ELSEIF (chave = 'all' && typeData = 'groups') THEN
		SELECT groups as Value FROM characters WHERE charid = id;
	ELSEIF (chave = 'all' && typeData = 'charTable') THEN
		SELECT charTable as Value FROM characters WHERE charid = id;
	ELSEIF (chave = 'all' && typeData = 'skin') THEN
		SELECT skin as Value FROM characters WHERE charid = id;
	END IF;
	
	IF (typeData = 'groups') THEN
		SELECT json_extract(groups, CONCAT("$.", chave)) as Value FROM characters WHERE charid = id;
	ELSEIF (typeData = 'clothes') THEN
		SELECT json_extract(clothes, CONCAT("$.", chave)) as Value FROM characters WHERE charid = id;
	ELSEIF (typeData = 'charTable') THEN
		SELECT json_extract(charTable, CONCAT("$.", chave)) as Value FROM characters WHERE charid = id;
	ELSEIF (typeData = 'skin') THEN
		SELECT json_extract(skin, CONCAT("$.", chave)) as Value FROM characters WHERE charid = id;
	END IF;
END//
DELIMITER ;

-- Copiando estrutura para procedure ckf2.inventories
DROP PROCEDURE IF EXISTS `inventories`;
DELIMITER //
CREATE PROCEDURE `inventories`(
	IN `iid` VARCHAR(20),
	IN `charid` INT(8),
	IN `itemName` VARCHAR(100),
	IN `itemCount` INT(8),
	IN `typeInv` VARCHAR(8)
)
BEGIN
    IF (typeInv = "update") THEN
        UPDATE inventories SET items = JSON_SET(items, CONCAT("$.", itemName), itemCount) WHERE id = iid;
    ELSEIF (typeInv = "remove") THEN
        UPDATE inventories SET items = JSON_REMOVE(items, CONCAT("$.", itemName)) WHERE id = iid;
    ELSEIF (typeInv = "select") THEN
        SELECT * from inventories WHERE id = iid;
    ELSEIF (typeInv = "insert") THEN
        INSERT INTO inventories(id, charid, capacity, items) VALUES (iid, charid, 5, "{}");
    ELSEIF (typeInv = "deadPlayer") THEN
        UPDATE inventories SET items = '{}' WHERE id = iid and charid = charid;
    END IF;
END//
DELIMITER ;

-- Copiando estrutura para tabela ckf2.inventories
DROP TABLE IF EXISTS `inventories`;
CREATE TABLE IF NOT EXISTS `inventories` (
  `id` varchar(100) NOT NULL,
  `charid` int(11) DEFAULT NULL,
  `capacity` int(11) DEFAULT NULL,
  `items` text NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_inventoriers_characters` (`charid`),
  CONSTRAINT `FK_inventories_characters` FOREIGN KEY (`charid`) REFERENCES `characters` (`charid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela ckf2.launcher_accounts
DROP TABLE IF EXISTS `launcher_accounts`;
CREATE TABLE IF NOT EXISTS `launcher_accounts` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `charid` int(11) DEFAULT NULL,
  `username` mediumtext DEFAULT NULL,
  `password` mediumtext DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `charid` (`charid`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela ckf2.mechanicstock
DROP TABLE IF EXISTS `mechanicstock`;
CREATE TABLE IF NOT EXISTS `mechanicstock` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehtyres` int(11) NOT NULL DEFAULT 0,
  `engine` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela ckf2.outfits
DROP TABLE IF EXISTS `outfits`;
CREATE TABLE IF NOT EXISTS `outfits` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `charid` int(11) NOT NULL DEFAULT 0,
  `outfits` text DEFAULT '{}',
  PRIMARY KEY (`ID`),
  KEY `charid` (`charid`),
  CONSTRAINT `charid` FOREIGN KEY (`charid`) REFERENCES `characters` (`charid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela ckf2.phone_app_chat
DROP TABLE IF EXISTS `phone_app_chat`;
CREATE TABLE IF NOT EXISTS `phone_app_chat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel` varchar(20) NOT NULL,
  `message` varchar(255) NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela ckf2.phone_calls
DROP TABLE IF EXISTS `phone_calls`;
CREATE TABLE IF NOT EXISTS `phone_calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(10) NOT NULL COMMENT 'Num tel proprio',
  `num` varchar(10) NOT NULL COMMENT 'Num reférence du contact',
  `incoming` int(11) NOT NULL COMMENT 'Défini si on est à l''origine de l''appels',
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `accepts` int(11) NOT NULL COMMENT 'Appels accepter ou pas',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela ckf2.phone_messages
DROP TABLE IF EXISTS `phone_messages`;
CREATE TABLE IF NOT EXISTS `phone_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transmitter` varchar(10) NOT NULL,
  `receiver` varchar(10) NOT NULL,
  `message` varchar(255) NOT NULL DEFAULT '0',
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `isRead` int(11) NOT NULL DEFAULT 0,
  `owner` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=469 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela ckf2.phone_users_contacts
DROP TABLE IF EXISTS `phone_users_contacts`;
CREATE TABLE IF NOT EXISTS `phone_users_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
  `number` varchar(10) CHARACTER SET utf8mb4 DEFAULT NULL,
  `display` varchar(64) CHARACTER SET utf8mb4 NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela ckf2.police_bills
DROP TABLE IF EXISTS `police_bills`;
CREATE TABLE IF NOT EXISTS `police_bills` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `charid` int(11) DEFAULT NULL,
  `bill_value` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `charid` (`charid`),
  CONSTRAINT `charid_val` FOREIGN KEY (`charid`) REFERENCES `characters` (`charid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela ckf2.posses
DROP TABLE IF EXISTS `posses`;
CREATE TABLE IF NOT EXISTS `posses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `charid` int(11) NOT NULL,
  `members` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `charid` (`charid`),
  CONSTRAINT `FK_posses_characters` FOREIGN KEY (`charid`) REFERENCES `characters` (`charid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela ckf2.racings
DROP TABLE IF EXISTS `racings`;
CREATE TABLE IF NOT EXISTS `racings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `raceid` int(11) NOT NULL DEFAULT 0,
  `charid` int(11) NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL DEFAULT '0',
  `time` varchar(255) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para procedure ckf2.remData
DROP PROCEDURE IF EXISTS `remData`;
DELIMITER //
CREATE PROCEDURE `remData`(
	IN `typeData` VARCHAR(20),
	IN `chave` TEXT,
	IN `_id` INT(8)
)
BEGIN
	IF (typeData = 'groups') THEN
		UPDATE characters SET groups = JSON_REMOVE(groups, CONCAT("$.", chave)) WHERE charid = _id;
	ELSEIF (typeData = 'chest') THEN
		UPDATE chests SET items = JSON_REMOVE(items, CONCAT("$.", chave)) WHERE id = _id;
	ELSEIF (typeData = 'outfit') THEN
		UPDATE outfits SET outfits = JSON_REMOVE(outfits, CONCAT("$.", chave)) WHERE charid = _id;
	ELSEIF (typeData = 'vehchest') THEN
		UPDATE characters_vehicles SET items = JSON_REMOVE(items, CONCAT("$.", chave)) WHERE id = _id;
	ELSEIF (typeData = 'clothes') THEN
		UPDATE characters SET clothes = JSON_REMOVE(clothes, CONCAT("$.", chave)) WHERE charid = _id;
	ELSEIF (typeData = 'charTable') THEN
		UPDATE characters SET charTable = JSON_REMOVE(charTable, CONCAT("$.", chave)) WHERE charid = _id;
	ELSEIF (typeData = 'skin') THEN
		UPDATE characters SET skin = JSON_REMOVE(skin, CONCAT("$.", chave)) WHERE charid = _id;
	END IF;
END//
DELIMITER ;

-- Copiando estrutura para procedure ckf2.setData
DROP PROCEDURE IF EXISTS `setData`;
DELIMITER //
CREATE PROCEDURE `setData`(
	IN `typeData` VARCHAR(20),
	IN `chave` VARCHAR(50),
	IN `valorChave` TEXT,
	IN `_id` INT(8)
)
BEGIN
	-- THIS IS A GROUPS - IF IS A ADMIN, USER, MECHANIC ETC...
	IF (typeData = 'groups') THEN
		UPDATE characters SET groups = JSON_SET(groups, CONCAT("$.", chave), valorChave) WHERE charid = _id;
	ELSEIF (typeData = 'chest') THEN
		UPDATE chests SET items = JSON_SET(items, CONCAT("$.", chave), valorChave) WHERE id = _id;
	-- THIS IS A CHAR TABLE [ POSITION / HUNGER / THIRST / ETC... ]
	ELSEIF (typeData = 'outfit') THEN
		UPDATE outfits SET outfits = JSON_SET(outfits, CONCAT("$.", chave), valorChave) WHERE charid = _id;
	ELSEIF (typeData = 'tattoo') THEN
		UPDATE tattoos SET tattoos = JSON_SET(tattoos, CONCAT("$.", chave), valorChave) WHERE charid = _id;
	ELSEIF (typeData = 'charTable') THEN
		UPDATE characters SET charTable = JSON_SET(charTable, CONCAT("$.", chave), valorChave) WHERE charid = _id;
	-- THIS IS A PLAYER SKIN - FACE FEATURES, HEAD BLEND ETC..
	ELSEIF (typeData = 'skin') THEN
		UPDATE characters SET skin = JSON_SET(skin, CONCAT("$.", chave), valorChave) WHERE charid = _id;
	-- THIS IS A CLOTHES SITUATION
	ELSEIF (typeData = 'clothes') THEN
		UPDATE characters SET clothes = JSON_SET(clothes, CONCAT("$.", chave), valorChave) WHERE charid = _id;
	ELSEIF (typeData = 'saveHair') THEN
		UPDATE characters SET skin = JSON_SET(skin, CONCAT("$.", chave), valorChave) WHERE charid = _id;
	ELSEIF (chave = 'ALL' and typeData = 'saveClothes') THEN
		UPDATE characters SET clothes = valorChave WHERE charid = _id;
	ELSEIF (chave = 'ALL' and typeData = 'saveSkin') THEN
		UPDATE characters SET skin = valorChave WHERE charid = _id;
	END IF;
END//
DELIMITER ;

-- Copiando estrutura para tabela ckf2.tattoos
DROP TABLE IF EXISTS `tattoos`;
CREATE TABLE IF NOT EXISTS `tattoos` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `charid` int(11) NOT NULL,
  `tattoos` text DEFAULT '{}',
  PRIMARY KEY (`ID`),
  KEY `charid` (`charid`),
  CONSTRAINT `char_id` FOREIGN KEY (`charid`) REFERENCES `characters` (`charid`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela ckf2.twitter_accounts
DROP TABLE IF EXISTS `twitter_accounts`;
CREATE TABLE IF NOT EXISTS `twitter_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `password` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
  `avatar_url` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela ckf2.twitter_likes
DROP TABLE IF EXISTS `twitter_likes`;
CREATE TABLE IF NOT EXISTS `twitter_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `authorId` int(11) DEFAULT NULL,
  `tweetId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_twitter_likes_twitter_accounts` (`authorId`),
  KEY `FK_twitter_likes_twitter_tweets` (`tweetId`),
  CONSTRAINT `FK_twitter_likes_twitter_accounts` FOREIGN KEY (`authorId`) REFERENCES `twitter_accounts` (`id`),
  CONSTRAINT `FK_twitter_likes_twitter_tweets` FOREIGN KEY (`tweetId`) REFERENCES `twitter_tweets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela ckf2.twitter_tweets
DROP TABLE IF EXISTS `twitter_tweets`;
CREATE TABLE IF NOT EXISTS `twitter_tweets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `authorId` int(11) NOT NULL,
  `realUser` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `likes` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `FK_twitter_tweets_twitter_accounts` (`authorId`),
  CONSTRAINT `FK_twitter_tweets_twitter_accounts` FOREIGN KEY (`authorId`) REFERENCES `twitter_accounts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela ckf2.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `name` varchar(50) NOT NULL,
  `banned` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`),
  KEY `identifier` (`identifier`),
  CONSTRAINT `FK_users_whitelist` FOREIGN KEY (`identifier`) REFERENCES `whitelist` (`identifier`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para procedure ckf2.vehchest
DROP PROCEDURE IF EXISTS `vehchest`;
DELIMITER //
CREATE PROCEDURE `vehchest`(
	IN `typeData` TEXT,
	IN `chave` TEXT,
	IN `valorChave` TEXT,
	IN `_id` INT
)
BEGIN
	IF (typeData = 'vehchest') THEN
		UPDATE characters_vehicles SET `items` = JSON_SET(items, CONCAT("$.", chave), valorChave) WHERE id = _id;
	ELSEIF (typeData = 'remvehchest') THEN
		UPDATE characters_vehicles SET `items` = JSON_REMOVE(items, CONCAT("$.", chave)) WHERE id = _id;
	END IF;
END//
DELIMITER ;

-- Copiando estrutura para tabela ckf2.whitelist
DROP TABLE IF EXISTS `whitelist`;
CREATE TABLE IF NOT EXISTS `whitelist` (
  `id` int(11) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
