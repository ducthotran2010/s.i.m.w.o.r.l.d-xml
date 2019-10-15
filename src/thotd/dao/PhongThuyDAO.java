package thotd.dao;

import thotd.generated.phongthuy.Section;
import thotd.utils.DBUtil;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PhongThuyDAO implements Serializable {


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

    public boolean insert(Section section) throws SQLException, ClassNotFoundException {
        boolean result = false;
        try {
            connection = DBUtil.createConnection();
            String query = "INSERT INTO [PhongThuy] (number, mean, brief) VALUES (?, ?, ?) ";

            statement = connection.prepareStatement(query);
            statement.setInt(1, section.getNumber());
            statement.setString(2, section.getMean());
            statement.setString(3, section.getBrief());
            result = statement.executeUpdate() > 0;
        } finally {
            closeConnection();
        }

        return result;
    }

    public String getAll() throws SQLException, ClassNotFoundException {
        String result = "";

        try {
            connection = DBUtil.createConnection();
            String query = "SELECT number as Number, mean as Mean, brief as Brief FROM [PhongThuy] FOR XML PATH('Section'), ROOT('PhongThuy') ";

            statement = connection.prepareStatement(query);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                result += resultSet.getString(1);
            }
        } finally {
            closeConnection();
        }

        return result;
    }

}
