
SET @client = '611';
SELECT net_equip.in_exp, net_equip.modem_warrant_end,net_equip.trans_warrant_end, 
TIMESTAMPDIFF(MONTH, net_equip.in_exp, net_equip.modem_warrant_end) as tmonthModem,
TIMESTAMPDIFF(MONTH, net_equip.in_exp, net_equip.trans_warrant_end) as tmonthTransiver, 
DATE(NOW() + interval (TIMESTAMPDIFF(MONTH, net_equip.in_exp, net_equip.modem_warrant_end))  month)  as monthModem,
DATE(NOW() + interval (TIMESTAMPDIFF(MONTH, net_equip.in_exp, net_equip.trans_warrant_end)) month) as monthTransiver

FROM net_equip
JOIN office_kli ON office_kli.id_kli = net_equip.num_node AND net_equip.linkage='1'
WHERE office_kli.klient = @client AND net_equip.status_d = '2' 
ORDER BY net_equip.id_equip DESC LIMIT 5

-----------------------------------------------------------------------------------------------------------------------------
Рекомендуемая гарантия по модемам:
SET @client = '611';
SELECT net_equip.in_exp, net_equip.modem_warrant_end,net_equip.trans_warrant_end, 
TIMESTAMPDIFF(MONTH, net_equip.in_exp, net_equip.modem_warrant_end) as tmonthModem, COUNT(*),
DATE(NOW() + interval (TIMESTAMPDIFF(MONTH, net_equip.in_exp, net_equip.modem_warrant_end))  month)  as recWDATEforModem

FROM net_equip
JOIN office_kli ON office_kli.id_kli = net_equip.num_node AND net_equip.linkage='1'
WHERE office_kli.klient = @client AND net_equip.status_d = '2' AND net_equip.modem_warrant_end > '0000-00-00'
GROUP BY tmonthModem
ORDER BY net_equip.id_equip DESC LIMIT 5


-----------------------------------------------------------------------------------------------------------------------------
SELECT net_equip.in_exp, net_equip.modem_warrant_end, net_equip.trans_warrant_end
FROM net_equip
JOIN office_kli ON office_kli.id_kli = net_equip.num_node
AND net_equip.linkage = '1'
WHERE office_kli.klient = @client
AND net_equip.status_d = '2'
ORDER BY net_equip.id_equip DESC
LIMIT 5





SELECT *

FROM net_equip
JOIN office_kli ON office_kli.id_kli = net_equip.num_node AND net_equip.linkage='1'
WHERE office_kli.klient = 611 AND net_equip.status_d = '2'
ORDER BY net_equip.id_equip DESC LIMIT 5


31133
31132
31131
31130
31129

SELECT *  FROM `net_equip` WHERE `id_equip` IN(31133,31132,31131,31130,31129)