--If not exists (select * from sys.databases where name = 'Product')
--CREATE DATABASE Product;

--USE Product

--ALTER TABLE [dbo].[Products]
--ADD FOREIGN KEY (CategoryID) REFERENCES [dbo].[Categories](CategoryID);

--ALTER TABLE [dbo].[OrderDetails]
--ALTER COLUMN UnitPrice MONEY; 



-- Excel sheet 1: Customer_country : What are the countries that have the most company customers? 
--SELECT Country, COUNT(*) AS EachCompanyCustomer
--FROM [dbo].[Customers]
--GROUP BY Country
--ORDER BY COUNT(*) DESC;


-- Excel sheet 2: CustomerOrder_City : What are the overall Orders in each country?  
--SELECT C.Country, COUNT(*) AS OrderEachCountry
--FROM [dbo].[Customers] AS C
--INNER JOIN [dbo].[Order] AS O
--ON C.CustomerID = O.CustomerID
--INNER JOIN [dbo].[OrderDetails] AS OD
--ON O.OrderID = OD.OrderID
--GROUP BY C.Country
--ORDER BY COUNT(*) DESC;

-- CustomerOrder_City (USA) : Among USA and Germany, which city has the most overall order?
--SELECT C.Country, C.City, COUNT(C.COUNTRY) AS Order_each_Company
--FROM [dbo].[Customers] AS C
--INNER JOIN [dbo].[Order] AS O
--ON C.CustomerID = O.CustomerID
--INNER JOIN [dbo].[OrderDetails] AS OD
--ON O.OrderID = OD.OrderID
--WHERE C.Country = 'USA'
--GROUP BY C.Country, C.City
--ORDER BY COUNT(C.COUNTRY) DESC; 


-- Excel sheet 3: CustomerOrder_Money : What are the Total Price of orders in each country? 
--SELECT Country, COUNT(ProductID) AS OrderEachCountry, CONVERT(money,SUM(TotalPrice)) AS TotalPrice
--FROM (
--SELECT C.Country, OD.ProductID,
--CASE 
--	WHEN OD.UnitPrice * OD.Quantity * OD.Discount != 0 THEN OD.UnitPrice * OD.Quantity * OD.Discount
--	ELSE OD.UnitPrice * OD.Quantity
--END AS TotalPrice
--FROM [dbo].[OrderDetails] AS OD
--INNER JOIN [dbo].[Order] AS O
--ON OD.OrderID = O.OrderID
--INNER JOIN [dbo].[Customers] AS C
--ON C.CustomerID = O.CustomerID 
--) AS AA
--GROUP BY Country
--ORDER BY TotalPrice DESC;

-- CustomerOrder_Money (USA AND GERMANY)
--SELECT Country, City, COUNT(ProductID) AS OrderEachCountry, CONVERT(money,SUM(TotalPrice)) AS TotalPrice
--FROM (
--SELECT C.Country, C.City, OD.ProductID,
--CASE 
--	WHEN OD.UnitPrice * OD.Quantity * OD.Discount != 0 THEN OD.UnitPrice * OD.Quantity * OD.Discount
--	ELSE OD.UnitPrice * OD.Quantity
--END AS TotalPrice
--FROM [dbo].[OrderDetails] AS OD
--INNER JOIN [dbo].[Order] AS O
--ON OD.OrderID = O.OrderID
--INNER JOIN [dbo].[Customers] AS C
--ON C.CustomerID = O.CustomerID
--WHERE C.Country = 'USA'
--) AS BB
--GROUP BY Country, City
--ORDER BY TotalPrice DESC;


