use ist722_mafudge_cb4_dw
GO

/*create schema customersatisfaction*/

DROP TABLE customersatisfaction.Fact_AccountTitles;
DROP TABLE customersatisfaction.FactReview;
DROP TABLE customersatisfaction.DimPlans;
DROP TABLE customersatisfaction.DimCustomerAccount;
DROP TABLE customersatisfaction.DimTitles;
DROP TABLE customersatisfaction.DimProduct;
DROP TABLE customersatisfaction.DimVendor;
DROP TABLE customersatisfaction.DimDate;



CREATE TABLE customersatisfaction.DimDate(
    [DateKey] [int] NOT NULL,
    [Date] [datetime] NULL,
    [FullDateUSA] [nchar](11) NOT NULL,
    [DayOfWeek] [tinyint] NOT NULL,
    [DayName] [nchar](10) NOT NULL,
    [DayOfMonth] [tinyint] NOT NULL,
    [DayOfYear] [int] NOT NULL,
    [WeekOfYear] [tinyint] NOT NULL,
    [MonthName] [nchar](10) NOT NULL,
    [MonthOfYear] [tinyint] NOT NULL,
    [Quarter] [tinyint] NOT NULL,
    [QuarterName] [nchar](10) NOT NULL,
    [Year] [int] NOT NULL,
    [IsAWeekday] varchar(1) NOT NULL DEFAULT (('N')),
    constraint pkNorthwindDimDate PRIMARY KEY ([DateKey])
)


CREATE TABLE customersatisfaction.DimPlans(
	[PlanKey] int NOT NULL,
	[plan_id] int NOT NULL,
	[plan_name] nvarchar(50) NOT NULL,
	[plan_price] money NOT NULL,
	[plan_current] bit NOT NULL,
	 -- metadata
  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
	CONSTRAINT [PK_customersatisfaction.DimPlans] PRIMARY KEY CLUSTERED ( [PlanKey] )
	);

	
CREATE TABLE customersatisfaction.DimCustomerAccount(
	[CustomerKey]  int IDENTITY  NOT NULL,
	[customer_source] nvarchar(9) NOT NULL,
	[account_id] int ,
	[account_email] nvarchar(200),
	[account_firstname] nvarchar(50),
	[account_lastname] nvarchar(50),
	[account_address] nvarchar(1000),
	[account_zipcode] char(5),
	[account_PlanKey] int,
	[account_opened_on] datetime,
	[customer_id] int,
	[customer_email] nvarchar(100),
	[customer_firstname] nvarchar(50),
	[customer_lastname]  nvarchar(50),
	[customer_address] nvarchar(255),
	[customer_city] nvarchar(50),
	[customer_state] char(2),
	[customer_zip] nvarchar(20),
	[customer_phone] nvarchar(30),
	[customer_fax] nvarchar(30)
	 -- metadata
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
	CONSTRAINT [PK_customersatisfaction.DimCustomerAccount] PRIMARY KEY CLUSTERED 
( [CustomerKey] ),
CONSTRAINT [FK_customersatisfaction_Customer_Plans] FOREIGN KEY (account_PlanKey)
  REFERENCES customersatisfaction.DimPlans(PlanKey),
) ;

CREATE TABLE customersatisfaction.DimVendor(
	[VendorKey]  int IDENTITY  NOT NULL,
	[vendor_id] int NOT NULL ,
	[vendor_name] nvarchar(50) NOT NULL,
	[vendor_phone] nvarchar(20) NOT NULL,
	[vendor_website] nvarchar(1000)
	 -- metadata
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
	CONSTRAINT [PK_customersatisfaction.DimVendor] PRIMARY KEY CLUSTERED ( [VendorKey] )
);


