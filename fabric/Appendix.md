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
