
package thotd.generated.phongthuy;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
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
 *         &lt;element name="Number" type="{http://www.w3.org/2001/XMLSchema}int"/>
 *         &lt;element name="Mean" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="Brief" type="{http://www.w3.org/2001/XMLSchema}string"/>
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
    "number",
    "mean",
    "brief"
})
@XmlRootElement(name = "Section", namespace = "http://ducthotran2010.github.io/xsd/section")
public class Section {

    @XmlElement(name = "Number", namespace = "http://ducthotran2010.github.io/xsd/section")
    protected int number;
    @XmlElement(name = "Mean", namespace = "http://ducthotran2010.github.io/xsd/section", required = true)
    protected String mean;
    @XmlElement(name = "Brief", namespace = "http://ducthotran2010.github.io/xsd/section", required = true)
    protected String brief;

    /**
     * Gets the value of the number property.
     * 
     */
    public int getNumber() {
        return number;
    }

    /**
     * Sets the value of the number property.
     * 
     */
    public void setNumber(int value) {
        this.number = value;
    }

    /**
     * Gets the value of the mean property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMean() {
        return mean;
    }

    /**
     * Sets the value of the mean property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMean(String value) {
        this.mean = value;
    }

    /**
     * Gets the value of the brief property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getBrief() {
        return brief;
    }

    /**
     * Sets the value of the brief property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setBrief(String value) {
        this.brief = value;
    }

}
