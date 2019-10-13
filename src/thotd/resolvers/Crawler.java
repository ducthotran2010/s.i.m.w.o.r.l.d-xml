package thotd.resolvers;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import thotd.utils.DocumentUtil;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPathExpressionException;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class Crawler implements Serializable {
    public static List<DOMResult> doCrawlForPaginatedSite(String xmlConfigPath, String xslPath, int totalPage) throws IOException, TransformerException, XPathExpressionException {
       /**
        * Parse XML Config to DOM
        */
        InputStream xmlInputStream = new FileInputStream(xmlConfigPath);
        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        DOMResult domResult = new DOMResult();
        Transformer transformer = transformerFactory.newTransformer();
        transformer.transform(new StreamSource(xmlInputStream), domResult);

        Document document = (Document) domResult.getNode();
        Node networkOperatorNode = document.getChildNodes().item(0);
        String href = networkOperatorNode.getAttributes().getNamedItem("href").getNodeValue();

        /**
         * Add page number into href attribute
         */
        StreamSource xslStreamSource = new StreamSource(xslPath);
        HtmlResolver htmlResolver = new HtmlResolver();
        transformerFactory.setURIResolver(htmlResolver);
        transformer = transformerFactory.newTransformer(xslStreamSource);

        ArrayList<DOMResult> domResults = new ArrayList<>(totalPage);
        for (int i = 1; i <= totalPage; i++) {
            domResult = new DOMResult();
            /* Update href attribute */
            String newHref = href + i;
            networkOperatorNode.getAttributes().getNamedItem("href").setNodeValue(newHref);

            InputStream inputStream = DocumentUtil.parseDocumentToInputStream(document);
            StreamSource streamSource = new StreamSource(inputStream);
            transformer.transform(streamSource, domResult);

            domResults.add(domResult);
        }


        return domResults;
    }

    public static DOMResult doCrawlForSingleSite(String xmlConfigPath, String xslPath) throws FileNotFoundException, TransformerException {
        StreamSource xslCate = new StreamSource(xslPath);
        InputStream inputStream = new FileInputStream(xmlConfigPath);

        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        DOMResult domResult = new DOMResult();

        HtmlResolver htmlResolver = new HtmlResolver();
        transformerFactory.setURIResolver(htmlResolver);
        Transformer transformer = transformerFactory.newTransformer(xslCate);

        StreamSource streamSource = new StreamSource(inputStream);
        transformer.transform(streamSource, domResult);
        return domResult;
    }
}
