<?php
ini_set('default_charset',"UTF-8");
include(__DIR__ . '/config.php');
use PhpAmqpLib\Connection\AMQPConnection;
use PhpAmqpLib\Message\AMQPMessage;

//$exchange = 'basic_get_test';
//$queue = 'basic_get_queue';

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

//$ch->exchange_declare($exchange, 'direct', false, true, false);

//$ch->queue_bind($queue, $exchange);

//$toSend = new AMQPMessage('test message', array('content_type' => 'text/plain', 'delivery_mode' => 2));
//$ch->basic_publish($toSend, $exchange);
$msg = $ch->basic_get($queue);

$ch->basic_ack($msg->delivery_info['delivery_tag']);
//Open database connection
$mysqli = mysqli_connect($host,$user,$password,$db) or die("Error " . mysqli_error($mysqli));
// Block Decode json-file ================================================
$arr = json_decode(trim($msg->body),true);
//var_dump($arr);
echo json_last_error(); // 4 (JSON_ERROR_SYNTAX)
echo '</br>';
//$ch->close();
$conn->close();
// Block MySQL ============================================================
// task insert
$workid      = mysql_escape_string($arr['task']['workid']);
$WBS         = mysql_escape_string($arr['task']['WBS']);
$POSID       = mysql_escape_string($arr['task']['POSID']);
$client      = mysql_escape_string($arr['task']['client']);
$cltype      = mysql_escape_string($arr['task']['cltype']);
$lastmile    = mysql_escape_string($arr['task']['lastmile']);
$region_name = mysql_escape_string($arr['task']['region_name']);
$city        = mysql_escape_string($arr['task']['city']);
$street      = mysql_escape_string($arr['task']['street']);
$bulding     = mysql_escape_string($arr['task']['bulding']);
$strtype     = mysql_escape_string($arr['task']['strtype']);
$mannage     = mysql_escape_string($arr['task']['mannage']);
$chtoDelat   = mysql_escape_string($arr['task']['chtoDelat']);
$techname    = mysql_escape_string($arr['task']['techname']);
$typework    = mysql_escape_string($arr['task']['typework']);
$emplname    = mysql_escape_string($arr['task']['emplname']);
$otdel       = mysql_escape_string($arr['task']['otdel']);
$wop         = mysql_escape_string($arr['task']['wop']);
$wtd         = mysql_escape_string($arr['task']['wtd']);
$onWF        = mysql_escape_string($arr['task']['onWF']);
$budgetbag   = mysql_escape_string($arr['task']['budgetbag']);
$plannedEnd  = mysql_escape_string($arr['task']['plannedEnd']);
$subwname    = mysql_escape_string($arr['task']['subwname']);
$ktoPostavil = mysql_escape_string($arr['task']['ktoPostavil']);
$salesorg    = mysql_escape_string($arr['task']['salesorg']);
$STARTDATE   = mysql_escape_string($arr['task']['STARTDATE']);
$Status      = mysql_escape_string($arr['task']['Status']);
$SAPID       = mysql_escape_string($arr['task']['SAPID']);
$sql = "INSERT INTO plan_task (workid,WBS,POSID,client,cltype,lastmile,region_name,city,street,bulding,strtype,
                mannage,chtoDelat,techname,typework,emplname,otdel,wop,wtd,onWF,budgetbag,plannedEnd,subwname,ktoPostavil,salesorg,STARTDATE,Status,SAPID)
                VALUES ('$workid','$WBS','$POSID','$client','$cltype','$lastmile','$region_name','$city','$street','$bulding','$strtype',
                '$mannage','$chtoDelat','$techname','$typework','$emplname','$otdel','$wop','$wtd','$onWF','$budgetbag','$plannedEnd','$subwname','$ktoPostavil','$salesorg','$STARTDATE','$Status','$SAPID')";
$res = mysqli_query($mysqli, $sql);
//echo $sql.'<br>';
// services insert
$refWork=mysql_escape_string($arr['services']['refWork']);
$sertype=mysql_escape_string($arr['services']['sertype']);
$nameser=mysql_escape_string($arr['services']['nameser']);
$inter=mysql_escape_string($arr['services']['inter']);
$VOLUMEB=mysql_escape_string($arr['services']['VOLUMEB']);
$VOLUMEE=mysql_escape_string($arr['services']['VOLUMEE']);
$name=mysql_escape_string($arr['services']['name']);
$sql = "INSERT INTO plan_services (refWork,sertype,nameser,inter,VOLUMEB,VOLUMEE,`name`)
        VALUES ('$refWork','$sertype','$nameser','$inter','$VOLUMEB','$VOLUMEE','$name')";
$res = mysqli_query($mysqli, $sql);
//echo $sql.'<br>';
// comments insert
foreach($arr['comments'] as $value) {
    $refWork=mysql_escape_string($value['refWork']);
    $timestamp=mysql_escape_string($value['timestamp']);
    $editorName=mysql_escape_string($value['editorName']);
    $comment=mysql_escape_string($value['comment']);
    $sql = "INSERT INTO plan_comments (refWork,`timestamp`,editorName,comment)
            VALUES ('$refWork','$timestamp','$editorName','$comment')";
    $res = mysqli_query($mysqli, $sql);
    //echo $sql.'<br>';
}

mysqli_close($mysqli);
