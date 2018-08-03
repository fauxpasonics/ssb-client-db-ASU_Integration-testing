SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROCEDURE  [wrk].[sp_Contact_Custom]
AS 

TRUNCATE TABLE dbo.Contact_Custom;

MERGE INTO dbo.Contact_Custom Target
USING dbo.[Contact] source
ON source.[SSB_CRMSYSTEM_Contact_ID] = target.[SSB_CRMSYSTEM_Contact_ID]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([SSB_CRMSYSTEM_Contact_ID]) VALUES (Source.[SSB_CRMSYSTEM_Contact_ID])
WHEN NOT MATCHED BY SOURCE THEN DELETE;

EXEC dbo.sp_CRMProcess_ConcatIDs 'Contact'

DECLARE @currentmemberyear int = (Select  datepart(year,getdate()))
					
DECLARE @previousmemberyear int = @currentmemberyear -1 


UPDATE a
SET SSID_Winner = b.SSID
,SSID_Winner_SourceSystem	= b.SourceSystem
,[PersonEmail] = b.EmailPrimary
,[Business_Email__c] = b.EmailPrimary
,[PersonHomePhone] = b.PhoneHome
,[PersonMobilePhone] = b.PhoneCell
,[Biz_Other_Phone__c] = b.PhoneBusiness
,[PersonOtherPhone] = b.PhoneOther
,[PersonBirthdate] = b.Birthday
,[Customer_Type__c] = b.CustomerType
FROM [dbo].[Contact_Custom] a
INNER JOIN dbo.[vwCompositeRecord_ModAcctID] b ON b.[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_Contact_ID]
INNER JOIN dbo.[vwDimCustomer_ModAcctId] c ON b.[DimCustomerId] = c.[DimCustomerId] AND c.SSB_CRMSYSTEM_PRIMARY_FLAG = 1

UPDATE a
SET SeasonTicket_Years = recent.SeasonTicket_Years
FROM dbo.[Contact_Custom] a
INNER JOIN dbo.CRMProcess_DistinctContacts recent ON [recent].SSB_CRMSYSTEM_Contact_ID = [a].SSB_CRMSYSTEM_Contact_ID


SELECT b.[SSB_CRMSYSTEM_Contact_ID], b.SSID, b.[SourceSystem]
INTO #tmpSSID_ACCTGUID
FROM [dbo].[Contact_Custom] a
INNER JOIN dbo.[vwDimCustomer_ModAcctId] b ON [a].[SSB_CRMSYSTEM_Contact_ID] = b.[SSB_CRMSYSTEM_Contact_ID]
--DROP TABLE #tmpSSID_ACCTGUID

--SDC Fields
UPDATE a
SET [Donor_Flag__c] = ISNULL(c.Donor_Flag,0) 
 , [SDC_Member_Level__c] = ISNULL(c.GIFT_CLUB_DESC, 'Non-Member')
FROM [dbo].[Contact_Custom] a WITH (NOLOCK)
LEFT JOIN (SELECT DISTINCT [c].[SSB_CRMSYSTEM_Contact_ID], 1 AS Donor_Flag, MAX(QUALIFIED_AMOUNT) AS QUALIFIED_AMOUNT, GIFT_CLUB_DESC 
			 from [ASU].[dbo].[FD_SDC_GIFT_CLUBS] gc WITH(NOLOCK)
			 INNER JOIN [ASU].[dbo].[FD_SDA_ENTITY_OTHER_IDS] oid WITH(NOLOCK) 
					ON gc.GIFT_CLUB_ID_NUMBER = oid.[ID_NUMBER] AND TYPE_CODE = 'SDP'
			 INNER JOIN  dbo.[vwDimCustomer_ModAcctId] c 
					ON c.SourceSystem = 'TM' AND CustomerType = 'Primary' AND oid.[OTHER_ID] = CAST(c.[AccountId] AS nvarchar(50)) AND c.SSB_CRMSYSTEM_PRIMARY_FLAG = 1
			 where GIFT_CLUB_STATUS = 'A'
			GROUP BY SSB_CRMSYSTEM_CONTACT_ID, GIFT_CLUB_DESC
			) c
