<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://ducthotran2010.github.io/xsd/look-up">
    <xsl:output method="html" indent="yes"/>
    <xsl:template match="/">

        <div class="wrapper-body--head">
            <p>Chủ nhân số điện thoại có thể là:</p>
        </div>

        <table class="home_table">
            <thead><tr class="home_tr home_tr--head"><th>STT</th><th>Tên</th><th>Sim số đẹp</th><th>Thời gian</th></tr></thead>
            <tbody>
                <xsl:call-template name="getTableBody"/>
            </tbody>
        </table>
    </xsl:template>

    <xsl:template name="getTableBody">
        <xsl:for-each select="//Order">
        <tr class="home_tr home_tr--body">
                <td><a><xsl:number count="Order"/></a></td>
                <td><a><xsl:value-of select="Name"/></a></td>
                <td><a><xsl:value-of select="PhoneMask"/></a></td>
                <td><a><xsl:value-of select="Timestamp"/></a></td>
            </tr>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>