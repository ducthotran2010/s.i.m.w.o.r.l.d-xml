<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:config="http://ducthotran2010.github.io/xml/config/orders"
                xmlns="http://ducthotran2010.github.io/xsd/orders">
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>

    <xsl:template match="config:Orders">
        <xsl:variable name="document" select="document(@khosim_href)"/>
        <xsl:variable name="orders" select="$document//ul[@class='list-group list-group-flush']//li[@class='list-group-item']"/>
        <xsl:element name="Orders" xmlns="http://ducthotran2010.github.io/xsd/orders">
            <xsl:for-each select="$orders">
                <xsl:call-template name="getOrderNode">
                    <xsl:with-param name="name" select="p[1]"/>
                    <xsl:with-param name="phoneMask" select="current()/p[2]/span"/>
                    <xsl:with-param name="timestamp" select="p[3]"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="getOrderNode">
        <xsl:param name="name"/>
        <xsl:param name="phoneMask"/>
        <xsl:param name="timestamp"/>

        <xsl:element name="Order" xmlns="http://ducthotran2010.github.io/xsd/order">
            <xsl:element name="Name">
                <xsl:value-of select="$name"/>
            </xsl:element>
            <xsl:element name="PhoneMask">
                <xsl:variable name="left">
                    <xsl:value-of select="substring($phoneMask, 1, 6)"/>
                </xsl:variable>
                <xsl:variable name="right">
                    <xsl:value-of select="substring($phoneMask, 8, 10)"/>
                </xsl:variable>
                <xsl:value-of select="translate(concat($left, $right), '.', '_')"/>
            </xsl:element>
            <xsl:element name="Timestamp">
                <xsl:value-of select="substring($timestamp, 9, string-length($timestamp))"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>