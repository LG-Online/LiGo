<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon" exclude-result-prefixes="saxon">
    <xsl:output method="html" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:variable name="frage_nr" select="1" saxon:assignable="yes"/>
    
    <xsl:template match="div[@class='exercises']">
        <xsl:for-each-group select=".//div[tokenize(@class,'\s')='exercise']" group-by="@resource">
            <xsl:result-document href="./selbstgenerierte/{@resource}.html">---
                title: "Test - ?"
                layout: default
                type: test
                ---
                <div class="test">
                    <h1 id="top">Test - ?</h1>
                    <div class="introduction">
                        Bei diesem Test sollen insgesamt ? Multiple Choice-Fragen aus dem Bereich »?« innerhalb von ? Min. ? Sek. beantwortet werden.
                        Es wird empfohlen, zuerst den LiGo-Kurs zum entsprechenden Bereich zu absolvieren, bevor Sie Ihr Wissen testen.
                        Sobald Sie auf den untenstehenden Button klicken, werden die Übungen angezeigt und der Countdown gestartet.
                        <div class="exercise_buttons">
                            <button id="start_button">Test starten</button>
                        </div>
                    </div>
                    <div class="progress">
                        <div id="progress-bar" class="progress-bar max_time" role="progressbar" aria-valuemin="0" aria-valuenow="0" aria-valuemax="0">
                            <span id="time_text">? Min. ? Sek. verbleibend.</span>
                        </div>
                    </div>
                    <div id="timeout_pop_up">
                        <div id="timeout_content">
                            <h3>Zeit abgelaufen</h3>
                            <p id="timout_text">Ihre Bearbeitungszeit ist vorbei.</p>
                            <div class="exercise_buttons">
                                <button id="timeout_button">Ergebnisse auswerten</button>
                            </div>
                        </div>
                    </div>
                    <div id="exercises">
                        <xsl:for-each select="current-group()">
                            <xsl:if test="current()[tokenize(@class,'\s')='mc']">
                                <h3>Frage <xsl:value-of select="$frage_nr"/> von <xsl:value-of select="count(current-group()[tokenize(@class,'\s')='mc'])"/></h3>
                                <xsl:copy-of select="current()"/>
                                <hr class="separation_line"/>
                                <saxon:assign name="frage_nr" select="$frage_nr + 1"/>
                            </xsl:if>
                        </xsl:for-each>
                        <div class="exercise_buttons">
                            <button id="solution_button">Ergebnisse auswerten</button>
                            <button id="reset_button">Test zurücksetzen</button>
                        </div>
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
                        <div id="feedback" class="feedback"></div>
                    </div>
                </div>
            </xsl:result-document>
            <saxon:assign name="frage_nr" select="1"/>
        </xsl:for-each-group>
    </xsl:template>

</xsl:stylesheet>