USE BankSystem
GO

ALTER VIEW GetBankAccountsView AS
SELECT 
	SocialStatus.SocialStatusID AS 'SocialStatusId',
	BankAccount.AccountBalance AS 'NeAccountBalance',
	BankAccount.BankAccountID AS 'BankAccountId'
FROM SocialStatus
JOIN Client ON Client.SocialStatusID = SocialStatus.SocialStatusID
JOIN BankAccount ON BankAccount.BankAccountID = Client.BankAccountID
GO

ALTER VIEW GetCards AS
SELECT
	BankCard.BankCardID AS 'CardId',
	BankCard.CardBalance AS 'CardBalance',
	BankAccount.BankAccountID AS 'AccountId',
	BankAccount.AccountBalance AS 'AccountBalance'
FROM BankAccount
JOIN BankCard ON BankCard.BankAccountID = BankAccount.BankAccountID
GO

ALTER VIEW BalancesView AS
SELECT 
	BankAccount.BankAccountID AS 'AccountId',
	BankAccount.AccountBalance AS 'AccountBalance',
	SUM(BankCard.CardBalance) AS 'CardsBalance'
FROM BankAccount
JOIN BankCard ON BankCard.BankAccountID = BankAccount.BankAccountID
GROUP BY BankAccount.BankAccountID, BankAccount.AccountBalance
GO