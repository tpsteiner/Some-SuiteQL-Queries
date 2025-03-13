/*
Description:
Get a list of intercompany transactions, assuming all GL accounts have 'Intercompany' in the name.
Includes To/From subsidiary info for Advanced Intercompany Journal Entries.
------------------------------------------------------------------------------------
Oracle docs:
- "The first line of this journal entry must post to the Subsidiary you select"
- "By default, the Currency field displays the base currency of the subsidiary selected in the 
   Subsidiary field. You can change this value to any currency set up in your system"
------------------------------------------------------------------------------------
Notes:

 */

WITH interco_transactions AS (
    SELECT DISTINCT
        tal.transaction
    FROM transactionaccountingline tal
        LEFT JOIN account a ON a.id = tal.account
        LEFT JOIN transaction t ON t.id = tal.transaction
    WHERE
        t.posting = 'T'
        AND tal.amount != 0
        AND a.fullname LIKE '%Intercompany%'
        AND t.trandate >= '1/1/2024'
        AND t.trandate <= '12/31/2024'
),

mainline_subsidiary AS (
    SELECT
        it.transaction,
        s.id AS subsidiary
    FROM interco_transactions it
        LEFT JOIN transactionline tl ON tl.transaction = it.transaction
        INNER JOIN subsidiary s ON s.id = tl.subsidiary AND tl.lineSequenceNumber = 0
)

SELECT
    ap.enddate AS period,
    t.tranid,
    t.recordtype,
    at.longname,
    a.acctnumber,
    a.accountsearchdisplaynamecopy AS account,
    CASE WHEN a.fullname LIKE '%Intercompany%' THEN 'Yes' ELSE 'No' END AS isintercoaccount,
    ts.name AS transubsidiary,
    ls.name AS linesubsidiary,
    COALESCE(rsc.name, rsv.name) AS representingsubsidiary,
    lc.symbol AS linecurrency,
    tal.amount AS localamount,
    tal.exchangeRate,
    tc.symbol AS trancurrency,
    ROUND(tal.amount / tal.exchangeRate, 2) AS amount

FROM mainline_subsidiary ms
    LEFT JOIN transaction t ON t.id = ms.transaction
    LEFT JOIN transactionline tl ON tl.transaction = t.id
    LEFT JOIN transactionaccountingline tal ON tal.transaction = t.id AND tal.transactionline = tl.id
    LEFT JOIN account a ON a.id = tal.account
    LEFT JOIN accounttype at ON at.id = a.accttype
    LEFT JOIN subsidiary ts ON ts.id = ms.subsidiary
    LEFT JOIN subsidiary ls ON ls.id = tl.subsidiary
    LEFT JOIN accountingperiod ap ON ap.id = t.postingperiod
    LEFT JOIN customer c ON c.id = tl.entity
    LEFT JOIN subsidiary rsc ON rsc.id = c.representingsubsidiary
    LEFT JOIN vendor v ON v.id = tl.entity
    LEFT JOIN subsidiary rsv ON rsv.id = v.representingsubsidiary
    LEFT JOIN currency tc ON tc.id = t.currency
    LEFT JOIN currency lc ON lc.id = ls.currency

ORDER BY
    ap.enddate,
    t.tranid,
    ls.id,
    at.internalid