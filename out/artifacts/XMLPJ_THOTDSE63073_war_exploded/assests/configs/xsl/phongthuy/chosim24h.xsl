<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:config="http://ducthotran2010.github.io/xml/config/phong-thuy"
                xmlns="http://ducthotran2010.github.io/xsd/phong-thuy">
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="config:PhongThuy">
        <xsl:variable name="document" select="document(@href)"/>
        <xsl:variable name="list" select="$document//table[@class='table table-responsive']/tbody/tr"/>

        <xsl:element name="PhongThuy" xmlns="http://ducthotran2010.github.io/xsd/phong-thuy">
            <xsl:call-template name="getSection">
                <xsl:with-param name="list" select="$list"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>


    <xsl:template name="getSection">
        <xsl:param name="list"/>

        <xsl:for-each select="$list">
            <xsl:if test="not(position()=1)">
                <xsl:element name="Section" xmlns="http://ducthotran2010.github.io/xsd/section">
                    <xsl:element name="Number">
                        <xsl:value-of select="normalize-space(td[1]/p)"/>
                    </xsl:element>
                    <xsl:element name="Mean">
                        <xsl:value-of select="normalize-space(td[2]/p)"/>
                    </xsl:element>
                    <xsl:element name="Brief">
                        <xsl:value-of select="normalize-space(td[3]/p)"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>