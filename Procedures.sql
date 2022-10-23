USE BankSystem
GO

CREATE OR ALTER PROCEDURE AddMoneyProc
	@SocStatusId numeric(18, 0)
AS
BEGIN
SET NOCOUNT ON
PRINT 'Start procedure AddMoneyProc(id)'

	DECLARE @MoneyValue DECIMAL(18, 4), @AccQt INTEGER, @IdCheck INTEGER
	SET @MoneyValue = 10.0000
	SET @AccQt = (SELECT COUNT(SocialStatusId) FROM GetBankAccountsView WHERE SocialStatusId = @SocStatusId)
	SET @IdCheck = (SELECT COUNT(SocialStatus.SocialStatusID) FROM SocialStatus WHERE SocialStatus.SocialStatusID = @SocStatusId)

	IF @IdCheck = 0
		PRINT 'Wrong social number status!'
	ELSE IF @AccQt = 0
		PRINT 'No linked accounts!'
	ELSE
		UPDATE BankAccount
		SET BankAccount.AccountBalance = BankAccount.AccountBalance + @MoneyValue
		WHERE BankAccount.BankAccountID IN (SELECT BankAccountId FROM (
			SELECT SocialStatusId, BankAccountId FROM GetBankAccountsView WHERE SocialStatusId = @SocStatusId) AS BankAccountId)
		PRINT 'Items was updated!'
END
GO


CREATE OR ALTER PROCEDURE WithdrawFromAccountToCard
	@AccountId numeric(18, 0),
	@CardId numeric(18, 0),
	@Value decimal(18, 4)
AS
BEGIN
SET NOCOUNT ON
PRINT 'Start procedure WithdrawFromAccountToCards(AccountId, CardId, Value)'
BEGIN TRANSACTION
	DECLARE @AccountBalance decimal(18, 4)
	DECLARE @CardsBalance decimal(18, 4)

	IF (SELECT COUNT(*) FROM GetCards WHERE @CardId = CardId) = 0
		PRINT 'This card does not exist'
	ELSE IF	(SELECT COUNT(*) FROM GetCards WHERE @AccountId = AccountId) = 0
		PRINT 'This account does not exist'
	ELSE
		SET @AccountBalance = (SELECT TOP 1 AccountBalance FROM GetCards WHERE @AccountId = AccountId)
		PRINT @AccountBalance
		SET @CardsBalance = (SELECT SUM(CardBalance) FROM GetCards WHERE @AccountId = AccountId)
		PRINT @CardsBalance
		BEGIN
			PRINT @AccountBalance - @CardsBalance - @Value
			UPDATE BankCard
			SET BankCard.CardBalance = BankCard.CardBalance + @Value
			WHERE BankCard.BankCardID = @CardId
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