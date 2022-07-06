<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon" exclude-result-prefixes="saxon">
    <xsl:output method="html" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="fragen_gesamt" select="count(.//exercise)"/>    
    
    <xsl:template match="/">---
        title: "Test - <xsl:value-of select="//exerciselist[1]/@title"/>"
        layout: default
        type: test
        ---
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="exerciselist">
        <h1 id="top">Test - <xsl:value-of select="@title"/></h1>
        <div class="introduction">
            Bei diesem Test sollen insgesamt <xsl:value-of select="$fragen_gesamt"/> Multiple Choice-Fragen aus dem Bereich »<xsl:value-of select="@title"/>« innerhalb von 
            <xsl:call-template name="seconds-to-time">
                <xsl:with-param name="seconds" select="@time"/>
            </xsl:call-template>
            beantwortet werden.
            Es wird empfohlen, zuerst den LiGo-Kurs zum entsprechenden Bereich zu absolvieren, bevor Sie Ihr Wissen testen.
            Sobald Sie auf den untenstehenden Button klicken, werden die Übungen angezeigt und der Countdown gestartet.
            <div class="exercise_buttons">
                <button id="start_button">Test starten</button>
            </div>
        </div>
        <div class="progress">
            <div id="progress-bar" class="progress-bar max_time" role="progressbar" aria-valuemin="0">
                <xsl:attribute name="aria-valuenow"><xsl:value-of select="@time"/></xsl:attribute>
                <xsl:attribute name="aria-valuemax"><xsl:value-of select="@time"/></xsl:attribute>
                <span id="time_text">
                    <xsl:call-template name="seconds-to-time">
                        <xsl:with-param name="seconds" select="@time"/>
                    </xsl:call-template>
                    verbleibend.
                </span>
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
            <xsl:apply-templates/>
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
    </xsl:template>
    
    <xsl:template match="exercise">
        <xsl:variable name="frage_nr"><xsl:number count="exercise" level="any"/></xsl:variable>
        <xsl:variable name="locallabel" select="@locallabel"/>
        <xsl:for-each select="document('../xml_selbstgenerierte/uebungen.xml')//div[tokenize(@class,'\s')='exercise']">
            <xsl:if test="@id = $locallabel">
                <h3>Frage <xsl:value-of select="$frage_nr"/> von <xsl:value-of select="$fragen_gesamt"/></h3>
                <xsl:sequence select="."/>
                <hr class="separation_line"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="seconds-to-time">
        <xsl:param name="seconds"/>
        <xsl:variable name="m" select="floor($seconds div 60) mod 60"/>
        <xsl:variable name="s" select="$seconds mod 60"/>
        <xsl:value-of select="$m"/><xsl:text> Min. </xsl:text><xsl:value-of select="$s"/><xsl:text> Sek.</xsl:text>
    </xsl:template>
    

</xsl:stylesheet>