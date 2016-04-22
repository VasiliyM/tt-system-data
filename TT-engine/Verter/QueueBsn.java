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
        Queue<Task> tasks; //������ (�������) ��� ���������� ������������� (������� �� ��)

            tasks = loadSlaTasks(); // � tasks ��������� ������ ������(�����), �� ��, �� ������������� �� �������
            Iterator<Task> itasks = tasks.iterator();   // ��������� ������������� �� ������� ������� (������)
            while (itasks.hasNext()){
                Task locTask = itasks.next();
                runDistribution(locTask.getTTs(),locTask.getWorkers()); // ���������������� ������������� ������� �� ���������
            }



    }
    public static void runDistribution(Queue inTTs, HashSet<Expworker> inWorkers){ // ������������ ��

        if (inTTs.size() > 0 && inWorkers.size() > 0) {
            System.out.println("[QueueBsn], ���������� TT:" + inTTs.size() + ", ���������� ������� ����: " + inWorkers.size());
            String theBestwrkr = null;

            Iterator<InstanceTT> iter = inTTs.iterator();
            while (iter.hasNext()) { // ������ �� ������� �� � �������, ������������ ��� �� ��������������� ������� �����
                InstanceTT inTT = iter.next();
                theBestwrkr = getTheBestExpworker(inTT, inWorkers);
                //System.out.println("�������: " + theBestwrkr);
                if (theBestwrkr == null) break;
                //    System.out.println("������:"+inTT.getIdClient());
                inTT.setExpworkersid(theBestwrkr); // ���������� �� �� ������ ������� ������
                //System.out.println("[QueueBsn], ��: "+getNumTT()+" ������������� �� ������� ������ "+inNewExpwrkrid);
            }


        }


    }
    public static String getTheBestExpworker(InstanceTT insTT, HashSet<Expworker> inaExpw) { // ������� ���������� ���������� ������� ����� ��� ����� ��

        // ��������� �� ������� ������� ����� � ������� ������ ����� �� � ������
        HashSet<Expworker> minTTaExpw = getArrExpworkersByMinAmountTT(inaExpw);

        if (minTTaExpw.size() == 1) {  // ���� ������� ���� � ���������� ����������  ���� - ���������� ���
            ArrayList<Expworker> arrL = new ArrayList<Expworker>(minTTaExpw);
            return arrL.get(0).getIdExpw();

        } else {
            // ���� ��������� ������� ���� � ����������� ����������� ��
            // ��������� � ��������� �� � ������� ���������� ���������� �� � ���� �� ��������, ���������� ��� ��������
            HashSet<Expworker> maxClientsTTaExpw = getArrExpworkersByMaxAmountTTthisClient(insTT,minTTaExpw);
                ArrayList<Expworker> arrByClient = new ArrayList<Expworker>(maxClientsTTaExpw);
                return arrByClient.get(0).getIdExpw();
        }


    }

    private static HashSet<Expworker> getArrExpworkersByMinAmountTT (HashSet<Expworker> inArr){ //�������� ������ ������� ����  � ������� ���������� ���������� �� � ������

        // ������� �������� ����������� ���������� ��  � ������� ������� ����
        int minAmmountOfTT = 1000000;
        int currentAmmountOfTT = 0;
        // ������� ����������� ���������� �� ������� ���� � �������
        Iterator<Expworker> iter = inArr.iterator();
        while (iter.hasNext()) {
           currentAmmountOfTT = iter.next().getFullLoad();
            if (currentAmmountOfTT < minAmmountOfTT) {
                minAmmountOfTT = currentAmmountOfTT;
            }
        }
        // �������� �� inArr � outArr ������� ����� � ������� ���������� �������� � ���������� ��
        HashSet<Expworker> outArr = new HashSet<Expworker>();
        Iterator<Expworker> iter2 = inArr.iterator();
        while (iter2.hasNext()) {
            Expworker worker = iter2.next();
            if (worker.getFullLoad() == minAmmountOfTT) {
                outArr.add(worker);//
                // System.out.println("� ������ ������� ���� � ���������� ����������� ��������: " + worker.getIdExpw() + " � ���� � ������: " + worker.getFullLoad());
            }
        }
        return outArr;
    }

    private static HashSet<Expworker> getArrExpworkersByMaxAmountTTthisClient (InstanceTT inTT, HashSet<Expworker> inArr){ //�������� ������ ������� ����  � ������� ���������� ���������� �� � ���� ��������
        Iterator <Expworker> iter = inArr.iterator();
        int maxTTwithClinet = 0;
        int currTTwithClient = 0;
        while (iter.hasNext()) { // ������� ������������ ���������� �� (maxTTwithClinet) � ���� ����� ������� � ������� ������� ����
            currTTwithClient = iter.next().getLoadByClient(inTT.getIdClient());
            if (currTTwithClient > maxTTwithClinet) maxTTwithClinet = currTTwithClient;
        }
        Iterator<Expworker> itermin = inArr.iterator();
        HashSet<Expworker> outArr = new HashSet<Expworker>();
        while (itermin.hasNext()){ // ������ � outArr ��� ������� ����� � ������� ������������ �� ������ ���������� �� � ���� �������� � ������
            Expworker operative = itermin.next();
            if (operative.getLoadByClient(inTT.getIdClient())==maxTTwithClinet)  outArr.add(operative);
        }
        return outArr;
    }

    private static Queue<Task> loadSlaTasks(){ //��������� ������ ������ (�����) �� ������������� ��)
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

    public Queue<InstanceTT> getTTs() { // ��� ����� ������ �������� ��� �� ������� ���������� ������������
         Queue<InstanceTT> inqTT = new PriorityQueue<InstanceTT>();
         String sumFrom =" AND (" ; //��������� ����� ��� ������� ��� �� �������� �� ������������ �� �������� ��������
            for (String e: this.from) {
                sumFrom = sumFrom+"expworkers.id='"+e+"' OR ";
            }
                sumFrom =sumFrom.substring(0,sumFrom.length()-3)+") ";
        //System.out.println("sumFrom="+sumFrom);

        String  sumTypeSla =" AND ("; //��������� ����� ��� ������� ��� �� �������� �� ������������� SLA
            for (String s: this.typeSLA) {
                sumTypeSla=sumTypeSla+"tab_sla_net_data.id='"+s+"' OR ";
            }
                sumTypeSla=sumTypeSla.substring(0,sumTypeSla.length()-3)+") ";
        //System.out.println("sumTypeSla="+sumTypeSla);

        ResultSet rs = null;
        try {
            //��������� ��� �� ������� � ���� ������� � ���� ��� (��� ����� �� ������ �� ��)
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

    public HashSet<Expworker> getWorkers(){ // �������� ��� ����� ������ ��� ������� ����� �� ������� ������������ ��
        HashSet<Expworker> outWorkers = new HashSet<Expworker>();
        String sumSQL = " AND (";
        for (String s: this.to){
            sumSQL=sumSQL+"resp_area.id = '"+s+"' OR ";
        }
            sumSQL=sumSQL.substring(0,sumSQL.length()-3)+") ";

        try {
        ResultSet rs = null;
        // �������� ��� ��������� ����� � ������� ������� � ���� ������ this.to
        rs = SqlConnect.getStmnt().executeQuery(" SELECT expworkers.id as idexpw" +
                " FROM resp_area" +
                " JOIN expworkers ON resp_area.num_area = expworkers.id_num AND expworkers.absence IN(0,3)" +
                " WHERE resp_area.id > '0'"+sumSQL);
        while (rs.next()) {
            String expw = rs.getString("idexpw");
            outWorkers.add(new Expworker(expw));
            //    System.out.println("������� �����: "+expw);
        }


    } catch (SQLException se) {
        se.printStackTrace();
    } finally {
        SqlConnect.closeConn();
    }

        return outWorkers;
    }
}
