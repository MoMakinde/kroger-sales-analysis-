/*****************************************************************************************
   	Nov-Dec 2015

	PROJECT TITLE : LEARNING FROM BIG DATA: AN IMPACT ANALYSIS OF A SALES PROMOTION USING SAS 

   	Author : Palma Daawin

   	Purpose: This program is written as part of a study that seeks to improve on the state of 
	the art of data and provide useful information from the data set from chain store retailer in 
	order to make judgments about the impact of a sales promotion.
	In this program  I specially intend to, Read, extract, organize, manipulate, combine 
	and data prepare data from complicated source and provide summary information using graphs and 
	other summary statistics in SAS.
********************************************************************************************/ 


data saleshistory;
	infile "C:\Users\Palma\Desktop\SAS Term Project\CustomerPurchasesProject\salesdata.csv"
	firstobs=3
	/*obs = 13100 */  /* data of interest up through line this limit */
	dsd; /* delimiter-separated data - comma is default delimiter */
	input transact_date date9. filenum store_num upc units visits hhs spend price base_price feature display 
         tpr_only;
	transact_month= month(transact_date); *Create a variable that shows  the Month of each observation;
	*format transact_month monname.;
	transact_week= week(transact_date);
	transact_year= year(transact_date);  *Create a variable that shows  the Year  of each obeservation;

run;


/*** Reading dataset containing product descritption**/
 data productdescript;
		infile "C:\Users\Palma\Desktop\SAS Term Project\CustomerPurchasesProject\productdescription.csv"
		firstobs=3 /* data start on line 2, not line 1 */
		dsd; 
		input  upc2 description $ manufacturer $ category $ sub_category $ product_size $; 
		*manufacturer = propcase(manufacturer);
		*category = propcase(category);

run;

/*** Reading dataset containing stores descritption**/
data storedescript;
		infile "C:\Users\Palma\Desktop\SAS Term Project\CustomerPurchasesProject\storesdescription.csv"
		firstobs=3 /* data start on line 2, not line 1 */
		dsd; 
		input store_num1 store_name $ city $ state $ msa_code $ seg_value_name $; 
		*city = propcase(city);
run;

/**  Merging  and Assigning the saleshistory and productdescript data sets by a variable (Universal Product Code) */
ods graphics off;
ods html close;
ods noresults; 
proc sql;
		create table salesproclass as
	 	select *
	 	from saleshistory,productdescript
		where saleshistory.upc = productdescript.upc2;
		select transact_date,transact_week,transact_month,transact_year,upc,store_num,units,visits,hhs,spend,price
				,base_price,feature,display,tpr_only,description,manufacturer,category
		from  saleshistory,productdescript; 
quit;	

ods output close;
ods results; * turning back results on ;
ods html path="%sysfunc(getoption(work))";
ods graphics on;

/**  Merging and Assigning the salesproclass and storedescript data sets by a variable (Store Number ) */
ods graphics off;
ods html close;
ods noresults; 
proc sql;
		create table salesclassified as 
		select *
		from salesproclass,storedescript
		where salesproclass.store_num = storedescript.store_num1;
		select transact_date,transact_week,transact_month,transact_year,upc,units,visits,hhs,spend,price,
				base_price,feature,display,tpr_only,description,manufacturer,category
			    ,store_num,store_num1,store_name,city,state
		from  salesproclass,storedescript;
ods output close;
ods results; * turning back results on ;
ods html path="%sysfunc(getoption(work))";
ods graphics on;


/*** Producing tables that summaries multiple sales transactions*/
ods rtf file="C:\Users\Palma\Desktop\SAS Term Project\CustomerPurchasesProject\SalesByWeek";
*ods html style=htmlbluecml;
ods output table=SalesbyWeek; *storing output into another table;
title "Table of summary sales data grouped by Week" ;
proc tabulate data= salesclassified ;
	class transact_week ; * classisy by TimeCategory;
	by transact_year;
	var  spend ; * Use these variables to create table of Statistical summaries;
	table transact_week,(spend)*(reppctsum='Percentage %' sum='Sales Revenue'*f=dollar11.2);
	label transact_year="Sales Year" transact_week="Transaction Week" spend="Sales";
	*table  (units)*(N min Q1 Q3 max sum),transact_month;
