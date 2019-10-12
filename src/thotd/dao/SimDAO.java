package thotd.dao;

import thotd.generated.NetworkOperators;
import thotd.generated.Sim;
import thotd.utils.DBUtil;
import thotd.utils.SQLQueryUtil;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class SimDAO implements Serializable {

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


    private String getSearchQuery(String phone, String priceLimit, String[] startWiths, String[] notIncludes, String[] networkOperators) {
        String selectClause = "SELECT phone as PhoneNumber, price as Price, name as NetworkOperator, tagName as Tag FROM [Sim] AS S JOIN [NetworkOperator] AS N ON S.networkOperatorId = N.id JOIN [Tag] AS T ON S.tagId = T.id WHERE ";

        int[] lengths = {
                phone == null ? 0 : 1,
                priceLimit == null ? 0 : 1,
                startWiths == null ? 0 : startWiths.length,
                notIncludes == null ? 0 : notIncludes.length,
                networkOperators == null ? 0 : networkOperators.length,
        };

        String[] conditions = {
                SQLQueryUtil.getConditions("phone", "LIKE", "", lengths[0]),
                SQLQueryUtil.getConditions("price", "<=", "", lengths[1]),
                SQLQueryUtil.getConditions("phone", "LIKE", "OR", lengths[2]),
                SQLQueryUtil.getConditions("phone", "NOT LIKE", "OR", lengths[3]),
                SQLQueryUtil.getConditions("N.name", "=", "OR", lengths[4]),
        };

        ArrayList<String> filteredConditions =  new ArrayList<>();
        for (String condition: conditions) {
            if (condition.length() > 0) {
                filteredConditions.add(condition);
            }
        }
        String conditionClause = String.join(" AND ", filteredConditions);
        String formatClause = " FOR XML PATH('Sim'), ROOT('SimWorld')";
        String result = selectClause + conditionClause + formatClause;

        return result;
    }

    private int setStatementForField(int index, String field, String prefix, String suffix) throws SQLException {
        if (prefix == null) {
            prefix = "";
        }

        if (suffix == null) {
            suffix = "";
        }

        if (field != null) {
            statement.setString(++index, prefix + field + suffix);
        }
        return index;
    }


    private int setStatementForFields(int index, String[] fields, String prefix, String suffix) throws SQLException {
        if (prefix == null) {
            prefix = "";
        }

        if (suffix == null) {
            suffix = "";
        }

        if (fields != null) {
            for (String field: fields) {
                statement.setString(++index, prefix + field + suffix);
            }
        }
        return index;
    }

    public String search(String phone, String priceLimit, String[] startWiths, String[] notIncludes, String[] networkOperators) throws SQLException, ClassNotFoundException {
        String result = "";
        try {
            String query = getSearchQuery(phone, priceLimit, startWiths, notIncludes, networkOperators);
            connection = DBUtil.createConnection();
            statement = connection.prepareStatement(query);

            int index = 0;
            index = setStatementForField(index, phone, "%", "%");
            index = setStatementForField(index, priceLimit, null, null);
            index = setStatementForFields(index, startWiths, null, "%");
            index = setStatementForFields(index, notIncludes, "%", "%");
            setStatementForFields(index, networkOperators, null, null);

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
