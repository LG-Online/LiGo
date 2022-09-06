<!-- ANWENDUNG UND ZIEL -->
<!-- Anwenden des Stylesheets über die -it:main-Funktion des Saxon-XSLT-Prozessors -> Anwenden/Datenzugriff auf mehrere XML-Dateien über das main-Template (und nicht nur auf eine bestimmte Datei) -->
<!-- Generieren der uebungen.xml-Datei (im xml_daten -> selbstgenerierte-Ordner), in der sämtliche Übungen aus allen Lerneinheiten gesammelt werden -->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon" exclude-result-prefixes="saxon">
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- VARIABLE UND DATENZUGRIFF -->
    <!-- Deklarieren einer Variable mit dem Wert 0 -> Wird später inkrementell erhöht und dazu genutzt, sämtliche Übungen bzw. deren einzelne Elemente durchzunummerieren und ihnen somit eine eindeutige ID zuzuweisen -->
    <xsl:variable name="ex_nr" select="0" saxon:assignable="yes"/>
    
    <!-- Zugreifen auf die benötigten Daten/Dateien -->
    <xsl:template name="xsl:initial-template">
        <div class="exercises">
            <!-- Iterieren über sämtliche .xml-Dateien im xml_daten -> wissensbereiche-Ordner mithilfe der collection()-Funktion -->
            <xsl:for-each select="collection('../xml_daten/wissensbereiche/?select=*.xml;recurse=yes')">
                <!-- Anwenden der Templates für sämtliche Übungen in der jeweiligen Datei -->
                <xsl:apply-templates select=".//exercise"/>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    <xsl:template match="exercise">
        <!-- Erhöhen der ex_nr-Variable für jede neue Übung um die Zahl 1 -> Dadurch: Durchnummerieren der Übungen bzw. ihrer Elemente für eindeutige IDs bei allen Übungen -->
        <saxon:assign name="ex_nr" select="$ex_nr + 1"/>
        <xsl:choose>
            
            <!-- MULTIPLE CHOICE- UND ALTERNATIVE TEXTBEISPIELE-ÜBUNG -->
            <xsl:when test="@topics='multiplechoice' or @topics='alternativen' or @type='alternativen'">
                <div class="exercise mc">
                    <!-- Speichern des Wissensbereichs, aus dem die aktuelle Übung stammt, im resource-Attribut -->
                    <xsl:attribute name="resource">
                        <!-- Verwenden eines regex-Ausdrucks, um den gewünschten String (= Wissensbereich) aus der Dokument-URI (= Dateipfad) zu erhalten -->
                        <xsl:analyze-string select="base-uri(.)" regex=".+wissensbereiche/(.+?)/.+\.xml">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(1)"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:attribute>
                    <!-- Speichern des Labels (= Angabe zu Übung + Titel der Lerneinheit), im id-Attribut -->
                    <xsl:attribute name="id">
                        <xsl:value-of select="@label"/>
                    </xsl:attribute>
                    <!-- Einfügen der Fragestellung und des Textbeispiels (-> Templates für diese Elemente: siehe weiter unten, nach den Übungen) -->
                    <xsl:apply-templates select="./task[@type='fragestellung']"/>
                    <xsl:apply-templates select="./task[@type='textbeispiel']"/>
                    <!-- Generieren des Pools an auswählbaren MC-Optionen -->
                    <fieldset>
                        <xsl:attribute name="id">option_pool_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                        <!-- Iterieren über alle MC-Optionen/-Alternativen -> Generieren eines Radio-Buttons und eines Labels (= Textinhalt der Alternative) für jede Option -->
                        <xsl:for-each select="./task[@type='alternative']">
                            <div class="option">
                                <input type="radio">
                                    <xsl:attribute name="name">set_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                    <xsl:attribute name="id">option_<xsl:value-of select="$ex_nr"/>_<xsl:value-of select="@target"/></xsl:attribute>
                                    <xsl:attribute name="value"><xsl:value-of select="../solution[@label = current()/@target]/@true"/></xsl:attribute>
                                </input>
                                <label>
                                    <xsl:attribute name="for">option_<xsl:value-of select="$ex_nr"/>_<xsl:value-of select="@target"/></xsl:attribute>
                                    <xsl:apply-templates/>
                                </label>
                            </div>
                        </xsl:for-each>
                    </fieldset>
                    <!-- Generieren eines Elements, in dem das Feedback und die Lösung später mittels JavaScript eingefügt wird (-> Siehe tests.js-Datei im assets -> js-Ordner) -->
                    <div class="solution">
                        <xsl:attribute name="id">solution_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                        <div class="feedback">
                            <xsl:attribute name="id">feedback_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                        </div>
                        <div class="answer">
                            <xsl:attribute name="id">answer_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                        </div>
                    </div>
                    <!-- Speichern aller Antworten/Lösungen in einem Element -->
                    <div class="answer_pool">
                        <xsl:attribute name="id">answer_pool_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                        <xsl:for-each select="./solution">
                            <span>
                                <!-- Ausstatten jeder Anwort mit einer Klasse -> Diese wird bei der Auswertung mit der ID der ausgewählten Antwort abgeglichen, um so diejenige Lösung anzuzeigen, die zur ausgewählten Option passt (-> Siehe tests.js-Datei) -->
                                <xsl:attribute name="class">option_<xsl:value-of select="$ex_nr"/>_<xsl:value-of select="@label"/></xsl:attribute>
                                <xsl:apply-templates/>
                            </span>
                        </xsl:for-each>
                    </div>
                </div>
            </xsl:when>
            
            <!-- TEXTEINGABE-ÜBUNG -->
            <xsl:when test="@topics='musterloesung'">
                <div class="exercise text">
                    <xsl:attribute name="resource">
                        <xsl:analyze-string select="base-uri(.)" regex=".+wissensbereiche/(.+?)/.+\.xml">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(1)"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:attribute>
                    <xsl:attribute name="id">
                        <xsl:value-of select="@label"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="./task[@type='fragestellung']"/>
                    <xsl:apply-templates select="./task[@type='textbeispiel']"/>
                    <!-- Generieren eines Textfelds, das von dem/der Übenden mit einem eigenen Text befüllt werden kann -->
                    <div class="input">
                        <div class="pretext">Ihre Formulierung:</div>
                        <textarea class="input_field">
                            <xsl:attribute name="id">input_field_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                        </textarea>
                    </div>
                    <div class="solution">
                        <xsl:attribute name="id">solution_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                        <div class="feedback">
                            <xsl:attribute name="id">feedback_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                            Musterlösung:
                        </div>
                        <div class="answer">
                            <xsl:attribute name="id">answer_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                            <xsl:apply-templates select="./task[@type='userinput']"/>
                        </div>
                    </div>
                </div>
            </xsl:when>
            
            <!-- MARKIEREN-ÜBUNG -->
            <xsl:when test="@topics='markieren'">
                <div class="exercise marker">
                    <xsl:attribute name="resource">
                        <xsl:analyze-string select="base-uri(.)" regex=".+wissensbereiche/(.+?)/.+\.xml">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(1)"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:attribute>
                    <xsl:attribute name="id">
                        <xsl:value-of select="@label"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="./task[@type='fragestellung']"/>
                    <xsl:apply-templates select="./task[@type='selection']"/>                          
                    <div class="solution">
                        <xsl:attribute name="id">solution_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                        <div class="feedback">
                            <xsl:attribute name="id">feedback_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                            <!-- Testen, ob ein Antwort-/Lösungstext im XML-Dokument vorhanden ist -> Falls ja: 'Erläuterung:' einfügen -->
                            <xsl:if test=".//LMMLtext[@type='answerText']">Erläuterung:</xsl:if>
                        </div>
                        <div class="answer">
                            <xsl:attribute name="id">answer_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                            <xsl:apply-templates select=".//LMMLtext[@type='answerText']"/>
                        </div>
                    </div>
                </div>
            </xsl:when>
            
            <!-- LÜCKENTEXT-ÜBUNG -->
            <xsl:when test="@topics='luecken'">
                <div class="exercise gaps">
                    <xsl:attribute name="resource">
                        <xsl:analyze-string select="base-uri(.)" regex=".+wissensbereiche/(.+?)/.+\.xml">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(1)"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:attribute>
                    <xsl:attribute name="id">
                        <xsl:value-of select="@label"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="./task[@type='fragestellung']"/>
                    <xsl:for-each select=".//task[@type='lueckentext']/quotation[@type='luecken']/LMMLtext">
                        <xsl:if test="./text()">
                            <div class="gap_text">
                                <xsl:attribute name="id">gap_text_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                <xsl:apply-templates/>
                            </div>
                        </xsl:if>
                    </xsl:for-each>
                    <!-- Generieren eines Elements, in dem jetzt die Antwort/Lösung aus dem XML-Dokument eingefügt wird und später das Feedback mittels JavaScript ergänzt werden kann -->
                    <div class="solution">
                        <xsl:attribute name="id">solution_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                        <div class="feedback">
                            <xsl:attribute name="id">feedback_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                        </div>
                        <div class="answer">
                            <xsl:attribute name="id">answer_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                            <xsl:apply-templates select=".//task[@type='lueckenerlaeuterung']"/>
                        </div>
                    </div>
                </div>
            </xsl:when>
            
            <!-- DRAG AND DROP-ÜBUNG -->
            <xsl:otherwise>
                <div class="exercise dnd">
                    <xsl:attribute name="resource">
                        <xsl:analyze-string select="base-uri(.)" regex=".+wissensbereiche/(.+?)/.+\.xml">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(1)"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:attribute>
                    <xsl:attribute name="id">
                        <xsl:value-of select="@label"/>
                    </xsl:attribute>
                    <!-- Einfügen des Warnhinweises, dass DND aktuell nur auf PCs/Laptops funktioniert -->
                    <div class="dnd_info">
                        <div class="pretext">Hinweis:</div>
                        Drag and Drop wird bislang nur auf PCs/Laptops beziehungsweise auf Geräten unterstützt, die eine Maus oder ein Trackpad nutzen.
                        Auf Touchscreen-Geräten wie Smartphones und Tablets können Sie diese Übung daher momentan noch nicht durchführen.
                    </div>
                    <xsl:apply-templates select="./task[@type='fragestellung']"/>
                    <xsl:apply-templates select="./task[@type='textbeispiel']"/>
                    <!-- Generieren der Drop-Areas, in denen die DND-Items platziert werden sollen -->
                    <div class="drop_areas">
                        <xsl:attribute name="id">drop_areas_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                        <!-- Iterieren über alle Spalten der DND-Tabelle im XML-Dokument -> Für jede Spalte: -->
                        <xsl:for-each select=".//LMMLtext[matches(@type, 'column')]">
                            <div class="drop_wrapper">
                                <!-- Einfügen der Drop-Area-Überschrift -->
                                <div class="drop_head"><xsl:apply-templates/></div>
                                <!-- Einfügen einer Trennlinie -->
                                <hr class="drop_separation"/>
                                <!-- Einfügen der eigentlichen Drop-Area, in der die DND-Items platziert werden können -->
                                <!-- Ausstatten der Drop-Area mit einer ID und Attributen, welche die DND-Funktion ermöglichen -->
                                <div class="drop_area" ondrop="drop(event, this)" ondragover="allowDrop(event)">
                                    <xsl:attribute name="id">drop_area_<xsl:value-of select="$ex_nr"/>_<xsl:number count="LMMLtext[matches(@type, 'column')]"/></xsl:attribute>
                                </div>
                            </div>
                        </xsl:for-each>
                    </div>
                    <div class="dnd_items">
                        <xsl:attribute name="id">dnd_items_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                        <!-- Iterieren über alle <LMMLtext type='input'>-Elemente (= DND-Items) -->
                        <xsl:for-each select=".//LMMLtext[matches(@type, 'input')]">
                            <!-- Sicherstellen, dass das Element nicht leer ist -->
                            <xsl:if test=". != ''">
                                <!-- Austatten des Items mit einer ID und Attributen, welche die DND-Funktion ermöglichen -->
                                <div draggable="true" ondragstart="drag(event)">
                                    <xsl:attribute name="id">dnd_item_<xsl:value-of select="$ex_nr"/>_<xsl:number count="LMMLtext[matches(@type, 'input')]"/></xsl:attribute>
                                    <!-- Austatten des Items mit einer Klasse -> Diese wird bei der Auswertung mit der ID der Drop-Area abgeglichen, in der das Item platziert wurde, um so festzustellen, ob es korrekt zugeordnet wurde -->
                                    <xsl:attribute name="class">drop_area_<xsl:value-of select="$ex_nr"/>_<xsl:value-of select="@title"/></xsl:attribute>
                                    <xsl:apply-templates/>
                                </div>
                            </xsl:if>
                        </xsl:for-each>
                    </div>
                    <!-- Generieren eines Elements, in dem später das Feedback mittels JavaScript eingefügt werden kann -->
                    <div class="solution">
                        <xsl:attribute name="id">solution_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                        <div class="feedback">
                            <xsl:attribute name="id">feedback_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                        </div>
                    </div>
                </div>
            </xsl:otherwise>
            
        </xsl:choose>
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
        <!-- Hier müssen <span>-Elemente zur Umschließung der Texteinheiten verwendet werden (statt Blockelemente wie <p> oder <div>, die für diesen Zweck eigentlich vorgesehen sind) -->
        <!-- Grund: <p> und <div> sind nicht als Kindelemente von <label> bei den MC-Optionen erlaubt (-> Ungültiges HTML) -->
        <span class="text">
            <xsl:apply-templates/>
        </span>
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
        <!-- Hier müssen <span>-Elemente zur Umschließung der Texteinheiten verwendet werden (statt Blockelemente wie <p> oder <div>, die für diesen Zweck eigentlich vorgesehen sind) -->
        <!-- Grund: <p> und <div> sind nicht als Kindelemente von <label> bei den MC-Optionen erlaubt (-> Ungültiges HTML) -->
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
                <xsl:apply-templates select=".//referencesLink[@type='exercises']"/>
                <xsl:apply-templates select=".//referencesLink[@type='illustrates']"/>
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
                <!-- Testen, ob der Text ein Teil der Markieren-Übung ist -> Falls ja: Textabschnitte dürfen nicht mit <div>-Elementen umschlossen werden, weil das Markieren sonst nicht korrekt funktioniert -->
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
    
    <!-- LINKS/POP-OVER -->
    <!-- Darstellen ohne Links bzw. als gewöhnlicher Text -> Links/Pop-Over werden in diesem Kontext nicht benötigt -->
    <xsl:template match="referencesLink[@target and not(@type='illustrates') and not(@type='exercises') and not(@type='book')]">
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>