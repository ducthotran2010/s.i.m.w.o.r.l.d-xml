
package thotd.generated;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlEnumValue;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for NetworkOperatorType.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <p>
 * <pre>
 * &lt;simpleType name="NetworkOperatorType">
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
 *     &lt;enumeration value="Viettel"/>
 *     &lt;enumeration value="Vinaphone"/>
 *     &lt;enumeration value="Mobifone"/>
 *     &lt;enumeration value="Vietnamobile"/>
 *     &lt;enumeration value="Gmobile"/>
 *   &lt;/restriction>
 * &lt;/simpleType>
 * </pre>
 * 
 */
@XmlType(name = "NetworkOperatorType", namespace = "http://ducthotran2010.github.io/xsd/sim")
@XmlEnum
public enum NetworkOperatorType {

    @XmlEnumValue("Viettel")
    VIETTEL("Viettel"),
    @XmlEnumValue("Vinaphone")
    VINAPHONE("Vinaphone"),
    @XmlEnumValue("Mobifone")
    MOBIFONE("Mobifone"),
    @XmlEnumValue("Vietnamobile")
    VIETNAMOBILE("Vietnamobile"),
    @XmlEnumValue("Gmobile")
    GMOBILE("Gmobile");
    private final String value;

    NetworkOperatorType(String v) {
        value = v;
    }

    public String value() {
        return value;
    }

    public static NetworkOperatorType fromValue(String v) {
        for (NetworkOperatorType c: NetworkOperatorType.values()) {
            if (c.value.equals(v)) {
                return c;
            }
        }
        throw new IllegalArgumentException(v);
    }

}
