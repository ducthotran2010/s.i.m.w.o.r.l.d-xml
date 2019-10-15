<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://ducthotran2010.github.io/xsd/phong-thuy"
                xmlns:config="http://ducthotran2010.github.io/xml/config/phong-thuy"
>
    <xsl:output method="html"/>
    <xsl:template match="config:PhongThuy">
        <xsl:variable name="document" select="document(@href)"/>
        <xsl:variable name="list" select="$document//table[@class='table table-responsive']/tbody/tr"/>

        <xsl:element name="script" xmlns="http://ducthotran2010.github.io/xsd/phong-thuy">
            <xsl:text>const data = [</xsl:text>
            <xsl:call-template name="getBody">
                <xsl:with-param name="list" select="$list"/>
            </xsl:call-template>
            <xsl:text>];</xsl:text>
        </xsl:element>
    </xsl:template>


    <xsl:template name="getBody">
        <xsl:param name="list"/>

        <xsl:for-each select="$list">
            <xsl:if test="not(position()=1)">
                <xsl:text>{</xsl:text>
                <xsl:text>number: `</xsl:text><xsl:value-of select="normalize-space(td[1]/p)"/>
                <xsl:text>`.trim(), mean: `</xsl:text>
                <xsl:value-of select="normalize-space(td[2]/p)"/>
                <xsl:text>`.trim(), brief: `</xsl:text>
                <xsl:value-of select="normalize-space(td[3]/p)"/>
                <xsl:text>`.trim(),</xsl:text>
                <xsl:text>},</xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>