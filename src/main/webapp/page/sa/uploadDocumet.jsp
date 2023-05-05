<%-- 
    Document   : uploadDocumet
    Created on : 29-gen-2020, 12.39.45
    Author     : rcosco
--%>

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
        String uri_ = request.getRequestURI();
        String pageName_ = uri_.substring(uri_.lastIndexOf("/") + 1);
        if (!Action.isVisibile(String.valueOf(us.getTipo()), pageName_)) {
            response.sendRedirect(request.getContextPath() + "/page_403.jsp");
        } else {
            String src = session.getAttribute("src").toString();
            Entity e = new Entity();
            ProgettiFormativi p = e.getEm().find(ProgettiFormativi.class, Long.parseLong(request.getParameter("id")));
            List<TipoDoc> tipo_doc_obbl = e.getTipoDoc(p.getStato());
            List<DocumentiPrg> documeti = e.getDocPrg(p);
            List<DocumentiPrg> registri = new ArrayList<>();
            e.close();
            
            for(DocumentiPrg d : documeti){
                System.out.println(d.getGiorno()+" - "+d.getTipo().getModifiche_stati()+" -- "+p.getStato().getId()+" - - "+d.getValidate());
                if(d.getGiorno() != null && Action.isModifiable(d.getTipo().getModifiche_stati(), p.getStato().getId())){//prendo solo i registri
                    
                    registri.add(d);
                }
            }
            
            SimpleDateFormat sdf_day = new SimpleDateFormat("dd/MM/yyyy");
            
//            registri = documeti.stream()
//                    .filter(d -> d.getGiorno() != null && Action.isModifiable(d.getTipo().getModifiche_stati(), p.getStato().getId()))
//                    .collect(Collectors.toList());//prendo solo i registri
            documeti.removeAll(registri);
            
            Utility.sortDoc(documeti);

%>
<html>
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%> - Documenti</title>
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
        <!--fancy-->
        <link href="<%=src%>/assets/soop/css/jquery.fancybox.css" rel="stylesheet" type="text/css"/>
        <script type="text/javascript" src="<%=src%>/assets/soop/js/jquery-1.10.1.min.js"></script>
        <script type="text/javascript" src="<%=src%>/assets/soop/js/jquery.fancybox.js?v=2.1.5"></script>
        <script type="text/javascript" src="<%=src%>/assets/soop/js/fancy.js"></script>
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
                                            Carica Documenti:
                                        </h3>
                                    </div>
                                </div>
                                <div class="kt-portlet__body">
                                    <input type="hidden" id="id_progetto" value="<%=p.getId()%>">
                                    <h4 class='kt-font-io' style="padding-top: 20px;">Documenti Modificabili:</h4>
                                    <div class="kt-separator kt-separator--border kt-separator--space-xs"></div>
                                    <div class="row">
                                        <%String docente_nome, scadenza, giorno;
                                            for (DocumentiPrg d : documeti) {
                                                if (Action.isModifiable(d.getTipo().getModifiche_stati(), p.getStato().getId())) {//non sta facendo query
                                                    if (d.getTipo().getObbligatorio() == 1) {//rimuovo solo se obbligatorio
                                                        tipo_doc_obbl.remove(d.getTipo());
                                                    }
                                        %>
                                        <div class='col-lg-2 col-md-4 col-sm-6'>
                                            <div class='row'>
                                                <div class='col-6 paddig_0_r' data-container="body" data-html="true" data-toggle="kt-tooltip" title="Visualizza documento" style="text-align: center;">
                                                    <a target='_blank' href='<%=request.getContextPath()%>/OperazioniGeneral?type=showDoc&path=<%=d.getPath()%>' class='btn-icon kt-font-io document'>
                                                        <i class='fa fa-file-pdf' style='font-size: 100px;'></i>
                                                    </a>
                                                </div>
                                                <div class='col-6 paddig_0_l' style='text-align: left;'>
                                                    <a class="btn btn-icon btn-sm btn-io-n" href="javascript:void(0);" onclick="changeDoc(<%=d.getId()%>,<%=d.getScadenza() != null ? d.getScadenza().getTime() : null%>, '<%=d.getTipo().getEstensione().getEstensione().replaceAll("\"", "&quot;")%>', '<%=d.getTipo().getEstensione().getMime_type()%>');" data-container="body" data-html="true" data-toggle="kt-tooltip" title="Cambia documento">
                                                        <i class="fa fa-exchange-alt"></i>
                                                    </a>
                                                </div>
                                                <div class='offset-1 row'>
                                                    <%docente_nome = d.getDocente() != null ? d.getDocente().getCognome() + " " + d.getDocente().getNome() : "";%>
                                                    <%scadenza = d.getScadenza() != null ? "<br>scad. " + sdf_day.format(d.getScadenza()) : "";%>
                                                    <h5 class='kt-font-io-n'><%=d.getTipo().getDescrizione()%> <%=docente_nome + scadenza%></h5>
                                                </div>
                                            </div>
                                        </div>
                                        <% }
                                            }%>

                                    </div>

                                    <%if (!registri.isEmpty()) {%>
                                    <h4 class='kt-font-io' style="padding-top: 20px;">Registri:</h4><h5 class="kt-font-danger kt-font-boldest">*Se si dovesse avere la necessità di cambiare la data del registro, il registro errato dovrà essere eliminato e ricaricato in seguito</h5>
                                    <div class="kt-separator kt-separator--border kt-separator--space-xs"></div>
                                    <div class="row">
                                        <%for (DocumentiPrg d : registri) {%>
                                        <div class='col-lg-2 col-md-4 col-sm-6'>
                                            <div class='row'>
                                                <div class='col-6 paddig_0_r' style="text-align: center;">
                                                    <a class='btn-icon kt-font-io document'>
                                                        <i class='fa fa-clipboard-list' style='font-size: 100px;'></i>
                                                    </a>
                                                </div>
                                                <div class='col-6 paddig_0_l' style='text-align: left;'>
                                                    <a class="btn btn-icon btn-sm btn-io-n fancyBoxRafFull" href="modifyRegistroAula.jsp?id=<%=d.getId()%>" data-container="body" data-html="true" data-toggle="kt-tooltip" title="Modifica Registro">
                                                        <i class="fa fa-edit"></i>
                                                    </a><br>
                                                    <a class="btn btn-icon btn-sm btn-danger" href="javascript:void(0);" onclick="deleteRegister(<%=d.getId()%>, '<%=sdf_day.format(d.getGiorno())%>');" data-container="body" data-html="true" data-toggle="kt-tooltip" title="Elimina Registro" style="margin-top: 3px;">
                                                        <i class="fa fa-trash-alt"></i>
                                                    </a>
                                                </div>
                                                <div class='offset-1 row'>
                                                    <% docente_nome = d.getDocente() != null ? d.getDocente().getCognome() + " " + d.getDocente().getNome() : "";%>
                                                    <% giorno = d.getGiorno() != null ? "<br>del " + sdf_day.format(d.getGiorno()) + "<br> Docente: " : "";%>
                                                    <h5 class='kt-font-io-n'><%=d.getTipo().getDescrizione()%> <%=giorno + docente_nome%></h5>
                                                </div>
                                            </div>
                                        </div>
                                        <%}%>
                                    </div>
                                    <%}%>
                                    <%if (!tipo_doc_obbl.isEmpty()) {%>
                                    <br>
                                    <h4 class='kt-font-io' style="padding-top: 20px;">Documenti Da Caricare:</h4>
                                    <div class="kt-separator kt-separator--border kt-separator--space-xs"></div>
                                    <div class="row">
                                        <%for (TipoDoc t : tipo_doc_obbl) {%>
                                        <div class='col-lg-2 col-md-4 col-sm-6'>
                                            <div class='row'>
                                                <div class='col-6 paddig_0_r' style="text-align: center;">
                                                    <a href='javascript:void(0);' onclick="uploadDoc(<%=p.getId()%>,<%=t.getId()%>, '<%=t.getEstensione().getEstensione().replaceAll("\"", "&quot;")%>', '<%=t.getEstensione().getMime_type()%>');" class='btn-icon kt-font-warning document'>
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
                                        <%}%>
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
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/js/bootstrap-datepicker.js" type="text/javascript"></script>
        <script id="uploadDocument" src="<%=src%>/page/sa/js/uploadDocument.js<%="?dummy="+String.valueOf(new Date().getTime())%>" data-context="<%=request.getContextPath()%>" type="text/javascript"></script>
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
        <script>
        </script>
    </body>
</html>
<%}
    }%>