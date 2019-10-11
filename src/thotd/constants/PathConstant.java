package thotd.constants;

import java.util.Arrays;
import java.util.List;

public class PathConstant {
    public static final String PACKED_GENERATED_NAME = "thotd.generated";

    public static final String CONFIG_XML_DOMAIN = "assests/configs/xml/domain.xml";
    public static final String CONFIG_XML_SODEPAMI = "assests/configs/xml/sodepami.xml";
    public static final String CONFIG_XSL_SODEPAMI = "assests/configs/xsl/sodepami.xsl";

    public static final List<String> CONFIG_SCHEMAS = Arrays.asList(
            "web/assests/configs/xsd/sim.xsd",
            "web/assests/configs/xsd/tag.xsd",
            "web/assests/configs/xsd/network-operator.xsd",
            "web/assests/configs/xsd/network-operators.xsd"
    );
}
