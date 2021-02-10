CREATE DATABASE ExampleDB
GO
USE ExampleDB
CREATE TABLE Inventory (id INT, name NVARCHAR(50), quantity INT)
INSERT INTO Inventory VALUES (1, 'apple', 100)
INSERT INTO Inventory VALUES (2, 'orange', 150)
INSERT INTO Inventory VALUES (3, 'banana', 154)
INSERT INTO Inventory VALUES (4, N'バナナ', 170)
GO
SELECT * FROM Inventory WHERE quantity > 100;
GO
