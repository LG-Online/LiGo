<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon" exclude-result-prefixes="saxon">
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="ex_nr" select="0" saxon:assignable="yes"/>
    
    <xsl:template name="main">
        <div class="exercises">
            <xsl:for-each select="collection('../xml_wissensbereiche/?select=*.xml;recurse=yes')">
                <xsl:apply-templates select=".//exercise"/>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    <xsl:template match="exercise">
        <saxon:assign name="ex_nr" select="$ex_nr + 1"/>
        <xsl:choose>
            <!-- Multiple Choice-/Alternative Textbeispiele-Übung -->
            <xsl:when test="@topics='multiplechoice' or @topics='alternativen' or @type='alternativen'">
                <div class="exercise mc">
                    <xsl:attribute name="resource">
                        <xsl:analyze-string select="base-uri(.)" regex=".+xml_wissensbereiche/(.+?)/.+\.xml">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(1)"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:attribute>
                    <xsl:attribute name="id">
                        <xsl:value-of select="@label"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="./task[@type='fragestellung']/LMMLtext[1]"/>
                    <xsl:apply-templates select="./task[@type='textbeispiel']"/>
                    <fieldset>
                        <xsl:attribute name="id">option_pool_<xsl:value-of select="$ex_nr"/></xsl:attribute>
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
                        <xsl:for-each select="./solution">
                            <span>
                                <xsl:attribute name="class">option_<xsl:value-of select="$ex_nr"/>_<xsl:value-of select="@label"/></xsl:attribute>
                                <xsl:apply-templates/>
                            </span>
                        </xsl:for-each>
                    </div>
                </div>
            </xsl:when>
            
            <!-- Texteingabe-Übung -->
            <xsl:when test="./@topics='musterloesung'">
                <div class="exercise text">
                    <xsl:attribute name="resource">
                        <xsl:analyze-string select="base-uri(.)" regex=".+xml_wissensbereiche/(.+?)/.+\.xml">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(1)"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:attribute>
                    <xsl:attribute name="id">
                        <xsl:value-of select="@label"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="./task[@type='fragestellung']/LMMLtext[1]"/>
                    <xsl:apply-templates select="./task[@type='textbeispiel']"/>
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
            
            <!-- Markieren-Übung -->
            <xsl:when test="./@topics='markieren'">
                <div class="exercise marker">
                    <xsl:attribute name="resource">
                        <xsl:analyze-string select="base-uri(.)" regex=".+xml_wissensbereiche/(.+?)/.+\.xml">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(1)"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:attribute>
                    <xsl:attribute name="id">
                        <xsl:value-of select="@label"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="./task[@type='fragestellung']/LMMLtext[1]"/>
                    <xsl:apply-templates select="./task[@type='selection']"/>                          
                    <div class="solution">
                        <xsl:attribute name="id">solution_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                        <div class="feedback">
                            <xsl:attribute name="id">feedback_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                            Erläuterung:
                        </div>
                        <div class="answer">
                            <xsl:attribute name="id">answer_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                            <xsl:apply-templates select=".//LMMLtext[@type='answerText']"/>
                        </div>
                    </div>
                </div>
            </xsl:when>
            
            <!-- Lückentext-Übung -->
            <xsl:when test="./@topics='luecken'">
                <div class="exercise gaps">
                    <xsl:attribute name="resource">
                        <xsl:analyze-string select="base-uri(.)" regex=".+xml_wissensbereiche/(.+?)/.+\.xml">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(1)"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:attribute>
                    <xsl:attribute name="id">
                        <xsl:value-of select="@label"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="./task[@type='fragestellung']/LMMLtext[1]"/>
                    <xsl:for-each select=".//task[@type='lueckentext']/quotation[@type='luecken']/LMMLtext">
                        <xsl:if test="./text()">
                            <div class="gap_text">
                                <xsl:attribute name="id">gap_text_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                                <xsl:apply-templates/>
                            </div>
                        </xsl:if>
                    </xsl:for-each>
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
            
            <!-- Drag & Drop-Übung -->
            <xsl:otherwise>
                <div class="exercise dnd">
                    <xsl:attribute name="resource">
                        <xsl:analyze-string select="base-uri(.)" regex=".+xml_wissensbereiche/(.+?)/.+\.xml">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(1)"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:attribute>
                    <xsl:attribute name="id">
                        <xsl:value-of select="@label"/>
                    </xsl:attribute>
                    <div class="dnd_info">
                        <div class="pretext">Hinweis:</div>
                        Drag and Drop wird bislang nur auf PCs/Laptops beziehungsweise auf Geräten unterstützt, die eine Maus oder ein Trackpad nutzen.
                        Auf Touchscreen-Geräten wie Smartphones und Tablets können Sie diese Übung daher momentan noch nicht durchführen.
                    </div>
                    <xsl:apply-templates select="./task[@type='fragestellung']/LMMLtext[1]"/>
                    <xsl:apply-templates select="./task[@type='textbeispiel']"/>
                    <div class="drop_areas">
                        <xsl:attribute name="id">drop_areas_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                        <xsl:for-each select=".//LMMLtext[matches(@type, 'column')]">
                            <div class="drop_wrapper">
                                <th class="drop_head"><xsl:apply-templates/></th>
                                <hr class="drop_separation"/>
                                <div class="drop_area" ondrop="drop(event, this)" ondragover="allowDrop(event)">
                                    <xsl:attribute name="id">drop_area_<xsl:value-of select="$ex_nr"/>_<xsl:number count="LMMLtext[matches(@type, 'column')]"/></xsl:attribute>
                                </div>
                            </div>
                        </xsl:for-each>
                    </div>
                    <div class="dnd_items">
                        <xsl:attribute name="id">dnd_items_<xsl:value-of select="$ex_nr"/></xsl:attribute>
                        <xsl:for-each select=".//LMMLtext[matches(@type, 'input')]">
                            <xsl:if test=". != ''">
                                <div draggable="true" ondragstart="drag(event)">
                                    <xsl:attribute name="id">dnd_item_<xsl:value-of select="$ex_nr"/>_<xsl:number count="LMMLtext[matches(@type, 'input')]"/></xsl:attribute>
                                    <xsl:attribute name="class">drop_area_<xsl:value-of select="$ex_nr"/>_<xsl:value-of select="@title"/></xsl:attribute>
                                    <xsl:apply-templates/>
                                </div>
                            </xsl:if>
                        </xsl:for-each>
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
    
    <xsl:template match="referencesLink[@target and not(@type='defines') and not(@type='illustrates') and not(@type='exercises') and not(@type='book')]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="referencesLink[@type='defines']">
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>