ON c.[SSB_CRMSYSTEM_Contact_ID]=a.[SSB_CRMSYSTEM_Contact_ID]

UPDATE a
SET [SSB_CRMSYSTEM_Total_Priority_Points__c] = ISNULL(c.TOTAL_POINTS,0) 
 , [SSB_CRMSYSTEM_Priority_Point_Rank__c] = ISNULL(c.RANKING, 0)
FROM [dbo].[Contact_Custom] a WITH (NOLOCK)
LEFT JOIN (SELECT DISTINCT [c].[SSB_CRMSYSTEM_Contact_ID], TOTAL_POINTS, RANKING
			 from [ASU].[dbo].[FD_SDA_PRIORITY_POINT_SUMMARY] pp (NOLOCK)
			 INNER JOIN  dbo.[vwDimCustomer_ModAcctId] c 
					ON c.SourceSystem = 'TM' AND CustomerType = 'Primary' AND pp.[PACIOLAN_ID] = CAST(c.[AccountId] AS nvarchar(50)) AND c.SSB_CRMSYSTEM_PRIMARY_FLAG = 1
			GROUP BY SSB_CRMSYSTEM_CONTACT_ID, TOTAL_POINTS, RANKING
			) c 
ON c.[SSB_CRMSYSTEM_Contact_ID]=a.[SSB_CRMSYSTEM_Contact_ID]

-- For Last_Ticket_Purchase_Date  (added 7/5/2018 by Ameitin)
	UPDATE a
	SET	   [SSB_CRMSYSTEM_Last_Ticket_Purchase_Date__c] = fts.Ticket_Date
	FROM   [dbo].[Contact_Custom] a ( NOLOCK )
		   INNER JOIN (
						  SELECT   [b].[SSB_CRMSYSTEM_CONTACT_ID]
								   , MAX([CalDate]) AS Ticket_Date
						  FROM	   [ASU].[ro].[vw_FactTicketSales_All] a ( NOLOCK )
						  INNER JOIN ASU.dbo.DimDate dd (NOLOCK) 
										ON a.DimDateId = dd.DimDateId
						  INNER JOIN dbo.[vwDimCustomer_ModAcctId] b 
										ON b.SourceSystem = 'TM' 
										AND [a].ETL__SSID_TM_acct_id = b.AccountId 
										AND b.CustomerType = 'Primary'
						  GROUP BY [b].[SSB_CRMSYSTEM_CONTACT_ID]
					  ) fts ON fts.[SSB_CRMSYSTEM_CONTACT_ID] = a.[SSB_CRMSYSTEM_Contact_ID];

--Last Donation Date (added 7/5/2018 by Ameitin)

	UPDATE a
	SET	   [SSB_CRMSYSTEM_Last_Donation_Date__c] = don.TransDate
	FROM   [dbo].[Contact_Custom] a ( NOLOCK )
		   INNER JOIN (
						 SELECT   [b].[SSB_CRMSYSTEM_CONTACT_ID]
								   , MAX([DATE_OF_RECORD]) AS TransDate
						 FROM	   [ASU].[dbo].[FD_SDA_TRANSACTION_DETAIL] a ( NOLOCK )
								   INNER JOIN dbo.[vwDimCustomer_ModAcctId] b ON b.SourceSystem = 'Advance ASU' 
																				AND [a].ID_NUMBER = b.SSID
																				
						  WHERE	   GYPMD_DESC <> 'Pledge'
						  GROUP BY [b].[SSB_CRMSYSTEM_CONTACT_ID]
					  ) don ON don.[SSB_CRMSYSTEM_CONTACT_ID] = a.[SSB_CRMSYSTEM_Contact_ID];


--Email Unsubscribe  (added 7/5/2018 by Ameitin)

	UPDATE a
	SET	   [Email_Unsubscribe__c] = ISNULL(x.unsub_Flag, 0)
	FROM   [dbo].[Contact_Custom] a
		   LEFT JOIN (
						 SELECT DISTINCT SSB_CRMSYSTEM_CONTACT_ID
										 , CASE WHEN sfmc.[status] = 'unsub' THEN 1 ELSE 0 END AS Unsub_Flag
						 FROM	ASU.[dbo].[vwCompositeRecord_ModAcctID] b ( NOLOCK )
								INNER JOIN ASU.[ods].[SFMC_Subscribers] sfmc ( NOLOCK ) 
								ON sfmc.EmailAddress = b.EmailPrimary
						 WHERE	ISNULL(RTRIM(sfmc.EmailAddress), '') <> ''
					 ) x ON a.SSB_CRMSYSTEM_Contact_ID = x.SSB_CRMSYSTEM_CONTACT_ID;

