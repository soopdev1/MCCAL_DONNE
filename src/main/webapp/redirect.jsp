<%-- 
    Document   : redirect
    Created on : 17-giu-2019, 17.18.25
    Author     : rcosco
--%>

<%@page import="rc.soop.util.Utility"%>
<%@page import="java.util.Enumeration"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
    </head>
    <body>
        <form action="<%=request.getContextPath()%>/<%=request.getParameter("page")%>" method="post" name="form" id="form" accept-charset="ISO-8859-1" style="display: none">
            <%Enumeration<String> parameterNames = request.getParameterNames();
                while (parameterNames.hasMoreElements()) {
                    String paramName = parameterNames.nextElement();
                    String[] paramValues = request.getParameterValues(paramName);
                    if (!paramName.equals("page")) {
                        for (int i = 0; i < paramValues.length; i++) {;%>
            <input name="<%=paramName%>" value="<%=paramValues[i]%>">
            <%}
                    }
                }%>
        </form>
    </body>
    <script src="assets/vendors/general/jquery/dist/jquery.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            document.getElementById("form").submit();
        });
    </script>
</html>