﻿<?php
ini_set('default_charset',"UTF-8");
include(__DIR__ . '/config.php');
use PhpAmqpLib\Connection\AMQPConnection;
use PhpAmqpLib\Message\AMQPMessage;

$exchange = 'router';
$queue = 'msgs';

$conn = new AMQPConnection(HOST, PORT, USER, PASS, VHOST);
$ch = $conn->channel();

/*
    The following code is the same both in the consumer and the producer.
    In this way we are sure we always have a queue to consume from and an
        exchange where to publish messages.
*/

/*
    name: $queue
    passive: false
    durable: true // the queue will survive server restarts
    exclusive: false // the queue can be accessed in other channels
    auto_delete: false //the queue won't be deleted once the channel is closed.
*/
$ch->queue_declare($queue, false, true, false, false);

/*
    name: $exchange
    type: direct
    passive: false
    durable: true // the exchange will survive server restarts
    auto_delete: false //the exchange won't be deleted once the channel is closed.
*/

$ch->exchange_declare($exchange, 'direct', false, true, false);

$ch->queue_bind($queue, $exchange);

$msg_body = '{
    "task": {
        "workid": 262050,
        "WBS": "0200031287-01",
        "POSID": "0000000010",
        "client": "Державна фіскальна служба України",
        "cltype": "ДКП",
        "lastmile": 0,
        "region_name": "Херсонская",
        "city": "Херсон",
        "street": "Ушакова",
        "bulding": "75",
        "strtype": "пр.",
        "mannage": "Миколенко Олександр Іванович#новый менед",
        "chtoDelat": "СУТЬ ЗАДАЧІ: ЦК, подаем отдельным портом, согласно ПТВ 261581, емкость 20 Мбит/сек. Трафик на ГО: Киев, Львовская пл. 8. Контакты на месте: АГ - Кутник Олег Григорович ,0958844187, тел. роб. (0552) 42-76-72 ИТ - Шадрiн Валерiй ?вгенович 0958262563, тел. роб. (0552)42-76-28. Данные по включению отправляем на Золотаренко Станислава.\nПРОРАБОТКА ТВ: 100048717/10\nПРОРАБОТКА ТВ. ПЛАНЕР: 261581\nТИП РОБІТ: Нова задача\nТЕХНОЛОГІЯ ПОСЛУГИ: Ethernet\nТИП ЗАСОБІВ ДОСТУПУ: ВОЛЗ\nТИП ІНТЕРФЕЙСУ: Ethernet\nШВИДКІСТЬ: 20\nОДИНИЦІ ВИМІРЮВАННЯ: Мбіт/с\nЗАПЛАНОВАНА ДАТА НАДАННЯ: 13.02.15\nТРАФІК: на ГО\nАДРЕС НА ГО: КИЕВ, ПЛ.ЛЬВІВСЬКА 8\nБЫЛО: 0 \nБУДЕТ: 20 \nНАЯВНІСТЬ ОСТАННЬОЇ МИЛІ: Ні\nЗАХИСТ КУЛЬОЧКА ПОТРІБЕН?: Так\nНЕОБХІДНІСТЬ БУДІВНИЦТВА ВОЛЗ?: Ні\nПОСЛУГА: Надання міжміського каналу ПД, підключ.\nАДРЕСА: Херсонская обл., Херсон, пр.Ушакова 75\nКОНТ.ОСОБА: Станіслав Золотаренко 0672435299\nВІДП.ПРОДАВЕЦЬ: Миколенко Олександр Іванович\n",
        "techname": "Р’РћР›РЎ",
        "typework": "Внедрение",
        "emplname": null,
        "otdel": "Технический",
        "wop": null,
        "wtd": null,
        "onWF": 1,
        "budgetbag": 1,
        "plannedEnd": "2015-03-23",
        "subwname": "Р’РєР»СЋС‡РµРЅРёРµ",
        "ktoPostavil": "btester@172.16.5.129",
        "salesorg": "Департамент корпоративного продажу",
        "STARTDATE": "2015-02-04 13:08:37",
        "Status": "В работе",
        "SAPID": "0200031287"
    },
    "services": {
        "refWork": 262050,
        "sertype": "Передача данных",
        "nameser": "Аренда междугородних каналов передачи данных",
        "inter": null,
        "VOLUMEB": 0,
        "VOLUMEE": 20,
        "name": "Мбит/с"
    },
    "comments": [
        {
            "refWork": 262050,
            "timestamp": "2015-02-04 13:08:37",
            "editorName": "btester@172.16.5.129",
            "comment": "Установка задачи на бизнес-процесс"
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-04 13:44:03",
            "editorName": "sattievrusta@10.12.152.19",
            "comment": "у клиента нужно заменить медиаконвертор на свитч с сфп.\r\nДругих затрат нет"
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-04 16:11:40",
            "editorName": "btester@172.16.5.115",
            "comment": " Принято Статус Изменен с: \"СТРО\", на: \"ПЛАН\", (NAPRIENKODMI)"
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-04 16:16:27",
            "editorName": "martinukserg@10.11.3.33",
            "comment": "Мягкое исключение.   Для внесений данных в САП, по Техникс Ресурс.\r\n\r\nРезерв  Будет создан на:\r\nМодуль SFP 0.1-1SM-1310nm-20SC - 1 штк\r\nКомутатор LS-S2309TP-EI-AC - 1штк  Ставим вместо Медика \r\n\r\nСхема Действующего ЦК - 252157:\r\nvpls 12459 --- Mpls-Kherson sap 1/1/3:2900 --- port 36 ZTE2936-Kherson-Privok-1-DWDM port 24 --- ВОК --- new sw/LS-S2309TP-EI-AC  Port 1 --- Клиент, ЦК  №1  \r\n   \r\n    Схема Нового ЦК\r\n vpls *** --- Mpls-Kherson sap 1/1/3:*** --- port 36 ZTE2936-Kherson-Privok-1-DWDM port 24 --- ВОК --- new sw/LS-S2309TP-EI-AC  p.2  --- Клиент, ЦК  №2 20М  \r\n"
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-04 17:03:37",
            "editorName": "sattievrusta@10.12.152.19",
            "comment": "кулек готов"
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-04 17:28:18",
            "editorName": "btester@172.16.5.115",
            "comment": " Принято Статус Изменен с: \"СТРО\", на: \"ПЛАН\", (NAPRIENKODMI)"
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-05 12:15:28",
            "editorName": "martinukserg@10.11.3.33",
            "comment": "На защиту и проведения работ.\r\nРезерв создан."
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-06 16:28:01",
            "editorName": "btester@172.16.5.129",
            "comment": " ок Статус Изменес с: \"КУТВ\", на: \"УТВЖ\", (KLIMENCHUKEV)"
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-11 10:44:15",
            "editorName": "bratslavskiy@.corp.ics.com.ua",
            "comment": "Switch, Huawei S2309TP-EI (172.17.55.33/24)\r\nг. Херсон, ул. Ушакова, 75, ДФСУ \r\nvlan 4055 - Man_access_Kherson \r\nсхема:\r\n{vpls 4055 vlan 4055} --- Mpls-Kherson sap 1/1/3:4055 --- port 36 ZTE2936-Kherson-Privok-1-DWDM port 24 --- ВОК --- gi0/0/1 Switch, Huawei S2309TP-EI (172.17.55.33/24) г. Херсон, ул. Ушакова, 75, ДФСУ \r\n\r\nПо нашей сети построен канал для \"Державна фіскальна служба України, Херсон, Ушакова, 75\"\r\nемкость канала - 20Мбит/с.\r\nсхема: \r\nМіністерство доходів і зборів України, Киев, Львовская 8 --- eth 0/0/14 Huawei S2326TP-EI ул. Смирнова-Ласточкина 16 [192.168.205.50] gi 0/0/1 --- gi 0/2 Cisco-ME-2CS-Kiev-SmirnovaLastochkina16 Gi0/3 --- RING --- (MPLS-Kiev-12 sap 1/1/3:1313) sap 1/1/23:1313 KievC002 --- {vpls 14748 vlan 1313} --- Mpls-Kherson sap 1/1/3:1313 --- port 36 ZTE2936-Kherson-Privok-1-DWDM port 24 --- ВОК --- gi0/0/1 Switch, Huawei S2309TP-EI (172.17.55.33/24) г. Херсон, ул. Ушакова, 75, ДФСУ Eth0/0/2 --- Державна фіскальна служба України, Херсон, Ушакова, 75\r\n\r\nСхема Действующего ЦК - 252157:\r\nvpls 12459 --- Mpls-Kherson sap 1/1/3:2900 --- port 36 ZTE2936-Kherson-Privok-1-DWDM port 24 --- ВОК --- gi0/0/1 Switch, Huawei S2309TP-EI (172.17.55.33/24) г. Херсон, ул. Ушакова, 75, ДФСУ Eth0/0/1 --- Державна фіскальна служба України, Херсон, Ушакова, 75"
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-11 14:42:33",
            "editorName": "bratslavskiy@.corp.ics.com.ua",
            "comment": "письмо на клиента и ответственного менеджера написано."
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-11 16:57:58",
            "editorName": "sattievrusta@10.12.152.19",
            "comment": "выполнено"
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-11 16:58:06",
            "editorName": "sattievrusta@10.12.152.19",
            "comment": "выполнено"
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-11 16:58:16",
            "editorName": "sattievrusta@10.12.152.19",
            "comment": "выполнено"
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-04 13:08:37",
            "editorName": "btester@172.16.5.129",
            "comment": null
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-04 13:08:37",
            "editorName": "btester@172.16.5.129",
            "comment": "Установка отдела по бизнес-процессу. Этап - Прописывание спецификаций, отдел - Регионы/Херсон плановая  длительность - 8 часов."
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-04 13:44:03",
            "editorName": "sattievrusta@10.12.152.19",
            "comment": "Установка отдела по бизнес-процессу. Этап - SAP. Утверждение строительной части, отдел - SAP. Утверждение строительной части плановая  длительность - 8 часов."
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-04 16:11:40",
            "editorName": "btester@172.16.5.115",
            "comment": "Установка отдела по бизнес-процессу. Этап - Прописание схемы, резервирование оборудования, отдел - Планирования сети плановая  длительность - 8 часов."
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-04 16:16:27",
            "editorName": "martinukserg@10.11.3.33",
            "comment": "Установка отдела по бизнес-процессу. Этап - Прописывание спецификаций, отдел - Регионы/Херсон плановая  длительность - 8 часов."
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-04 17:03:37",
            "editorName": "sattievrusta@10.12.152.19",
            "comment": "Установка отдела по бизнес-процессу. Этап - SAP. Утверждение строительной части, отдел - SAP. Утверждение строительной части плановая  длительность - 8 часов."
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-04 17:28:18",
            "editorName": "btester@172.16.5.115",
            "comment": "Установка отдела по бизнес-процессу. Этап - Прописание схемы, резервирование оборудования, отдел - Планирования сети плановая  длительность - 8 часов."
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-05 12:15:27",
            "editorName": "martinukserg@10.11.3.33",
            "comment": "Установка отдела по бизнес-процессу. Этап - SAP защита кулечка, отдел - SAP. Защита кулечка плановая  длительность - 24 часов."
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-06 16:28:01",
            "editorName": "btester@172.16.5.129",
            "comment": "Установка отдела по бизнес-процессу. Этап - Получеие/оплата счетов., отдел - Регионы/Херсон плановая  длительность - 56 часов."
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-10 11:46:08",
            "editorName": "sattievrusta@10.12.152.19",
            "comment": "Задача зaблокирована. Установлен статус  Ожидание материалов."
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-11 09:47:50",
            "editorName": "btester@172.16.5.129",
            "comment": "Задача разблокирована. Отменен статус  Ожидание материалов."
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-11 16:57:58",
            "editorName": "sattievrusta@10.12.152.19",
            "comment": "Установка отдела по бизнес-процессу. Этап - Монтаж внутренних кабелей ВОЛС, отдел - Регионы/Херсон плановая  длительность - 24 часов."
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-11 16:58:06",
            "editorName": "sattievrusta@10.12.152.19",
            "comment": "Установка отдела по бизнес-процессу. Этап - Монтаж активного оборудования, отдел - Регионы/Херсон плановая  длительность - 16 часов."
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-11 16:58:16",
            "editorName": "sattievrusta@10.12.152.19",
            "comment": "Установка отдела по бизнес-процессу. Этап - Подача услуги и контроль, отдел - Технический плановая  длительность - 24 часов."
        },
        {
            "refWork": 262050,
            "timestamp": "2015-02-11 17:00:59",
            "editorName": "balashevalex@.corp.ics.com.ua",
            "comment": "Назначен новый ответственный"
        }
    ]
}';
//echo $msg_body;
$msg = new AMQPMessage($msg_body, array('content_type' => 'text/plain', 'delivery_mode' => 2));
$ch->basic_publish($msg, $exchange);

//$ch->close();
$conn->close();

?>