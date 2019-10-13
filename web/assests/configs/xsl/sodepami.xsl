<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:config="http://ducthotran2010.github.io/xml/config"
                xmlns="http://ducthotran2010.github.io/xsd/network-operators">
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>

    <xsl:template match="config:NetworkOperators">
        <xsl:variable name="document" select="document(@href)"/>
        <xsl:variable name="table" select="$document//table[@class='tab-sim']"/>

        <!-- local name used as variable to find on this web -->
        <xsl:variable name="viettel" select="'viettel'"/>
        <xsl:variable name="vinaphone" select="'vinaphone'"/>
        <xsl:variable name="mobifone" select="'mobifone'"/>
        <xsl:variable name="vietnamobile" select="'vietnamobile'"/>
        <xsl:variable name="gmobile" select="'gmobile'"/>

        <xsl:variable name="tagNames" select="$table/tr/td[contains(@class, 'res-tab-hide')]/text()"/>

        <xsl:element name="NetworkOperators" xmlns="http://ducthotran2010.github.io/xsd/network-operators">
            <xsl:call-template name="getNetworkOperatorNode">
                <xsl:with-param name="table" select="$table"/>
                <xsl:with-param name="tagNames" select="$tagNames"/>
                <xsl:with-param name="networkOperatorName" select="$viettel"/>
                <xsl:with-param name="networkOperatorDisplayName" select="'Viettel'"/>
            </xsl:call-template>
            <xsl:call-template name="getNetworkOperatorNode">
                <xsl:with-param name="table" select="$table"/>
                <xsl:with-param name="tagNames" select="$tagNames"/>
                <xsl:with-param name="networkOperatorName" select="$vinaphone"/>
                <xsl:with-param name="networkOperatorDisplayName" select="'Vinaphone'"/>
            </xsl:call-template>
            <xsl:call-template name="getNetworkOperatorNode">
                <xsl:with-param name="table" select="$table"/>
                <xsl:with-param name="tagNames" select="$tagNames"/>
                <xsl:with-param name="networkOperatorName" select="$mobifone"/>
                <xsl:with-param name="networkOperatorDisplayName" select="'Mobifone'"/>
            </xsl:call-template>
            <xsl:call-template name="getNetworkOperatorNode">
                <xsl:with-param name="table" select="$table"/>
                <xsl:with-param name="tagNames" select="$tagNames"/>
                <xsl:with-param name="networkOperatorName" select="$vietnamobile"/>
                <xsl:with-param name="networkOperatorDisplayName" select="'Vietnamobile'"/>
            </xsl:call-template>
            <xsl:call-template name="getNetworkOperatorNode">
                <xsl:with-param name="table" select="$table"/>
                <xsl:with-param name="tagNames" select="$tagNames"/>
                <xsl:with-param name="networkOperatorName" select="$gmobile"/>
                <xsl:with-param name="networkOperatorDisplayName" select="'Gmobile'"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>


    <xsl:template name="getNetworkOperatorNode">
        <xsl:param name="networkOperatorName"/>
        <xsl:param name="networkOperatorDisplayName"/>
        <xsl:param name="table"/>
        <xsl:param name="tagNames"/>

        <xsl:element name="NetworkOperator" xmlns="http://ducthotran2010.github.io/xsd/network-operator">
            <xsl:attribute name="name">
                <xsl:value-of select="$networkOperatorDisplayName"/>
            </xsl:attribute>
            <xsl:for-each select="$table//td[contains(@class, 'res-tab-hide')]">
                <xsl:if test="not(preceding::td[contains(@class, 'res-tab-hide') and text() = current()/text()])">
                <xsl:call-template name="getTagNode">
                    <xsl:with-param name="networkOperatorName" select="$networkOperatorName"/>
                    <xsl:with-param name="table" select="$table"/>
                    <xsl:with-param name="tagName" select="."/>
                </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template name="getTagNode">
        <xsl:param name="networkOperatorName"/>
        <xsl:param name="table"/>
        <xsl:param name="tagName"/>
        
        <xsl:element name="Tag" xmlns="http://ducthotran2010.github.io/xsd/tag">
            <xsl:attribute name="name">
                <xsl:value-of select="$tagName"/>
            </xsl:attribute>
            <xsl:call-template name="getSimNode">
                <xsl:with-param name="table" select="$table"/>
                <xsl:with-param name="networkOperatorName" select="$networkOperatorName"/>
                <xsl:with-param name="tagName" select="$tagName"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    
    


    <xsl:template name="getSimNode">
        <xsl:param name="table"/>
        <xsl:param name="networkOperatorName"/>
        <xsl:param name="tagName"/>

        <xsl:for-each select="$table/tr[td[contains(@class, $networkOperatorName)] and td=$tagName]">
            <xsl:variable name="phoneNumber" select="translate(normalize-space(td[@class='simnumb']),'.','')"/>
            <xsl:variable name="price" select="td[contains(., '₫')]"/>
            <xsl:variable name="tag" select="td[contains(@class, 'res-tab-hide')]"/>
            <xsl:element name="Sim" xmlns="http://ducthotran2010.github.io/xsd/sim">
                <xsl:element name="PhoneNumber">
                    <xsl:value-of select="$phoneNumber"/>
                </xsl:element>
                <xsl:element name="Price">
                    <xsl:call-template name="normalize-price">
                        <xsl:with-param name="price" select="$price"/>
                    </xsl:call-template>
                </xsl:element>
                <xsl:element name="Supplier">Sodepami</xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>


    <xsl:template name="normalize-price">
        <xsl:param name="price"/>
        <xsl:variable name="normalizedSpace" select="normalize-space($price)"/>
        <xsl:variable name="replaceCharacter" select="translate($normalizedSpace,' .₫ &#160;', '')"/>

        <xsl:variable name="length" select="string-length($replaceCharacter)"/>
        <xsl:variable name="removeLast3Digit" select="substring($replaceCharacter, 1, $length - 3)"/>

        <xsl:value-of select="$removeLast3Digit"/>
    </xsl:template>
</xsl:stylesheet>