/*
FILENAME GETGRAPH 'C:\Users\Palma\Pictures\Pictures\isafpro.JPG';
Proc gslide iframe = getgraph imagestyle = fit;
Note move = (25, 45) height = 2 font = 'swiss'
 'import external photo with gslide';
*sugi 31 coders’ corner
3;
Run;
Quit;
*/
/*******************************************************************************************
PROGRAM DESCRIPTION
A large chain store operator implemented a sales promotion campaign over a two year period on
a number of groceries, data has been provided on the selected items, we want to evaluate the 
impact of the promotion campaign, the most purchased product and how much earned on some of 
these products, we would study and observe useful trends from the data set.
This program Reads, extract, organize, manipulate, combine and. I have successfully read into 
SAS the data set, this was a large excel sheet with over 500,000 observations 
This program  performs various analysis using SAS methods and programming techniques

********************************************************************************************/ 
data saleshistory;
		infile "C:\Users\Palma\Desktop\SAS Term Project\CustomerPurchasesProject\salesdata.csv"
		firstobs=3
		obs = 20     /* data of interest up through line this limit */
		dsd;       			/* delimiter-separated data - comma is default delimiter */
		input transact_date date9.  filenum store_num upc units visits hhs spend price base_price feature display tpr_only;

				transact_month = month(transact_date); *Create a variable that shows  the Month of each observation;
				*format transact_month monname.;
				transact_year = year(transact_date);	*Create a variable that shows  the Year  of each obeservation;

run;


/* labelling various sales by stores*/
data salesclassified ;
	 set saleshistory;
	 /* Creating classification criteria of the stores by State*/
     if store_num = 389 then storestate="KY" ;
	else if store_num = 367 then storestate="KY" ;
    else if store_num = 19265  then storestate="KY" ;
    else if store_num = 4245 then storestate="IN" ;
	 else if store_num = 2277 then storestate="OH";
	 else if store_num = 25001 then storestate="OH";
	 else if store_num = 387 then storestate="OH";
	else if store_num = 4259 then storestate="OH"; 
	else if store_num = 13859 then storestate="TX"; 
	else if store_num = 15541 then storestate="OH"; 
	else if store_num = 23061 then storestate="OH"; 
	else if store_num = 21213 then storestate="OH"; 
	else if store_num = 23067 then storestate="OH"; 
	else if store_num = 28909 then storestate="OH"; 
		else if store_num = 9825 then storestate="OH"; 
	else if store_num = 15547 then storestate="OH"; 
	else if store_num = 387 then storestate="OH";
    else if store_num = 2279 then storestate="OH"; 
	else if store_num = 6179 then storestate="OH";
else if store_num = 11761 then storestate="OH";
else if store_num = 21227 then storestate="OH"; 
	else if store_num = 21237 then storestate="OH";
else if store_num = 23075 then storestate="OH";
else if store_num = 21221 then storestate="OH"; 
	else if store_num = 23055 then storestate="OH";
else if store_num = 24991 then storestate="OH";
else if store_num = 2281  then storestate="OH"; 
	else if store_num = 26973  then storestate="OH";
else if store_num = 8035 then storestate="OH";
else if store_num = 8041 then storestate="OH"; 
	else if store_num = 25027 then storestate="OH";
else if store_num = 25021 then storestate="OH";
else if store_num = 25021 then storestate="OH";
else if store_num = 26981then storestate="OH"; 
	else if store_num = 13609 then storestate="OH";