run;
ods output close;
ods rtf close;

/**** Producing a time series graph by week and grouped by year ****/
ods html style=htmlbluecml;
title 'Time Series Graph of Total Sales by Week for 3 Years';
proc sgplot data=SalesbyWeek;
	series x=transact_week y=spend_Sum / markers  group=transact_year;
	*datalabel=transact_week lineattrs=(pattern=solid);
	format spend_Sum dollar8.0; 
	yaxis grid;
	xaxis grid;
	yaxis label="Total Sales on products($)";
	xaxis label="Week of Sale";
run;

/*** Producing tables that summaries multiple sales transactions by Manufacturer ,by month and by year****/
ods html style=htmlbluecml;
ods output table=SBManufMonth;
*options orientation=landscape;/*portriat*/
title "Table of Monthly summary Sales data grouped by Manufacturer" ;
proc tabulate data= salesclassified;
	class Manufacturer transact_month; * classisy by TimeCategory;
	by transact_year;
	var  spend units; *Use these variables to create table of Statistical summaries;
	table  transact_month*Manufacturer,(spend units)*(reppctsum sum);
	label transact_year="Sales Year" transact_week="Transaction Week" transact_month="Transaction Month";
run;


/****  Producing a time series graph Manufacturer by month by year***/
title 'Time Series Graph of Total Sales per Manufacturer by Month';
ods html style=htmlbluecml;
proc sgplot data=SBManufMonth ;
	series x=transact_month y=spend_Sum / lineattrs=(pattern=solid) markers group=manufacturer;
	by transact_year;
	*format transact_month monname.; 
	xaxis grid;
	yaxis grid;
	*format transact_month monname.;
	format spend_Sum dollar8.0; 
	yaxis label="Total sales on products($)";
	xaxis label="Month of Transaction";
	label transact_year="Sales Year";
run;


/*** Producing tables that summaries multiple total sales transactions by month and by year****/
ods rtf file="C:\Users\Palma\Desktop\SAS Term Project\CustomerPurchasesProject\MonthSales.rtf";
ods output table=SalesbyMonth;
title "Table of summary sales data grouped by Month" ;
proc tabulate data= salesclassified ;
	class transact_month ; * classisy by TimeCategory;
	by transact_year; * create different tables of Statistical summaries by year;
	var  spend ; * Use these variables to create table of Statistical summaries;
	table  transact_month,(spend )*(reppctsum='Percentage %' sum='Sales Revenue'*f=dollar11.2);
	label transact_year="Sales Year" transact_month="Transaction Month" spend="Sales";
run;
ods output close;

/****  Producing a time series graph of total sales by month by year***/
ods html style=htmlbluecml;
title 'Time Series Graph of Sales Revenue';
proc sgplot data=SalesbyMonth ;
	series x=transact_month y=spend_Sum / lineattrs=(pattern=solid) markers group=transact_year 
	datalabel=transact_month;
	*format transact_month monname.; 
	xaxis grid;
	yaxis grid;
	format spend_Sum dollar8.0; 
	yaxis label="Total sales on products($)";
	xaxis label="Month of Transaction";
run;
ods html close;
 	
/****Formatting colors in table by this criteria*/
proc format;
   value expfmt low-<100000='white'
                      100000-<150000='blue'
                      150000-high='yellow';
run;

/*** Producing tables that summaries total sales transactions by city and state****/
ods rtf file="C:\Users\Palma\Desktop\SAS Term Project\CustomerPurchasesProject\SalesCityState.rtf";
ods html style=htmlbluecml;
title "Table of total sales over 3 years classified by City and State" ;
proc tabulate data= salesclassified  format=8.2 style=[backgroundcolor=expfmt.];
	class state city transact_year ; * classisy by City;
	var  spend; * Use these variables to create table of Statistical summaries;
	table (state*city all='Total'), (spend)*(reppctsum='Percentage %' sum='Sales Revenue'*f=dollar14.2)*(transact_year all='Total');
	label transact_year="Sales Year" sum="Sales Revenue" city="Store Location" spend="Sales" state="State";
