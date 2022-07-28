<!-- ANWENDUNG UND ZIEL -->
<!-- Anwenden des Stylesheets auf die bibliographie.xml-Datei (im daten -> xml_sonstige-Ordner) mit der LiGo-Bibliographie -->
<!-- Generieren der bibliographie.html-Datei (im _pages -> verzeichnisse-Ordner) mit der LiGo-Bibliographie -->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- YAML FRONT MATTER -->
    <!-- Festlegen des Seitentitels, der dann im Browser-Tab angezeigt wird -->
    <!-- Festlegen des Seitenlayouts, das in der default.html-Datei (im _layouts-Ordner) vorgegeben wird -->
    <!-- Festlegen des Seitentyps, der für die Zuordnung der benötigten JavaScript-Skripte in der scripts.html-Datei (im _includes-Ordner) genutzt wird -->
    <xsl:template match="/">---
        title: "Bibliographie"
        layout: default
        type: liste
        ---
        <!-- GESAMTE SEITE -->
        <!-- Austatten der Überschrift mit einer ID, damit sie als Link-Anker dienen kann -> Ermöglicht den Sprung per Link zurück zur Überschrift/zum Seitenanfang -->
        <h1 class="head" id="top">Bibliographie</h1>
        <!-- Generieren des Inhaltsverzeichnisses mit Einträgen und Links zu den jeweiligen Abschnitten -->
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
        <!-- Anwenden der Templates für die einzelnen Bibliographie-Abschnitte (-> Aufteilung nach Wissensbereichen) -->
        <xsl:apply-templates select="//illustration"/>
    </xsl:template>
    
    <!-- AUFTEILUNG ABSCHNITTE/WISSENSBEREICHE -->
    <xsl:template match="illustration">
        <!--  -->
        <xsl:for-each select="./LMMLtext[not(@uri='literaturtheorie' or @uri='edition')]">
            <xsl:sort select="@title"/>
            <div class="bib_section">
                <xsl:attribute name="id">
                    <xsl:value-of select="@uri"/>
                </xsl:attribute>
                <h3><xsl:value-of select="."/></h3>
                <ul class="bib_entries">
                    <!-- Testen, um welchen Wissensbereich es sich handelt, und Anwenden der Templates für die entsprechenden Elemente -->
                    <!-- Alphabetisches Sortieren der Elemente/Einträge nach Autorname und anschließend nach Veröffentlichungsjahr des Werks -->
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
                <!-- Einfügen eines Links am Ende jedes Abschnitts, der zurück zur Hauptüberschrift bzw. zum Seitenanfang führt -->
                <div class="return_link">
                    <a class="top_link" href="#top"><i class="bi bi-chevron-double-up"></i><span class="link_text">Zurück zum Seitenanfang</span></a>
                </div>
            </div>
        </xsl:for-each>
    </xsl:template>
    
    <!-- EINZELNE EINTRÄGE/BIB-ANGABEN -->
    <xsl:template match="bibliography">
        <!-- Einfügen des Bibliographie-Eintrags als Listenelement -->
        <li class="bib_entry">
            <!-- Einfügen des Autors (-> Wird dann fett dargestellt) -->
            <span class="bib_author">
                <xsl:value-of select="@author"/>
                <!-- Testen, ob der Vorname des Autors im XML-Dokument angegeben ist -> Falls ja: Einfügen eines Kommas und des Vornamens -->
                <xsl:if test="@authorFirstName">
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="@authorFirstName"/>
                </xsl:if>
            </span>
            <!-- Einfügen des Erscheinungsjahrs in Klammern und des Titels -->
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
    
</xsl:stylesheet>