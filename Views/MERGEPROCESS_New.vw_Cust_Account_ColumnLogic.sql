SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [MERGEPROCESS_New].[vw_Cust_Account_ColumnLogic]
AS
SELECT  ID,
		Losing_ID AS Losing_ID ,					
        CAST(SUBSTRING(Preferred_Name__c, 2, 82) AS NVARCHAR(50)) Preferred_Name__c,
		CAST(SUBSTRING([Description], 2, 3999) AS NVARCHAR(MAX)) [Description],	 
		CAST(SUBSTRING([Reasons_Why_Bought__c], 2, 3999) AS NVARCHAR(MAX)) [Reasons_Why_Bought__c]	 
FROM    ( SELECT    Winning_ID AS ID ,
					Losing_ID AS Losing_ID ,					
                    MAX(CASE WHEN dta.xtype = 'Winning'
                                  AND Preferred_Name__c IS NOT NULL AND Preferred_Name__c != ''
                             THEN '2' + CAST(Preferred_Name__c AS VARCHAR(50))
                             WHEN dta.xtype = 'Losing'
                                  AND Preferred_Name__c IS NOT NULL AND Preferred_Name__c != ''
                             THEN '1' + CAST(Preferred_Name__c AS VARCHAR(50))
                        END) Preferred_Name__c ,

						  
						  MAX(CASE WHEN dta.xtype = 'Winning'
                                  AND [Description]	 IS NOT NULL AND [Description] != ''
                             THEN '2' + CAST([Description]	 AS VARCHAR(MAX))
                             WHEN dta.xtype = 'Losing'
                                  AND [Description]	 IS NOT NULL AND [Description] != ''
                             THEN '1' + CAST([Description]	AS VARCHAR(MAX))
                        END) [Description],

												  
						  MAX(CASE WHEN dta.xtype = 'Winning'
                                  AND [Reasons_Why_Bought__c]	 IS NOT NULL AND [Reasons_Why_Bought__c] != ''
                             THEN '2' + CAST([Reasons_Why_Bought__c]	 AS VARCHAR(255))
                             WHEN dta.xtype = 'Losing'
                                  AND [Reasons_Why_Bought__c]	 IS NOT NULL AND [Reasons_Why_Bought__c] != ''
                             THEN '1' + CAST([Reasons_Why_Bought__c]	AS VARCHAR(255))
                        END) [Reasons_Why_Bought__c]
						                    
FROM      ( SELECT    *
            FROM      ( SELECT    'Winning' xtype ,
                                a.Winning_ID ,
								a.Losing_ID ,					
                                b.*
                        FROM      [MERGEPROCESS_New].[Queue] a
                                JOIN Prodcopy.vw_Account b ON a.Winning_ID = b.ID
--								WHERE a.FK_MergeID IN ('5163',
--'11309',
--'1701')
                        UNION ALL
                        SELECT    'Losing' xtype ,
                                a.Winning_ID ,
								a.Losing_ID ,					
                                b.*
                        FROM      [MERGEPROCESS_New].[Queue] a
                                JOIN Prodcopy.vw_Account b ON a.Losing_ID = b.ID
--								WHERE a.FK_MergeID IN ('5163',
--'11309',
--'1701')
                    ) x
        ) dta

GROUP BY  Winning_ID ,
		Losing_ID					
        ) aa
		
;





GO
