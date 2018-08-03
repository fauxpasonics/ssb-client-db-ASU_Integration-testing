SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwCRMProcess_DeDupProdCopyAccount_ByGUID] --updateme based on Account Model (may need contact)
AS

SELECT SSB_CRMSYSTEM_CONTACT_ID__c, id, CreatedDate, CreatedById, RANK() OVER (PARTITION BY SSB_CRMSYSTEM_CONTACT_ID__c ORDER BY CreatedDate ASC) Rank
FROM prodcopy.[vw_Account]
WHERE SSB_CRMSYSTEM_CONTACT_ID__c IS NOT NULL
GO
