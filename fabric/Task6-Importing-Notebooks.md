[Home](Readme-shell.md) -  [Next Task (Real-Time Analytics) >](Task7-KQL-DB-and-QuerySet-creation.md)

### Task 6: Importing Notebooks

In this task, we import 5 notebooks and do not execute them as some of them are automatically created as part of deployment. For reference only.

---------------------------------------------------------------------------------------------------------------------------------

1. Click and open [link](artifacts/fabricnotebooks) in new tab to download notebooks. You can download one at a time, click on each notebook and download raw file.

2. **Open** Fabric workspace in a new tab using the following link:  [https://app.powerbi.com/](https://app.powerbi.com/) at the bottom left corner **click** 'Power BI' and **select** 'Data Science'.

	![Datawarehouse.](media/notebook-1.png)

3. **Click** 'Import notebook'.

	![Datawarehouse.](media/notebook-2.png)
	
4. In the Import Status, **click** 'Upload' button.

	![Datawarehouse.](media/notebook-3.png)
	
5. **Browse** to the downloaded notebooks from your local system **select** all the notebooks and **click** the 'Open' button.

	![Datawarehouse.](media/notebook-4.png)

6. **Click** the 'notification' icon to check the status of upload. Once upload is done, it will show the notification as 'Imported succussfully'. Now **click**'Go to Workspace' and verify.

	![Datawarehouse.](media/notebook-5.png)

7. In the workspace **click** on the "03 Silver to Gold layer_ Medallion Architecture" notebook.


8. In the left pane **click** on 'Missing Lakehouse' button and **select** 'Remove all Lakehouses'.

	![Datawarehouse.](media/notebook-11.png)

>**Note:** In case you do not see Missing lakehouse, you would see 'lakehouse{Name}', click on the same to get the 'Remove all Lakehosues' option.

9. **Click** on 'Continue' in the pop-up window.

	![Datawarehouse.](media/notebook-12.png)

10. In the left pane **click** on the 'Add' button.

	![Datawarehouse.](media/notebook-13.png)

11. In the pop-up **select** 'Existing Lakehouse' radio button and then **click** on 'Add' button.

	![Datawarehouse.](media/notebook-14.png)

12. **Click** on 'lakehouseGold' checkbox and **click** on 'Add'.

For this workshop, we can skip steps 13 and 14 as we're not executing other notebooks now. 

13. Similarly **perform** step number 7 to step number 12 for the other notebooks as well.

>**Note:** To perform the above steps you need to attach the notebooks to respective lakehouses before runnig the notebooks. Follow the below instruction for the same.

14. Refer the below table to attach notebooks with the respective lakehouses

	|	Notebook	|	Lakehouse	|
	| -----------	| ------------- |
	|	02 Bronze to Silver layer_ Medallion Architecture.ipynb	|	lakehouseSilver	|
	|	03 Silver to Gold layer_ Medallion Architecture.ipynb	|	lakehouseGold	|
	|	04 Churn Prediction Using MLFlow From Silver To Gold Layer	|	lakehouseSilver	|
	|	05 Sales Forecasting for Store items in Gold Layer	|	lakehouseGold	|
	|||

15. In step#2, replace #LAKEHOUSE_GOLD with the gold lakehouse created. Run each cell in '03 Silver to Gold layer_ Medallion Architecture' notebook and look at the output

	
[Continue >](Task7-KQL-DB-and-QuerySet-creation.md)
