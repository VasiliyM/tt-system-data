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
#----------------------------------