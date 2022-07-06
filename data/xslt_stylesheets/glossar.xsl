<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">---
        title: "Glossar"
        layout: default
        type: liste
        ---
        <h1 class="head" id="top">Glossar</h1>
        <div class="content">
            <div class="toc">
                <ul class="toc_items">
                    <li class="toc_item">
                        <a class="toc_link" href="#drama"><i class="bi bi-chevron-right"></i>Drama</a>
                    </li>
                    <li class="toc_item">
                        <a class="toc_link" href="#edition"><i class="bi bi-chevron-right"></i>Edition</a>
                    </li>
                    <li class="toc_item">
                        <a class="toc_link" href="#lyrik"><i class="bi bi-chevron-right"></i>Lyrik</a>
                    </li>
                    <li class="toc_item">
                        <a class="toc_link" href="#metrik"><i class="bi bi-chevron-right"></i>Metrik</a>
                    </li>
                    <li class="toc_item">
                        <a class="toc_link" href="#prosa"><i class="bi bi-chevron-right"></i>Prosa</a>
                    </li>
                    <li class="toc_item">
                        <a class="toc_link" href="#rhetorik"><i class="bi bi-chevron-right"></i>Rhetorik/Stilistik</a>
                    </li>
                </ul>
            </div>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="div[@class='definition']">
        <li class="gloss_entry">
            <span class="gloss_term">
                <a class="gloss_link">
                    <xsl:attribute name="href">
                        <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                        <xsl:value-of select="@uri"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="@file"/>
                        <xsl:text>' | relative_url }}</xsl:text>
                    </xsl:attribute>
                    <i class="bi bi-chevron-right"></i>
                    <xsl:value-of select="@id"/>
                </a>
            </span>
            <xsl:text>: </xsl:text>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    
    <xsl:template match="div[@class='definitions']">
        <xsl:for-each-group select="./div[@class='definition']" group-by="@uri">
            <div class="gloss_section">
                <xsl:attribute name="id">
                    <xsl:value-of select="@uri"/>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="./@uri='prosa'">
                        <h3>Prosa</h3>
                    </xsl:when>
                    <xsl:when test="./@uri='lyrik'">
                        <h3>Lyrik</h3>
                    </xsl:when>
                    <xsl:when test="./@uri='metrik'">
                        <h3>Metrik</h3>
                    </xsl:when>
                    <xsl:when test="./@uri='drama'">
                        <h3>Drama</h3>
                    </xsl:when>
                    <xsl:when test="./@uri='rhetorik'">
                        <h3>Rhetorik/Stilistik</h3>
                    </xsl:when>
                    <xsl:when test="./@uri='edition'">
                        <h3>Edition</h3>
                    </xsl:when>
                </xsl:choose>
                <ul class="gloss_entries">
                    <xsl:for-each select="current-group()">
                        <xsl:sort select="@id" lang="de"/>
                        <xsl:apply-templates select="."/>
                    </xsl:for-each>
                </ul>
                <div class="return_link">
                    <a class="top_link" href="#top"><i class="bi bi-chevron-double-up"></i><span class="link_text">Zurück zum Seitenanfang</span></a>
                </div>
            </div>
        </xsl:for-each-group>
    </xsl:template>
    
</xsl:stylesheet>