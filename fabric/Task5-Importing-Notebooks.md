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
