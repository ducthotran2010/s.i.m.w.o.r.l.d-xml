package thotd.dto;

import org.xml.sax.Locator;

import java.io.Serializable;

public class HtmlTagDTO implements Serializable {
    private String tagName;
    private int lineNumber;
    private int columnNumber;

    public HtmlTagDTO(String tagName, int lineNumber, int columnNumber) {
        this.tagName = tagName;
        this.lineNumber = lineNumber;
        this.columnNumber = columnNumber;
    }

    public String getTagName() {
        return tagName;
    }

    public int getLineNumber() {
        return lineNumber;
    }

    public int getColumnNumber() {
        return columnNumber;
    }

    @Override
    public String toString() {
        return "HtmlTagDTO{" +
                "tagName='" + tagName + '\'' +
                ", lineNumber=" + lineNumber +
                ", columnNumber=" + columnNumber +
                '}';
    }
}
