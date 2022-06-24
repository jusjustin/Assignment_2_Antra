--1. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the
--following.

--    Country                        Province
Select cr.CountryRegionCode as Country, StateProvinceCode as Province
From Person.StateProvince sp JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode

/*2. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada.
Join them and produce a result set similar to the following.

    Country                        Province
*/
Select cr.CountryRegionCode as Country, StateProvinceCode as Province
From Person.StateProvince sp JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
Where cr.CountryRegionCode IN ('DE', 'CA')

-- Using Northwind Database: (Use aliases for all the Joins)

--3. List all Products that has been sold at least once in last 25 years. Product, OrderDetails, Orders
Select ProductName, OrderDate
From (Products p JOIN [Order Details] od ON p.ProductID = od.ProductID) JOIN Orders o ON od.OrderID = o.OrderID
Where YEAR(OrderDate) >= YEAR(GETDATE()) - 25

--4. List top 5 locations (Zip Code) where the products sold most in last 25 years.
Select TOP 5 ProductName, OrderDate, COUNT(ShipPostalCode) as AmountSoldToThisZipCode
From (Products p JOIN [Order Details] od ON p.ProductID = od.ProductID) JOIN Orders o ON od.OrderID = o.OrderID
Where YEAR(OrderDate) >= YEAR(GETDATE()) - 25
Group By ProductName, OrderDate
Order By AmountSoldToThisZipCode Desc

--5. List all city names and number of customers in that city.     
Select City, COUNT(City) as NumberOfCustomers
From Customers
Group By City

--6. List city names which have more than 2 customers, and number of customers in that city
Select City, COUNT(City) as NumberOfCustomers
From Customers
Group By City
Having COUNT(City) > 2

--7. Display the names of all customers along with the count of products they bought
Select ContactName, COUNT(c.CustomerID) as AmountOfProductsBought
From (Products p JOIN [Order Details] od ON p.ProductID = od.ProductID) JOIN (Orders o JOIN Customers c ON o.CustomerID = c.CustomerID) ON od.OrderID = o.OrderID
Group By ContactName
Order By ContactName

--8. Display the customer ids who bought more than 100 Products with count of products.
Select ContactName, COUNT(c.CustomerID) as AmountOfProductsBought
From (Products p JOIN [Order Details] od ON p.ProductID = od.ProductID) JOIN (Orders o JOIN Customers c ON o.CustomerID = c.CustomerID) ON od.OrderID = o.OrderID
Group By ContactName
Having COUNT(c.CustomerID) > 100
Order By ContactName Asc

/*9. List all of the possible ways that suppliers can ship their products. Display the results as below

    Supplier Company Name                Shipping Company Name

    ---------------------------------            ----------------------------------
*/
Select 'Supplier' as Role, CompanyName
From Suppliers
Union ALL
Select 'Shipping' as Role, CompanyName
From Shippers

--10. Display the products order each day. Show Order date and Product Name.
Select OrderDate, ProductName
From (Products p JOIN [Order Details] od ON p.ProductID = od.ProductID) JOIN Orders o ON od.OrderID = o.OrderID

--11. Displays pairs of employees who have the same job title.
Select FirstName, LastName, Title From Employees Where Title in
(Select Title From Employees group by Title having COUNT(*) > 1)

--12. Display all the Managers who have more than 2 employees reporting to them.
Select Title, ReportsTo
From Employees
Where Title = 'Sales Manager' AND ReportsTo > 2

/*13. Display the customers and suppliers by city. The results should have the following columns

City,

Name,

Contact Name,

Type (Customer or Supplier)*/
Select 'Customer', ContactName, City
From Customers
Union All
Select 'Supplier', ContactName, City
From Suppliers

--14. List all cities that have both Employees and Customers.
Select *
From Customers
Where City IN (Select Distinct City
From Employees)

/*15. List all cities that have Customers but no Employee.
a.    Use sub-query
b.    Do not use sub-query
*/
--A.
Select *
From Customers
Where City NOT IN (Select Distinct City
From Employees)

--B.
Select *
From (Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID) JOIN Customers c ON o.CustomerID = c.CustomerID
Where e.City != c.City
--*****
--****
--****

--16. List all products and their total order quantities throughout all orders.
Select ProductName, COUNT(o.OrderID) AS TotalQuantity
From (Products p JOIN [Order Details] od ON p.ProductID = od.ProductID) JOIN Orders o ON od.OrderID = o.OrderID
Group By ProductName

--17. List all Customer Cities that have at least two customers.
--a.  Use union
Select City, COUNT(CustomerID) as NumberOfCustomers
From Customers
Group By City
Having COUNT(CustomerID) >= 2
Union
Select City, COUNT(CustomerID) as NumberOfCustomers
From Customers
Group By City
Having COUNT(CustomerID) >= 2

--b.  Use no union
Select City, COUNT(CustomerID) as NumberOfCustomers
From Customers
Group By City
Having COUNT(CustomerID) >= 2

--18. List all Customer Cities that have ordered at least two different kinds of products.
Select City, COUNT(c.CustomerID) as AmountOfProductsBought
From (Products p JOIN [Order Details] od ON p.ProductID = od.ProductID) JOIN (Orders o JOIN Customers c ON o.CustomerID = c.CustomerID) ON od.OrderID = o.OrderID
Group By City
Having COUNT(c.CustomerID) >= 2
Order By City Asc

--19. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
Select TOP 5 ProductName, City, AVG(p.UnitPrice) as AveragePrice, COUNT(c.CustomerID) as AmountOfProductsBought
From (Products p JOIN [Order Details] od ON p.ProductID = od.ProductID) JOIN (Orders o JOIN Customers c ON o.CustomerID = c.CustomerID) ON od.OrderID = o.OrderID
Group By ProductName, City
Having COUNT(c.CustomerID) >= 2
Order By COUNT(c.CustomerID) Desc

--20. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, 
--and also the city of most total quantity of products ordered from. (tip: join sub-query)
Select TOP 1 e.City, COUNT(OrderID) as SoldOrders
From Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
Group By e.City
Order By COUNT(OrderID) DESC

--21. How do you remove the duplicates record of a table?
--Add Distinct to Select