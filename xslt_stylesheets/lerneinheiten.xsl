<!-- ANWENDUNG UND ZIEL -->
<!-- Anwenden des Stylesheets auf die [lerneinheit].xml-Dateien (in den xml_daten -> wissensbereiche-Unterordnern) mit den einzelnen Kurs-/Lerneinheiten -->
<!-- Generieren der [lerneinheit].html-Dateien (in den _pages -> wissensbereiche-Unterordnern) mit den einzelnen Kurs-/Lerneinheiten -->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- VARIABLE UND KEY -->
    <!-- Speichern des aktuellen Dokument-Pfads in der path-Variable -> Wird später zur Zuordnung des korrekten Wissensbereichs beim Generieren der Navigationslinks und der internen Links verwendet -->
    <xsl:variable name="path" select="document-uri(/)"/>    
    <!-- Speichern der menue.xml-Datei, in der die gesamte Struktur aller Wissensbereiche und Kurse gespeichert ist, in der menue-Variable -> Wird später zum Generien der Navigationslinks verwendet -->
    <xsl:variable name="menue" select="document('../xml_daten/sonstige/menue.xml')"/>
    <!-- Generieren eines Keys für die Beispiele/Übungen -> Wird später verwendet, um diese Elemente an der korrekten Stelle in den HTML-Dokumenten einzufügen
         (-> In den XML-Dokumenten befinden sich die Beispiele/Übungen immer ganz am Ende, aber in den HTML-Dokumenten sollen sie direkt an der für sie vorgesehenen Stelle zwischen den Textabschnitten eingefügt werden) -->
    <xsl:key name="examples_exercises" match="section[@type='example']|exercise" use="@label"/>
    
    <!-- YAML FRONT MATTER -->
    <!-- Festlegen des Seitentitels, der dann im Browser-Tab angezeigt wird -->
    <!-- Festlegen des Seitenlayouts, das in der default.html-Datei (im _layouts-Ordner) vorgegeben wird -->
    <!-- Festlegen des Seitentyps, der für die Zuordnung der benötigten JavaScript-Skripte in der scripts.html-Datei (im _includes-Ordner) genutzt wird -->
    <xsl:template _match="/">---
        title: "<xsl:value-of select=".//section[@type='course']/@title"/>"
        layout: default
        type: lerneinheit
        ---
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="section[@type='course']">
        <!-- Speichern des Lerneinheit-Labels in der label-Variable -> Wird später zum Finden der aktuellen Lerneinheit in der menue.xml-Datei verwendet -->
        <xsl:variable name="label" select="@label"/>
        
        <!-- BROTKRUMEN-NAVIGATION -->
        <div class="breadcrumb_nav">
            <a class="breadcrumb_link">
                <xsl:attribute name="href">
                    <xsl:text>{{ '_pages/verzeichnisse/</xsl:text>
                    <!-- Nutzen der path-Variable und der contains()-Funktion, um festzustellen, zu welchem Wissensbereich das aktuelle Dokument gehört und um den Link zur jeweiligen Kursübersicht zu generieren -->
                    <xsl:choose>
                        <xsl:when test="contains($path, 'drama')">
                            <xsl:text>inhalt_drama.html' | relative_url }}</xsl:text>
                        </xsl:when>
                        <xsl:when test="contains($path, 'edition')">
                            <xsl:text>inhalt_edition.html' | relative_url }}</xsl:text>
                        </xsl:when>
                        <xsl:when test="contains($path, 'fachgeschichtegerm')">
                            <xsl:text>inhalt_fachgeschichtegerm.html' | relative_url }}</xsl:text>
                        </xsl:when>
                        <xsl:when test="contains($path, 'lyrik')">
                            <xsl:text>inhalt_lyrik.html' | relative_url }}</xsl:text>
                        </xsl:when>
                        <xsl:when test="contains($path, 'metrik')">
                            <xsl:text>inhalt_metrik.html' | relative_url }}</xsl:text>
                        </xsl:when>
                        <xsl:when test="contains($path, 'prosa')">
                            <xsl:text>inhalt_prosa.html' | relative_url }}</xsl:text>
                        </xsl:when>
                        <xsl:when test="contains($path, 'rhetorik')">
                            <xsl:text>inhalt_rhetorik.html' | relative_url }}</xsl:text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                Kursübersicht
            </a>
            <!-- Einfügen eines Caret-Symbols zwischen den Links -->
            <i class="bi bi-caret-right"></i>
            <!-- Zugreifen auf die menue.xml-Datei über die menue-Variable  -->
            <!-- Iterieren über die Kurselemente-Vorfahren der aktuellen Lerneinheit, die über den Abgleich ihres Labels in der menue.xml-Datei gefunden wird -->
            <xsl:for-each select="$menue//section[@label = $label]/ancestor::section[@type='course']">
                <a class="breadcrumb_link">
                    <!-- Generieren eines Links für jedes übergeordnete Kurselement -->
                    <xsl:attribute name="href">
                        <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                        <xsl:value-of select="./ancestor-or-self::section[@discipline]/@discipline"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="@uri"/>
                        <xsl:text>' | relative_url }}</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of select="@title"/>
                </a>
                <i class="bi bi-caret-right"></i>
            </xsl:for-each>
            <xsl:value-of select="@title"/>
        </div>
        <!-- Einfügen einer Trennlinie zwischen Navigation und Kerninhalt der Lerneinheit -->
        <hr class="separation_line"/>
        
        <!-- KERNINHALT -->
        <!-- Überschrift der Lerneinheit -->
        <h1><xsl:value-of select="@title"/></h1>
        
        <!-- 'Alle anzeigen/verbergen'-Button -->
        <!-- Nur einfügen, falls Videos, Beispiele oder Übungen im Dokument bzw. in der Lerneinheit enthalten sind, die aufgeklappt werden können -->
        <xsl:if test=".//externalLink[matches(@uri, '.swf')] or .//referencesLink[@type='illustrates' or @type='exercises']">
            <button class="show_collapse_button">Alle Beispiele/Übungen anzeigen/verbergen</button>
        </xsl:if>
        
        <!-- Hauptinhalt der Seite (-> Templates für die einzelnen Elemente: siehe weiter unten) -->
        <xsl:apply-templates/> 
        
        <!-- Copyright/Autoren und Änderungsdatum -->
        <div class="content_data">
            <!-- Einfügen des Copyright-Symbols mit &#169; -->
            <!-- Einfügen von Leerzeichen, bei denen kein Zeilenumbruch stattfinden darf, mit &#160; -> Dadurch wird sichergestellt, dass der Zeilenumbruch auf kleineren Bildschirmen immer NACH dem '/'-Trenner erfolgt -->
            <span class="content_author">&#169;&#160;<xsl:value-of select="@author"/>&#160;/</span>
            <span class="content_date">&#160;Letzte inhaltliche Änderung am: <xsl:value-of select="@creationTime"/></span>
        </div>
        
        <!-- KURS-NAVIGATION -->
        <hr class="separation_line"/>
        <xsl:choose>
            
            <!-- Navigation für reguläre Lerneinheiten -->
            <!-- Testen, dass es sich nicht um die 1. Seite (= Startseite) eines Kurses handelt (-> Diese Seiten werden später gesondert behandelt) -->
            <xsl:when test="not($menue//section[@label = $label]/parent::section[@label='ligostart'])">
                <div class="course_nav">
                    <!-- Link zur vorherigen Einheit -->
                    <div class="previous_course">
                        <a class="previous_link">
                            <xsl:attribute name="href">
                                <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                <xsl:value-of select="$menue//section[@label = $label]/ancestor-or-self::section[@discipline]/@discipline"/>
                                <xsl:text>/</xsl:text>
                                <xsl:choose>
                                    <!-- Falls die aktuelle Lerneinheit keine vorhergehenden Geschwister hat (= falls es sich um die 1. Lerneinheit in diesem Kurs handelt): zu vorhergehendem Kurs springen -->
                                    <xsl:when test="count($menue//section[@label = $label]/preceding-sibling::section) = 0">
                                        <xsl:value-of select="$menue//section[@label = $label]/parent::section[1]/@uri"/> 
                                    </xsl:when>
                                    <!-- Ansonsten: zur ersten/naheliegendsten vorhergehenden Lerneinheit springen -->
                                    <xsl:otherwise>
                                        <xsl:value-of select="$menue//section[@label = $label]/preceding::section[1]/@uri"/> 
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:text>' | relative_url }}</xsl:text>
                            </xsl:attribute>
                            <i class="bi bi-chevron-double-left"></i><span class="link_text">Vorherige Lerneinheit</span>
                        </a>
                    </div>
                    <div class="course_separator">
                        |
                    </div>
                    <!-- Iterieren über alle Lerneinheiten des aktuellen Kurses -->
                    <xsl:for-each select="$menue//section[@label = $label]/parent::section/child::section">
                        <div class="course_item">
                            <xsl:choose>
                                <!-- Falls es sich um die Lerneinheit des aktuell transformierten Dokuments handelt: keinen Link, sondern nur Texteintrag generieren -->
                                <xsl:when test="@label = $label">
                                    <xsl:value-of select="@title"/>
                                </xsl:when>
                                <!-- Falls es sich um eine andere Lerneinheit des Kurses handelt: Link generieren -->
                                <xsl:otherwise>
                                    <a class="course_link">
                                        <xsl:attribute name="href">
                                            <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                            <xsl:value-of select="./ancestor-or-self::section[@discipline]/@discipline"/>
                                            <xsl:text>/</xsl:text>
                                            <xsl:value-of select="@uri"/>
                                            <xsl:text>' | relative_url }}</xsl:text>
                                        </xsl:attribute>
                                        <xsl:value-of select="@title"/>
                                    </a>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                        <div class="course_separator">
                            |
                        </div>
                    </xsl:for-each>
                    <!-- Link zur nächsten Einheit -->
                    <div class="next_course">
                        <a class="next_link">
                            <xsl:choose>
                                <!-- Testen, ob es sich bei der aktuellen Lerneinheit um die letzte ihres Wissensbereichs handelt und ob ihr eine neue 'discipline' (= Wissensbereich) folgt  -->
                                <!-- Falls ja: Generieren des Links zur 1. Lerneinheit in einem neuen Wissensbereich -->
                                <xsl:when test="(not($menue//section[@label = $label]/child::section)) and ($menue//section[@label = $label]/following::section[1][@discipline])">
                                    <xsl:attribute name="href">
                                        <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                        <xsl:value-of select="$menue//section[@label = $label]/following::section[1]/@discipline"/>
                                        <xsl:text>/</xsl:text>
                                        <xsl:value-of select="$menue//section[@label = $label]/following::section[1]/@uri"/>
                                        <xsl:text>' | relative_url }}</xsl:text>
                                    </xsl:attribute>
                                    Nächste Lerneinheit (Nächster Wissensbereich)
                                </xsl:when>
                                <!-- Ansonsten: Generieren des Links zur nächsten Lerneinheit im gleichen Wissensbereich -->
                                <xsl:otherwise>
                                    <xsl:attribute name="href">
                                        <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                        <xsl:value-of select="$menue//section[@label = $label]/ancestor-or-self::section[@discipline]/@discipline"/>
                                        <xsl:text>/</xsl:text>
                                        <xsl:choose>
                                            <!-- Testen, ob die aktuelle Lerneinheit ein Kindelement (= eine weitere Untereinheit) besitzt -->
                                            <!-- Falls ja: Generieren des Links zu dieser Untereinheit -->
                                            <xsl:when test="$menue//section[@label = $label]/child::section">
                                                <xsl:value-of select="$menue//section[@label = $label]/child::section[1]/@uri"/> 
                                            </xsl:when>
                                            <!-- Ansonsten: Generieren des Links zur nächsten Lerneinheit, die keine Untereinheit ist -->
                                            <xsl:otherwise>
                                                <xsl:value-of select="$menue//section[@label = $label]/following::section[1]/@uri"/> 
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:text>' | relative_url }}</xsl:text>
                                    </xsl:attribute>
                                    <span class="link_text">Nächste Lerneinheit</span>
                                </xsl:otherwise>
                            </xsl:choose>
                            <i class="bi bi-chevron-double-right"></i>
                        </a>
                    </div>
                </div>
            </xsl:when>
            
            <!-- Testen, ob es sich um die 1. Lerneinheit (= Startseite) eines Kurses handelt: -->
            <xsl:when test="$menue//section[@label = $label]/parent::section[@label='ligostart']">
                <xsl:choose>
                    <!-- Testen, dass es sich nicht um die 1. Seite des Prosa-Kurses handelt -->
                    <!-- (Grund: der Prosa-Kurs ist der 1. Kurs insgesamt, d.h. seiner 1. Kursseite gehen keine weiteren Seiten voraus -> Deshalb erhält die Prosa-Kursseite keinen Link zur vorherigen Seite bzw. zum vorherigen Wissensbereich, alle anderen 1. Kursseiten aber schon) -->
                    <xsl:when test="$menue//section[@label = $label][@discipline != 'prosa']">
                        <div class="course_nav">
                            <!-- Generieren des Links zur letzten Lerneinheit des vorherigen Wissensbereichs -->
                            <a class="previous_link">
                                <xsl:attribute name="href">
                                    <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                    <xsl:value-of select="$menue//section[@label = $label]/preceding-sibling::section[1]/@discipline"/>
                                    <xsl:text>/</xsl:text>
                                    <xsl:value-of select="$menue//section[@label = $label]/preceding-sibling::section[1]/descendant::section[last()]/@uri"/> 
                                    <xsl:text>' | relative_url }}</xsl:text>
                                </xsl:attribute>
                                <i class="bi bi-chevron-double-left"></i><span class="link_text">Vorherige Lerneinheit (Vorheriger Wissensbereich)</span>
                            </a>
                            <div class="course_separator">
                                |
                            </div>
                            <!-- Generieren des Links zur nächsten Lerneinheit des aktuellen Wissensbereichs -->
                            <a class="next_link">
                                <xsl:attribute name="href">
                                    <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                    <xsl:value-of select="$menue//section[@label = $label]/ancestor-or-self::section[@discipline]/@discipline"/>
                                    <xsl:text>/</xsl:text>
                                    <xsl:value-of select="$menue//section[@label = $label]/descendant::section[1]/@uri"/> 
                                    <xsl:text>' | relative_url }}</xsl:text>
                                </xsl:attribute>
                                <span class="link_text">Nächste Lerneinheit</span><i class="bi bi-chevron-double-right"></i>
                            </a>
                        </div>
                    </xsl:when>
                    <!-- Ansonsten (falls es sich um den Prosa-Kurs handelt): -->
                    <xsl:otherwise>
                        <!-- Generieren (nur) des Links zur nächsten Lerneinheit -->
                        <div class="only_next_item">
                            <a class="next_link">
                                <xsl:attribute name="href">
                                    <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                    <xsl:value-of select="$menue//section[@label = $label]/ancestor-or-self::section[@discipline]/@discipline"/>
                                    <xsl:text>/</xsl:text>
                                    <xsl:value-of select="$menue//section[@label = $label]/descendant::section[1]/@uri"/> 
                                    <xsl:text>' | relative_url }}</xsl:text>
                                </xsl:attribute>
                                <span class="link_text">Nächste Lerneinheit</span><i class="bi bi-chevron-double-right"></i>
                            </a>
                        </div>
                    </xsl:otherwise>
                </xsl:choose>  
            </xsl:when>
        </xsl:choose>
        
        <!-- FUSSNOTEN (Einträge am Seitenende -> Für dazugehörige Fußnoten-Links im Text: siehe letztes Template am Stylesheet-Ende) -->
        <!-- Testen, ob Fußnoten im aktuellen Dokument vorkommen -> Falls ja: Einfügen einer weitere Trennlinie unterhalb der Kursnavigation -->
        <xsl:if test=".//annotated">
            <hr class="separation_line"/>
        </xsl:if>
        <!-- Iterieren über alle Fußnoten-Elemente -->
        <xsl:for-each select=".//annotated">
            <!-- Generieren des Fußnoten-Links, des Fußnoten-Texts und des 'Zurück'-Links, der zurück zur Fußnote im Text führt -->
            <div class="footnote">
                <a class="footnote_link">
                    <xsl:attribute name="id">anchor_<xsl:number level="any"/></xsl:attribute>
                    <xsl:attribute name="href">#footnote_<xsl:number level="any"/></xsl:attribute>
                    <sup class="footnote_number">[<xsl:number level="any"/>]</sup>
                </a>
                <xsl:text xml:space="preserve"> </xsl:text>
                <xsl:value-of select="."/>
                <xsl:text xml:space="preserve"> </xsl:text>
                <a class="back_link">
                    <xsl:attribute name="href">#footnote_<xsl:number level="any"/></xsl:attribute><i class="bi bi-chevron-double-up"></i><span class="link_text">Zurück</span>
                </a>
            </div>
        </xsl:for-each>
    </xsl:template>
    
    <!-- BEISPIELE UND ÜBUNGEN -->
    <xsl:template match="referencesLink[@type='illustrates' or @type='exercises']">
        <!-- Festlegen einer Variable, in der die Nummer der aktuellen Übung gespeichert wird
             -> Sie wird benötigt, um die IDs der einzelnen Übungselemente mit der jeweiligen Übungsnummer zu versehen, damit sie auch bei mehreren Übungen auf einer Seite einzigartig sind und alle Übungen parallel funktionieren -->
        <xsl:variable name="ex_nr">
            <xsl:number level="any" count="referencesLink[@type='exercises']"/>
        </xsl:variable>
        <!-- Umschließen des Beispiels/der Übung mit einem <div class="list-group-item">-Element, dessen Inhalt aus- und eingeklappt werden kann -->
        <div class="ex list-group-item">
            <!-- Generieren des Links, über den der Inhalt ausgeklappt wird -->
            <a class="chevron_link" data-bs-toggle="collapse" aria-expanded="false">
                <xsl:attribute name="href">#<xsl:value-of select="key('examples_exercises', @target)/@label"/></xsl:attribute>
                <xsl:attribute name="aria-controls"><xsl:value-of select="key('examples_exercises', @target)/@label"/></xsl:attribute>
                <!-- Einfügen eines Chevrons, das beim Klicken auf den Link bzw. beim Ausklappen des Inhalts um 180° gedreht wird -->
                <i class="bi bi-chevron-down rotate_180"></i>
                <span class="expand_link"><xsl:value-of select="key('examples_exercises', @target)/@title"/></span>
            </a>
            <!-- Auszuklappender Inhalt (= Beispiel/Übung) -->
            <div class="list-group collapse">
                <xsl:attribute name="id"><xsl:value-of select="key('examples_exercises', @target)/@label"/></xsl:attribute>
                <xsl:choose>
                    
                    <!-- BEISPIEL -->
                    <!-- Nutzen und Überprüfen des Keys, um das Beispiel an dieser Stelle einzufügen -->
                    <xsl:when test="key('examples_exercises', @target)/@type = 'example'">
                        <xsl:apply-templates select="key('examples_exercises', @target)/*"/>
                    </xsl:when>
                    
                    <!-- MULTIPLE CHOICE- UND ALTERNATIVE TEXTBEISPIELE-ÜBUNG -->
                    <!-- Nutzen und Überprüfen des Keys, um die MC-/AT-Übung an dieser Stelle einzufügen -->
                    <xsl:when test="key('examples_exercises', @target)/@topics = 'multiplechoice' or key('examples_exercises', @target)/@topics='alternativen' or key('examples_exercises', @target)/@type='alternativen'">
                        <div class="exercise mc">
                            <!-- Einfügen der Fragestellung und des Textbeispiels (-> Templates für diese Elemente: siehe weiter unten, nach den Übungen) -->
                            <xsl:apply-templates select="key('examples_exercises', @target)/task[@type='fragestellung']"/>
                            <xsl:apply-templates select="key('examples_exercises', @target)/task[@type='textbeispiel']"/>
                            <!-- Generieren des Pools an auswählbaren MC-Optionen -->
                            <fieldset>
                                <xsl:attribute name="id">option_pool_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                <!-- Iterieren über alle MC-Optionen/-Alternativen -> Generieren eines Radio Buttons und eines Labels (= Textinhalt der Alternative) für jede Option -->
                                <xsl:for-each select="key('examples_exercises', @target)/task[@type='alternative']">
                                    <div class="option">
                                        <input type="radio">
                                            <xsl:attribute name="name">set_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                            <xsl:attribute name="id">option_<xsl:value-of select="$ex_nr"/>-<xsl:value-of select="@target"/></xsl:attribute>
                                            <xsl:attribute name="value"><xsl:value-of select="../solution[@label = current()/@target]/@true"/></xsl:attribute>
                                        </input>
                                        <label>
                                            <xsl:attribute name="for">option_<xsl:value-of select="$ex_nr"/>-<xsl:value-of select="@target"/></xsl:attribute>
                                            <xsl:apply-templates/>
                                        </label>
                                    </div>
                                </xsl:for-each>
                            </fieldset>
                            <!-- Generieren der Buttons zum Zurücksetzen der Übung und zum Auswerten/Anzeigen der Lösung -->
                            <div class="exercise_buttons">
                                <button>
                                    <xsl:attribute name="id">reset_button_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                    Übung zurücksetzen
                                </button>
                                <button>
                                    <xsl:attribute name="id">solution_button_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                    Lösung anzeigen
                                </button>                            
                            </div>
                            <!-- Generieren eines Elements, in dem das Feedback und die Lösung später mittels JavaScript eingefügt wird (-> Siehe uebungen.js-Datei im assets -> js-Ordner)
                                 -> Dieses Element bleibt zunächst auf der Webseite verborgen und wird erst nach einem Klick auf den 'Lösung anzeigen'-Button sichtbar gemacht -->
                            <div class="solution">
                                <xsl:attribute name="id">solution_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                <div class="feedback">
                                    <xsl:attribute name="id">feedback_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                </div>
                                <div class="answer">
                                    <xsl:attribute name="id">answer_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                </div>
                            </div>
                            <!-- Speichern aller Antworten/Lösungen in einem Element 
                                 -> Dieses Element bleibt dauerhaft auf der Webseite verborgen und wird nur im JS-Skript genutzt, um die passende Lösung zur ausgewählten Option bereitzustellen -->
                            <div class="answer_pool">
                                <xsl:attribute name="id">answer_pool_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                <xsl:for-each select="key('examples_exercises', @target)/solution">
                                    <span>
                                        <!-- Ausstatten jeder Anwort mit einer Klasse -> Diese wird bei der Auswertung mit der ID der ausgewählten Antwort abgeglichen, um so diejenige Lösung anzuzeigen, die zur ausgewählten Option passt (-> Siehe uebungen.js-Datei) -->
                                        <xsl:attribute name="class">option_<xsl:value-of select="$ex_nr"/>-<xsl:value-of select="@label"/></xsl:attribute>
                                        <xsl:apply-templates/>
                                    </span>
                                </xsl:for-each>
                            </div>
                        </div>
                    </xsl:when>
                    
                    <!-- TEXTEINGABE-ÜBUNG -->
                    <xsl:when test="key('examples_exercises', @target)/@topics='musterloesung'">
                        <div class="exercise text">
                            <xsl:apply-templates select="key('examples_exercises', @target)/task[@type='fragestellung']"/>
                            <xsl:apply-templates select="key('examples_exercises', @target)/task[@type='textbeispiel']"/>
                            <!-- Generieren eines Textfelds, das von dem/der Übenden mit einem eigenen Text befüllt werden kann -->
                            <div class="input">
                                <div class="pretext">Ihre Formulierung:</div>
                                <textarea class="input_field">
                                    <xsl:attribute name="id">input_field_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                </textarea>
                            </div>
                            <div class="exercise_buttons">
                                <button>
                                    <xsl:attribute name="id">reset_button_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                    Übung zurücksetzen
                                </button>
                                <button>
                                    <xsl:attribute name="id">solution_button_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                    Lösung anzeigen
                                </button>                            
                            </div>
                            <div class="solution">
                                <xsl:attribute name="id">solution_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                <div class="feedback">
                                    <xsl:attribute name="id">feedback_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                    Musterlösung:
                                </div>
                                <div class="answer">
                                    <xsl:attribute name="id">answer_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                    <xsl:apply-templates select="key('examples_exercises', @target)/task[@type='userinput']"/>
                                </div>
                            </div>
                        </div>
                    </xsl:when>
                    
                    <!-- MARKIEREN-ÜBUNG -->
                    <xsl:when test="key('examples_exercises', @target)/@topics='markieren'">
                        <div class="exercise marker">
                            <xsl:apply-templates select="key('examples_exercises', @target)/task[@type='fragestellung']"/>
                            <xsl:apply-templates select="key('examples_exercises', @target)/task[@type='selection']/quotation"/>
                            <div class="exercise_buttons">
                                <!-- Einfügen eines zusätzlichen 'Markieren'-Buttons, über den die Textauswahl, die zuvor mit dem Maus-Cursor vorgenommen wurde, als Markierung festgelegt werden kann -->
                                <button>
                                    <xsl:attribute name="id">mark_button_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                    Markierung setzen
                                </button>
                                <button>
                                    <xsl:attribute name="id">reset_button_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                    Übung zurücksetzen
                                </button>
                                <button>
                                    <xsl:attribute name="id">solution_button_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                    Lösung anzeigen
                                </button>                            
                            </div>
                            <div class="solution">
                                <xsl:attribute name="id">solution_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                <div class="feedback">
                                    <xsl:attribute name="id">feedback_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                    <!-- Testen, ob ein Antwort-/Lösungstext im XML-Dokument vorhanden ist -> Falls ja: 'Erläuterung:'-Prätext einfügen -->
                                    <xsl:if test="key('examples_exercises', @target)//LMMLtext[@type='answerText']">Erläuterung:</xsl:if>
                                </div>
                                <div class="answer">
                                    <xsl:attribute name="id">answer_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                    <xsl:apply-templates select="key('examples_exercises', @target)//LMMLtext[@type='answerText']"/>
                                </div>
                            </div>
                        </div>
                    </xsl:when>
                    
                    <!-- LÜCKENTEXT-ÜBUNG -->
                    <xsl:when test="key('examples_exercises', @target)/@topics='luecken'">
                        <div class="exercise gaps">
                            <xsl:apply-templates select="key('examples_exercises', @target)/task[@type='fragestellung']"/>
                            <xsl:for-each select="key('examples_exercises', @target)//task[@type='lueckentext']/quotation[@type='luecken']/LMMLtext">
                                <xsl:if test="./text()">
                                    <div class="gap_text">
                                        <xsl:attribute name="id">gap_text_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                        <xsl:apply-templates/>
                                    </div>
                                </xsl:if>
                            </xsl:for-each>
                            <div class="exercise_buttons">
                                <button>
                                    <xsl:attribute name="id">reset_button_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                    Übung zurücksetzen
                                </button>
                                <button>
                                    <xsl:attribute name="id">solution_button_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                    Lösung anzeigen
                                </button>
                            </div>
                            <!-- Generieren eines Elements, in dem jetzt die Antwort/Lösung aus dem XML-Dokument und später das Feedback mittels JavaScript eingefügt wird (-> Siehe uebungen.js-Datei) -->
                            <div class="solution">
                                <xsl:attribute name="id">solution_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                <div class="feedback">
                                    <xsl:attribute name="id">feedback_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                </div>
                                <div class="answer">
                                    <xsl:attribute name="id">answer_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                    <xsl:apply-templates select="key('examples_exercises', @target)//task[@type='lueckenerlaeuterung']"/>
                                </div>
                            </div>
                        </div>
                    </xsl:when>
                    
                    <!-- DRAG AND DROP-ÜBUNG -->
                    <xsl:otherwise>
                        <div class="exercise dnd">
                            <!-- Einfügen des Warnhinweises, dass DND aktuell nur auf PCs/Laptops funktioniert -->
                            <div class="dnd_info">
                                <div class="pretext">Hinweis:</div>
                                Drag and Drop wird bislang nur auf PCs/Laptops beziehungsweise auf Geräten unterstützt, die eine Maus oder ein Trackpad nutzen.
                                Auf Touchscreen-Geräten wie Smartphones und Tablets können Sie diese Übung daher momentan noch nicht durchführen.
                            </div>
                            <xsl:apply-templates select="key('examples_exercises', @target)/task[@type='fragestellung']"/>
                            <xsl:apply-templates select="key('examples_exercises', @target)/task[@type='textbeispiel']"/>
                            <!-- Generieren der Drop-Areas, in denen die DND-Items platziert werden sollen -->
                            <div class="drop_areas">
                                <xsl:attribute name="id">drop_areas_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                <!-- Iterieren über alle Spalten der DND-Tabelle im XML-Dokument -> Für jede Spalte: -->
                                <xsl:for-each select="key('examples_exercises', @target)//LMMLtext[matches(@type, 'column')]">
                                    <div class="drop_wrapper">
                                        <!-- Einfügen der Drop-Area-Überschrift -->
                                        <div class="drop_head"><xsl:apply-templates/></div>
                                        <!-- Einfügen einer Trennlinie -->
                                        <hr class="drop_separation"/>
                                        <!-- Einfügen der eigentlichen Drop-Area, in der die DND-Items platziert werden können -->
                                        <!-- Ausstatten der Drop-Area mit einer ID und Attributen, welche die DND-Funktion ermöglichen -->
                                        <div class="drop_area" ondrop="drop(event, this)" ondragover="allowDrop(event)">
                                            <xsl:attribute name="id">drop_area_<xsl:value-of select="$ex_nr"/>-<xsl:number count="LMMLtext[matches(@type, 'column')]"/></xsl:attribute>
                                        </div>
                                    </div>
                                </xsl:for-each>
                            </div>
                            <div class="dnd_items">
                                <xsl:attribute name="id">dnd_items_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                <!-- Iterieren über alle <LMMLtext type='input'>-Elemente (= DND-Items) -->
                                <xsl:for-each select="key('examples_exercises', @target)//LMMLtext[matches(@type, 'input')]">
                                    <!-- Sicherstellen, dass das Element nicht leer ist -->
                                    <xsl:if test=". != ''">
                                        <!-- Austatten des Items mit einer ID und Attributen, welche die DND-Funktion ermöglichen -->
                                        <div draggable="true" ondragstart="drag(event)">
                                            <xsl:attribute name="id">dnd_item_<xsl:value-of select="$ex_nr"/>-<xsl:number count="LMMLtext[matches(@type, 'input')]"/></xsl:attribute>
                                            <!-- Austatten des Items mit einer Klasse -> Diese wird bei der Auswertung mit der ID der Drop-Area abgeglichen, in der das Item platziert wurde, um so festzustellen, ob das Item korrekt zugeordnet wurde (-> Siehe uebungen.js-Datei) -->
                                            <xsl:attribute name="class">drop_area_<xsl:value-of select="$ex_nr"/>-<xsl:value-of select="@title"/></xsl:attribute>
                                            <xsl:apply-templates/>
                                        </div>
                                    </xsl:if>
                                </xsl:for-each>
                            </div>
                            <div class="exercise_buttons">
                                <button>
                                    <xsl:attribute name="id">reset_button_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                    Übung zurücksetzen
                                </button>
                                <button>
                                    <xsl:attribute name="id">solution_button_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                    Lösung anzeigen
                                </button>
                            </div>
                            <!-- Generieren eines Elements, in dem später das Feedback mittels JavaScript eingefügt wird (-> Siehe uebungen.js-Datei) -->
                            <div class="solution">
                                <xsl:attribute name="id">solution_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                <div class="feedback">
                                    <xsl:attribute name="id">feedback_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                </div>
                            </div>
                        </div>
                    </xsl:otherwise>
                    
                </xsl:choose>
            </div>
        </div>
    </xsl:template>
    
    <!-- ÜBUNGEN: WEITERES -->
    <!-- Alle Übungen: Einfügen des 'Fragestellung:'-Prätexts vor der Frage/Aufgabe -->
    <xsl:template match="task[@type='fragestellung']">
        <div class="task">
            <div class="pretext">Fragestellung:</div>
            <div class="text"><xsl:apply-templates/></div>
        </div>
    </xsl:template>
    
    <!-- Alternative Textbeispiele-Übung: Prosa-Textbeispiel -->
    <xsl:template match="task[@type='alternative']//quotation">
        <!-- Hier müssen <span>-Elemente zur Umschließung der Texteinheiten verwendet werden (statt Blockelemente wie <p> oder <div>, die für diesen Zweck eigentlich vorgesehen sind)
             -> Grund: <p> und <div> sind nicht als Kindelemente von <label> bei den MC-Optionen erlaubt (-> Ungültiges HTML) -->
        <span class="text">
            <xsl:apply-templates/>
        </span>
        <!-- Testen, ob ein Autorvorname oder -nachname beim aktuellen Text vorhanden ist -> Falls ja: Hinzufügen der Angaben zu Autor und Werktitel -->
        <xsl:if test="@authorname or @authorfamily">
            <span class="author_title">
                <span class="author"><xsl:value-of select="@authorname"/><xsl:text xml:space="preserve"> </xsl:text><xsl:value-of select="@authorfamily"/>:</span>
                <xsl:choose>
                    <!-- Testen, ob das booktitle-Attribut einen Textinhalt (und nicht nur Leerzeichen) besitzt -> Falls ja: Titel daraus beziehen -->
                    <xsl:when test="normalize-space(@booktitle) != ''">
                        <span class="title"><xsl:text xml:space="preserve"> </xsl:text><xsl:value-of select="@booktitle"/></span>
                    </xsl:when>
                    <!-- Testen, ob das title-Attribut einen Textinhalt (und nicht nur Leerzeichen) besitzt -> Falls ja: Titel daraus beziehen -->
                    <xsl:when test="normalize-space(@title) != ''">
                        <span class="title"><xsl:text xml:space="preserve"> </xsl:text><xsl:value-of select="@title"/></span>
                    </xsl:when>
                </xsl:choose>
            </span>
        </xsl:if>
    </xsl:template>
    
    <!-- Alternative Textbeispiele-Übung: Lyrik-Textbeispiel -->
    <!-- Gesamtes Gedicht -->
    <xsl:template match="task[@type='alternative']//poem">
        <!-- Hier müssen <span>-Elemente zur Umschließung der Texteinheiten verwendet werden (statt Blockelemente wie <p> oder <div>, die für diesen Zweck eigentlich vorgesehen sind)
             -> Grund: <p> und <div> sind nicht als Kindelemente von <label> bei den MC-Optionen erlaubt (-> Ungültiges HTML) -->
        <span class="poem">
            <xsl:apply-templates/>
            <xsl:if test="@authorname or @authorfamily">
                <span class="author_title">
                    <span class="author"><xsl:value-of select="@authorname"/><xsl:text xml:space="preserve"> </xsl:text><xsl:value-of select="@authorfamily"/>:</span>
                    <xsl:choose>
                        <xsl:when test="normalize-space(@booktitle) != ''">
                            <span class="title"><xsl:text xml:space="preserve"> </xsl:text><xsl:value-of select="@booktitle"/></span>
                        </xsl:when>
                        <xsl:when test="normalize-space(@title) != ''">
                            <span class="title"><xsl:text xml:space="preserve"> </xsl:text><xsl:value-of select="@title"/></span>
                        </xsl:when>
                    </xsl:choose>
                </span>
            </xsl:if>
        </span>
    </xsl:template>
    
    <!-- Strophen -->
    <xsl:template match="task[@type='alternative']//poem//poemlinegroup">
        <span class="poem_linegroup">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- Verse -->
    <xsl:template match="task[@type='alternative']//poem//poemline">
        <span class="poem_line">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- Texteingabe-Übung: Lösungstext -->
    <xsl:template match="task[@type='userinput']/LMMLtext">
        <div class="text">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- Markieren-Übung: Kennzeichnung für die korrekten/gesuchten Stellen im markierbaren Text -->
    <xsl:template match="formatted[@style='richtig' or @style='style1']">
        <span class="correct_marker">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- Lückentext-Übung: Lücken/Optionen -->
    <!-- Unterbinden der Darstellung von <option>-Elementen mit target-Attribut -> Sonst werden zu viele Lücken generiert -->
    <xsl:template match="option[@target]"/>
    
    <!-- Darstellen (nur) der <option>-Elemente ohne target-Attribut -> So wird die korrekte Anzahl an Lücken generiert -->
    <xsl:template match="option[not(@target)]">
        <xsl:variable name="label"><xsl:value-of select="@label"/></xsl:variable>
        <select name="dropdown" class="gap">
            <!-- Festlegen des Standardwerts für jede Lücke, der zu Beginn eingestellt ist -->
            <option value="standard">--- bitte auswählen ---</option>
            <!-- Anwenden des Templates für das aktuelle <option>-Element -->
            <!-- Versehen mit dem Attribut value="true", da es sich hierbei um die korrekte Option handelt -->
            <option value="true"><xsl:apply-templates/></option>
            <!-- Iterieren über alle nachfolgenden Geschwisterelemente, deren target-Attribut mit dem label der Lücke übereinstimmt (= weitere Optionen für diese Lücke) -->
            <xsl:for-each select="following-sibling::option[@target=$label]">
                <!-- Versehen mit dem Attribut value="false", da es sich hierbei um die inkorrekten Optionen handelt -->
                <option value="false"><xsl:value-of select="."></xsl:value-of></option>
            </xsl:for-each>
        </select>
    </xsl:template>
    
    <!-- TEXT(FORMATIERUNGEN) -->
    <!-- Zwischenüberschrift -->
    <xsl:template match="formatted[@style='ueberschrift']">
        <h6>
            <xsl:apply-templates/>
        </h6>
    </xsl:template>
    
    <!-- Werktitel (-> Werden kursiv dargestellt) -->
    <xsl:template match="formatted[@style='buchtitel']">
        <span class="title">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- Regieanweisungen (-> Werden kursiv dargestellt) -->
    <xsl:template match="formatted[@style='regie']">
        <span class="stage_dir">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- Hervorhebungen (-> Werden kursiv dargestellt) -->
    <xsl:template match="formatted[@style='hervorhebung']">
        <span class="highlight">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- Begriffsdefinitionen (-> Begriffe werden rot/fett dargestellt) -->
    <xsl:template match="definition">
        <div class="definition">
            <span class="term"><xsl:value-of select="@title"/></span>
            <xsl:text>: </xsl:text>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- Textabschnitte (1) -->
    <xsl:template match="illustration[@label]/LMMLtext">
        <div class="text">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- Textabschnitte (2) -->
    <xsl:template match="illustration[not(@*)]/LMMLtext">
        <xsl:choose>
            <!-- Testen, ob es sich um ein Textelement in einem Beispiel handelt -> Falls ja: Umschließen mit Blockelement <div> -->
            <xsl:when test="ancestor::section[@type='example']">
                <div class="text">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <!-- Testen, ob es sich um ein Textelement handelt, das eine Überschrift, ein Gedicht oder einen Link beinhaltet -> Falls ja: kein Umschließen mit Blockelement <div> -->
            <xsl:when test=".//formatted[@style='ueberschrift'] or .//poem or .//externalLink">
                <xsl:apply-templates/>
            </xsl:when>
            <!-- Testen, ob es sich um ein Textelement handelt, das Text und/oder eine Referenz auf eine Übung oder ein Beispiel beinhaltet -> Falls ja: -->
            <xsl:when test=".//referencesLink[@type='exercises'] or .//referencesLink[@type='illustrates']">
                <!-- Testen, ob Text vorhanden ist -> Falls ja: Umschließen des Textabschnitts mit Blockelement <div> -->
                <xsl:if test=".//text()">
                    <div class="paragraph">
                        <xsl:apply-templates select=".//text()"/>
                    </div>
                </xsl:if>
                <!-- Anwenden der Templates für die Übungen/Beispiele, damit diese in das HTML-Dokument integriert werden -->
                <xsl:apply-templates select=".//referencesLink[@type='illustrates' or @type='exercises']"/>
            </xsl:when>
            <!-- Ansonsten (falls keine der vorherigen Optionen zutrifft und Text im Textelement vorhanden ist): Umschließen des Textabschnitts mit Blockelement <div> -->
            <xsl:otherwise>
                <xsl:if test=".//text()">
                    <div class="paragraph">
                        <xsl:apply-templates/>
                    </div>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- MEDIEN -->
    <!-- PDFs -->
    <xsl:template match="externalLink[matches(@uri, '.pdf|.PDF')]">
        <object class="pdf" type="application/pdf">
            <xsl:attribute name="data"><xsl:text>{{ 'assets/media/</xsl:text><xsl:value-of select="@uri"/><xsl:text>' | relative_url }}</xsl:text></xsl:attribute>
        </object>
    </xsl:template>
    
    <!-- Bilder -->
    <xsl:template match="externalLink[matches(@uri, '.jpg|.JPG|.gif|.GIF')]">
        <img class="media">
            <xsl:attribute name="src"><xsl:text>{{ 'assets/media/</xsl:text><xsl:value-of select="@uri"/><xsl:text>' | relative_url }}</xsl:text></xsl:attribute>
        </img>
    </xsl:template>
    
    <!-- Videos -->
    <xsl:template match="LMMLtext[externalLink[matches(@uri, '.swf|.SWF')]]" priority="1">
        <!-- Einbetten des Videos in einem aus-/einklappbaren Element -->
        <div class="ex list-group-item">
            <a class="chevron_link" data-bs-toggle="collapse" aria-expanded="false">
                <xsl:attribute name="href">#<xsl:value-of select="./externalLink/substring-before(@uri, '.')"/></xsl:attribute>
                <xsl:attribute name="aria-controls"><xsl:value-of select="./externalLink/substring-before(@uri, '.')"/></xsl:attribute>
                <i class="bi bi-chevron-down rotate_180"></i>
                <span class="expand_link"><xsl:value-of select="."/></span>
            </a>
            <div class="list-group collapse">
                <xsl:attribute name="id"><xsl:value-of select="./externalLink/substring-before(@uri, '.')"/></xsl:attribute>
                <video class="media" type="video/mp4" controls="controls">
                    <xsl:attribute name="src"><xsl:text>{{ 'assets/media/</xsl:text><xsl:value-of select="./externalLink/substring-before(@uri, '.')"/><xsl:text>.mp4' | relative_url }}</xsl:text></xsl:attribute>
                    Video-Wiedergabe wird nicht vom Browser unterstützt.
                </video>
            </div>
        </div>
    </xsl:template>
    
    <!-- LISTEN -->
    <!-- Nicht-nummerierte (Stichpunkt-)Listen -->
    <xsl:template match="ulist">
        <ul class="unordered_list">
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    
    <!-- Nummerierte Listen -->
    <xsl:template match="olist">
        <ol class="ordered_list">
            <xsl:apply-templates/>
        </ol>
    </xsl:template>
    
    <!-- Listeneinträge -->
    <xsl:template match="item">
        <li class="list_item">
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    
    <!-- TABELLEN -->
    <xsl:template match="table">
        <table class="standard_table">
            <xsl:for-each select="./tablerow">
                <tr>
                    <xsl:for-each select="./tabledata">
                        <td class="table_data"><xsl:value-of select="."/></td>
                    </xsl:for-each>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>
    
    <!-- ERLÄUTERUNGEN/BEISPIELE -->
    <!-- Leerlassen des Templates, damit Übungen/Beispiele nicht doppelt bzw. noch einmal am Ende des Texts eingefügt werden -> Sie werden bereits über den Key an der vorgesehenen Stelle integriert (-> Siehe weiter oben) -->
    <xsl:template match="exercise|section[@type='example']"/>
    
    <!-- Erläuterungen/Textbeispiele -->
    <xsl:template match="section[@type='example']/illustration">
        <xsl:choose>
            <!-- Testen, dass das Element einen Inhalt besitzt und dass es sich nicht um ein Textbeispiel handelt -> Falls ja: 'Erläuterung:'-Prätext einfügen -->
            <xsl:when test="./node() and not(.//quotation or .//poem)">
                <div class="explanation">
                    <div class="pretext">Erläuterung:</div>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <!-- Ansonsten (wenn es sich um ein Textbeispiel handelt): keinen Prätext einfügen -->
            <xsl:when test="./node()">
                <xsl:apply-templates/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- Prosa- und Drama-Textbeispiel/-zitat (das nicht zu einer Alternative Textbeispiele-Übung gehört) -->
    <xsl:template match="quotation[not(ancestor::task[@type='alternative'])]">
        <!-- Sicherstellen, dass das Element nicht leer ist -->
        <xsl:if test=".//node()">
            <xsl:variable name="ex_nr"><xsl:number level="any" count="exercise"/></xsl:variable>
            <div class="quotation">
                <!-- Testen, ob der Text ein Teil der Markieren-Übung ist -> Falls ja: Kennzeichnen mit ID als markierbarer Text, damit später per JavaScript darauf zugegriffen werden kann (-> Siehe uebungen.js-Datei) -->
                <xsl:if test="ancestor::task[@type='selection']">
                    <xsl:attribute name="id">markable_text_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                </xsl:if>
                <!-- Einfügen des 'Textbeispiel:'-Prätexts vor dem Text -->
                <div class="pretext">Textbeispiel:</div>
                <xsl:apply-templates/>
                <xsl:if test="@authorname or @authorfamily">
                    <div class="author_title">
                        <span class="author"><xsl:value-of select="@authorname"/><xsl:text xml:space="preserve"> </xsl:text><xsl:value-of select="@authorfamily"/>:</span>
                        <xsl:choose>
                            <xsl:when test="normalize-space(@booktitle) != ''">
                                <span class="title"><xsl:text xml:space="preserve"> </xsl:text><xsl:value-of select="@booktitle"/></span>
                            </xsl:when>
                            <xsl:when test="normalize-space(@title) != ''">
                                <span class="title"><xsl:text xml:space="preserve"> </xsl:text><xsl:value-of select="@title"/></span>
                            </xsl:when>
                        </xsl:choose>
                    </div>
                </xsl:if>
            </div>
        </xsl:if>
    </xsl:template>
    
    <!-- Prosa-Textabschnitte -->
    <xsl:template match="quotation/LMMLtext[not(@type='br')]">
        <xsl:if test=".//node()">
            <xsl:choose>
                <!-- Testen, ob der Text ein Teil der Markieren-Übung ist -> Falls ja: Textabschnitte dürfen nicht mit <div>-Elementen umschlossen werden, weil das Markieren sonst nicht mehr korrekt funktioniert -->
                <!-- Für Zeilenumbrüche wird stattdessen mit <br/>-Elementen gesorgt -->
                <xsl:when test="ancestor::task[@type='selection']">
                    <xsl:apply-templates/><br/>
                </xsl:when>
                <!-- Ansonsten: <div>-Elemente können verwendet werden und <br/>-Elemente sind nicht nötig -->
                <xsl:otherwise>
                    <div class="text">
                        <xsl:apply-templates/>
                    </div>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <!-- Drama-Textabschnitte (= Sprechakte, Regieanweisungen etc.) -->
    <xsl:template match="quotation/LMMLtext[@type='br']">
        <xsl:if test=".//text()">
            <xsl:choose>
                <!-- Auch hier: Testen, ob der Text ein Teil der Markieren-Übung ist, und wie im vorhergehenden Template verfahren -->
                <xsl:when test="ancestor::task[@type='selection']">
                    <xsl:apply-templates/><br/>
                </xsl:when>
                <xsl:otherwise>
                    <div class="drama_line">
                        <xsl:apply-templates/>
                    </div>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <!-- Lyrik-Textbeispiel/-zitat (das nicht zu einer Alternative Textbeispiele-Übung gehört) -->
    <!-- Gesamtes Gedicht -->
    <xsl:template match="poem[not(ancestor::task[@type='alternative'])]">
        <xsl:if test=".//text()">
            <div class="poem">
                <div class="pretext">Textbeispiel:</div>
                <xsl:apply-templates/>
                <xsl:if test="@authorname or @authorfamily">
                    <div class="author_title">
                        <span class="author"><xsl:value-of select="@authorname"/><xsl:text xml:space="preserve"> </xsl:text><xsl:value-of select="@authorfamily"/>:</span>
                        <xsl:choose>
                            <xsl:when test="normalize-space(@booktitle) != ''">
                                <span class="title"><xsl:text xml:space="preserve"> </xsl:text><xsl:value-of select="@booktitle"/></span>
                            </xsl:when>
                            <xsl:when test="normalize-space(@title) != ''">
                                <span class="title"><xsl:text xml:space="preserve"> </xsl:text><xsl:value-of select="@title"/></span>
                            </xsl:when>
                        </xsl:choose>
                    </div>
                </xsl:if>
            </div>
        </xsl:if>
    </xsl:template>
    
    <!-- Strophen -->
    <xsl:template match="poemlinegroup[not(ancestor::task[@type='alternative'])]">
        <div class="poem_linegroup">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- Verse -->
    <xsl:template match="poemline[not(ancestor::task[@type='alternative'])]">
        <div class="poem_line">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- INTERNE LINKS -->
    <!-- Sicherstellen, dass es sich bei dem Link-Element nicht um eine (Pop-Over-)Definition, ein Beispiel, eine Übung oder ein Werk handelt -->
    <xsl:template match="referencesLink[@target and not(@type='defines') and not(@type='illustrates') and not(@type='exercises') and not(@type='book')]">
        <xsl:choose>
            <!-- Sicherstellen, dass es sich weder beim Eltern- noch beim Kindelement um ein Element handelt, das als eine Pop-Over-Definition erhält --> 
            <!-- Grund: hier wird der interne Link auf andere Weise umgesetzt -> Siehe nachfolgendes POP-OVER-Template) -->
            <xsl:when test="not(./parent::referencesLink[@type='defines']) and not(./child::referencesLink[@type='defines'])">
                <!-- Nutzen der path-Variable und der contains()-Funktion, um den internen Link zu generieren -->
                <a class="internal_link">
                    <xsl:attribute name="href">
                        <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                        <xsl:choose>
                            <xsl:when test="contains($path, 'drama')">
                                <xsl:text>drama/</xsl:text>
                            </xsl:when>
                            <xsl:when test="contains($path, 'edition')">
                                <xsl:text>edition/</xsl:text>
                            </xsl:when>
                            <xsl:when test="contains($path, 'fachgeschichtegerm')">
                                <xsl:text>fachgeschichtegerm/</xsl:text>
                            </xsl:when>
                            <xsl:when test="contains($path, 'lyrik')">
                                <xsl:text>lyrik/</xsl:text>
                            </xsl:when>
                            <xsl:when test="contains($path, 'metrik')">
                                <xsl:text>metrik/</xsl:text>
                            </xsl:when>
                            <xsl:when test="contains($path, 'prosa')">
                                <xsl:text>prosa/</xsl:text>
                            </xsl:when>
                            <xsl:when test="contains($path, 'rhetorik')">
                                <xsl:text>rhetorik/</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:value-of select="@target"/>
                        <xsl:text>.html' | relative_url }}</xsl:text>
                    </xsl:attribute>
                    <i class="bi bi-chevron-right"></i><span class="link_text"><xsl:apply-templates/></span>
                </a>
            </xsl:when>
            <!-- Ansonsten: keinen Link generieren -->
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <!-- POP-OVER -->
    <xsl:template match="referencesLink[@type='defines']">
        <!-- Speichern des target-Attributwerts (= definierter Begriff) in der target-Variable -> Wird gleich zum Finden der aktuellen Definition in der definitionen.xml-Datei verwendet -->
        <xsl:variable name="target" select="@target"/>
        <!-- Generieren des Pop-Overs -->
        <details class="pop_over">
            <!-- Generieren des Pop-Over-Links mit einem Caret-Icon, das beim Anklicken des Links bzw. beim Öffnen des Pop-Over-Fensters um 90° nach oben gedreht wird (-> Siehe svg_icons.scss-Datei im _sass-Ordner) -->
            <summary class="pop_over_link">
                <i class="bi bi-caret-right-fill rotate_90"></i><xsl:apply-templates/>
            </summary>
            <!-- Iterieren über alle Definitionen in der definitionen.xml-Datei -->
            <!-- In dieser Datei, die extra für diesen Zweck generiert wurde (-> Siehe definitionen.xsl-Datei in diesem Ordner), sind sämtliche Definitionen aller Lerneinheiten enthalten -->
            <xsl:for-each select="document('../xml_daten/selbstgenerierte/definitionen.xml')//div[@class='definition']">
                <!-- Testen, ob das Label der aktuellen Definition (in der definitionen.xml-Datei) dem target-Wert der gesuchten Definition für das Pop-Over im HTML-Dokument entspricht -> Falls ja: -->
                <xsl:if test="@label = $target">
                    <!-- Generieren des Pop-Over-Inhalts -->
                    <div class="pop_over_content">
                        <!-- Entnehmen der Überschrift und der Definition aus der definitionen.xml-Datei -->
                        <h5><xsl:value-of select="@id"/></h5>
                        <span class="pop_over_text"><xsl:value-of select="."/></span>
                        <!-- Generieren des Links zu derjenigen Lerneinheit, die diese Definition beinhaltet -->
                        <div class="pop_over_course_link">
                            <a class="course_link">
                                <xsl:attribute name="href">
                                    <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="contains($path, 'drama')">
                                            <xsl:text>drama/</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains($path, 'edition')">
                                            <xsl:text>edition/</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains($path, 'fachgeschichtegerm')">
                                            <xsl:text>fachgeschichtegerm/</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains($path, 'lyrik')">
                                            <xsl:text>lyrik/</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains($path, 'metrik')">
                                            <xsl:text>metrik/</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains($path, 'prosa')">
                                            <xsl:text>prosa/</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains($path, 'rhetorik')">
                                            <xsl:text>rhetorik/</xsl:text>
                                        </xsl:when>
                                    </xsl:choose>
                                    <xsl:value-of select="@file"/>
                                    <xsl:text>' | relative_url }}</xsl:text>
                                </xsl:attribute>
                                <i class="bi bi-chevron-right"></i><span class="link_text">Zur Kursseite</span>
                            </a>
                        </div>
                    </div>
                </xsl:if>
            </xsl:for-each>
        </details>
    </xsl:template>
        
    <!-- FUSSNOTEN (Link im Text) -->
    <xsl:template match="annotated">
        <a class="footnote_link">
            <xsl:attribute name="id">footnote_<xsl:number level="any"/></xsl:attribute>
            <xsl:attribute name="href">#anchor_<xsl:number level="any"/></xsl:attribute>
            <sup class="footnote_number">[<xsl:number level="any"/>]</sup>
        </a>
    </xsl:template>
    
</xsl:stylesheet>