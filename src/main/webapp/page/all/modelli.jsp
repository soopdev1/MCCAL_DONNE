<%-- 
    Document   : modelli
    Created on : 2-mar-2020, 12.41.15
    Author     : rcosco
--%>
<%@page import="rc.soop.db.Action"%>
<%@page import="rc.soop.domain.Cloud"%>
<%@page import="java.util.List"%>
<%@page import="rc.soop.db.Entity"%>
<% Entity e = new Entity();
    List<Cloud> clouds = e.findAll(Cloud.class);
    e.close();
%>
<div class="row">
    <%for (Cloud c : clouds) {
            if (Action.isModifiable(c.getVisible(), String.valueOf(us.getTipo()))) {%>
    <div class='col-xl-3 col-lg-6 col-md-6 col-sm-12 form-group'>
        <div class='row'>
            <div class='col-4 paddig_0_r' data-container="body" data-html="true" data-toggle="kt-tooltip" title="Visualizza documento" style="text-align: center;">
                <input type="hidden" value="<%=request.getContextPath()%>/redirect.jsp?page=OperazioniGeneral&type=showDoc&path=<%=c.getPath().replaceAll("\\\\", "/")%>">
                <a href='javascript:void(0);' class='btn-icon kt-font-io document'>
                    <i class='fa fa-file-pdf' style='font-size: 100px;'></i>
                </a>
            </div>
            <div class='col-1 paddig_0_l' style='text-align: left;'>
                <input type="hidden" value="<%=request.getContextPath()%>/OperazioniGeneral?type=downloadDoc&path=<%=c.getPath().replaceAll("\\\\", "/")%>">
                <a class="btn btn-icon btn-sm btn-io-n download" href="javascript:void(0);" onclick="" data-container="body" data-html="true" data-toggle="kt-tooltip" title="Scarica documento">
                    <i class="fa fa-arrow-down"></i>
                </a>
            </div>
        </div>
        <div class='row'>
            <h5 class='kt-font-io-n'><%=c.getNome().replaceAll("_", " ")%></h5>
        </div>
    </div>
    <%}}%>
</div>
<script>
    $("a.document").click(function (e) {
        var input = $($($(this).parent()[0]).find('input')[0]);
        clickLink(input.val(), "_blank");
    });
    $("a.download").click(function (e) {
        var input = $($($(this).parent()[0]).find('input')[0]);
        clickLink(input.val(), "");
    });
    function clickLink(link, target) {
        var a = document.createElement('a');
        a.href = link;
        a.target = target;
        document.body.appendChild(a);
        a.click();
        a.remove();
    }
</script>