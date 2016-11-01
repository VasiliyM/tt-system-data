# Окончательная версия запроса, запрос может выдать и null и 0 и значение больше чем в СЛА, логика обработки результатов должна быть реализованна в программе 

	SET @ttnum := '380447'; # номер ТТ для которого рассчитываем прогнозные сроки устранения
	SET @type2d := '16' ; # trubl.type_2_d который выбирает пользователь в закладке добавить ТТ

	SELECT trubl.num_of_trubl_tick as TT,
		CEIL(
		  (
		    (SELECT AVG(TIMESTAMPDIFF(MINUTE,CONCAT (trbl2.date_of_start,' ',trbl2.time_of_start),CONCAT (trbl2.date_of_end,' ', trbl2.time_of_end)))
			 FROM trubl trbl2 
			  JOIN  net_data nd ON trbl2.inv_num_kli= nd.id_data AND trbl2.tab_on = '7'
			  JOIN  office_kli okl ON nd.office_b = okl.id_kli
			  WHERE trbl2.date_of_end <> '0000-00-00' 
			  AND trbl2.date_of_start > (NOW() - interval 550 day) 
			  AND  trbl2.type_trubl_d = trubl.type_trubl_d
			  AND  okl.town_id = office_kli.town_id
		      AND trbl2.type_2_d = @type2d
		      AND (TIMESTAMPDIFF (MINUTE,CONCAT (trbl2.date_of_start,' ',trbl2.time_of_start),CONCAT (trbl2.date_of_end,' ', trbl2.time_of_end))) < '4320') 
		  + (SELECT STD(TIMESTAMPDIFF(MINUTE,CONCAT (trbl2.date_of_start,' ',trbl2.time_of_start),CONCAT (trbl2.date_of_end,' ', trbl2.time_of_end)))
			 FROM `trubl`  trbl2 
			  JOIN  net_data nd ON trbl2.inv_num_kli= nd.id_data AND trbl2.tab_on = '7'
			  JOIN  office_kli okl ON nd.office_b = okl.id_kli
			  WHERE trbl2.date_of_end <> '0000-00-00' 
			  AND trbl2.date_of_start > (NOW() - interval 550 day) 
			  AND  trbl2.type_trubl_d = trubl.type_trubl_d
			  AND  okl.town_id = office_kli.town_id
		      AND trbl2.type_2_d = @type2d
		      AND (TIMESTAMPDIFF (MINUTE,CONCAT (trbl2.date_of_start,' ',trbl2.time_of_start),CONCAT (trbl2.date_of_end,' ', trbl2.time_of_end))) < '4320')
		  )/60
		) as PrognDlitelnost
	FROM trubl
		JOIN  net_data ON trubl.inv_num_kli= net_data.id_data AND trubl.tab_on = '7'
		JOIN  office_kli ON net_data.office_b = office_kli.id_kli
	WHERE 	trubl.num_of_trubl_tick = @ttnum LIMIT 1;

		


