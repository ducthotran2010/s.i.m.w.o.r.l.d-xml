package thotd.dao;

import thotd.constants.LoginConstant;
import thotd.dto.AccountDTO;
import thotd.utils.DBUtil;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AccountDAO implements Serializable {

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

    public String checkLogin(String username, String password) throws SQLException, ClassNotFoundException {
        String result = LoginConstant.LOGIN_FAIL;

        try {
            connection = DBUtil.createConnection();
            String query = "SELECT isRemoved FROM Account WHERE username = ? AND password = ?";

            statement = connection.prepareStatement(query);
            statement.setString(1, username);
            statement.setString(2, password);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                boolean isRemoved = resultSet.getBoolean("isRemoved");
                if (isRemoved) {
                    result = LoginConstant.LOGIN_INVALID;
                } else {
                    result = LoginConstant.LOGIN_SUCCESS;
                }
            }

        } finally {
          closeConnection();
        }

        return result;
    }

    public AccountDTO getAccountByUsername(String username) throws SQLException, ClassNotFoundException {
        AccountDTO result = null;

        try {
            connection = DBUtil.createConnection();
            String query = "SELECT fullName FROM Account WHERE username = ?";

            statement = connection.prepareStatement(query);
            statement.setString(1, username);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                String fullName = resultSet.getString("fullName");
                result = new AccountDTO(username, fullName);
            }
        } finally {
            closeConnection();
        }

        return result;
    }
}
