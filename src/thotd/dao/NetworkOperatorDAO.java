package thotd.dao;

import thotd.utils.DBUtil;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class NetworkOperatorDAO implements Serializable  {

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


    public boolean insert(String networkOperatorName) throws SQLException, ClassNotFoundException {
        boolean result = false;
        try {
            connection = DBUtil.createConnection();
            String query = "INSERT INTO NetworkOperator (name) VALUES (?) ";

            statement = connection.prepareStatement(query);
            statement.setString(1, networkOperatorName);
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
            String query = "SELECT id FROM NetworkOperator WHERE name = ?";

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
