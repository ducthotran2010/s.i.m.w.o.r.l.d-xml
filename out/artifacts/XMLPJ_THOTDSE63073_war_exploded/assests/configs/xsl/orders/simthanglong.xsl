<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:config="http://ducthotran2010.github.io/xml/config/orders"
                xmlns="http://ducthotran2010.github.io/xsd/orders">
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>

    <xsl:template match="config:Orders">
        <xsl:variable name="document" select="document(@simthanglong_href)"/>
        <xsl:variable name="orders" select="$document//li[@style=' border-bottom: 1px solid #ccc; padding-bottom: 5px; ']"/>
        <xsl:element name="Orders" xmlns="http://ducthotran2010.github.io/xsd/orders">
            <xsl:for-each select="$orders">
                <xsl:call-template name="getOrderNode">
                    <xsl:with-param name="name" select="h3[1]"/>
                    <xsl:with-param name="phoneMask" select="label[1]"/>
                    <xsl:with-param name="timestamp" select="span[1]"/>
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
                <xsl:value-of select="$phoneMask"/>
            </xsl:element>
            <xsl:element name="Timestamp">
                <xsl:value-of select="$timestamp"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>