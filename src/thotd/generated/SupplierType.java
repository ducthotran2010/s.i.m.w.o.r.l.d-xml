
package thotd.generated;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlEnumValue;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for SupplierType.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <p>
 * <pre>
 * &lt;simpleType name="SupplierType">
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
 *     &lt;enumeration value="Sodepami"/>
 *   &lt;/restriction>
 * &lt;/simpleType>
 * </pre>
 * 
 */
@XmlType(name = "SupplierType", namespace = "http://ducthotran2010.github.io/xsd/sim")
@XmlEnum
public enum SupplierType {

    @XmlEnumValue("Sodepami")
    SODEPAMI("Sodepami");
    private final String value;

    SupplierType(String v) {
        value = v;
    }

    public String value() {
        return value;
    }

    public static SupplierType fromValue(String v) {
        for (SupplierType c: SupplierType.values()) {
            if (c.value.equals(v)) {
                return c;
            }
        }
        throw new IllegalArgumentException(v);
    }

}
