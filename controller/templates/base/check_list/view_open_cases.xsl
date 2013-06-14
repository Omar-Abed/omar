<!-- $Id: choose_control_items.xsl 8267 2011-12-11 12:27:18Z sigurdne $ -->

<xsl:template match="data" xmlns:php="http://php.net/xsl">

<div id="view_cases">
	
	<xsl:call-template name="cases_tab_menu">
	 	<xsl:with-param name="active_tab">view_open_cases</xsl:with-param>
	</xsl:call-template>
	
	<div class="tab_item active">
		<xsl:choose>
			<xsl:when test="open_check_items_and_cases/child::node()">
				<ul class="check_items">
					<xsl:for-each select="open_check_items_and_cases">
						<xsl:choose>
							<xsl:when test="control_item/type = 'control_item_type_1'">
			 					<xsl:choose>
			 						<xsl:when test="cases_array/child::node()">
					 					<li class="check_item_case">
			 						<h4><span><xsl:value-of select="control_item/title"/></span></h4>
						 			<span class="control_item_type ext_info"><xsl:value-of select="control_item/type" /></span>
						 			<ul>
						 			<xsl:for-each select="cases_array">
										<xsl:variable name="cases_id"><xsl:value-of select="id"/></xsl:variable>
											<li>
											
											<!--  ==================== COL1: ORDERNR ===================== -->
											<div class="col_1">
												<span class="order_nr"><xsl:number /></span>.
											</div>
											<!--  ==================== COL2: CASE CONTENT ===================== -->
											<div class="col_2">
												<form class="frm_update_case">
													<xsl:attribute name="action">
														<xsl:text>index.php?menuaction=controller.uicase.save_case</xsl:text>
														<xsl:text>&amp;case_id=</xsl:text>
														<xsl:value-of select="id"/>
														<xsl:text>&amp;check_list_id=</xsl:text>
														<xsl:value-of select="//check_list/id"/>
														<xsl:text>&amp;phpgw_return_as=json</xsl:text>
													</xsl:attribute>
												
													<textarea name="case_descr"><xsl:value-of select="descr"/></textarea>
													<div>
														<input class='btn_m' type='submit' value='Oppdater' /><input class='btn_m cancel' type='button' value='Avbryt' />
													</div>
												</form>
												<div class="case_info">
													<div class="case_descr"><xsl:value-of select="descr"/></div>
													<div class="quick_menu">
															<a class="quick_edit_case first" href="">
																endre
															</a>
															<a class="close_case">
																<xsl:attribute name="href">
																	<xsl:text>index.php?menuaction=controller.uicase.close_case</xsl:text>
																	<xsl:text>&amp;case_id=</xsl:text>
																	<xsl:value-of select="id"/>
																	<xsl:text>&amp;check_list_id=</xsl:text>
																	<xsl:value-of select="//check_list/id"/>
																	<xsl:text>&amp;phpgw_return_as=json</xsl:text>
																</xsl:attribute>
																lukk
															</a>
															<xsl:choose>
																<xsl:when test="location_item_id = 0">
																	<a class="delete_case">
																		<xsl:attribute name="href">
																			<xsl:text>index.php?menuaction=controller.uicase.delete_case</xsl:text>
																			<xsl:text>&amp;case_id=</xsl:text>
																			<xsl:value-of select="id"/>
																			<xsl:text>&amp;check_list_id=</xsl:text>
																			<xsl:value-of select="//check_list/id"/>
																			<xsl:text>&amp;phpgw_return_as=json</xsl:text>
																		</xsl:attribute>
																		slett
																	</a>
																</xsl:when>
															</xsl:choose>
														</div>
													</div>
												</div>
												<!--  ==================== COL3: MESSAGE LINK ===================== -->
												<div class="col_3">
												
													<xsl:choose>
														<xsl:when test="location_item_id > 0">
															<a target="_blank">
																	<xsl:attribute name="href">
																		<xsl:text>index.php?menuaction=property.uitts.view</xsl:text>
																		<xsl:text>&amp;id=</xsl:text>
																		<xsl:value-of select="location_item_id"/>
																	</xsl:attribute>
																	Vis melding
																</a>
														</xsl:when>
														<xsl:otherwise>
															<span class="message">Ingen melding</span>
														</xsl:otherwise>
													</xsl:choose>
												</div>
											</li>
											</xsl:for-each>
										</ul>
																
					 					</li>
									</xsl:when>	
										</xsl:choose>
										</xsl:when>
						 				<xsl:when test="control_item/type = 'control_item_type_2'">
						 					<h4><span><xsl:value-of select="control_item/title"/></span>(Måling)</h4>
									 		<span class="control_item_type ext_info"><xsl:value-of select="control_item/type" /></span>
									 		<ul>
												<xsl:for-each select="cases_array">
													<xsl:variable name="cases_id"><xsl:value-of select="id"/></xsl:variable>
													<li>
													
													<!--  ==================== COL1: ORDERNR ===================== -->
													<div class="col_1">
														<span class="order_nr"><xsl:number /></span>.
													</div>
													
													<!--  ==================== COL2: CASE CONTENT ===================== -->
													<div class="col_2">
													
													<!--  =============== SHOW CASE INFO ==================== -->
													<div class="case_info">
														<!-- STATUS -->
														<div class="row first">
															<label>Status:</label>
															<span class="case_status">
																<xsl:choose>
																	<xsl:when test="status = 0">Åpen</xsl:when>
																	<xsl:when test="status = 1">Lukket</xsl:when>
																	<xsl:when test="status = 2">Venter på tilbakemelding</xsl:when>
																</xsl:choose>
															</span>
														</div>
														<!--  MEASUREMENT -->
														<div class="row">
															<label>Måleverdi:</label> 
															<span class="measurement"><xsl:value-of select="measurement"/></span>
														</div>
														<!--  DESCRIPTION -->
														<div class="row">
															<label>Beskrivelse:</label> 
														</div>
														<div class="case_descr"><xsl:value-of select="descr"/></div>
														
														<!-- === QUICK EDIT MENU === -->
														<div class="quick_menu">
																<a class="quick_edit_case" href="">
																	endre
																</a>
																<a class="close_case">
																	<xsl:attribute name="href">
																		<xsl:text>index.php?menuaction=controller.uicase.close_case</xsl:text>
																		<xsl:text>&amp;case_id=</xsl:text>
																		<xsl:value-of select="id"/>
																		<xsl:text>&amp;check_list_id=</xsl:text>
																		<xsl:value-of select="//check_list/id"/>
																		<xsl:text>&amp;phpgw_return_as=json</xsl:text>
																	</xsl:attribute>
																	lukk
																</a>
																<xsl:choose>
																	<xsl:when test="location_item_id = 0">
																		<a class="delete_case">
																			<xsl:attribute name="href">
																				<xsl:text>index.php?menuaction=controller.uicase.delete_case</xsl:text>
																				<xsl:text>&amp;case_id=</xsl:text>
																				<xsl:value-of select="id"/>
																				<xsl:text>&amp;check_list_id=</xsl:text>
																				<xsl:value-of select="//check_list/id"/>
																				<xsl:text>&amp;phpgw_return_as=json</xsl:text>
																			</xsl:attribute>
																			slett
																		</a>
																	</xsl:when>
																</xsl:choose>
															</div>
														</div>
														<!--  =================== UPDATE CASE FORM =================== -->
													<form class="frm_update_case">
														<xsl:attribute name="action">
															<xsl:text>index.php?menuaction=controller.uicase.save_case</xsl:text>
															<xsl:text>&amp;case_id=</xsl:text>
															<xsl:value-of select="id"/>
															<xsl:text>&amp;check_list_id=</xsl:text>
															<xsl:value-of select="//check_list/id"/>
															<xsl:text>&amp;phpgw_return_as=json</xsl:text>
														</xsl:attribute>
																									
														<!--  STATUS -->
														<div class="row first">
															<label>Status:</label> 
															<select name="case_status">
																<xsl:choose>
																	<xsl:when test="status = 0">
																		<option value="0" SELECTED="SELECTED">Åpen</option>
																		<option value="2">Venter på tilbakemelding</option>	
																	</xsl:when>
																	<xsl:when test="status = 1">
																		<option value="0">Åpen</option>
																		<option value="2">Venter på tilbakemelding</option>	
																	</xsl:when>
																	<xsl:when test="status = 2">
																		<option value="0">Åpen</option>
																		<option value="2" SELECTED="SELECTED">Venter på tilbakemelding</option>
																	</xsl:when>
																</xsl:choose>
															</select>
														</div>
														<!--  MEASUREMENT -->
														<div class="row">
															<label>Måleverdi:</label> 
															<input type="text" name="measurement">
															<xsl:attribute name="value"><xsl:value-of select="measurement"/></xsl:attribute>
															</input>
														</div>
														<!--  DESCRIPTION -->
														<label>Beskrivelse:</label>
														<div class="row"> 
															<textarea name="case_descr"><xsl:value-of select="descr"/></textarea>
														</div>
														<div>
															<input class='btn_m' type='submit' value='Oppdater' /><input class='btn_m cancel' type='button' value='Avbryt' />
														</div>
													</form>
													</div>
														
													<!--  ==================== COL3: MESSAGE LINK ===================== -->
													<div class="col_3">
														<xsl:choose>
															<xsl:when test="location_item_id > 0">
																<a target="_blank">
																		<xsl:attribute name="href">
																			<xsl:text>index.php?menuaction=property.uitts.view</xsl:text>
																			<xsl:text>&amp;id=</xsl:text>
																			<xsl:value-of select="location_item_id"/>
																		</xsl:attribute>
																		Vis melding
																	</a>
															</xsl:when>
															<xsl:otherwise>
																<span class="message">Ingen melding</span>
															</xsl:otherwise>
														</xsl:choose>
													</div>
													</li>
												</xsl:for-each>
											</ul>
						 				</xsl:when>
						 				<xsl:when test="control_item/type = 'control_item_type_3' or control_item/type = 'control_item_type_4'">
						 				<h4><span><xsl:value-of select="control_item/title"/></span>(Måling)</h4>
									 		<span class="control_item_type ext_info"><xsl:value-of select="control_item/type" /></span>
									 		<ul>
												<xsl:for-each select="cases_array">
													<xsl:variable name="cases_id"><xsl:value-of select="id"/></xsl:variable>
													<li>
													
													<!--  ==================== COL1: ORDERNR ===================== -->
													<div class="col_1">
														<span class="order_nr"><xsl:number /></span>.
													</div>
													
													<!--  ==================== COL2: CASE CONTENT ===================== -->
													<div class="col_2">
													
													<!--  =============== SHOW CASE INFO ==================== -->
													<div class="case_info">
														<!-- STATUS -->
														<div class="row first">
															<label>Status:</label>
															<span class="case_status">
																<xsl:choose>
																	<xsl:when test="status = 0">Åpen</xsl:when>
																	<xsl:when test="status = 1">Lukket</xsl:when>
																	<xsl:when test="status = 2">Venter på tilbakemelding</xsl:when>
																</xsl:choose>
															</span>
														</div>
														<!--  MEASUREMENT -->
														<div class="row">
															<label>Måleverdi:</label> 
															<span class="measurement"><xsl:value-of select="measurement"/></span>
														</div>
														<!--  DESCRIPTION -->
														<div class="row">
															<label>Beskrivelse:</label> 
														</div>
														<div class="case_descr"><xsl:value-of select="descr"/></div>
														
														<!-- === QUICK EDIT MENU === -->
														<div class="quick_menu">
																<a class="quick_edit_case" href="">
																	endre
																</a>
																<a class="close_case">
																	<xsl:attribute name="href">
																		<xsl:text>index.php?menuaction=controller.uicase.close_case</xsl:text>
																		<xsl:text>&amp;case_id=</xsl:text>
																		<xsl:value-of select="id"/>
																		<xsl:text>&amp;check_list_id=</xsl:text>
																		<xsl:value-of select="//check_list/id"/>
																		<xsl:text>&amp;phpgw_return_as=json</xsl:text>
																	</xsl:attribute>
																	lukk
																</a>
																<xsl:choose>
																	<xsl:when test="location_item_id = 0">
																		<a class="delete_case">
																			<xsl:attribute name="href">
																				<xsl:text>index.php?menuaction=controller.uicase.delete_case</xsl:text>
																				<xsl:text>&amp;case_id=</xsl:text>
																				<xsl:value-of select="id"/>
																				<xsl:text>&amp;check_list_id=</xsl:text>
																				<xsl:value-of select="//check_list/id"/>
																				<xsl:text>&amp;phpgw_return_as=json</xsl:text>
																			</xsl:attribute>
																			slett
																		</a>
																	</xsl:when>
																</xsl:choose>
															</div>
														</div>
														<!--  =================== UPDATE CASE FORM =================== -->
													<form class="frm_update_case">
														<xsl:attribute name="action">
															<xsl:text>index.php?menuaction=controller.uicase.save_case</xsl:text>
															<xsl:text>&amp;case_id=</xsl:text>
															<xsl:value-of select="id"/>
															<xsl:text>&amp;check_list_id=</xsl:text>
															<xsl:value-of select="//check_list/id"/>
															<xsl:text>&amp;phpgw_return_as=json</xsl:text>
														</xsl:attribute>
																									
														<!--  STATUS -->
														<div class="row first">
															<label>Status:</label> 
															<select name="case_status">
																<xsl:choose>
																	<xsl:when test="status = 0">
																		<option value="0" SELECTED="SELECTED">Åpen</option>
																		<option value="2">Venter på tilbakemelding</option>	
																	</xsl:when>
																	<xsl:when test="status = 1">
																		<option value="0">Åpen</option>
																		<option value="2">Venter på tilbakemelding</option>	
																	</xsl:when>
																	<xsl:when test="status = 2">
																		<option value="0">Åpen</option>
																		<option value="2" SELECTED="SELECTED">Venter på tilbakemelding</option>
																	</xsl:when>
																</xsl:choose>
															</select>
														</div>
														<!--  MEASUREMENT -->
														<div class="row">
															 <label class="comment">Velg verdi fra liste</label>
												         	<select name="option_value">
												         		<xsl:for-each select="../control_item/options_array">
												         			<option>
																		<xsl:attribute name="value"><xsl:value-of select="option_value"/></xsl:attribute>
																		<xsl:value-of select="option_value"/>
																	</option>	
																</xsl:for-each>
													   		</select>
														</div>
														<!--  DESCRIPTION -->
														<label>Beskrivelse:</label>
														<div class="row"> 
															<textarea name="case_descr"><xsl:value-of select="descr"/></textarea>
														</div>
														<div>
															<input class='btn_m' type='submit' value='Oppdater' /><input class='btn_m cancel' type='button' value='Avbryt' />
														</div>
													</form>
													</div>
														
													<!--  ==================== COL3: MESSAGE LINK ===================== -->
													<div class="col_3">
														<xsl:choose>
															<xsl:when test="location_item_id > 0">
																<a target="_blank">
																		<xsl:attribute name="href">
																			<xsl:text>index.php?menuaction=property.uitts.view</xsl:text>
																			<xsl:text>&amp;id=</xsl:text>
																			<xsl:value-of select="location_item_id"/>
																		</xsl:attribute>
																		Vis melding
																	</a>
															</xsl:when>
															<xsl:otherwise>
																<span class="message">Ingen melding</span>
															</xsl:otherwise>
														</xsl:choose>
													</div>
													</li>
												</xsl:for-each>
											</ul>
						 				</xsl:when>
						 			</xsl:choose>
					</xsl:for-each>
				</ul>
			</xsl:when>
			<xsl:otherwise>
				<p>Ingen åpne saker eller målinger</p>
			</xsl:otherwise>
		</xsl:choose>
	</div>
</div>
</xsl:template>