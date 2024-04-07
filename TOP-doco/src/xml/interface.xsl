<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- Get filename -->
  <xsl:param name="filename" select="page/filename"/>
  <!-- Get sitemap -->
  <xsl:param name="realsitemap" select="document('real-sitemap.xml')"/>
  <!-- Set up node variables -->
  <xsl:param name="currentnode" select="$realsitemap//menubar//menuitem[@href=$filename]"/>
  <xsl:param name="prevnode" select="$currentnode/preceding::menuitem[position()=1]"/>
  <xsl:param name="nextnode" select="$currentnode/following::menuitem[position()=1]"/>
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
<base href="{$realsitemap/window/base/@href}"/>

<link rel="stylesheet" href="TOP-interface.css"/>
<link rel="stylesheet" href="TOP-toc.css"/>
<link rel="stylesheet" href="TOP-content.css"/>

</head>
<body>

<div class="wide-box {$currentnode/@width}">
<div class="menu-bar"><ul>
  <xsl:apply-templates select="$realsitemap//menubar/*"/>
</ul></div>

<div id="table-of-contents">
  <ul>
    <xsl:apply-templates select="//h1" mode="toc"/>
  </ul>
</div>

<div class="main-box">

<div class="title"><xsl:value-of select="$title"/></div>

<div class="tagline">Tim Nelson, 2024</div>

<xsl:apply-templates select="page/content/*" mode="content"/>

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
	<li class="menu-container">
	  <xsl:apply-templates select="title"/>
    <div class="menu-content">
      <xsl:apply-templates select="*[self::menu or self::menuitem]"/>
    </div>
	</li>
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
	  <li class="menu-container">
		    <a href="javascript:void(0)" class="menu-bar-button"><xsl:value-of select="title"/></a>
        <div class="menu-content">
          <xsl:apply-templates select="*[self::menu or self::menuitem]"/>
        </div>
      </li>
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
   
  <xsl:template match="*" mode="content">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="xtlinclude" mode="content">
    <xsl:copy-of select="document(@href)"/>
  </xsl:template>
  
  <xsl:template match="h1" mode="toc">
    <xsl:param name="id">
      <xsl:choose>
        <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="generate-id(.)"/></xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <li><a href="{$filename}#{$id}"><xsl:copy-of select="./text()"/></a></li>
  </xsl:template>
  
  <xsl:template match="h1" mode="content">
    <xsl:param name="id">
      <xsl:choose>
        <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="generate-id(.)"/></xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <a class="pre-heading" name="$id"/>
    <a class="heading-link" href="{$filename}#{$id}">
      <h1>
        <xsl:copy-of select="./text()"/>
        <xsl:if test="@id">
          <span style="font-family: 'Noto Emoji'">⚓</span>
        </xsl:if>
      </h1>
    </a>
  </xsl:template>
  
</xsl:stylesheet>
