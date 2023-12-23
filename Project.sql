/*

Using Northwind Database for Data Exploration

Questions/Prompts are from
"SQL Practice Problems 57 beginning, intermediate, and advanced challenges for you to solve using a "learn-bydoing" approach"
By Sylvia Moestl Vasilik

Link to the book:
https://ia601403.us.archive.org/32/items/deitel-java-como-programar-6a-edicao-br-completo/SQL%20Practice%20Problems_%2057%20beginning%2C%20intermediate%2C%20and%20advanced%20challenges%20for%20you%20to%20solve%20using%20a%20%26quot%3Blearn-by-doing%26quot%3B%20approach%20%28%20PDFDrive%20%29.pdf

*/

----------------------------------------------------------------------------------------------
-- Introductory Problems --
----------------------------------------------------------------------------------------------

-- Returns all the fields from all the shippers 

SELECT *

FROM NorthWind.dbo.Shippers as s

----------------------------------------------------------------------------------------------
-- Returns 2 columns CategoryName and Description

SELECT categories.CategoryName, categories.Description

FROM NorthWind.dbo.Categories as categories

----------------------------------------------------------------------------------------------
-- Returns FirstName, LastName, and HireDate of all the employees with the Title of Sales Representative

SELECT employee.FirstName, employee.LastName, employee.HireDate

FROM NorthWind.dbo.Employees as employee

WHERE employee.Title = 'Sales Representative'
----------------------------------------------------------------------------------------------
-- Returns FirstName, LastName, and HireDate of all the employees with the Title of Sales Representative within the United States

SELECT employees.FirstName, employees.LastName, employees.HireDate

FROM NorthWind.dbo.Employees as employees

WHERE employees.Title = 'Sales Representative'
AND employees.Country = 'USA'

----------------------------------------------------------------------------------------------
-- Show all the orders placed by a specific employee. The EmployeeID for this Employee (Steven Buchanan) is 5.

SELECT *

FROM NorthWind.dbo.Orders as orders

WHERE orders.EmployeeID = 5

----------------------------------------------------------------------------------------------
-- Show the SupplierID, ContactName, and ContactTitle for those Suppliers whose ContactTitle is not Marketing Manager.

SELECT suppliers.SupplierID, suppliers.ContactName, suppliers.ContactTitle

FROM NorthWind.dbo.Suppliers as suppliers

WHERE suppliers.ContactTitle != 'Marketing Manager'
----------------------------------------------------------------------------------------------
-- Shows ProductID and ProductName for those products where the ProductName includes the string “queso”

SELECT products.ProductID, products.ProductName

FROM NorthWind.dbo.Products as products

WHERE products.ProductName LIKE '%queso%'

----------------------------------------------------------------------------------------------
-- Shows the OrderID, CustomerID, and ShipCountry for the orders where the ShipCountry is either France or Belgium.

SELECT orders.OrderID, orders.CustomerID, orders.ShipCountry

FROM NorthWind.dbo.Orders as orders

WHERE orders.ShipCountry = 'France'
OR orders.ShipCountry = 'Belgium'

----------------------------------------------------------------------------------------------
-- Shows all the orders from any Latin American country

SELECT orders.OrderID, orders.CustomerID, orders.ShipCountry

FROM NorthWind.dbo.Orders as orders

WHERE orders.ShipCountry IN ('Brazil','Mexico', 'Argentina', 'Venezuela')

----------------------------------------------------------------------------------------------
-- Show the FirstName, LastName, Title, and BirthDate. Order the results by BirthDate, so we have the oldest employees first

SELECT employees.FirstName, employees.LastName, employees.Title, employees.BirthDate

FROM NorthWind.dbo.Employees as employees

ORDER BY  employees.BirthDate 

----------------------------------------------------------------------------------------------
-- Show the same output as above but remove the time of the birthdate

SELECT employees.FirstName, employees.LastName, employees.Title, convert(date, employees.BirthDate) as BirthDate

FROM NorthWind.dbo.Employees as employees

ORDER BY BirthDate 

--Another way this could be done is:

SELECT employees.FirstName, employees.LastName, employees.Title, cast(employees.BirthDate as date) as BirthDate

FROM NorthWind.dbo.Employees as employees

ORDER BY employees.BirthDate 

----------------------------------------------------------------------------------------------
-- Shows FirstName and LastName columns, then shows them merged

SELECT employees.FirstName, employees.LastName, concat(employees.FirstName, ' ', employees.LastName) as FullName

FROM NorthWind.dbo.Employees as employees

----------------------------------------------------------------------------------------------
-- Shows the TotalPrice OrderID, ProductID, UnitPrice, and Quantity. Order by OrderID and ProductID.

SELECT OrderDetails.OrderID, OrderDetails.ProductID, OrderDetails.UnitPrice, OrderDetails.Quantity, (OrderDetails.UnitPrice * OrderDetails.Quantity) as TotalPrice

FROM NorthWind.dbo.[Order Details] as OrderDetails

