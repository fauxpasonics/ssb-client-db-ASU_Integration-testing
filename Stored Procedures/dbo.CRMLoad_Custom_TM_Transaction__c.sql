SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*****		Revision History

DCH on 2017-10-05:		Sproc created to replace view dbo.vwCRMLoad_Custom_TM_Transaction__c.


*****/


CREATE PROCEDURE [dbo].[CRMLoad_Custom_TM_Transaction__c]
AS 
BEGIN


SELECT AccountId
	, SSB_CRMSYSTEM_CONTACT_ID
into #tmp_vwDimCustomer_ModAcctId
FROM dbo.vwDimCustomer_ModAcctId (nolock)
WHERE CustomerType = 'Primary' AND SourceSystem = 'TM';

CREATE NONCLUSTERED INDEX IDX_vwDimCustomer_ModAcctId_CONTACT_ID on #tmp_vwDimCustomer_ModAcctId(SSB_CRMSYSTEM_CONTACT_ID);
CREATE NONCLUSTERED INDEX IDX_vwDimCustomer_ModAcctId_AccountId on #tmp_vwDimCustomer_ModAcctId(AccountId);

----------------------------------------------------------------------------------------------------------------------------------

with FirstStep as (
	SELECT SSB_CRMSYSTEM_CONTACT_ID__c
		, ISNULL(id,'') as id
		, CreatedDate
		, CreatedById
		, ROW_NUMBER() OVER (PARTITION BY SSB_CRMSYSTEM_CONTACT_ID__c ORDER BY CreatedDate ASC) rownum
	FROM prodcopy.vw_Account (nolock)
	WHERE SSB_CRMSYSTEM_CONTACT_ID__c IS NOT NULL
)
select SSB_CRMSYSTEM_CONTACT_ID__c
	, id
into #tmp_CRMAccount_DistinctGUID
from FirstStep
where rownum = 1;

CREATE NONCLUSTERED INDEX IDX_CRMAccount_DistinctGUID_CONTACT_ID on #tmp_CRMAccount_DistinctGUID(SSB_CRMSYSTEM_CONTACT_ID__c);

----------------------------------------------------------------------------------------------------------------------------------

SELECT
CONCAT('Ticket Order # ', ISNULL(CAST(t.OrderNumber__c AS NVARCHAR(100)),'Unknown')) AS Name 
,  t.Team__c
, t.TicketingAccountID__c
, t.SeasonName__c
, t.FactTicketSalesID__c
, t.OrderNumber__c
, t.OrderLine__c
, t.OrderDate__c
, t.Item__c
, t.ItemName__c
, t.EventDate__c
, t.PriceCode__c
, t.IsComp__c
, t.PromoCode__c
, t.QtySeat__c
, t.SectionName__c
, t.RowName__c
, t.Seat__c
, t.SeatPrice__c
, t.Total__c
, t.OwedAmount__c
, t.PaidAmount__c
, LEFT(t.SalesRep__c,255) AS SalesRep__c
, a.Id AS AccountID__c
, a.SSB_CRMSYSTEM_CONTACT_ID__c

--SELECT *
FROM stg.CRMLoad_TicketTransactions t
INNER JOIN #tmp_vwDimCustomer_ModAcctId dimcust
	ON t.TicketingAccountID__c = dimcust.AccountId							--	AND dimcust.CustomerType = 'Primary' AND dimcust.SourceSystem = 'TM'	--updateme
INNER JOIN #tmp_CRMAccount_DistinctGUID a
	ON dimcust.SSB_CRMSYSTEM_CONTACT_ID = a.SSB_CRMSYSTEM_CONTACT_ID__c		--	AND a.Rank = 1 --updateme based on Account model
LEFT JOIN ASU_Reporting.prodcopy.TM_Transactions__c pctt WITH (NOLOCK)
	ON pctt.FactTicketSalesID__c = t.FactTicketSalesID__c					--updateme for TM_Transaction (only because ASU had both Pac and TM)

--To catch up failures with missing fields
--INNER join dbo.TicketTrans_ErrorOutput e (nolock)
--	ON e.Order_Line_ID__c = t.Order_Line_ID__c
--	AND e.Sequence__c =  t.Sequence__c
--	AND e.account__c =   t.account__c

WHERE 1=1 AND (
	pctt.id IS NULL
	OR pctt.OwedAmount__c != t.OwedAmount__c
	OR pctt.PaidAmount__c != t.PaidAmount__c
	OR ISNULL(LEFT(pctt.SalesRep__c,255),'') != ISNULL(t.SalesRep__c,'')
	OR ISNULL(pctt.AccountId__c,'') != a.id
);



END



GO