CREATE TABLE customersatisfaction.DimProduct(
	[ProductKey]  int IDENTITY  NOT NULL,
	[product_id] int NOT NULL ,
	[product_department] nvarchar(20) NOT NULL,
	[product_name] nvarchar(50) NOT NULL,
	[product_retail_price] money NOT NULL,
	[product_wholesale_price] money NOT NULL,
	[product_is_active] bit NOT NULL,
	[product_add_date] datetime NOT NULL,
	[product_VendorKey] int NOT NULL,
	[product_description] nvarchar(1000)
	 -- metadata
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
	CONSTRAINT [PK_customersatisfaction.DimProduct] PRIMARY KEY CLUSTERED ( [ProductKey] ),
    CONSTRAINT [FK_customersatisfaction_Vendor_Product] FOREIGN KEY (product_VendorKey)
  REFERENCES customersatisfaction.DimVendor( VendorKey),
);


CREATE TABLE customersatisfaction.FactReview(
	[CustomerKey] int NOT NULL,
	[ProductKey] int NOT NULL,
	[review_date_key] int NOT NULL,
	[review_stars] int NOT NULL,
	CONSTRAINT [PK_customersatisfaction.FactReview] PRIMARY KEY NONCLUSTERED ( [CustomerKey],[ProductKey]),
	CONSTRAINT [FK_customersatisfaction_Fact_Product] FOREIGN KEY (ProductKey)
  REFERENCES customersatisfaction.DimProduct( ProductKey),
  CONSTRAINT [FK_customersatisfaction_Fact_Customer] FOREIGN KEY (CustomerKey)
  REFERENCES customersatisfaction.DimCustomerAccount( CustomerKey),
   CONSTRAINT [FK_customersatisfaction_Fact_Date] FOREIGN KEY (review_date_key)
  REFERENCES customersatisfaction.DimDate( DateKey)
  );


CREATE TABLE customersatisfaction.DimTitles(
	[TitleKey] int NOT NULL,
	[title_id] int NOT NULL,
	[title_name] nvarchar(20) NOT NULL,
	[title_type] nvarchar(20) NOT NULL,
	[title_synopsis] nvarchar(max)NOT NULL,
	[title_avg_rating] decimal(18,2) NOT NULL,
	[title_release_year]  int NOT NULL,
	[title_runtime] int NOT NULL,
	[title_rating] nvarchar(20) NOT NULL
	 -- metadata
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
	CONSTRAINT [PK_customersatisfaction.DimTitles] PRIMARY KEY CLUSTERED ( [TitleKey])
	);

CREATE TABLE customersatisfaction.Fact_AccountTitles(
	[AccountKey] int NOT NULL,
	[at_id] int NOT NULL,
	[CustomerKey] int NOT NULL,
	[TitleKey]int NOT NULL,
	[at_queue_date_key] int NOT NULL,
	[at_shipped_date_key] int,
	[at_returned_date_key] int ,
	[at_rating] int,
	[days_toShip] int Null,
    [days_toReturn] int Null,
	CONSTRAINT [PK_customersatisfaction.FactAccountTitles] PRIMARY KEY CLUSTERED ( [AccountKey]),
	CONSTRAINT [FK_customersatisfaction_Fact_AccountTitles_Customer] FOREIGN KEY (CustomerKey)
  REFERENCES customersatisfaction.DimCustomerAccount( CustomerKey),
    CONSTRAINT [FK_customersatisfaction_Fact_AccountTitles_Title] FOREIGN KEY (TitleKey)
  REFERENCES customersatisfaction.DimTitles(TitleKey),
  CONSTRAINT [FK_customersatisfaction_Fact_Date1] FOREIGN KEY (at_queue_date_key)
  REFERENCES customersatisfaction.DimDate( DateKey),
  CONSTRAINT [FK_customersatisfaction_Fact_Date2] FOREIGN KEY (at_shipped_date_key)
  REFERENCES customersatisfaction.DimDate( DateKey),
  CONSTRAINT [FK_customersatisfaction_Fact_Date3] FOREIGN KEY (at_returned_date_key)
  REFERENCES customersatisfaction.DimDate( DateKey)

  );