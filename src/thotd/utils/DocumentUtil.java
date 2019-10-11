package thotd.utils;

import com.sun.org.apache.xml.internal.serialize.OutputFormat;
import com.sun.org.apache.xml.internal.serialize.XMLSerializer;
import org.w3c.dom.Document;

import java.io.*;

public class DocumentUtil implements Serializable {

    public static InputStream parseDocumentToInputStream(Document document) throws IOException {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        OutputFormat outputFormat = new OutputFormat(document);
        XMLSerializer xmlSerializer = new XMLSerializer(outputStream, outputFormat);
        xmlSerializer.serialize(document);
        return new ByteArrayInputStream(outputStream.toByteArray());
    }

}
