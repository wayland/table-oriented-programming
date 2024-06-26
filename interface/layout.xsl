﻿<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:svg="http://www.w3.org/2000/svg">
  <!-- Get filename -->
  <xsl:param name="sitedir" select="page/sitedir"/>
  <xsl:param name="sitedir_string">
    <xsl:choose>
      <xsl:when test="$sitedir != ''"><xsl:value-of select="$sitedir"/>/</xsl:when>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="filename" select="concat($sitedir_string, page/filename)"/>
  <xsl:param name="interface_structure" select="document('structure.xml')"/>
  <!-- Get sitemap -->
  <xsl:param name="realsitemap" select="document(concat('../', $sitedir, '/real-sitemap.xml'))"/>
  <!-- Set up node variables -->
  <xsl:param name="currentnode" select="$realsitemap//link[@href=$filename]"/>
  <xsl:param name="prevnode" select="page/prevnode/link | $currentnode/preceding::link[position()=1]"/>
  <xsl:param name="nextnode" select="page/nextnode/link | $currentnode/following::link[position()=1]"/>
  <!-- Set up usable text variables -->
  <xsl:param name="title" select="$currentnode/@name"/>

  <xsl:template match="/">
<html>
<head>
<title><xsl:value-of select="$title"/> :: Table-Oriented Programming (TOP)</title>
<!-- Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com"/>
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/>
<link href="https://fonts.googleapis.com/css2?family=Courier+Prime:ital,wght@0,400;0,700;1,400;1,700&amp;family=Crimson+Text:ital,wght@0,400;0,600;0,700;1,400;1,600;1,700&amp;family=Dosis:wght@200..800&amp;family=Forum&amp;family=Noto+Emoji:wght@300..700&amp;family=Quattrocento:wght@400;700&amp;family=Urbanist:ital,wght@0,100..900;1,100..900&amp;display=swap" rel="stylesheet"/>

<!-- jQuery -->
<script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.slim.min.js">
</script>

<!-- Links and stylesheet -->
<base href="{$interface_structure/window/base/@href}"/>

<link rel="stylesheet" href="interface/TOP-interface.css"/>
<link rel="stylesheet" href="TOP-toc.css"/>
<link rel="stylesheet" href="TOP-content.css"/>

</head>
<body>

<div class="wide-box {$currentnode/@width}">

<div class="left-column">
  <ul>
    <xsl:apply-templates select="$realsitemap" mode="site-toc"/>
  </ul>

</div>

<div class="main-column">
  <div class="menu-bar"><ul>
    <xsl:apply-templates select="$interface_structure//menubar/*"/>
  </ul></div>

<div class="main-box">

<div class="title"><xsl:value-of select="$title"/></div>

<div class="tagline">Tim Nelson, 2024</div>

<xsl:apply-templates select="page/content/node()" mode="content"/>

</div> <!-- main-box -->

<div class="footer">
	<span class="left"><xsl:call-template name="FooterLink">
	  <xsl:with-param name="type" select="'prev'"/>
	  <xsl:with-param name="node" select="$prevnode"/>
  </xsl:call-template></span>
	<span class="centre">-</span>
	<span class="right"><xsl:call-template name="FooterLink">
	  <xsl:with-param name="type" select="'next'"/>
	  <xsl:with-param name="node" select="$nextnode"/>
  </xsl:call-template> </span>
</div>
<div class="copyright">© Copyright Tim Nelson, 2024</div>
</div>

<div class="right-column">
  <div class="tab-widget">
    <div class="tab-headers">
      <span class="tab-header">Table of Contents</span>
    </div>
    <div class="tab-body">
      <div id="table-of-contents">
        <ul>
          <xsl:apply-templates select="//h1" mode="toc"/>
        </ul>
      </div>
    </div>
  </div>
</div>

</div> <!-- wide-box -->

