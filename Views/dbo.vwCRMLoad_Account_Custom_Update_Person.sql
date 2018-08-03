SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO











CREATE VIEW [dbo].[vwCRMLoad_Account_Custom_Update_Person]
AS
SELECT  
b.ssb_crmsystem_Contact_ID,
	 z.[crm_id] Id
	,b.SSID_Winner SSB_CRMSYSTEM_SSID_Winner__c
	,b.DimCustIDs SSB_CRMSYSTEM_DimCustomerID__c
	,b.TI_IDs SSB_CRMSYSTEM_SSID_Paciolan__c
	,b.AccountId SSB_CRMSYSTEM_SSID_TM__c
	,b.SeasonTicket_Years SSB_CRMSYSTEM_Season_Ticket_Years__c
	,b.SSID_Winner_SourceSystem SSB_CRMSYSTEM_SSID_Winner_SourceSystem
	,b.TM_Ids [SSB_CRMSYSTEM_TM_Account_ID__c]
	--,SSB_CRMSYSTEM_Last_Ticket_Purchase_Date__c
	--,b.PersonOtherPhone
	--,b.PersonHomePhone
	--,Secondary_Email__pc
	--,Preferred_Phone__pc
	--,Cell_Phone__pc
	--,Business_Phone__pc
	,NULLIF(z.AddressPrimaryStreet, '')	PersonMailingStreet
	,NULLIF(z.AddressPrimaryCity, '')	PersonMailingCity
	,NULLIF(z.AddressPrimaryState, '')	PersonMailingState
	,NULLIF(z.AddressPrimaryZip, '')	PersonMailingPostalCode
	,NULLIF(z.AddressPrimaryCountry, '') PersonMailingCountry
	--, aa.SSB_CRMSYSTEM_SSID_Winner__c , aa.SSB_CRMSYSTEM_DimCustomerID__c, aa.SSB_CRMSYSTEM_SSID_Paciolan__c , aa.Patron_ID__c , aa.SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c , aa.PersonMailingStreet , aa.PersonMailingCity , aa.PersonMailingState , aa.PersonMailingPostalCode , aa.PersonMailingCountry
	,b.PersonEmail
	--,b.Business_Email__c
	--,b.PersonBirthdate
	,b.Turnkey_Football_Capacity_Score__c	
	,b.Turnkey_Basketball_Capacity_Score__c	
	,b.Turnkey_WBasketball_Capacity_Score__c	
	,b.Turnkey_WBasketball_Priority_Score__c	
	,b.Turnkey_Net_Worth_Gold__c	
	,b.Turnkey_Discretionary_Income_Index__c	
	,b.Turnkey_PersonicX_Cluster__c	
	,b.Turnkey_Age_Input_Individual__c	
	,b.Turnkey_Marital_Status__c	
	,b.Turnkey_Presence_of_Children__c	
	,b.Email_Unsubscribe__c	
	,b.SSB_CRMSYSTEM_Last_Email_Engagement_Date__c	
	,b.SSB_CRMSYSTEM_Last_Ticket_Purchase_Date__c	
	,b.SSB_CRMSYSTEM_Last_Donation_Date__c
