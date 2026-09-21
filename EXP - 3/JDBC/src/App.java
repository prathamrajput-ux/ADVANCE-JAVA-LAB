import java.sql.*;

public class App {
    public static void main(String[] args) throws Exception {
        try (Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/college", 
            "root", 
            "2703"
        )) {
            System.out.println(con);
            System.out.println("Connection created");
        }
    }
}