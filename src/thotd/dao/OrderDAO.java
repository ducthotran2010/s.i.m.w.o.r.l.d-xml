package thotd.dao;

import thotd.generated.orders.Order;
import thotd.utils.DBUtil;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class OrderDAO implements Serializable  {

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


    public boolean insert(Order order) throws SQLException, ClassNotFoundException {
        boolean result = false;
        try {
            connection = DBUtil.createConnection();
            String query = "INSERT INTO [Order] (name, phoneMask, timestamp) VALUES (?, ?, ?) ";

            statement = connection.prepareStatement(query);
            statement.setString(1, order.getName());
            statement.setString(2, order.getPhoneMask());
            statement.setString(3, order.getTimestamp());
            result = statement.executeUpdate() > 0;
        } finally {
            closeConnection();
        }

        return result;
    }

    public String search(String phoneNumber) throws SQLException, ClassNotFoundException {
        String result = "";

        try {
            connection = DBUtil.createConnection();
            String query = "SELECT name as Name, phoneMask as PhoneMask, timestamp as Timestamp FROM [ORDER] WHERE ? LIKE phoneMask FOR XML Path('Order'), Root('Orders')";

            statement = connection.prepareStatement(query);
            statement.setString(1, phoneNumber);
            resultSet = statement.executeQuery();

            while (resultSet.next())  {
                result += resultSet.getString(1);
            }
        } finally {
            closeConnection();
        }

        return result;
    }
}
