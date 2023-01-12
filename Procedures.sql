USE BankSystem
GO

CREATE OR ALTER PROCEDURE AddMoneyProc
	@SocStatusId INT
AS
BEGIN
SET NOCOUNT ON
PRINT 'Start procedure AddMoneyProc(id)'

	DECLARE @MoneyValue DECIMAL(18, 4), @AccQt INT, @IdCheck INT
	SET @MoneyValue = 10.0000
	SET @AccQt = (SELECT COUNT(*) FROM GetBankAccountsView WHERE SocialStatus = @SocStatusId)
	SET @IdCheck = (SELECT COUNT(SocialStatuses.Id) FROM SocialStatuses WHERE SocialStatuses.Id = @SocStatusId)

	IF @IdCheck = 0
		RAISERROR('Wrong social number status!', 16, 1)
	ELSE IF @AccQt = 0
		RAISERROR('No linked accounts!', 16, 1)
	ELSE
		UPDATE BankClients
		SET BankClients.AccountBalance = BankClients.AccountBalance + @MoneyValue
		WHERE BankClients.Id IN (
			SELECT Account FROM GetBankAccountsView WHERE SocialStatus = @SocStatusId)
		PRINT 'Items was updated!'
END
GO


CREATE OR ALTER PROCEDURE WithdrawFromAccountToCardProc
	@AccountId numeric(18, 0),
	@CardId numeric(18, 0),
	@Value decimal(18, 4)
AS
BEGIN
SET NOCOUNT ON
PRINT 'Start procedure WithdrawFromAccountToCards(AccountId, CardId, Value)'
BEGIN TRANSACTION
	DECLARE @AccountBalance DECIMAL(18, 4)
	DECLARE @CardsBalance DECIMAL(18, 4)
	DECLARE @ToWithdraw DECIMAL(18, 4)

	IF (SELECT COUNT(*) FROM GetCardsView WHERE @CardId = CardId) = 0
		RAISERROR('This card does not exist!', 16, 1)
	ELSE IF	(SELECT COUNT(*) FROM GetCardsView WHERE @AccountId = AccountId) = 0
		RAISERROR('This account does not exist!', 16, 1)
	ELSE
		SET @AccountBalance = (SELECT TOP 1 AccountBalance FROM GetCardsView WHERE @AccountId = AccountId)
		PRINT @AccountBalance
		SET @CardsBalance = (SELECT SUM(CardBalance) FROM GetCardsView WHERE @AccountId = AccountId)
		PRINT @CardsBalance

		SET @ToWithdraw = @AccountBalance - @CardsBalance - @Value
		PRINT @ToWithdraw
		IF @ToWithdraw < 0.0
			RAISERROR('Account amount error!', 16, 1)
		ELSE
		BEGIN
			UPDATE BankCards
			SET BankCards.CardBalance = BankCards.CardBalance + @Value
			WHERE BankCards.Id = @CardId
			PRINT 'Items was updated!'
		END
COMMIT
END
GO

--CREATE OR ALTER PROCEDURE TestUpdateProcForAccountTrigger
--	@AccountId numeric(18, 0),
--	@NewAccountBalance decimal(18, 4)
--AS
--PRINT 'Start test procedure'
--BEGIN TRANSACTION

--	UPDATE BankAccount
--		SET BankAccount.AccountBalance = @NewAccountBalance
--	WHERE BankAccount.BankAccountID = @AccountId

--COMMIT TRANSACTION
--GO

--CREATE OR ALTER PROCEDURE TestUpdateProcForCardsTrigger
--	@CardId numeric(18, 0),
--	@NewCardBalance decimal(18, 4)
--AS
--PRINT 'Start test procedure'
--BEGIN TRANSACTION

--	UPDATE BankCard
--		SET BankCard.CardBalance = @NewCardBalance
--	WHERE BankCard.BankCardID = @CardId

--COMMIT TRANSACTION
--GO