--Email Last Engagement Date  (added 7/5/2018 by Ameitin)

	UPDATE a
	SET	   [SSB_CRMSYSTEM_Last_Email_Engagement_Date__c] = x.Engagement_Date
	FROM   [dbo].[Contact_Custom] a
		   INNER JOIN ( SELECT DISTINCT SSB_CRMSYSTEM_CONTACT_ID
						, MAX(Engagement_Date) AS Engagement_Date
						 FROM (
						  SELECT   [b].[SSB_CRMSYSTEM_CONTACT_ID]
								   , CAST(MAX(EventDate) AS DATE) AS Engagement_Date
						  FROM	   [ASU].[ods].[SFMC_Opens] sfmc ( NOLOCK )
								   INNER JOIN ASU.[dbo].[vwCompositeRecord_ModAcctID] b  
								   ON sfmc.EmailAddress = b.EmailPrimary
						  GROUP BY [b].[SSB_CRMSYSTEM_CONTACT_ID]

						  UNION ALL

						  SELECT   [b].[SSB_CRMSYSTEM_CONTACT_ID]
								   , CAST(MAX(EventDate) AS DATE) AS Engagement_Date
						  FROM	   [ASU].[ods].[SFMC_Clicks] sfmc ( NOLOCK )
								   INNER JOIN ASU.[dbo].[vwCompositeRecord_ModAcctID] b  
								   ON sfmc.EmailAddress = b.EmailPrimary
						  GROUP BY [b].[SSB_CRMSYSTEM_CONTACT_ID]
						   ) e
						   GROUP BY SSB_CRMSYSTEM_CONTACT_ID
					  ) x ON a.SSB_CRMSYSTEM_CONTACT_ID = x.SSB_CRMSYSTEM_CONTACT_ID;

---Turnkey Fields (added 7/5/2018 by AMeitin)
UPDATE a
SET 
a.Turnkey_Football_Capacity_Score__c     = tk.[Turnkey_Football_Capacity_Score__c]
,a.Turnkey_Football_Priority_Score__c     = tk.[Turnkey_Football_Priority_Score__c]
,a.Turnkey_Basketball_Capacity_Score__c   = tk.[Turnkey_Basketball_Capacity_Score__c]
,a.Turnkey_Basketball_Priority_Score__c   = tk.[Turnkey_Basketball_Priority_Score__c]
,a.Turnkey_WBasketball_Capacity_Score__c  = tk.[Turnkey_WBasketball_Capacity_Score__c]
,a.Turnkey_WBasketball_Priority_Score__c  = tk.[Turnkey_WBasketball_Priority_Score__c]
,a.Turnkey_Net_Worth_Gold__c              = tk.[Turnkey_Net_Worth_Gold__c]
,a.Turnkey_Discretionary_Income_Index__c  = CASE WHEN tk.[Turnkey_Discretionary_Income_Index__c] = '' THEN '-1' 
												ELSE tk.[Turnkey_Discretionary_Income_Index__c] END 
,a.Turnkey_PersonicX_Cluster__c           = tk.[Turnkey_PersonicX_Cluster__c]
,a.Turnkey_Age_Input_Individual__c        = tk.[Turnkey_Age_Input_Individual__c]
,a.Turnkey_Marital_Status__c              = tk.[Turnkey_Marital_Status__c]
,a.Turnkey_Presence_of_Children__c        = tk.[Turnkey_Presence_of_Children__c]

FROM [dbo].[Contact_Custom] a WITH (NOLOCK)
INNER JOIN ASU.[ro].[vw_Turnkey_CustomFields] tk
	ON a.SSB_CRMSYSTEM_Contact_ID = tk.SSB_CRMSYSTEM_CONTACT_ID

EXEC  [dbo].[sp_CRMLoad_Contact_ProcessLoad_Criteria]
GO
