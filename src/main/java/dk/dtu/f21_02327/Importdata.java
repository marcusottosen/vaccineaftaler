package dk.dtu.f21_02327;
import java.sql.*;

public class Importdata {
    //Connectionindstillinger
    String HOST     = "localhost";
    int PORT        = 3306;
    String DATABASE  = "vaccineberedskabet";
    String USERNAME = "root";
    String PASSWORD = "Gce59hgh";

    String url = "jdbc:mysql://" + HOST + ":" + PORT + "/" + DATABASE + "?user=root";
    public Connection connection;

    {
        try {
            //Opret forbindelse
            connection = DriverManager.getConnection(url, USERNAME, PASSWORD);
        } catch (SQLException throwables) {
            //Ved forbindelsesfejl
            System.out.println("Kunne ikke oprette forbindelse til databasen");
        }
    }

    //Indsættelse af appointments i databasen
    public void Importdata(long cprnr, String name, Date date, Time time, String vaccinetype, String location) throws SQLException {
        PreparedStatement datainsert = connection.prepareStatement("INSERT INTO Appointment (daily_appointment_ID, CPR, appointment_name, appointment_date, appointment_time, vaccine_type, city) VALUES (?, ?, ?, ?, ?, ?, ?) ");
        datainsert.setString(1,null);
        datainsert.setLong(2, cprnr);
        datainsert.setString(3, name);
        datainsert.setDate(4, date);
        datainsert.setTime(5, time);
        datainsert.setString(6, vaccinetype);
        datainsert.setString(7, location);
       datainsert.executeUpdate();
    }
}
