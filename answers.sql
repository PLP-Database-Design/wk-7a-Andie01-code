sql
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');


Step 2: Transform into 1NF

Since standard SQL doesn't have a built-in function to split strings into rows, the approach varies depending on the database system. Here's an example using MySQL with a helper numbers table:

```sql
-- Create a helper numbers table
CREATE TABLE numbers (n INT);
INSERT INTO numbers (n) VALUES (1),(2),(3),(4),(5);

-- Create the normalized table
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);- Insert normalized data
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT
    pd.OrderID,
    pd.CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(pd.Products, ',', numbers.n), ',', -1)) AS Product
FROM
    ProductDetail pd
JOIN
    numbers ON CHAR_LENGTH(pd.Products) - CHAR_LENGTH(REPLACE(pd.Products, ',', '')) >= numbers.n - 1;
```
sql
CREATE TABLE OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT
);

INSERT INTO OrderDetails (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);


Step 2: Decompose into 2NF

*Create the Orders Table:*

sql
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;


*Create the OrderItems Table:*

sql
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
