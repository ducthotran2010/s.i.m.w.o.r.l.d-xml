<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:config="http://ducthotran2010.github.io/xml/config"
                xmlns="http://ducthotran2010.github.io/xsd/network-operators">
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>

    <xsl:template match="config:NetworkOperators">
        <xsl:variable name="document" select="document(@tongkhosim_href)"/>
        <xsl:variable name="list" select="$document//table[@class='table table-bordered table-striped']/tbody/tr"/>

        <!-- local name used as variable to find on this web -->
<!--        <xsl:variable name="viettel" select="Tongkhosim/Viettel"/>-->
<!--        <xsl:variable name="vinaphone" select="Tongkhosim/Vinaphone"/>-->
<!--        <xsl:variable name="mobifone" select="Tongkhosim/Mobifone"/>-->
<!--        <xsl:variable name="vietnamobile" select="Tongkhosim/Vietnamobile"/>-->
<!--        <xsl:variable name="gmobile" select="Tongkhosim/Gmobile"/>-->



        <xsl:element name="NetworkOperators" xmlns="http://ducthotran2010.github.io/xsd/network-operators">
            <xsl:attribute name="supplier">
                <xsl:value-of select="@tongkhosim_name"/>
            </xsl:attribute>
            <xsl:attribute name="website">
                <xsl:value-of select="@tongkhosim_domain"/>
            </xsl:attribute>
            <xsl:for-each select="Tongkhosim/*">
                <xsl:call-template name="getNetworkOperatorNode">
                    <xsl:with-param name="list" select="$list"/>
                    <xsl:with-param name="networkOperatorName" select="name()"/>
                    <xsl:with-param name="networkOperatorDisplayName" select="text()"/>
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

            <xsl:element name="Tag">
                <xsl:for-each select="$list[//span=$networkOperatorName]">
                    <xsl:call-template name="getSimNode">
                        <xsl:with-param name="phoneNumber" select="current()//strong"/>
                        <xsl:with-param name="price" select="td[contains(@class, 'sim-price')]"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template name="getSimNode">
        <xsl:param name="phoneNumber"/>
        <xsl:param name="price"/>

        <xsl:element name="Sim">
            <xsl:element name="PhoneNumber">
                <xsl:value-of select="$phoneNumber"/>
            </xsl:element>
            <xsl:element name="Price">
                <xsl:value-of select="$price"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>