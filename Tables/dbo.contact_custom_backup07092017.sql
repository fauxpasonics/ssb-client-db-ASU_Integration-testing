CREATE TABLE [dbo].[contact_custom_backup07092017]
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
[TM_Ids] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
