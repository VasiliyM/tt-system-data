
#Перед тем как выполнять эту процедуру, нужно выполнить процедуру апдейта для контакцентра (отсылки сообщений контактцентру) 

# Процедура email Update ТТ, получаем список ТТ по которым нужно провести процедуру Email рассылки update:

SELECT  DISTINCT (zapisi_trubl_tic.num_trubl) AS num_tt, 
(select MAX(zp2.num_zap_trubl) FROM zapisi_trubl_tic zp2 WHERE zp2.num_trubl=zapisi_trubl_tic.num_trubl  LIMIT 1) As idlast_zapis

FROM zapisi_trubl_tic 
JOIN trubl ON zapisi_trubl_tic.num_trubl = trubl.num_of_trubl_tick AND trubl.email_send like '%@%' AND trubl.type_trubl_d NOT IN(1,4,5,6) 
                                           AND trubl.email_doing not like "close"
WHERE `transition`  IN (61,63)  AND DATEDIFF(NOW(),CONCAT(date_zapisi,' ',time_zapisi)) < '1';

# в списке два поля номер ТТ (num_tt) и id последней записи в этом ТТ на этот момент (idlast_zapis)
# из списка выбрасываем те ТТ которые открыты на СК в старом формате данных ( у тебя сейчас эта проверка есть и работает нормально, используй ее)

# по каждой позиции (тоесть по каждому ТТ) из полученного выше списка получаем записи которые нужно вставить в письмо используя (num_tt):

SET @numTT = 'num_tt из предыдущей таблички';
SELECT CONCAT(IF (trubl.date_of_start!=tmptable.date_zapisi,CONCAT(DATE_FORMAT(tmptable.date_zapisi,'%d.%m.%y'),' '),''),
       TIME_FORMAT(tmptable.time_zapisi,'%H:%i'),', ',tmptable.desc_zapisi) as msgtext
FROM (SELECT date_zapisi,time_zapisi,desc_zapisi,num_zap_trubl,num_trubl,transition
		FROM zapisi_trubl_tic 
		WHERE transition  IN (61,62)  AND zapisi_trubl_tic.num_trubl like '@numTT'
	  UNION ALL
	  SELECT date_zapisi,time_zapisi,desc_zapisi,MAX(num_zap_trubl),num_trubl,transition
		FROM zapisi_trubl_tic 
		WHERE num_zap_trubl = (SELECT MAX(num_zap_trubl) 
			                   FROM zapisi_trubl_tic 
			                   WHERE zapisi_trubl_tic.num_trubl like '@numTT' AND transition  IN (63,64)
			                  )  
	 ) tmptable
JOIN trubl ON tmptable.num_trubl=trubl.num_of_trubl_tick 
ORDER BY CONCAT(tmptable.date_zapisi,' ',tmptable.time_zapisi) DESC, tmptable.num_zap_trubl DESC;


# получаем список полностью готовых записей у которого самый старые записи внизу самые новые вверху, вставляем в email выше шапки, оптравляем
# Помечаем что по этому ТТ мы email update  отправили
  SET @numTT = 'num_tt из первой таблички ';
  SET @lstzap = 'idlast_zapis из первой таблички ';
