
# Процедура email Close ТТ, получаем список ТТ по которым нужно провести процедуру Email рассылки close:

SELECT  DISTINCT (trubl.num_of_trubl_tick) AS num_tt
FROM trubl                                            
WHERE trubl.email_send like '%@%' AND trubl.type_trubl_d NOT IN(1,4,5,6)  AND date_of_end > '0000-00-00'
      AND trubl.email_doing like "open" AND date_of_close > (NOW() - interval 1 day);

---------------

# в списке только номера ТТ
# из списка выбрасываем те ТТ которые открыты на СК в старом формате данных ( у тебя сейчас эта проверка есть и работает нормально, используй ее)
# по каждой позиции (тоесть по каждому ТТ) из полученного выше списка получаем записи которые нужно вставить в письмо используя (num_tt):

SET @numTT = 'num_tt из первой  таблички'; 
SELECT CONCAT(TIME_FORMAT(tmptable.time_zapisi,'%H:%i'),
	          IF (trubl.date_of_start<>tmptable.date_zapisi,CONCAT(' ',DATE_FORMAT(tmptable.date_zapisi,'%d.%m.%y')),''),
       ', ',tmptable.desc_zapisi) as msgtext
FROM (SELECT date_zapisi,time_zapisi,desc_zapisi,num_zap_trubl,num_trubl,transition
		FROM zapisi_trubl_tic 
		WHERE transition  IN (61,62)  AND zapisi_trubl_tic.num_trubl like @numTT
	  ) tmptable
JOIN trubl ON tmptable.num_trubl=trubl.num_of_trubl_tick 
ORDER BY CONCAT(tmptable.date_zapisi,' ',tmptable.time_zapisi) DESC, tmptable.num_zap_trubl DESC;


# получаем список полностью готовых записей у которого самый старые записи внизу самые новые вверху, вставляем в email выше шапки о открытии,
# добавляем шапку о закрыти - отправляем.

# Помечаем что по этому ТТ мы email close оповещение уже сделали

  SET @numTT = 'num_tt из первой таблички ';

  UPDATE klients.zapisi_trubl_tic 
  SET  transition = '64', col_centr = '2'
  WHERE zapisi_trubl_tic.num_trubl = @numTT AND zapisi_trubl_tic.transition = '63';

UPDATE klients.zapisi_trubl_tic 
  SET  transition = '62', col_centr = '2'
  WHERE zapisi_trubl_tic.num_trubl = @numTT AND zapisi_trubl_tic.transition = '61';

UPDATE klients.trubl SET email_doing = 'close' WHERE trubl.num_of_trubl_tick = @numTT;

# все вроде