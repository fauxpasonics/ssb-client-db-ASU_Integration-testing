CREATE TABLE [dbo].[Contact_Custom]
(
[SSB_CRMSYSTEM_Contact_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSID_Winner] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TI_Ids] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DimCustIDs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountId] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeasonTicket_Years] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRMProcess_UpdatedDate] [datetime] NULL,
[SSID_Winner_SourceSystem] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonEmail] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Business_Email__c] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonHomePhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonMobilePhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Biz_Other_Phone__c] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonOtherPhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonBirthdate] [date] NULL,
[Customer_Type__c] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Donor_Flag__c] [bit] NULL,
[SDC_Member_Level__c] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_Ids] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_Total_Priority_Points__c] [decimal] (10, 2) NULL,
[SSB_CRMSYSTEM_Priority_Point_Rank__c] [int] NULL,
[Turnkey_Football_Priority_Score__c] [int] NULL,
[Turnkey_Basketball_Priority_Score__c] [int] NULL,
[Turnkey_Football_Capacity_Score__c] [decimal] (1, 0) NULL,
[Turnkey_Basketball_Capacity_Score__c] [decimal] (1, 0) NULL,
[Turnkey_WBasketball_Capacity_Score__c] [decimal] (1, 0) NULL,
[Turnkey_WBasketball_Priority_Score__c] [decimal] (1, 0) NULL,
[Turnkey_Net_Worth_Gold__c] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Turnkey_Discretionary_Income_Index__c] [decimal] (4, 0) NULL,
[Turnkey_PersonicX_Cluster__c] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Turnkey_Age_Input_Individual__c] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Turnkey_Marital_Status__c] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Turnkey_Presence_of_Children__c] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email_Unsubscribe__c] [bit] NULL,
[SSB_CRMSYSTEM_Last_Email_Engagement_Date__c] [date] NULL,
[SSB_CRMSYSTEM_Last_Ticket_Purchase_Date__c] [date] NULL,
[SSB_CRMSYSTEM_Last_Donation_Date__c] [date] NULL
)
GO
ALTER TABLE [dbo].[Contact_Custom] ADD CONSTRAINT [PK_Contact_Custom] PRIMARY KEY CLUSTERED  ([SSB_CRMSYSTEM_Contact_ID])
GO
