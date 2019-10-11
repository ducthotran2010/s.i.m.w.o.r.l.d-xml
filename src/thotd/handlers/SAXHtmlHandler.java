package thotd.handlers;

import org.xml.sax.Attributes;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;
import thotd.dto.HtmlTagDTO;

import java.io.Serializable;
import java.util.*;

/**
 * NOT USE ANY MORE
 *
 * {@code HtmlHandler} is base on DefaultHanlder of SAX parser.
 * This class is used to handle missing close tag of XML.
 *
 */
public class SAXHtmlHandler extends DefaultHandler implements Serializable {
    private Stack<HtmlTagDTO> tagStack;
    private Locator locator;

    public SAXHtmlHandler() {
        tagStack = new Stack<>();
    }

    @Override
    public void processingInstruction(String target, String data) throws SAXException {
        super.processingInstruction(target, data);

        System.out.println(target + "_" + data + ": " + locator.getLineNumber() + ", " + locator.getColumnNumber());
    }

    @Override
    public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
        HtmlTagDTO htmlTagDTO = new HtmlTagDTO(qName, locator.getLineNumber(), locator.getColumnNumber());
        System.out.println(htmlTagDTO);
        for (int i = 0; i < attributes.getLength(); ++i) {
            System.out.println(attributes.getQName(i) + ":" + attributes.getValue(i));
        }
        tagStack.push(htmlTagDTO);

        super.startElement(uri, localName, qName, attributes);
    }

    @Override
    public void endElement(String uri, String localName, String qName) throws SAXException {
        super.endElement(uri, localName, qName);
        while (!tagStack.empty()) {
            HtmlTagDTO htmlTagDTO = tagStack.pop();
            if (qName.equals(htmlTagDTO.getTagName())) {
                return;
            }
        }
    }

    public void setDocumentLocator(Locator locator) {
        this.locator = locator;
    }

    public Stack<HtmlTagDTO> tagStack() {
        return tagStack;
    }
}