run;
ods html close;
ods rtf close;



ods rtf file="C:\Users\Palma\Desktop\SAS Term Project\CustomerPurchasesProject\SaleManYr.rtf";
ods html style=htmlbluecml;
ods output table=SBManufTotal;
*options orientation=landscape;/*portriat*/
title "Table of summary Sales over 3 years grouped by Manufacturer" ;
proc tabulate data= salesclassified;
	class Manufacturer transact_year ; * classisy by TimeCategory;
	var  spend ; *Use these variables to create table of Statistical summaries;
	table  (Manufacturer all='Total'),(spend )*(reppctsum='Percentage %' sum='Sales Revenue'*f=dollar14.2)*(transact_year all='Total');
	label transact_year="Sales Year" transact_week="Transaction Week" transact_month="Transaction Month" spend="Sales";
run;

/*
ods html style=htmlbluecml;
title "Graph of Product Sales data grouped by Year Various States" ;
proc sgpanel data=salesclassified;
	panelby state/ rows=4 ;
	hbar manufacturer /response=spend dataskin=gloss fillattrs=(transparency=0) group=transact_year;
	format spend dollar8.0; 
	colaxis grid ;
	colaxis label="Total sales on product ($)";
	rowaxis label="Manufacturer";
	label transact_year="Sales Year";
run;
ods rtf close;*/

/*** Producing tables that summaries total sales  by category , year  and state****/
ods rtf file="C:\Users\Palma\Desktop\SAS Term Project\CustomerPurchasesProject\AllCatYrState.rtf";
ods html style=htmlbluecml;
title "Table of total sales over 3 years classified by Category ,State and Year" ;
proc tabulate data= salesclassified ;
	class state transact_year category ; * classisy by City;
	var  spend; * Use these variables to create table of Statistical summaries;
	table (category all='Total' state all='Total'),(spend)*(reppctsum='Percentage %' sum='Sales Revenue'*f=dollar14.2)*(transact_year all='Total');
	label transact_year="Sales Year" sum="Sales Revenue" city="Store Location" spend="Sales" state="State";
run;
ods html close;
ods rtf close;


/****Formatting colors in table by this criteria*/
proc format;
   value expfmt low-<500000='white'
                      500000-<1000000='blue'
                      1000000-high='yellow';
run;

ods rtf file="C:\Users\Palma\Desktop\SAS Term Project\CustomerPurchasesProject\SaleManYrFin.rtf";
*ods html style=htmlbluecml;
ods output table=SBManufTotal;
*options orientation=landscape;/*portriat*/
title "Table of summary Sales over 3 years grouped by Manufacturer" ;
proc tabulate data= salesclassified format=8.2 style=[backgroundcolor=expfmt.];
	class Manufacturer transact_year ; * classisy by TimeCategory;
	var  spend ; *Use these variables to create table of Statistical summaries;
	table  (Manufacturer all='Total'),(spend )*(reppctsum='Percentage %' sum='Sales Revenue'*f=dollar14.2)
              *(transact_year all='Total');
	label transact_year="Sales Year" transact_week="Transaction Week" transact_month="Transaction Month" spend="Sales";
run;

*ods output Summary=ManuSummary;
proc means data=salesclassified ;
  class transact_year manufacturer;
  var spend;
  output out=prdsale(where=(_type_ = 7) 
             keep=transact_year manufacturer ActualSum _type_)
         sum=ActualSum;
run;

*ods html style=htmlbluecml;
title "Graph of  summary Sales  classified by Manufacturer for the 3 years" ;
proc template ;
	define statgraph StClusBarStat;
		begingraph;
			layout gridded;
			layout datalattice columnvar=transact_year / headerlabeldisplay=value
                           columnheaders=bottom border=false
            	 rowaxisopts=(offsetmin=0.25 display=(ticks tickvalues label))
            	row2axisopts=(offsetmax=0.8 display=none)
            	 columnaxisopts=(display=(ticks tickvalues));
         	 layout prototype / ;
		  		barchart x=manufacturer y=Actualsum / group=transact_year stat=sum dataskin=gloss ;
			endlayout;
			endlayout;
			endlayout;
		endgraph;
	end;
	
