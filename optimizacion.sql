select NationalIDNumber, HireDate from HumanResources.Employee
where NationalIDNumber= '121491555';

select NationalIDNumber, BusinessEntityID from HumanResources.Employee
where NationalIDNumber= '121491555';

-------
select NationalIDNumber, BusinessEntityID from HumanResources.Employee
where NationalIDNumber= '121491555';

select NationalIDNumber, BusinessEntityID from HumanResources.Employee
where NationalIDNumber= 121491555;

--

SELECT P.Name , P.ProductNumber
FROM Production.Product P
WHERE ProductNumber ='EC-R098'

SELECT P.ProductID , P.ProductNumber
FROM Production.Product P
WHERE ProductNumber ='EC-R098'

--
SELECT SalesOrderID, SalesOrderDetailID
FROM Sales.SalesOrderDetail
WHERE SalesOrderID = 58950

SELECT SalesOrderID, SalesOrderDetailID
FROM Sales.SalesOrderDetail
WHERE SalesOrderDetailID = 68531

--
SELECT SalesOrderID, SalesOrderDetailID
FROM Sales.SalesOrderDetail
WHERE SalesOrderID = 43683 AND SalesOrderDetailID = 240

SELECT SalesOrderID, SalesOrderDetailID
FROM Sales.SalesOrderDetail
WHERE SalesOrderID = 43683 OR SalesOrderDetailID = 240

---

SELECT ProductID, PV.BusinessEntityID, Name
FROM Purchasing.ProductVendor PPV JOIN Purchasing.Vendor PV
ON (PPV.BusinessEntityID =PV.BusinessEntityID)

SELECT ProductID, PV.BusinessEntityID, Name
FROM Purchasing.ProductVendor PPV JOIN Purchasing.Vendor PV
ON (PPV.BusinessEntityID =PV.BusinessEntityID)
WHERE StandardPrice > $10

SELECT ProductID, PV.BusinessEntityID, Name
FROM Purchasing.ProductVendor PPV JOIN Purchasing.Vendor PV
ON (PPV.BusinessEntityID =PV.BusinessEntityID)
WHERE StandardPrice > $10 AND Name LIKE N'F%'

-- PARCIAL
--1

SELECT pi.Shelf
FROM Production.ProductInventory AS pi
ORDER BY pi.Shelf;

CREATE NONCLUSTERED INDEX IX_ProductInventory_Shelf
ON Production.ProductInventory (Shelf);
GO;

DROP INDEX IX_ProductInventory_Shelf 
on Production.ProductInventory;

--2

SELECT s.Name AS StoreName,
 bec.PersonID,
 bec.ContactTypeID
FROM Sales.Store AS s
 JOIN Person.BusinessEntityContact AS bec
 ON s.BusinessEntityID = bec.BusinessEntityID
ORDER BY s.Name

CREATE NONCLUSTERED INDEX IX_Store_Name
ON Sales.Store (Name);
GO
