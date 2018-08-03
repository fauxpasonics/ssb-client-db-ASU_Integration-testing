SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vwCRMLoad_Account_Std_Update] AS
SELECT a.ssb_crmsystem_Contact_ID__c, a.FirstName, a.LastName, a.Suffix, 
a.BillingStreet, a.BillingCity, a.BillingState, a.BillingPostalCode, a.BillingCountry, a.Phone, a.Id, [LoadType]
--, c.ssb_crmsystem_Contact_ID__c, c.FirstName, c.LastName,c.Suffix__c, c.BillingStreet, c.BillingCity, c.BillingState, c.BillingPostalCode, c.BillingCountry, c.Phone
FROM [dbo].[vwCRMLoad_Account_Std_Prep] a
LEFT JOIN prodcopy.Account c WITH (NOLOCK) ON a.Id = c.ID
WHERE LoadType = 'Update'
--AND  (HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( a.FirstName AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.FirstName AS VARCHAR(MAX)))),'')) 
--	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( a.LastName AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.LastName AS VARCHAR(MAX)))),'')) 
--	--OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( a.Suffix as varchar(max)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( c.Suffix as varchar(max)))),'')) 
--	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( a.BillingStreet AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.BillingStreet AS VARCHAR(MAX)))),'')) 
--	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( a.BillingCity AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.BillingCity AS VARCHAR(MAX)))),'')) 
--	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( a.BillingState AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.BillingState AS VARCHAR(MAX)))),'')) 
--	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( a.BillingPostalCode AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.BillingPostalCode AS VARCHAR(MAX)))),'')) 
--	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( a.BillingCountry AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.BillingCountry AS VARCHAR(MAX)))),'')) 
--	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( a.Phone AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.Phone AS VARCHAR(MAX)))),'')) 
--	--Or HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( a.emailaddress1 as varchar(max)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( c.emailaddress1 as varchar(max)))),'')) 
--	)
AND ( 
a.ssb_crmsystem_Contact_ID__c != c.ssb_crmsystem_Contact_ID__c
OR a.FirstName != c.FirstName
OR a.LastName != c.LastName
OR a.Suffix != c.Suffix__c
OR a.BillingStreet != c.BillingStreet
OR a.BillingCity != c.BillingCity
OR a.BillingState != c.BillingState
OR a.BillingPostalCode != c.BillingPostalCode
OR a.BillingCountry != c.BillingCountry
OR a.Phone != c.Phone
)


GO
