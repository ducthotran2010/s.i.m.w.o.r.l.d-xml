package thotd.utils;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.List;

public class StringUtil implements Serializable {
    public static String parseInputStreamToString(InputStream inputStream) throws IOException {
        String line;
        StringBuilder stringBuilder = new StringBuilder();

        try (BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))) {
            while ((line = bufferedReader.readLine()) != null) {
                stringBuilder.append(line + "\n");
            }
        }

        return stringBuilder.toString();
    }

    public static InputStream parseStringToInputStream(String string) {
       return new ByteArrayInputStream(string.getBytes());
    }

    public static String insert(String parentString, String childString, int lineNumber, int columnNumber) {
        int count = 0;
        String[] lines = parentString.split("\n");
        String result = "";

        for (String line : lines) {
            if (count == lineNumber) {
                line = line.substring(0, columnNumber - 1) + childString + line.substring(columnNumber - 1);
            }
            result += line + "\n";
            count++;
        }

        return result;
    }

    public static boolean isStringStartWithListString(List<String> stringList, String parentString)  {
        for (String string: stringList) {
            if (parentString.startsWith(string)) {
                return true;
            }
        }

        return false;
    }
}
