package thotd.resolvers;

import org.xml.sax.SAXException;
import thotd.constants.DomainConstant;
import thotd.dto.HtmlTagDTO;
import thotd.handlers.SAXHtmlHandler;
import thotd.refiners.XMLRefiner;
import thotd.utils.StringUtil;

import java.io.*;
import java.lang.String;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.stream.*;
import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamSource;
import java.net.URL;
import java.net.URLConnection;
import java.util.Stack;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.jsoup.Jsoup;

public class HtmlResolver implements URIResolver, Serializable {
    @Override
    public Source resolve(String href, String base) {
        System.out.println("here....");
        if (href != null && StringUtil.isStringStartWithListString(DomainConstant.DOMAIN_LIST, href)) {
            System.out.println("good choose");
            try {
                URLConnection urlConnection = new URL(href).openConnection();
                StreamSource streamSource;
                try (InputStream http = urlConnection.getInputStream()) {
                    streamSource = preProcessInputStream(http);
                    return streamSource;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    private String removeComment(String source) {
        String expression = "<!--.*?-->";
        return source.replaceAll(expression, "");
    }

    private String removeTag(String source, String tagName) {
        String expression = "<" + tagName + ".*?</" + tagName + ">";
        return source.replaceAll(expression, "");
    }

    /**
     * Get the first matched {@code tag} in {@code source}
     * if not match return the original {@code source}
     *
     * @param source  the http source as a string.
     * @param tagName the initial capacity.
     */
    private String getTag(String source, String tagName) {
        String result = source;
        String expression = "<" + tagName + ".*?</" + tagName + ">";
        Pattern pattern = Pattern.compile(expression);
        Matcher matcher = pattern.matcher(source);

        if (matcher.find()) {
            result = matcher.group(0);
        }

        return result;
    }

    private StreamSource preProcessInputStream(InputStream http) throws IOException {

        String httpString = "<html>" + StringUtil.parseInputStreamToString(http) + "</html>";


        httpString = httpString.replaceAll("\n", "");
        httpString = httpString.replaceAll("&nbsp;", "");
        httpString = getTag(httpString, "body");
        httpString = removeTag(httpString, "script");
        httpString = removeTag(httpString, "style");
        httpString = removeComment(httpString);

        XMLRefiner xmlRefiner = new XMLRefiner();
        httpString = xmlRefiner.doRefine(httpString);

        http = StringUtil.parseStringToInputStream(httpString);

        return new StreamSource(http);
    }


    /**
     * NOT USE ANY MORE
     * <p>
     * Refine by adding missed close tag in {@code inputStream}
     *
     * @param inputStream the http source as a string.
     */
    private InputStream doRefine(InputStream inputStream) throws ParserConfigurationException, SAXException, IOException {
        boolean isWellFormed = false;
        String httpString = StringUtil.parseInputStreamToString(inputStream);
        httpString = httpString.replaceAll("&", "&amp;");
        inputStream = StringUtil.parseStringToInputStream(httpString);

        SAXHtmlHandler SAXHtmlHandler = new SAXHtmlHandler();
        SAXParserFactory saxParserFactory = SAXParserFactory.newInstance();
        SAXParser saxParser = saxParserFactory.newSAXParser();

        while (!isWellFormed) {
            try {
                saxParser.parse(inputStream, SAXHtmlHandler);
                isWellFormed = true;
            } catch (SAXException | IOException e) {
                Stack<HtmlTagDTO> stack = SAXHtmlHandler.tagStack();
                HtmlTagDTO htmlTagDTO = stack.peek();
                SAXHtmlHandler.tagStack().clear();

                String closeTag = "</" + htmlTagDTO.getTagName() + ">";
                httpString = StringUtil.insert(httpString, closeTag, htmlTagDTO.getLineNumber() - 1, htmlTagDTO.getColumnNumber());
                inputStream = StringUtil.parseStringToInputStream(httpString);
            }
        }
        httpString = httpString.replaceAll("[\n]+", "").replaceAll("[  ]+", " ");

        return StringUtil.parseStringToInputStream(httpString);
    }
}
