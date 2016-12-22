#Среднее колич. ТТ за рабочий день:
SET @frm = '2016-02-01';
SET @to = '2016-04-26';
SET @typeSLA = '1,2';

SELECT ROUND(COUNT(*)/(DATEDIFF(@to,@frm)*0.714285714285714),1) AS TTinWD
FROM trubl
JOIN net_data ON trubl.inv_num_kli=net_data.id_data AND tab_on = '7' AND net_data.sla_d like 'tab_sla_net_data' AND `type_trubl_d` IN(2,3) 
WHERE date_of_open >= @frm AND date_of_open <= @to AND WEEKDAY(`date_of_open`) IN (0,1,2,3,4) AND net_data.sla_id IN( @typeSLA );
#----------------------------------

#Среднее колич. ТТ за календарный день:
SET @frm = '2016-02-01';
SET @to = '2016-04-26';
SET @typeSLA = '1,2';

SELECT ROUND(COUNT(*)/(DATEDIFF(@to,@frm)),1) AS TTinD
FROM trubl
JOIN net_data ON trubl.inv_num_kli=net_data.id_data AND tab_on = '7' AND net_data.sla_d like 'tab_sla_net_data' AND `type_trubl_d` IN(2,3) 
WHERE date_of_open >= @frm AND date_of_open <= @to AND net_data.sla_id IN( @typeSLA );
#----------------------------------

#Всего количество ТТ по выбранным SLA:
SET @frm = '2016-02-01';
SET @to = '2016-04-26';
SET @typeSLA = '1,2';

SELECT COUNT(*) AS allTT
FROM trubl
JOIN net_data ON trubl.inv_num_kli=net_data.id_data AND tab_on = '7' AND net_data.sla_d like 'tab_sla_net_data' AND `type_trubl_d` IN(2,3) 
WHERE date_of_open >= @frm AND date_of_open <= @to AND net_data.sla_id IN( @typeSLA );
#----------------------------------


#Количество ТТ с нарушением сроков устранения:
SET @frm = '2016-02-01';
SET @to = '2016-04-26';
SET @typeSLA = '1,2';

SELECT COUNT(*) as TTwBrokenSLA
FROM trubl 
 JOIN net_data ON trubl.inv_num_kli=net_data.id_data AND trubl.tab_on='7' AND trubl.type_trubl_d IN(2,3)  
 JOIN tab_sla_net_data ON net_data.sla_id = tab_sla_net_data.id AND net_data.sla_d LIKE 'tab_sla_net_data'
WHERE date_of_end > '0000-00-00' AND date_of_open >= @frm AND date_of_open <= @to 
      AND net_data.sla_id IN( @typeSLA ) 
      AND HOUR(TIMEDIFF(CONCAT(date_of_end,' ',time_of_end),CONCAT(date_of_start,' ',time_of_start))) >	tab_sla_net_data.timeframe
      AND type_1 NOT LIKE 'Заказчик';
#---------------------

# Количество выездов по выбранным SLA:
SET @frm = '2016-02-01';
SET @to = '2016-04-26';
SET @typeSLA = '1,2';

	SELECT COUNT(*)
	FROM trubl_crew 
	JOIN trubl ON trubl_crew.num_trubl = trubl.num_of_trubl_tick AND tab_on='7' 
	JOIN net_data ON trubl.inv_num_kli=net_data.id_data AND sla_d LIKE 'tab_sla_net_data' 
	WHERE LEFT(trubl_crew.date_of_start,7) >= @frm AND LEFT(trubl_crew.date_of_start,7) <= @to AND net_data.sla_id IN( @typeSLA ) 
	      AND trubl_crew.date_of_start > 0 AND dt_close >0
#----------------------------------

# Всего (количество) услуг с выбранными SLA:
SET @frm = '2016-02-01';
SET @to = '2016-04-26';
SET @typeSLA = '1,2';

SELECT COUNT(*) 
FROM  net_data
JOIN tab_klients ON net_data.client=tab_klients.id
JOIN tab_sla_net_data ON net_data.sla_id = tab_sla_net_data.id AND `sla_d` LIKE 'tab_sla_net_data'
WHERE `sla_id` IN( @typeSLA ) AND in_exp<=@to AND (out_exp>@to OR  out_exp='0000-00-00')
      AND net_data.retail = '0' AND net_data.client not IN (16,1641,78,79,1946,2102,2174,3715)
#----------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------
# Детальнее: Всего количество ТТ по выбранным SLA:
SET @frm = '2016-02-01';
SET @to = '2016-04-26';
SET @typeSLA = '1,2';

SELECT num_of_trubl_tick AS ТТ, tab_sla_net_data.name AS SLA,
       GetNameOfClient(trubl.tab_on,trubl.inv_num_kli) AS 'Клиент',
       HOUR(TIMEDIFF(CONCAT(date_of_end,' ',time_of_end),CONCAT(date_of_start,' ',time_of_start))) AS 'Длительн.ТТ часов',
       tab_sla_net_data.timeframe AS 'Срок по СЛА, ч',
       type_1 AS Категория,type_2 AS Подкатегория, type_3 AS Оборудование,zakril AS Закрыл, trubl.prichina AS 'причина инцидента',
       trubl.description AS 'причина открытия',
       CONCAT(date_of_start,' ',LEFT(time_of_start,5),' / ',date_of_end,' ',LEFT(time_of_end,5)) AS 'Начало/окончание',
       tab_catal_comm_dep.namedepartment as 'Тип бизнеса'
