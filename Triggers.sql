USE BankSystem
GO

CREATE OR ALTER TRIGGER AccountUpdateTrigger ON BankAccount
AFTER UPDATE
AS
SET NOCOUNT ON
PRINT 'Bank account update trigger'

	IF (SELECT COUNT(*) FROM BankAccount WHERE BankAccount.AccountBalance < 0) > 0
	OR (SELECT COUNT(*) FROM BalancesView WHERE CardsBalance > AccountBalance) > 0
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Incorrect account balance values', 16, 1)
		RETURN
	END
GO

CREATE OR ALTER TRIGGER CardsUpdateTrigger ON BankCard
AFTER UPDATE
AS
SET NOCOUNT ON
PRINT 'Bank card update trigger'

	IF (SELECT COUNT(*) FROM BankCard WHERE BankCard.CardBalance < 0) > 0
	OR (SELECT COUNT(*) FROM BalancesView WHERE CardsBalance > AccountBalance) > 0
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Incorrect cards balance values', 16, 1)
		RETURN
	END
GO