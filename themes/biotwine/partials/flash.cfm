<cfif structKeyExists(session, "flash")>
  <cfoutput>
  <div class="alert alert-#session.flash.type# alert-dismissible" role="alert">
    #session.flash.message#
    <button type="button" class="btn-close" aria-label="Close">&times;</button>
  </div>
  </cfoutput>
  <cfset structDelete(session, "flash")>
</cfif>
