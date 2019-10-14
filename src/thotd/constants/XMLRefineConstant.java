package thotd.constants;

import java.util.Arrays;
import java.util.List;

public class XMLRefineConstant {
        public static final String CONTENT = "content";
        public static final String OPEN_BRACKET = "openBracket";
        public static final String OPEN_TAG_NAME = "openTagName";
        public static final String TAG_INNER = "tagInner";
        public static final String ATTR_NAME = "attributeName";
        public static final String EQUAL_WAIT = "equalWait";
        public static final String EQUAL = "equal";
        public static final String ATTR_VALUE_NQ = "nonQuotedAttributeValue";
        public static final String ATTR_VALUE_Q = "quotedAttributeValue";
        public static final String EMPTY_SLASH = "emptyTagSlash";
        public static final String CLOSE_BRACKET = "closeBracket";
        public static final String CLOSE_TAG_SLASH = "closeTagSlash";
        public static final String CLOSE_TAG_NAME = "closeTagName";
        public static final String WAIT_END_TAG_CLOSE = "waitEndTagClose";

        public static final List<String> INLINE_TAGS = Arrays.asList(
                "area", "base", "br", "col", "command", "embed", "hr",
                "img", "input", "keygen", "link", "meta", "param", "source",
                "track", "wbr");
}