run;

proc sgrender data=prdsale template=StClusBarStat;
  format actualsum dollar7.0;
run;

ods html style=htmlbluecml;
title "Graph of Product Sales data grouped by Category" ;
proc sgplot data=salesclassified;
	hbar category /response=spend fillattrs=(transparency=0) dataskin=pressed
	group= transact_year;
	format spend dollar8.0; 
	xaxis grid;
	xaxis label="Total Sales on product ($)";
	yaxis label="Product Category";
	label transact_year="Sales Year";
run;
ods html close;


ods rtf file="C:\Users\Palma\Desktop\SAS Term Project\CustomerPurchasesProject\TotSalesByManu.rtf";
ods html style=htmlbluecml;
ods output table=SBManuf;
title "Table of summary Sales data grouped by Manufacturer" ;
proc tabulate data= salesclassified;
	class Manufacturer ; * classisy by TimeCategory;
	*by transact_year;
	var  spend units; *Use these variables to create table of Statistical summaries;
	table  Manufacturer,(spend units)*(reppctsum='Percentage %' sum);
	label transact_year="Sales Year" sum="Total" spend="Sales ($)" units="Units Sold";

run;
ods html close;
ods rtf close;






data summarytables;
 	set  SBManuf;
	format spend_Sum dollar11.2;
	format units_Sum comma11.2;
	/*format spend_Sum 'Sales Revenue'*f=dollar11.2;*/
	manufacturer= propcase(manufacturer);
	label manufacturer="Manufacturer(Brand)"  spend_Sum="Sales ($)" units_Sum="Units Sold";
	keep manufacturer spend_PctSum_0 spend_Sum units_PctSum_0 units_Sum;
run;


ods html style=htmlbluecml;
proc print data=summarytables;
run;


ods html style=htmlbluecml;
ods output table=FinalSumTable;
proc means data=SBManuf sum ;
var spend_Sum;
by manufacturer ;
*by transact_year;
run;
ods output close;
ods html close;



ods html style=htmlbluecml;
proc sgpanel data=SBManuf ;
	panelby transact_year /rows=3;
	vbar  manufacturer  /response=spend_Sum dataskin=gloss  ;  
	rowaxis label="Total sales on Brand($)";
	colaxis label="Manufacturer";
run;
ods html close;

ods html style=htmlbluecml;
proc sgplot data=SBManuf ;
	hbar manufacturer /response=spend_Sum dataskin=gloss group=transact_year;
	format spend_Sum dollar8.0; 
	yaxis grid;
	xaxis grid;
	xaxis label="Total sales on products($)";
	yaxis label="Manufacturer";
run;
ods html close;


/*** Producing tables that summaries multiple sales transactions by Manufacturer ,by month and by year****/
*ods html style=htmlbluecml;
ods output table=SBManufWeek;
*options orientation=landscape;/*portriat*/
title "Table of Weekly summary Sales data grouped by Manufacturer" ;
proc tabulate data= salesclassified;
	class Manufacturer transact_week; * classisy by TimeCategory;
	by transact_year;
	var  spend units; *Use these variables to create table of Statistical summaries;
	table  transact_week*Manufacturer,(spend units)*(reppctsum sum);
	label transact_year="Sales Year" transact_week="Transaction Week" transact_month="Transaction Month";
run;


/****  Producing a time series graph Manufacturer by month by year***/
title 'Time Series Graph of Total Sales per Manufacturer by Week';
ods html style=htmlbluecml;
proc sgplot data=SBManufWeek ;
	series x=transact_week y=spend_Sum / lineattrs=(pattern=solid) markers group=manufacturer;
	by transact_year;
	*format transact_month monname.; 
	xaxis grid;
	yaxis grid;
	*format transact_month monname.;
	format spend_Sum dollar8.0; 
	yaxis label="Total sales on products($)";
	xaxis label="Month of Transaction";
	label transact_year="Sales Year";
