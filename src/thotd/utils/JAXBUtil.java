package thotd.utils;
import com.sun.codemodel.internal.JCodeModel;
import com.sun.tools.internal.xjc.api.S2JJAXBModel;
import com.sun.tools.internal.xjc.api.SchemaCompiler;
import com.sun.tools.internal.xjc.api.XJC;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;
import thotd.constants.PathConstant;
import thotd.handlers.JAXBValidationHandler;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;
import java.io.*;

public class JAXBUtil implements Serializable {

    public static void generateClassFromSchema(String filePath) throws IOException {
        SchemaCompiler schemaCompiler = XJC.createSchemaCompiler();
        schemaCompiler.forcePackageName(PathConstant.PACKED_GENERATED_NAME);

        File schema = new File(filePath);
        InputSource inputSource = new InputSource(schema.toURI().toString());
        schemaCompiler.parseSchema(inputSource);
        S2JJAXBModel mode = schemaCompiler.bind();
        JCodeModel code = mode.generateCode(null, null);

        String sourcePackage = "src";
        code.build(new File(sourcePackage));
    }

    /**
     *
     * @param      objClass  the class of object wanted to unmarshal.
     * @param      node  the DOM node.
     *
     */
    public static Object unmarshal(Class<?> objClass, org.w3c.dom.Node node) throws JAXBException {
        JAXBContext context = JAXBContext.newInstance(objClass);
        Unmarshaller unmarshaller = context.createUnmarshaller();
        unmarshaller.setEventHandler(new JAXBValidationHandler());
        Object result = unmarshaller.unmarshal(node);

        return result;
    }
}
