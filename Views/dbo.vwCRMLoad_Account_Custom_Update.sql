SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vwCRMLoad_Account_Custom_Update]
AS
SELECT  
b.ssb_crmsystem_Contact_ID,
	 z.[crm_id] Id
	,b.SSID_Winner SSB_CRMSYSTEM_SSID_Winner__c
	,b.DimCustIDs SSB_CRMSYSTEM_DimCustomerID__c
	,b.TI_IDs SSB_CRMSYSTEM_SSID_Paciolan__c
	,b.AccountId SSB_CRMSYSTEM_PatronID__c
	,b.SeasonTicket_Years SSB_CRMSYSTEM_Season_Ticket_Years__c
	,b.SSID_Winner_SourceSystem SSB_CRMSYSTEM_SSID_Winner_SourceSystem
	--,SSB_CRMSYSTEM_Last_Ticket_Purchase_Date__c
	--,b.PersonOtherPhone
	--,b.PersonHomePhone
	--,Secondary_Email__pc
	--,Preferred_Phone__pc
	--,Cell_Phone__pc
	--,Business_Phone__pc
	,z.AddressPrimaryStreet	PersonMailingStreet
	,z.AddressPrimaryCity	PersonMailingCity
	,z.AddressPrimaryState	PersonMailingState
	,z.AddressPrimaryZip	PersonMailingPostalCode
	,z.AddressPrimaryCountry PersonMailingCountry
	--,b.PersonEmail
	--,b.Business_Email__c
	--,b.PersonBirthdate 
FROM dbo.[vwCRMLoad_Account_Std_Prep] a
INNER JOIN dbo.Contact_Custom b ON [a].[ssb_crmsystem_Contact_ID__c] = b.ssb_crmsystem_Contact_ID
INNER JOIN dbo.Contact z ON a.[ssb_crmsystem_Contact_ID__c] = z.ssb_crmsystem_Contact_ID
WHERE z.[SSB_CRMSYSTEM_CONTACT_ID] <> z.[crm_id]



GO