----------------------------------------------------------------------------------------------
-- Shows how many customers there are in the Customers table

SELECT count(Customers.CustomerID) as TotalCustomers

FROM NorthWind.dbo.Customers as Customers
----------------------------------------------------------------------------------------------
-- Shows the date of the first order ever made

SELECT top 1 orders.OrderDate as FirstOrder

FROM NorthWind.dbo.Orders as Orders

ORDER BY Orders.OrderDate 

-- Another way it could be done

SELECT min(orders.OrderDate) as FirstOrder

FROM NorthWind.dbo.Orders as Orders

----------------------------------------------------------------------------------------------
-- Shows a list of countries where the Northwind company has customers

SELECT distinct Customers.country

FROM NorthWind.dbo.Customers as Customers

--Another way it could be done

SELECT Customers.country

FROM NorthWind.dbo.Customers as Customers

GROUP BY Customers.country

----------------------------------------------------------------------------------------------
--Shows a list of all the different values in the Customers table for ContactTitles. Also include a count for each ContactTitle

SELECT Customers.ContactTitle, count(customers.ContactTitle) as TotalContactTitle

FROM NorthWind.dbo.Customers as Customers

GROUP BY Customers.ContactTitle

ORDER BY TotalContactTitle desc

----------------------------------------------------------------------------------------------
-- Shows the ProductID, ProductName, and the CompanyName of the Supplier. Sort by ProductID.

SELECT products.ProductID, products.ProductName, suppliers.CompanyName

FROM NorthWind.dbo.Products as products
INNER JOIN NorthWind.dbo.Suppliers as suppliers on products.SupplierID = suppliers.SupplierID

ORDER BY products.ProductID

----------------------------------------------------------------------------------------------
-- Shows a list of the Orders that were made, including the Shipper that was used. Show the OrderID, OrderDate (date only), and CompanyName of the Shipper, and sort by OrderID
-- In order to not show all the orders (there’s more than 800), show only those rows with an OrderID of less than 10300.

SELECT orders.orderId, orders.OrderDate, shippers.CompanyName

FROM NorthWind.dbo.Orders as orders
INNER JOIN NorthWind.dbo.Shippers as shippers on orders.ShipVia = shippers.ShipperID

WHERE orders.OrderID < 10300

----------------------------------------------------------------------------------------------
-- INTERMEDIATE PROBLEMS --
----------------------------------------------------------------------------------------------

-- Shows Categories, and the total products in each category

SELECT categories.CategoryName, count(*) as TotalProductsInEachCategory

FROM NorthWind.dbo.Categories as categories
LEFT JOIN NorthWind.dbo.Products as products on categories.CategoryID = products.CategoryID

GROUP BY categories.CategoryName

ORDER BY TotalProductsInEachCategory desc

----------------------------------------------------------------------------------------------
-- Shows total customers per country/city

SELECT customers.country, customers.city, count(*) as TotalCustomersPerCountryCity

FROM NorthWind.dbo.Customers as customers 

GROUP BY customers.country, customers.city

ORDER BY TotalCustomersPerCountryCity desc

--Another way

SELECT customers.country, customers.city, count(customers.CustomerID) as TotalCustomersPerCountryCity

FROM NorthWind.dbo.Customers as customers 

GROUP BY customers.country, customers.city

ORDER BY TotalCustomersPerCountryCity desc

----------------------------------------------------------------------------------------------
-- Shows products that need reordering

SELECT products.ProductID, products.ProductName, products.UnitsInStock, products.ReorderLevel

FROM NorthWind.dbo.Products as products

WHERE products.UnitsInStock <= products.ReorderLevel

ORDER BY products.ProductID

--Another way, shows which items need reordering that are continued

SELECT products.ProductID, products.ProductName, products.UnitsInStock, products.ReorderLevel, products.Discontinued

FROM NorthWind.dbo.Products as products 

WHERE products.UnitsInStock + products.UnitsOnOrder <= products.ReorderLevel
AND products.Discontinued = 0

ORDER BY products.ProductID
----------------------------------------------------------------------------------------------
-- Shows customer list by region

SELECT customers.CustomerID, customers.CompanyName, customers.Region

FROM NorthWind.dbo.Customers as customers

ORDER BY 
	CASE
		WHEN customers.Region is null then 1
	else 0
END,
customers.Region, customers.CustomerID


----------------------------------------------------------------------------------------------
-- Shows high freight charges

SELECT TOP 3 orders.ShipCountry, AVG(orders.Freight) as AverageFreight

FROM NorthWind.dbo.Orders as orders

GROUP BY orders.ShipCountry

ORDER BY AverageFreight desc

----------------------------------------------------------------------------------------------
-- Shows High Freight Charges in 1997

SELECT TOP 3 orders.ShipCountry, AVG(orders.Freight) as AverageFreight

FROM NorthWind.dbo.Orders as orders

WHERE orders.OrderDate BETWEEN '1997-01-01' AND '1997-12-31'

