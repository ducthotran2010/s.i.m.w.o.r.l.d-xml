package thotd.utils;

import java.io.Serializable;
import java.util.ArrayList;

public class SQLQueryUtil implements Serializable {
    public static String getConditions(String entryName, String operator, String delimiter, int length) {
        String condition = "";
        String formatedDelimiter = " " + delimiter.trim() + " ";
        String formatedOperator = " " + operator.trim() + " ";

        ArrayList<String> conditions = new ArrayList<>();
        for (int i = 0; i < length; ++i) {
            condition = entryName + formatedOperator + "?";
            conditions.add(condition);
        }

        String result = String.join(formatedDelimiter, conditions);
        if ( result.length() != 0) {
            result = "(" + result + ")";
        }

        return result;
    }
}
