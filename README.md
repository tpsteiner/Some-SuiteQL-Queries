# Some SuiteQL Queries
Useful queries that I re-use as a NetSuite independent contractor. Mostly standard netsuite tables and common addon tables.

# How to use
Most of the SuiteQL queries above use CTEs, and thus require the **N/query** Suitescript module. 

I should plug here that I work with a group of experts at **Prolecto Resources**. We provide great tools for working with queries, but even better, we've got a strong team of nerdy CPAs that can work through your business problems with you. We offer a Query Renderer that adds a lot more utility to the output of queries, as well as a lightweight IDE for querying within your netsuite instance. Reach out on LinkedIn if you want to talk.

If you have admin privileges and a bit of gumption, here are some free options:
- Tim Dietrich's SuiteQL Query Tool
- Tim's SuiteAPI Suitescript

If you've paid Oracle for Suiteanalytics **Connect Services** (ODBC, JDBC, ADO.NET), use your favorite LLM (ChatGPT/Gemini/Claude) to convert the query to be compliant. "Act as a CPA and data engineer who is an expert at writing netsuite SuiteQL queries. The query below is not compliant with OpenAccess SDK, which is required to run with an ODBC driver. Rewrite the script so that it is compiant with SQL-92, Oracle SQL, and OpenAccess SDK. [paste query]"

# Common gotchas and other good stuff
- N/query and Connect Services support ANSI SQL-92 syntax or Oracle SQL 12c, but not both in the same query. Connect Services have the additional requirement of being compliant with some unknown version of the OpenAccess SDK. If you're trying to learn how to query netsuite, this is the first thing to study imo.
- SuiteQL row limit in N/query is 1 million rows if you have the ODBC module & 100,000 rows if you do not. ODBC is unlimited.
- SuiteQL in N/query will timeout after 15 minutes. Make queries more efficient. Run in batches. Consider a data warehouse. 
- Connect Services can use the old netsuite data source (netsuite.com) or the new netsuite data source (netsuite2.com AKA Analytics data source). However update netsuite instance 2026.1 will remove the old data source. You should use the new one.
- Is data missing from your query results? Run as admin.
- BUILTIN.DF() is great for quick analysis. It takes barely any extra time to add the whole table via join, which allows you to add more columns quicker and helps you learn where everything is.
- The Excel ODBC driver is great. Definitely worth it if you want to automate within Excel via Power Query, or in your favorite language that can connect to an ODBC driver. I've used it to automate Excel financial statements that update on workbook open. However the functionality is much more limited than N/query. Maybe Oracle will improve this someday.
- NetSuite --> Setup --> Records Browser
- If these tidbits helped you, let me know so I can feel all happy inside for a couple minutes.

# Great resources for learning NetSuite
https://docs.oracle.com/en/cloud/saas/netsuite/ns-online-help/

https://www.reddit.com/user/Nick_AxeusConsulting/

https://timdietrich.me/blog/

https://blog.prolecto.com/

https://meir.prolecto.com/category/articles/

# Useful Chrome Addons
https://chromewebstore.google.com/detail/netsuite-field-explorer/cekalaapeajnlhphgdpmngmollojdfnd

https://chromewebstore.google.com/detail/netsuite-utils/jdecachbikbkppkpjjgdmdghgdfffibi

https://chromewebstore.google.com/detail/netsuite-field-finder/npehdolgmmdncpmkoploaeljhkngjbne

https://chromewebstore.google.com/detail/netsuite-saved-search-and/gglbgdfbkaelbjpjkiepdmfaihdokglp