-- Excel sheet 4: Reason_Aus, Bra, Fra : Find out the reason why Austria has more total price than 
-- France, despite the different in overall order
--SELECT Country, SUM(UnitPrice) UP, SUM(Quantity) QT, SUM(Discount) DC, CONVERT(money,SUM(TotalPrice)) AS TP
--FROM (
--SELECT C.Country, OD.UnitPrice, OD.Quantity, OD.Discount,
--CASE 
--	WHEN OD.UnitPrice * OD.Quantity * OD.Discount != 0 THEN OD.UnitPrice * OD.Quantity * OD.Discount
--	ELSE OD.UnitPrice * OD.Quantity
--END AS TotalPrice
--FROM [dbo].[OrderDetails] AS OD
--INNER JOIN [dbo].[Order] AS O
--ON OD.OrderID = O.OrderID
--INNER JOIN [dbo].[Customers] AS C
--ON C.CustomerID = O.CustomerID
--WHERE C.Country = 'FRANCE'
--) AS CC
--GROUP BY Country;


-- Excel sheet 5: EmployeeOrder : What are the Total number of Product-sold and total sales
-- of each employee?
--SELECT EmployeeID, Fullname, Title, COUNT(EmployeeID) AS NumSales, CONVERT(money,SUM(TotalPrice)) TotalSales
--FROM (
--SELECT E.EmployeeID, CONCAT(E.LastName, ' ', E.FirstName) AS Fullname, E.Title,
--CASE 
--	WHEN OD.UnitPrice * OD.Quantity * OD.Discount != 0 THEN OD.UnitPrice * OD.Quantity * OD.Discount
--	ELSE OD.UnitPrice * OD.Quantity
--END AS TotalPrice
--FROM [dbo].[Employees] AS E
--INNER JOIN [dbo].[Order] AS O
--ON E.EmployeeID = O.EmployeeID
--INNER JOIN [dbo].[OrderDetails] AS OD
--ON O.OrderID = OD.OrderID
--) AS DD
--GROUP BY EmployeeID, Fullname, Title
--ORDER BY TotalSales DESC;

-- Note: Find what category that each employee sale the most to company
--SELECT EmployeeID, Fullname, ProductName, COUNT(EmployeeID) AS NumSales, CONVERT(money,SUM(TotalPrice)) TotalSales,
--CategoryName, sum(Discount)
--FROM (
--SELECT E.EmployeeID, CONCAT(E.LastName, ' ', E.FirstName) AS Fullname, E.Title, C.CategoryName,
--P.CategoryID, P.ProductName, OD.Discount,
--CASE 
--	WHEN OD.UnitPrice * OD.Quantity * OD.Discount != 0 THEN OD.UnitPrice * OD.Quantity * OD.Discount
--	ELSE OD.UnitPrice * OD.Quantity
--END AS TotalPrice
--FROM [dbo].[Employees] AS E
--INNER JOIN [dbo].[Order] AS O
--ON E.EmployeeID = O.EmployeeID
--INNER JOIN [dbo].[OrderDetails] AS OD
--ON O.OrderID = OD.OrderID
--INNER JOIN [dbo].[Products] AS P
--ON OD.ProductID = P.ProductID
--INNER JOIN [dbo].[Categories] AS C
--ON P.CategoryID = C.CategoryID
--WHERE E.EmployeeID = 3 AND C.CategoryName = 'Beverages'
--) AS DD
--GROUP BY EmployeeID, Fullname, ProductName, CategoryName
--ORDER BY TotalSales DESC;

-- Note: To clarify the sales of each employee
--SELECT E.EmployeeID, CONCAT(E.LastName, ' ', E.FirstName) AS Fullname, E.Title,
--CASE 
--	WHEN OD.UnitPrice * OD.Quantity * OD.Discount != 0 THEN OD.UnitPrice * OD.Quantity * OD.Discount
--	ELSE OD.UnitPrice * OD.Quantity
--END AS TotalPrice
--FROM [dbo].[Employees] AS E
--INNER JOIN [dbo].[Order] AS O
--ON E.EmployeeID = O.EmployeeID
--INNER JOIN [dbo].[OrderDetails] AS OD
--ON O.OrderID = OD.OrderID
--WHERE E.EmployeeID = 5 


