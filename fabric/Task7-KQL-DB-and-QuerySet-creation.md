
### Task 7: KQL DB and QuerySet creation

1. In Power BI service click 'Workspaces' and **click** current working workspace. 

	![Close the browser.](media/power-bi-5.png)

2. **Click** '+ New' and then **click** 'Show all'.

	![Close the browser.](media/demo-5.png)

3. In the new window **scroll down** to 'Real-Time Analytics' section and **click** 'KQL Database (Preview)'.

	![Close the browser.](media/demo-33.png)

4. **Enter** the name as 'Contoso-KQL-DB', **click** 'Create' button and **wait** for the database to get created.

	![Close the browser.](media/demo-34.png)

5. Once database is created in overview page, **click** 'Get data' and then **click** 'Event Hubs'.

    ![Close the browser.](media/demo-35.png)

6. In Destination tab **select** 'New table' and provide the name as 'thermostat'and then **click** 'Next:Source' button.

    ![Close the browser.](media/demo-36.png)

7. In the Source tab **select** the source type as 'Event Hub' and **select** 'create new connection'

	![Close the browser.](media/demo-36.1.png)

	>**Note:** For the rest of the details we will get the data from the resource group.

8. In a new tab **open** the resource group created in [Task 2](#task-2-run-the-cloud-shell-to-provision-the-demo-resources).

9. **Search** for 'Event Hub namespace' and **copy** the name of Event Hub namespace and **paste** it in a notepad for further use.

	  ![Close the browser.](media/demo-52.png)

10. **Click** the 'Event Hubs Namespace' under overview **scrolldown** at bottom and **copy** the name of Event Hub and **paste** it in a notepad for further use.

	 ![Close the browser.](media/demo-53.png)	

11. To get the shared access key & shared access key name,**click** Event Hubs Instance 'thermostat'. Then **click** 'Shared access policies' in the left pane. **Click** on shared access key name 'thermostat' to open the shared access key tab in right pane. 
**Copy** the primary key and **paste** it in a notepad for further use. 

   ![Close the browser.](media/demo-54.png)

12. **Navigate back** to the PowerBI tab.

13. Make sure you are in the 'Create new connection' section. **Select** 'Authentication kind' as 'Shared Access Key' and then in the connection setting **paste** the value copied in step 9,10,11 and **click** 'Save' button.

    ![Close the browser.](media/demo-37.png)
    ![Close the browser.](media/demo-38.png)
    ![Close the browser.](media/demo-39.png)

14. Upon clicking on 'Save', the below disabled fields 'Data connection name' & 'Consumer group' will be enabled. Keeping its value as default, **click** 'Next: Schema' button.

    ![Close the browser.](media/demo-40.png)

15. On Schema tab, **select** the Data format as JSON and **click** Next:Summary button.

    ![Close the browser.](media/demo-41.png)

16. Once **click** Summary button, it will show the message as 'Continuous ingestion from Event Hubs established'. **Click** 'Close' button.

    ![Close the browser.](media/demo-42.png)

17. To verify the data tree **expand** the thermostat table, check the size and the table details.

    ![Close the browser.](media/demo-43.png)

18. **Click** 'Contoso-KQL-DB' and  **wait** for sometime to load the data. **Check** the table size.

	![Close the browser.](media/demo-44.png)

19. Once you see the table size is increased then, **click** 'Explore your data' button. 

	<img width="805" alt="image" src="https://github.com/swmannepalli/MicrosoftFabric_HOL/assets/84516667/c0424e9b-d834-4c15-96fe-a85f48be91d5">


20. It will open the KQL queryset editor. **Click** link [KQL Queryset Scripts](https://github.com/microsoft/Azure-Analytics-and-AI-Engagement/tree/microsoftfabric/fabric/artifacts/kqlscripts). **Copy** and **paste** the script in the editor, select till line #8 or as shown below and **click** 'Run' button.

	<img width="945" alt="image" src="https://github.com/swmannepalli/MicrosoftFabric_HOL/assets/84516667/1939b296-1e11-4c14-b63c-80d4753c56a6">


21. To create a Query Set **go to** current Workspace, **click** '+ New' and **click** 'Show all' button.

	![Close the browser.](media/demo-5.png)

22. In the new window, **scroll down** to 'Real-Time Analytics' section and **click** 'KQL Queryset (Preview)'.

	![Close the browser.](media/demo-47.png)

23. **Enter** the name as "01 Query Thermostat Data in Near 'Real-Time' using KQL Script", **click** 'Create' button and **wait** for the Queryset to get created.

	![Close the browser.](media/demo-48.png)

24. **Select** the database 'Contoso-KQL-DB' and **click** 'Select' button.

	![Close the browser.](media/demo-49.png)

22. Now this will open the Queryset editor. **Copy** the queries from step 20 and **paste** it to queryset editor. **Select** the query and **click** 'Run' button.

	![Close the browser.](media/demo-50.png)
