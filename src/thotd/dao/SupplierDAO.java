package thotd.dao;

import thotd.constants.LoginConstant;
import thotd.dto.AccountDTO;
import thotd.utils.DBUtil;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class SupplierDAO implements Serializable {

    private Connection connection = null;
    private PreparedStatement statement = null;
    private ResultSet resultSet = null;

    private void closeConnection() throws SQLException {
        if (resultSet != null) {
            resultSet.close();
        }
        if (statement != null) {
            statement.close();
        }
        if (connection != null) {
            connection.close();
        }
    }

    public boolean insert(String supplier, String website) throws SQLException, ClassNotFoundException {
        boolean result = false;

        try {
            connection = DBUtil.createConnection();
            String query = "INSERT INTO Supplier (name, website) VALUES (?, ?) ";

            statement = connection.prepareStatement(query);
            statement.setString(1, supplier);
            statement.setString(2, website);
            result = statement.executeUpdate() > 0;
        } finally {
            closeConnection();
        }

        return result;
    }

    public Integer getIdByName(String name) throws SQLException, ClassNotFoundException {
        Integer result = null;

        try {
            connection = DBUtil.createConnection();
            String query = "SELECT id FROM Supplier WHERE name = ?";

            statement = connection.prepareStatement(query);
            statement.setString(1, name);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                result = resultSet.getInt("id");
            }
        } finally {
            closeConnection();
        }

        return result;
    }
}
