
/* 
Description: Adjusted EBITDA detail
------------------------------------------------------------------------------------
Required edits:
- You must review your chart of accounts and class list to understand your own 
requirements. The example below uses a mix of class names and account names to 
determine the EBITDA report category. This example also removes EBITDA add-backs,
hence Adjusted EBITDA. This assumes ALL transaction lines that are add-backs 
were assigned the class "Add-Backs"
- You must determine the internal ID of the subsidiary you will consolidate to;
In this example it is 1. [cer.tosubsidiary = 1]
- If you use multi-book accounting, you must determine the internal ID of the
accounting book used for consolidation; In this example it is 1. [cer.accountingbook = 1]
------------------------------------------------------------------------------------
Notes:
- The big 'case when' statement MUST be edited for your personal company's setup. 
If you need help, please reach out.
 */

WITH ebitda AS (
    SELECT
        ap.enddate AS period,
        CASE
            WHEN accttype = 'Income' THEN CASE
                WHEN c.fullname LIKE 'Services%' THEN 'Services'
                ELSE 'Product' END
            WHEN accttype = 'COGS' THEN CASE 
                WHEN c.fullname LIKE 'Equipment%' THEN 'Equipment'
                WHEN a.fullname = 'Cost of Goods Sold' THEN 'Product'
                ELSE 'Payroll' END
            WHEN accttype = 'Expense' THEN CASE
                WHEN a.fullname LIKE 'Commissions%' THEN 'Commissions'
                WHEN a.fullname LIKE 'Marketing%' THEN 'Marketing'
                WHEN a.fullname LIKE 'Events%' THEN 'Events'
                WHEN a.fullname LIKE 'Payroll%' THEN 'Payroll'
                WHEN a.fullname LIKE 'Sales Tax%' THEN 'Sales Tax'
                WHEN a.fullname LIKE 'Depreciation%' THEN 'Depreciation'
                WHEN a.fullname LIKE 'Amortization%' THEN 'Amortization'
                WHEN a.fullname LIKE 'Shareholder%' THEN 'Shareholder'
                ELSE 'Other Operating Expenses' END
            ELSE '--Account not mapped--'
        END AS category,
        a.acctnumber,
        a.fullName AS account,
        s.name AS subsidiary,
        c.fullname AS class,
        t.tranid,
        (-tal.amount * cer.averagerate) AS amount

    FROM transaction t
        LEFT JOIN transactionline tl ON tl.transaction = t.id
        LEFT JOIN transactionaccountingline tal ON tal.transaction = t.id AND tal.transactionline = tl.id
        LEFT JOIN account a ON a.id = tal.account
        LEFT JOIN item i ON i.id = tl.item
        LEFT JOIN classification c ON c.id = tl.class
        LEFT JOIN subsidiary s ON s.id = tl.subsidiary
        LEFT JOIN accountingperiod ap ON ap.id = t.postingperiod
        LEFT JOIN consolidatedexchangerate cer ON cer.postingperiod = ap.id AND cer.fromsubsidiary = s.id AND cer.tosubsidiary = 1 AND cer.accountingbook = 1

    WHERE 
        t.posting = 'T'
        AND a.accttype IN ('Income','COGS','Expense') -- Assumes Other Income/Expenses are non-EBITDA
        AND tal.amount != 0
        AND (c.name != 'Add-Backs' OR c.name IS NULL) -- NULLs not included if an expression is used
        AND ap.startdate >= '1/1/2024'
        AND ap.enddate <= '12/31/2024'
)

SELECT *
FROM ebitda
WHERE category NOT IN ('Depreciation', 'Amortization', 'Sales Tax', 'Shareholder')
ORDER BY period, acctnumber, class, subsidiary