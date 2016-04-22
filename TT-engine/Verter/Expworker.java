import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Created by morozvasiliy on 18.04.2016.
 */
public class Expworker {

    private int fullLoad; //общее количество ТТ в работает
    private int loadByClient; // количество ТТ в работе с этим клиентом
    private String idExpw; // id рабочего места из  expworkers.id

    Expworker (String expwid) {
        this.idExpw = expwid;
        this.loadByClient = 0;
        this.fullLoad = 0;
    }

    public String getIdExpw (){
        return this.idExpw;
    }

    public int getLoadByClient(String idClient) {


            try {
                ResultSet rs = null;
                rs = SqlConnect.getStmnt().executeQuery("SELECT COUNT(*) as quantity FROM `trubl`" +
                        " JOIN net_data ON trubl.inv_num_kli = net_data.id_data AND trubl.tab_on='7'" +
                        " WHERE `status_tt` IN (1,2) AND date_of_end = '0000-00-00' AND type_trubl_d IN (2,3) AND depend_on = 0 " +
                        " AND user_id = (SELECT id_num + id FROM expworkers WHERE id ='" + this.idExpw +
                        "') AND client = '" + idClient + " '");
                while (rs.next()) {
                    this.loadByClient = rs.getInt("quantity");
                }

            } catch (SQLException se) {
                se.printStackTrace();
            } finally {
                SqlConnect.closeConn();
            }

        return this.loadByClient;
    }

    public int getFullLoad() {

            try {
                ResultSet rs = null;
                rs = SqlConnect.getStmnt().executeQuery("SELECT COUNT(*) as quantity FROM `trubl`" +
                        " WHERE `status_tt` IN (1,2) AND date_of_end = '0000-00-00' AND type_trubl_d IN (2,3) AND depend_on = 0 " +
                        " AND user_id = (SELECT id_num + id FROM expworkers WHERE id ='" + this.idExpw + "')");
                while (rs.next()) {
                    this.fullLoad = rs.getInt("quantity");
                }

            } catch (SQLException se) {
                se.printStackTrace();
            } finally {
                SqlConnect.closeConn();
            }

        return this.fullLoad;
    }
}
