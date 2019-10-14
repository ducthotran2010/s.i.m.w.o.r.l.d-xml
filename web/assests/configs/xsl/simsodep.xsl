<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:config="http://ducthotran2010.github.io/xml/config"
                xmlns="http://ducthotran2010.github.io/xsd/network-operators">
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>

    <xsl:template match="config:NetworkOperators">
        <xsl:variable name="document" select="document(@simsodep_href)"/>
        <xsl:variable name="list" select="$document//table[@class='table table-bordered table-condensed']/tbody/tr"/>
        <xsl:element name="NetworkOperators" xmlns="http://ducthotran2010.github.io/xsd/network-operators">
            <xsl:attribute name="supplier">
                <xsl:value-of select="@simsodep_name"/>
            </xsl:attribute>
            <xsl:attribute name="website">
                <xsl:value-of select="@simsodep_domain"/>
            </xsl:attribute>

            <xsl:for-each select="current()/config:Simsodep/*">
                <xsl:call-template name="getNetworkOperatorNode">
                    <xsl:with-param name="list" select="$list"/>
                    <xsl:with-param name="networkOperatorName" select="text()"/>
                    <xsl:with-param name="networkOperatorDisplayName" select="name()"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>


    <xsl:template name="getNetworkOperatorNode">
        <xsl:param name="list"/>
        <xsl:param name="networkOperatorName"/>
        <xsl:param name="networkOperatorDisplayName"/>

        <xsl:element name="NetworkOperator" xmlns="http://ducthotran2010.github.io/xsd/network-operator">
            <xsl:attribute name="name">
                <xsl:value-of select="$networkOperatorDisplayName"/>
            </xsl:attribute>

            <xsl:element name="Tag" xmlns="http://ducthotran2010.github.io/xsd/tag">
                <xsl:for-each select="$list">
                    <xsl:if test="current()//span/@class=$networkOperatorName">
                        <xsl:call-template name="getSimNode">
                            <xsl:with-param name="phoneNumber" select="td[2]"/>
                            <xsl:with-param name="price" select="td[3]"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template name="getSimNode">
        <xsl:param name="phoneNumber"/>
        <xsl:param name="price"/>

        <xsl:element name="Sim" xmlns="http://ducthotran2010.github.io/xsd/sim">
            <xsl:element name="PhoneNumber">
                <xsl:value-of select="translate($phoneNumber, '.', '')"/>
            </xsl:element>
            <xsl:element name="Price">
                <xsl:variable name="removeUnusedChar" select="translate($price, ',', '')"/>
                <xsl:variable name="length" select="string-length($removeUnusedChar)"/>
                <xsl:value-of select="substring($removeUnusedChar, 1, $length - 3)"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>