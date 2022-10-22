USE [master]
CREATE DATABASE [BankSystem]

GO

 USE [BankSystem]
 CREATE TABLE [dbo].[Bank](
	[BankID] [numeric](18, 0) NOT NULL IDENTITY(1,1),
	[Name] [nvarchar](64) NOT NULL,
	CONSTRAINT [PK_Bank] PRIMARY KEY CLUSTERED ([BankID]) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[City](
	[CityID] [numeric](18, 0) NOT NULL IDENTITY(1,1),
	[Name] [nvarchar](64) NOT NULL,
	CONSTRAINT [PK_City] PRIMARY KEY CLUSTERED ([CityID]) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[BranchOffice](
	[BranchOfficeID] [numeric](18, 0) NOT NULL IDENTITY(1,1),
	[Name] [nvarchar](64) NOT NULL,
	[CityID] [numeric](18, 0) NOT NULL,
	[BankID] [numeric](18, 0) NOT NULL,
	CONSTRAINT [PK_BranchOffice] PRIMARY KEY CLUSTERED ([BranchOfficeID]) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Client](
	[ClientID] [numeric](18, 0) NOT NULL IDENTITY(1,1),
	[Name] [nvarchar](256) NOT NULL,
	[Phone] [nvarchar](16) NOT NULL,
	[BankID] [numeric](18, 0) NOT NULL,
	[SocialStatusID] [numeric](18, 0) NOT NULL,
	[BankAccountID] [numeric](18, 0) NOT NULL UNIQUE,
	CONSTRAINT [PK_Client] PRIMARY KEY CLUSTERED ([ClientID]) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[SocialStatus](
	[SocialStatusID] [numeric](18, 0) NOT NULL IDENTITY(1,1),
	[Name] [nvarchar](32) NOT NULL,
	CONSTRAINT [PK_SocialStatus] PRIMARY KEY CLUSTERED ([SocialStatusID]) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[BankAccount](
	[BankAccountID] [numeric](18, 0) NOT NULL IDENTITY(1,1),
	[AccountBalance] [decimal](18, 4) NOT NULL,
	CONSTRAINT [PK_BankAccount] PRIMARY KEY CLUSTERED ([BankAccountID]) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[BankCard](
	[BankCardID] [numeric](18, 0) NOT NULL IDENTITY(1,1),
	[BankAccountID] [numeric](18, 0) NOT NULL,
	[CardBalance] [decimal](18, 4) NOT NULL,
	CONSTRAINT [PK_BankCard] PRIMARY KEY CLUSTERED ([BankCardID]) ON [PRIMARY]
) ON [PRIMARY]
GO



ALTER TABLE [dbo].[BranchOffice] WITH CHECK ADD CONSTRAINT [FK_BranchOffice_City] FOREIGN KEY([CityID])
REFERENCES [dbo].[City] ([CityID])
GO
ALTER TABLE [dbo].[BranchOffice] CHECK CONSTRAINT [FK_BranchOffice_City]
GO

ALTER TABLE [dbo].[BranchOffice] WITH CHECK ADD CONSTRAINT [FK_BranchOffice_Bank] FOREIGN KEY([BankID])
REFERENCES [dbo].[Bank] ([BankID])
GO
ALTER TABLE [dbo].[BranchOffice] CHECK CONSTRAINT [FK_BranchOffice_Bank]
GO

ALTER TABLE [dbo].[Client] WITH CHECK ADD CONSTRAINT [FK_Client_SocialStatus] FOREIGN KEY([SocialStatusID])
REFERENCES [dbo].[SocialStatus] ([SocialStatusID])
GO
ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [FK_Client_SocialStatus]
GO

ALTER TABLE [dbo].[Client] WITH CHECK ADD CONSTRAINT [FK_Client_Bank] FOREIGN KEY([BankID])
REFERENCES [dbo].[Bank] ([BankID])
GO
ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [FK_Client_Bank]
GO

ALTER TABLE [dbo].[Client] WITH CHECK ADD CONSTRAINT [FK_Client_BankAccount] FOREIGN KEY([BankAccountID])
REFERENCES [dbo].[BankAccount] ([BankAccountID])
GO
ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [FK_Client_BankAccount]
GO

ALTER TABLE [dbo].[BankCard] WITH CHECK ADD CONSTRAINT [FK_BankCard_BankAccount] FOREIGN KEY([BankAccountID])
REFERENCES [dbo].[BankAccount] ([BankAccountID])
GO
ALTER TABLE [dbo].[BankCard] CHECK CONSTRAINT [FK_BankCard_BankAccount]
GO