else if store_num = 15531 then storestate="OH";
	 else storestate="TX";

	 /* Creating classification criteria for Categorizing  Products by Manufacturer and Category*/
	  set saleshistory ;

	 if   upc = 1600027527 then do manufacturer ="GENERAL MI" ; category= "Cereal";

			if upc = 1600027528 then do  manufacturer ="GENERAL MI";  category= "Cereal";output;end;
     		if upc = 1600027564 then do manufacturer ="GENERAL MI" ;category= "Cereal"; output;end;end;
	 	 	if upc = 2066200530 then do manufacturer ="KING" ; category= "Frozen pizza";output;end;
	 	 	if upc = 2066200531then do manufacturer ="KING"  ;category= "Frozen pizza"; output;end;
			if upc = 2066200532 then do  manufacturer ="KING" ;  category= "Frozen pizza";output;end;

		 	if upc = 2840002333 then do  manufacturer ="FRITO LAY" ; category= "Bag Snacks";output;end;
			 if upc = 2840004768 then do manufacturer ="FRITO LAY" ; category= "Bag Snacks";output;end;
	  		if upc = 2840004770 then do manufacturer ="FRITO LAY" ;category= "Bag Snacks";output;end;

			 if upc = 3000006340 then do manufacturer ="QUAKER" ; category= "Cereal";output;end;
	  	if upc = 3000006560 then do manufacturer ="QUAKER" ; category= "Cereal";output;end;
  	 	if upc = 3000006610 then do manufacturer ="QUAKER"  ;category= "Cereal";output;end;

			if upc = 3120505000 then do manufacturer ="HOME RUN"  ;category= "Frozen pizza";output;end;
	 		 if upc = 3120505100 then do  manufacturer ="HOME RUN"; category= "Frozen pizza";output;end;
			 if upc = 3120506000 then do manufacturer ="HOME RUN"; category= "Frozen pizza";output;end;
	

	 		 if upc = 3700019521 then do manufacturer ="P & G" ; category= "Oral hygiene";output;end;
	 		if upc = 3700031613 then do manufacturer ="P & G"  ;category= "Oral hygiene ";output;end;
	 		 if upc = 3700044982 then do manufacturer ="P & G" ; category= "Oral hygiene";output;end;

	   		if upc = 3800031829 then do  manufacturer ="KELLOGG" ; category= "cereal";output;end;
	 		 if upc = 3800031838 then do manufacturer ="KELLOGG" ; category= "Cereal";output;end;
	 		 if upc = 3800039118 then do manufacturer ="KELLOGG" ;category= "Cereal";output;end;

	   		if upc = 4116709428 then do  manufacturer ="CHATTEM" ; category= "Oral hygiene";output;end;
			if upc = 4116709448 then do manufacturer ="CHATTEM"  ; category= "Oral hygiene";output;end;
	 		 if upc = 4116709565 then do manufacturer ="CHATTEM"  ; category= "Oral hygiene";output;end;

   			 if upc = 7027312504 then do manufacturer ="SHULTZ" ; category= "Bag Snacks";output;end;
	 		if upc = 7027316204 then do manufacturer ="SHULTZ" ; category= "Bag Snacks";output;end;
	 		 if upc = 7027316404 then do manufacturer ="SHULTZ" ; category= "Bag Snacks";output;end;

	  		if upc = 7110410455 then do  manufacturer =" MKSL" ; category= "Bag Snacks";output;end;
			if upc = 7110410470 then do manufacturer =" MKSL"  ;category= "Bag Snacks";output;end;
			if upc = 7110410471 then do manufacturer =" MKSL" ; category= "Bag Snacks";output;end;

	 		 if upc = 7192100336 then do manufacturer ="TOMBSTONE" ;  category= "Frozen pizza";output;end;
	 		 if upc = 7192100337 then do manufacturer ="TOMBSTONE" ;category= "Frozen pizza";output;end;
	 		if upc = 7192100339 then do manufacturer ="TOMBSTONE" ; category= "Frozen pizza";output;end;

			 if upc = 7218063052 then do manufacturer ="TONYS" ; category= "Frozen pizza";output;end;
			  if upc = 7218063979 then do manufacturer ="TONYS"  ;category= "Frozen pizza";output;end;
			 if upc = 7218063983 then do manufacturer ="TONYS" ; category= "Frozen pizza";output;end;

	 		 if upc = 7797502248 then do  manufacturer =" SNYDERS"; category= "Bag Snacks";output;end;
			if upc = 7797508004 then do manufacturer =" SNYDERS" ; category= "Bag Snacks";output;end;
			 if upc = 7797508006 then do manufacturer =" SNYDERS"  ; category= "Bag Snacks";output;end;

	 		  if upc = 31254742725 then do manufacturer ="WARNER" ; category= "Oral hygiene";output;end;
			 if upc = 	 31254742735 then do manufacturer ="WARNER" ;category= "Oral hygiene";output;end;
			if upc = 31254742835 then do manufacturer ="WARNER" ; category= "Oral hygiene ";output;end;

			 if upc =  88491201426 then do  manufacturer ="POST FOODS";  category= "Cereal";output;end;
		 	 if upc = 88491201427 then do manufacturer ="POST FOODS";  category= "Cereal";output;end;
  		 	 if upc = 88491212971 then do manufacturer ="POST FOODS" ; category= "Cereal";output;end;
			if upc = 3500068914 then do manufacturer ="COLGATE" ; category= "Oral hygiene";output;end;
			else   manufacturer ="OTHERS"  ; category="Various";output; 
*drop filenum; 
run;
title "Table of  Categorized Sales data";
proc print data=salesclassified ;
run;



title "Graph of Product Sales data grouped by Month and Year" ;
proc sgpanel data=salesclassified;
	panelby transact_year/ columns=3 ;
	vbar transact_month /response=spend  ;
	rowaxis label="Total spend on product ($)";
	colaxis label="Month of Transaction";
run;

title "Graph of Product Sales data grouped by Manufacturer" ;
proc sgplot data=salesclassified;
	vbar category /response=spend  ;
	by transact_year;
	yaxis label="Total spend on product ($)";
	xaxis label="Manufacturer";
run;



title "Graph of Product Sales data grouped by Month and Year" ;
proc sgpanel data=salesclassified;
	panelby transact_year/ columns=3 ;
	vbar transact_month /response=spend  ;
	rowaxis label="Total spend on product ($)";
	colaxis label="Month of Transaction";
