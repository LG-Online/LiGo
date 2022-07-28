<!-- ANWENDUNG UND ZIEL -->
<!-- Anwenden des Stylesheets über die -it:main-Funktion des Saxon-XSLT-Prozessors -> Anwenden/Datenzugriff auf mehrere XML-Dateien über das main-Template (und nicht nur auf eine bestimmte Datei) -->
<!-- Generieren der definitionen.xml-Datei (im daten -> xml_selbstgenerierte-Ordner), in der sämtliche Defintionen aus allen Lerneinheiten gesammelt werden -->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- DATENZUGRIFF -->
    <!-- Zugreifen auf die benötigten Daten/Dateien im main-Template -->
    <xsl:template name="main">
        <div class="definitions">
            <!-- Iterieren über sämtliche .xml-Dateien im xml_wissensbereiche-Ordner mithilfe der collection()-Funktion -->
            <xsl:for-each select="collection('../xml_daten/wissensbereiche/?select=*.xml;recurse=yes')">
                <!-- Anwenden der Templates für sämtliche Defintionen in der jeweiligen Datei -->
                <xsl:apply-templates select=".//definition"/>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    <!-- DEFINITIONEN -->
    <xsl:template match="definition">
        <div class="definition">
            <!-- Ausstatten des Definitions-Elements mit einem id-Attribut -> Gibt den definierten Begriff an -->
            <xsl:attribute name="id">
                <xsl:value-of select="@title"/>
            </xsl:attribute>
            <!-- Ausstatten des Definitions-Elements mit einem label-Attribut -> Gibt die ursprüngliche ID aus der XML-Datei an -->
            <xsl:attribute name="label">
                <xsl:value-of select="@label"/>
            </xsl:attribute>
            <!-- Ausstatten des Definitions-Elements mit einem uri Attribut -> Gibt den Wissensbereich an -->
            <xsl:attribute name="uri">
                <!--Extrahieren des Wissensbereich-Strings aus der URI (= Dateipfad) der XML-Datei mithilfe eines Regex-Ausdrucks -->
                <xsl:analyze-string select="base-uri(.)" regex=".*/(.*)/.*\.xml">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:attribute>
            <!-- Ausstatten des Definitions-Elements mit einem file-Attribut -> Gibt die Lerneinheit/Datei an -->
            <xsl:attribute name="file">
                <!--Extrahieren des Dateinamen-Strings aus der URI (= Dateipfad) der XML-Datei mithilfe eines Regex-Ausdrucks -->
                <xsl:analyze-string select="base-uri(.)" regex=".*/(.*)\.xml">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
                <xsl:text>.html</xsl:text>
            </xsl:attribute>
            <!-- Anwenden der Templates zum Einfügen des Definitionstexts -->
            <xsl:apply-templates/>
        </div>
    </xsl:template>

</xsl:stylesheet>