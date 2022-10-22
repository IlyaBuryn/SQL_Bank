USE BankSystem
GO

-- Query 2 --
SELECT Bank.Name
FROM Bank
JOIN BranchOffice ON BranchOffice.BankID = Bank.BankID
JOIN City ON City.CityID = BranchOffice.CityID
WHERE City.Name = N'Grodno'

-- Query 3 --
SELECT Client.Name, BankCard.CardBalance, Bank.Name
FROM BankCard
JOIN BankAccount ON BankAccount.BankAccountID = BankCard.BankAccountID
JOIN Client ON Client.BankAccountID = BankAccount.BankAccountID
JOIN Bank ON Bank.BankID = Client.BankID

-- Query 4 --
SELECT Client.Name, AccountId, AccountBalance, CardsBalance, (AccountBalance - CardsBalance) AS 'BalanceDifference'
FROM BalancesView
JOIN Client ON Client.BankAccountID = AccountId
WHERE (AccountBalance - CardsBalance) > 0 OR (AccountBalance - CardsBalance) < 0

-- Query 5 --
SELECT SocialStatus.Name, COUNT(BankCard.BankCardID) AS CardQt
FROM BankCard
JOIN BankAccount ON BankAccount.BankAccountID = BankCard.BankAccountID
JOIN Client ON Client.BankAccountID = BankAccount.BankAccountID
JOIN Bank ON Bank.BankID = Client.BankID
FULL JOIN SocialStatus ON SocialStatus.SocialStatusID = Client.SocialStatusID
GROUP BY SocialStatus.Name

-- Query 6 --
--EXEC AddMoneyProc 3

-- Query 7 --
SELECT Client.Name, SUM(BankCard.CardBalance) AS 'For withdrawal'
FROM Client
JOIN BankAccount ON Client.BankAccountID = BankAccount.BankAccountID
JOIN BankCard ON BankCard.BankAccountID = BankAccount.BankAccountID
GROUP BY Client.Name

-- Query 8 --
--EXEC WithdrawFromAccountToCard 6, 7, 200.0000
--EXEC WithdrawFromAccountToCard 6, 8, 4000.0000

-- Query 9 --