run;

/*
title "Graph of Product Sales data grouped by Month and Year" ;
proc sgpanel data=salesclassified;
	panelby transact_year/ columns=3 ;
	vbar transact_month /response=spend dataskin=pressed ;
	rowaxis label="Total spend on product ($)";
	colaxis label="Month of Transaction";
run;*/

/*
ods html style=htmlbluecml;
title "Table of monthly sales data by State " ;

proc sgpanel data=salesclassified;
	panelby state / columns=4 ;
	vbar transact_month /response=spend dataskin=pressed;
	by transact_year;
	rowaxis label="total spend on product";
	colaxis label="Month";
run;
ods html close;

/*
proc tabulate data=energy format=8.2;
   class division type;
   var expenditures;
   table division*
           (sum='Expenditures'*f=dollar10.2
            pctsum<type>='% of row' 1
            pctsum<division>='% of column' 2
            pctsum='% of all customers'), 3
         type*expenditures/rts=40;
   title 'Expenditures in Each Division';
run;

*/



proc gproject data=maps.counties out=OHIO_counties;
	where state eq 39;
	id state;
run;


data county_pop;
	length char_county $ 10;
	input county6 1-5 weeklybaskets char_county &;
	county =county6-39000;
	datalines;
39001   20000       Adams
39003  30600 Allen
39005  30009        Ashland
39007  45645       Ashtabula
39009   2478       Athens
39011   13545   Auglaize
39013  24345    Belmont
39015 39900     Brown
39017  9000     Butler
39019   0      Carroll
39021    0    Champaign
39023     112    Clark
39025     3900 Clermont
39027    23555    Clinton
39029   3444  Columbiana
39031   0   Coshocton
39033    900  Crawford
39035  2000  Cuyahoga
39037  2000    Darke
39039  2887    Defiance
39041 99777     Delaware
39043  1234    Erie
39045  26990   Fairfield
39047   8099  Fayette
39049   2000  Franklin
39051   9400  Fulton
39053   2000   Gallia
39055  3000     Geauga
39057   4000  Greene
39059   2255   Guernsey
39061   3566  Hamilton
39063   4599   Hancock
39065  3800    Hardin
39067  3455  Harrison
39069   0   Henry
39071  1000    Highland
39073   55  Hocking
39075    109  Holmes
39077     300 Huron
39079    0 Jackson
39081   0   Jefferson
39083   3232   Knox
39085   2323 Lake
39087   232   Lawrence
39089    100 Licking
39091   100   Logan
39093  500   Lorain
39095   600 Lucas
39097   3000  Madison
39099  9000  Mahoning
39101   3322  Marion
39103  1  Medina
39105   12   Meigs
39107    34  Mercer
39109  545    Miami
39111  0   Monroe
39113  0  Montgomery
39115  0    Morgan
39117   343   Morrow
39119   2423   Muskingum
39121    2432  Noble
39123   23423  Ottawa
39125   23423   Paulding
39127    4234  Perry
39129    2432 Pickaway
39131   89   Pike
39133   898 Portage
39135   89 Preble
39137   98   Putnam
;
run;

proc gmap data=county_pop
		map=OHIO_counties;
	id county;
	choro weeklybaskets;
	note ' Average Weekly Baskets by County for OHIO';
run;
quit;


pattern v=e;
title 'MAP OF USA Showing Location on Store for the Sales Data';
* use a SAS-supplied map data set (US) as both the map and response data sets;
proc gmap
		map=maps.us 
		data=maps.us (obs=12) 
		all;
		id state ;
		choro state / nolegend ;
	pattern1 v=me c=red r=12;
	pattern1 v=ms c=cxeff3ff;
	pattern1 v=ms c=redd4 r=3;
	pattern3 v=oh c=red r=3 ;
	pattern4 v=ms c=gray64 r=3;
run;
quit;
