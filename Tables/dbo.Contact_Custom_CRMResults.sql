CREATE TABLE [dbo].[Contact_Custom_CRMResults]
(
[ErrorCode] [int] NULL,
[ErrorColumn] [int] NULL,
[Update SF Dest.Id] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorDescription] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_SSID_Winner__c] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_SSID_Paciolan__c] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_DimCustomerID__c] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResultDateTime] [datetime] NULL CONSTRAINT [DF__Contact_C__Resul__7E37BEF6] DEFAULT (getdate())
)
GO
