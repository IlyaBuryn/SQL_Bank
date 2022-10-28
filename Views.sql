USE BankSystem
GO

CREATE OR ALTER VIEW GetBankAccountsView AS
SELECT 
	SocialStatuses.SocialStatusID AS 'SocialStatus',
	BankAccounts.AccountBalance AS 'AccountBalance',
	BankAccounts.BankAccountID AS 'Account'
FROM SocialStatuses
	JOIN Clients ON Clients.SocialStatusID = SocialStatuses.SocialStatusID
	JOIN BankAccounts ON BankAccounts.ClientID = Clients.ClientID
GO

CREATE OR ALTER VIEW GetCardsView AS
SELECT
	BankCards.BankCardID AS 'CardId',
	BankCards.CardBalance AS 'CardBalance',
	BankAccounts.BankAccountID AS 'AccountId',
	BankAccounts.AccountBalance AS 'AccountBalance'
FROM BankAccounts
	JOIN BankCards ON BankCards.BankAccountID = BankAccounts.BankAccountID
GO

CREATE OR ALTER VIEW BalancesView AS
SELECT 
	BankAccounts.BankAccountID AS 'Account',
	BankAccounts.AccountBalance AS 'AccountBalance',
	Clients.ClientID AS 'Client',
	SUM(BankCards.CardBalance) AS 'CardsBalance'
FROM BankAccounts
	JOIN BankCards ON BankCards.BankAccountID = BankAccounts.BankAccountID
	JOIN Clients ON Clients.ClientID = BankAccounts.ClientID
GROUP BY BankAccounts.BankAccountID, BankAccounts.AccountBalance, Clients.ClientID
GO