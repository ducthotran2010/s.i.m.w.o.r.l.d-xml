<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:config="http://ducthotran2010.github.io/xml/config/orders"
                xmlns="http://ducthotran2010.github.io/xsd/orders">
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>

    <xsl:template match="config:Orders">
        <xsl:variable name="document" select="document(@simsovietnam_href)"/>
        <xsl:variable name="orders" select="$document//div[@class='newdh']"/>
        <xsl:element name="Orders" xmlns="http://ducthotran2010.github.io/xsd/orders">
            <xsl:for-each select="$orders">
                <xsl:call-template name="getOrderNode">
                    <xsl:with-param name="name" select="p/strong[@style='color: red;']"/>
                    <xsl:with-param name="phoneMask" select="current()//strong[@style='color: black;']"/>
                    <xsl:with-param name="timestamp" select="p[@class='list-group-item-text font-11']"/>
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
                <xsl:call-template name="removePrefixAndGetRidOfDot">
                <xsl:with-param name="string">
                    <xsl:value-of select="$phoneMask"/>
                </xsl:with-param>
                <xsl:with-param name="number">8</xsl:with-param>
            </xsl:call-template>
            </xsl:element>
            <xsl:element name="Timestamp">
                <xsl:call-template name="removePrefixAndGetRidOfDot">
                    <xsl:with-param name="string">
                        <xsl:value-of select="$timestamp"/>
                    </xsl:with-param>
                    <xsl:with-param name="number">15</xsl:with-param>
                </xsl:call-template>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template name="removePrefixAndGetRidOfDot">
        <xsl:param name="string"/>
        <xsl:param name="number"/>

        <xsl:variable name="length" select="string-length($string)"/>
        <xsl:variable name="removedPrefix" select="substring($string, $number, $length)"/>
        <xsl:variable name="removeUnusedCharacter" select="translate($removedPrefix, '. ', '')"/>
        <xsl:variable name="result" select="translate($removeUnusedCharacter, 'x', '_')"/>

        <xsl:value-of select="$result"/>
    </xsl:template>
</xsl:stylesheet>