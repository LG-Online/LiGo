<!-- ANWENDUNG UND ZIEL -->
<!-- Anwenden des Stylesheets auf die definitionen.xml-Datei (im xml_daten -> selbstgenerierte-Ordner), in der sämtliche Defintionen aus allen Lerneinheiten gesammelt wurden -->
<!-- Generieren der glossar.html-Datei (im _pages -> verzeichnisse-Ordner) mit dem LiGo-Glossar -->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- YAML FRONT MATTER -->
    <!-- Festlegen des Seitentitels, der dann im Browser-Tab angezeigt wird -->
    <!-- Festlegen des Seitenlayouts, das in der default.html-Datei (im _layouts-Ordner) vorgegeben wird -->
    <!-- Festlegen des Seitentyps, der für die Zuordnung der benötigten JavaScript-Skripte in der scripts.html-Datei (im _includes-Ordner) genutzt wird -->
    <xsl:template match="/">---
        title: "Glossar"
        layout: default
        type: liste
        ---
        <!-- GESAMTE SEITE -->
        <!-- Austatten der Überschrift mit einer ID, damit sie als Link-Anker dienen kann -> Ermöglicht den Sprung per Link zurück zur Überschrift/zum Seitenanfang -->
        <h1 class="head" id="top">Glossar</h1>
        <!-- Generieren des Inhaltsverzeichnisses mit Einträgen und Links zu den jeweiligen Abschnitten -->
        <ul class="toc">
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
        <!-- Anwenden der Templates für den restlichen Seiteninhalt bzw. die Glossar-Einträge -->
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- AUFTEILUNG ABSCHNITTE/WISSENSBEREICHE -->
    <xsl:template match="div[@class='definitions']">
        <!-- Gruppieren der Definitionen nach ihrem uri-Attribut (-> Enthält den Wissensbereich, aus dem die jeweilige Definition stammt) -->
        <xsl:for-each-group select="./div[@class='definition']" group-by="@uri">
            <!-- Umschließen jedes Abschnitts mit einem <div>-Blockelement -->
            <div class="gloss_section">
                <xsl:attribute name="id">
                    <xsl:value-of select="@uri"/>
                </xsl:attribute>
                <!-- Testen, um welchen Wissensbereich es sich handelt, und Einfügen der entsprechenden Überschrift -->
                <xsl:choose>
                    <xsl:when test="@uri='prosa'">
                        <h3>Prosa</h3>
                    </xsl:when>
                    <xsl:when test="@uri='lyrik'">
                        <h3>Lyrik</h3>
                    </xsl:when>
                    <xsl:when test="@uri='metrik'">
                        <h3>Metrik</h3>
                    </xsl:when>
                    <xsl:when test="@uri='drama'">
                        <h3>Drama</h3>
                    </xsl:when>
                    <xsl:when test="@uri='rhetorik'">
                        <h3>Rhetorik/Stilistik</h3>
                    </xsl:when>
                    <xsl:when test="@uri='edition'">
                        <h3>Edition</h3>
                    </xsl:when>
                </xsl:choose>
                <!-- Einfügen der Definitionen/Glossareinträge in Form einer Liste -->
                <ul class="gloss_entries">
                    <xsl:for-each select="current-group()">
                        <!-- Alphabetisches Sortieren der Einträge -->
                        <xsl:sort select="@id" lang="de"/>
                        <xsl:apply-templates select="."/>
                    </xsl:for-each>
                </ul>
                <!-- Einfügen eines Links am Ende jedes Abschnitts, der zurück zur Hauptüberschrift bzw. zum Seitenanfang führt -->
                <div class="return_link">
                    <a class="top_link" href="#top"><i class="bi bi-chevron-double-up"></i><span class="link_text">Zurück zum Seitenanfang</span></a>
                </div>
            </div>
        </xsl:for-each-group>
    </xsl:template>
    
    <!-- EINZELNE EINTRÄGE/DEFINITIONEN -->
    <xsl:template match="div[@class='definition']">
        <!-- Einfügen des Glossareintrags als Listenelement -->
        <li class="gloss_entry">
            <!-- Einfügen des definierten Begriffs (-> Wird blau/fett dargestellt) -->
            <span class="gloss_term">
                <!-- Verlinken des definierten Begriffs mit der Lerneinheit-Webseite, auf der diese Definition zu finden ist -->
                <a class="gloss_link">
                    <xsl:attribute name="href">
                        <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                        <!-- Nutzen des uri-Attributs (= Wissensbereich) und des file-Attributs (= Lerneinheit/Datei) zur Generierung des korrekten Dateipfads für den Link -->
                        <xsl:value-of select="@uri"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="@file"/>
                        <xsl:text>' | relative_url }}</xsl:text>
                    </xsl:attribute>
                    <i class="bi bi-chevron-right"></i>
                    <!-- Einfügen des definierten Begriffs aus dem ID-Attribut -->
                    <xsl:value-of select="@id"/>
                </a>
            </span>
            <xsl:text>: </xsl:text>
            <!-- Anwenden der Templates bzw. Einfügen des Definitionstexts -->
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    
</xsl:stylesheet>