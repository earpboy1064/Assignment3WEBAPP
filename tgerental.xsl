<?xml version="1.0" encoding="UTF-8" ?>



<xsl:stylesheet version="2.0"
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:xs="http://www.w3.org/2001/XMLSchema" 
     xmlns:fixt="http://example.com//illumfixtures"
      >
 	<xsl:variable name="rentalsDoc" select = "document('tgerentals.xml')"/>
	<xsl:variable name="toolsDoc" select = "document('tgetools.xml')"/>
	<xsl:variable name="customerDoc" select = "document('tgecustomers.xml')"/>

     <xsl:key name="cKey" match="customer" use="@custID"/>
	 <xsl:key name="tKey" match="tool" use="@toolID"/>
	 
   <xsl:output method="html"
      doctype-system="about:legacy-compat"
      encoding="UTF-8"
      indent="yes" />

   <xsl:template match="/">
   <html>
		<head>
			<title>Test Title</title>
			<link href = "brstyles.css" rel="stylesheet" type = "text/css"/>
		</head>
		<body>
		<h1>Current Rentals</h1>
		<xsl:apply-templates select="rentals/rental"></xsl:apply-templates>
		
		
		Test Body
		<xsl:for-each-group select="rentals/rental" group-by="custID">
		<xsl:sort select= "current-grouping-key()"/>
		<xsl:variable name="custList" select="doc('tgecustomers.xml')/customers/customer [@custID=current-grouping-key()]" />

		<xsl:value-of select= "$custList/firstName" />
		
		
		</xsl:for-each-group>
		cat
		</body>
	</html>
   </xsl:template>


  <xsl:template match="rentals/rental">
   <table class= "head" cellpadding="2">
				<tbody>
				<tr>
					
					<th>Customer</th>
					<th>Tool ID</th>
					<th>Tool</th>
					<th>Category</th>
					<th>Due Back</th>
					<th>Charge</th>
				</tr> 
				<tr>
					<th>					
					<xsl:variable name="cID" select="Customer" /> <!-- creates variable named tID that is the value of tool in rgeRentals--> 
					<xsl:for-each select = "$customerDoc"> <!--selects the tgetools file so we can get the tool data from it.-->
					<!--<xsl:value-of select="key('tKey','EM247-16')"/> -->
					<xsl:value-of select="key('cKey',$cID)/firstName"/>  <!--tKey represents the toolID that we are compairing to the tID which is the tool ID from tgerentals  $ represents that variable not its children-->
					<xsl:value-of select="key('cKey',$cID)/lastName"/> <br />
					<xsl:value-of select="key('cKey',$cID)/street"/> 
					<xsl:value-of select="key('cKey',$cID)/city"/>, 
					<xsl:value-of select="key('cKey',$cID)/state"/> <br />
					<xsl:value-of select="key('cKey',$cID)/ZIP"/> 

					</xsl:for-each>
					</th>
					
					
					<!--<th><xsl:value-of select="Tool"/></th>-->
					
					<th>
					
					<xsl:value-of select="Tool"/>
					
					</th>
					
					
					<th>
							
						<xsl:variable name="tID" select="Tool" /> <!-- creates variable named tID that is the value of tool in rgeRentals--> 
							<xsl:for-each select = "$toolsDoc"> <!--selects the tgetools file so we can get the tool data from it.-->
							<!--<xsl:value-of select="key('tKey','EM247-16')"/> -->
							<xsl:value-of select="key('tKey',$tID)/description"/><!--tKey represents the toolID that we are compairing to the tID which is the tool ID from tgerentals  $ represents that variable not its children-->
							</xsl:for-each>
					
					</th>
					
					<th>
						<xsl:variable name="tID" select="Tool" /> <!-- creates variable named tID that is the value of tool in rgeRentals--> 
							<xsl:for-each select = "$toolsDoc"> <!--selects the tgetools file so we can get the tool data from it.-->
							<!--<xsl:value-of select="key('tKey','EM247-16')"/> -->
							<xsl:value-of select="key('tKey',$tID)/category"/><!--tKey represents the toolID that we are compairing to the tID which is the tool ID from tgerentals  $ represents that variable not its children-->
							</xsl:for-each>
					</th>
					
					<th>
					

					<!-- This is the date function -->
					<xsl:value-of select= "format-date(fixt:getDate(Days,Weeks,Start_Date), '[D1] [MNn] [Y1]')"/>
					<!--
					Below code not really needed. Its just an example of how to break up the date into day month year. 
					<xsl:variable name="YearValue" select="year-from-date(Start_Date)"/>
					<xsl:variable name="MonthValue" select="month-from-date(Start_Date)"/>
					<xsl:variable name="DayValue" select="day-from-date(Start_Date)"/>
					<xsl:variable name="FormatedDate" select = "format-date(Start_Date, '[D1] [MNn] [Y1]')"/> -->
					
					
