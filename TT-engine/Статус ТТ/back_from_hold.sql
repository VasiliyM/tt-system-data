# Выведение ТТ из статуса паузы в статус в работе:
# Получить список ТТ которые нужно вывести из отложенных по каждому тт независимо от того за кем он закреплен, в момент выведения 
# из паузы так же присвоить trubl.user_id значение которое выдаст ниже приведенный запрос

# (запрос сначала проверит если текущее рабочее место сейчас активно - вернет его значение, иначе вернет активной рабочее место из группы, иначе
#  вернее активное рабочее место из сектора)

SET @numtt = 'номер ТТ который будет выводиться из паузы в работу';
(SELECT id_num+id as usid , worker
FROM expworkers 
WHERE absence IN (0,3) AND  (id_num+id) = (SELECT user_id FROM trubl WHERE `num_of_trubl_tick` =@numtt) LIMIT 1)
UNION ALL
(SELECT id_num+id as usid , worker
FROM expworkers 
JOIN trubl ON (expworkers.id_num+expworkers.id)=trubl.user_id
JOIN zapisi_trubl_tic ON trubl.num_of_trubl_tick=zapisi_trubl_tic.num_trubl AND zapisi_trubl_tic.name_user not like 'автомат'
WHERE absence IN (0,3) AND trubl.date_of_end = '0000-00-00' AND trubl.type_trubl_d IN(2,3) AND  id_num = (SELECT id_num 
                                     FROM expworkers 
                                     WHERE  (id_num+id) = (SELECT user_id FROM trubl WHERE `num_of_trubl_tick` =@numtt)) 
ORDER BY zapisi_trubl_tic.num_zap_trubl DESC LIMIT 1)
UNION ALL
(SELECT id_num+id as usid ,worker
FROM expworkers 
JOIN trubl ON (expworkers.id_num+expworkers.id)=trubl.user_id
JOIN zapisi_trubl_tic ON trubl.num_of_trubl_tick=zapisi_trubl_tic.num_trubl AND zapisi_trubl_tic.name_user not like 'автомат'
WHERE absence IN (0,3) AND trubl.date_of_end = '0000-00-00' AND trubl.type_trubl_d IN(2,3) 
      AND  id_num like (SELECT CONCAT(LEFT(user_id,1),'%') FROM trubl WHERE num_of_trubl_tick = @numtt) 
ORDER BY zapisi_trubl_tic.num_zap_trubl DESC LIMIT 1)
LIMIT 1