FROM dbo.[vwCRMLoad_Account_Std_Prep] a
INNER JOIN dbo.Contact_Custom b ON [a].[ssb_crmsystem_Contact_ID__c] = b.ssb_crmsystem_Contact_ID
INNER JOIN dbo.Contact z ON a.[ssb_crmsystem_Contact_ID__c] = z.ssb_crmsystem_Contact_ID
LEFT JOIN prodcopy.Account AA ON z.crm_ID = aa.ID
LEFT JOIN prodcopy.RecordType rt ON aa.RecordTypeId = rt.Id
LEFT JOIN dbo.vw_KeyAccounts k ON k.SSBID = a.ssb_crmsystem_Contact_ID__c
WHERE z.[SSB_CRMSYSTEM_Contact_ID] <> z.[crm_id]
--AND k.SSBID IS null
AND ISNULL(CASE WHEN rt.name = 'Business Account' THEN 1 WHEN rt.name = 'Person Account' THEN 0 END, z.isbusinessaccount) = 0 
--AND ISNULL(CASE WHEN rt.name = 'Business_Account' THEN 1 WHEN rt.name = 'PersonAccount' THEN 0 END, z.isbusinessaccount) = 1
AND (
ISNULL(b.SSID_Winner,'')							!=			  ISNULL(aa.SSB_CRMSYSTEM_SSID_Winner__c,'')
OR ISNULL(b.DimCustIDs,'')							!=		  ISNULL(aa.SSB_CRMSYSTEM_DimCustomerID__c,'')
--OR ISNULL(b.TI_IDs,'') 								!=		  ISNULL(aa.SSB_CRMSYSTEM_SSID_Paciolan__c,'')
OR ISNULL(b.AccountId ,'')								!=		  ISNULL(aa.SSB_CRMSYSTEM_SSID_TM__c,'')
--OR isnull(b.SeasonTicket_Years,'') 			!=				  isnull(aa.SSB_CRMSYSTEM_Season_Ticket_Years__c,'')
OR ISNULL(b.SSID_Winner_SourceSystem,'') 	!=					  ISNULL(aa.SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c,'')
OR ISNULL(z.AddressPrimaryStreet,'')	!=						  ISNULL(aa.PersonMailingStreet,'')
OR ISNULL(z.AddressPrimaryCity,'')		!=						  ISNULL(aa.PersonMailingCity,'')
OR ISNULL(z.AddressPrimaryState,'')	!=						  ISNULL(aa.PersonMailingState,'')
OR ISNULL(z.AddressPrimaryZip,'')		!=						  ISNULL(aa.PersonMailingPostalCode,'')
OR ISNULL(z.AddressPrimaryCountry,'')  !=						  ISNULL(aa.PersonMailingCountry,'')
OR ISNULL(b.TM_Ids,'')  !=						  ISNULL(aa.[SSB_CRMSYSTEM_TM_Account_ID__c],'')
OR ISNULL(b.PersonEmail,'')  !=						  ISNULL(aa.PersonEmail,'')
--OR ISNULL(b.TM_Ids,'')  !=						  ISNULL(aa.[SSB_CRMSYSTEM_SSID_TM__c] ,'')
	OR isnull(b.Turnkey_Football_Capacity_Score__c,0)	 != isnull(aa.Turnkey_Football_Capacity_Score__c,0)	
OR isnull(b.Turnkey_Basketball_Capacity_Score__c,0)	 != isnull(aa.Turnkey_Basketball_Capacity_Score__c,0)	
OR isnull(b.Turnkey_WBasketball_Capacity_Score__c,0)	 != isnull(aa.Turnkey_WBasketball_Capacity_Score__c,0)	
OR isnull(b.Turnkey_WBasketball_Priority_Score__c,0)	 != isnull(aa.Turnkey_WBasketball_Priority_Score__c,0)	
OR isnull(b.Turnkey_Net_Worth_Gold__c,'')	 != isnull(aa.Turnkey_Net_Worth_Gold__c,'')	
OR isnull(b.Turnkey_Discretionary_Income_Index__c,0)	 != isnull(aa.Turnkey_Discretionary_Income_Index__c,0)	
OR isnull(b.Turnkey_PersonicX_Cluster__c,'')	 != isnull(aa.Turnkey_PersonicX_Cluster__c,'')	
OR isnull(b.Turnkey_Age_Input_Individual__c,'')	 != isnull(aa.Turnkey_Age_Input_Individual__c,'')	
OR isnull(b.Turnkey_Marital_Status__c,'')	 != isnull(aa.Turnkey_Marital_Status__c,'')	
OR isnull(b.Turnkey_Presence_of_Children__c,'')	 != isnull(aa.Turnkey_Presence_of_Children__c,'')	
OR isnull(b.Email_Unsubscribe__c,0)	 != isnull(aa.Email_Unsubscribe__c,0)	
OR isnull(b.SSB_CRMSYSTEM_Last_Email_Engagement_Date__c, '1901-01-01') != isnull(aa.SSB_CRMSYSTEM_Last_Email_Engagement_Date__c, '1901-01-01')	
OR isnull(b.SSB_CRMSYSTEM_Last_Ticket_Purchase_Date__c, '1901-01-01') != isnull(aa.SSB_CRMSYSTEM_Last_Ticket_Purchase_Date__c, '1901-01-01')	
OR isnull(b.SSB_CRMSYSTEM_Last_Donation_Date__c, '1901-01-01') != isnull(aa.SSB_CRMSYSTEM_Last_Donation_Date__c, '1901-01-01')
)






GO
