![Showcase Image](media/showcase.png)

# Fabric DREAM PoC Accelerator Setup Guide

## What is DPoC?
DREAM PoC Accelerators (DPoC) are packaged DREAM Demos using ARM templates and automation scripts (with a demo web application, Power BI reports, Fabric resources, ML Notebooks etc.) that can be deployed in a customer’s environment.

## Objective & Intent
Partners can deploy DREAM Demos in their own Azure subscriptions and demonstrate them live to their customers. 
Partnering with Microsoft sellers, partners can deploy the Industry scenario DREAM demos into customer subscriptions. 
Customers can play, get hands-on experience navigating through the demo environment in their own subscription and show it to their own stakeholders.

**Here are some important guidelines before you begin** 

  1. **Read the [license agreement](https://github.com/microsoft/Azure-Analytics-and-AI-Engagement/blob/main/CDP-Retail/license.md) and [disclaimer](https://github.com/microsoft/Azure-Analytics-and-AI-Engagement/blob/main/CDP-Retail/disclaimer.md) before proceeding, as your access to and use of the code made available hereunder is subject to the terms and conditions made available therein.**
  2. Without limiting the terms of the [license](https://github.com/microsoft/Azure-Analytics-and-AI-Engagement/blob/main/CDP-Retail/license.md) , any Partner distribution of the Software (whether directly or indirectly) must be conducted through Microsoft’s Customer Acceleration Portal for Engagements (“CAPE”). CAPE is accessible to Microsoft employees. For more information aregarding the CAPE process, contact your local Data & AI specialist or CSA/GBB.
  3. It is important to note that **Azure hosting costs** are involved when DREAM PoC Accelerator is implemented in customer or partner Azure subscriptions. DPoC hosting costs are not covered by Microsoft for partners or customers.
  4. Since this is a DPoC, there are certain resources available to the public. **Please ensure that proper security practices are followed before adding any sensitive data to the environment.** To strengthen the environment's security posture, **leverage Azure Security Centre.** 
  5.  In case of questions or comments; please email **[dreamdemos@microsoft.com](mailto:dreamdemos@microsoft.com).**
  
 


## Contents

<!-- TOC -->

- [Requirements](#requirements)
- [Before Starting](#before-starting)
  - [Task 1: Power BI Workspace and Lakehouse creation](#task-1-power-bi-workspace-and-lakehouse-creation)
  - [Task 2: Run the Cloud Shell to provision the demo resources](#task-2-run-the-cloud-shell-to-provision-the-demo-resources)
  - [Task 3: Creating a Shortcut in Lakehouse](#task-3-creating-a-shortcut-in-lakehouse)
  - [Task 4: Setting up the Warehouse](#task-4-setting-up-the-warehouse)
  - [Task 5: Importing Notebooks](#task-5-importing-notebooks)
  - [Task 6: Creating Internal Shortcut](#task-6-creating-internal-shortcut)
  - [Task 7: KQL DB and QuerySet creation](#task-7-kql-db-and-queryset-creation)

- [Appendix](#appendix)
  - [Setting up the Lakehouse](#setting-up-the-lakehouse)
  - [Creating Pipelines and Dataflows](#creating-pipelines-and-dataflows)
  - [Creating a Resource Group](#creating-a-resource-group)

<!-- /TOC -->

## Requirements

* An Azure non-prod external account with the ability to create Fabric Workspace. If you don't have one, use link below to request for one.
https://mcapsservices.powerappsportals.com/SignIn?ReturnUrl=%2Fsupport%2Feslabs-newazuresubscription%2F%3FServiceId%3D78b2e66c-42f2-e811-a96a-000d3a30da4f
* A Power BI with Fabric License to host Power BI reports.
* Make sure your Power BI administrator can provide service principal access on your Power BI tenant.
* Make sure to register the following resource providers with your Azure Subscription:
   - Microsoft.Fabric
   - Microsoft.Databricks
   - Microsoft.EventHub
   - Microsoft.SQLSever
   - Microsoft.StorageAccount
   - Microsoft.AppService
* You must only execute one deployment at a time and wait for its completion.Running multiple deployments simultaneously is highly discouraged, as it can lead to deployment failures.
* Select a region where the desired Azure Services are available. If certain services are not available, deployment may fail. See [Azure Services Global Availability](https://azure.microsoft.com/en-us/global-infrastructure/services/?products=all) for understanding target service availability. (Consider the region availability for Synapse workspace, Iot Central and cognitive services while choosing a location)
* In this Accelerator, we have converted real-time reports into static reports for the users' ease but have covered the entire process to configure real-time dataset. Using those real-time dataset, you can create real-time reports.
* Make sure you use the same valid credentials to log into Azure and Power BI.
* Once the resources have been setup, ensure that your AD user and synapse workspace have “Storage Blob Data Owner” role assigned on storage account name starting with “storage”.
* Review the [License Agreement](https://github.com/microsoft/Azure-Analytics-and-AI-Engagement/blob/main/CDP-Retail/license.md) before proceeding.


### Task 1: Power BI Workspace and Lakehouse creation

1. **Open** Power BI in a new tab by clicking [HERE](https://app.powerbi.com/)
>**Note:** Make sure to login using non-prod external subscription credentials.

3. **Sign in** to Power BI.

	![Sign in to Power BI.](media/power-bi.png)

	> **Note:** Use your Azure Active Directory credentials to login to Power BI.

4. In Power BI service **click** 'Workspaces'.

5. **Click** '+ New workspace' button.

	![Create Power BI Workspace.](media/power-bi-2.png)

6. **Enter** the name as 'contosoSales', expand Advanced and select Trial under License mode  and **click** 'Apply'.

>**Note:** The name of the workspace should be in camel case, i.e. the first word starting with a small letter and then the second word staring with a capital letter with no spaces in between.

>If name 'contosoSales' is already taken, add some suffix to the end of the name for eg. 'contosoSalesTest'.

>Workspace name should not have any spaces.

7. **Copy** the Workspace GUID or ID from the address URL.

8. **Save** the GUID in a notepad for future reference.

	![Give the name and description for the new workspace.](media/power-bi-3.png)

	> **Note:** This workspace ID will be used during powershell script execution.

9. In Power BI service **Click** '+ New' and then **select** 'More options'.

   <img width="343" alt="image" src="https://github.com/swmannepalli/MicrosoftFabric_HOL/assets/84516667/6b6af585-e359-4fca-bafa-bc37bcda342e">


10. In the new window **click** 'Lakehouse(Preview)'.

    ![Close the browser.](media/demo-6.png)

11. **Enter** the name as 'lakehouseBronze'.

12. **Click** 'Create' button.

    ![Close the browser.](media/demo-7.png)

13. **Click** 'Workspaces' and **select** 'contosoSales'.

	![Give the name and description for the new workspace.](media/power-bi-5.png)

14. **Repeat** step number 9 to 12 to create two more lakehouses with names 'lakehouseSilver' and 'lakehouseGold' respectively.

17. **Repeat** step number 4 to 6 to **create** a new workspace with the name 'contosoFinance' and then **create** a lakehouse in it and name it 'lakehouseFinance'.

>**Note:** Make sure to add this workspace has fabric Trial License as well and note the names of the workspaces and lakehouses as these will be used during the script execution(Task 2)
>**Note:** **Copy** the Workspace GUID or ID from the address URL and **Save** the GUID in a notepad for future reference.


### Task 2: Run the Cloud Shell to provision the demo resources

1. **Open** Azure Portal in a new tab by clicking [HERE](https://portal.azure.com/)
   
   >**Note:** Make sure to login using non-prod external subscription credentials.

2. In the Resource group section, **select** the Terminal icon to open Azure Cloud Shell.

	![A portion of the Azure Portal taskbar is displayed with the Azure Cloud Shell icon highlighted.](media/cloud-shell.png)

3. **Click** on the 'PowerShell'.

4. **Click** 'Show advanced settings'.

	![Mount a Storage for running the Cloud Shell.](media/cloud-shell-2.png)

	> **Note:** If you already have a storage mounted for Cloud Shell, you will not get this prompt. In that case, skip step 5 and 6.

5. **Select** your 'Subscription', 'Cloud Shell region' and 'Resource Group'.

>**Note:** If you do not have an existing resource group please follow the steps mentioned [HERE](#creating-a-resource-group) to create one. Complete the task and then continue with the below steps.

>Cloud Shell region need not be specific, you may select any region which works best for your experience.

6. **Enter** the 'Storage account', 'File share' name and then **click** on 'Create storage'.

	![Mount a storage for running the Cloud Shell and Enter the Details.](media/cloud-shell-3.png)

	> **Note:** If you are creating a new storage account, give it a unique name with no special characters or uppercase letters. The whole name should be in small case and not more than 24 characters.

	> It is not mandatory for storage account and file share name to be same.

7. In the Azure Cloud Shell window, ensure that the PowerShell environment is selected.

	![Git Clone Command to Pull Down the demo Repository.](media/cloud-shell-3.1.png)

	>**Note:** All the cmdlets used in the script works best in Powershell.	

8. **Enter** the following command to clone the repository files in cloudshell.

Command:
```
git clone -b microsoftfabric --depth 1 --single-branch https://github.com/swmannepalli/MicrosoftFabric_HOL.git fabric
```

   <img width="1243" alt="image" src="https://github.com/swmannepalli/MicrosoftFabric_HOL/assets/84516667/0aa3f391-dc61-48f0-8999-84a92a06df62">

	
   > **Note:** If you get File already exist error, please execute the following command to delete existing clone and then reclone:
```
 rm fabric -r -f 
```
   > **Note**: When executing scripts, it is important to let them run to completion. Some tasks may take longer than others to run. When a script completes execution, you will be returned to a command prompt. 

9. **Execute** the Powershell script with the following command:
```
cd ./fabric/fabric/
```

```
./fabricSetup.ps1
```
      
10. From the Azure Cloud Shell, **copy** the authentication code. You will need to enter this code in next step.

11. **Click** the link [https://microsoft.com/devicelogin](https://microsoft.com/devicelogin) and a new browser window will launch.

	![Authentication link and Device Code.](media/cloud-shell-6.png)
     
12. **Paste** the authentication code.

	![New Browser Window to provide the Authentication Code.](media/cloud-shell-7.png)

13. **Select** the user account that is used for logging into the Azure Portal in [Task 1](#task-1-create-a-resource-group-in-azure).

	![Select the User Account which you want to Authenticate.](media/cloud-shell-8.png)

14. **Click** on 'Continue' button.

	![Select the User Account which you want to Authenticate.](media/cloud-shell-8.1.png)

15. **Close** the browser tab once you see the message box.

	![Authentication done.](media/cloud-shell-9.png)  

16. **Navigate back** to your Azure Cloud Shell execution window.

17. **Copy** the code on screen to authenticate Azure PowerShell script for creating reports in Power BI.

18. **Click** the link [https://microsoft.com/devicelogin](https://microsoft.com/devicelogin).

	![Authentication link and Device code.](media/cloud-shell-10.png)

19. A new browser window will launch.

20. **Paste** the authentication code you copied from the shell above.

	![Enter the Resource Group name.](media/cloud-shell-11.png)

21. **Select** the user account that is used for logging into the Azure Portal in [Task 1](#task-1-create-a-resource-group-in-azure).

	![Select Same User to Authenticate.](media/cloud-shell-12.png)

22. **Click** on 'Continue'.

	![Select Same User to Authenticate.](media/cloud-shell-12.1.png)

23. **Close** the browser tab once you see the message box.

	![Close the browser tab.](media/cloud-shell-13.png)

24. **Go back** to Azure Cloud Shell execution window.

25. **Copy** your subscription name from the screen and **paste** it in the prompt.

    ![Close the browser tab.](media/select-sub.png)
	
	> **Notes:**
	> - The user with single subscription won't be prompted to select subscription.
	> - The subscription highlighted in yellow will be selected by default if you do not enter any disired subscription. Please select the subscription carefully, as it may break the execution further.
	> - While you are waiting for processes to get completed in the Azure Cloud Shell window, you'll be asked to enter the code three times. This is necessary for performing installation of various Azure Services and preloading the data.

26. **Enter** the Region for deployment with necessary resources available, preferably "eastus". (ex. eastus, eastus2, westus, westus2 etc)

	![Enter Resource Group name.](media/cloudshell-region.png)

27. **Enter** desired SQL Password.

	![Enter Resource Group name.](media/cloud-shell-14.png)

>**Note:** Copy the password in Notepad for further reference.

28. **Enter** the workspace ids which you copied in Step 7 and 17 of [Task 1](#task-1-power-bi-workspace-and-lakehouse-creation).

<img width="619" alt="image" src="https://github.com/swmannepalli/MicrosoftFabric_HOL/assets/84516667/f77dbeab-9bf1-4b63-a275-c18bfcb98e7b">

29. **Enter** all the lakehouses name one by one.

<img width="418" alt="image" src="https://github.com/swmannepalli/MicrosoftFabric_HOL/assets/84516667/9fd15a1a-47f2-4de0-855c-52630d43c795">


30. You will get another code to authenticate the Azure PowerShell script for creating reports in Power BI. **Copy** the code.

	> **Note:** You may see errors in script execution if you  do not have necessary permissions for cloudshell to manipulate your Power BI workspace. In that case, follow this document [Power BI Embedding](https://github.com/microsoft/Azure-Analytics-and-AI-Engagement/blob/fintax/fintaxdemo/Power%20BI%20Embedding.md) to get the necessary permissions assigned. You’ll have to manually upload the reports to your Power BI workspace by downloading them from this location [Reports](https://github.com/microsoft/Azure-Analytics-and-AI-Engagement/tree/fintax/fintaxdemo/artifacts/reports). 

31. **Click** the link [https://microsoft.com/devicelogin](https://microsoft.com/devicelogin).

    ![Click the link.](media/cloud-shell-16.png)
      
32. In the new browser tab, **paste** the code that you copied from the shell in step 34 and **click** on 'Next'.

	![Paste the code.](media/cloud-shell-17.png)

	> Note: Make sure to provide the device code before it expires and let the script run till completion.

33. **Select** the user account that is used for logging into the Azure Portal in [Task 1](#task-1-create-a-resource-group-in-azure). 

	![Select the same user.](media/cloud-shell-18.png)

34. **Click** on 'Continue'.

	![Select the same user.](media/cloud-shell-18.1.png)

35. **Close** the browser tab once you see the message box.

	![Close the browser.](media/cloud-shell-19.png)

	>**Note:** During script execution you need to note the resource group which gets created, since a resource group with unique suffix is created each time the script is executed.

36. **Navigate back** to your Azure Cloud Shell execution window.

	> **Note:** The deployment will take approximately 20-30 minutes to complete. Keep checking the progress with messages printed in the console to avoid timeout.

37. After the script execution is complete, the user is prompted "--Execution Complete--"
	
38. **Go to** Azure Portal and **search** for 'fabric-dpoc' and **click** on the resource group name which was created by the script.

	![Close the browser.](media/demo-1.1.png)

	>**Note:** The resource group name starts with 'fabric-dpoc-' with some random unique suffix in the end.

39. In the search pane of the resource group **type** "app-realtime-kpi-analytics..." and **select** the resource.

	![Close the browser.](media/demo-1.png)

40. **Click** "Browse" and a new tab will open.

	![Close the browser.](media/demo-2.png)

41. **Wait** for the tab to load till you get the following screen.

	![Close the browser.](media/demo-3.png)


### Task 3: Creating a Shortcut in Lakehouse

1. **Open** [Power BI](https://app.powerbi.com/)

2. In PowerBI, **click** 'Workspaces' and **select** 'contosoSales'

    ![Lakehouse.](media/demo-4.png)

3. In 'contosoSales' workspace, **click** on 'lakehouseBronze' lakehouse.

    ![Lakehouse.](media/lakehouse-1.png)
   
4.  **Click** on the three dots in front of Files.
5. **Click** on 'New shortcut'.

	![Lakehouse.](media/lakehouse-2.png)

6. In the pop-up window, under External sources **select** 'Azure Data Lake Storage Gen2'

	![Lakehouse.](media/demo-9.png)

7. In a new tab **open** the resource group created in [Task 2](#task-2-run-the-cloud-shell-to-provision-the-demo-resources) while script execution with name 'fabric-dpoc-...'.

8. **Search** for 'storage account', **click** the storage account resource.

	![Lakehouse.](media/demo-10.png)

10. In the resource window **goto** the left pane and **scroll down**.
11. In 'Security + networking' section, **click** 'Access keys'.
12. **Click** 'Show' button under key1.

	![Lakehouse.](media/demo-11.png)

13. **Click** 'Copy to clickboard' button.
14. **Save** it in a notepad for further use.

	![Lakehouse.](media/demo-12.png)

15. **Scroll down** in the left pane.
16. **Select** 'Endpoints' from 'Settings' section.
17. **Scroll down** and **copy** the 'Data Lake Storage' endpoint under 'Data Lake Storage' section.
18. **Save** it in a notepad for further use.

	![Lakehouse.](media/demo-12.1.png)

>**Note:** You may see different endpoints as well in the above screen. Make sure to select only the Data Lake Storage endpoint.

19. **Navigate back** to Power BI workspace i.e. the powerbi tab.
20. **Paste** the endpoint copied under the 'URL' field.

21. In the 'Authentiation kind' dropdown, **select** 'Account Key'.

22. **Paste** the account key copied.

23. **Click** on 'Next'.

	![Lakehouse.](media/demo-12.2.png)

24. Under Shortcut Name **type** 'sales-transaction-litware'.

25. **Verify** the URL is same as the one you copied in step 17.

26. Under Sub Path **type** '/bronzeshortcutdata'.

27. **Click** the **Create** button.

	![Lakehouse.](media/lakehouse-3.png)


### Task 4: Setting up the Warehouse

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

35. **Click** on [Warehouse Scripts](https://github.com/microsoft/Azure-Analytics-and-AI-Engagement/tree/microsoftfabric/fabric/artifacts/warehousescripts) link in new tab to open the scripts.

36. **Click** the first script to open it.

	![Datawarehouse.](media/warehouse-19.png)
37. **copy** the script and paste in the SQL Query tab in Data Warehouse page. **Replace** '#STORAGE_ACCOUNT_NAME#' and '#STORAGE_ACCOUNT_SAS_TOKEN#'. To get these values, 

38. In a new tab **open** the resource group created in [Task 2](#task-2-run-the-cloud-shell-to-provision-the-demo-resources).

39. **Search** for the 'Storage account' **copy** the 'Storage account' and **paste** it in the SQL Squery.

	![Datawarehouse.](media/warehouse-22.png)

40. **Click** on searched 'Storage account', **scrolldown** left pane and **click** to select 'Shared access signature'.

	![Datawarehouse.](media/warehouse-23.png)

41. **Select** 'Container' in 'Allowed resource type'. **select** 'Read','Write', 'List' in 'Allowed permissions' keep  rest all uncheck. In 'Start and expiry date/time' **select** date & time and then **scrolldown** to **click** 'Generate SAS and connection string' button.

	![Datawarehouse.](media/warehouse-24.png)

	![Datawarehouse.](media/warehouse-25.png)

42. Below the 'Generate SAS and connection string' button, we can see the generated SAS token. **Copy** and paste it in the SQL Squery.

	![Datawarehouse.](media/warehouse-26.png)

43.  **Right click** on 'SQL query 1' and **click** 'Rename'.

	![Datawarehouse.](media/warehouse-27.png)

48. **Enter** the name as '00 Ingest Data In DW Using COPY INTO Command.sql' and **click** 'Rename' button.

	![Datawarehouse.](media/warehouse-28.png)

49. **Click** the 'three dots (Ellipsis)' in front of the name of the scripts and **select** 'Move to Shared queries'.

	![Datawarehouse.](media/warehouse-29.png)

>**Note:** We are going to create 2 more scripts following the above steps for querying the Warehouse data.

48. **Repeat** above steps for the other two scripts in the repository. Get the scripts [HERE](https://github.com/microsoft/Azure-Analytics-and-AI-Engagement/tree/microsoftfabric/fabric/artifacts/warehousescripts)

>**Note:** If there are no replacements necessary in the scripts, you can skip the steps in between.
> We're not going to execute these scripts now as the tables are already created as part of deployment. These scripts are for your reference in the future.

49. **Click** 'New visual query'.

	![Datawarehouse.](media/warehouse-30.png)

50. **Click** and **drag** the table 'DimProduct' to the canvas.

	![Datawarehouse.](media/warehouse-31.png)

51. **Click** and **drag** the table 'FactSales' to the canvas.

	![Datawarehouse.](media/warehouse-40.png)

52. **Click** 'Combine' and **select** 'Merge queries as new'.

	![Datawarehouse.](media/warehouse-32.png)

53. In the 'Left table for merge' **select** 'DimProduct' from the dropdown and **click** on column 'ProductKey' of the table.

	![Datawarehouse.](media/warehouse-33.png)

54. **Scroll down** in the 'Right table for merge' **select** 'FactSales' from the dropdown and **click** on column 'ProductKey' of the table.

	![Datawarehouse.](media/warehouse-34.png)

55. **Scroll down** to Join kind section and **click** on 'Inner' radio button and click on 'OK' button.

	![Datawarehouse.](media/warehouse-35.png)

56. You would see the following result.

	![Datawarehouse.](media/warehouse-36.png)

57. **Right click** on 'Visual query 1' and **select** 'Rename'.

	![Datawarehouse.](media/warehouse-37.png)

58. **Enter** the name as "Visual query- Total Sales By Product" and **click** on 'Rename' button.

	![Datawarehouse.](media/warehouse-38.png)

59. **Click** on the 'three dots' infront of the visual query name and **click** one 'Moved to Shared queries'

	![Datawarehouse.](media/warehouse-39.png)

### Task 5: Importing Notebooks

1. In the Cloudshell window **click** on the 'Upload/Download files' button and **select** 'Download'.

	![Datawarehouse.](media/notebook-7.png)

2. **Enter** the path as "fabric/fabric/artifacts/fabricnotebooks/01 Marketing Data to Lakehouse (Bronze) - Code-First Experience.ipynb" in the download tab and **click** on 'Download' button.

	![Datawarehouse.](media/notebook-8.png)

3. In the right bottom corner of the screen **click** on the highlighted link as shown in the screenshot.

	![Datawarehouse.](media/notebook-9.png)

4. **Verify** the file name and **click** on 'Save' button.

	![Datawarehouse.](media/notebook-10.png)

5. Perform steps 1 through 4 for all five notebooks, replacing the names of the individual notebooks in the path "fabric/fabric/artifacts/fabricnotebooks/#notebook_name#"

	Names of the other notebooks are as follows:
	```
		02 Bronze to Silver layer_ Medallion Architecture.ipynb

		03 Silver to Gold layer_ Medallion Architecture.ipynb

		04 Churn Prediction Using MLFlow From Silver To Gold Layer.ipynb

		05 Sales Forecasting for Store items in Gold Layer.ipynb
	```

6. **Open** Fabric workspace in a new tab using the following link:  [https://app.powerbi.com/](https://app.powerbi.com/) at the bottom left corner **click** 'Power BI' and **select** 'Data Science'.

	![Datawarehouse.](media/notebook-1.png)

7. **Click** 'Import notebook'.

	![Datawarehouse.](media/notebook-2.png)
	
8. In the Import Status, **click** 'Upload' button.

	![Datawarehouse.](media/notebook-3.png)
	
9. **Browse** to the downloaded notebooks from your local system **select** all the notebooks and **click** the 'Open' button.

	![Datawarehouse.](media/notebook-4.png)

10. **Click** the 'notification' icon to check the status of upload. Once upload is done, it will show the notification as 'Imported succussfully'. Now **click**'Go to Workspace' and verify.

	![Datawarehouse.](media/notebook-5.png)

11. In the workspace **click** on the "02 Bronze to Silver layer_ Medallion Architecture" notebook.

	![Datawarehouse.](media/notebook-6.png)

12. In the left pane **click** on 'Missing Lakehouse' button and **select** 'Remove all Lakehouses'.

	![Datawarehouse.](media/notebook-11.png)

>**Note:** In case you do not see Missing lakehouse, you would see 'lakehouse{Name}', click on the same to get the 'Remove all Lakehosues' option.

13. **Click** on 'Continue' in the pop-up window.

	![Datawarehouse.](media/notebook-12.png)

14. In the left pane **click** on the 'Add' button.

	![Datawarehouse.](media/notebook-13.png)

15. In the pop-up **select** 'Existing Lakehouse' radio button and then **click** on 'Add' button.

	![Datawarehouse.](media/notebook-14.png)

16. **Click** on 'lakehouseSilver' checkbox and **click** on 'Add'.

	![Datawarehouse.](media/notebook-15.png)

17. Similarly **perform** step number 11 to step number 16 for the other notebooks as well.

>**Note:** To perform the above steps you need to attach the notebooks to respective lakehouses before runnig the notebooks. Follow the below instruction for the same.

18. Refer the below table to attach notebooks with the respective lakehouses

	|	Notebook	|	Lakehouse	|
	| -----------	| ------------- |
	|	02 Bronze to Silver layer_ Medallion Architecture.ipynb	|	lakehouseSilver	|
	|	03 Silver to Gold layer_ Medallion Architecture.ipynb	|	lakehouseGold	|
	|	04 Churn Prediction Using MLFlow From Silver To Gold Layer	|	lakehouseSilver	|
	|	05 Sales Forecasting for Store items in Gold Layer	|	lakehouseSilver	|
	|||

>**Note:** Please complete Task 6 and then execute notebook '05 Sales Forecasting for Store items in Gold Layer'.

> Please comeback to continue with the below given steps after completing Task 6

19. In PowerBI workspace **click** on 'Workspaces' and **select** 'contosoSales'.

	![Close the browser.](media/demo-4.png)

20. **Filter** 'Notebook' and then **click** on the notebook '03 Silver to Gold layer_ Medallion Architecture'

	![Close the browser.](media/notebook-16.png)

21. **Click** on the 'Run all' button.

	![Close the browser.](media/notebook-17.png)

### Task 6 : Creating Internal Shortcut

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

	![Close the browser.](media/LakehouseGoldShortcut3.png)

6. **Click** on Tables, **select** 'dimension_date' and then **click** on 'Create'.

	![Close the browser.](media/LakehouseGoldShortcut4.png)

7. **Repeat** step number 2 to step number 6 for the other tables in the below tables.

	|	Table Name	|	Create Shortcut From Lakehouse	|
	| -----------	| ------------- |
	|	dimesion_product|	lakehouseSilver	|
	|	dimesion_customer|	lakehouseSilver	|
	|	fact_sales|	lakehouseSilver	|
	|	fact_campaigndata|	lakehouseSilver	|
	|||

>**Note:** Once you are done with Task 6 please go back to Task 5 and follow the steps from the point where you had stopped.


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

19. Once you see the table size is increased then, **click** 'Check your data' button. 

	![Close the browser.](media/demo-45.png)

20. It will open the KQL queryset editor. **Click** link [KQL Queryset Scripts](https://github.com/microsoft/Azure-Analytics-and-AI-Engagement/tree/microsoftfabric/fabric/artifacts/kqlscripts). **Copy** and **paste** the script in the editor and **click** 'Run' button.

	![Close the browser.](media/demo-46.png)

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

### Appendix

This section is optional and created to showcase other data ingestion options. Use it as a refrence if you have your own Dataverse and Snowflake connections.

### Setting up the Lakehouse

1. To **Open** Power BI in a new tab, click [HERE](https://app.powerbi.com/)

2. **Sign in**, to Power BI using your Power BI with Fabric License account.

	![Sign in to Power BI.](media/power-bi.png)

	> **Note:** Use the same credentials for Power BI which you will be using for the Azure account.

3. In Power BI service **Click** 'Workspaces' and **select** 'contosoSales'

    ![Close the browser.](media/demo-4.png)

4. **Click** '+ New' and then **select** 'Show all'.

    ![Close the browser.](media/demo-5.png)

5. In the new window **click** 'Lakehouse(Preview)'.

    ![Close the browser.](media/demo-6.png)

6. **Enter** the name as 'lakehouseBronze' and **click** 'Create' button.

    ![Close the browser.](media/demo-7.png)

7. **Wait** for the lakehouse to create, **click** the three dots(Ellipsis) in front of the 'Files' and **select** 'New shortcut'

    ![Close the browser.](media/demo-8.png)

8. In the pop-up window, under External sources **select** 'Azure Data Lake Storage Gen2'

	![Close the browser.](media/demo-9.png)

>**Note:** To fill in the required fields in the pop-up screen you need to fetch it from the storage account resource. Follow the below steps to get those data.

9. In a new tab,**open** the resource group created in Task 2, which you noted while script execution with name starting with 'fabric-dpoc-'.

10. **Search** for 'storage account', **click** the storage account resource.

	![Close the browser.](media/demo-10.png)

11. In the Storage account window **scroll down** the left pane, in the 'Security + networking' section, **click** 'Access keys' and **click** 'Show' button under key1.

	![Close the browser.](media/demo-11.png)

12. **Click** 'Copy to clickboard' button and **paste** it in notepad for further use.

	![Close the browser.](media/demo-12.png)

13. Again **scroll down** in the left pane, **select** Settings >> 'Endpoints' section. **Copy** the 'Primary endpoint' under 'Data Lake Storage' section, and **paste** it in notepad for further use.

	![Close the browser.](media/demo-12.1.png)

14. **Go back** the powerbi workspace, under 'URL' **paste** the endpoint copied in step number 13.

15. In the 'Authentiation kind' dropdown **select** 'Account Key'.

16. **Paste** the account key copied in step number 12.

17. **Click** 'Next'.

	![Close the browser.](media/demo-12.2.png)

18. Under Shortcut Name **type** 'BlobToLakehouse'.

19. Verify the URL.

20. Under Sub Path **type** '/bronzelakehousefiles'.

21. **Click** the **Create** button.

	![Close the browser.](media/demo-12.3.png)

### Creating Pipelines and Dataflows

1. While you are in the 'contosoSales' workspace **click** '+ New' button and **select** 'Show all'.

	![Pipeline.](media/pipeline-1.png)

2. Under Data Factory section, **select** 'Dataflow Gen2 (Preview).

	![Pipeline.](media/pipeline-2.png)

3. In the dataflow window, **click** the default dataflow name 'Dataflow 1' and in the Name field **type** '04 Customer Insights Data from Dataverse' finally **click** somewhere outside the rename box to update the dataflow name.

	![Pipeline.](media/pipeline-3.png)

4. **Click** 'Get data' and **click** 'More...'.

	![Pipeline.](media/pipeline-4.png)

5. **Click** 'Dataverse'.

	![Pipeline.](media/pipeline-5.png)

6. **Enter** the Dynamics 365 credentials if available and then **click** 'Next' button.

	![Pipeline.](media/pipeline-6.png)

7. **Go back** to the workspace, **click** '+ New' and **click** 'Show all'.

	![Pipeline.](media/pipeline-1.png)

8. Under Data Factory section, **select** 'Data pipeline (Preview).

	![Pipeline.](media/pipeline-7.png)

9. **Type** the name as '03 Customer Insights Dataflow trigger from Data' and **click** 'Create'.

	![Pipeline.](media/pipeline-8.png)

10. Wait for the pipeline to create, **click** 'Add pipeline activity' and **click** 'Dataflow'.

	![Pipeline.](media/pipeline-9.png)

11. **Click** the new dataflow activity, in General tab **type** the name as 'Customer Insights Data to Lakehouse'.

	![Pipeline.](media/pipeline-10.png)

12. In the Settings tab **attach** it to the dataflow created in the earlier steps.

	![Pipeline.](media/pipeline-11.png)

13. Similarly **create** another pipeline with the name "01 Campaigns data from Snowflake to Lakehouse - Low Code Experience"

14. Once the pipeline is created **click** on 'Lookup'. 

	![Pipeline.](media/pipeline-12.png)

15. In 'General' tab of the Lookup activity **enter** 'Name' as "Check if Snowflake Campaign Data exist" and 'Description' as "GetMetadata activity is used to ensure the source dataset is ready for downstream consumption, before triggering the copy and analytics job."

	![Pipeline.](media/pipeline-13.png)

16. In the 'Settings' tab **select** the External radio button, and **click** 'New'.

	![Pipeline.](media/pipeline-14.png)

17. In the 'New connection' pop-up window, **scroll down** to **select** 'Snowflake' and **click** 'Continue'.

	![Pipeline.](media/pipeline-15.png)

18. **Enter** your Server, Warehouse, Username, and Password for Snowflake if available.

	![Pipeline.](media/pipeline-16.png)	

	![Pipeline.](media/pipeline-17.png)	

19. Once your connection setup is done, **enter** the details as shown.

	![Pipeline.](media/pipeline-18.png)	

20. **Click** 'Copy data activity' and **select** 'Add to canvas'.

	![Pipeline.](media/pipeline-19.png)	

21. In the 'General' tab **enter** 'Name' as 'SnowflakeDB To Lakehouse'.

	![Pipeline.](media/pipeline-20.png)	

22. **Enter** the values in the 'Source' tab.

	![Pipeline.](media/pipeline-21.png)	

23. **Enter** the values in the 'Destination' tab.

	![Pipeline.](media/pipeline-22.png)	

24. **Click** the 'green tick' on the Lookup and drag it to Copy data as shown in the screenshot.

	![Pipeline.](media/pipeline-23.png)

### Creating a Resource Group

1. **Log into** the [Azure Portal](https://portal.azure.com) using your Azure credentials.

2. On the Azure Portal home screen, **select** the '+ Create a resource' tile.

	![A portion of the Azure Portal home screen is displayed with the + Create a resource tile highlighted.](media/create-a-resource.png)

3. In the Search the Marketplace text box, **type** "Resource Group" and **press** the Enter key.

	![On the new resource screen Resource group is entered as a search term.](media/resource-group.png)

4. **Select** the 'Create' button on the 'Resource Group' overview page.

	![A portion of the Azure Portal home screen is displayed with Create Resource Group tile](media/resource-group-2.png)
	
5. On the 'Create a resource group' screen, **select** your desired Subscription. For Resource group, **type** 'cloudshell-dpoc'. 

6. **Select** your desired region.

	> **Note:** Some services behave differently in different regions and may break some part of the setup. Choosing one of the following regions is preferable: 		westus2, eastus2, northcentralus, northeurope, southeastasia, australliaeast, centralindia, uksouth, japaneast.

7. **Click** the 'Review + Create' button.

	![The Create a resource group form is displayed populated with Synapse-MCW as the resource group name.](media/resource-group-3.png)

8. **Click** the 'Create' button once all entries have been validated.

	![Create Resource Group with the final validation passed.](media/resource-group-4.png)


# Copyright

© 2023 Microsoft Corporation. All rights reserved.   

By using this demo/lab, you agree to the following terms: 

The technology/functionality described in this demo/lab is provided by Microsoft Corporation for purposes of obtaining your feedback and to provide you with a learning experience. You may only use the demo/lab to evaluate such technology features and functionality and provide feedback to Microsoft.  You may not use it for any other purpose. You may not modify, copy, distribute, transmit, display, perform, reproduce, publish, license, create derivative works from, transfer, or sell this demo/lab or any portion thereof. 

COPYING OR REPRODUCTION OF THE DEMO/LAB (OR ANY PORTION OF IT) TO ANY OTHER SERVER OR LOCATION FOR FURTHER REPRODUCTION OR REDISTRIBUTION IS EXPRESSLY PROHIBITED. 

THIS DEMO/LAB PROVIDES CERTAIN SOFTWARE TECHNOLOGY/PRODUCT FEATURES AND FUNCTIONALITY, INCLUDING POTENTIAL NEW FEATURES AND CONCEPTS, IN A SIMULATED ENVIRONMENT WITHOUT COMPLEX SET-UP OR INSTALLATION FOR THE PURPOSE DESCRIBED ABOVE. THE TECHNOLOGY/CONCEPTS REPRESENTED IN THIS DEMO/LAB MAY NOT REPRESENT FULL FEATURE FUNCTIONALITY AND MAY NOT WORK THE WAY A FINAL VERSION MAY WORK. WE ALSO MAY NOT RELEASE A FINAL VERSION OF SUCH FEATURES OR CONCEPTS.  YOUR EXPERIENCE WITH USING SUCH FEATURES AND FUNCITONALITY IN A PHYSICAL ENVIRONMENT MAY ALSO BE DIFFERENT.
