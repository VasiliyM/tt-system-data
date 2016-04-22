/**
 * Created by morozvasiliy on 15.04.2016.
 */
public class test {
    public static void main(String[] args){
        System.out.println("Запускаем QueueBsn");
        QueueBsn a = new QueueBsn();
        try {
            a.start();
            a.join();
        }catch (InterruptedException ez){
            ez.printStackTrace();}
        }
}