FROM trubl
JOIN net_data ON trubl.inv_num_kli=net_data.id_data AND tab_on = '7' AND net_data.sla_d like 'tab_sla_net_data' AND `type_trubl_d` IN(2,3) 
JOIN tab_klients ON net_data.client=tab_klients.id
JOIN tab_sla_net_data ON net_data.sla_id = tab_sla_net_data.id 
JOIN tab_catal_comm_dep ON tab_klients.type_business = tab_catal_comm_dep.id
WHERE date_of_open >= @frm AND date_of_open <= @to AND net_data.sla_id IN( @typeSLA );
#--------------

# Детальнее: Количество ТТ с нарушением сроков устранения:
SET @frm = '2016-02-01';
SET @to = '2016-04-26';
SET @typeSLA = '1,2';

SELECT num_of_trubl_tick AS ТТ, tab_sla_net_data.name AS SLA,
       GetNameOfClient(trubl.tab_on,trubl.inv_num_kli) AS 'Клиент',
       HOUR(TIMEDIFF(CONCAT(date_of_end,' ',time_of_end),CONCAT(date_of_start,' ',time_of_start))) AS 'Длительн.ТТ часов',
       tab_sla_net_data.timeframe AS 'Срок по СЛА, ч',
       type_1 AS Категория,type_2 AS Подкатегория, type_3 AS Оборудование,zakril AS Закрыл, trubl.prichina AS 'причина инцидента',
       trubl.description AS 'причина открытия',
       CONCAT(date_of_start,' ',LEFT(time_of_start,5),' / ',date_of_end,' ',LEFT(time_of_end,5)) AS 'Начало/окончание',
       tab_catal_comm_dep.namedepartment as 'Тип бизнеса'
FROM trubl 
 JOIN net_data ON trubl.inv_num_kli=net_data.id_data AND trubl.tab_on='7' AND trubl.type_trubl_d IN(2,3)  
 JOIN tab_klients ON net_data.client=tab_klients.id
 JOIN tab_sla_net_data ON net_data.sla_id = tab_sla_net_data.id AND net_data.sla_d LIKE 'tab_sla_net_data'
 JOIN tab_catal_comm_dep ON tab_klients.type_business = tab_catal_comm_dep.id
WHERE date_of_end > '0000-00-00' AND date_of_open >= @frm AND date_of_open <= @to 
      AND net_data.sla_id IN( @typeSLA ) 
      AND HOUR(TIMEDIFF(CONCAT(date_of_end,' ',time_of_end),CONCAT(date_of_start,' ',time_of_start))) >	tab_sla_net_data.timeframe
      AND type_1 NOT LIKE 'Заказчик';
#--------------

# Детальнее: Количество выездов по выбранным SLA:
SET @frm = '2016-02-01';
SET @to = '2016-04-26';
SET @typeSLA = '1,2';

	SELECT num_trubl AS TT,
	  LEFT(TIMEDIFF(CONCAT(trubl_crew.date_of_end,' ',trubl_crew.time_of_end),CONCAT(trubl_crew.date_of_start,' ',trubl_crew.time_of_start)),5) AS 'Длительн.выезда ч.',
	  LEFT(TIMEDIFF(CONCAT(trubl_crew.date_of_start,' ',trubl_crew.time_of_start),dt_open),5) AS 'Собрались за ч.',
	  CONCAT(LEFT(dt_open,16),' /',trubl_crew.date_of_start,' ',LEFT(trubl_crew.time_of_start,5),' /',trubl_crew.date_of_end,' ',LEFT(trubl_crew.time_of_end,5)) AS 'Поставлен/начали/закончили',
       tab_sla_net_data.timeframe AS 'Срок по СЛА, ч',tab_sla_net_data.name AS SLA,
       name_of_crew AS Группа, klient AS Клиент, type_tt AS Тип_заявки, zadanie AS Задача, report AS Отчет
	FROM trubl_crew 
	JOIN trubl ON trubl_crew.num_trubl = trubl.num_of_trubl_tick 
	JOIN category_type_tt ON trubl_crew.TYPE=category_type_tt.id
	JOIN net_data ON trubl.inv_num_kli=net_data.id_data AND sla_d LIKE 'tab_sla_net_data'  AND tab_on='7' 
	JOIN tab_sla_net_data ON net_data.sla_id = tab_sla_net_data.id  
	WHERE LEFT(trubl_crew.date_of_start,7) >= @frm AND LEFT(trubl_crew.date_of_start,7) <= @to AND net_data.sla_id IN( @typeSLA ) 
	      AND trubl_crew.date_of_start > 0 AND dt_close >0
#--------------

# Детальнее: Всего (количество) услуг с выбранными SLA:
SET @frm = '2016-02-01';
SET @to = '2016-04-26';
SET @typeSLA = '1,2';

SELECT tab_klients.client AS Клиент, tab_sla_net_data.name AS SLA, GetNameOfClient('7',net_data.id_data) AS 'Услуга',
      tab_katal_sk_type.name as 'Тип услуги',
	Concat(change_login," ",CAST(LEFT(last_edit,16) AS CHAR)) AS 'Последнее редактирование', CID,net_data.planerid  AS Планер,
       tab_catal_comm_dep.namedepartment as 'Тип бизнеса'
FROM  net_data
JOIN tab_klients ON net_data.client=tab_klients.id
JOIN tab_sla_net_data ON net_data.sla_id = tab_sla_net_data.id AND `sla_d` LIKE 'tab_sla_net_data'
JOIN tab_catal_comm_dep ON tab_klients.type_business = tab_catal_comm_dep.id
JOIN tab_katal_sk_type  ON net_data.type_serv_d = tab_katal_sk_type.id
WHERE `sla_id` IN( @typeSLA ) AND in_exp<=@to AND (out_exp>@to OR  out_exp='0000-00-00')
      AND  retail = '0' AND net_data.client not IN (16,1641,78,79,1946,2102,2174,3715)

#--------------

          
