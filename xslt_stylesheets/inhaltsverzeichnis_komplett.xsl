<!-- ANWENDUNG UND ZIEL -->
<!-- Anwenden des Stylesheets auf die menue.xml-Datei (im daten -> xml_sonstige-Ordner) mit der Gesamtstruktur aller Wissensbereiche/Kurse/Lerneinheiten -->
<!-- Generieren der kurse.html-Datei (im _pages -> verzeichnisse-Ordner) mit der Gesamtübersicht über alle Kurs-/Lerneinheiten in sämtlichen Wissensbereichen -->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon" exclude-result-prefixes="saxon">
    <xsl:output method="html" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- VARIABLEN -->
    <!-- Deklarieren von 8 Variablen (-> 1 für jede der maximal 8 Ebenen), jeweils mit dem Wert 1 -> Werden später inkrementell erhöht und dazu genutzt, die Listeneinträge durchzunummerieren -->
    <!-- Durch diese Nummerierung wird sichergestellt, dass alle Einträge eine individuelle ID erhalten und somit als Drop-Down-Element per Link-Klick aufgeklappt werden können -->
    <xsl:variable name="first_level_units" select="1" saxon:assignable="yes"/>
    <xsl:variable name="second_level_units" select="1" saxon:assignable="yes"/>
    <xsl:variable name="third_level_units" select="1" saxon:assignable="yes"/>
    <xsl:variable name="fourth_level_units" select="1" saxon:assignable="yes"/>
    <xsl:variable name="fifth_level_units" select="1" saxon:assignable="yes"/>
    <xsl:variable name="sixth_level_units" select="1" saxon:assignable="yes"/>
    <xsl:variable name="seventh_level_units" select="1" saxon:assignable="yes"/>
    <xsl:variable name="eighth_level_units" select="1" saxon:assignable="yes"/>
    
    <!-- YAML FRONT MATTER -->
    <!-- Festlegen des Seitentitels, der dann im Browser-Tab angezeigt wird -->
    <!-- Festlegen des Seitenlayouts, das in der default.html-Datei (im _layouts-Ordner) vorgegeben wird -->
    <!-- Festlegen des Seitentyps, der für die Zuordnung der benötigten JavaScript-Skripte in der scripts.html-Datei (im _includes-Ordner) genutzt wird -->
    <xsl:template match="/">---
        title: "Kursinhalte"
        layout: default
        type: liste
        ---
        <h1>Kursinhalte</h1>
        <!-- Einfügen eines Buttons, mit dem alle Ebenen gleichzeitig auf-/eingeklappt werden können -->
        <button class="show_collapse_button">Alle Ebenen anzeigen/verbergen</button>
        <div class="drop_down_list">
            <!-- Anwenden der Templates für die Listenelemente -> Einfügen der Liste -->
            <xsl:apply-templates select="lmml"/>
        </div>
    </xsl:template>
    
    <xsl:template match="section">
        
        <!-- EBENE 1 -->
        <!-- Iterieren über die Elemente der 1. Ebene -->
        <xsl:for-each select="./section">
            <!-- Zurücksetzen der Variable für die Einheiten der 2. Ebene auf 1 bei jeder Iteration -> Garantiert korrekte Nummerierung über das gesamte Dokument bzw. alle Unterebenen hinweg -->
            <saxon:assign name="second_level_units">1</saxon:assign>
            <div class="list-group-item level_1">
                <xsl:choose>
                    <!-- Testen, ob der Abschnitt ein weiteres section-Kindelement (= Unterebene, die ausgeklappt werden soll) besitzt -> Falls ja: -->
                    <xsl:when test="./section">
                        <!-- Einfügen und Verlinken eines Chevron-Icons, über das diese Unterebene ausgeklappt werden kann -->
                        <a class="chevron_link" data-bs-toggle="collapse" aria-expanded="false">
                            <xsl:attribute name="aria-controls">
                                <xsl:text>unit</xsl:text>
                                <!-- Nutzen der eingehend deklarierten Variable zur korrekten Durchnummerierung und Verlinkung -->
                                <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                            </xsl:attribute>
                            <xsl:attribute name="href">
                                <xsl:text>#unit</xsl:text>
                                <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                            </xsl:attribute>
                            <i class="bi bi-chevron-down rotate_180"></i>
                        </a>
                    </xsl:when>
                    <!-- Ansonsten (falls keine Unterebene existiert, die ausgeklappt werden soll): -->
                    <xsl:otherwise>
                        <!-- Einfügen eines <span>-Elements, über das per CSS eine Einrückung anstatt des Chevron-Icons im HTML-Dokument vorgenommen wird (-> Siehe svg_icons.scss im _sass-Ordner) -->
                        <span class="no_chevron"/>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- Generieren des Links, der zur jeweiligen Lerneinheit führt -->
                <a class="list_link">
                    <xsl:attribute name="href">
                        <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                        <!-- Zugreifen auf das discipline-Attribut dieses Elements oder des naheliegendsten Vorfahrens mit diesem Attribut (-> Beinhaltet den Namen des Wissensbereichs) -->
                        <xsl:value-of select="ancestor-or-self::section[@discipline]/@discipline"/>
                        <xsl:text>/</xsl:text>
                        <!-- Zugreifen auf das uri-Attribut des aktuellen Elements (-> Beinhaltet den Namen der HTML-Datei) -->
                        <xsl:value-of select="@uri"/>
                        <xsl:text>' | relative_url }}</xsl:text>
                    </xsl:attribute>
                    <!-- Zugreifen auf das titel-Attribut des aktuellen Elements (-> Beinhaltet den Titel der Lerneinheit bzw. des Verzeichniseintrags) -->
                    <xsl:value-of select="@title"/>
                </a>
                
                <!-- EBENE 2 -->
                <!-- Umschließen mit einem <div class="list-group collapse">-Element, dessen Inhalt zunächst verborgen bleibt und per Klick auf das dazugehörige Chevron-Icon in Ebene 1 ausgeklappt werden kann -->
                <div class="list-group collapse level_2">
                    <!-- Nutzen der eingehend deklarierten Variable zur korrekten Durchnummerierung bei der ID -->
                    <xsl:attribute name="id">
                        <xsl:text>unit</xsl:text>
                        <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                    </xsl:attribute>
                    <!-- Iterieren über die Elemente der 2. Ebene -->
                    <xsl:for-each select="./section">
                        <saxon:assign name="third_level_units">1</saxon:assign>
                        <div class="list-group-item level_2">
                            <xsl:choose>
                                <xsl:when test="./section">
                                    <a class="chevron_link" data-bs-toggle="collapse" aria-expanded="false">
                                        <xsl:attribute name="aria-controls">
                                            <xsl:text>unit</xsl:text>
                                            <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                                            <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="href">
                                            <xsl:text>#unit</xsl:text>
                                            <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                                            <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                        </xsl:attribute>
                                        <i class="bi bi-chevron-down rotate_180"></i>
                                    </a>
                                </xsl:when>
                                <xsl:otherwise>
                                    <span class="no_chevron"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <a class="list_link">
                                <xsl:attribute name="href">
                                    <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                    <xsl:value-of select="ancestor-or-self::section[@discipline]/@discipline"/>
                                    <xsl:text>/</xsl:text>
                                    <xsl:value-of select="@uri"/>
                                    <xsl:text>' | relative_url }}</xsl:text>
                                </xsl:attribute>
                                <xsl:value-of select="@title"/>
                            </a>
                            
                            <!-- EBENE 3 -->
                            <div class="list-group collapse level_3">
                                <xsl:attribute name="id">
                                    <xsl:text>unit</xsl:text>
                                    <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                                    <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                </xsl:attribute>
                                <xsl:for-each select="./section">
                                    <saxon:assign name="fourth_level_units">1</saxon:assign>
                                    <div class="list-group-item level_3">
                                        <xsl:choose>
                                            <xsl:when test="./section">
                                                <a class="chevron_link" data-bs-toggle="collapse" aria-expanded="false">
                                                    <xsl:attribute name="aria-controls">
                                                        <xsl:text>unit</xsl:text>
                                                        <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                                                        <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                        <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="href">
                                                        <xsl:text>#unit</xsl:text>
                                                        <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                                                        <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                        <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                    </xsl:attribute>
                                                    <i class="bi bi-chevron-down rotate_180"></i>
                                                </a>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <span class="no_chevron"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <a class="list_link">
                                            <xsl:attribute name="href">
                                                <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                                <xsl:value-of select="ancestor-or-self::section[@discipline]/@discipline"/>
                                                <xsl:text>/</xsl:text>
                                                <xsl:value-of select="@uri"/>
                                                <xsl:text>' | relative_url }}</xsl:text>
                                            </xsl:attribute>
                                            <xsl:value-of select="@title"/>
                                        </a>
                                        
                                        <!-- EBENE 4 -->
                                        <div class="list-group collapse level_4">
                                            <xsl:attribute name="id">
                                                <xsl:text>unit</xsl:text>
                                                <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                                                <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                            </xsl:attribute>
                                            <xsl:for-each select="./section">
                                                <saxon:assign name="fifth_level_units">1</saxon:assign>
                                                <div class="list-group-item level_4">
                                                    <xsl:choose>
                                                        <xsl:when test="./section">
                                                            <a class="chevron_link" data-bs-toggle="collapse" aria-expanded="false">
                                                                <xsl:attribute name="aria-controls">
                                                                    <xsl:text>unit</xsl:text>
                                                                    <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                </xsl:attribute>
                                                                <xsl:attribute name="href">
                                                                    <xsl:text>#unit</xsl:text>
                                                                    <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                </xsl:attribute>
                                                                <i class="bi bi-chevron-down rotate_180"></i>
                                                            </a>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <span class="no_chevron"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                    <a class="list_link">
                                                        <xsl:attribute name="href">
                                                            <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                                            <xsl:value-of select="ancestor-or-self::section[@discipline]/@discipline"/>
                                                            <xsl:text>/</xsl:text>
                                                            <xsl:value-of select="@uri"/>
                                                            <xsl:text>' | relative_url }}</xsl:text>
                                                        </xsl:attribute>
                                                        <xsl:value-of select="@title"/>
                                                    </a>
                                                    
                                                    <!-- EBENE 5 -->
                                                    <div class="list-group collapse level_5">
                                                        <xsl:attribute name="id">
                                                            <xsl:text>unit</xsl:text>
                                                            <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                                                            <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                            <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                            <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                        </xsl:attribute>
                                                        <xsl:for-each select="./section">
                                                            <saxon:assign name="sixth_level_units">1</saxon:assign>
                                                            <div class="list-group-item level_5">
                                                                <xsl:choose>
                                                                    <xsl:when test="./section">
                                                                        <a class="chevron_link" data-bs-toggle="collapse" aria-expanded="false">
                                                                            <xsl:attribute name="aria-controls">
                                                                                <xsl:text>unit</xsl:text>
                                                                                <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                            </xsl:attribute>
                                                                            <xsl:attribute name="href">
                                                                                <xsl:text>#unit</xsl:text>
                                                                                <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                            </xsl:attribute>
                                                                            <i class="bi bi-chevron-down rotate_180"></i>
                                                                        </a>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <span class="no_chevron"/>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                                <a class="list_link">
                                                                    <xsl:attribute name="href">
                                                                        <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                                                        <xsl:value-of select="ancestor-or-self::section[@discipline]/@discipline"/>
                                                                        <xsl:text>/</xsl:text>
                                                                        <xsl:value-of select="@uri"/>
                                                                        <xsl:text>' | relative_url }}</xsl:text>
                                                                    </xsl:attribute>
                                                                    <xsl:value-of select="@title"/>
                                                                </a>
                                                                
                                                                <!-- EBENE 6 -->
                                                                <div class="list-group collapse level_6">
                                                                    <xsl:attribute name="id">
                                                                        <xsl:text>unit</xsl:text>
                                                                        <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                    </xsl:attribute>
                                                                    <xsl:for-each select="./section">
                                                                        <saxon:assign name="seventh_level_units">1</saxon:assign>
                                                                        <div class="list-group-item level_6">
                                                                            <xsl:choose>
                                                                                <xsl:when test="./section">
                                                                                    <a class="chevron_link" data-bs-toggle="collapse" aria-expanded="false">
                                                                                        <xsl:attribute name="aria-controls">
                                                                                            <xsl:text>unit</xsl:text>
                                                                                            <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$sixth_level_units"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:attribute name="href">
                                                                                            <xsl:text>#unit</xsl:text>
                                                                                            <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$sixth_level_units"/>
                                                                                        </xsl:attribute>
                                                                                        <i class="bi bi-chevron-down rotate_180"></i>
                                                                                    </a>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                    <span class="no_chevron"/>
                                                                                </xsl:otherwise>
                                                                            </xsl:choose>
                                                                            <a class="list_link">
                                                                                <xsl:attribute name="href">
                                                                                    <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                                                                    <xsl:value-of select="ancestor-or-self::section[@discipline]/@discipline"/>
                                                                                    <xsl:text>/</xsl:text>
                                                                                    <xsl:value-of select="@uri"/>
                                                                                    <xsl:text>' | relative_url }}</xsl:text>
                                                                                </xsl:attribute>
                                                                                <xsl:value-of select="@title"/>
                                                                            </a>
                                                                            
                                                                            <!-- EBENE 7 -->
                                                                            <div class="list-group collapse level_7">
                                                                                <xsl:attribute name="id">
                                                                                    <xsl:text>unit</xsl:text>
                                                                                    <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$sixth_level_units"/>
                                                                                </xsl:attribute>
                                                                                <xsl:for-each select="./section">
                                                                                    <saxon:assign name="eighth_level_units">1</saxon:assign>
                                                                                    <div class="list-group-item level_7">
                                                                                        <xsl:choose>
                                                                                            <xsl:when test="./section">
                                                                                                <a class="chevron_link" data-bs-toggle="collapse" aria-expanded="false">
                                                                                                    <xsl:attribute name="aria-controls">
                                                                                                        <xsl:text>unit</xsl:text>
                                                                                                        <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$sixth_level_units"/>
                                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$seventh_level_units"/>
                                                                                                    </xsl:attribute>
                                                                                                    <xsl:attribute name="href">
                                                                                                        <xsl:text>#unit</xsl:text>
                                                                                                        <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$sixth_level_units"/>
                                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$seventh_level_units"/>
                                                                                                    </xsl:attribute>
                                                                                                    <i class="bi bi-chevron-down rotate_180"></i>
                                                                                                </a>
                                                                                            </xsl:when>
                                                                                            <xsl:otherwise>
                                                                                                <span class="no_chevron"/>
                                                                                            </xsl:otherwise>
                                                                                        </xsl:choose>
                                                                                        <a class="list_link">
                                                                                            <xsl:attribute name="href">
                                                                                                <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                                                                                <xsl:value-of select="ancestor-or-self::section[@discipline]/@discipline"/>
                                                                                                <xsl:text>/</xsl:text>
                                                                                                <xsl:value-of select="@uri"/>
                                                                                                <xsl:text>' | relative_url }}</xsl:text>
                                                                                            </xsl:attribute>
                                                                                            <xsl:value-of select="@title"/>
                                                                                        </a>
                                                                                        
                                                                                        <!-- EBENE 8 -->
                                                                                        <div class="list-group collapse level_8">
                                                                                            <xsl:attribute name="id">
                                                                                                <xsl:text>unit</xsl:text>
                                                                                                <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$sixth_level_units"/>
                                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$seventh_level_units"/>
                                                                                            </xsl:attribute>
                                                                                            <xsl:for-each select="./section">
                                                                                                <div class="list-group-item level_8">
                                                                                                    <xsl:choose>
                                                                                                        <xsl:when test="./section">
                                                                                                            <a class="chevron_link" data-bs-toggle="collapse" aria-expanded="false">
                                                                                                                <xsl:attribute name="aria-controls">
                                                                                                                    <xsl:text>unit</xsl:text>
                                                                                                                    <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$sixth_level_units"/>
                                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$seventh_level_units"/>
                                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$eighth_level_units"/>
                                                                                                                </xsl:attribute>
                                                                                                                <xsl:attribute name="href">
                                                                                                                    <xsl:text>#unit</xsl:text>
                                                                                                                    <xsl:text>_</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$sixth_level_units"/>
                                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$seventh_level_units"/>
                                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$eighth_level_units"/>
                                                                                                                </xsl:attribute>
                                                                                                                <i class="bi bi-chevron-down rotate_180"></i>
                                                                                                            </a>
                                                                                                        </xsl:when>
                                                                                                        <xsl:otherwise>
                                                                                                            <span class="no_chevron"/>
                                                                                                        </xsl:otherwise>
                                                                                                    </xsl:choose>
                                                                                                    <a class="list_link">
                                                                                                        <xsl:attribute name="href">
                                                                                                            <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                                                                                            <xsl:value-of select="ancestor-or-self::section[@discipline]/@discipline"/>
                                                                                                            <xsl:text>/</xsl:text>
                                                                                                            <xsl:value-of select="@uri"/>
                                                                                                            <xsl:text>' | relative_url }}</xsl:text>
                                                                                                        </xsl:attribute>
                                                                                                        <xsl:value-of select="@title"/>
                                                                                                    </a>
                                                                                                    
                                                                                                    <xsl:apply-templates/>
                                                                                                    
                                                                                                </div>
                                                                                                <saxon:assign name="eighth_level_units"><xsl:value-of select="$eighth_level_units+1"/></saxon:assign>
                                                                                            </xsl:for-each>
                                                                                        </div>
                                                                                        
                                                                                    </div>
                                                                                    <saxon:assign name="seventh_level_units"><xsl:value-of select="$seventh_level_units+1"/></saxon:assign>
                                                                                </xsl:for-each>
                                                                            </div>
                                                                            
                                                                        </div>
                                                                        <saxon:assign name="sixth_level_units"><xsl:value-of select="$sixth_level_units+1"/></saxon:assign>
                                                                    </xsl:for-each>
                                                                </div>
                                                                
                                                            </div>
                                                            <saxon:assign name="fifth_level_units"><xsl:value-of select="$fifth_level_units+1"/></saxon:assign>
                                                        </xsl:for-each>
                                                    </div>
                                                    
                                                </div>
                                                <saxon:assign name="fourth_level_units"><xsl:value-of select="$fourth_level_units+1"/></saxon:assign>
                                            </xsl:for-each>
                                        </div>
                                        
                                    </div>
                                    <saxon:assign name="third_level_units"><xsl:value-of select="$third_level_units+1"/></saxon:assign>
                                </xsl:for-each>
                            </div>
                            
                        </div>
                        <saxon:assign name="second_level_units"><xsl:value-of select="$second_level_units+1"/></saxon:assign>
                    </xsl:for-each>
                </div>
                
            </div>
            <!-- Inkrementelles Erhöhen der Nummerierungsvariable um den Wert 1 für jede Iteration -> Garantiert korrekte Nummerierung über das gesamte Dokument bzw. alle Unterebenen hinweg -->
            <saxon:assign name="first_level_units"><xsl:value-of select="$first_level_units+1"/></saxon:assign>
        </xsl:for-each>
        
    </xsl:template>
</xsl:stylesheet>