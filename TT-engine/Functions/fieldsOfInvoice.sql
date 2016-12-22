DROP PROCEDURE IF EXISTS `fieldsOfInvoice`;
DELIMITER $$
CREATE DEFINER=`marusyak`@`%` PROCEDURE `fieldsOfInvoice`(IN `idInv` VARCHAR(10))
    NO SQL
BEGIN
	DECLARE id_inv INT;
	DECLARE Prtn VARCHAR(250);
	DECLARE Kli VARCHAR(250);
	DECLARE planer_id INT;
	DECLARE dt_want Date;
	DECLARE sap VARCHAR(20);
	DECLARE num_inv VARCHAR(250);
	DECLARE dt_inv Date;
	DECLARE summ decimal(10,2);	
	DECLARE purposePay VARCHAR(500);
	DECLARE Biznes VARCHAR(250);
	DECLARE dt_out DATE;
	DECLARE dt_pay DATE;
	DECLARE resp VARCHAR(250);
	DECLARE man VARCHAR(250);
	DECLARE twn VARCHAR(250);
	DECLARE descr VARCHAR(500);
	
	DECLARE done INT DEFAULT FALSE;
	DECLARE invCursor Cursor for 
	  SELECT id,
	    (SELECT client FROM tab_klients WHERE id = (SELECT tab_a_id FROM z_connecttable WHERE `tab_b_id`=z_tab_invoice.num_dogovor)) as Prtn,
		(SELECT client FROM tab_klients WHERE id = z_tab_invoice.client) as Kli,
		planner_id,
		dt_plan_of_pay,
		sap_id, 
		num_invoice,
		dt_invoice,
		summa,
		detail_of_pay,
		(SELECT namedepartment FROM `tab_catal_comm_dep` WHERE `id` = z_tab_invoice.business) as Biznes,
		dt_out_to_pay,
		dt_of_pay,
		(SELECT `nik` FROM `tab_access` WHERE `id` = z_tab_invoice.responsible) as resp,
		(SELECT `nik` FROM `tab_access` WHERE `id`=z_tab_invoice.manager) as man,
		(SELECT concat(`town`," ",`town_ua`," ",CAST( tab_area.region AS CHAR)," обл.") FROM `tab_town`,tab_area WHERE tab_town.area_id = tab_area.id and `tab_town`.id = z_tab_invoice.town) as twn,
		description	
	  FROM z_tab_invoice ORDER BY id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;	

	IF (idInv = '*') THEN
		DROP TEMPORARY TABLE IF EXISTS temp_invoice;
		CREATE TEMPORARY TABLE temp_invoice (id_inv INT,Prtn VARCHAR(250),Kli VARCHAR(250),planer_id INT,dt_want DATE,sap VARCHAR(20),num_inv VARCHAR(250),
											dt_inv DATE,summ decimal(10,2),purposePay VARCHAR(500),Biznes VARCHAR(250),dt_out DATE,dt_pay DATE,resp VARCHAR(250),
											man VARCHAR(250),twn VARCHAR(250),descr VARCHAR(500));

		Open invCursor;
		read_loop: LOOP
			FETCH invCursor INTO id_inv,Prtn,Kli,planer_id,dt_want,sap,num_inv,dt_inv,summ,purposePay,Biznes,dt_out,dt_pay,resp,man,twn,descr;
			IF done THEN
			  LEAVE read_loop;
			END IF;

			insert into temp_invoice values (id_inv,Prtn,Kli,planer_id,dt_want,sap,num_inv,dt_inv,summ,purposePay,Biznes,dt_out,dt_pay,resp,man,twn,descr);	
		END LOOP;
		Close invCursor; 
		
		select * from temp_invoice;
		DROP TEMPORARY TABLE IF EXISTS temp_invoice;
	ELSE
		SELECT id,
			(SELECT client FROM tab_klients WHERE id = (SELECT tab_a_id FROM z_connecttable WHERE `tab_b_id`=z_tab_invoice.num_dogovor)) as Prtn,
			(SELECT client FROM tab_klients WHERE id = z_tab_invoice.client) as Kli,
			planner_id,
			dt_plan_of_pay,
			sap_id,
			num_invoice,
			dt_invoice,
			summa,
			detail_of_pay,
			(SELECT namedepartment FROM `tab_catal_comm_dep` WHERE `id` = z_tab_invoice.business) as Biznes,
			dt_out_to_pay,
			dt_of_pay,
			(SELECT `nik` FROM `tab_access` WHERE `id` = z_tab_invoice.responsible) as resp,
			(SELECT `nik` FROM `tab_access` WHERE `id`=z_tab_invoice.manager) as man,
			(SELECT concat(`town`," ",`town_ua`," ",CAST( tab_area.region AS CHAR)," обл.") FROM `tab_town`,tab_area WHERE tab_town.area_id = tab_area.id and `tab_town`.id = z_tab_invoice.town) as twn,
			description	
		  INTO id_inv,Prtn,Kli,planer_id,dt_want,sap,num_inv,dt_inv,summ,purposePay,Biznes,dt_out,dt_pay,resp,man,twn,descr 
		FROM z_tab_invoice 
		WHERE id=idInv;	
		SELECT  id_inv as '#',Prtn as 'Партнер',Kli as 'Клиент',planer_id as 'ID планера',dt_want as 'Желаемая дата опл.',sap as '№ СПП',
			num_inv as '№ счета',dt_inv as 'Дата счета',summ as 'Сумма счета',purposePay as 'Назначение платежа',Biznes as 'Бизнес',
			dt_out as 'Дата передачи на оплату',dt_pay as 'Дата оплаты',resp as 'Ответственный',man as 'Менеджер',twn as 'Город',descr as 'Примечание';
	END IF;  
END
$$
DELIMITER ;



#CALL fieldsOfInvoice('*')
#CALL fieldsOfInvoice('8')
