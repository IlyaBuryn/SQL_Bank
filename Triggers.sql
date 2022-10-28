USE BankSystem
GO

CREATE OR ALTER TRIGGER AccountUpdateTrigger ON BankAccounts
AFTER UPDATE
AS
SET NOCOUNT ON
PRINT 'Bank account update trigger'

	IF (SELECT COUNT(*) FROM BankAccounts WHERE BankAccounts.AccountBalance < 0) > 0
	OR (SELECT COUNT(*) FROM BalancesView WHERE CardsBalance > AccountBalance) > 0
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Incorrect account balance values', 16, 1)
		RETURN
	END
GO

CREATE OR ALTER TRIGGER CardsUpdateTrigger ON BankCards
AFTER UPDATE
AS
SET NOCOUNT ON
PRINT 'Bank card update trigger'

	IF (SELECT COUNT(*) FROM BankCards WHERE BankCards.CardBalance < 0) > 0
	OR (SELECT COUNT(*) FROM BalancesView WHERE CardsBalance > AccountBalance) > 0
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Incorrect cards balance values', 16, 1)
		RETURN
	END
GO