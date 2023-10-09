 [Home](Readme-shell.md) -  [Next Task (Demo Resources Provision) >](Task2-Run-the-Cloud-Shell-to-provision-the-demo-resources.md)

### Task 1: Power BI Workspace and Lakehouse creation

 In this task we create a workspace - ContosoSales and three lakehouses - lakehouseBronze, lakehouseSilver and lakehouseGold.

-------------------------------------------------------------------------------------------------------------------

1. **Open** Power BI in a new tab by clicking [HERE](https://app.powerbi.com/)


>**Note:** Make sure to login using non-prod external subscription credentials.

2. **Sign in** to Power BI.

	![Sign in to Power BI.](media/power-bi.png)

	> **Note:** Use your Azure Active Directory credentials to login to Power BI.

3. In Power BI service **click** 'Workspaces'.

4. **Click** '+ New workspace' button.

	![Create Power BI Workspace.](media/power-bi-2.png)

5. **Enter** the name as 'contosoSales', expand Advanced and select Trial under License mode  and **click** 'Apply'.

>**Note:** The name of the workspace should be in camel case, i.e. the first word starting with a small letter and then the second word staring with a capital letter with no spaces in between.

>If name 'contosoSales' is already taken, add some suffix to the end of the name for eg. 'contosoSalesTest'.

>Workspace name should not have any spaces.

6. **Copy** the Workspace GUID or ID from the address URL.

7. **Save** the GUID in a notepad for future reference.

	![Give the name and description for the new workspace.](media/power-bi-3.png)

	> **Note:** This workspace ID will be used during powershell script execution.

8. In Power BI service **Click** '+ New' and then **select** 'More options'.

   <img width="343" alt="image" src="https://github.com/swmannepalli/MicrosoftFabric_HOL/assets/84516667/6b6af585-e359-4fca-bafa-bc37bcda342e">


9. In the new window **click** 'Lakehouse(Preview)'.

    ![Close the browser.](media/demo-6.png)

10. **Enter** the name as 'lakehouseBronze'.

11. **Click** 'Create' button.

    ![Close the browser.](media/demo-7.png)

12. **Click** 'Workspaces' and **select** 'contosoSales'.

	![Give the name and description for the new workspace.](media/power-bi-5.png)

13. **Repeat** step number 9 to 12 to create two more lakehouses with names 'lakehouseSilver' and 'lakehouseGold' respectively.


>**Note:** Make sure to add this workspace has fabric Trial License as well and note the names of the workspaces and lakehouses as these will be used during the script execution(Task 2)
>**Note:** **Copy** the Workspace GUID or ID from the address URL and **Save** the GUID in a notepad for future reference.

[Continue >](Task2-Run-the-Cloud-Shell-to-provision-the-demo-resources.md)
