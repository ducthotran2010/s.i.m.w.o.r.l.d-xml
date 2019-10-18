package thotd.constants;

import java.util.Arrays;
import java.util.List;

public class PathConstant {
    public static final String PACKED_GENERATED_NAME = "thotd.generated";

    /**
     * Path config for sim crawl
     *
     * Work fine with:
     *  - Sodepami
     *  - Simsodep
     *
     * Got 403 with:
     *  - Tongkhosim
     */
    public static final String CONFIG_XML = "assests/configs/xml/network-operators.xml";
    public static final String CONFIG_XSL_SODEPAMI = "assests/configs/xsl/sodepami.xsl";
    public static final String CONFIG_XSL_SIMSODEP = "assests/configs/xsl/simsodep.xsl";
    /* public static final String CONFIG_XSL_TONGKHOSIM = "assests/configs/xsl/tongkhosim.xsl"; */

    public static final List<String> CONFIG_XSL = Arrays.asList(
            CONFIG_XSL_SODEPAMI,
            CONFIG_XSL_SIMSODEP
            /* CONFIG_XSL_TONGKHOSIM */
    );

    public static final List<String> CONFIG_HREF = Arrays.asList(
            "sodepami_href",
            "simsodep_href"
            /* "tongkhosim_href" */
    );

    public static final List<String> CONFIG_SCHEMAS = Arrays.asList(
            "web/assests/configs/xsd/sim.xsd",
            "web/assests/configs/xsd/tag.xsd",
            "web/assests/configs/xsd/network-operator.xsd",
            "web/assests/configs/xsd/network-operators.xsd"
    );



    /**
     * Path config for order crawl
     *
     * Work fine with:
     *  - Simsovietnam
     *  - Khosim
     *
     *  Got 403 with:
     *  - Giaosimnhanh
     *  - Simthanglong
     */
    public static final String CONFIG_ORDERS_XML= "assests/configs/xml/orders.xml";
    public static final String CONFIG_ORDERS_XSL_SIMSOVIETNAM = "assests/configs/xsl/orders/simsovietnam.xsl";
    public static final String CONFIG_ORDERS_XSL_KHOSIM = "assests/configs/xsl/orders/khosim.xsl";
    /* public static final String CONFIG_ORDERS_XSL_GIAOSIMNHANH = "assests/configs/xsl/orders/giaosimnhanh.xsl"; */
    /* public static final String CONFIG_ORDERS_XSL_SIMTHANGLONG = "assests/configs/xsl/orders/simthanglong.xsl"; */

    public static final List<String> CONFIG_ORDERS_XSL = Arrays.asList(
            CONFIG_ORDERS_XSL_SIMSOVIETNAM,
            CONFIG_ORDERS_XSL_KHOSIM
            /* CONFIG_ORDERS_XSL_SIMTHANGLONG */
            /* CONFIG_ORDERS_XSL_GIAOSIMNHANH */
    );

    public static final List<String> CONFIG_ORDERS_SCHEMAS = Arrays.asList(
            "web/assests/configs/xsd/orders/order.xsd",
            "web/assests/configs/xsd/orders/orders.xsd"
    );

    /**
     * Path config for PhongThuy crawl
     */
    public static final String CONFIG_PHONGTHUY_XML = "assests/configs/xml/phongthuy.xml";
    public static final String CONFIG_PHONGTHUY_XSL = "assests/configs/xsl/phongthuy/chosim24h.xsl";


    public static final List<String> CONFIG_PHONGTHUY_SCHEMAS = Arrays.asList(
            "web/assests/configs/xsd/phongthuy/section.xsd",
            "web/assests/configs/xsd/phongthuy/phongthuy.xsd"
    );
}
