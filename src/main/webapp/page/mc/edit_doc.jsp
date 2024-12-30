<%-- 
    Document   : uploadDocumet
    Created on : 29-gen-2020, 12.39.45
    Author     : rcosco
--%>

<%@page import="rc.soop.domain.Documenti_Allievi"%>
<%@page import="rc.soop.domain.Allievi"%>
<%@page import="rc.soop.entity.FadCalendar"%>
<%@page import="java.util.Date"%>
<%@page import="rc.soop.util.Utility"%>
<%@page import="org.apache.commons.lang3.StringEscapeUtils"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="rc.soop.domain.DocumentiPrg"%>
<%@page import="rc.soop.domain.TipoDoc"%>
<%@page import="java.util.List"%>
<%@page import="rc.soop.domain.StatiPrg"%>
<%@page import="rc.soop.domain.ProgettiFormativi"%>
<%@page import="rc.soop.db.Entity"%>
<%@page import="rc.soop.db.Action"%>
<%@page import="rc.soop.domain.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User us = (User) session.getAttribute("user");
    if (us == null) {
    } else {

        String src = session.getAttribute("src").toString();
        Entity e = new Entity();
        String idpr = request.getParameter("id") == null ? "" : request.getParameter("id");
        ProgettiFormativi p = e.getEm().find(ProgettiFormativi.class, Long.parseLong(idpr));
        String usersupdate = e.getPath("users.update");
        
        if(usersupdate==null || usersupdate.equals("null")|| usersupdate.contains(us.getUsername())){
%>
<html>
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%> - Sostituisci DOC</title>
        <meta name="description" content="Updates and statistics">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <script src="<%=src%>/resource/webfont.js"></script>
        <script>
            WebFont.load({
                google: {
                    "families": ["Poppins:300,400,500,600,700", "Roboto:300,400,500,600,700"]
                },
                active: function () {
                    sessionStorage.fonts = true;
                }
            });
        </script>
        <link href="<%=src%>/assets/vendors/general/select2/dist/css/select2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/owl.carousel/dist/assets/owl.carousel.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/owl.carousel/dist/assets/owl.theme.default.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/socicon/css/socicon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/line-awesome/css/line-awesome.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/flaticon/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/flaticon2/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/fontawesome5/css/all.min.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/base/style.bundle.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/resource/custom.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/header/base/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/brand/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/aside/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/resource/animate.css" rel="stylesheet" type="text/css"/>
        <link rel="shortcut icon" href="<%=src%>/assets/media/logos/favicon.ico" />
        <!--this page-->
        <link href="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/css/bootstrap-datepicker3.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-timepicker/css/bootstrap-timepicker.css" rel="stylesheet" type="text/css" />
        <!--fancy-->
        <link href="<%=src%>/assets/soop/css/jquery.fancybox.css" rel="stylesheet" type="text/css"/>
        <script type="text/javascript" src="<%=src%>/assets/soop/js/jquery-1.10.1.min.js"></script>
        <script type="text/javascript" src="<%=src%>/assets/soop/js/jquery.fancybox.js?v=2.1.5"></script>
        <script type="text/javascript" src="<%=src%>/assets/soop/js/fancy.js"></script>
    </head>
    <body class="kt-header--fixed kt-header-mobile--fixed kt-subheader--fixed kt-subheader--enabled kt-subheader--solid kt-aside--enabled kt-aside--fixed">

        <%if (p != null) {

                List<DocumentiPrg> elencodocumentiprogetto = p.getDocumenti();
                elencodocumentiprogetto = Utility.orderList(elencodocumentiprogetto, "DocumentiPrg");
                List<Allievi> elencoallievi = p.getAllievi();
                elencoallievi = Utility.orderList(elencoallievi, "Allievi");

        %>


        <div class="kt-grid kt-grid--hor kt-grid--root">
            <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--ver kt-page">
                <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor">
                    <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor">
                        <div class="kt-content  kt-grid__item kt-grid__item--fluid" id="kt_content">
                            <div class="kt-portlet kt-portlet--mobile">
                                <div class="kt-portlet__head">
                                    <div class="kt-portlet__head-label">
                                        <h3 class="kt-portlet__head-title">
                                            Progetto Formativo ID <%=p.getId()%> - Soggetto Attuatore <%=p.getSoggetto().getRagionesociale()%> - Sostituisci Documenti Progetto
                                        </h3>
                                    </div>
                                </div>
                                <div class="kt-portlet__body">
                                    <%if (!elencodocumentiprogetto.isEmpty()) {%>
                                    <div class="kt-portlet__body paddig_0_t paddig_0_b">
                                        <div class="kt-section kt-section--first">
                                            <h4 class="kt-portlet__head-title">
                                                DOCUMENTI PROGETTUALI
                                            </h4>
                                            <div class="kt-section__body">
                                                <div class="table-responsive">
                                                    <table class="table">
                                                        <thead>
                                                            <tr>
                                                                <th scope="col">ID</th>
                                                                <th scope="col">TIPO DOCUMENTO</th>
                                                                <th scope="col"></th>
                                                                <th scope="col"></th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <%
                                                                for (DocumentiPrg lez : elencodocumentiprogetto) {
                                                                    if (lez.getDeleted() == 0 && lez.getPath() != null) {

                                                                        String docente = lez.getDocente() == null ? ""
                                                                                : "DOCENTE: " + lez.getDocente().getCognome() + " " + lez.getDocente().getNome();
                                                                        String scadenza = lez.getScadenza() == null ? ""
                                                                                : " - SCADENZA: " + Utility.sdita.format(lez.getScadenza());

                                                                        String descr = lez.getTipo().getDescrizione() + " " + docente + " " + scadenza;

                                                            %>

                                                            <tr>
                                                                <th scope="row"><%=lez.getId()%></th>
                                                                <td scope="row"><%=descr.toUpperCase().trim()%></td>
                                                                <td scope="row"><%
                                                                    if (lez.getTipo().getId().equals(30L)) { //REPORT FAD TEMP%>
                                                                        <button type="button" class="btn btn-sm btn-outline-danger"
                                                                                onclick="return rigenera_report('<%=idpr%>');">
                                                                        
                                                                            <i class="fa fa-edit"></i> RIGENERA
                                                                        </button>                                                                    
                                                                    <%}
                                                                    %>
                                                                </td>
                                                                <td>
                                                                    <button type="button" class="btn btn-sm btn-outline-success" onclick="return document.getElementById('DOCPR_D_<%=lez.getId()%>').submit()">
                                                                        <i class="fa fa-download"></i> SCARICA
                                                                    </button>
                                                                    <button type="button" class="btn btn-sm btn-outline-info" 
                                                                            onclick="return sost_docprg('<%=lez.getId()%>', '<%=lez.getTipo().getEstensione().getId()%>', '<%=lez.getTipo().getEstensione().getMime_type()%>', 1);">
                                                                        <i class="fa fa-upload"></i> SOSTITUISCI
                                                                    </button>
                                                                    <form action="<%=src%>/OperazioniGeneral" method="post" target="_blank" id="DOCPR_D_<%=lez.getId()%>">
                                                                        <input type="hidden" name="type" value="showDoc" />
                                                                        <input type="hidden" name="path" value="<%=lez.getPath()%>" />
                                                                    </form>
                                                                </td>
                                                            </tr>

                                                            <%}
                                                                }%>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <%}%>
                                    <div class="col"><hr></div>
                                        <%if (!p.getAllievi().isEmpty()) {%>
                                    <div class="kt-portlet__body paddig_0_t paddig_0_b">
                                        <div class="kt-section kt-section--first">
                                            <h4 class="kt-portlet__head-title">
                                                DOCUMENTI ALLIEVI
                                            </h4>
                                            <div class="kt-section__body">
                                                <div class="table-responsive">
                                                    <table class="table">
                                                        <thead>
                                                            <tr>
                                                                <th scope="col">ID</th>
                                                                <th scope="col">ALLIEVO</th>
                                                                <th scope="col">TIPO DOCUMENTO</th>
                                                                <th scope="col"></th>
                                                            </tr>
                                                        </thead>

                                                        <%
                                                            for (Allievi a1 : elencoallievi) {
                                                            
                                                            %>
                                                            <tr>
                                                            <th scope="row">DR_<%=a1.getId()%></th>
                                                            <td scope="row"><%=a1.getCognome().toUpperCase().trim()%> <%=a1.getNome().toUpperCase().trim()%> (<%=a1.getCodicefiscale().toUpperCase().trim()%>)</td>
                                                            <td scope="row">DOCUMENTO DI RICONOSCIMENTO</td>
                                                            <td>
                                                                <button type="button" class="btn btn-sm btn-outline-success"
                                                                        onclick="return document.getElementById('DOCALL_RIC_<%=a1.getId()%>').submit()">
                                                                    <i class="fa fa-download"></i> Scarica
                                                                </button>
                                                                <button type="button" class="btn btn-sm btn-outline-info" 
                                                                        onclick="return sost_docprg('<%=a1.getId()%>', 'pdf', 'application/pdf', 3);">
                                                                    <i class="fa fa-upload"></i> Sostituisci
                                                                </button>
                                                                <form action="<%=src%>/OperazioniGeneral" method="post" target="_blank" id="DOCALL_RIC_<%=a1.getId()%>">
                                                                    <input type="hidden" name="type" value="showDoc" />
                                                                    <input type="hidden" name="path" value="<%=a1.getDocid()%>" />
                                                                </form>
                                                            </td>
                                                        </tr>
                                                            
                                                            <%
                                                                List<Documenti_Allievi> elencodocumentiallievo = a1.getDocumenti();
                                                                elencodocumentiallievo = Utility.orderList(elencodocumentiallievo, "Documenti_Allievi");
                                                                for (Documenti_Allievi lez : elencodocumentiallievo) {
                                                                    if (lez.getDeleted() == 0 && lez.getPath() != null) {
                                                                        String docente = lez.getDocente() == null ? ""
                                                                                : "DOCENTE: " + lez.getDocente().getCognome() + " " + lez.getDocente().getNome();
                                                                        String scadenza = lez.getScadenza() == null ? ""
                                                                                : " - SCADENZA: " + Utility.sdita.format(lez.getScadenza());
                                                                        String descr = lez.getTipo().getDescrizione() + " " + docente + " " + scadenza;
                                                        %>

                                                        <tr>
                                                            <th scope="row"><%=lez.getId()%></th>
                                                            <td scope="row"><%=lez.getAllievo().getCognome().toUpperCase().trim()%> <%=lez.getAllievo().getNome().toUpperCase().trim()%> (<%=lez.getAllievo().getCodicefiscale().toUpperCase().trim()%>)</td>
                                                            <td scope="row"><%=descr.toUpperCase().trim()%></td>
                                                            <td>
                                                                <button type="button" class="btn btn-sm btn-outline-success" onclick="return document.getElementById('DOCALL_D_<%=lez.getId()%>').submit()">
                                                                    <i class="fa fa-download"></i> Scarica
                                                                </button>
                                                                <button type="button" class="btn btn-sm btn-outline-info" onclick="return sost_docprg('<%=lez.getId()%>', '<%=lez.getTipo().getEstensione().getId()%>', '<%=lez.getTipo().getEstensione().getMime_type()%>', 2);">
                                                                    <i class="fa fa-upload"></i> Sostituisci
                                                                </button>
                                                                <form action="<%=src%>/OperazioniGeneral" method="post" target="_blank" id="DOCALL_D_<%=lez.getId()%>">
                                                                    <input type="hidden" name="type" value="showDoc" />
                                                                    <input type="hidden" name="path" value="<%=lez.getPath()%>" />
                                                                </form>
                                                            </td>
                                                        </tr>
                                                        <%}
                                                                }
                                                            }%>

                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <%}%>
                                    <!-- Button trigger modal -->
                                    <div class="modal fade"  tabindex="-1" role="dialog" aria-hidden="true">
                                        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#exampleModal" id="openmodalerror">
                                            Launch demo modal
                                        </button>
                                    </div>
                                    <!-- Modal -->
                                    <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                        <div class="modal-dialog" role="document">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title text-danger" id="exampleModalLabel"><i class="fa fa-exclamation-triangle"></i> ERRORE!</h5>
                                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                        <span aria-hidden="true">&times;</span>
                                                    </button>
                                                </div>
                                                <div class="modal-body" id="modalerrortxt">

                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>	
                </div>
            </div>
        </div>
        <%}%>
        <div id="kt_scrolltop" class="kt-scrolltop">
            <i class="fa fa-arrow-up"></i>
        </div>
        <script src="<%=src%>/assets/vendors/general/jquery/dist/jquery.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/popper.js/dist/umd/popper.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap/dist/js/bootstrap.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/js-cookie/src/js.cookie.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/moment/min/moment.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/tooltip.js/dist/umd/tooltip.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/perfect-scrollbar/dist/perfect-scrollbar.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/sticky-js/dist/sticky.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/demo/default/base/scripts.bundle.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/jquery-form/dist/jquery.form.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/jquery-validation/dist/jquery.validate.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/jquery-validation/dist/additional-methods.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/components/extended/blockui1.33.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/soop/js/utility.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/bundle/app.bundle.js" type="text/javascript"></script>
        <!--this page-->
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/bootstrap-timepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/js/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-timepicker/js/bootstrap-timepicker.js" type="text/javascript"></script>
        <script id="myFAQ" src="<%=src%>/page/mc/js/edit_doc.js" type="text/javascript" data-context="<%=request.getContextPath()%>"></script>

        <script type="text/javascript">
                                                                    var KTAppOptions = {
                                                                        "colors": {
                                                                            "state": {
                                                                                "brand": "#5d78ff",
                                                                                "dark": "#282a3c",
                                                                                "light": "#ffffff",
                                                                                "primary": "#5867dd",
                                                                                "success": "#34bfa3",
                                                                                "info": "#36a3f7",
                                                                                "warning": "#ffb822"
                                                                            },
                                                                            "base": {
                                                                                "label": ["#c5cbe3", "#a1a8c3", "#3d4465", "#3e4466"],
                                                                                "shape": ["#f0f3ff", "#d9dffa", "#afb4d4", "#646c9a"]
                                                                            }
                                                                        }
                                                                    };
        </script>
    </body>
</html>
<%
    }}%>