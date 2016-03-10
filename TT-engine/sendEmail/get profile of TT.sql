# Запрос для определения нужна ли этому комментарию английская версия, вернет 0 - не нужна, вернет >0  - нужна

SET @ntt = 'номер_тт_в_который_вносится_запись';
SELECT COUNT(ku.num_of_trubl_tick) 
FROM
(SELECT num_of_trubl_tick
FROM trubl
JOIN net_data ON net_data.id_data = trubl.inv_num_kli  AND tab_on ='7' 
JOIN tab_klients ON net_data.client = tab_klients.id
WHERE trubl.email_send like '%@%' 
       AND (trubl.num_of_trubl_tick = @ntt  OR trubl.depend_on = @ntt) AND tab_klients.emailtemplate = 'BASE_EN'
UNION
SELECT num_of_trubl_tick
FROM trubl
JOIN office_kli ON  office_kli.id_kli = trubl.inv_num_kli AND tab_on = '6'
JOIN tab_klients ON office_kli.klient = tab_klients.id
WHERE trubl.email_send like '%@%' 
       AND (trubl.num_of_trubl_tick = @ntt  OR trubl.depend_on = @ntt) AND tab_klients.emailtemplate = 'BASE_EN') ku  


