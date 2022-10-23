USE BankSystem
GO

DECLARE @TestCardId numeric(18, 0), @TestCity nvarchar(64), @TestSocStatus numeric(18, 0)

-- Query 2 --
SET @TestCity = N'Grodno'
SELECT Bank.Name
FROM Bank
	JOIN BranchOffice ON BranchOffice.BankID = Bank.BankID
	JOIN City ON City.CityID = BranchOffice.CityID
WHERE City.Name = @TestCity


-- Query 3 --
SELECT Client.Name, BankCard.BankCardID AS 'Card Id', BankCard.CardBalance, Bank.Name
FROM BankCard
	JOIN BankAccount ON BankAccount.BankAccountID = BankCard.BankAccountID
	JOIN Client ON Client.BankAccountID = BankAccount.BankAccountID
	JOIN Bank ON Bank.BankID = Client.BankID

-- Query 4 --
SELECT Client.Name, AccountId, AccountBalance, CardsBalance, (AccountBalance - CardsBalance) AS BalanceDifference
FROM BalancesView
	JOIN Client ON Client.BankAccountID = AccountId
WHERE (AccountBalance - CardsBalance) <> 0

-- Query 5 --
SELECT SocialStatus.Name, COUNT(BankCard.BankCardID) AS CardQt
FROM BankCard
	JOIN BankAccount ON BankAccount.BankAccountID = BankCard.BankAccountID
	JOIN Client ON Client.BankAccountID = BankAccount.BankAccountID
	JOIN Bank ON Bank.BankID = Client.BankID
	FULL JOIN SocialStatus ON SocialStatus.SocialStatusID = Client.SocialStatusID
GROUP BY SocialStatus.Name

-- Query 6 --
SET @TestSocStatus = 3
SELECT * FROM GetBankAccountsView ORDER BY SocialStatusId
EXEC AddMoneyProc @TestSocStatus
SELECT * FROM GetBankAccountsView ORDER BY SocialStatusId

-- Query 7 --
SELECT Client.Name, SUM(BankCard.CardBalance) AS 'For withdraw'
FROM Client
	JOIN BankAccount ON Client.BankAccountID = BankAccount.BankAccountID
	JOIN BankCard ON BankCard.BankAccountID = BankAccount.BankAccountID
GROUP BY Client.Name

-- Query 8 --
SET @TestCardId = 7
SELECT BankCard.CardBalance FROM BankCard WHERE BankCard.BankCardID = @TestCardId
EXEC WithdrawFromAccountToCard 6, @TestCardId, 200.0000 -- Working
--EXEC WithdrawFromAccountToCard 6, @TestCardId, 4000.0000 -- Error checking
SELECT BankCard.CardBalance FROM BankCard WHERE BankCard.BankCardID = @TestCardId

-- Query 9 --
SELECT * FROM BalancesView
BEGIN TRANSACTION
UPDATE BankAccount
	SET BankAccount.AccountBalance = 1000 -- [1000, -100, 400, 500] for tests
WHERE BankAccount.BankAccountID = 1
COMMIT TRANSACTION
SELECT * FROM BalancesView

SELECT * FROM BalancesView
BEGIN TRANSACTION
UPDATE BankCard
	SET BankCard.CardBalance = 200 -- [200, -200, 700, 800] for tests
WHERE BankCard.BankCardID = 1
COMMIT TRANSACTION
SELECT * FROM BalancesView
