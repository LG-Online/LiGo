<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:variable name="path" select="document-uri(/)"/>
    <xsl:key name="examples_exercises" match="section[@type='example']|exercise" use="@label"/>
    
    <xsl:template match="/">---
        title: "<xsl:value-of select=".//section[@type='course']/@title"/>"
        layout: default
        type: lerneinheit
        ---
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="section[@type='course']">
        <xsl:variable name="label" select="./@label"/>
        
        <!-- Brotkrumen-Navigationsleiste -->
        <div class="breadcrumb_nav">
            <a class="breadcrumb_link">
                <xsl:attribute name="href">
                    <xsl:text>{{ '_pages/verzeichnisse/</xsl:text>
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
            <i class="bi bi-caret-right"></i>
            <xsl:for-each select="document('../xml_sonstige/menue.xml')//section[@label = $label]/ancestor::section[@type='course']">
                <a class="breadcrumb_link">
                    <xsl:attribute name="href">
                        <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                        <xsl:value-of select="./ancestor-or-self::section[@discipline]/@discipline"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="./@uri"/>
                        <xsl:text>' | relative_url }}</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of select="@title"/>
                </a>
                <i class="bi bi-caret-right"></i>
            </xsl:for-each>
            <xsl:value-of select="@title"/>
        </div>
        <hr class="separation_line"/>
        
        <!-- Überschrift und 'Alle anzeigen/verbergen'-Button -->
        <h1 id="top"><xsl:value-of select="@title"/></h1>
        <div class="content">
            <xsl:if test=".//referencesLink[@type='illustrates' or @type='exercises'] or .//externalLink[matches(@uri, '.swf')]">
                <button class="expand-collapse-button">Alle Beispiele/Übungen anzeigen/verbergen</button>
            </xsl:if>
            
            <!-- Hauptinhalt -->
            <xsl:apply-templates/>
            
            <!-- Copyright/Autoren und Änderungsdatum -->
            <div class="content_data">
                <span class="content_author"><xsl:value-of select="./@author"/>&#xA0;/&#160;</span><span class="content_date">Letzte inhaltiche Änderung am:&#160;<xsl:value-of select="./@creationTime"/></span>
            </div>
            
            <!-- Kurseinheiten-Navigationsleiste -->
            <hr class="separation_line"/>
            <xsl:choose>
                
                <!-- Reguläre Lerneinheiten -->
                <xsl:when test="not(document('../xml_sonstige/menue.xml')//section[@label = $label]/parent::section[@label='ligostart'])">
                    <div class="course_items">
                        <div class="previous_course">
                            <a class="previous_link">
                                <xsl:attribute name="href">
                                    <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                    <xsl:value-of select="document('../xml_sonstige/menue.xml')//section[@label = $label]/ancestor-or-self::section[@discipline]/@discipline"/>
                                    <xsl:text>/</xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="count(document('../xml_sonstige/menue.xml')//section[@label = $label]/preceding-sibling::section) = 0">
                                            <xsl:value-of select="document('../xml_sonstige/menue.xml')//section[@label = $label]/parent::section[1]/@uri"/> 
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="document('../xml_sonstige/menue.xml')//section[@label = $label]/preceding::section[1]/@uri"/> 
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
                        <xsl:for-each select="document('../xml_sonstige/menue.xml')//section[@label = $label]/parent::section/child::section">
                            <div class="course_item">
                                <xsl:choose>
                                    <xsl:when test="./@label = $label">
                                        <xsl:value-of select="./@title"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <a class="course_link">
                                            <xsl:attribute name="href">
                                                <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                                <xsl:value-of select="./ancestor-or-self::section[@discipline]/@discipline"/>
                                                <xsl:text>/</xsl:text>
                                                <xsl:value-of select="./@uri"/>
                                                <xsl:text>' | relative_url }}</xsl:text>
                                            </xsl:attribute>
                                            <xsl:value-of select="./@title"/>
                                        </a>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </div>
                            <div class="course_separator">
                                |
                            </div>
                        </xsl:for-each>
                        <div class="next_course">
                            <a class="next_link">
                                <xsl:choose>
                                    <!-- Übergang zur ersten Lerneinheit in einem neuen Wissensbereich, falls der aktuelle Wissensbereich zu Ende ist (z.B. von Prosa zu Drama) -->
                                    <xsl:when test="(not(document('../xml_sonstige/menue.xml')//section[@label = $label]/child::section)) and (document('../xml_sonstige/menue.xml')//section[@label = $label]/following::section[1][@discipline])">
                                        <xsl:attribute name="href">
                                            <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                            <xsl:value-of select="document('../xml_sonstige/menue.xml')//section[@label = $label]/following::section[1]/@discipline"/>
                                            <xsl:text>/</xsl:text>
                                            <xsl:value-of select="document('../xml_sonstige/menue.xml')//section[@label = $label]/following::section[1]/@uri"/>
                                            <xsl:text>' | relative_url }}</xsl:text>
                                        </xsl:attribute>
                                        Nächste Lerneinheit (Nächster Wissensbereich)
                                    </xsl:when>
                                    <!-- Übergang zur nächsten Lerneinheit im gleichen Kurs -->
                                    <xsl:otherwise>
                                        <xsl:attribute name="href">
                                            <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                            <xsl:value-of select="document('../xml_sonstige/menue.xml')//section[@label = $label]/ancestor-or-self::section[@discipline]/@discipline"/>
                                            <xsl:text>/</xsl:text>
                                            <xsl:choose>
                                                <xsl:when test="document('../xml_sonstige/menue.xml')//section[@label = $label]/child::section">
                                                    <xsl:value-of select="document('../xml_sonstige/menue.xml')//section[@label = $label]/child::section[1]/@uri"/> 
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="document('../xml_sonstige/menue.xml')//section[@label = $label]/following::section[1]/@uri"/> 
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
                
                <!-- Erste Lerneinheit (Hauptseite) eines jeden Kurses -->
                <xsl:when test="document('../xml_sonstige/menue.xml')//section[@label = $label]/parent::section[@label='ligostart']">
                    <xsl:choose>
                        <xsl:when test="document('../xml_sonstige/menue.xml')//section[@label = $label][@discipline != 'prosa']">
                            <div class="course_items">
                                <a class="previous_link">
                                    <xsl:attribute name="href">
                                        <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                        <xsl:value-of select="document('../xml_sonstige/menue.xml')//section[@label = $label]/preceding-sibling::section[1]/@discipline"/>
                                        <xsl:text>/</xsl:text>
                                        <xsl:value-of select="document('../xml_sonstige/menue.xml')//section[@label = $label]/preceding-sibling::section[1]/descendant::section[last()]/@uri"/> 
                                        <xsl:text>' | relative_url }}</xsl:text>
                                    </xsl:attribute>
                                    <i class="bi bi-chevron-double-left"></i><span class="link_text">Vorherige Lerneinheit (Vorheriger Wissensbereich)</span>
                                </a>
                                <div class="course_separator">
                                    |
                                </div>
                                <a class="next_link">
                                    <xsl:attribute name="href">
                                        <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                        <xsl:value-of select="document('../xml_sonstige/menue.xml')//section[@label = $label]/ancestor-or-self::section[@discipline]/@discipline"/>
                                        <xsl:text>/</xsl:text>
                                        <xsl:value-of select="document('../xml_sonstige/menue.xml')//section[@label = $label]/descendant::section[1]/@uri"/> 
                                        <xsl:text>' | relative_url }}</xsl:text>
                                    </xsl:attribute>
                                    <span class="link_text">Nächste Lerneinheit</span><i class="bi bi-chevron-double-right"></i>
                                </a>
                            </div>
                        </xsl:when>
                        <xsl:otherwise>
                            <div class="only_next_item">
                                <a class="next_link">
                                    <xsl:attribute name="href">
                                        <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                        <xsl:value-of select="document('../xml_sonstige/menue.xml')//section[@label = $label]/ancestor-or-self::section[@discipline]/@discipline"/>
                                        <xsl:text>/</xsl:text>
                                        <xsl:value-of select="document('../xml_sonstige/menue.xml')//section[@label = $label]/descendant::section[1]/@uri"/> 
                                        <xsl:text>' | relative_url }}</xsl:text>
                                    </xsl:attribute>
                                    <span class="link_text">Nächste Lerneinheit</span><i class="bi bi-chevron-double-right"></i>
                                </a>
                            </div>
                        </xsl:otherwise>
                    </xsl:choose>  
                </xsl:when>
            </xsl:choose>
            
            <!-- Fußnoten -->
            <xsl:if test=".//annotated">
                <hr class="separation_line"/>
            </xsl:if>
            <xsl:for-each select=".//annotated">
                <div class="footnote">
                    <a class="footnote_link">
                        <xsl:attribute name="id">anchor_<xsl:number level="any"/></xsl:attribute>
                        <xsl:attribute name="href">#footnote_<xsl:number level="any"/></xsl:attribute>
                        <sup class="footnote_number">[<xsl:number level="any"/>]</sup>
                    </a>
                    <xsl:value-of select="."/>
                    <xsl:text> </xsl:text>
                    <a class="back_link">
                        <xsl:attribute name="href">#footnote_<xsl:number level="any"/></xsl:attribute><i class="bi bi-chevron-double-up"></i><span class="link_text">Zurück</span>
                    </a>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    <xsl:template match="referencesLink[@type='illustrates' or @type='exercises']">
        <xsl:variable name="ex_nr">
            <xsl:number level="any" count="referencesLink[@type='exercises']"/>
        </xsl:variable>
        <div class="list-group-item">
            <a class="chevron-link" data-bs-toggle="collapse" aria-expanded="false">
                <xsl:attribute name="href">#<xsl:value-of select="key('examples_exercises', @target)/@label"/></xsl:attribute>
                <xsl:attribute name="aria-controls">#<xsl:value-of select="key('examples_exercises', @target)/@label"/></xsl:attribute>
                <i class="bi bi-chevron-down rotate"></i>
                <span class="list-link"><xsl:value-of select="key('examples_exercises', @target)/@title"/></span>
            </a>
            <div class="list-group collapse">
                <xsl:attribute name="id"><xsl:value-of select="key('examples_exercises', @target)/@label"/></xsl:attribute>
                <xsl:choose>
                    
                    <!-- Beispiel -->
                    <xsl:when test="key('examples_exercises', @target)/@type = 'example'">
                        <xsl:apply-templates select="key('examples_exercises', @target)/*"/>
                    </xsl:when>
                    
                    <!-- Multiple Choice-/Alternative Textbeispiele-Übung -->
                    <xsl:when test="key('examples_exercises', @target)/@topics = 'multiplechoice' or key('examples_exercises', @target)/@topics='alternativen' or key('examples_exercises', @target)/@type='alternativen'">
                        <div class="exercise mc">
                            <xsl:apply-templates select="key('examples_exercises', @target)/task[@type='fragestellung']/LMMLtext[1]"/>
                            <xsl:apply-templates select="key('examples_exercises', @target)/task[@type='textbeispiel']"/>
                            <fieldset>
                                <xsl:attribute name="id">option_pool_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                <xsl:for-each select="key('examples_exercises', @target)/task[@type='alternative']">
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
                                </div>
                                <div class="answer">
                                    <xsl:attribute name="id">answer_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                </div>
                            </div>
                            <div class="answer_pool">
                                <xsl:attribute name="id">answer_pool_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                <xsl:for-each select="key('examples_exercises', @target)/solution">
                                    <span>
                                        <xsl:attribute name="class">option_<xsl:value-of select="$ex_nr"/>_<xsl:value-of select="@label"/></xsl:attribute>
                                        <xsl:apply-templates/>
                                    </span>
                                </xsl:for-each>
                            </div>
                        </div>
                    </xsl:when>
                    
                    <!-- Texteingabe-Übung -->
                    <xsl:when test="key('examples_exercises', @target)/@topics='musterloesung'">
                        <div class="exercise text">
                            <xsl:apply-templates select="key('examples_exercises', @target)/task[@type='fragestellung']/LMMLtext[1]"/>
                            <xsl:apply-templates select="key('examples_exercises', @target)/task[@type='textbeispiel']"/>
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
                    
                    <!-- Markieren-Übung -->
                    <xsl:when test="key('examples_exercises', @target)/@topics='markieren'">
                        <div class="exercise marker">
                            <xsl:apply-templates select="key('examples_exercises', @target)/task[@type='fragestellung']/LMMLtext[1]"/>
                            <xsl:apply-templates select="key('examples_exercises', @target)/task[@type='selection']/quotation"/>
                            <div class="exercise_buttons">
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
                                    <xsl:if test="key('examples_exercises', @target)//LMMLtext[@type='answerText']">Erläuterung:</xsl:if>
                                </div>
                                <div class="answer">
                                    <xsl:attribute name="id">answer_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                    <xsl:apply-templates select="key('examples_exercises', @target)//LMMLtext[@type='answerText']"/>
                                </div>
                            </div>
                        </div>
                    </xsl:when>
                    
                    <!-- Lückentext-Übung -->
                    <xsl:when test="key('examples_exercises', @target)/@topics='luecken'">
                        <div class="exercise gaps">
                            <xsl:apply-templates select="key('examples_exercises', @target)/task[@type='fragestellung']/LMMLtext[1]"/>
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
                    
                    <!-- Drag & Drop-Übung -->
                    <xsl:otherwise>
                        <div class="exercise dnd">
                            <div class="dnd_info">
                                <div class="pretext">Hinweis:</div>
                                Drag and Drop wird bislang nur auf PCs/Laptops beziehungsweise auf Geräten unterstützt, die eine Maus oder ein Trackpad nutzen.
                                Auf Touchscreen-Geräten wie Smartphones und Tablets können Sie diese Übung daher momentan noch nicht durchführen.
                            </div>
                            <xsl:apply-templates select="key('examples_exercises', @target)/task[@type='fragestellung']/LMMLtext[1]"/>
                            <xsl:apply-templates select="key('examples_exercises', @target)/task[@type='textbeispiel']"/>
                            <div class="drop_areas">
                                <xsl:attribute name="id">drop_areas_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                <xsl:for-each select="key('examples_exercises', @target)//LMMLtext[matches(@type, 'column')]">
                                    <div class="drop_wrapper">
                                        <div class="drop_head"><xsl:apply-templates/></div>
                                        <hr class="drop_separation"/>
                                        <div class="drop_area" ondrop="drop(event, this)" ondragover="allowDrop(event)">
                                            <xsl:attribute name="id">drop_area_<xsl:value-of select="$ex_nr"/>_<xsl:number count="LMMLtext[matches(@type, 'column')]"/></xsl:attribute>
                                        </div>
                                    </div>
                                </xsl:for-each>
                            </div>
                            <div class="dnd_items">
                                <xsl:attribute name="id">dnd_items_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                <xsl:for-each select="key('examples_exercises', @target)//LMMLtext[matches(@type, 'input')]">
                                    <xsl:if test=". != ''">
                                        <div draggable="true" ondragstart="drag(event)">
                                            <xsl:attribute name="id">dnd_item_<xsl:value-of select="$ex_nr"/>_<xsl:number count="LMMLtext[matches(@type, 'input')]"/></xsl:attribute>
                                            <xsl:attribute name="class">drop_area_<xsl:value-of select="$ex_nr"/>_<xsl:value-of select="@title"/></xsl:attribute>
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
    <xsl:template match="task[@type='fragestellung']/LMMLtext[1]">
        <div class="task">
            <div class="pretext">Fragestellung:</div>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="formatted[@style='richtig' or @style='style1']">
        <span class="correct_marker">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="task[@type='userinput']/LMMLtext">
        <div class="text">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="option[@target]"/>
    
    <xsl:template match="option[not(@target)]">
        <xsl:variable name="label"><xsl:value-of select="@label"/></xsl:variable>
        <select name="dropdown" class="gap">
            <option value="standard">--- bitte auswählen ---</option>
            <option value="true"><xsl:apply-templates/></option>
            <xsl:for-each select="following-sibling::option[@target=$label]">
                <option value="false"><xsl:value-of select="."></xsl:value-of></option>
            </xsl:for-each>
        </select>
    </xsl:template>
    
    <!-- TEXT(FORMATIERUNGEN) -->
    <xsl:template match="formatted[@style='ueberschrift']">
        <h4>
            <xsl:apply-templates/>
        </h4>
    </xsl:template>
    
    <xsl:template match="formatted[@style='buchtitel']">
        <span class="title">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="formatted[@style='regie']">
        <span class="stage_dir">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="formatted[@style='hervorhebung']">
        <span class="highlight">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="definition">
        <div class="definition">
            <span class="term"><xsl:value-of select="@title"/><xsl:text>: </xsl:text></span>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="illustration[@label]/LMMLtext">
        <div class="section">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="illustration[not(@*)]/LMMLtext">
        <xsl:choose>
            <xsl:when test=".//poem">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <div class="info_example">
                    <xsl:apply-templates/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- MEDIEN -->
    
    <!-- Bilder -->
    <xsl:template match="externalLink[matches(@uri, '.jpg|.gif')]">
        <img class="media">
            <xsl:attribute name="src"><xsl:text>{{ 'assets/media/</xsl:text><xsl:value-of select="@uri"/><xsl:text>' | relative_url }}</xsl:text></xsl:attribute>
        </img>
    </xsl:template>
    
    <!-- Videos -->
    <xsl:template match="LMMLtext[externalLink[matches(@uri, '.swf')]]" priority="1">
        <div class="list-group-item">
            <a class="chevron-link" data-bs-toggle="collapse" aria-expanded="false">
                <xsl:attribute name="href">#<xsl:value-of select="./externalLink/substring-before(@uri, '.')"/></xsl:attribute>
                <xsl:attribute name="aria-controls">#<xsl:value-of select="./externalLink/substring-before(@uri, '.')"/></xsl:attribute>
                <i class="bi bi-chevron-down rotate"></i>
                <span class="list-link"><xsl:value-of select="."/></span>
            </a>
            <div class="list-group collapse">
                <xsl:attribute name="id"><xsl:value-of select="./externalLink/substring-before(@uri, '.')"/></xsl:attribute>
                <video type="video/mp4" controls="controls">
                    <xsl:attribute name="src"><xsl:text>{{ 'assets/media/</xsl:text><xsl:value-of select="./externalLink/substring-before(@uri, '.')"/><xsl:text>.mp4' | relative_url }}</xsl:text></xsl:attribute>
                    Video-Widergabe wird nicht vom Browser unterstützt.
                </video>
            </div>
        </div>
    </xsl:template>
    
    <!-- LISTEN -->
    <xsl:template match="ulist">
        <ul class="unordered_list">
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    
    <xsl:template match="olist">
        <ol class="ordered_list">
            <xsl:apply-templates/>
        </ol>
    </xsl:template>
    
    <xsl:template match="item">
        <li class="list_item">
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    
    <xsl:template match="item/LMMLtext">
        <div class="text">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- TABELLEN -->
    <xsl:template match="table">
        <table class="content_table">
            <xsl:for-each select="./tablerow">
                <tr>
                    <xsl:for-each select="./tabledata">
                        <td class="table_data"><xsl:value-of select="."/></td>
                    </xsl:for-each>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>
    
    <!-- Erläuterungen und Textbeispiele -->
    <xsl:template match="exercise|section[@type='example']"/>
    
    <xsl:template match="section[@type='example']/illustration">
        <xsl:choose>
            <xsl:when test="./node() and not(.//quotation or .//poem)">
                <div class="explanation">
                    <div class="pretext">Erläuterung:</div>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="./node()">
                <xsl:apply-templates/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="quotation">
        <xsl:if test=".//externalLink[@uri]">
            <xsl:apply-templates/>
        </xsl:if>
        <xsl:if test=".//text()">
            <xsl:variable name="ex_nr"><xsl:number level="any" count="exercise"/></xsl:variable>
            <div class="quotation">
                <xsl:if test="ancestor::task[@type='selection']">
                    <xsl:attribute name="id">markable_text_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="not(ancestor::task[@type='alternative'])">
                    <div class="pretext">Textbeispiel:</div>
                </xsl:if>
                <xsl:apply-templates/>
                <xsl:if test="@authorname or @authorfamily">
                    <span class="author_title">
                        <span class="author"><xsl:value-of select="@authorname"/><xsl:text> </xsl:text><xsl:value-of select="@authorfamily"/>:&#160;</span>
                        <span class="title"><xsl:value-of select="(@title|@booktitle)"/></span>
                    </span>
                </xsl:if>
            </div>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="quotation/LMMLtext">
        <div class="text">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="poem">
        <xsl:if test=".//text()">
            <div class="poem">
                <xsl:if test="not(ancestor::task[@type='alternative'])">
                    <div class="pretext">Textbeispiel:</div>
                </xsl:if>
                <xsl:apply-templates/>
                <xsl:if test="@authorname or @authorfamily">
                    <span class="author_title">
                        <span class="author"><xsl:value-of select="@authorname"/><xsl:text> </xsl:text><xsl:value-of select="@authorfamily"/>:&#160;</span>
                        <span class="title"><xsl:value-of select="(@title|@booktitle)"/>
                        </span>
                    </span>
                </xsl:if>
            </div>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="poemlinegroup">
        <div class="poem_linegroup">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="poemline">
        <p class="poem_line">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <!-- Interne Links zu anderen Kurseinheiten -->
    <xsl:template match="referencesLink[@target and not(@type='defines') and not(@type='illustrates') and not(@type='exercises') and not(@type='book')]">
        <xsl:choose>
            <xsl:when test="not(./parent::referencesLink[@type='defines']) and not(./child::referencesLink[@type='defines'])">
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
                        <xsl:value-of select="./@target"/>
                        <xsl:text>.html' | relative_url }}</xsl:text>
                    </xsl:attribute>
                    <i class="bi bi-chevron-right"></i><span class="link_text"><xsl:apply-templates/></span>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <!-- Pop-Over-Begriffserläuterungen -->
    <xsl:template match="referencesLink[@type='defines']">
        <xsl:variable name="path" select="document-uri(/)"/>
        <xsl:variable name="target" select="@target"/>
        <details class="pop_over">
            <summary class="pop_over_link">
                <i class="bi bi-caret-right-fill rotate-up"></i><span class="link_text"><xsl:apply-templates/></span>
            </summary>
            <xsl:for-each select="document('../xml_selbstgenerierte/definitionen.xml')//div[@class='definition']">
                <xsl:if test="@label = $target">
                    <div class="pop_over_content">
                        <h5><xsl:value-of select="@id"/></h5>
                        <xsl:value-of select="."/>
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
                                    <xsl:value-of select="./@file"/>
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
        
    <!-- Fußnoten -->
    <xsl:template match="annotated">
        <a class="footnote_link">
            <xsl:attribute name="id">footnote_<xsl:number level="any"/></xsl:attribute>
            <xsl:attribute name="href">#anchor_<xsl:number level="any"/></xsl:attribute>
            <sup class="footnote_number">[<xsl:number level="any"/>]</sup>
        </a>
    </xsl:template>
    
</xsl:stylesheet>