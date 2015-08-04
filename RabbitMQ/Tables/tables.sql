
-------------------------------
CREATE TABLE IF NOT EXISTS `plan_comments` (
  `commId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `refWork` int(10) unsigned NOT NULL,
  `timestamp` datetime NOT NULL,
  `editorName` varchar(50) NOT NULL,
  `comment` varchar(500) NOT NULL,
  PRIMARY KEY (`commId`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 AUTO_INCREMENT=1 ;
---------------------------------

CREATE TABLE IF NOT EXISTS `plan_services` (
  `refId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `refWork` int(10) unsigned NOT NULL,
  `sertype` varchar(30) NOT NULL,
  `nameser` varchar(100) NOT NULL,
  `inter` varchar(200) NOT NULL,
  `VOLUMEB` int(1) NOT NULL,
  `VOLUMEE` int(3) NOT NULL,
  `name` varchar(20) NOT NULL,
  PRIMARY KEY (`refId`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 AUTO_INCREMENT=1 ;

---------------------------------------------------

CREATE TABLE IF NOT EXISTS `plan_task` (
  `workid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `WBS` varchar(20) NOT NULL,
  `POSID` varchar(15) NOT NULL,
  `client` varchar(50) NOT NULL,
  `cltype` varchar(10) NOT NULL,
  `lastmile` int(2) NOT NULL,
  `region_name` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  `street` varchar(150) NOT NULL,
  `bulding` int(4) unsigned NOT NULL,
  `strtype` varchar(10) NOT NULL,
  `mannage` varchar(150) NOT NULL,
  `chtoDelat` text NOT NULL,
  `techname` varchar(20) NOT NULL,
  `typework` varchar(20) NOT NULL,
  `emplname` varchar(200) NOT NULL,
  `otdel` varchar(20) NOT NULL,
  `wop` varchar(200) NOT NULL,
  `wtd` varchar(200) NOT NULL,
  `onWF` int(1) NOT NULL,
  `budgetbag` int(1) NOT NULL,
  `plannedEnd` date NOT NULL,
  `subwname` varchar(30) NOT NULL,
  `ktoPostavil` varchar(50) NOT NULL,
  `salesorg` varchar(100) NOT NULL,
  `STARTDATE` datetime NOT NULL,
  `Status` varchar(20) NOT NULL,
  `SAPID` varchar(10) NOT NULL,
  PRIMARY KEY (`workid`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 AUTO_INCREMENT=1 ;
