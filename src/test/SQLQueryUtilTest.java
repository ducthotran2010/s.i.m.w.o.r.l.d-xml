package test;

import thotd.utils.SQLQueryUtil;

import java.util.ArrayList;

public class SQLQueryUtilTest {

    public static void main(String[] args) {

        int[] lengths = {
                0,
                1,
                0,
                0,
                0,
        };


        String[] conditions = {
                SQLQueryUtil.getConditions("phone", "LIKE", "", lengths[0]),
                SQLQueryUtil.getConditions("price", "<=", "", lengths[1]),
                SQLQueryUtil.getConditions("phone", "LIKE", "", lengths[2]),
                SQLQueryUtil.getConditions("phone", "LIKE", "OR", lengths[3]),
                SQLQueryUtil.getConditions("networkOperatorId", "<=", "OR", lengths[4]),
        };


        System.out.println(String.join(" AND ", conditions));

        ArrayList<String> filteredConditions =  new ArrayList<>();
        for (String condition: conditions) {
            if (condition.length() > 0) {
                filteredConditions.add(condition);
            }
        }

        System.out.println(String.join(" AND ", filteredConditions));
    }
}
