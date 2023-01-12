USE BankSystem

DECLARE @TestCardId numeric(18, 0), @TestCity nvarchar(64), @TestSocStatus numeric(18, 0)

-- Query 2 --
SET @TestCity = N'Grodno'
SELECT Banks.Name AS 'Bank name'
FROM Banks
	JOIN BranchOffices ON BranchOffices.BankId = Banks.Id
	JOIN Cities ON Cities.Id = BranchOffices.CityId
WHERE Cities.Name = @TestCity

-- Query 3 --
SELECT Clients.Name AS 'Client name', BankCards.Id AS 'Card id', BankCards.CardBalance AS 'Card balance', Banks.Name AS 'Bank name'
FROM BankCards
	JOIN BankClients ON BankClients.Id = BankCards.BankClientId
	JOIN Clients ON Clients.Id = BankClients.ClientId
	JOIN Banks ON Banks.Id = BankClients.BankId

-- Query 4 --
SELECT Clients.Name AS 'Client name', Clients.Id AS 'Client id', AccountBalance, CardsBalance, (AccountBalance - CardsBalance) AS 'Balance difference'
FROM BalancesView
	JOIN Clients ON Clients.Id = Client
WHERE (AccountBalance - CardsBalance) <> 0

-- Query 5 --
SELECT SocialStatuses.Name AS 'Social status name', COUNT(BankCards.Id) AS 'Card quantity'
FROM BankCards
	JOIN BankClients ON BankClients.Id = BankCards.BankClientId
	JOIN Clients ON Clients.Id = BankClients.ClientId
	FULL JOIN SocialStatuses ON SocialStatuses.Id = Clients.SocialStatusId
GROUP BY SocialStatuses.Name

-- Query 6 --
SET @TestSocStatus = 3 -- [3, 6, 100, -100] for tests
SELECT * FROM GetBankAccountsView ORDER BY SocialStatus
EXEC AddMoneyProc @TestSocStatus
SELECT * FROM GetBankAccountsView ORDER BY SocialStatus

-- Query 7 --
SELECT Clients.Name, Clients.Id, SUM(BankCards.CardBalance) AS 'For withdraw'
FROM Clients
	JOIN BankClients ON Clients.Id = BankClients.ClientId
	JOIN BankCards ON BankCards.BankClientId = BankClients.Id
GROUP BY Clients.Name, Clients.Id

-- Query 8 --
SET @TestCardId = 7
SELECT * FROM GetCardsView WHERE CardId = @TestCardId
EXEC WithdrawFromAccountToCardProc 6, @TestCardId, 200.0000 -- Working
--EXEC WithdrawFromAccountToCardProc 6, @TestCardId, 4000.0000 -- Error checking
SELECT * FROM GetCardsView WHERE CardId = @TestCardId

-- Query 9 --
SELECT * FROM BalancesView
BEGIN TRANSACTION
UPDATE BankClients
	SET BankClients.AccountBalance = 1000 -- [1000, -1000, 400, 500] for tests
WHERE BankClients.Id = 1
COMMIT TRANSACTION
SELECT * FROM BalancesView

SELECT * FROM BalancesView
BEGIN TRANSACTION
UPDATE BankCards
	SET BankCards.CardBalance = 200 -- [200, -200, 300, 700, 800] for tests
WHERE BankCards.Id = 1
COMMIT TRANSACTION
SELECT * FROM BalancesView
