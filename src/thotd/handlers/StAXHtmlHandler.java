package thotd.handlers;

import thotd.dto.HtmlTagDTO;
import thotd.utils.XMLUtil;

import javax.xml.stream.XMLEventReader;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.events.XMLEvent;
import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;
import java.util.Stack;

/**
 * NOT USE ANY MORE
 *
 * {@code HtmlHandler_draf} is base on of StAX parser
 * Orginal of this class is to handle missing close tag of XML.
 *
 */
public class StAXHtmlHandler implements Serializable {
    private InputStream inputStream;

    public StAXHtmlHandler(InputStream inputStream) {
        this.inputStream = inputStream;
    }

    public void doRefine() throws XMLStreamException, IOException {
        int count = 0;
        String tagName;
        Stack<HtmlTagDTO> tagStack = new Stack<>();
        Stack<Integer> marker = new Stack<>();
        XMLEventReader xmlEventReader = XMLUtil.parseInputStreamToXMLReader(inputStream);

        while (xmlEventReader.hasNext()) {
            XMLEvent xmlEvent = null;

            try {
                System.out.println("next....");
                xmlEvent = xmlEventReader.nextEvent();

                if (xmlEvent.isStartElement()) {
                    tagName = xmlEvent.asStartElement().getName().getLocalPart();
                    int offset = xmlEvent.getLocation().getCharacterOffset();
//                    tagStack.push(new HtmlDTO(offset, tagName));

                } else if (xmlEvent.isEndElement()) {
                    tagName = xmlEvent.asEndElement().getName().getLocalPart();
                    if (tagName.equals(tagStack.peek().getTagName())) {
                        tagStack.pop();
                    }
                }
            } catch (Exception e) {
                System.out.println("error hndled" + e);
//                String message = e.getMessage();
//                tagName = message.substring(message.indexOf("<") + 2, message.indexOf(">"));
//                System.out.println("got tagname: [" + tagName + "]");



                System.out.println("top stack: " + tagStack.peek().getTagName());
//                System.out.println("top stack: " + tagStack.peek().getId());

//                InputStream newStream = IOUtil.
//                xmlEvent = XMLU

                //handle...
//                while (!tagStack.empty()) {
//                    HtmlDTO htmlDTO = tagStack.pop();
//                    if (!tagName.equals(htmlDTO.getTagName())) {
//                        marker.push(htmlDTO.getId());
//                    } else {
//                        break;
//                    }
//                }

                break;
            }
        }
    }
}
