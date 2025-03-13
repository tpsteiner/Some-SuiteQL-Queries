# Some-SuiteQL-Queries
Useful queries that I re-use. Mostly standard tables or common addon tables.

# How to use
Most of the SuiteQL queries use CTEs, and thus require the N/query Suitescript module. 

I should plug here that I work with a group of experts at Prolecto Resources. We provide great tools for working with queries, but even better, we've got a strong team that can work through your problems with you. We offer a Query Renderer that adds a lot more utility to the output of queries, as well as a lightweight IDE for querying within your netsuite instance.

Some free options:
- Tim Dietrich's SuiteQL Query Tool
- Tim's SuiteAPI Suitescript

To use with Suiteanalytics Connect services (ODBC, JDBC, ADO.NET), use your favorite LLM (ChatGPT/Gemini/Claude) to convert the query to be compliant. "Act as a CPA and data engineer who is an expert in writing netsuite queries. The query below is not compliant with OpenAccess SDK. Rewrite the script so that it is compiant with SQL-92, Oracle SQL, and OpenAccess SDK. [paste query]"