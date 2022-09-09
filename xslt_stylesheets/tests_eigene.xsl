<!-- ANWENDUNG UND ZIEL -->
<!-- Anwenden des Stylesheets auf die uebungen.xml-Datei (im xml_daten -> selbstgenerierte-Ordner), in der sämtliche Übungen aus allen Wissensbereichen gesammelt wurden -->
<!-- Generieren der [test].html-Dateien (im _pages -> tests -> selbstgenerierte-Ordner) mit dem Test zum jeweiligen Wissensbereich -->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon" exclude-result-prefixes="saxon">
    <xsl:output method="html" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- MODUS UND VARIABLE -->
    <!-- Falls nichts anderes durch ein Template vorgegeben wird: Inhalte vollständig mit Tags, Attributen etc. aus uebungen.xml kopieren -->
    <xsl:mode on-no-match="shallow-copy"/>
    <!-- Deklarieren einer Variable mit dem Wert 1 -> Wird später inkrementell erhöht und zum Durchnummerieren der Übungen/Fragen genutzt -->
    <xsl:variable name="frage_nr" select="1" saxon:assignable="yes"/>
    
    <!-- GESAMTER TEST -->
    <xsl:template match="div[@class='exercises']">
        <!-- Gruppieren der <div>-Kindelemente (= einzelne Übungen) nach ihrem resource-Attribut (-> Enthält den Wissensbereich, aus dem die jeweilige Übung stammt) -->
        <xsl:for-each-group select="./div" group-by="@resource">
            <!-- Generieren einer eigenen HTML-Datei für jede Gruppe bzw. jeden Wissensbereich -->
            <!-- YAML FRONT MATTER -->
            <!-- Festlegen des Seitentitels, der dann im Browser-Tab angezeigt wird (-> Titel muss manuell/individuell für jeden Test ergänzt werden) -->
            <!-- Festlegen des Seitenlayouts, das in der default.html-Datei (im _layouts-Ordner) vorgegeben wird -->
            <!-- Festlegen des Seitentyps, der für die Zuordnung der benötigten JavaScript-Skripte in der scripts.html-Datei (im _includes-Ordner) genutzt wird -->
            <xsl:result-document href="./selbstgenerierte/{@resource}.html">---
                title: "Test – [Wissensbereich]"
                layout: default
                type: test
                ---
                <div class="test">
                    <!-- Generieren der Überschrift (-> Überschrift muss manuell/individuell für jeden Test ergänzt werden) -->
                    <!-- Austatten der Überschrift mit einer ID, damit sie als Link-Anker dienen kann -> Ermöglicht den Sprung per Button-Klick zurück zur Überschrift/zum Seitenanfang -->
                    <h1 id="top">Test – [Wissensbereich]</h1>
                    <!-- Generieren des Einleitungstexts mit Infos zu Fragenanzahl, Thema und Zeitvorgabe (-> Infos müssen manuell/individuell für jeden Test nachgetragen werden) -->
                    <div class="introduction">
                        Bei diesem Test sollen insgesamt [Anzahl] Multiple Choice-Fragen aus dem Bereich »[Wissensbereich]« innerhalb von [Anzahl] Min. [Anzahl] Sek. beantwortet werden.
                        Es wird empfohlen, zuerst den LiGo-Kurs zum entsprechenden Bereich zu absolvieren, bevor Sie Ihr Wissen testen.
                        Sobald Sie auf den untenstehenden Button klicken, werden die Übungen angezeigt und der Countdown gestartet.
                        <!-- Generieren des Buttons zum Starten des Tests (und des Countdowns mit abnehmendem Fortschrittsbalken) -->
                        <div class="exercise_buttons">
                            <button id="start_button">Test starten</button>
                        </div>
                    </div>
                    <!-- Generieren des (Bootstrap-)Fortschrittsbalkens, mit dem die verbleibende Zeit angezeigt wird -->
                    <div class="progress">
                        <!-- Angeben des minimalen Zeitwerts (-> 0 Sekunden) sowie des aktuellen und maximalen Zeitwerts (-> Sekunden-Wert muss manuell/individuell für jeden Test nachgetragen werden) -->
                        <!-- Hinzufügen der max_time-Klasse, mit der eine grüne Farbe des Balkens festgelegt wird (-> Siehe tests.scss-Datei im _sass-Ordner)
                             -> Wird später mittels JavaScript gegen mid_time für blauen und min_time für roten Farbwechsel ausgetauscht (-> Siehe tests.js-Datei im assets -> js-Ordner) -->
                        <div id="progress-bar" class="progress-bar max_time" role="progressbar" aria-valuemin="0" aria-valuenow="[Anzahl]" aria-valuemax="[Anzahl]">
                            <!-- Angeben der verbleibenden Zeit im Fortschrittsbalken (-> Minuten/Sekunden-Wert muss manuell/individuell für jeden Test nachgetragen werden) -->
                            <span id="time_text">[Anzahl] Min. [Anzahl] Sek. verbleibend.</span>
                        </div>
                    </div>
                    <!-- Generieren des Timeout-Pop-Ups, das zunächst auf der Webseite verborgen bleibt -> Es erscheint automatisch, sobald die vorgegebene Zeit abgelaufen ist (-> Siehe tests.js-Datei) -->
                    <div id="timeout_pop_up">
                        <div id="timeout_content">
                            <h3>Zeit abgelaufen</h3>
                            <p id="timeout_text">Ihre Bearbeitungszeit ist vorbei.</p>
                            <div class="exercise_buttons">
                                <button id="timeout_button">Ergebnisse auswerten</button>
                            </div>
                        </div>
                    </div>
                    <!-- Generieren eines <div>-Elements mit den Übungen und weiteren Buttons, das zunächst auf der Webseite verborgen bleibt -> Der Inhalt wird erst nach einem Klick auf den 'Test starten'-Button angezeigt (-> Siehe tests.js-Datei) -->
                    <div id="exercises">
                        <!-- Itieren über die gruppierten Übungen -->
                        <xsl:for-each select="current-group()">
                            <!-- Testen, ob es sich bei der aktuellen Übung um eine Multiple Choice-Übung handelt -> Falls ja: -->
                            <xsl:if test="current()[tokenize(@class,'\s')='mc']">
                                <!-- Generieren der Überschrift mit Fragenummer und Gesamtanzahl der Fragen -->
                                <h3>Frage <xsl:value-of select="$frage_nr"/> von <xsl:value-of select="count(current-group()[tokenize(@class,'\s')='mc'])"/></h3>
                                <!-- Einfügen der aktuellen Frage/Übung -->
                                <xsl:copy-of select="current()"/>
                                <!-- Einfügen einer Trennlinie am Ende der Frage/Übung -->
                                <hr class="separation_line"/>
                                <!-- Inkrementelles Erhöhen der Variable um 1 bei jeder Frage/Übung zur korrekten Durchnummerierung -->
                                <saxon:assign name="frage_nr" select="$frage_nr + 1"/>
                            </xsl:if>
                        </xsl:for-each>
                        <!-- Generieren der Buttons zum Zurücksetzen des Tests und zum Auswerten der Ergebnisse -->
                        <div class="exercise_buttons">
                            <button id="solution_button">Ergebnisse auswerten</button>
                            <button id="reset_button">Test zurücksetzen</button>
                        </div>
                        <!-- Generieren des Warnung-Pop-Ups, das zunächst auf der Webseite verborgen bleibt -> Es nur erscheint nach einem Klick auf den 'Ergebnisse auswerten'-Button, falls noch nicht für jeder Frage eine Antwort ausgewählt wurde (-> Siehe tests.js-Datei) -->
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
                </div>
            </xsl:result-document>
            <!-- Zurücksetzen der Variable auf den Wert 1, damit bei der Nummerierung der Fragen aus der nächsten Gruppe wieder korrekt mit 1 begonnen wird -->
            <saxon:assign name="frage_nr" select="1"/>
        </xsl:for-each-group>
    </xsl:template>

</xsl:stylesheet>