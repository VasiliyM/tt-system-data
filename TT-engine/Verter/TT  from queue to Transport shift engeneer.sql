---- Переносить ТТ из Вход очередь(2400002) в Старший смены (Т) (2300140) если рабочее место доступно
---- переносить которые или скорость >= 500 Мбит/с или Премиум Бизнес СЛА или клиент англоязычен (профиль BASE_EN)

------- Проверочный запрос -----------
SELECT  trubl.num_of_trubl_tick, net_data.speed, tab_klients.emailtemplate,net_data.sla_id, 
        (SELECT COUNT(*)  FROM expworkers WHERE expworkers.id = 140 AND expworkers.absence IN (0,3)) as rab_m
FROM trubl 
JOIN net_data ON trubl.inv_num_kli = net_data.id_data
JOIN tab_klients ON net_data.client = tab_klients.id
	WHERE trubl.user_id = '2400002' AND trubl.date_of_end = '0000-00-00' AND trubl.tab_on = '7'  AND trubl.depend_on = '0'
		AND ( net_data.speed > 499 OR tab_klients.emailtemplate like 'BASE_EN' OR (net_data.sla_d like 'tab_sla_net_data' AND net_data.sla_id IN (1,2)))
		AND (SELECT COUNT(*)  FROM expworkers WHERE expworkers.id = 140 AND expworkers.absence IN (0,3)) > 0


------- Выполняющий запрос ------------
UPDATE klients.trubl 
JOIN net_data ON trubl.inv_num_kli = net_data.id_data
JOIN tab_klients ON net_data.client = tab_klients.id
SET user_id = '2300140' 
WHERE trubl.user_id = '2400002' AND trubl.date_of_end = '0000-00-00' AND trubl.tab_on = '7'  AND trubl.depend_on = '0'
		AND ( net_data.speed > 499 OR tab_klients.emailtemplate like 'BASE_EN' OR (net_data.sla_d like 'tab_sla_net_data' AND net_data.sla_id IN (1,2)))
		AND (SELECT COUNT(*)  FROM expworkers WHERE expworkers.id = 140 AND expworkers.absence IN (0,3)) > 0