CREATE TABLE SalesOrderHeader(
[SalesOrderID] [int] NOT NULL,
[RevisionNumber] [tinyint] NOT NULL,
[OrderDate] [datetime] NOT NULL,
[DueDate] [datetime] NOT NULL,
[ShipDate] [datetime] NULL,
[Status] [tinyint] NOT NULL,
[OnlineOrderFlag] [BIT] NOT NULL,
[SalesOrderNumber]  [nvarchar](23) not null,
[PurchaseOrderNumber] [nvarchar](23) NULL,
[AccountNumber] [nvarchar](23) NULL,
[CustomerID] [int] NOT NULL,
[ShipToAddressID] [int] NULL,
[BillToAddressID] [int] NULL,
[ShipMethod] [nvarchar](50) NOT NULL,
[CreditCardApprovalCode] [varchar](15) NULL,
[SubTotal] [money] NOT NULL,
[TaxAmt] [money] NOT NULL,
[Freight] [money] NOT NULL,
[TotalDue]  [money] NULL,
[Comment] [nvarchar](1000) NULL,
[rowguid] [uniqueidentifier] NOT NULL,
[ModifiedDate] [datetime] NOT NULL
)


CREATE TABLE Customer(
    [CustomerID] [int] NOT NULL,
    [NameStyle]  [bit] NOT NULL,
    [Title] [nvarchar](8) NULL,
    [FirstName] [nvarchar](128) NOT NULL,
    [MiddleName] [nvarchar](20) NULL,
    [LastName] [nvarchar](128) NOT NULL,
    [Suffix] [nvarchar](10) NULL,
    [CompanyName] [nvarchar](128) NULL,
    [SalesPerson] [nvarchar](256) NULL,
    [EmailAddress] [nvarchar](50) NULL,
    [Phone] [nvarchar](20) NULL,
    [PasswordHash] [varchar](128) NOT NULL,
    [PasswordSalt] [varchar](10) NOT NULL,
    [rowguid] [uniqueidentifier] NOT NULL,
    [ModifiedDate] [datetime] NOT NULL
)