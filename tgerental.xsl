<?xml version="1.0" encoding="UTF-8" ?>
<!--
  
Wyatt LeMaster 

   Assignment 3
   Comp 6000 
   
   Generates html file tgerental.html to display customer rentals.
   The customers are grouped by the day they rented the equipment.
   The information shown includes the customer name, tool ID
   tool description, category of the tool, the date the tool us due back,
   the charge for the tool rental.  

   Filename:         tgerentals.xsl
   Supporting Files: tgerentals.xml, tgecustomers.xml, tgetools.xml

-->


<xsl:stylesheet version="2.0"
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:xs="http://www.w3.org/2001/XMLSchema" 
     xmlns:fixt="http://example.com//illumfixtures"
      >
	<xsl:variable name="toolsDoc" select = "document('tgetools.xml')"/>
<!--Note: Documet is only used for getting the data from a file once. Doc is used to collect data in the functions:
fixt:Charge, fixt:CustomerData  --> 


	<xsl:key name="tKey" match="tool" use="@toolID"/>
	 
   <xsl:output method="html"
      doctype-system="about:legacy-compat"
      encoding="UTF-8"
      indent="yes" />

   <xsl:template match="/">
   <html>
		<head>
			<title>The Good Earth</title>
			<link href = "tgeStyle.css" rel="stylesheet" type = "text/css"/>
		</head>
		
		<body>
		
			<header><img src="tgelogo.png"/></header>
		
			<h2 class="center">Current Rentals </h2>
	
			<xsl:for-each-group select="rentals/rental" group-by="Start_Date">
			<!--Grouping key is start date-->
		 
             <xsl:sort select="current-grouping-key()" />
               
            <xsl:variable name="date" select="format-date(xs:date(current-grouping-key()), '[MNn] [D1] [Y1]')"/>
            <!-- 2.d Date format using XPath 2.0 picture formats -->

            <h3><xsl:value-of select = "$date"/></h3> 
            <!-- 2.b Displaying current key using current-grouping-key()-->

		
		
			<table id ="rentals" class = "center" cellpadding="2">
                  <thead>                  
                     <tr>
                        <th class="customerCell"> Customer</th>
                        <th class="toolIDCell">Tool ID</th>
                        <th class="toolCell"> Tool</th>
                        <th class="categoryCell">Category</th>
                        <th class="dueBackCell">Due Back</th>
                        <th class="chargeCell">Charge</th>
                     </tr>
                  </thead>
                  	
                  <tbody >	
                  		
       	          <xsl:apply-templates select="current-group()" /> 
				<!--applies template to the current group which is sorted by start Date -->
       	          
                  </tbody>
                  
            </table>
               
            </xsl:for-each-group>	
		</body>
	</html>
   </xsl:template>




 <xsl:template match="rentals/rental">
      <tr>
      <td class="customerCell">  
        <!-- calls function to display customer information-->    
        <xsl:value-of select= "fixt:CustomerData(Customer)"/>

      </td>
         
        <td class="toolIDCell">
           <!-- displays tool ID--> 
           <xsl:value-of select="Tool" />
           
        </td>
         
        <td class="toolCell">
            <!--This is used to access the description of the tool
			This is using document not Doc but I use doc in the functions so that the requirement is met,
			I wrote this before understanding doc and did not want to lose the work I had done. Hopefully this is okay-->    

			<xsl:variable name="tID" select="Tool" /> 
				<xsl:for-each select = "$toolsDoc"> 
					<xsl:value-of select="key('tKey',$tID)/description"/>
				</xsl:for-each>				
        </td>
         
        <td class="categoryCell">
         
			  <!-- displays tool category--> 
			<xsl:variable name="tID" select="Tool" /> 
				<xsl:for-each select = "$toolsDoc"> 
					<xsl:value-of select="key('tKey',$tID)/category"/>
				</xsl:for-each>				
        </td>

        <td class="dueBackCell">
            <!-- calls function to display date information-->    
            <xsl:value-of select= "format-date(fixt:getDate(Days,Weeks,Start_Date), ' [MNn] [D1]  [Y1]')"/>
            <!-- 2.d Date format using XPath 2.o picture formats -->
         </td>
         
         <td class="chargeCell">
            <!--Uses function fixt:Charge to calculate the total change for the tool --> 
            <xsl:value-of select= "concat('$',fixt:Charge(Days,Weeks,Tool))"/>
         </td>

      </tr>

   </xsl:template>




   <!--Function to calculate the date the tool us due back
       This is done by calculating the total days the user has rented the tool for
       Then adding that time to the date that the user rented the tool on. This 
        results in the date the tool is due back--> 
    <xsl:function name="fixt:getDate" as="xs:date">
   
	   <xsl:param name="Days" as="xs:integer" />
	   <xsl:param name="Weeks" as="xs:integer" />	
	   <xsl:param name="Start_Date" as="xs:date" />	

				
		<xsl:variable name="TotalDays" select="$Days+($Weeks*7)"/>
		<xsl:variable name="Days" select="concat('P',$TotalDays,'D')"/>


		<xsl:variable name="updatedDate" as="xs:date" select="xs:date($Start_Date) + xs:dayTimeDuration($Days)"/>

        <!--variable updatedDate contains the date that the tool us due back--> 
        <xsl:sequence select="$updatedDate" />
                   
   </xsl:function>
   
   
   
   <!--2.e Application of XML Schema Datatype to a function -->
   
   <!--Function calculates the charge for the tool
    This utilizes the dailyRate and weeklyRate for each tool
    along with the amount of time the user has rented the tool-->
   <xsl:function name="fixt:Charge" as="xs:integer"> 
   
	  
	   	<xsl:param name="Days" as="xs:integer" />
	    <xsl:param name="Weeks" as="xs:integer" />	
	    <xsl:param name="tID" as="xs:string" />
	

	<!-- 2.c data value looked up by using doc --> 
		 <xsl:variable name="toolList"
                select="doc('tgetools.xml')/equipment/tool[@toolID =  $tID]" />
                
                <!--2e Application of XML Schema Datatype to a variable -->
         <xsl:variable name="Drate" as="xs:integer" select="xs:integer($toolList/dailyRate)*$Days" />  
         <xsl:variable name="Wrate" as="xs:integer" select="xs:integer($toolList/weeklyRate)*$Weeks" />
		 <xsl:variable name="totalRate" as="xs:integer" select="$Drate+$Wrate" />

         <!--total Rate contains the rate calculated for each tool for the specified amount of time --> 
         <xsl:sequence select="$totalRate" />

   </xsl:function>
   
   
   <!--2.e Application of XML Schema Datatype to a function -->
   <!--Function fetches and concats the data from the user so it can be easy displayed -->
   <xsl:function name="fixt:CustomerData" as="xs:string"> 
   
	  
	<xsl:param name="Customer" as="xs:string" />
	  
	<!--Uses the doc function to navigate and retieve data from the customer file-->
	<xsl:variable name="cust"
                select="doc('tgecustomers.xml')/customers/customer[@custID =  $Customer]" />
                
     
       
    <xsl:variable name="custData" as = "xs:string" select="concat($cust/firstName,' ',$cust/lastName,' ',$cust/street,' ', $cust/city,', ',$cust/state,' ',$cust/ZIP)"/>

	<!--custData contains the customer data that has been concatinated together.-->
    <xsl:sequence select="$custData" />
     
   </xsl:function>
   
  
</xsl:stylesheet>

