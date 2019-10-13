
package thotd.generated;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
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
 *         &lt;element ref="{http://ducthotran2010.github.io/xsd/network-operator}NetworkOperator" maxOccurs="unbounded" minOccurs="0"/>
 *       &lt;/sequence>
 *       &lt;attribute name="supplier" type="{http://ducthotran2010.github.io/xsd/network-operators}SupplierType" />
 *       &lt;attribute name="website" type="{http://www.w3.org/2001/XMLSchema}string" />
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "networkOperator"
})
@XmlRootElement(name = "NetworkOperators", namespace = "http://ducthotran2010.github.io/xsd/network-operators")
public class NetworkOperators {

    @XmlElement(name = "NetworkOperator")
    protected List<NetworkOperator> networkOperator;
    @XmlAttribute(name = "supplier")
    protected SupplierType supplier;
    @XmlAttribute(name = "website")
    protected String website;

    /**
     * Gets the value of the networkOperator property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the networkOperator property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getNetworkOperator().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link NetworkOperator }
     * 
     * 
     */
    public List<NetworkOperator> getNetworkOperator() {
        if (networkOperator == null) {
            networkOperator = new ArrayList<NetworkOperator>();
        }
        return this.networkOperator;
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

    /**
     * Gets the value of the website property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getWebsite() {
        return website;
    }

    /**
     * Sets the value of the website property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setWebsite(String value) {
        this.website = value;
    }

}
