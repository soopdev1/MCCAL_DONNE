<%-- 
    Document   : updoladRegistri
    Created on : 4-feb-2020, 15.55.22
    Author     : rcosco
--%>


<%@page import="rc.soop.util.Utility"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="org.apache.commons.lang3.StringEscapeUtils"%>
<%@page import="rc.soop.domain.Documenti_Allievi"%>
<%@page import="rc.soop.domain.TipoDoc_Allievi"%>
<%@page import="rc.soop.domain.Allievi"%>
<%@page import="java.text.SimpleDateFormat"%>
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
        String uri_ = request.getRequestURI();
        String pageName_ = uri_.substring(uri_.lastIndexOf("/") + 1);
        if (!Action.isVisibile(String.valueOf(us.getTipo()), pageName_)) {
            response.sendRedirect(request.getContextPath() + "/page_403.jsp");
        } else {
            String src = session.getAttribute("src").toString();
            Entity e = new Entity();
            String guida_SA = e.getPath("guida_SA");
            int max_ore_day = Integer.parseInt(e.getPath("max_ore_day"));
            Allievi a = e.getEm().find(Allievi.class, Long.parseLong(request.getParameter("id")));
            List<TipoDoc_Allievi> tipo_doc_obbl = e.getTipoDocAllievi(a.getProgetto().getStato());
            List<Documenti_Allievi> docs = e.getDocAllievo(a);
//            List<Documenti_Allievi> registri = docs.stream()
//                    .filter(d -> d.getGiorno() != null && Action.isModifiable(d.getTipo().getModifiche_stati(), a.getProgetto().getStato().getId()))
//                    .collect(Collectors.toList());//prendo solo i registri
            List<Documenti_Allievi> registri = new ArrayList<>();

            for (Documenti_Allievi d : docs) {
                if (d.getGiorno() != null && Action.isModifiable(d.getTipo().getModifiche_stati(), a.getProgetto().getStato().getId())) {//prendo solo i registri
                    registri.add(d);
                }
            }

            e.close();
            docs.removeAll(registri);
            Long id_se;
            String idea, protocollo;
%>
<html>
    <head>

        <meta charset="utf-8" />
        <title><%=Utility.titlepro%></title>
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
        <!--This page-->
        <link href="<%=src%>/assets/vendors/general/select2/dist/css/select2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-select/dist/css/bootstrap-select.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/css/bootstrap-datepicker3.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-timepicker/css/bootstrap-timepicker.css" rel="stylesheet" type="text/css" />
        <!--this page-->
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



    </head>
    <body class="kt-header--fixed kt-header-mobile--fixed kt-subheader--fixed kt-subheader--enabled kt-subheader--solid kt-aside--enabled kt-aside--fixed">
        <div class="kt-grid kt-grid--hor kt-grid--root">
            <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--ver kt-page">
                <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor">
                    <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor">
                        <div class="kt-content  kt-grid__item kt-grid__item--fluid" id="kt_content">
                            <div class="kt-portlet kt-portlet--mobile">
                                <div class="kt-portlet__head">
                                    <div class="kt-portlet__head-label">
                                        <h3 class="kt-portlet__head-title">
                                            Documenti e Registri
                                        </h3>
                                    </div>
                                </div>
                                <div class="kt-portlet__body">
                                    <h4 class='kt-font-io'>Documenti:</h4>
                                    <div class="kt-separator kt-separator--border kt-separator--space-md" style="margin-top: 0px;"></div>
                                    <div class="row">
                                        <%for (Documenti_Allievi d : docs) {
                                                if (Action.isModifiable(d.getTipo().getModifiche_stati(), a.getProgetto().getStato().getId()) && d.getTipo().getId() != 5) {
                                                    if (d.getTipo().getObbligatorio() == 1) {//rimuovo solo se obbligatorio
                                                        tipo_doc_obbl.remove(d.getTipo());
                                                    }
                                                    id_se = a.getSelfiemployement() != null ? a.getSelfiemployement().getId() : 0;
                                                    idea = a.getIdea_impresa() != null ? StringEscapeUtils.escapeEcmaScript(a.getIdea_impresa()) : "";
                                                    protocollo = a.getProtocollo() != null ? StringEscapeUtils.escapeEcmaScript(a.getProtocollo()) : "";
                                        %>
                                        <div class='col-lg-2 col-md-4 col-sm-6'>
                                            <div class='row'>
                                                <div class='col-6 paddig_0_r' data-container="body" data-html="true" data-toggle="kt-tooltip" title="Visualizza documento" style="text-align: center;">
                                                    <a target='_blank' href='<%=request.getContextPath()%>/OperazioniGeneral?type=showDoc&path=<%=d.getPath()%>' class='btn-icon kt-font-io document'>
                                                        <i class='fa fa-file-pdf' style='font-size: 100px;'></i>
                                                    </a>
                                                </div>
                                                <div class='col-6 paddig_0_l' style="text-align: left;">
                                                    <a class="btn btn-icon btn-sm btn-io-n" href="javascript:void(0);" onclick="changeDocs(<%=d.getId()%>,<%=id_se%>, '<%=idea%>', '<%=protocollo%>',<%=d.getTipo().getId()%>, '<%=d.getTipo().getEstensione().getEstensione().replaceAll("\"", "&quot;")%>', '<%=d.getTipo().getEstensione().getMime_type()%>');" data-container="body" data-html="true" data-toggle="kt-tooltip" title="Modifica documento">
                                                        <i class="fa fa-exchange-alt"></i>
                                                    </a>
                                                </div>
                                                <div class='offset-1 row'>
                                                    <%String docente_nome = d.getDocente() != null ? d.getDocente().getCognome() + " " + d.getDocente().getNome() : "";%>
                                                    <%String scadenza = d.getScadenza() != null ? "<br>scad. " + new SimpleDateFormat("dd/MM/yyyy").format(d.getScadenza()) : "";%>
                                                    <h5 class='kt-font-io-n'><%=d.getTipo().getDescrizione()%> <%=docente_nome + scadenza%></h5>
                                                </div>
                                            </div>
                                        </div>
                                        <%}
                                            }%>
                                    </div>
                                    <%
                                        if (!registri.isEmpty()) {
                                            double totale = 0;
                                            for (Documenti_Allievi registro : registri) {
                                                if (registro.getTipo().getId() == 5 && registro.getDeleted() == 0) {
                                                    double hh = (double) registro.getOrarioend_mattina().getTime() - registro.getOrariostart_mattina().getTime();
                                                    if (registro.getOrariostart_pom() != null && registro.getOrarioend_pom() != null) {
                                                        hh += (double) registro.getOrarioend_pom().getTime() - registro.getOrariostart_pom().getTime();
                                                    }
                                                    totale += hh / 3600000;
                                                }
                                            }
                                    %>
                                    <div class="row" style="padding-top: 20px;">
                                        <h4 class="kt-font-io col-6">Registri:</h4><h4 class="kt-font-io col-6 kt-align-right">Totale ore effettuate: <b><%=totale%></b></h4>
                                    </div>
                                    <div class="kt-separator kt-separator--border kt-separator--space-md" style="margin-top: 0px;"></div>
                                    <div class="row">
                                        <%for (Documenti_Allievi d : registri) {
                                                if (Action.isModifiable(d.getTipo().getModifiche_stati(), a.getProgetto().getStato().getId()) && d.getTipo().getId() == 5) {
                                                    if (d.getTipo().getObbligatorio() == 1) {//rimuovo solo se obbligatorio
                                                        tipo_doc_obbl.remove(d.getTipo());
                                                    }%>
                                        <div class='col-lg-2 col-md-4 col-sm-6'>
                                            <div class='row'>
                                                <div class='col-6 paddig_0_r' style="text-align: center;">
                                                    <a class='btn-icon kt-font-io document'>
                                                        <i class='fa fa-clipboard-list' style='font-size: 100px;'></i>
                                                    </a>
                                                </div>
                                                <div class='col-6 paddig_0_l' style="text-align: left;">
                                                    <a class="btn btn-icon btn-sm btn-io-n" href="javascript:void(0);" onclick="changeRegistro(<%=d.getAllievo().getId()%>,<%=d.getId()%>,<%=a.getProgetto().getId()%>,<%=totale%>);" data-container="body" data-html="true" data-toggle="kt-tooltip" title="Modifica registro">
                                                        <i class="fa fa-exchange-alt"></i>
                                                    </a>
                                                </div>
                                                <div class='offset-1 row'>
                                                    <%
                                                        double ore = (double) d.getOrarioend_mattina().getTime() - d.getOrariostart_mattina().getTime();
                                                        if (d.getOrariostart_pom() != null && d.getOrarioend_pom() != null) {
                                                            ore += (double) d.getOrarioend_pom().getTime() - d.getOrariostart_pom().getTime();
                                                        }%>
                                                    <%String data = d.getGiorno() != null ? "<br>del " + new SimpleDateFormat("dd/MM/yyyy").format(d.getGiorno()) : "";%>
                                                    <h5 class='kt-font-io-n'><%=d.getTipo().getDescrizione()%> <%=data + "<br> Ore lezione " + (ore / 3600000)%></h5>
                                                </div>
                                            </div>
                                        </div>
                                        <%}
                                                }
                                            }%>
                                    </div>
                                    <%if (!tipo_doc_obbl.isEmpty()) {%>
                                    <br>
                                    <h4 class='kt-font-io'>Carica Documento:</h4>
                                    <div class="kt-separator kt-separator--border kt-separator--space-xs"></div>
                                    <div class="row">
                                        <%for (TipoDoc_Allievi t : tipo_doc_obbl) {
                                                if (t.getId() != 5) {%>
                                        <div class='col-lg-2 col-md-4 col-sm-6'>
                                            <div class='row'>
                                                <div class='col-6 paddig_0_r' style="text-align: center;">
                                                    <a href='javascript:void(0);' onclick="uploadDocs(<%=a.getId()%>,<%=t.getId()%>, '<%=t.getEstensione().getEstensione().replaceAll("\"", "&quot;")%>', '<%=t.getEstensione().getMime_type()%>');" class='btn-icon kt-font-warning document'>
                                                        <i class='fa fa-file-upload' style='font-size: 100px;'></i>
                                                    </a>
                                                </div>

                                                <div class='col-6 paddig_0_l' style="text-align: left;">
                                                    <%=t.getObbligatorio() == 1 ? "<label class='kt-font-danger kt-font-boldest' style='font-size: 30px;text-align:left;'>*</label>" : ""%>
                                                </div>
                                                <div class='offset-1 row'>
                                                    <h5 class='kt-font-io'>Carica <%=t.getDescrizione()%></h5>
                                                </div>
                                            </div>
                                        </div>
                                        <%}
                                            }%>
                                    </div>
                                    <label class="kt-font-danger kt-font-bold"><font size="2" >* Documenti Obbligatori</font></label>
                                        <%}%>
                                </div>
                            </div>
                        </div>
                    </div>	
                </div>
            </div>
        </div>
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
        <script src="<%=src%>/assets/vendors/general/select2/dist/js/select2.full.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/select2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/js/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/bootstrap-timepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-timepicker/js/bootstrap-timepicker.js" type="text/javascript"></script>
        <script id="ore_max" data-context="<%=max_ore_day%>" type="text/javascript"></script>
        <script id="uploadRegistri" src="<%=src%>/page/sa/js/uploadRegistri.js<%="?dummy=" + String.valueOf(new Date().getTime())%>" 
                data-context="<%=request.getContextPath()%>" 
        data-start-fb=<%=(a.getProgetto().getEnd_fa() != null ? a.getProgetto().getEnd_fa().getTime() : 0)%> type="text/javascript"></script>
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
<%}
    }%>