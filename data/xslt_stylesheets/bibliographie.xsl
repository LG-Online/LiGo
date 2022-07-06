<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">---
        title: "Bibliographie"
        layout: default
        type: liste
        ---
        <h1 class="head" id="top">Bibliographie</h1>
        <div class="content">
            <div class="toc">
                <ul class="toc_items">
                    <li class="toc_item">
                        <a class="toc_link" href="#drama"><i class="bi bi-chevron-right"></i>Drama</a>
                    </li>
                    <li class="toc_item">
                        <a class="toc_link" href="#fachgeschichte"><i class="bi bi-chevron-right"></i>Fachgeschichte</a>
                    </li>
                    <li class="toc_item">
                        <a class="toc_link" href="#lyrik"><i class="bi bi-chevron-right"></i>Lyrik</a>
                    </li>
                    <li class="toc_item">
                        <a class="toc_link" href="#metrik"><i class="bi bi-chevron-right"></i>Metrik</a>
                    </li>
                    <li class="toc_item">
                        <a class="toc_link" href="#erzaehltextanalyse"><i class="bi bi-chevron-right"></i>Prosa</a>
                    </li>
                    <li class="toc_item">
                        <a class="toc_link" href="#rhetorik"><i class="bi bi-chevron-right"></i>Rhetorik/Stilistik</a>
                    </li>
                </ul>
            </div>        
            <xsl:apply-templates select="//illustration"/>
        </div>
    </xsl:template>
    
    <xsl:template match="bibliography">
        <li class="bib_entry">
            <span class="bib_author">
                <xsl:value-of select="@author"/>
                <xsl:if test="@authorFirstName">
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="@authorFirstName"/>
                </xsl:if>
            </span>
            <xsl:text> (</xsl:text>
            <span class="bib_year">
                <xsl:value-of select="@bookYear"/>
            </span>
            <xsl:text>): </xsl:text>
            <span class="bib_title">
                <xsl:value-of select="@title"/>
            </span>
        </li>
    </xsl:template>
    
    <xsl:template match="illustration">
        <xsl:for-each select="./LMMLtext[not(@uri='literaturtheorie' or @uri='edition')]">
            <xsl:sort select="@title"/>
            <div class="bib_section">
                <xsl:attribute name="id">
                    <xsl:value-of select="@uri"/>
                </xsl:attribute>
                <h3><xsl:value-of select="."/></h3>
                <ul class="bib_entries">
                    <xsl:choose>
                        <xsl:when test="./@uri='erzaehltextanalyse'">
                            <xsl:apply-templates select="../../bibliography[matches(@topics, 'Erzaehltextanalyse')]">
                                <xsl:sort select="@author" data-type="text"/>
                                <xsl:sort select="@bookYear" data-type="number"/>
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:when test="./@uri='lyrik'">
                            <xsl:apply-templates select="../../bibliography[matches(@topics, 'Lyrik')]">
                                <xsl:sort select="@author" data-type="text"/>
                                <xsl:sort select="@bookYear" data-type="number"/>
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:when test="./@uri='metrik'">
                            <xsl:apply-templates select="../../bibliography[matches(@topics, 'Metrik')]">
                                <xsl:sort select="@author" data-type="text"/>
                                <xsl:sort select="@bookYear" data-type="number"/>
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:when test="./@uri='drama'">
                            <xsl:apply-templates select="../../bibliography[matches(@topics, 'Drama')]">
                                <xsl:sort select="@author" data-type="text"/>
                                <xsl:sort select="@bookYear" data-type="number"/>
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:when test="./@uri='rhetorik'">
                            <xsl:apply-templates select="../../bibliography[matches(@topics, 'Rhetorik')]">
                                <xsl:sort select="@author" data-type="text"/>
                                <xsl:sort select="@bookYear" data-type="number"/>
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:when test="./@uri='fachgeschichte'">
                            <xsl:apply-templates select="../../bibliography[matches(@topics, 'FachgeschichteGermanistik')]">
                                <xsl:sort select="@author" data-type="text"/>
                                <xsl:sort select="@bookYear" data-type="number"/>
                            </xsl:apply-templates>
                        </xsl:when>
                    </xsl:choose>
                </ul>
                <div class="return_link">
                    <a class="top_link" href="#top"><i class="bi bi-chevron-double-up"></i><span class="link_text">Zurück zum Seitenanfang</span></a>
                </div>
            </div>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>