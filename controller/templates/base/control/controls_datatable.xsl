<!-- $Id: view_locations_for_control.xsl 9485 2012-06-04 08:39:52Z vator $ -->

<xsl:template match="data" xmlns:php="http://php.net/xsl">

<div id="main_content">

	<h1>Kontroller</h1>

  <div class="content-wrp">
	  <xsl:call-template name="datatable" />
  </div>
</div>
</xsl:template>