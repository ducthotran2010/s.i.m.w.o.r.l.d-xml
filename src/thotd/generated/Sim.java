
package thotd.generated;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for anonymous complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType>
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="PhoneNumber" type="{http://ducthotran2010.github.io/xsd/sim}PhoneNumberType"/>
 *         &lt;element name="Price" type="{http://www.w3.org/2001/XMLSchema}unsignedInt"/>
 *         &lt;element name="Supplier" type="{http://ducthotran2010.github.io/xsd/sim}SupplierType"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "phoneNumber",
    "price",
    "supplier"
})
@XmlRootElement(name = "Sim", namespace = "http://ducthotran2010.github.io/xsd/sim")
public class Sim {

    @XmlElement(name = "PhoneNumber", namespace = "http://ducthotran2010.github.io/xsd/sim", required = true)
    protected String phoneNumber;
    @XmlElement(name = "Price", namespace = "http://ducthotran2010.github.io/xsd/sim")
    @XmlSchemaType(name = "unsignedInt")
    protected long price;
    @XmlElement(name = "Supplier", namespace = "http://ducthotran2010.github.io/xsd/sim", required = true)
    @XmlSchemaType(name = "string")
    protected SupplierType supplier;

    /**
     * Gets the value of the phoneNumber property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPhoneNumber() {
        return phoneNumber;
    }

    /**
     * Sets the value of the phoneNumber property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPhoneNumber(String value) {
        this.phoneNumber = value;
    }

    /**
     * Gets the value of the price property.
     * 
     */
    public long getPrice() {
        return price;
    }

    /**
     * Sets the value of the price property.
     * 
     */
    public void setPrice(long value) {
        this.price = value;
    }

    /**
     * Gets the value of the supplier property.
     * 
     * @return
     *     possible object is
     *     {@link SupplierType }
     *     
     */
    public SupplierType getSupplier() {
        return supplier;
    }

    /**
     * Sets the value of the supplier property.
     * 
     * @param value
     *     allowed object is
     *     {@link SupplierType }
     *     
     */
    public void setSupplier(SupplierType value) {
        this.supplier = value;
    }

}