GROUP BY orders.ShipCountry

ORDER BY AverageFreight desc

-- Another way

SELECT TOP 3 orders.ShipCountry, AVG(orders.Freight) as AverageFreight

FROM NorthWind.dbo.Orders as orders

WHERE orders.OrderDate > '1997-01-01'
AND orders.OrderDate < '1998-01-01'

GROUP BY orders.ShipCountry

ORDER BY AverageFreight desc
----------------------------------------------------------------------------------------------
-- Shows inventory list

SELECT employees.EmployeeID, employees.LastName, orders.OrderID, products.ProductName, orderdetails.Quantity

FROM NorthWind.dbo.Employees as employees
INNER JOIN NorthWind.dbo.Orders as orders on employees.EmployeeID = orders.EmployeeID
INNER JOIN NorthWind.dbo.[Order Details] as orderdetails on orders.OrderID = orderdetails.OrderID
INNER JOIN NorthWind.dbo.Products as products on orderdetails.ProductID = products.ProductID

ORDER BY orders.OrderID, products.ProductID

----------------------------------------------------------------------------------------------
-- Shows customers with no orders

SELECT *

FROM NorthWind.dbo.Customers as customers
LEFT JOIN NorthWind.dbo.Orders as orders on customers.CustomerID = orders.CustomerID

WHERE orders.CustomerID is null

----------------------------------------------------------------------------------------------
-- ADVANCED PROBLEMS
----------------------------------------------------------------------------------------------

-- Shows High-valued customers

SELECT customers.CustomerID, customers.CompanyName, orders.OrderID, SUM(orderdetails.Quantity * orderdetails.UnitPrice) as TotalOrderAmount

FROM NorthWind.dbo.Customers as customers
INNER JOIN NorthWind.dbo.Orders as orders on customers.CustomerID = orders.CustomerID
INNER JOIN NorthWind.dbo. [Order Details] as orderdetails on orders.OrderID = orderdetails.OrderID

GROUP BY customers.CustomerID, customers.CompanyName, orders.OrderID 

HAVING SUM(orderdetails.Quantity * orderdetails.UnitPrice) > 10000

----------------------------------------------------------------------------------------------
-- Shows month-end orders

SELECT orders.EmployeeID, orders.OrderID, orders.OrderDate

FROM NorthWind.dbo.Orders as orders

WHERE orders.OrderDate = EOMONTH(orders.OrderDate)

ORDER BY orders.EmployeeID, orders.OrderID
----------------------------------------------------------------------------------------------
-- Shows orders with many line items

SELECT orders.OrderID, count(*) as TotalOrderDetails

FROM NorthWind.dbo.Orders as orders
INNER JOIN NorthWind.dbo.[Order Details] as orderdetails on orders.OrderID = orderdetails.OrderID

GROUP BY orders.OrderID

ORDER BY TotalOrderDetails desc

----------------------------------------------------------------------------------------------
-- Shows late orders

SELECT orders.OrderID, 
convert(date, orders.OrderDate) as OrderDate,
convert(date, orders.RequiredDate) as RequiredDate,
convert(date, orders.ShippedDate) as shippedDate

FROM NorthWind.dbo.Orders as orders

WHERE RequiredDate <= ShippedDate
----------------------------------------------------------------------------------------------
-- shows employees with late orders

SELECT employees.EmployeeID, employees.LastName, count(*) as TotalLateOrders

FROM NorthWind.dbo.Orders as orders
INNER JOIN NorthWind.dbo.Employees as employees on orders.EmployeeID = employees.EmployeeID

WHERE orders.RequiredDate <= orders.ShippedDate

GROUP BY employees.EmployeeID, employees.LastName

ORDER BY TotalLateOrders desc

----------------------------------------------------------------------------------------------
-- Late Orders vs Total Orders

With LateOrders as (

SELECT employees.EmployeeID, count(*) as TotalLateOrders

FROM NorthWind.dbo.Orders as orders
INNER JOIN NorthWind.dbo.Employees as employees on orders.EmployeeID = employees.EmployeeID

WHERE orders.RequiredDate <= orders.ShippedDate

GROUP BY employees.EmployeeID
),

AllOrders as (

SELECT orders.EmployeeID, count(*) as TotalOrders

FROM NorthWind.dbo.Orders as orders

GROUP BY orders.EmployeeID
)

SELECT *

FROM Northwind.dbo.Employees as employees
INNER JOIN AllOrders on employees.EmployeeID = AllOrders.EmployeeID
INNER JOIN LateOrders ON employees.EmployeeID = LateOrders.EmployeeID

----------------------------------------------------------------------------------------------
-- Countries with suppliers or customers

SELECT customers.country

FROM NorthWind.dbo.Customers as customers

UNION

SELECT suppliers.Country

FROM NorthWind.dbo.Suppliers as suppliers

----------------------------------------------------------------------------------------------
--THANK YOU FOR MAKING IT TO THE END!!
----------------------------------------------------------------------------------------------