<!--<xsl:value-of select="format-date(Start_Date, '[D1] [MNn] [Y1]')" /> -->
<!-- This creates -->

<!--
				<xsl:variable name="TotalDays" select="Days+(Weeks*7)"/>
				
				
				<xsl:variable name="Days" select="concat('P',$TotalDays,'D')"/>


				<xsl:variable name="updatedDate" select="xs:date(Start_Date) + xs:dayTimeDuration($Days)"/>

                    
                     <xsl:value-of select="format-date($updatedDate, '[D1] [MNn] [Y1]')" />
                     -->
                     <!--
                     <br>Total Days  <xsl:value-of select="$TotalDays"/>
</br>
                    -->
					<!-- This prints the start date for comparison. <xsl:value-of select="Start_Date"/> -->
                    
                    
                    <!--
					<xsl:value-of select="$YearValue"/>
					<xsl:value-of select="$MonthValue"/>
					<xsl:value-of select="$DayValue"/> -->

						<!-- Due back -->
					</th>
					<th>
					Test
					
					
						 <xsl:variable name="tID" select="Tool" /> <!-- creates variable named tID that is the value of tool in rgeRentals--> 
							<xsl:for-each select = "$toolsDoc"> <!--selects the tgetools file so we can get the tool data from it.-->
											<xsl:variable name="Drate" select="key('tKey',$tID)/dailyRate" />
											<xsl:value-of select = "$Drate"/>		
 


							</xsl:for-each>	




					</th>
				</tr>
				
					<!--<tr>
						<th>Tools</th>
						<td><xsl:value-of select="Tool"/></td> We do not need the rentals/rental because we are already at that level i think.
					</tr>-->
				</tbody>
			</table> 
			
  
   </xsl:template>
   
   <xsl:function name="fixt:getDate" as="xs:date">
   
	   <xsl:param name="Days" as="xs:integer" />
	   	<xsl:param name="Weeks" as="xs:integer" />	
	   	<xsl:param name="Start_Date" as="xs:date" />	

				
				<xsl:variable name="TotalDays" select="$Days+($Weeks*7)"/>

				<xsl:variable name="Days" select="concat('P',$TotalDays,'D')"/>


				<xsl:variable name="updatedDate" as="xs:date" select="xs:date($Start_Date) + xs:dayTimeDuration($Days)"/>

                     <!--<xsl:value-of select="$updatedDate"/>   Not needed-->
                     <xsl:sequence select="$updatedDate" />
                     
   
   </xsl:function>
   
 <!--
 <xsl:template match= "rentals/rental">
  
  <xsl:variable name="yearValue"
   select=day-from-date(xs:date($Start_Date) />
   
 <xsl:variable name="monthValue"
   select=substring-before(substring-after(.,'-'), '-')" />
   
    <xsl:variable name="dayValue"
   select=substring-after(substring-after(.,'-'), '-')" />
 
   <xsl:if test="$dayValue"
 </xsl:template>
 
 -->
</xsl:stylesheet>

