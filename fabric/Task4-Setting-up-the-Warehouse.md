[Home](Readme-shell.md) -  [Next Task (Internal Shortcut) >](Task5-Creating-Internal-Shortcut.md)

### Task 4: Setting up the Warehouse

In this task, 
	
1. we set up a Data Warehouse
2. Copy data from Azure SQL Database to Data Warehouse using data pipeline
3. Execute SQL scripts
4. Create Visual Query
	
 ----------------------------------------------------------------------------------------------

1. In the bottom-left corner of the PowerBI tab **click** on 'Power BI'.

2. **Select** 'Data Warehouse'.

	![Datawarehouse.](media/warehouse-1.png)

3. **Click** 'Data Warehouse'.

	![Datawarehouse.](media/warehouse-2.png)

4. In the 'New Warehouse' pop-up, **enter** name as 'salesDW'.

5. **Click** 'Create'.

	![Datawarehouse.](media/warehouse-3.png)

>**Note:** It would take some time for the page to load, please wait.

7. **Click** 'Get data'.

8. **Select** 'New data pipeline'.

	![Datawarehouse.](media/warehouse-4.png)

9. In the pop-up **enter** the name as '02 Sales data from Azure SQL DB to Data Warehouse - Low Code Experience'.

10. **Click** Create.

11. **Wait** for a new pop-up.

	![Datawarehouse.](media/warehouse-5.png)

12. In the pop-up **scroll down**.

13. **Select** 'Azure SQL Database'.

14. **Click** 'Next' button.

	![Datawarehouse.](media/warehouse-6.png)

