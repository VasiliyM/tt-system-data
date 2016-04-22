import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Created by morozvasiliy on 18.04.2016.
 */
public class InstanceTT implements Comparable<InstanceTT> {

    private String numTT ;
    private String idClient;
    private String expWorkid;
    private String lastOwnerFromGroup;

    InstanceTT (String inTT){

        this.numTT=inTT;
        this.idClient="0";
    }

    public String getNumTT(){
        return this.numTT;
    }

    public String getIdClient() {

        if (this.idClient.equals("0")) {
            try {
                ResultSet rs = null;

                rs = SqlConnect.getStmnt().executeQuery("SELECT client FROM trubl " +
                        "JOIN net_data ON trubl.inv_num_kli = net_data.id_data AND trubl.tab_on='7'" +
                        " WHERE `num_of_trubl_tick` = '" + this.numTT + "'");

                while (rs.next()) {
                    this.idClient = rs.getString("client");
                }

            } catch (SQLException se) {
                se.printStackTrace();
            } finally {
                SqlConnect.closeConn();
            }
        }
        return this.idClient;
    }

    public void  setExpworkersid (String inNewExpwrkrid){

        try {

            SqlConnect.getStmnt().executeUpdate("UPDATE klients.trubl"+
                    " SET user_id = (SELECT id_num + id FROM expworkers WHERE id ='"+inNewExpwrkrid+"'),view_tt = '1'" +
                    " WHERE trubl.num_of_trubl_tick ='"+this.numTT+"'");
            System.out.println("[InstanceTT], ТТ: "+getNumTT()+" перезакреплен за рабочим местом "+inNewExpwrkrid);

            SqlConnect.getStmnt().executeUpdate("INSERT INTO `klients`.`zapisi_trubl_tic` " +
              "(`num_zap_trubl`, `num_trubl`, `date_zapisi`, `time_zapisi`, `desc_zapisi`, `name_user`, `kontakt`, `user_id`, " +
                    "`col_centr`, `transition`) VALUES (NULL, '"+this.numTT+"', '0000-00-00', '00:00:00', " +
                    "concat('Ответственный за ТТ: ',(SELECT worker FROM expworkers WHERE id ='"+inNewExpwrkrid+"'),'  (Robot Verter)') "+
                    ", 'автомат', '-',(SELECT id_num + id FROM expworkers WHERE id ='"+inNewExpwrkrid+"') , '0', '12')");

        }catch (SQLException se){ se.printStackTrace();
    }finally {SqlConnect.closeConn(); }

    }

    public int compareTo(InstanceTT o) {
        //сравниваем только по номеру ТТ
       return Integer.compare(Integer.parseInt(this.numTT),Integer.parseInt(o.getNumTT()));
    }
}
