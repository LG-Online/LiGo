<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template name="main">
        <div class="definitions">
            <xsl:for-each select="collection('../xml_wissensbereiche/?select=*.xml;recurse=yes')">
                <xsl:apply-templates select=".//definition"/>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    <xsl:template match="definition">
        <div class="definition">
            <xsl:attribute name="id">
                <xsl:value-of select="@title"/>
            </xsl:attribute>
            <xsl:attribute name="label">
                <xsl:value-of select="@label"/>
            </xsl:attribute>
            <xsl:attribute name="uri">
                <xsl:analyze-string select="base-uri(.)" regex=".*/(.*)/.*\.xml">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:attribute>
            <xsl:attribute name="file">
                <xsl:analyze-string select="base-uri(.)" regex=".*/(.*)\.xml">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
                <xsl:text>.html</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

</xsl:stylesheet>