<%@page import="rc.soop.domain.StatiPrg"%>
<%@page import="rc.soop.db.Entity"%>
<%@page import="java.util.List"%>
<%@page import="rc.soop.domain.SoggettiAttuatori"%>
<%@page import="rc.soop.domain.User"%>
<%@page import="rc.soop.db.Action"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    User us = (User) session.getAttribute("user");
    if (us == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    } else {
        String uri_ = request.getRequestURI();
        String pageName_ = uri_.substring(uri_.lastIndexOf("/") + 1);
        if (!Action.isVisibile(String.valueOf(us.getTipo()), pageName_)) {
            response.sendRedirect(request.getContextPath() + "/page_403.jsp");
        } else {
            Long idsa = 0L;
            if (request.getParameter("idsa") != null) {
                idsa = Long.parseLong(request.getParameter("idsa"));
            }
            Entity e = new Entity();
            List<SoggettiAttuatori> sa_list = e.findAll(SoggettiAttuatori.class);
            List<StatiPrg> stati = e.getStatiPrg();
            e.close();
            String src = session.getAttribute("src").toString();
            String istato = request.getParameter("tipo") != null ? request.getParameter("tipo") : "";
            idsa = request.getParameter("sa") != null ? Long.parseLong(request.getParameter("sa")) : idsa;
%>
<html>
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%> - Progetti Formativi</title>
        <meta name="description" content="Updates and statistics">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <!--begin::Fonts -->
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
        <link href="<%=src%>/assets/vendors/general/bootstrap-daterangepicker/daterangepicker.css" rel="stylesheet" type="text/css"/>
        <link href="<%=src%>/resource/datatbles.bundle.css" rel="stylesheet" type="text/css"/>
        <link href="<%=src%>/assets/vendors/general/bootstrap-select/dist/css/bootstrap-select.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/select2/dist/css/select2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet" type="text/css" />
        <!-- - -->
        <link href="<%=src%>/assets/vendors/general/owl.carousel/dist/assets/owl.carousel.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/owl.carousel/dist/assets/owl.theme.default.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/line-awesome/css/line-awesome.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/flaticon/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/flaticon2/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/fontawesome5/css/all.min.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/resource/animate.css" rel="stylesheet" type="text/css"/>
        <link href="<%=src%>/assets/demo/default/base/style.bundle.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/resource/custom.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/header/base/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/brand/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/aside/light.css" rel="stylesheet" type="text/css" />
        <link rel="shortcut icon" href="<%=src%>/assets/media/logos/favicon.ico" />
        <!--end::countDown -->
        <style>
            .kt-section__title {
                font-size: 1.2rem!important;
            }
            .daterangepicker.ltr.auto-apply.show-calendar.opensright{
                z-index: 9999;
            }
        </style>
    </head>
    <body class="kt-header--fixed kt-header-mobile--fixed kt-subheader--fixed kt-subheader--enabled kt-subheader--solid kt-aside--enabled kt-aside--fixed">
        <!-- begin:: Page -->
        <%@ include file="menu/head1.jsp"%>
        <div class="kt-grid kt-grid--hor kt-grid--root">
            <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--ver kt-page">
                <%@ include file="menu/menu.jsp"%>
                <!-- end:: Aside -->
                <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor kt-wrapper" id="kt_wrapper">
                    <%@ include file="menu/head.jsp"%>
                    <!-- begin:: Footer -->
                    <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor">
                        <!-- begin:: Content Head -->
                        <div class="kt-subheader   kt-grid__item" id="kt_subheader">
                            <div class="kt-subheader   kt-grid__item" id="kt_subheader">
                                <div class="kt-subheader__main">
                                    <h3 class="kt-subheader__title">Progetti Formativi</h3>
                                    <span class="kt-subheader__separator kt-subheader__separator--v"></span>
                                    <a class="kt-subheader__breadcrumbs-link">Cerca</a>
                                </div>
                            </div>
                        </div>
                        <div class="kt-content  kt-grid__item kt-grid__item--fluid" id="kt_content">
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="kt-portlet" id="kt_portlet" data-ktportlet="true"><!--io-background-->
                                        <div class="kt-portlet__head">
                                            <div class="kt-portlet__head-label">
                                                <h3 class="kt-portlet__head-title" >
                                                    Cerca :
                                                </h3>
                                            </div>
                                            <div class="kt-portlet__head-toolbar">
                                                <div class="kt-portlet__head-group">
                                                    <a href="#" data-ktportlet-tool="toggle" class="btn btn-sm btn-icon btn-clean btn-icon-md"><i class="la la-angle-down" id="toggle_search"></i></a>
                                                </div>
                                            </div>
                                        </div>
                                        <form action="" class="kt-form kt-form--label-right" onsubmit="refresh();return false;" accept-charset="ISO-8859-1" method="post">
                                            <div class="kt-portlet__body paddig_0_t paddig_0_b">
                                                <div class="kt-section kt-section--first">
                                                    <div class="kt-section__body"><br>
                                                        <div class="form-group row">
                                                            <div class="col-lg-3">
                                                                <label>Soggetto Attuatore</label>
                                                                <div class="dropdown bootstrap-select form-control kt-" id="soggettoattuatore_div" style="padding: 0;height: 35px;">
                                                                    <select class="form-control kt-select2-general" id="soggettoattuatore" name="soggettoattuatore"  style="width: 100%">
                                                                        <option value="-">Seleziona Soggetto Attuatore</option>
                                                                        <%for (SoggettiAttuatori i : sa_list) {%>
                                                                        <%if (i.getId() == idsa) {%>
                                                                        <option selected value="<%=i.getId()%>"><%=i.getRagionesociale()%></option>
                                                                        <%} else {%>
                                                                        <option value="<%=i.getId()%>"><%=i.getRagionesociale()%></option>
                                                                        <%}
                                                                            }%>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="col-lg-3">
                                                                <label>CIP</label>
                                                                <input class="form-control" name="cip" id="cip" autocomplete="off">
                                                            </div>
                                                            <div class="col-lg-3">
                                                                <label>Stato</label>
                                                                <div class="dropdown bootstrap-select form-control kt-" id="stato_div" style="padding: 0;height: 35px;">
                                                                    <select class="form-control kt-select2-general" id="stato" name="stato" style="width: 100%">
                                                                        <option value="-">Seleziona Stato</option>
                                                                        <%for (StatiPrg i : stati) {
                                                                                if (istato.equals(i.getTipo())) {%>
                                                                        <option selected value="<%=i.getTipo()%>"><%=i.getDe_tipo()%></option>
                                                                        <%} else {%>
                                                                        <option value="<%=i.getTipo()%>"><%=i.getDe_tipo()%></option>
                                                                        <%}
                                                                            }%>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="col-lg-3" id="rendicontato_filter" style="display: none;">
                                                                <label>Rendic./Liq.:</label><br>
                                                                <div class="dropdown bootstrap-select form-control kt- " id="rendicontato_div" style="padding: 0;">
                                                                    <select class="form-control kt-select2-general obbligatory" id="rendicontato" name="rendicontato"  style="width: 100%">
                                                                        <option value="-">. . .</option>
                                                                        <option value="0">No</option>
                                                                        <option value="1">Rendicontato</option>
                                                                        <option value="2">Liquidato</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="kt-portlet__foot">
                                                        <div class="kt-form__actions">
                                                            <div class="row">
                                                                <div class="offset-lg-6 col-lg-6 kt-align-right">
                                                                    <a onclick="refresh();" href="javascript:void(0);" class="btn btn-io"><font color='white'>Cerca</font></a>
                                                                    <a href="<%=pageName_%>" class="btn btn-io-n"><font color='white'>Reset</font></a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            <div class="row" id="offsetresult">
                                <div class="col-lg-12">
                                    <div class="kt-portlet" id="kt_portlet" data-ktportlet="true">
                                        <div class="kt-portlet__head">
                                            <div class="kt-portlet__head-label col-lg-8">
                                                <div class="col-lg-4">
                                                    <h3 class="kt-portlet__head-title text" >
                                                        Risultati :
                                                    </h3>
                                                </div>
                                            </div>
                                            <div class="kt-portlet__head-toolbar">
                                                <div class="kt-portlet__head-group">
                                                    <a href="#" data-ktportlet-tool="toggle" class="btn btn-sm btn-icon btn-clean btn-icon-md"><i class="la la-angle-down" id="toggle_search"></i></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="kt-portlet__body kt-scroll-x">
                                            <table class="table table-striped table-bordered" cellspacing="0" id="kt_table_1" style="border-collapse: collapse;"> 
                                                <thead>
                                                    <tr>
                                                        <th class="text-uppercase text-center">Azioni</th>
                                                        <th class="text-uppercase text-center">ID</th>
                                                        <th class="text-uppercase text-center">Descrizione</th>
                                                        <th class="text-uppercase text-center">PF Misto</th>
                                                        <th class="text-uppercase text-center">Ore</th>
                                                        <th class="text-uppercase text-center">Data Inizio</th>
                                                        <th class="text-uppercase text-center">Data Fine</th>
                                                        <th class="text-uppercase text-center">CIP</th>
                                                        <th class="text-uppercase text-center">Soggetto Attuatore</th>
                                                        <th class="text-uppercase text-center">Sede Di Formazione</th>
                                                        <th class="text-uppercase text-center">Stato</th>
                                                        <th class="text-uppercase text-center">Errore O Verificare</th>
                                                        <th class="text-uppercase text-center">Redicontato</th>
                                                        <th class="text-uppercase text-center">Importo Riconosciuto al SA</th>
                                                        <th class="text-uppercase text-center">Importo Rendicontato RegCal</th>
                                                    </tr>
                                                </thead>
                                            </table>  
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- end:: Content Head -->
                    </div>
                    <%@ include file="menu/footer.jsp"%>
                    <!-- end:: Footer -->
                    <!-- end:: Content -->
                </div>
            </div>
        </div>
        <!-- begin::Scrolltop -->
        <div id="kt_scrolltop" class="kt-scrolltop">
            <i class="fa fa-arrow-up"></i>
        </div>
        <!--start:Modal-->
        <div class="modal fade" id="allievi_table" tabindex="-1" role="dialog" aria-labelledby="Allievi Progetto Formativo" aria-hidden="true" style="padding: 0!important;">
            <div class="modal-dialog modal-full modal-dialog-centered" role="document">
                <div class="modal-content center">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Allievi Progetto</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="kt-scroll" style="max-height: 750px; min-height: 750px;">
                            <table class="table table-bordered" id="kt_table_allievi" style="width: 100%;">
                                <thead style="width: 100%;">
                                    <tr>
                                        <th class="text-uppercase text-center">Azioni</th>
                                        <th class="text-uppercase text-center">Nome</th>
                                        <th class="text-uppercase text-center">Cognome</th>
                                        <th class="text-uppercase text-center">Codice Fiscale</th>
                                        <th class="text-uppercase text-center">Data Nascita</th>
                                        <th class="text-uppercase text-center">Domicilio</th>
                                        <th class="text-uppercase text-center">Modello 8</th>
                                        <th class="text-uppercase text-center">SELFIEmployement</th>
                                        <th class="text-uppercase text-center">Documento Id.</th>
                                        <th class="text-uppercase text-center">Esito</th>
                                        <th class="text-uppercase text-center">Importo</th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal fade" id="doc_modal" tabindex="-1" role="dialog" aria-labelledby="Documenti" aria-hidden="true"> 
            <div class="modal-dialog modal-xl modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Documenti</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        </button>
                    </div>
                    <div class="modal-body kt-scroll" style="max-height: 750px;">
                        <div style="text-align: center;">
                            <div class="row col-12" id="prg_docs"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal fade" id="register_modal" tabindex="-1" role="dialog" aria-labelledby="Registro Aula" aria-hidden="true"> 
            <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Registro Aula</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        </button>
                    </div>
                    <div class="modal-body kt-scroll" style="max-height: 500px;">
                        <div class="row col-12" id="register_docs_modal">

                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--end::Modal-->
        <script src="<%=src%>/assets/vendors/general/jquery/dist/jquery.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/popper.js/dist/umd/popper.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap/dist/js/bootstrap.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/js-cookie/src/js.cookie.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/moment/min/moment.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/tooltip.js/dist/umd/tooltip.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/sticky-js/dist/sticky.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/demo/default/base/scripts.bundle.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/bundle/app.bundle.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/soop/js/utility.js" type="text/javascript"></script>
        <link href="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/css/bootstrap-datepicker3.css" rel="stylesheet" type="text/css" />
        <!--this page -->
        <script src="<%=src%>/assets/vendors/general/select2/dist/js/select2.full.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/select2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/jquery-form/dist/jquery.form.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/custom/datatables/datatables.bundle.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/soop/js/loadTable.js" type="text/javascript"></script>
        <script src="<%=src%>/resource/PerfectScroolbar/perfect-scrollbar.js" type="text/javascript"></script>
        <script src="<%=src%>/page/mc/js/control.js<%=no_cache%>" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-daterangepicker/daterangepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/js/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/inputmask/dist/inputmask/inputmask.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/inputmask/dist/inputmask/jquery.inputmask.js" type="text/javascript"></script>
        <script id="searchPFMicro" src="<%=src%>/page/mc/js/searchPFMicro.js<%=no_cache%>" data-context="<%=request.getContextPath()%>" type="text/javascript"></script>
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
//            serve a far vedere il filtro rendicontato solo se seleziono archiviato
            $("#stato").change(function () {
                if ($(this).val() == "archiviato")
                    $("#rendicontato_filter").css("display", "");
                else {
                    $("#rendicontato_filter").css("display", "none");
                    $("#rendicontato").val("-");
                    $("#rendicontato").trigger("change");
                }
            });
            jQuery(document).ready(function () {
                $("#stato").trigger("change");
            });
        </script>
    </body>
</html>
<%
        }
    }
%>