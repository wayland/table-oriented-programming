<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- Get filename -->
  <xsl:param name="filename" select="page/filename"/>
  <!-- Get sitemap -->
  <xsl:param name="realsitemap" select="document('real-sitemap.xml')"/>
  <!-- Set up node variables -->
  <xsl:param name="currentnode" select="$realsitemap/site//item[@href=$filename]"/>
  <xsl:param name="prevnode" select="$currentnode/preceding::item[position()=1]"/>
  <xsl:param name="nextnode" select="$currentnode/following::item[position()=1]"/>
  <!-- Set up usable text variables -->
  <xsl:param name="title" select="$currentnode/@title"/>

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

<script type="text/javascript">
<!--
class	StackItem {
	Item = null;
	ParentList = null;

	constructor(item, parent, stack) {
		this.Item = item;
		this.ParentList = parent;
		stack.push(this);
	}
}

// If heading has an ID, make it anchor better
// Also, generate table of contents
$(document).ready(function() {
	// Start TOC code
	$("table-of-contents").empty();                                                            

	// jQuery stacks
	var HeadingStack = [];
	var prevHLevel = 0;

	var index = 0;                                                                    
	// End TOC code

	$("h1,h2,h3,h4,h5,h6").each(function(i) {
		var jQuery_Heading = $(this);
		var DOM_Heading = jQuery_Heading.get(0);

		//console.log('Starting: ' + jQuery_Heading.text());
		// if ($('#table-of-contents').is(':empty')){	console.log("Empty TOC-4!" + jQuery_Heading.text()); }

		// Create Anchor
		var anchor
		var anchor_name
		if(jQuery_Heading.attr('id')) {
			anchor_name = jQuery_Heading.attr("id");
		} else {
			anchor_name = DOM_Heading.nodeName + index;
		}
		var link_target = window.location.href + '#' + anchor_name;
		jQuery_Heading.before('<a name="' + anchor_name + '" class="pre-heading"/>');
		// End Create Anchor

		var originalText = jQuery_Heading.text();

		// Mark up named anchors
		if(jQuery_Heading.attr('id')) {
			jQuery_Heading.addClass('linkable');
			var headingId = jQuery_Heading.attr("id");
			jQuery_Heading.wrap('<a class="heading-link" href="' + link_target + '"></a>');
			var fontstring = "'Noto Emoji'";
			jQuery_Heading.append(' <span style="font-family: ' + fontstring + '">⚓</span>');
			jQuery_Heading.removeAttr("id");
		}
		// End Mark up named anchors

		// Start TOC code
		jQuery_Heading.before(anchor);                                     

		var	DOM_li = "<li><a href='" + link_target + "'>" + originalText + "</a></li>";
		var	jQuery_li = $(DOM_li);

		var thisHLevel = DOM_Heading.nodeName.substring(1,2);
		var thisHDiff = thisHLevel - prevHLevel;

		// console.log('t3==' + thisHDiff + '==' + thisHLevel + '==' + anchor_name);

		if(thisHDiff > 0) {
			for(let step = prevHLevel; step < thisHLevel; step++) {
				console.log('Starting step: ' + step);
				// Set up parent
				parent = HeadingStack[HeadingStack.length - 1];
				// Set up new stack item (including parent list) and push
				var isLast = step == (thisHLevel - 1);
				CurrentStackItem = new StackItem(
					isLast ? jQuery_li : null, 
					$('<ul foo="' + anchor_name + '-' + step + '"></ul>'),
					HeadingStack
				);
				if(isLast) {
					// Add item to list
					CurrentStackItem.ParentList.append(CurrentStackItem.Item);
				}
				// console.log(CurrentStackItem.ParentList.get(0));

				// Add list to list
				var useGrandParent = (typeof parent == 'undefined') ? "#table-of-contents" : parent.ParentList;
				// if(typeof useGrandParent == 'object') { console.log(useGrandParent.get(0)); }
				CurrentStackItem.ParentList.appendTo(useGrandParent);
			}
			// console.log(JSON.parse(JSON.stringify(HeadingStack)));
		} else if(thisHDiff == 0) {
			// Add to existing list
			CurrentStackItem.ParentList.append(jQuery_li);
		} else {
			for(let step = prevHLevel; step &gt; thisHLevel; step = step - 1) {
				HeadingStack.pop();
			}
			parent = HeadingStack[HeadingStack.length - 1];
			parent.ParentList.append(jQuery_li);
		}
		prevHLevel = thisHLevel;
		index++;                                                    
		// End TOC code
	});
})

-->
</script>

<!-- Links and stylesheet -->
<base href="{$realsitemap/site/base/@href}"/>

<link rel="stylesheet" href="TOP-interface.css"/>
<link rel="stylesheet" href="TOP-toc.css"/>
<link rel="stylesheet" href="TOP-content.css"/>

</head>
<body>

<div class="wide-box {$currentnode/@width}">
<div class="menu-bar"><ul>
  <xsl:apply-templates select="$realsitemap/site/*"/>
	
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
    <a href="{$node/@href}"><xsl:if test="$type = 'prev' and $node/@href != ''">&lt;&lt; </xsl:if><xsl:value-of select="$node/@title"/><xsl:if test="$type = 'next'"> &gt;&gt;</xsl:if></a>
  </xsl:template>
  
  <xsl:template match="site/group">
	<li class="menu">
		<a href="javascript:void(0)" class="menu-bar-button"><xsl:value-of select="title"/></a>
		<xsl:choose>
		  <xsl:when test="@type = 'drop-menu'">
        <div class="menu-content drop-menu">
          <xsl:apply-templates select="*[self::group or self::item]" mode="submenu"/>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="menu-content">
          <xsl:apply-templates select="*[self::group or self::item]"/>
        </div>
      </xsl:otherwise>
		</xsl:choose>
	</li>
  </xsl:template>
    
  <xsl:template match="group" mode="submenu">
	  <li class="menu">
		    <a href="javascript:void(0)" class="menu-bar-button"><xsl:value-of select="title"/></a>
        <div class="menu-content">
          <xsl:apply-templates select="*[self::group or self::item]"/>
        </div>
      </li>
  </xsl:template>
  
  <xsl:template match="group">
			<section>
				<span class="menu-subheader"><xsl:value-of select="title"/></span>
				<xsl:apply-templates select="item"/>
			</section>
  </xsl:template>
  
  <xsl:template match="item">
			<a href="{@href}"><xsl:value-of select="@title"/></a>
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
