<xsl:template match="data" xmlns:php="http://php.net/xsl">
<xsl:variable name="date_format"><xsl:value-of select="php:function('get_phpgw_info', 'user|preferences|common|dateformat')"/></xsl:variable>

<xsl:call-template name="yui_phpgw_i18n"/>
<div id="resource-allocation" class="yui-navset yui-navset-top">
	<h1>
		<xsl:value-of select="php:function('lang', 'Booking of resources')"/> for <xsl:value-of select="activity/name"/>
	</h1>
	
	<xsl:variable name="view_resources_params">
		<xsl:text>menuaction:logistic.uiactivity.view_resource_allocation, activity_id:</xsl:text>
			<xsl:value-of select="activity/id" />
		</xsl:variable>
		<xsl:variable name="view_resources_url">
			<xsl:value-of select="php:function('get_phpgw_link', '/index.php', $view_resources_params )" />
	</xsl:variable>
	<a style="margin-left: 20px;" id="view-resources-btn" class="btn non-focus" href="{$view_resources_url}">
		<xsl:value-of select="php:function('lang', 'View resources overview')" />
	</a>
	
	<div class="content-wrp">
		
		<div id="requirement-wrp">
			<h3 style="margin: 0 0 10px 0;">Detaljer for behov</h3>
			<ul>
				<li>
					<label for="start_date">Startdato</label><span><xsl:value-of select="php:function('date', $date_format, number(requirement/start_date))"/></span>
				</li>
				<li>
					<label for="end_date">Sluttdato</label>
					<span><xsl:value-of select="php:function('date', $date_format, number(requirement/end_date))"/></span>
				</li>
				<li>
					<label for="no_of_items">Antall</label>
					<span><xsl:value-of select="requirement/no_of_items" /></span>
				</li>
			</ul>
			
			<h3 style="margin-bottom: 10px;">Kriterier</h3>
				<xsl:choose>
					<xsl:when test="view_criterias_array/child::node()">
						<xsl:for-each select="view_criterias_array">
							<ul>
								<li>
									<label><xsl:value-of select="cust_attribute_data/input_text"/></label>
									<span style="margin-right:5px;"><xsl:value-of select="operator"/></span>
									<xsl:choose>
										<xsl:when test="cust_attribute_data/column_info/type = 'LB'">
											<xsl:for-each select="cust_attribute_data/choice">
												<xsl:if test="//value = id">
													<span><xsl:value-of select="value"/></span>
												</xsl:if>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
											<span><xsl:value-of select="value"/></span>
										</xsl:otherwise>
									</xsl:choose>
								</li>
							</ul>
						</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<p style="margin-top:0;">Ingen kriterier lagt til</p>
						</xsl:otherwise>
				</xsl:choose>
		</div>
			
			<xsl:variable name="action_url">
				<xsl:value-of select="php:function('get_phpgw_link', '/index.php', 'menuaction:logistic.uirequirement_resource_allocation.save')" />
			</xsl:variable>
			<form action="{$action_url}" method="post">
				<input type="hidden" name="requirement_id" value="{requirement/id}" />

				<div id="resource-list">
					<div class="resource heading">
							<span class="desc">Kort beskrivelse</span>
							<span class="loc_id">Lokasjons id</span>
							<span class="type">Type</span>
							<span class="loc_code">Lokasjons kode</span>
					</div>
					<xsl:for-each select="allocation_suggestions">
						
						<div>				
							<xsl:choose>
						  	<xsl:when test="(position() mod 2) != 1">
						    	<xsl:attribute name="class">resource odd</xsl:attribute>
						    </xsl:when>
						    <xsl:otherwise>
						    	<xsl:attribute name="class">resource even</xsl:attribute>
						    </xsl:otherwise>
						  </xsl:choose>
						
							<input type="checkbox" value="{id}" name="chosen_resources[]" />
							<span class="desc"><xsl:value-of select="short_description" /></span>
							<span class="loc_id"><xsl:value-of select="location_id" /></span>
							<span class="type"><xsl:value-of select="type_lokale" /></span>
							<span class="loc_code"><xsl:value-of select="location_code" /></span>
						</div>
					</xsl:for-each>
				</div>			
				
				<input type="submit" value="Lagre bestilling" />
			</form>
	</div>
</div>
</xsl:template>