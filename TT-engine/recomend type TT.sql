
# Используется при открытии ТТ в форме "Добавление ТТ", если в запрос подставить tab_on на который открывается ТТ и
# tab_access.id залогиненного пользователя то запрос вернет рекомендуемый category_type_tt.id для поля Тип ТТ  
# если запрос не вернет ничего - то ничего не рекомендовать  

SET @tabON = 'значение которое будет вставлено в trubl.tab_on';
SET @iduser = 'id пользователя из tab_access.id';

SELECT pre.type_trubl_d
FROM 
(SELECT type_trubl_d FROM trubl JOIN tab_access ON trubl.name_user = tab_access.nik
WHERE tab_access.id = @iduser AND tab_on = @tabON
ORDER BY `num_of_trubl_tick` DESC LIMIT 25) pre
GROUP BY pre.type_trubl_d
ORDER BY COUNT(*) DESC LIMIT 1