</body>
</html>
    
  </xsl:template>
  
  <xsl:template name="FooterLink">
    <xsl:param name="type"/>
    <xsl:param name="node"/>
    <a href="{$node/@href}"><xsl:if test="$type = 'prev' and $node/@href != ''">&lt;&lt; </xsl:if><xsl:value-of select="$node/@name"/><xsl:if test="$type = 'next'"> &gt;&gt;</xsl:if></a>
  </xsl:template>
  
  <xsl:template match="menubar/menu">
	<span class="menu-container">
	  <xsl:apply-templates select="title"/>
    <div class="menu-content">
      <xsl:apply-templates select="*[self::menu or self::menuitem]"/>
    </div>
	</span>
  </xsl:template>
  
  <xsl:template match="menubar/dropmenu">
	<li class="dropmenu-container">
	  <xsl:apply-templates select="title"/>
    <div class="dropmenu-content">
      <xsl:apply-templates select="*[self::menu or self::menuitem]" mode="submenu"/>
    </div>
	</li>
  </xsl:template>
  
  <xsl:template match="menu/title|dropmenu/title">
		<a href="javascript:void(0)" class="menu-bar-button"><xsl:value-of select="."/></a>
  </xsl:template>
    
  <xsl:template match="menu" mode="submenu">
	  <span class="menu-container">
      <a href="javascript:void(0)" class="menu-bar-button"><xsl:value-of select="title"/></a>
      <div class="menu-content">
        <xsl:apply-templates select="*[self::menu or self::menuitem]"/>
      </div>
    </span>
  </xsl:template>
  
  <xsl:template match="menu">
			<section>
				<span class="menu-subheader"><xsl:value-of select="title"/></span>
				<xsl:apply-templates select="menuitem"/>
			</section>
  </xsl:template>
  
  <xsl:template match="menuitem">
			<a href="{@href}"><xsl:value-of select="@name"/></a>
  </xsl:template>
   
  <xsl:template match="@* | node()" mode="content">
    <xsl:copy>
      <xsl:apply-templates  select="@* | node()" mode="content"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xtlinclude" mode="content">
    <xsl:variable name="svgdoc" select="document(@href)/svg:svg"/>
    <xsl:variable name="width">
        <xsl:choose>
          <xsl:when test="@width"><xsl:value-of select="@width"/>mm</xsl:when>
          <xsl:when test="$svgdoc/@width"><xsl:value-of select="$svgdoc/@width"/></xsl:when>
          <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="height">
        <xsl:choose>
          <xsl:when test="@height"><xsl:value-of select="@height"/>mm</xsl:when>
          <xsl:when test="$svgdoc/@height"><xsl:value-of select="$svgdoc/@height"/></xsl:when>
          <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <!-- xsl:variable name="viewBox">
        <xsl:choose>
          <xsl:when test="@width and @height">0 0 <xsl:value-of select="$width"/> <xsl:value-of select="$height"/></xsl:when>
          <xsl:when test="$svgdoc/@viewBox"><xsl:value-of select="$svgdoc/@viewBox"/></xsl:when>
          <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:variable -->
    <svg:svg>
      <xsl:if test="$width"><xsl:attribute name="width"><xsl:value-of select="$width"/></xsl:attribute></xsl:if>
      <xsl:if test="$height"><xsl:attribute name="height"><xsl:value-of select="$height"/></xsl:attribute></xsl:if>
      <!-- xsl:if test="$viewBox"><xsl:attribute name="viewBox"><xsl:value-of select="$viewBox"/></xsl:attribute></xsl:if -->
      <xsl:copy-of select="$svgdoc/* | $svgdoc/@*[local-name() != 'width' and local-name() != 'height']"/>
    </svg:svg>
  </xsl:template>
  
  <xsl:template match="h1" mode="toc">
    <xsl:param name="id">
      <xsl:choose>
        <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="generate-id(.)"/></xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <li><a href="{$filename}#{$id}"><xsl:copy-of select="./text()"/></a></li>
    <ul>
      <xsl:apply-templates select="following::h2[preceding::h1[1]/@id = $id] | following::h2[generate-id(preceding::h1[1]) = $id]" mode="toc"/>
    </ul>
  </xsl:template>
  
  <xsl:template match="h2" mode="toc">
    <xsl:param name="id">
      <xsl:choose>
        <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="generate-id(.)"/></xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <li><a href="{$filename}#{$id}"><xsl:copy-of select="./text()"/></a></li>
    <ul>
      <xsl:apply-templates select="following::h3[generate-id(preceding::h2[1]) = $id]" mode="toc"/>
    </ul>
  </xsl:template>
  
  <xsl:template match="h3" mode="toc">
    <xsl:param name="id">
      <xsl:choose>
        <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="generate-id(.)"/></xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <li><a href="{$filename}#{$id}"><xsl:copy-of select="./text()"/></a></li>
  </xsl:template>

  <xsl:template match="h1|h2|h3" mode="content">
    <xsl:param name="id">
      <xsl:choose>
        <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="generate-id(.)"/></xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <a class="pre-heading" name="{$id}"/>
    <a class="heading-link" href="{$filename}#{$id}">
      <xsl:element name="{name()}">
        <xsl:copy-of select="./text()"/>
        <xsl:if test="@id">
          <span style="font-family: 'Noto Emoji'">⚓</span>
        </xsl:if>
      </xsl:element>
    </a>
  </xsl:template>

  <xsl:template match="section" mode="site-toc">
    <li><xsl:value-of select="title"/></li>
    <ul>
      <xsl:apply-templates select="section|link" mode="site-toc"/>
    </ul>
  </xsl:template>
  
  <xsl:template match="link" mode="site-toc">
    <li><a href="{@href}"><xsl:value-of select="@name"/></a></li>
  </xsl:template>
  
</xsl:stylesheet>
