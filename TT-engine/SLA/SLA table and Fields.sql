
#Добавляем поля в существующую таблицу:
ALTER TABLE `net_data` ADD `sla_d` VARCHAR( 30 ) NOT NULL COMMENT 'SLAs table name' AFTER `SLA` ,
ADD `sla_id` INT NOT NULL DEFAULT '0' COMMENT 'id on SLAs table' AFTER `sla_d`;

# Добавляем новую таблицу с экземплярами SLA для СК, поля буду добавлять, пока такие:

CREATE TABLE IF NOT EXISTS `tab_sla_net_data` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `lbl` varchar(3) NOT NULL COMMENT 'Краткое название для системы ТТ и оператора',
  `dflt` int(1) NOT NULL DEFAULT '0' COMMENT 'по умолчанию',
  `bld` int(11) NOT NULL DEFAULT '0' COMMENT 'if 1 - text in BDSE bold',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=7 ;


INSERT INTO `tab_sla_net_data` (`id`, `name`, `lbl`, `dflt`, `bld`) VALUES
(1, 'Преміум', 'Pre', 0, 1),
(2, 'Бізнес', 'Bsn', 0, 1),
(3, 'Стандарт', 'Std', 1, 0),
(4, 'Супутник/радіо', 'S/W', 0, 0),
(5, 'Початковий', 'Sta', 0, 0),
