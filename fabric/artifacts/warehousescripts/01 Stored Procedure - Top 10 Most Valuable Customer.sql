---------------

Create or Alter PROCEDURE Top10_MostValuableStores
as 

    With resultdata as( 
    Select  
	DS.StoreName,
        DP.ProductName, 
        Sum(Cast(FS.SalesAmount as decimal(18,2))) TotalSalesAmount 
        ,DENSE_RANK()  OVER (ORDER BY Sum(Cast(FS.SalesAmount as decimal(18,2))) desc) as  RankCol 
        From FactOnlineSales FS  
        Inner Join 
        DimProduct DP on DP.ProductKey=FS.ProductKey 
        Inner Join 
        DimStore DS on DS.StoreKey=FS.StoreKey 
        Group BY DS.StoreName, 
        DP.ProductName 
        ) 
    Select  
    StoreName,ProductName,TotalSalesAmount,RankCol 
	From resultdata r 
	where r.RankCol between 1 and 10 
    Order by RankCol 

go   


----- View results 

Exec Top10_MostValuableStores
