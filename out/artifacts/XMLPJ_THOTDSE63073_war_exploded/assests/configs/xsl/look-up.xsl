<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://ducthotran2010.github.io/xsd/look-up">
    <xsl:output method="html" indent="yes"/>
    <xsl:template match="/">
        <table>
            <thead><tr><th>STT</th><th>Tên</th><th>Sim số đẹp</th><th>Thời gian</th></tr></thead>
            <tbody>
                <xsl:call-template name="getTableBody"/>
            </tbody>
        </table>
    </xsl:template>

    <xsl:template name="getTableBody">
        <xsl:for-each select="//Order">
        <tr>
                <td><xsl:number count="Order"/></td>
                <td><xsl:value-of select="Name"/></td>
                <td><xsl:value-of select="PhoneMask"/></td>
                <td><xsl:value-of select="Timestamp"/></td>
            </tr>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>