15. In a new tab **open** the resource group created in [Task 2](#task-2-run-the-cloud-shell-to-provision-the-demo-resources).

16. **Search** for 'sql server'.

17. **Click** on the SQL server resource.

	![Datawarehouse.](media/warehouse-7.png)

18. In the resource window **copy** the 'Server admin'.

19. **Save** it in a notepad for further use.

20. **Copy** the 'Server name'.

21. **Save** it in a notepad for further use.

22. **Click** 'SQL databases' under the Settings in the left pane.

	![Datawarehouse.](media/warehouse-8.png)

23. **Copy** the name of database and **paste** it in a notepad for further use.

	![Datawarehouse.](media/warehouse-9.png)

24. **Go back** to the PowerBI tab.

25. **Select** 'Create new connection' radio button, in the 'Server;' and 'Database' field **paste** the value copied in step number 19 and 22.

	![Datawarehouse.](media/warehouse-10.png)

26. **Select** Authentication kind as 'Basic', **enter** Username as 'labsqladmin' and Password you copied in [Task 2](#task-2-run-the-cloud-shell-to-provision-the-demo-resources)
step 27 finally **click** on the 'Next' button.

![Datawarehouse.](media/warehouse-11.png)

26. Next, in 'Connect to data source' **select** 'Existing tables' then **select** 'Select all' and then **click** 'Next' button.

	![Datawarehouse.](media/warehouse-12.png)

27. In 'Choose data destination' **select** the Data Warehouse and **click** 'Next' button.

	![Datawarehouse.](media/warehouse-13.png)

28. In 'Choose data destination' **select** 'Load to new table', **click** on 'Source' checkbox and then **click** 'Next' button.

	![Datawarehouse.](media/warehouse-14.png)

29. In 'Settings' section keep it default and **click** 'Next' button.

	![Datawarehouse.](media/warehouse-15.png)

30. In 'Review + save' section **review** the copy summary and **scrolldown** tick mark the option of 'Start data transfer immediately' then **click** 'Save + Run' button.

	![Datawarehouse.](media/warehouse-16.png)	

>**Note:** As you click on 'Save + Run' the pipeline gets automatically triggered.

31. **Check** the notification or pipeline output screen for the progress of copy database.

	![Datawarehouse.](media/warehouse-17.png)

32. In progress section of pipeline **check** the status of running pipeline.

	![Datawarehouse.](media/warehouse-18.png)

>**Note:** Please wait for the resultant data to load.

33. **Wait** for the status of pipeline to be 'Succeeded' and **go back** to the Data Warehouse from the workspace.

34. **Open** the Data Warehouse and **click** 'New SQL query'.

	![Datawarehouse.](media/warehouse-18.1.png)

35. **Click** on [Warehouse Scripts](artifacts/warehousescripts) link in new tab to open the scripts.

36. **Click** the first script to open it.

	![Datawarehouse.](media/warehouse-19.png)
37. **copy** the script and paste in the SQL Query tab in Data Warehouse page. **Replace** '#STORAGE_ACCOUNT_NAME#' and '#STORAGE_ACCOUNT_SAS_TOKEN#'. To get these values, 

38. In a new tab **open** the resource group created in [Task 2](#task-2-run-the-cloud-shell-to-provision-the-demo-resources).

39. **Search** for the 'Storage account' **copy** the 'Storage account' and **paste** it in the SQL Squery.

	![Datawarehouse.](media/warehouse-22.png)

40. **Click** on searched 'Storage account', **scrolldown** left pane and **click** to select 'Shared access signature'.

	![Datawarehouse.](media/warehouse-23.png)

41. **Select** 'Container' and 'Object' in 'Allowed resource type'. **select** 'Read','Write', 'List' in 'Allowed permissions' . **select** HTTPS and HTTP under Allowed Protocols. keep  rest all uncheck. In 'Start and expiry date/time' **select** date & time and then **scrolldown** to **click** 'Generate SAS and connection string' button.

	<img width="1042" alt="image" src="https://github.com/swmannepalli/MicrosoftFabric_HOL/assets/84516667/0d8ff029-a27f-495a-aee4-d5abc1cd854c">


42. Below the 'Generate SAS and connection string' button, we can see the generated SAS token. **Copy** and paste it in the SQL Squery.

	![Datawarehouse.](media/warehouse-26.png)

43.  **Right click** on 'SQL query 1' and **click** 'Rename'.


44. **Enter** the name as '00 Ingest Data In DW Using COPY INTO Command.sql' and **click** 'Rename' button.

	![Datawarehouse.](media/warehouse-28.png)

45. **Click** the 'three dots (Ellipsis)' in front of the name of the scripts and **select** 'Move to Shared queries'.

	![Datawarehouse.](media/warehouse-29.png)

>**Note:** We are going to create 2 more scripts following the above steps for querying the Warehouse data.

46. **Repeat** above steps for the other two scripts in the repository. Get the scripts [HERE](https://github.com/microsoft/Azure-Analytics-and-AI-Engagement/tree/microsoftfabric/fabric/artifacts/warehousescripts)

>**Note:** If there are no replacements necessary in the scripts, you can skip the steps in between.

Execute each script to view results.

47. **Click** 'New visual query'.

	![Datawarehouse.](media/warehouse-30.png)

48. **Click** and **drag** the table 'DimProduct' to the canvas.

	![Datawarehouse.](media/warehouse-31.png)

49. **Click** and **drag** the table 'FactSales' to the canvas.

	![Datawarehouse.](media/warehouse-40.png)

50. **Click** 'Combine' and **select** 'Merge queries as new'.

	![Datawarehouse.](media/warehouse-32.png)

51. In the 'Left table for merge' **select** 'DimProduct' from the dropdown and **click** on column 'ProductKey' of the table.

	![Datawarehouse.](media/warehouse-33.png)

52. **Scroll down** in the 'Right table for merge' **select** 'FactSales' from the dropdown and **click** on column 'ProductKey' of the table.

	![Datawarehouse.](media/warehouse-34.png)

53. **Scroll down** to Join kind section and **click** on 'Inner' radio button and click on 'OK' button.

	![Datawarehouse.](media/warehouse-35.png)

54. You would see the following result.

	![Datawarehouse.](media/warehouse-36.png)

55. **Right click** on 'Visual query 1' and **select** 'Rename'.

	![Datawarehouse.](media/warehouse-37.png)

56. **Enter** the name as "Visual query- Total Sales By Product" and **click** on 'Rename' button.

	![Datawarehouse.](media/warehouse-38.png)

57. **Click** on the 'three dots' infront of the visual query name and **click** one 'Moved to Shared queries'

	![Datawarehouse.](media/warehouse-39.png)

[Continue >](Task5-Creating-Internal-Shortcut.md)
