package thotd.utils;

import java.io.Serializable;

public class PhongThuyUtil implements Serializable {
    public static Integer getNumber(String phoneNumber) {
        Integer result = null;
        String last4Digit = phoneNumber.substring(6);

        try {
            result = Integer.parseInt(last4Digit);
        } catch (Exception e) {
        }

        if (result == null) return null;

        float a = (float) (result * 1.0 / 80);
        float b = (float) (a - Math.floor(a));
        float c = b * 80;
        result = Math.round(c);

        return result;
    }
}
