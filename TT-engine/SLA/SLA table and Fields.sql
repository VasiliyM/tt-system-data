
#Добавляем поля в существующую таблицу:
ALTER TABLE `net_data` ADD `sla_d` VARCHAR( 30 ) NOT NULL COMMENT 'SLAs table name' AFTER `SLA` ,
ADD `sla_id` INT NOT NULL DEFAULT '0' COMMENT 'id on SLAs table' AFTER `sla_d`;

# Добавляем новую таблицу с экземплярами SLA для СК, поля буду добавлять, пока такие:

DROP TABLE IF EXISTS `tab_sla_net_data`;
CREATE TABLE IF NOT EXISTS `tab_sla_net_data` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `lbl` varchar(3) NOT NULL COMMENT 'Краткое название для системы ТТ и оператора',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=6 ;

INSERT INTO `tab_sla_net_data` (`id`, `name`, `lbl`) VALUES
(1, 'Преміум', 'Pre'),
(2, 'Бізнес', 'Bsn'),
(3, 'Стандарт', 'Std'),
(4, 'Супутниковий', 'Stl'),
(5, 'Легкий', 'Lgh');