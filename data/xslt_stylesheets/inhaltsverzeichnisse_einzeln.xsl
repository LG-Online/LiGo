<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon" exclude-result-prefixes="saxon">
    <xsl:variable name="first_level_units" select="1" saxon:assignable="yes"/>
    <xsl:variable name="second_level_units" select="1" saxon:assignable="yes"/>
    <xsl:variable name="third_level_units" select="1" saxon:assignable="yes"/>
    <xsl:variable name="fourth_level_units" select="1" saxon:assignable="yes"/>
    <xsl:variable name="fifth_level_units" select="1" saxon:assignable="yes"/>
    <xsl:variable name="sixth_level_units" select="1" saxon:assignable="yes"/>
    <xsl:variable name="seventh_level_units" select="1" saxon:assignable="yes"/>
    <xsl:variable name="eighth_level_units" select="1" saxon:assignable="yes"/>
    <xsl:variable name="discipline" saxon:assignable="yes"/>
    <xsl:output method="html" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="section">
        
        <!-- Ebene 1 -->
        <xsl:for-each select="./section">
            
            <saxon:assign name="discipline"><xsl:value-of select="@discipline"/></saxon:assign>
            <xsl:result-document href="inhalt_{$discipline}.html">---
                title: "<xsl:value-of select="@title"/>"
                layout: default
                type: liste
                ---
                <h1><xsl:value-of select="@title"/></h1>
                <button class="expand-collapse-button">Alle Ebenen anzeigen/verbergen</button>
                <div class="drop-down-list">

                <saxon:assign name="second_level_units">1</saxon:assign>
                    <div class="list-group-item level-1">
                        <xsl:choose>
                            <xsl:when test="./section">
                                <a class="chevron-link" data-bs-toggle="collapse" aria-expanded="true">
                                    <xsl:attribute name="aria-controls">
                                        <xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                        <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="href">
                                        <xsl:text>#</xsl:text><xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                        <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                    </xsl:attribute>
                                    <i class="bi bi-chevron-down rotate active"></i>
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="no-chevron"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <a class="list-link">
                            <xsl:attribute name="href">
                                <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                <xsl:value-of select="ancestor-or-self::section[@discipline]/@discipline"/>
                                <xsl:text>/</xsl:text>
                                <xsl:value-of select="./@uri"/>
                                <xsl:text>' | relative_url }}</xsl:text>
                            </xsl:attribute>
                            <xsl:value-of select="@title"/>
                        </a>
                        
                        <!-- Ebene 2 -->
                        <div class="list-group collapse level-2 show">
                            <xsl:attribute name="id">
                                <xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                            </xsl:attribute>
                            <xsl:for-each select="./section">
                                <saxon:assign name="third_level_units">1</saxon:assign>
                                <div class="list-group-item level-2">
                                    <xsl:choose>
                                        <xsl:when test="./section">
                                            <a class="chevron-link" data-bs-toggle="collapse" aria-expanded="false">
                                                <xsl:attribute name="aria-controls">
                                                    <xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                                    <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                                    <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="href">
                                                    <xsl:text>#</xsl:text><xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                                    <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                                    <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                </xsl:attribute>
                                                <i class="bi bi-chevron-down rotate"></i>
                                            </a>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <span class="no-chevron"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <a class="list-link">
                                        <xsl:attribute name="href">
                                            <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                            <xsl:value-of select="ancestor-or-self::section[@discipline]/@discipline"/>
                                            <xsl:text>/</xsl:text>
                                            <xsl:value-of select="./@uri"/>
                                            <xsl:text>' | relative_url }}</xsl:text>
                                        </xsl:attribute>
                                        <xsl:value-of select="@title"/>
                                    </a>
                                    
                                    <!-- Ebene 3 -->
                                    <div class="list-group collapse level-3">
                                        <xsl:attribute name="id">
                                            <xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                            <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                            <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                        </xsl:attribute>
                                        <xsl:for-each select="./section">
                                            <saxon:assign name="fourth_level_units">1</saxon:assign>
                                            <div class="list-group-item level-3">
                                                <xsl:choose>
                                                    <xsl:when test="./section">
                                                        <a class="chevron-link" data-bs-toggle="collapse" aria-expanded="false">
                                                            <xsl:attribute name="aria-controls">
                                                                <xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                                                <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="href">
                                                                <xsl:text>#</xsl:text><xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                                                <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                            </xsl:attribute>
                                                            <i class="bi bi-chevron-down rotate"></i>
                                                        </a>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <span class="no-chevron"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                <a class="list-link">
                                                    <xsl:attribute name="href">
                                                        <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                                        <xsl:value-of select="ancestor-or-self::section[@discipline]/@discipline"/>
                                                        <xsl:text>/</xsl:text>
                                                        <xsl:value-of select="./@uri"/>
                                                        <xsl:text>' | relative_url }}</xsl:text>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="@title"/>
                                                </a>
                                                
                                                <!-- Ebene 4 -->
                                                <div class="list-group collapse level-4">
                                                    <xsl:attribute name="id">
                                                        <xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                                        <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                                        <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                        <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                    </xsl:attribute>
                                                    <xsl:for-each select="./section">
                                                        <saxon:assign name="fifth_level_units">1</saxon:assign>
                                                        <div class="list-group-item level-4">
                                                            <xsl:choose>
                                                                <xsl:when test="./section">
                                                                    <a class="chevron-link" data-bs-toggle="collapse" aria-expanded="false">
                                                                        <xsl:attribute name="aria-controls">
                                                                            <xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                        </xsl:attribute>
                                                                        <xsl:attribute name="href">
                                                                            <xsl:text>#</xsl:text><xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                        </xsl:attribute>
                                                                        <i class="bi bi-chevron-down rotate"></i>
                                                                    </a>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                    <span class="no-chevron"/>
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                            <a class="list-link">
                                                                <xsl:attribute name="href">
                                                                    <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                                                    <xsl:value-of select="ancestor-or-self::section[@discipline]/@discipline"/>
                                                                    <xsl:text>/</xsl:text>
                                                                    <xsl:value-of select="./@uri"/>
                                                                    <xsl:text>' | relative_url }}</xsl:text>
                                                                </xsl:attribute>
                                                                <xsl:value-of select="@title"/>
                                                            </a>
                                                            
                                                            <!-- Ebene 5 -->
                                                            <div class="list-group collapse level-5">
                                                                <xsl:attribute name="id">
                                                                    <xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                </xsl:attribute>
                                                                <xsl:for-each select="./section">
                                                                    <saxon:assign name="sixth_level_units">1</saxon:assign>
                                                                    <div class="list-group-item level-5">
                                                                        <xsl:choose>
                                                                            <xsl:when test="./section">
                                                                                <a class="chevron-link" data-bs-toggle="collapse" aria-expanded="false">
                                                                                    <xsl:attribute name="aria-controls">
                                                                                        <xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                                    </xsl:attribute>
                                                                                    <xsl:attribute name="href">
                                                                                        <xsl:text>#</xsl:text><xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                                    </xsl:attribute>
                                                                                    <i class="bi bi-chevron-down rotate"></i>
                                                                                </a>
                                                                            </xsl:when>
                                                                            <xsl:otherwise>
                                                                                <span class="no-chevron"/>
                                                                            </xsl:otherwise>
                                                                        </xsl:choose>
                                                                        <a class="list-link">
                                                                            <xsl:attribute name="href">
                                                                                <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                                                                <xsl:value-of select="ancestor-or-self::section[@discipline]/@discipline"/>
                                                                                <xsl:text>/</xsl:text>
                                                                                <xsl:value-of select="./@uri"/>
                                                                                <xsl:text>' | relative_url }}</xsl:text>
                                                                            </xsl:attribute>
                                                                            <xsl:value-of select="@title"/>
                                                                        </a>
                                                                        
                                                                        <!-- Ebene 6 -->
                                                                        <div class="list-group collapse level-6">
                                                                            <xsl:attribute name="id">
                                                                                <xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                            </xsl:attribute>
                                                                            <xsl:for-each select="./section">
                                                                                <saxon:assign name="seventh_level_units">1</saxon:assign>
                                                                                <div class="list-group-item level-6">
                                                                                    <xsl:choose>
                                                                                        <xsl:when test="./section">
                                                                                            <a class="chevron-link" data-bs-toggle="collapse" aria-expanded="false">
                                                                                                <xsl:attribute name="aria-controls">
                                                                                                    <xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$sixth_level_units"/>
                                                                                                </xsl:attribute>
                                                                                                <xsl:attribute name="href">
                                                                                                    <xsl:text>#</xsl:text><xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                                                    <xsl:text>-</xsl:text><xsl:value-of select="$sixth_level_units"/>
                                                                                                </xsl:attribute>
                                                                                                <i class="bi bi-chevron-down rotate"></i>
                                                                                            </a>
                                                                                        </xsl:when>
                                                                                        <xsl:otherwise>
                                                                                            <span class="no-chevron"/>
                                                                                        </xsl:otherwise>
                                                                                    </xsl:choose>
                                                                                    <a class="list-link">
                                                                                        <xsl:attribute name="href">
                                                                                            <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                                                                            <xsl:value-of select="ancestor-or-self::section[@discipline]/@discipline"/>
                                                                                            <xsl:text>/</xsl:text>
                                                                                            <xsl:value-of select="./@uri"/>
                                                                                            <xsl:text>' | relative_url }}</xsl:text>
                                                                                        </xsl:attribute>
                                                                                        <xsl:value-of select="@title"/>
                                                                                    </a>
                                                                                    
                                                                                    <!-- Ebene 7 -->
                                                                                    <div class="list-group collapse level-7">
                                                                                        <xsl:attribute name="id">
                                                                                            <xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$sixth_level_units"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:for-each select="./section">
                                                                                            <saxon:assign name="eighth_level_units">1</saxon:assign>
                                                                                            <div class="list-group-item level-7">
                                                                                                <xsl:choose>
                                                                                                    <xsl:when test="./section">
                                                                                                        <a class="chevron-link" data-bs-toggle="collapse" aria-expanded="false">
                                                                                                            <xsl:attribute name="aria-controls">
                                                                                                                <xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$sixth_level_units"/>
                                                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$seventh_level_units"/>
                                                                                                            </xsl:attribute>
                                                                                                            <xsl:attribute name="href">
                                                                                                                <xsl:text>#</xsl:text><xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$sixth_level_units"/>
                                                                                                                <xsl:text>-</xsl:text><xsl:value-of select="$seventh_level_units"/>
                                                                                                            </xsl:attribute>
                                                                                                            <i class="bi bi-chevron-down rotate"></i>
                                                                                                        </a>
                                                                                                    </xsl:when>
                                                                                                    <xsl:otherwise>
                                                                                                        <span class="no-chevron"/>
                                                                                                    </xsl:otherwise>
                                                                                                </xsl:choose>
                                                                                                <a class="list-link">
                                                                                                    <xsl:attribute name="href">
                                                                                                        <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                                                                                        <xsl:value-of select="ancestor-or-self::section[@discipline]/@discipline"/>
                                                                                                        <xsl:text>/</xsl:text>
                                                                                                        <xsl:value-of select="./@uri"/>
                                                                                                        <xsl:text>' | relative_url }}</xsl:text>
                                                                                                    </xsl:attribute>
                                                                                                    <xsl:value-of select="@title"/>
                                                                                                </a>
                                                                                                
                                                                                                <!-- Ebene 8 -->
                                                                                                <div class="list-group collapse level-8">
                                                                                                    <xsl:attribute name="id">
                                                                                                        <xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$sixth_level_units"/>
                                                                                                        <xsl:text>-</xsl:text><xsl:value-of select="$seventh_level_units"/>
                                                                                                    </xsl:attribute>
                                                                                                    <xsl:for-each select="./section">
                                                                                                        <div class="list-group-item level-8">
                                                                                                            <xsl:choose>
                                                                                                                <xsl:when test="./section">
                                                                                                                    <a class="chevron-link" data-bs-toggle="collapse" aria-expanded="false">
                                                                                                                        <xsl:attribute name="aria-controls">
                                                                                                                            <xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$sixth_level_units"/>
                                                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$seventh_level_units"/>
                                                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$eighth_level_units"/>
                                                                                                                        </xsl:attribute>
                                                                                                                        <xsl:attribute name="href">
                                                                                                                            <xsl:text>#</xsl:text><xsl:value-of select="$discipline"/><xsl:text>-unit</xsl:text>
                                                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$first_level_units"/>
                                                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$second_level_units"/>
                                                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$third_level_units"/>
                                                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$fourth_level_units"/>
                                                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$fifth_level_units"/>
                                                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$sixth_level_units"/>
                                                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$seventh_level_units"/>
                                                                                                                            <xsl:text>-</xsl:text><xsl:value-of select="$eighth_level_units"/>
                                                                                                                        </xsl:attribute>
                                                                                                                        <i class="bi bi-chevron-down rotate"></i>
                                                                                                                    </a>
                                                                                                                </xsl:when>
                                                                                                                <xsl:otherwise>
                                                                                                                    <span class="no-chevron"/>
                                                                                                                </xsl:otherwise>
                                                                                                            </xsl:choose>
                                                                                                            <a class="list-link">
                                                                                                                <xsl:attribute name="href">
                                                                                                                    <xsl:text>{{ '_pages/wissensbereiche/</xsl:text>
                                                                                                                    <xsl:value-of select="ancestor-or-self::section[@discipline]/@discipline"/>
                                                                                                                    <xsl:text>/</xsl:text>
                                                                                                                    <xsl:value-of select="./@uri"/>
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
                    <saxon:assign name="first_level_units"><xsl:value-of select="$first_level_units+1"/></saxon:assign>
                </div>
                
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>