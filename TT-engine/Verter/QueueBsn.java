import javax.swing.plaf.basic.BasicScrollPaneUI;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

/**
 * Created by morozvasiliy on 05.04.2016.
 */
public class QueueBsn extends Thread {

    @Override
    public void run() {

        Queue<InstanceTT> aTT = new PriorityQueue<InstanceTT>(); // tickets from queue
        HashSet<Expworker> aExpWrkrs = new HashSet<Expworker>(); // ingeneers for distributions tickets
        Queue<Task> tasks; //задачи (правила) для выполнения распределения (берутся из БД)

            tasks = loadSlaTasks(); // В tasks загрузить массив правил(задач), из БД, на распределение из очереди
            Iterator<Task> itasks = tasks.iterator();   // выполняем распределение по каждому правилу (задаче)
            while (itasks.hasNext()){
                Task locTask = itasks.next();
                runDistribution(locTask.getTTs(),locTask.getWorkers()); // непосредственное распределение тикетов на инженеров
            }



    }
    public static void runDistribution(Queue inTTs, HashSet<Expworker> inWorkers){ // распределить ТТ

        if (inTTs.size() > 0 && inWorkers.size() > 0) {
            System.out.println("[QueueBsn], количество TT:" + inTTs.size() + ", количество рабочих мест: " + inWorkers.size());
            String theBestwrkr = null;

            Iterator<InstanceTT> iter = inTTs.iterator();
            while (iter.hasNext()) { // пройти по каждому ТТ в массиве, распределить его на соответствующее рабочее место
                InstanceTT inTT = iter.next();
                theBestwrkr = getTheBestExpworker(inTT, inWorkers);
                //System.out.println("Возврат: " + theBestwrkr);
                if (theBestwrkr == null) break;
                //    System.out.println("Клиент:"+inTT.getIdClient());
                inTT.setExpworkersid(theBestwrkr); // Закрепляем ТТ за лучшим рабочим местом
                //System.out.println("[QueueBsn], ТТ: "+getNumTT()+" перезакреплен за рабочим местом "+inNewExpwrkrid);
            }


        }


    }
    public static String getTheBestExpworker(InstanceTT insTT, HashSet<Expworker> inaExpw) { // функция возвращает наилутчшее рабочее место для этого ТТ

        // Отсеиваем из массива рабочие места у которых меньше всего ТТ в работе
        HashSet<Expworker> minTTaExpw = getArrExpworkersByMinAmountTT(inaExpw);

        if (minTTaExpw.size() == 1) {  // Если рабочих мест с наименьшим количество  одно - возвращаем его
            ArrayList<Expworker> arrL = new ArrayList<Expworker>(minTTaExpw);
            return arrL.get(0).getIdExpw();

        } else {
            // если несколько рабочих мест с минимальным количеством ТТ
            // отсеиваем и отсавляем те у которыо наибольшее количество ТТ с этим же клиентом, возвращаем это значение
            HashSet<Expworker> maxClientsTTaExpw = getArrExpworkersByMaxAmountTTthisClient(insTT,minTTaExpw);
                ArrayList<Expworker> arrByClient = new ArrayList<Expworker>(maxClientsTTaExpw);
                return arrByClient.get(0).getIdExpw();
        }


    }

    private static HashSet<Expworker> getArrExpworkersByMinAmountTT (HashSet<Expworker> inArr){ //Получить массив рабочих мест  у которых наименьшее количество ТТ в работе

        // Находим значение наименьшего количество ТТ  в массиве рабочих мест
        int minAmmountOfTT = 1000000;
        int currentAmmountOfTT = 0;
        // Находим минимальное количество ТТ которое есть в массиве
        Iterator<Expworker> iter = inArr.iterator();
        while (iter.hasNext()) {
           currentAmmountOfTT = iter.next().getFullLoad();
            if (currentAmmountOfTT < minAmmountOfTT) {
                minAmmountOfTT = currentAmmountOfTT;
            }
        }
        // Копируем из inArr в outArr рабочие места у которых наименьшая загрузка в количестве ТТ
        HashSet<Expworker> outArr = new HashSet<Expworker>();
        Iterator<Expworker> iter2 = inArr.iterator();
        while (iter2.hasNext()) {
            Expworker worker = iter2.next();
            if (worker.getFullLoad() == minAmmountOfTT) {
                outArr.add(worker);//
                // System.out.println("В Список рабочих мест с наименьшим количеством добавлен: " + worker.getIdExpw() + " у него в работе: " + worker.getFullLoad());
            }
        }
        return outArr;
    }

