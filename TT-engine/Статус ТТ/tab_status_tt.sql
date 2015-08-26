-- phpMyAdmin SQL Dump
-- version 3.3.7deb7
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Aug 17, 2015 at 05:28 PM
-- Server version: 5.1.66
-- PHP Version: 5.3.3-7+squeeze14

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `klients`
--

-- --------------------------------------------------------

--
-- Table structure for table `tab_status_tt`
--

CREATE TABLE IF NOT EXISTS `tab_status_tt` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `forIngener` varchar(100) NOT NULL COMMENT 'Для инженера',
  `forCustomer` varchar(150) NOT NULL COMMENT 'Для пользователя',
  `sort` int(2) NOT NULL DEFAULT '0' COMMENT 'Порядок сортировки',
  `description` varchar(300) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 COMMENT='Статусы состояния ТТ' AUTO_INCREMENT=6 ;

--
-- Dumping data for table `tab_status_tt`
--

INSERT INTO `tab_status_tt` (`id`, `forIngener`, `forCustomer`, `sort`, `description`) VALUES
(1, 'В ожидании', 'В ожидании', 0, ''),
(2, 'В работе', 'В работе', 1, ''),
(3, 'Пауза, партнеры', 'В работе', 2, ''),
(4, 'Пауза, клиент', 'Авария у пользователя', 3, ''),
(5, 'Решено', 'Решено', 4, '');


/* Добавляем поле статусов в trubl */

ALTER TABLE `trubl`  ADD `status_tt` INT(2) NOT NULL DEFAULT '1' COMMENT ' tab_status_tt.id',  ADD INDEX (`status_tt`) 