package thotd.generator;

import thotd.constants.PathConstant;
import thotd.utils.JAXBUtil;

import java.io.IOException;

public class XMLGenerator {

    public static void main(String[] args) {
        System.out.println("------------------------------------------");
        System.out.println("START GENERATE PROCESS");
        for (String schema : PathConstant.CONFIG_SCHEMAS) {
            System.out.println("Starting to generate file: " + schema);
            try {
                JAXBUtil.generateClassFromSchema(schema, "");
                System.out.println("Object generated");
            } catch (IOException e) {
                e.printStackTrace();
                System.out.println("XMLGenerator: " + e);
            }
            System.out.println();
        }
        System.out.println("END GENERATE PROCESS");
        System.out.println("------------------------------------------");
    }
}
