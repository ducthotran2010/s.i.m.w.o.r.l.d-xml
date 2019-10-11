package thotd.dao;

import thotd.generated.Sim;
import thotd.utils.DBUtil;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class SimDAO implements Serializable  {

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


    public boolean insert(Sim sim, int networkOperatorId, int tagId) throws SQLException, ClassNotFoundException {
        boolean result = false;
        try {
            connection = DBUtil.createConnection();
            String query = "INSERT INTO Sim (phone, price, networkOperatorId, tagId) VALUES (?, ?, ?, ?) ";

            statement = connection.prepareStatement(query);
            statement.setString(1, sim.getPhoneNumber());
            statement.setLong(2, sim.getPrice());
            statement.setInt(3, networkOperatorId);
            statement.setInt(4, tagId);
            result = statement.executeUpdate() > 0;
        } finally {
            closeConnection();
        }

        return result;
    }

    public boolean update(Sim sim, Integer networkOperatorId, Integer tagId) throws SQLException, ClassNotFoundException {
        boolean result = false;

        try {
            connection = DBUtil.createConnection();
            String query = "UPDATE Sim SET price = ?, networkOperatorId = ?, tagId = ? WHERE phone = ?";

            statement = connection.prepareStatement(query);
            statement.setLong(1, sim.getPrice());
            statement.setInt(2, networkOperatorId);
            statement.setInt(3, tagId);
            statement.setString(4, sim.getPhoneNumber());
            result = statement.executeUpdate() > 0;
        } finally {
            closeConnection();
        }

        return result;
    }

}
