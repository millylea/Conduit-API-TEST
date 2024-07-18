package helpers;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

import net.minidev.json.JSONObject;

public class DBHandler {

    private static String connectionUrl = "jdbc:sqlite:D:\\MyFinalProject\\Travelsite\\db.sqlite3";

    public static void addNewData(String name) {
        try (Connection connect = DriverManager.getConnection(connectionUrl)) {
            connect.createStatement().execute(
                    "INSERT into app_travel_contact (name, email, phone, subject, message, created_day) values ('"
                            + name + "','maimai', '312312', 'ter', 'fasd', '46543')");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static JSONObject getdata(String name) {
        JSONObject json = new JSONObject();

        try (Connection connect = DriverManager.getConnection(connectionUrl)) {
            ResultSet rs = connect.createStatement()
                    .executeQuery("SELECT * FROM app_travel_contact Where name ='" + name + "'");
            rs.next();
            json.put("email", rs.getString("email"));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return json;
    }

}
