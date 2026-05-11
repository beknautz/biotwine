<!--- /admin/logout.cfm --->
<cfset session.btLoggedIn = false>
<cfset session.userID     = 0>
<cfset session.role       = "">
<cfset session.firstName  = "">
<cflocation url="/admin/login.cfm" addtoken="false">
