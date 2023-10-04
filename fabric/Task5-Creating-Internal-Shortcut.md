### Task 5 : Creating Internal Shortcut

>**Note:** In this task we are creating Internal Shortcut in lakehouse 'Silver To Gold'

1. In Power BI workspace **click** on 'Workspaces' and **select** 'contosoSales'.

	![Close the browser.](media/demo-4.png)

2. **Filter** 'Lakehouse' and then **select** 'lakehouseGold'.
    
	![Close the browser.](media/FilterLakehouseGold.png)
	
3. **Click** on the 'three dots' infont of Tables and then **select** 'New Shortcut'.

	![Close the browser.](media/LakehouseGoldShortcut1.png)

4. In the 'Internal Sources' section **select** 'Microsoft OneLake'.

	![Close the browser.](media/LakehouseGoldShortcut2.png)

5. **Search** for 'lakehouseSilver' in the search box, **click** on 'lakehouseSilver' and then **click** on 'Next'.

	<img width="1048" alt="image" src="https://github.com/swmannepalli/MicrosoftFabric_HOL/assets/84516667/62abe067-024e-416c-b012-2f9c79b8ca10">


6. **Click** on Tables, **select** 'dim_date' and then **click** on 'Create'.

	<img width="964" alt="image" src="https://github.com/swmannepalli/MicrosoftFabric_HOL/assets/84516667/c5c041ad-d267-4e45-9ebd-384c7ef67f37">


7. **Repeat** step number 2 to step number 6 for the other tables in the below tables.

	|	Table Name	|	Create Shortcut From Lakehouse	|
	| -----------	| ------------- |
	|	dimesion_product|	lakehouseSilver	|
	|	dimesion_customer|	lakehouseSilver	|
	|	fact_sales|	lakehouseSilver	|
	|	fact_campaigndata|	lakehouseSilver	|
	|||

>**Note:** Once you are done with Task 6 please go back to Task 5 and follow the steps from the point where you had stopped.
