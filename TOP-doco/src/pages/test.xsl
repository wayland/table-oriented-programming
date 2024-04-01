<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="xhtml"
	version="2.0">

	<xsl:output method="html" indent="yes" encoding="utf-8" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>

	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml" lang="en-us" class="no-js">      
			<head>                
				<meta charset="utf-8"/>
				<title><xsl:value-of select="/page/title"/></title>
			</head>
			<body>
				<h1><xsl:value-of select="/page/title"/></h1>
				<p>Content - <xsl:value-of select="/page/author"/></p>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