-- Excel sheet 6: ShippingOrder : What are the company that has the most shipment? 
--SELECT S.CompanyName, COUNT(*) AS NumOfShippment
--FROM [dbo].[Order] AS O
--INNER JOIN [dbo].[Shippers] AS S
--ON O.ShipVia = S.ShipperID
--INNER JOIN [dbo].[OrderDetails] AS OD
--ON O.OrderID = OD.OrderID
--GROUP BY S.CompanyName
--ORDER BY NumOfShippment DESC;

-- Note: Total Shippment in each country
--SELECT O.ShipCountry, COUNT(ShipVia) AS ShipVia
--FROM [dbo].[Order] AS O
--INNER JOIN [dbo].[Shippers] AS S
--ON O.ShipVia = S.ShipperID
--INNER JOIN [dbo].[OrderDetails] AS OD
--ON O.OrderID = OD.OrderID
--GROUP BY O.ShipCountry
--ORDER BY ShipVia DESC;

-- ShippingOrder_Country : which of these 3 shipment companies that each country prefer the most?
--SELECT *
--FROM(
--SELECT S.CompanyName, O.ShipCountry, ShipVia
--FROM [dbo].[Order] AS O
--INNER JOIN [dbo].[Shippers] AS S
--ON O.ShipVia = S.ShipperID
--INNER JOIN [dbo].[OrderDetails] AS OD
--ON O.OrderID = OD.OrderID
--) Fro
--PIVOT (COUNT(ShipVia) FOR CompanyName IN ([Speedy Express], [United Package], [Federal Shipping])) 
--AS Pivo;


--  Excel sheet 7: SupplyProduct_Country : What are the country that supply the most?
--SELECT S.Country, COUNT(OD.ProductID) AS Num_Country_Supply
--FROM [dbo].[Suppliers] AS S
--INNER JOIN [dbo].[Products] AS P
--ON S.SupplierID = P.SupplierID
--INNER JOIN [dbo].[OrderDetails] AS OD
--ON OD.ProductID = P.ProductID
--GROUP BY S.Country
--ORDER BY Num_Country_Supply DESC;


-- Excel sheet 8: SupplyProduct_Money : Despite Highest number of supply in USA, France has the highest
-- total sales compare to USA.
--SELECT Country, COUNT(ProductID) AS NumSupply, CONVERT(money,SUM(TotalPrice)) AS TotalPrice
--FROM (
--SELECT S.Country, P.ProductID, CASE 
--	WHEN OD.UnitPrice * OD.Quantity * OD.Discount != 0 THEN OD.UnitPrice * OD.Quantity * OD.Discount
--	ELSE OD.UnitPrice * OD.Quantity
--END AS TotalPrice
--FROM [dbo].[Suppliers] AS S
--INNER JOIN [dbo].[Products] AS P
--ON S.SupplierID = P.SupplierID
--INNER JOIN [dbo].[OrderDetails] AS OD
--ON OD.ProductID = P.ProductID
--) AS TEN
--GROUP BY Country
--ORDER BY TotalPrice DESC;

-- Note: Find the reason why France & USA has big different in supply sold, even USA has
-- highest number of supply (in term of Category Name)
--SELECT Country, COUNT(ProductID) AS NumSupply, CONVERT(money,SUM(TotalPrice)) AS TotalPrice, 
--CategoryName, SUM(Quantity)
--FROM (
--SELECT S.Country, P.ProductID, C.CategoryName, OD.Quantity,
--CASE 
--	WHEN OD.UnitPrice * OD.Quantity * OD.Discount != 0 THEN OD.UnitPrice * OD.Quantity * OD.Discount
--	ELSE OD.UnitPrice * OD.Quantity
--END AS TotalPrice
--FROM [dbo].[Suppliers] AS S
--INNER JOIN [dbo].[Products] AS P
--ON S.SupplierID = P.SupplierID
--INNER JOIN [dbo].[OrderDetails] AS OD
--ON OD.ProductID = P.ProductID
--INNER JOIN [dbo].[Categories] AS C
--ON C.CategoryID = P.CategoryID
--WHERE S.Country = 'France'
--) AS TEN
--GROUP BY Country, CategoryName
--ORDER BY TotalPrice DESC;
