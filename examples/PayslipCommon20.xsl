<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="#all">
	<xsl:output version="4.0" method="html" indent="yes" encoding="ISO-8859-15" use-character-maps="spaces" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" doctype-system="http://www.w3.org/TR/html4/loose.dtd"/>
	<xsl:template match="/">
		<html>
			<head>
				<title><xsl:value-of select="Payslips/Payslip[1]/HeaderData/DocumentTitle/Value"/></title>
				
				<style type="text/css">
					body{font-family:"Helvetica Neue",Helvetica,Arial,sans-serif;font-size:14px;margin:10px 20px;background-color:#fbfafa}@media all{.page-break{display:none}.page-divider{border:1px inset #ddd;width:100%;margin:20px 0}}@media print{.page-break{display:block;page-break-before:always}.page-divider{display:none}body{font-size:12px}}div{display:block}table{display:table}.table{border-spacing:0;border-collapse:collapse;border:0}table .firstColumn{width:40%}.table-striped>tbody>tr:nth-child(odd)>td,.table-striped>tbody>tr:nth-child(odd)>th{background-color:#f1f1f1}table>thead{line-height:200%;font-weight:700;vertical-align:bottom}h1{font-size:20px;font-weight:700;margin:10px 0}hr{border:1px solid #ddd}.logo{font-size:16px;margin-top:10px;line-height:18px}td#LineHeading{vertical-align:bottom}#Header{margin-bottom:10px}#Header>div,#Summary>div,#Footer>div{width:50%}#Footer>div{width:48%}#Address{margin-top:10px;line-height:20px}.dividerLeft{border-left:1px solid #e1e1e1;padding-left:15px;}.wide{width:100%}.half{width:50%}.semi-narrow{width:33%}.narrow{width:25%}.pull-up{vertical-align:top}.pull-right{float:right}.pull-left{float:left}.clearfix{*zoom:1}.clearfix:before,.clearfix:after{display:table;content:""}.clearfix:after{clear:both}.bevel{min-height:20px;padding:19px;margin-bottom:20px;background-color:#f9f9f9;border:1px solid #e3e3e3;-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px;-webkit-box-shadow:inset 0 1px 1px rgba(0,0,0,.05);-moz-box-shadow:inset 0 1px 1px rgba(0,0,0,.05);box-shadow:inset 0 1px 1px rgba(0,0,0,.05)}.message{padding:0 35px 10px 14px;margin-bottom:20px;background-color:#d9edf7;border:1px solid #bce8f1;-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px}.panel{margin-bottom:21px;background-color:#fff;border:1px solid transparent;border-radius:4px;-webkit-box-shadow:0 1px 1px rgba(0,0,0,.05);box-shadow:0 1px 1px rgba(0,0,0,.05)}.panel-heading{padding:10px 15px;border-bottom:1px solid transparent;border-top-right-radius:3px;border-top-left-radius:3px;font-weight:700}.panel-body{padding:15px}.panel-default{border-color:#ecf0f1}.panel-default>.panel-heading{color:#344;background-color:#ebeff0;border-color:#ecf0f1}.panel-default>.panel-heading+.panel-collapse .panel-body{border-top-color:#ecf0f1}.panel-default>.panel-footer+.panel-collapse .panel-body{border-bottom-color:#ecf0f1}.valueColumn{text-align: right;} #HeaderData > table td {vertical-align:top;} #SalaryDetails > tbody > tr > td {padding-right: 15px;} @media print{#Footer{page-break-inside: avoid; display:block;}}

				</style>
			</head>
			<body>
				<xsl:for-each select="/">
					<xsl:for-each select="Payslips">
						<xsl:for-each select="Payslip">

							<!-- Add a separator, if multiple Payslips are being visualized -->
							<xsl:if test="not(position()=1)">
								<div class="page-divider"/>
								<div class="page-break"/>
							</xsl:if>
							<!-- Header contains the sender "logo" and payslip document header + date -->
							<div id="Header" class="wide clearfix">
								<div class="logo pull-left">
									<xsl:for-each select="Delivery">
										<strong><xsl:value-of select="Sender/Name[1]"/></strong><br/>	
										<xsl:if test="string-length(Sender/Name[2]) >= 1">
											<strong><xsl:value-of select="Sender/Name[2]"/></strong><br/>	
										</xsl:if>
										<!-- Print out the address lines delimited by comma -->
										<xsl:for-each select="Sender/AddressLine">
											<xsl:if test="string-length(.) >= 1">
												<!-- Omit the delimiting comma on the first address line -->
												<xsl:if test="position() != 1"><xsl:text>, </xsl:text></xsl:if>
												<small><xsl:value-of select="."/></small>
											</xsl:if>
										</xsl:for-each>
										<small>
										<!-- If multiple address lines were present print the postcode on a new line, otherwise separate with comma -->
										<xsl:choose>
											<xsl:when test="string-length(Sender/AddressLine[2]) >= 1">
												<br/>
											</xsl:when>
											<xsl:when test="string-length(Sender/AddressLine[3]) >= 1">
												<br/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>, </xsl:text>
											</xsl:otherwise>
										</xsl:choose>
										<!-- Print the country code prefix only if it is defined -->
										<xsl:if test="string-length(Sender/CountryCode) >= 1">
											<xsl:value-of select="Sender/CountryCode"/>
											<xsl:text>-</xsl:text>
										</xsl:if>
										<xsl:value-of select="Sender/PostalCode"/>&#160;<xsl:value-of select="Sender/PostOffice" />
										<xsl:if test="string-length(Sender/Country) >= 1">
											<xsl:text>, </xsl:text>
											<xsl:value-of select="Sender/Country"/>
										</xsl:if>
										</small>
									</xsl:for-each>
								</div>
								<!-- Extract and format the payslip date from the header timestamp -->
								<div class="pull-right">
									<h1><xsl:value-of select="HeaderData/DocumentTitle/Value[1]"/></h1>
									<h1><xsl:value-of select="HeaderData/DocumentTitle/Value[2]"/></h1>
									<!-- <xsl:value-of select="substring(HeaderData/Timestamp,7,2)"/>
									<xsl:text>.</xsl:text>
									<xsl:value-of select="substring(HeaderData/Timestamp,5,2)"/>
									<xsl:text>.</xsl:text>
									<xsl:value-of select="substring(HeaderData/Timestamp,1,4)"/> -->
								</div>
							</div>
							<div id="Summary" class="wide clearfix">
								<!-- Recipient details are positioned as a mailed letter would have them. -->
								<div id="Address" class="pull-left">
									<strong><small><xsl:value-of select="Delivery/Recipient/Heading"/><br/></small></strong>
									<xsl:value-of select="Delivery/Recipient/RecipientName/SurName"/>&#160;<xsl:value-of select="Delivery/Recipient/RecipientName/ForeName"/>
									<br/>
									<xsl:for-each select="Delivery/Recipient/AddressLine">
										<xsl:value-of select="."/>
										<xsl:if test="not(position()=last())">
											<br/>
										</xsl:if>
									</xsl:for-each>
									<br/>
									<xsl:value-of select="Delivery/Recipient/PostalCode"/>&#160;<xsl:value-of select="Delivery/Recipient/PostOffice"/>
									<br/>
									<xsl:value-of select="Delivery/Recipient/Country"/>
								</div>
								<!-- Summarized header information in top-right corner of the document -->
								<div id="HeaderData" class="pull-right">
									<table class="wide bevel">
										<!-- <thead>
											<tr>
												<td></td>
												<td></td>
											</tr>
										</thead> -->
										<tbody>
											<tr>
												<td></td>
												<td>
													<xsl:choose>
														<xsl:when test="Employee/EmployeeName/ForeName = ''">
															<xsl:value-of select="Delivery/Recipient/RecipientName/ForeName"/>&#160;
															<xsl:value-of select="Delivery/Recipient/RecipientName/SurName"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="Employee/EmployeeName/ForeName"/>&#160;
															<xsl:value-of select="Employee/EmployeeName/SurName"/>																		
														</xsl:otherwise>
													</xsl:choose>
												</td>

											</tr>
											<tr>
												<td><xsl:value-of select="Employee/Identity/Label"/></td>
												<td>
													<xsl:value-of select="Employee/Identity/EmployeeIdentity/PersonID"/>
												</td>
											</tr>
											<tr>
												<td><xsl:value-of select="Employee/PersonNumber/Label"/></td>
												<td>
													<xsl:value-of select="Employee/PersonNumber/Value"/>
												</td>
											</tr>											
											
											<tr>
												<td><xsl:value-of select="Employee/TaxNumber/Label"/></td>
												<td>
													<xsl:value-of select="Employee/TaxNumber/Value"/>
												</td>
											</tr>
											<tr>
												<td>
													<xsl:for-each select="PayPeriod/DateOfPayment/Label">
														<xsl:choose>
															<xsl:when test=". != ''">
																<xsl:value-of select="."/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:text></xsl:text>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:for-each>
												</td>
												<td>
													<xsl:value-of select="PayPeriod/DateOfPayment/Date"/>
												</td>
											</tr>
											<tr>
												<td><xsl:value-of select="PayPeriod/Period/Label"/></td>
												<td><xsl:value-of select="PayPeriod/Period/PeriodCode"/></td>
											</tr>
											<tr>
												<td><xsl:value-of select="PayPeriod/PeriodDates/Label"/></td>
												<td>
													<xsl:value-of select="PayPeriod/PeriodDates/StartDate/Date"/>
													<xsl:text> - </xsl:text>
													<xsl:value-of select="PayPeriod/PeriodDates/TermDate/Date"/>
												</td>
											</tr>
											<xsl:for-each select="Employee/EmploymentDate">
												<tr>
													<td><xsl:value-of select="./Label"/></td>
													<td>
														<xsl:value-of select="./Value"/>
														
													</td>
												</tr>
											</xsl:for-each>
											<tr>
												<td><xsl:value-of select="Employee/EmploymentEndDate/Label"/></td>
												<td>
													<xsl:value-of select="Employee/EmploymentEndDate/Value"/>
													
												</td>
											</tr>

											<xsl:if test="string-length(Employee/Classification/JobTitle/Value) > 0">
												<tr>
													<td><xsl:value-of select="Employee/Classification/JobTitle/Label"/></td>
													<td>
														<xsl:value-of select="Employee/Classification/JobTitle/Value"/>
													</td>
												</tr>
											</xsl:if>
											<xsl:if test="string-length(Employee/Classification/DeptCode/Value) > 0">
												<tr>
													<td><xsl:value-of select="Employee/Classification/DeptCode/Label"/></td>
													<td>
														<xsl:value-of select="Employee/Classification/DeptCode/Value"/>
													</td>
												</tr>
											</xsl:if>
											<xsl:if test="string-length(Employee/Classification/CostFollowUp/Value) > 0">
												<tr>
													<td><xsl:value-of select="Employee/Classification/CostFollowUp/Label"/></td>
													<td>
														<xsl:value-of select="Employee/Classification/CostFollowUp/Value"/>
													</td>
												</tr>
											</xsl:if>
											<xsl:if test="string-length(Employee/PaymentType/Value) > 0">
												<tr>
													<td><xsl:value-of select="Employee/PaymentType/Label"/></td>
													<td>
														<xsl:value-of select="Employee/PaymentType/Value"/>
													</td>
												</tr>
											</xsl:if>
											<xsl:for-each select="BankAccount/AccountCode">
												<tr>
													<td>
														<xsl:value-of select="./Label"/>
													</td>
													<td>
														
														<xsl:choose>
															<xsl:when test="./Value/@Type = 'IBAN'">
																<xsl:value-of select="substring(./Value,1,4)"/>
																<xsl:text> </xsl:text>
																<xsl:value-of select="substring(./Value,5,4)"/>
																<xsl:text> </xsl:text>
																<xsl:value-of select="substring(./Value,9,4)"/>
																<xsl:text> </xsl:text>
																<xsl:value-of select="substring(./Value,13,4)"/>
																<xsl:text> </xsl:text>
																<xsl:value-of select="substring(./Value,17,4)"/>
																<xsl:text> </xsl:text>
															</xsl:when>
															<xsl:when test="./Value/@Type = 'BBAN'">
																<xsl:value-of select="./Value"/>
															</xsl:when>
															<xsl:otherwise><xsl:value-of select="./Value"/></xsl:otherwise>
														</xsl:choose>
														<br/>
														<xsl:value-of select="./BIC"/>
													</td>
												</tr>
											</xsl:for-each>
											<tr>
												<td></td>
												<td></td>
											</tr>
											<tr>
												<td><strong><xsl:value-of select="HeaderData/NetPayment/Label"/></strong></td>
												<td><strong><xsl:value-of select="HeaderData/NetPayment/Value"/></strong></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							
							<div class="clearfix"/>															
							<!-- Pay detail panel -section -->
							<div class="panel panel-default">
								<div class="panel-heading"><xsl:value-of select="PayDetails/Heading"/></div>
								
								<!-- Determine if Paycode -element is present on any of the DetailLines -->
								<xsl:variable name="PayCodeCount" select="count(PayDetails/DetailLines/DetailLine/PayCode)" />

								<table id="PayDetails" class="wide panel-body">
									<thead>
										<xsl:for-each select="PayDetails/DetailLines/HeadingLine">
											<tr>
												<xsl:for-each select="Heading">
													<!-- Add PayCode column as a value column and consider the second column as the line heading column -->
													<xsl:if test="$PayCodeCount &gt; 0">
														<xsl:if test="position()=1">
															<td><xsl:value-of select="."/></td>	
														</xsl:if>
														<xsl:if test="position()=2">
															<td class="firstColumn"><xsl:value-of select="."/></td>	
														</xsl:if>
														<xsl:if test="position() &gt; 2">
															<td class="valueColumn"><xsl:value-of select="."/></td>	
														</xsl:if>
													</xsl:if>
													<!-- PayCode column was not present, thus the first column is the line heading column -->
													<xsl:if test="$PayCodeCount &lt; 1">
														<xsl:if test="position()=1">
															<td class="firstColumn"><xsl:value-of select="."/></td>	
														</xsl:if>
														<xsl:if test="position() &gt; 1">
															<td class="valueColumn"><xsl:value-of select="."/></td>	
														</xsl:if>
													</xsl:if>
												</xsl:for-each>
											</tr>
										</xsl:for-each>
									</thead>
									<tbody>
										<xsl:for-each select="PayDetails/DetailLines/DetailLine">
											<tr>
												<!-- Add the PayCode column if any PayCode elements were found in the table -->
												<xsl:if test="$PayCodeCount &gt; 0">
													<td><xsl:value-of select="PayCode"/></td>
												</xsl:if>
												<td class="firstColumn"><xsl:value-of select="Description"/></td>
												<xsl:for-each select="Value">
													<td class="valueColumn"><xsl:value-of select="."/></td>	
												</xsl:for-each>
												<td class="valueColumn"><xsl:value-of select="Amount"/></td>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
							</div>
							<!-- Page break, if printed -->
							<div class="page-break"/>
							<!-- Salary details panel -section -->
							<div class="panel panel-default wide">
								<div class="panel-heading"><xsl:value-of select="CalculationBases/Heading"/></div>
								<table id="SalaryDetails" class="wide panel-body" >
									<tbody>
										<tr>
											<td class="pull-up">
												<table class="table wide">
													<thead>
														<tr>
															<td><xsl:value-of select="Employee/SalaryCategories/Heading"/></td>
															<td></td>
														</tr>
													</thead>
													<tbody>
														<xsl:for-each select="Employee/SalaryCategories/SalaryCategory">
															<tr>
																<td><xsl:value-of select="Label"/></td>
																<td class="valueColumn"><xsl:value-of select="Value"/></td>
															</tr>
														</xsl:for-each>
													</tbody>
												</table>
											</td>
											<td class="pull-up dividerLeft">
												<table class="table wide">
													<thead>
														<tr>
															<td><xsl:value-of select="CalculationBases/SalaryRates/Heading"/></td>
															<td></td>
														</tr>
													</thead>
													<tbody>
													<xsl:for-each select="CalculationBases/SalaryRates/Record">
														<tr>
															<td><xsl:value-of select="Label"/></td>
															<td class="valueColumn"><xsl:value-of select="Value"/></td>
														</tr>
													</xsl:for-each>
													</tbody>
												</table>
											</td>
											<td class="pull-up dividerLeft">
												<table class="table wide">
													<thead>
														<tr>
															<td><xsl:value-of select="CalculationBases/TaxationRates/Heading"/></td>
															<td></td>
														</tr>
													</thead>
													<tbody>
													<xsl:for-each select="CalculationBases/TaxationRates/Record">
														<tr>
															<td><xsl:value-of select="Label"/></td>
															<td class="valueColumn"><xsl:value-of select="Value"/></td>
														</tr>
													</xsl:for-each>
													</tbody>
												</table>
											</td>
										</tr>

										<tr>
											<td class="pull-up">
												<table class="table wide">
													<thead>
														<tr>
															<td><xsl:value-of select="CalculationBases/DeductionRates/Heading"/></td>
															<td></td>
														</tr>
													</thead>
													<tbody>
													<xsl:for-each select="CalculationBases/DeductionRates/Record">
														<tr>
															<td><xsl:value-of select="Label"/></td>
															<td class="valueColumn"><xsl:value-of select="Value"/></td>
														</tr>
													</xsl:for-each>
													</tbody>
												</table>
											</td>
											<td class="pull-up dividerLeft">
												<table class="table wide">
													<thead>
														<tr>
															<td><xsl:value-of select="CalculationBases/VacationRecords/Heading"/></td>
															<td></td>
														</tr>
													</thead>
													<tbody>
														<xsl:for-each select="CalculationBases/VacationRecords/Record">
															<tr>
																<td><xsl:value-of select="Label"/></td>
																<td class="valueColumn"><xsl:value-of select="Value"/></td>
															</tr>
														</xsl:for-each>
													</tbody>
												</table>
											</td>
										</tr>
									</tbody>
								</table>
							</div>

							<!-- Optional message section -->
							<div id="Messages" class="message">
								<xsl:for-each select="Messages">
									<h3><xsl:value-of select="Heading"/></h3>
									<table class="table">
										<tbody>
											<xsl:for-each select="Permanent">
												<tr>
													<td><xsl:value-of select="Label"/></td>
													<td><xsl:value-of select="Value"/></td>
												</tr>	
											</xsl:for-each>
											<xsl:for-each select="Transient">
												<tr>
													<td><xsl:value-of select="Label"/></td>
													<td><xsl:value-of select="Value"/></td>
												</tr>	
											</xsl:for-each>										
										</tbody>
									</table>
								</xsl:for-each>	
							</div>							
							<!-- Earnings to date -section -->
							<div class="panel panel-default">
								<div class="panel-heading"><xsl:value-of select="EarningsToDate/Heading"/></div>

								
								<!-- Generate the dynamic earnings table as defined in the secifications-->
								<table id="EarningsToDate" class="wide panel-body">
									<xsl:for-each select="EarningsToDate/Set">
										<thead>
											<!-- Optional line headings -->
											<xsl:for-each select="SetHeading">
												<tr>
													<xsl:for-each select="Heading">
														<xsl:if test="position()=1">
															<td class=""><strong><xsl:value-of select="."/></strong></td>	
														</xsl:if>
														<xsl:if test="position() &gt; 1">
															<td class="valueColumn"><strong><xsl:value-of select="."/></strong></td>	
														</xsl:if>
														
													</xsl:for-each>
												</tr>
											</xsl:for-each>
										</thead>
								
										<tbody>
											<!-- Lines -->
											<xsl:for-each select="Line">
												<!-- Generate a separate row for the cell labels (headings), if any labels have been defined -->
												<xsl:if test="count(Cell/Label[.!='']) &gt; 0">
													<tr style="">
														<td id="LineHeading"></td> <!-- Empty line heading cell -->
														<xsl:for-each select="Cell">
															<td class="valueColumn pull-up">
																<i><xsl:value-of select="Label"/></i>
															</td>
														</xsl:for-each>	
													</tr>
												</xsl:if>
												<!-- Generate a row containing the line heading and the actual cell values -->
												<tr style="">
													<td id="LineHeading"><xsl:value-of select="LineHeading"/></td>
													<xsl:for-each select="Cell">
														<td class="valueColumn pull-up">
															<xsl:value-of select="Value"/>
														</td>
													</xsl:for-each>
												</tr>
											</xsl:for-each>
										</tbody>
									</xsl:for-each>
									
								</table>
							</div>
													
							
							<hr/>
							<!-- Sender and optional pay office details are positioned in to the footer -->
							<div id="Footer" class="wide clearfix">
								<div class="pull-left ">
									<div class="bevel">
										<strong><xsl:value-of select="Delivery/Sender/Heading"/></strong><br/>
										<xsl:value-of select="Delivery/Sender/Name[1]"/><br/>
										<xsl:if test="string-length(Delivery/Sender/Name[2]) >= 1">
											<xsl:value-of select="Delivery/Sender/Name[2]"/><br/>
										</xsl:if>
										<xsl:for-each select="Delivery/Sender/AddressLine">
											<xsl:if test="string-length(.) >0">
												<xsl:value-of select="."/><br/>
											</xsl:if>
										</xsl:for-each>
										<xsl:if test="string-length(Delivery/Sender/CountryCode) >= 1">
											<xsl:value-of select="Delivery/Sender/CountryCode"/>
											<xsl:text>-</xsl:text>
										</xsl:if>
										<xsl:value-of select="Delivery/Sender/PostalCode"/>&#160;<xsl:value-of select="Delivery/Sender/PostOffice"/>
										<xsl:if test="string-length(Delivery/Sender/Country) >= 1">
											<xsl:text>, </xsl:text><xsl:value-of select="Delivery/Sender/Country"/>
										</xsl:if>
										<br/><br/>
										<xsl:for-each select="Delivery/Sender/Telephone/PhoneNumber">
												<xsl:value-of select="."/><br/>
											</xsl:for-each>
										<xsl:value-of select="Delivery/Sender/Telephone/MobileNumber"/><br/>
										<xsl:value-of select="Delivery/Sender/EmailAddress"/><br/>
										<xsl:value-of select="HeaderData/PartyIdentifications/PartyIdentificationId/Authority"/>&#160;<xsl:value-of select="HeaderData/PartyIdentifications/PartyIdentificationId/Value"/>
									</div>
								</div>
								<xsl:if test="boolean(Delivery/PayOffice/Name)">
									<div class="pull-right">
										<div class="bevel">
											<strong><xsl:value-of select="Delivery/PayOffice/Heading"/></strong><br/>
											<xsl:value-of select="Delivery/PayOffice/Name[1]"/><br/>
											<xsl:if test="string-length(Delivery/PayOffice/Name[2]) >= 1">
												<xsl:value-of select="Delivery/PayOffice/Name[2]"/><br/>
											</xsl:if>
											<xsl:for-each select="Delivery/PayOffice/AddressLine">
												<xsl:if test="string-length(.) >0">
													<xsl:value-of select="."/><br/>	
												</xsl:if>
											</xsl:for-each>
											<xsl:if test="string-length(Delivery/PayOffice/CountryCode) >= 1">
											<xsl:value-of select="Delivery/PayOffice/CountryCode"/>
											<xsl:text>-</xsl:text>
										</xsl:if>
											<xsl:value-of select="Delivery/PayOffice/PostalCode"/>&#160;<xsl:value-of select="Delivery/PayOffice/PostOffice"/>
											<xsl:if test="string-length(Delivery/PayOffice/Country) >= 1">
												<xsl:text>, </xsl:text><xsl:value-of select="Delivery/PayOffice/Country"/>
											</xsl:if>
											<br/><br/>
											<xsl:for-each select="Delivery/PayOffice/Telephone/PhoneNumber">
												<xsl:value-of select="."/><br/>
											</xsl:for-each>
											<xsl:value-of select="Delivery/PayOffice/Telephone/MobileNumber"/><br/>
											<xsl:value-of select="Delivery/PayOffice/EmailAddress"/><br/>
										</div>			
									</div>
								</xsl:if>
							</div>
						</xsl:for-each>
					</xsl:for-each>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
