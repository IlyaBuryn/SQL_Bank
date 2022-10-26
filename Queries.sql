USE BankSystem

DECLARE @TestCardId numeric(18, 0), @TestCity nvarchar(64), @TestSocStatus numeric(18, 0)

-- Query 2 --
SET @TestCity = N'Grodno'
SELECT Banks.Name
FROM Banks
	JOIN BranchOffices ON BranchOffices.BankID = Banks.BankID
	JOIN Cities ON Cities.CityID = BranchOffices.CityID
WHERE Cities.Name = @TestCity

-- Query 3 --
SELECT Clients.Name, BankCards.BankCardID AS 'Card Id', BankCards.CardBalance, Banks.Name
FROM BankCards
	JOIN BankAccounts ON BankAccounts.BankAccountID = BankCards.BankAccountID
	JOIN Clients ON Clients.ClientID = BankAccounts.ClientID
	JOIN BankClients ON BankClients.ClientID = Clients.ClientID
	JOIN Banks ON Banks.BankID = BankClients.BankID

-- Query 4 --
SELECT Clients.Name, Account, AccountBalance, CardsBalance, (AccountBalance - CardsBalance) AS BalanceDifference
FROM BalancesView
	JOIN Clients ON Clients.ClientID = Client
WHERE (AccountBalance - CardsBalance) <> 0

-- Query 5 --
SELECT SocialStatuses.Name, COUNT(BankCards.BankCardID) AS CardQt
FROM BankCards
	JOIN BankAccounts ON BankAccounts.BankAccountID = BankCards.BankAccountID
	JOIN Clients ON Clients.ClientID = BankAccounts.ClientID
	FULL JOIN SocialStatuses ON SocialStatuses.SocialStatusID = Clients.SocialStatusID
GROUP BY SocialStatuses.Name

---- Query 6 --
SET @TestSocStatus = 3 -- [3, 6, 100, -100] for tests
SELECT * FROM GetBankAccountsView ORDER BY SocialStatus
EXEC AddMoneyProc @TestSocStatus
SELECT * FROM GetBankAccountsView ORDER BY SocialStatus

-- Query 7 --
SELECT Clients.Name, Clients.ClientID, SUM(BankCards.CardBalance) AS 'For withdraw'
FROM Clients
	JOIN BankAccounts ON Clients.ClientID = BankAccounts.ClientID
	JOIN BankCards ON BankCards.BankAccountID = BankAccounts.BankAccountID
GROUP BY Clients.Name, Clients.ClientID

-- Query 8 --
SET @TestCardId = 7
SELECT * FROM GetCardsView WHERE CardId = @TestCardId
EXEC WithdrawFromAccountToCardProc 6, @TestCardId, 200.0000 -- Working
--EXEC WithdrawFromAccountToCardProc 6, @TestCardId, 4000.0000 -- Error checking
SELECT * FROM GetCardsView WHERE CardId = @TestCardId

---- Query 9 --
SELECT * FROM BalancesView
BEGIN TRANSACTION
UPDATE BankAccounts
	SET BankAccounts.AccountBalance = 1000 -- [1000, -100, 400, 500] for tests
WHERE BankAccounts.BankAccountID = 1
COMMIT TRANSACTION
SELECT * FROM BalancesView

SELECT * FROM BalancesView
BEGIN TRANSACTION
UPDATE BankCards
	SET BankCards.CardBalance = 200 -- [200, -200, 700, 800] for tests
WHERE BankCards.BankCardID = 1
COMMIT TRANSACTION
SELECT * FROM BalancesView
