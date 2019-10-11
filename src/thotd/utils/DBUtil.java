package thotd.utils;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil implements Serializable {
    public static Connection createConnection() throws SQLException, ClassNotFoundException{
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://localhost:1433;databaseName=SimWorld";
        Connection con = DriverManager.getConnection(url, "sa", "Ductho1998");
        return con;
    }
}