    private static HashSet<Expworker> getArrExpworkersByMaxAmountTTthisClient (InstanceTT inTT, HashSet<Expworker> inArr){ //Получить массив рабочих мест  у которых наибольшее количество ТТ с этим клиентом
        Iterator <Expworker> iter = inArr.iterator();
        int maxTTwithClinet = 0;
        int currTTwithClient = 0;
        while (iter.hasNext()) { // находим максимальное количество ТТ (maxTTwithClinet) с этим типом клиента в массиве рабочих мест
            currTTwithClient = iter.next().getLoadByClient(inTT.getIdClient());
            if (currTTwithClient > maxTTwithClinet) maxTTwithClinet = currTTwithClient;
        }
        Iterator<Expworker> itermin = inArr.iterator();
        HashSet<Expworker> outArr = new HashSet<Expworker>();
        while (itermin.hasNext()){ // вносим в outArr все рабочие места у которых максимальное из набора количество ТТ с этим клиентом в работе
            Expworker operative = itermin.next();
            if (operative.getLoadByClient(inTT.getIdClient())==maxTTwithClinet)  outArr.add(operative);
        }
        return outArr;
    }

    private static Queue<Task> loadSlaTasks(){ //загрузить список правил (задач) на распределение ТТ)
        Queue<Task> outTasks = new PriorityQueue<Task>();

        try {
            ResultSet rs = null;
            rs = SqlConnect.getStmnt().executeQuery("SELECT firstOptions,secondOptions,thirdOptions,id " +
                    "FROM serv_queue_tt_verter WHERE name_queue LIKE 'VerterSlaInputQueue' ORDER BY id ASC");

            while (rs.next()) {
                outTasks.add(new Task(rs.getString("firstOptions"),rs.getString("secondOptions"),rs.getString("thirdOptions"),rs.getString("id")));
                //    System.out.println("TT= "+nTT);
            }



        }catch (SQLException se) {
            se.printStackTrace();
        } finally {
            SqlConnect.closeConn();
        }
    return outTasks;
    }
}

class  Task {
        private String[] from ;
        private String[] to;
        private String[] typeSLA;
        private String idTask;



        Task (String iFrom, String iTo, String iTypeSla,String id){
            this.from = iFrom.split(";");
            this.to = iTo.split(";");
            this.typeSLA = iTypeSla.split(";");
            this.idTask = id;

        }

    public Queue<InstanceTT> getTTs() { // для этого класса получить все ТТ которые необходимо распределить
         Queue<InstanceTT> inqTT = new PriorityQueue<InstanceTT>();
         String sumFrom =" AND (" ; //форсируем часть для запроса что бы получить ТТ закрепелнные за входящей очередью
            for (String e: this.from) {
                sumFrom = sumFrom+"expworkers.id='"+e+"' OR ";
            }
                sumFrom =sumFrom.substring(0,sumFrom.length()-3)+") ";
        //System.out.println("sumFrom="+sumFrom);

        String  sumTypeSla =" AND ("; //форсируем часть для запроса что бы получить ТТ определенного SLA
            for (String s: this.typeSLA) {
                sumTypeSla=sumTypeSla+"tab_sla_net_data.id='"+s+"' OR ";
            }
                sumTypeSla=sumTypeSla.substring(0,sumTypeSla.length()-3)+") ";
        //System.out.println("sumTypeSla="+sumTypeSla);

        ResultSet rs = null;
        try {
            //запросить все ТТ которые в этой очереди с этим СЛА (это будут ТТ только на СК)
            rs = SqlConnect.getStmnt().executeQuery("SELECT num_of_trubl_tick" +
                    " FROM trubl" +
                    " JOIN net_data ON trubl.inv_num_kli = net_data.id_data AND tab_on ='7'" +
                    " JOIN  tab_sla_net_data ON tab_sla_net_data.id = net_data.sla_id AND net_data.sla_d like 'tab_sla_net_data'" +
                    " WHERE date_of_end = '0000-00-00' "+sumTypeSla+" AND depend_on='0'" +
                    " AND trubl.user_id = (SELECT  expworkers.id_num+expworkers.id FROM expworkers WHERE expworkers.id >'0' "+sumFrom+" limit 1)");
            while (rs.next()) {

                inqTT.add(new InstanceTT(rs.getString("num_of_trubl_tick")));
                //    System.out.println("TT= "+nTT);
            }

        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            SqlConnect.closeConn();
        }
    return inqTT;
    }

    public HashSet<Expworker> getWorkers(){ // получить для этого класса все рабочие места на которые распределять ТТ
        HashSet<Expworker> outWorkers = new HashSet<Expworker>();
        String sumSQL = " AND (";
        for (String s: this.to){
            sumSQL=sumSQL+"resp_area.id = '"+s+"' OR ";
        }
            sumSQL=sumSQL.substring(0,sumSQL.length()-3)+") ";

        try {
        ResultSet rs = null;
        // получить все доступные места в рабочих группах в этом классе this.to
        rs = SqlConnect.getStmnt().executeQuery(" SELECT expworkers.id as idexpw" +
                " FROM resp_area" +
                " JOIN expworkers ON resp_area.num_area = expworkers.id_num AND expworkers.absence IN(0,3)" +
                " WHERE resp_area.id > '0'"+sumSQL);
        while (rs.next()) {
            String expw = rs.getString("idexpw");
            outWorkers.add(new Expworker(expw));
            //    System.out.println("Рабочее место: "+expw);
        }


    } catch (SQLException se) {
        se.printStackTrace();
    } finally {
        SqlConnect.closeConn();
    }

        return outWorkers;
    }
}
