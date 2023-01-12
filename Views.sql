USE BankSystem
GO

CREATE OR ALTER VIEW GetBankAccountsView AS
SELECT 
	SocialStatuses.Id AS 'SocialStatus',
	BankClients.AccountBalance AS 'AccountBalance',
	BankClients.Id AS 'Account'
FROM SocialStatuses
	JOIN Clients ON Clients.SocialStatusId = SocialStatuses.Id
	JOIN BankClients ON BankClients.ClientId = Clients.Id
GO

CREATE OR ALTER VIEW GetCardsView AS
SELECT
	BankCards.Id AS 'CardId',
	BankCards.CardBalance AS 'CardBalance',
	BankClients.Id AS 'AccountId',
	BankClients.AccountBalance AS 'AccountBalance'
FROM BankClients
	JOIN BankCards ON BankCards.BankClientId = BankClients.Id
GO

CREATE OR ALTER VIEW BalancesView AS
SELECT 
	BankClients.Id AS 'Account',
	BankClients.AccountBalance AS 'AccountBalance',
	Clients.Id AS 'Client',
	SUM(BankCards.CardBalance) AS 'CardsBalance'
FROM BankClients
	JOIN BankCards ON BankCards.BankClientId = BankClients.Id
	JOIN Clients ON Clients.Id = BankClients.ClientId
GROUP BY BankClients.Id, BankClients.AccountBalance, Clients.Id
GO