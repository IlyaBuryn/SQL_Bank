USE BankSystem
GO

ALTER PROCEDURE AddMoneyProc
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

		SELECT * FROM GetBankAccountsView ORDER BY SocialStatusId
END
GO





ALTER PROCEDURE WithdrawFromAccountToCard
	@AccountId numeric(18, 0),
	@CardId numeric(18, 0),
	@Value decimal(18, 4)
AS
BEGIN
SET NOCOUNT ON
PRINT 'Start procedure WithdrawFromAccountToCards(AccountId, CardId, Value)'

	DECLARE @AccountBalance decimal(18, 4)
	DECLARE @CardsBalance decimal(18, 4)
-- Проверка разности

	IF (SELECT COUNT(*) FROM GetCards WHERE @CardId = CardId) = 0
		PRINT 'This card does not exist'
	ELSE IF	(SELECT COUNT(*) FROM GetCards WHERE @AccountId = AccountId) = 0
		PRINT 'This account does not exist'
	ELSE
		SET @AccountBalance = (SELECT TOP 1 AccountBalance FROM GetCards WHERE @AccountId = AccountId)
		PRINT @AccountBalance
		SET @CardsBalance = (SELECT SUM(CardBalance) FROM GetCards WHERE @AccountId = AccountId)
		PRINT @CardsBalance
		IF @AccountBalance < @Value
		OR (@AccountBalance - @CardsBalance - @Value) < 0
			PRINT 'Insufficient funds on the account'
		ELSE 
		BEGIN
			PRINT @AccountBalance - @CardsBalance - @Value
			UPDATE BankCard
			SET BankCard.CardBalance = BankCard.CardBalance + @Value
			WHERE BankCard.BankCardID = @CardId
			PRINT 'Items was updated!'
		END
		SELECT BankCard.CardBalance FROM BankCard WHERE BankCard.BankCardID = @CardId
END
GO