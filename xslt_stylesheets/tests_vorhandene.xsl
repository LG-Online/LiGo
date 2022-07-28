<!-- ANWENDUNG UND ZIEL -->
<!-- Anwenden des Stylesheets auf die [test].xml-Dateien (im daten -> xml_tests-Ordner) mit der Fragenstruktur für die einzelnen Tests -->
<!-- Generieren der [test].html-Dateien (im _pages -> tests-Ordner) mit dem Test zum jeweiligen Themengebiet -->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon" exclude-result-prefixes="saxon">
    <xsl:output method="html" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- VARIABLE -->
    <!-- Speichern der Gesamtanzahl an Übungen/MC-Fragen in einer Variable -> Wird später genutzt, um den Einleitungstext zu generieren -->
    <xsl:variable name="fragen_gesamt" select="count(.//exercise)"/>    
    
    <!-- YAML FRONT MATTER -->
    <!-- Festlegen des Seitentitels, der dann im Browser-Tab angezeigt wird -->
    <!-- Festlegen des Seitenlayouts, das in der default.html-Datei (im _layouts-Ordner) vorgegeben wird -->
    <!-- Festlegen des Seitentyps, der für die Zuordnung der benötigten JavaScript-Skripte in der scripts.html-Datei (im _includes-Ordner) genutzt wird -->
    <xsl:template match="/">---
        title: "Test - <xsl:value-of select="//exerciselist[1]/@title"/>"
        layout: default
        type: test
        ---
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- GESAMTER TEST -->
    <xsl:template match="exerciselist">
        <!-- Austatten der Überschrift mit einer ID, damit sie als Link-Anker dienen kann -> Ermöglicht den Sprung per Button-Klick zurück zur Überschrift/zum Seitenanfang -->
        <h1 id="top">Test - <xsl:value-of select="@title"/></h1>
        <!-- Generieren des Einleitungstexts mit Infos zur Fragenanzahl, Thema und Zeitvorgabe -->
        <!-- Dazu: Verwenden des seconds-to-time-Templates zur Umrechung der vorgegebenen Zeit von Sekunden in Minuten und Sekunden (-> Siehe letztes Template unten) -->
        <div class="introduction">
            Bei diesem Test sollen insgesamt <xsl:value-of select="$fragen_gesamt"/> Multiple Choice-Fragen aus dem Bereich »<xsl:value-of select="@title"/>« innerhalb von 
            <xsl:call-template name="seconds-to-time">
                <xsl:with-param name="seconds" select="@time"/>
            </xsl:call-template>
            beantwortet werden.
            Es wird empfohlen, zuerst den LiGo-Kurs zum entsprechenden Bereich zu absolvieren, bevor Sie Ihr Wissen testen.
            Sobald Sie auf den untenstehenden Button klicken, werden die Übungen angezeigt und der Countdown gestartet.
            <!-- Generieren des Buttons zum Starten des Tests (und des Countdowns mit abnehmendem Fortschrittsbalken) -->
            <div class="exercise_buttons">
                <button id="start_button">Test starten</button>
            </div>
        </div>
        <!-- Generieren des (Bootstrap-)Fortschrittsbalkens, mit dem die verbleibende Zeit angezeigt wird -->
        <div class="progress">
            <!-- Angeben des minimalen Zeitwerts (-> 0 Sekunden) sowie des aktuellen und maximalen Zeitwerts (-> Sekunden-Wert aus dem @time-Attribut des aktuellen <exerciseList>-Elements -->
            <!-- Hinzufügen des max_time-Attributs, mit dem eine grüne Farbe der Leiste festgelegt wird -> Wird später mittels JavaScript gegen mid_time für blauen und min_time für roten Farbwechsel ausgetauscht (-> Siehe tests.js-Datei im assets -> js -> uebungen-Ordner) -->
            <div id="progress-bar" class="progress-bar max_time" role="progressbar" aria-valuemin="0">
                <xsl:attribute name="aria-valuenow"><xsl:value-of select="@time"/></xsl:attribute>
                <xsl:attribute name="aria-valuemax"><xsl:value-of select="@time"/></xsl:attribute>
                <!-- Angeben der verbleibenden Zeit im Fortschrittsbalken -->
                <span id="time_text">
                    <xsl:call-template name="seconds-to-time">
                        <xsl:with-param name="seconds" select="@time"/>
                    </xsl:call-template>
                    verbleibend.
                </span>
            </div>
        </div>
        <!-- Generieren des Timeout-Pop-Ups, das zunächst auf der Website verborgen bleibt -> Es erscheint automatisch, sobald die vorgegebene Zeit abgelaufen ist (-> Siehe tests.js-Datei) -->
        <div id="timeout_pop_up">
            <div id="timeout_content">
                <h3>Zeit abgelaufen</h3>
                <p id="timout_text">Ihre Bearbeitungszeit ist vorbei.</p>
                <div class="exercise_buttons">
                    <button id="timeout_button">Ergebnisse auswerten</button>
                </div>
            </div>
        </div>
        <!-- Generieren eines <div>-Elements mit den Übungen und weiteren Buttons, das zunächst auf der Website verborgen bleibt -> Der Inhalt wird erst angezeigt, sobald der Nutzer auf den "Test starten"-Button klickt (-> Siehe tests.js-Datei) -->
        <div id="exercises">
            <!-- Anwenden der Templates für die einzelnen Übungen/MC-Fragen -->
            <xsl:apply-templates/>
            <!-- Generieren der Buttons zum Zurücksetzen des Tests und zum Auswerten der Ergebnisse -->
            <div class="exercise_buttons">
                <button id="solution_button">Ergebnisse auswerten</button>
                <button id="reset_button">Test zurücksetzen</button>
            </div>
            <!-- Generieren des Warnung-Pop-Ups, das zunächst auf der Website verborgen bleibt -> Es erscheint, falls der Nutzer auf den "Ergebnisse auswerten"-Button klickt, bevor er eine Antwort bei jeder Frage ausgewählt hat (-> Siehe tests.js-Datei) -->
            <div id="warning_pop_up">
                <div id="warning_content">
                    <h3>Hinweis</h3>
                    <p id="warning_text"></p>
                    <div class="exercise_buttons">
                        <button id="return_button">Weiter bearbeiten</button>
                        <button id="resume_button">Trotzdem auswerten</button>
                    </div>
                </div>
            </div>
            <!-- Generieren eines Elements, in das später das Feedback (bezüglich der Anzahl an korrekten Antworten) mittels JavaScript eingefügt wird (-> Siehe tests.js-Datei) -->
            <div id="feedback" class="feedback"></div>
        </div>
    </xsl:template>
    
    <!-- EINZELNE ÜBUNGEN -->
    <xsl:template match="exercise">
        <!-- Speichern der Nummer und des Labels der Frage in je einer Variable -->
        <xsl:variable name="frage_nr"><xsl:number count="exercise" level="any"/></xsl:variable>
        <xsl:variable name="frage_label" select="@locallabel"/>
        <!-- Zugreifen auf die eigens für diesen Zweck generierte uebungen.xml-Datei (-> Siehe uebungen.xsl-Datei) und Iterieren über sämtliche Übungen darin  -->
        <xsl:for-each select="document('../xml_daten/selbstgenerierte/uebungen.xml')//div[tokenize(@class,'\s')='exercise']">
            <!-- Testen, ob die ID der aktuellen Übung dem Label der gesuchten Frage für diesen Test entspricht -> Falls ja: -->
            <xsl:if test="@id = $frage_label">
                <h3>Frage <xsl:value-of select="$frage_nr"/> von <xsl:value-of select="$fragen_gesamt"/></h3>
                <!-- Einfügen der Übung mitsamt all ihrer Tags, Attribute etc. -->
                <xsl:sequence select="."/>
                <!-- Einfügen einer Trennlinie am Ende der Übung -->
                <hr class="separation_line"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <!-- ZEIT-KALKULATION -->
    <!-- Template zur Umrechnung von Sekunden in Minuten -->
    <xsl:template name="seconds-to-time">
        <xsl:param name="seconds"/>
        <!-- Umrechnen von Sekunden in Minuten und Speichern in einer Variable -->
        <xsl:variable name="m" select="floor($seconds div 60) mod 60"/>
        <xsl:variable name="s" select="$seconds mod 60"/>
        <!-- Ausgaben der Zeit in Minuten und Sekunden in Textform -->
        <xsl:value-of select="$m"/><xsl:text> Min. </xsl:text><xsl:value-of select="$s"/><xsl:text> Sek.</xsl:text>
    </xsl:template>

</xsl:stylesheet>