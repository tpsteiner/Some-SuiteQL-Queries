/* 
Description: List all journal entries that impacted the GL after approval.
------------------------------------------------------------------------------------
Oracle docs:
- "Anyone with view access to a record and the List > Notes Tab permission can view the system notes for that record."
- "System notes are not copied from the production account to the sandbox."
------------------------------------------------------------------------------------
Notes:
- This runs slow. Run in small batches.
- GL Impact always happens after approval of the record, usually in the same second, often one second later.
- Getting system notes via ODBC is very difficult. Nick Horowitz posted the process on reddit I believe.
 */
 
WITH journal_entries AS (
    SELECT
        t.id AS journalentry,
        t.tranid
    FROM transaction t
    WHERE t.posting = 'T'
    AND t.recordtype = 'journalentry'
    AND t.trandate >= '1/1/2024'
    AND t.trandate <= '1/31/2024'
),

notes AS (
    SELECT
        j.journalentry,
        j.tranid,
        TO_CHAR(sn.date, 'YYYY-MM-DD HH24:MI') AS changedate,
        sn.field,
        sn.oldvalue,
        sn.newvalue
    FROM journal_entries j
    LEFT JOIN systemnote sn ON sn.recordid = j.journalentry
    WHERE sn.field IN ('TRANDOC.KSTATUS','TRANDOC.IMPACT')
    ORDER BY j.journalentry, TO_CHAR(sn.date, 'YYYY-MM-DD HH24:MI:SS')
),

latest_changes AS (
    SELECT
        notes.journalentry,
        notes.tranid,
        MAX(CASE WHEN notes.field = 'TRANDOC.IMPACT' THEN notes.changedate END) AS impact_changedate,
        MAX(CASE WHEN notes.field = 'TRANDOC.KSTATUS' THEN notes.changedate END) AS status_changedate
    FROM notes
    GROUP BY notes.journalentry, notes.tranid
)

SELECT *
FROM latest_changes lc
WHERE lc.impact_changedate > lc.status_changedate
ORDER BY journalentry