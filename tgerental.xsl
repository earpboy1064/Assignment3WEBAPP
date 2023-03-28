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
		
		
		 <xsl:for-each-group select="rentals/rental" group-by="Start_Date">
               <xsl:sort select="current-grouping-key()" />
               <h1><xsl:value-of select = "current-grouping-key()"/></h1> <!-- 2.b Displaying current key using current-grouping-key()-->

<!--
               <xsl:variable name="custList"
                select="doc('tgecustomers.xml')/customers/customer[@custID=current-grouping-key()]" />

               <h2>Customer ID:
                   <xsl:value-of select="current-grouping-key()" />
               </h2>

               <p>
                  <xsl:value-of select="$custList/firstName" />
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$custList/lastName" /><br />
                  <xsl:value-of select="$custList/street" /><br />
                  <xsl:value-of select="$custList/city" />,
                  <xsl:value-of select="$custList/state" />
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$custList/zip" />
               </p>
		-->
		
		
		
		
   <table id ="rentals" class="head"  cellpadding="2">
                  <thead>                  
                     <tr>
                        <th>Customer</th>
                        <th>Tool ID</th>
                        <th>Tool</th>
                        <th>Category</th>
                        <th>Due Back</th>
                        <th>Charge</th>
                     </tr>
                  </thead>	
                  <tbody>			
       	          <xsl:apply-templates select="current-group()" />
                  </tbody>
               </table>
               
               </xsl:for-each-group>
             
		
		<!--<xsl:apply-templates select="rentals/rental"></xsl:apply-templates> -->
		
		
		
		cat
		</body>
	</html>
   </xsl:template>




 <xsl:template match="rentals/rental">
      <tr>
      <th class = "CustomerCell" >
       <xsl:apply-templates select="rental/Customer" />
       
        <xsl:value-of select= "fixt:CustomerData(Customer)"/>

       
       
       

      </th>
         
         <th class="ToolIDCell">
           <xsl:value-of select="Tool" />
         </th>
         <th class="ToolCell">
			 <xsl:variable name="tID" select="Tool" /> <!-- creates variable named tID that is the value of tool in rgeRentals--> 
							<xsl:for-each select = "$toolsDoc"> <!--selects the tgetools file so we can get the tool data from it.-->
							<!--<xsl:value-of select="key('tKey','EM247-16')"/> -->
							<xsl:value-of select="key('tKey',$tID)/description"/><!--tKey represents the toolID that we are compairing to the tID which is the tool ID from tgerentals  $ represents that variable not its children-->
							</xsl:for-each>
							
            <xsl:apply-templates select="rental/Tool" />
         </th>
         
         <th class="CategoryCell">
			 <xsl:variable name="tID" select="Tool" /> <!-- creates variable named tID that is the value of tool in rgeRentals--> 
							<xsl:for-each select = "$toolsDoc"> <!--selects the tgetools file so we can get the tool data from it.-->
							<!--<xsl:value-of select="key('tKey','EM247-16')"/> -->
							<xsl:value-of select="key('tKey',$tID)/category"/><!--tKey represents the toolID that we are compairing to the tID which is the tool ID from tgerentals  $ represents that variable not its children-->
							</xsl:for-each>
							
			   <xsl:apply-templates select="equipment/toolID" mode="toolCat" />
         </th>

         <th class="ReturnDateCell">
            <xsl:value-of select= "format-date(fixt:getDate(Days,Weeks,Start_Date), '[D1] [MNn] [Y1]')"/>  <!-- 2.d Date format using XPath 2.o picture formats -->

         </th>
         
         <th class="ChargeCell">
               <xsl:value-of select= "fixt:Charge(Days,Weeks,Tool)"/>

         
         </th>

      </tr>

   </xsl:template>


<xsl:template match="rental/Tool">
<xsl:variable name="tgetools"
       select="doc('tgetools.xml')/equipment/tool[Tool=current()]" />
      <xsl:value-of select="current()" />:
      <xsl:value-of select="$tgetools/description" />
      
</xsl:template>

<xsl:template match="toolID" mode="toolCat">
<xsl:variable name="Tool"
       select="doc('tgetools.xml')/equipment/tool[toolID=current()]" />
      <xsl:value-of select="current()" />:
      <xsl:value-of select="$Tool/category" />
      
</xsl:template>




<xsl:template match="Customer">

      <xsl:variable name="custList"
                select="doc('tgecustomers.xml')/customers/customer[@custID=current()]" />

               <h2>Customer ID:
                   <xsl:value-of select="current()" />
               </h2>

               <p>
                  <xsl:value-of select="$custList/firstName" />
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$custList/lastName" /><br />
                  <xsl:value-of select="$custList/street" /><br />
                  <xsl:value-of select="$custList/city" />,
                  <xsl:value-of select="$custList/state" />
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$custList/zip" />
               </p>
 </xsl:template>





      <xsl:function name="fixt:getDate" as="xs:date">
   
	   <xsl:param name="Days" as="xs:integer" />
	   	<xsl:param name="Weeks" as="xs:integer" />	
	   	<xsl:param name="Start_Date" as="xs:date" />	

				
				<xsl:variable name="TotalDays" select="$Days+($Weeks*7)"/>

				<xsl:variable name="Days" select="concat('P',$TotalDays,'D')"/>


				<xsl:variable name="updatedDate" as="xs:date" select="xs:date($Start_Date) + xs:dayTimeDuration($Days)"/>

                     <xsl:sequence select="$updatedDate" />
                     
   
   </xsl:function>
   
   
   
   
   
   
   
   <xsl:function name="fixt:Charge" as="xs:integer"> <!--2e Application of XML Schema Datatype to a function -->
   
	  
	   	<xsl:param name="Days" as="xs:integer" />
	    <xsl:param name="Weeks" as="xs:integer" />	
	    <xsl:param name="tID" as="xs:string" />
	


	 <xsl:variable name="toolList"
                select="doc('tgetools.xml')/equipment/tool[@toolID =  $tID]" />
                
                <xsl:variable name="Drate" as="xs:integer" select="xs:integer($toolList/dailyRate)*$Days" />  <!--2e Application of XML Schema Datatype to a variable -->
                <xsl:variable name="Wrate" as="xs:integer" select="xs:integer($toolList/weeklyRate)*$Weeks" />
				<xsl:variable name="totalRate" as="xs:integer" select="$Drate+$Wrate" />


                <xsl:sequence select="$totalRate" />


				
                
   
   </xsl:function>
   
   
   
   <xsl:function name="fixt:CustomerData" as="xs:string"> <!--2e Application of XML Schema Datatype to a function -->
   
	  
	   	<xsl:param name="Customer" as="xs:string" />
	    
	


	 <xsl:variable name="customer"
                select="doc('tgecustomers.xml')/customers/customer[@custID =  $Customer]" />
                
               
               	<xsl:variable name="custData" as = "xs:string" select="concat($customer/firstName,$customer/lastName,$customer/street,$customer/state,$customer/zip,$customer/phone,$customer/email)"/>


                <xsl:sequence select="$custData" />


				
                
   
   </xsl:function>
   
    




































  <!--<xsl:template match="rentals/rental"> -->
   <xsl:template match="tmp">

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

