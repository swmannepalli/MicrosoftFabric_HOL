 [Home](Readme-shell.md) -  [Next Task (Shortcut Creation) >](Task3-Creating-a-Shortcut-in-Lakehouse.md)

### Task 2: Run the Cloud Shell to provision the demo resources

In this task the following serives are deployed which are used in different tasks.

<img width="702" alt="image" src="https://github.com/swmannepalli/MicrosoftFabric_HOL/assets/84516667/c445ac3f-e201-43ed-a643-d84ba5846173">

In addition, 

1. Files are uploaded to lakehouseBronze, tables are created in lakehouseSilver.
2. Power BI reports are generated along with datasets.

-------------------------------------------------------------------------------------------------------------------------------------------------------

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

[Continue >](Task3-Creating-a-Shortcut-in-Lakehouse.md)