run;

title "Graph of Product Sales data grouped Product Category" ;
proc sgplot data=salesclassified;
	vbar category /response=spend  ;
	by year;
	yaxis label="Total spend on product ($)";
	xaxis label="Product Category";
run;

title "Table of monthly sales data by State " ;

proc sgpanel data=salesclassified;
	panelby storestate / columns=4 ;
	vbar transact_month /response=spend ;
	by transact_year;
	rowaxis label="total spend on product ($)";
	colaxis label="Store Location by State ";
run;

title "Table of summary sales data grouped by Month" ;
proc tabulate data= salesclassified;
	class transact_month ; * classisy by TimeCategory;
	var  spend units; * Use these variables to create table of Statistical summaries;
	table  (spend units)*(min Q1 Q3 max sum),transact_month;
run;


title "Graph of Product Sales data grouped Product Category" ;
proc sgplot data=salesclassified;
	vbar category /response=spend ;
	yaxis label="Total spend on product ($)";
	xaxis label="Product Category";
run;



title "Graph of Product Sales data grouped by Month and Year" ;
proc sgplot data=salesclassified;
	vbar transact_month /response=spend;
	by transact_year;
	yaxis label="Total spend on product ($)";
	xaxis label="Month of Transaction";
run;






title "Table of summary Sales data grouped by Manufacturer" ;
proc tabulate data= salesclassified;
	class Manufacturer; * classisy by TimeCategory;
	var  spend units; *Use these variables to create table of Statistical summaries;
	table  (spend units)*( min Q1 Q3 max sum),Manufacturer;
run;


title "Table of Five number summary Sales data grouped by Products" ;
proc tabulate data= salesclassified;
	class category; * classisy by TimeCategory;
	var  spend units; *Use these variables to create table of Statistical summaries;
	table  ( min Q1 Q3 max sum)*(spend units),category;
run;

proc sgplot data=salesclassified;
	hbar  spend*(Manufacturer);
run;


proc means data=salesclassified N STD Q1 MEDIAN Q3 MIN MAX;
	by spend ;
	var manufacturer ;
	
run;



proc sgplot data=salesclassified;
	vbar manufacturer /response=spend ;
	yaxis label="total spend on product";
	xaxis label="universal product code (upc)";
run;


proc sgplot data=salesclassified;
	vbar storestate /response=spend ;
	yaxis label="total spend on product";
	xaxis label="Store Location by State ";
run;


* select an empty pattern (v=e) and a title;
pattern v=e;
title 'MAP OF USA Showing Location on Store for the Sales Data';
* use a SAS-supplied map data set (US) as both the map and response data sets;
proc gmap
		map=maps.us 
		data=maps.us (obs=5) 
		all;
		id state ;
		choro state / nolegend ;
	pattern1 v=me c=green r=12;
	pattern1 v=ms c=cxeff3ff;
	pattern1 v=ms c=grayd4 r=3;
	pattern3 v=oh c=red r=3 ;
	pattern4 v=ms c=gray64 r=3;
run;
quit;


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



proc gproject data=maps.counties out=TEXAS_counties;
	*where state eq 77;
	id state;
run;



data county_pop2;
	length char_county $ 10;
	input county6 weeklybaskets char_county &;
	*county =county6-77000 county6 1-5 ;
	datalines;
77339	20620 KINGWOOD
77520	24322 BAYTOWN
75080	15787 RICHARDSON
75069	15345 MCKINNEY
77506  18291  PASADENA
77002  30258 HOUSTON
75034 21947 FRISCO

	;
	run;


proc gmap 
		map=TEXAS_counties;
	/*id county6;
	choro weeklybaskets;
	note ' Texas Stores  Weekly Baskets';*/
run;
quit;

 data productdescript;
	infile "C:\Users\Palma\Desktop\SAS Term Project\CustomerPurchasesProject\productdescription.csv"
	firstobs=3 /* data start on line 2, not line 1 */
	dsd; 
	input  upc description $ manufacturer $ category $ sub_category $ product_size $; 
run;

data storedescript;
	infile "C:\Users\Palma\Desktop\SAS Term Project\CustomerPurchasesProject\storesdescription.csv"
	firstobs=3 /* data start on line 2, not line 1 */
	dsd; 
	input store_num $ store_name $ city $ state $ msa_code $ seg_value_name $; 
run;
/*
data salespromerged;
	merge productdescript saleshistory;
	by upc;
run;

proc sort data=salespromerged;
	by upc;
run;

data alldatamerged;
	merge salespromerged storedescript;
	by store_num;
run;
*/
proc print data=alldatamerged;
run;


title 'Daily Sales records  in chain stores';
/*proc print data=saleshistory;
run;*/

proc sgplot data=saleshistory;
	vbar store_num  ;
	yaxis label="frequency";
	xaxis label="store number ";
run;
