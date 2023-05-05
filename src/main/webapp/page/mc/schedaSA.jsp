<%-- 
    Document   : profile
    Created on : 18-set-2019, 12.31.26
    Author     : rcosco
--%>
<%@page import="rc.soop.util.Utility"%>
<%@page import="java.util.List"%>
<%@page import="rc.soop.domain.Storico_ModificheInfo"%>
<%@page import="rc.soop.db.Action"%>
<%@page import="rc.soop.domain.SoggettiAttuatori"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="rc.soop.db.Entity"%>
<%@page import="rc.soop.domain.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
            String src = session.getAttribute("src").toString();
            Entity e = new Entity();
            SoggettiAttuatori sa = e.getEm().find(SoggettiAttuatori.class, Long.parseLong(request.getParameter("id")));
            e.close();
%>
<html>
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%> - Profilo</title>
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

        <!--end::Fonts -->

        <!--begin::Page Vendors Styles(used by this page) -->

        <!--end::Page Vendors Styles -->

        <!--begin:: Global Mandatory Vendors -->
        <link href="<%=src%>/assets/vendors/general/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet" type="text/css" />

        <!--end:: Global Mandatory Vendors -->

        <!--begin:: Global Optional Vendors -->
        <link href="<%=src%>/assets/vendors/general/bootstrap-touchspin/dist/jquery.bootstrap-touchspin.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-select/dist/css/bootstrap-select.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-switch/dist/css/bootstrap3/bootstrap-switch.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/owl.carousel/dist/assets/owl.carousel.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/owl.carousel/dist/assets/owl.theme.default.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/socicon/css/socicon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/line-awesome/css/line-awesome.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/flaticon/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/flaticon2/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/fontawesome5/css/all.min.css" rel="stylesheet" type="text/css" />

        <!--end:: Global Optional Vendors -->

        <!--begin::Global Theme Styles(used by all pages) -->
        <link href="<%=src%>/assets/demo/default/base/style.bundle.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/resource/custom.css" rel="stylesheet" type="text/css" />

        <!--end::Global Theme Styles -->
        <link href="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/css/bootstrap-datepicker3.css" rel="stylesheet" type="text/css" />
        <!--begin::Layout Skins(used by all pages) -->
        <link href="<%=src%>/assets/demo/default/skins/header/base/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/brand/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/aside/light.css" rel="stylesheet" type="text/css" />

        <link href="<%=src%>/resource/animate.css" rel="stylesheet" type="text/css"/>
        <!--end::Layout Skins -->
        <link rel="shortcut icon" href="<%=src%>/assets/media/logos/favicon.ico" />
<style>
th { font-size: 13px; }
td { font-size: 12px; }
</style>
        <!--end::countDown -->
    </head>
    <body class="kt-header--fixed kt-header-mobile--fixed kt-subheader--fixed kt-subheader--enabled kt-subheader--solid kt-aside--enabled kt-aside--fixed">
        <!-- begin:: Page -->
        <div class="kt-grid kt-grid--hor kt-grid--root">
            <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--ver kt-page">
                <!-- end:: Aside -->
                <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor">
                    <!-- begin:: Footer -->
                    <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor">
                        <!-- begin:: Content Head -->
                        <!-- end:: Content Head -->
                        <!-- begin:: Content -->
                        <div class="kt-content  kt-grid__item kt-grid__item--fluid" id="kt_content">
                            <div class="kt-portlet kt-portlet--mobile">
                                <div class="kt-portlet__body">
                                    <form class="kt-form" id="kt_form" action="<%=request.getContextPath()%>/OperazioniSA?type=updtProfile" style="padding-top: 0;"  method="post" enctype="multipart/form-data">
                                        <!--begin:: Widgets/Best Sellers-->
                                        <div class="kt-portlet__head">
                                            <div class="kt-portlet__head kt-portlet__head--noborder">
                                                <div class="kt-portlet__head-label">
                                                    <h3 class="kt-portlet__head-title kt-font-io">
                                                        <i class="flaticon2-user"></i> Profilo | <b><%=sa.getRagionesociale()%></b>&nbsp;&nbsp;&nbsp;
                                                        <% if (sa.getProtocollo() == null) {%>
                                                        <a  data-toggle="popover-hover" data-content="<h5>Soggetto Attuatore in attesa di accreditamento</h5>" ><i class="flaticon2-correct kt-font-io-n"></i></a>
                                                            <%} else {%>
                                                        <a  data-toggle="popover-hover" data-content="<h5>Soggetto Attuatore accreditato</h5>" ><i class="flaticon2-correct kt-font-success"></i></a>
                                                            <%}%>
                                                    </h3>
                                                </div>
                                            </div>
                                            <div class="kt-portlet__head-toolbar">
                                                <ul class="nav nav-pills nav-pills-sm nav-pills-label nav-pills-bold" role="tablist">
                                                    <li class="nav-item">
                                                        <a class="nav-link active" data-toggle="tab" href="#kt_widget5_tab1_content" role="tab">
                                                            Soggetto Attuatore
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a class="nav-link" data-toggle="tab" href="#kt_widget5_tab2_content"  role="tab">
                                                            Amministratore Delegato / Unico
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a class="nav-link" data-toggle="tab" href="#kt_widget5_tab3_content" role="tab">
                                                            Referente
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a class="nav-link" data-toggle="tab" href="#kt_widget5_tab4_content" role="tab">
                                                            Aggiornamenti
                                                        </a>
                                                    </li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="kt-portlet__body">
                                            <div class="tab-content">
                                                <div class="tab-pane active" id="kt_widget5_tab1_content" aria-expanded="true">
                                                    <div class="col-md-12 col-sm-12">
                                                        <div class="kt-section kt-section--space-md">
                                                            <div class="form-group form-group-sm row">
                                                                <div class="col-md-5">
                                                                    <h5>Soggetto Attuatore</h5> <h6><%if (sa.getProtocollo() != null) {%>
                                                                        Numero Protocollo:<i> <%=sa.getProtocollo()%></i>
                                                                        <%}%></h6>
                                                                    <br>
                                                                    <div class="form-group ">
                                                                        <label>Ragione Sociale </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input readonly type="text" class="form-control" id="ragionesociale" name="ragionesociale" value="<%=sa.getRagionesociale()%>">
                                                                    </div>
                                                                    <div class="form-group ">
                                                                        <label>Partita IVA </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input readonly class="form-control" type="text" value="<%=sa.getPiva() == null ? "" : sa.getPiva()%>" name="piva" id="piva" onkeypress="return isNumber(event);"  >
                                                                    </div>
                                                                    <div class="form-group ">
                                                                        <label>Codice Fiscale </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input readonly class="form-control" type="text" value="<%=sa.getCodicefiscale() == null ? "" : sa.getCodicefiscale()%>" name="cf" id="cf" onkeypress="return isNumber(event);"  >
                                                                    </div>
                                                                    <br>
                                                                    <h6>Contatti</h6><br>
                                                                    <div class="form-group ">
                                                                        <label>Email</label> 
                                                                        <input readonly type="text" class="form-control" id="email" name="email" value="<%=sa.getEmail()%>">
                                                                    </div>
                                                                    <div class="form-group ">
                                                                        <label>Posta Elettronica Certificata (PEC) </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input readonly type="text" class="form-control" id="pec" name="pec" value="<%=sa.getPec()%>">
                                                                    </div>
                                                                    <div class="form-group ">
                                                                        <label>Telefono </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input readonly type="text" class="form-control" id="telefono_sa" name="telefono_sa" value="<%=sa.getTelefono_sa()%>">
                                                                    </div>
                                                                    <div class="form-group ">
                                                                        <label>Cellulare </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input readonly type="text" class="form-control" id="cell_sa" name="cell_sa" value="<%=sa.getCell_sa()%>">
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-5">

                                                                    <h6>Indirizzo Sede Legale</h6><br>
                                                                    <div class="form-group ">
                                                                        <label>Indirizzo </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input readonly type="text" class="form-control" id="indirizzo" name="indirizzo" value="<%=sa.getIndirizzo()%>">
                                                                    </div>
                                                                    <div class="form-group ">
                                                                        <label>Regione </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <div class="dropdown bootstrap-select form-control kt-" id="regione_div" style="padding: 0;height: 35px;">
                                                                            <input readonly type="text" class="form-control" id="regione" name="regione" value="<%=sa.getComune().getRegione()%>">
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-group ">
                                                                        <label>Provincia </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <div class="dropdown bootstrap-select form-control kt-" id="provincia_div" style="padding: 0;height: 35px;">
                                                                            <input readonly type="text" class="form-control" id="provincia" name="provincia" value="<%=sa.getComune().getNome_provincia()%>">
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-group ">
                                                                        <label>Comune </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <div class="dropdown bootstrap-select form-control kt-" id="comune_div" style="padding: 0;height: 35px;">
                                                                            <input readonly type="text" class="form-control" id="comune" name="comune" value="<%=sa.getComune().getNome()%>">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-2 kt-align-right">
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="tab-pane" id="kt_widget5_tab2_content">
                                                    <div class="col-md-12 col-sm-12">
                                                        <div class="kt-section kt-section--space-md">
                                                            <div class="form-group form-group-sm row">
                                                                <div class="col-md-5">
                                                                    <h5>Amministratore Delegato / Unico</h5><br>
                                                                    <div class="form-group ">
                                                                        <label>Nome </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input readonly type="text" class="form-control" id="nome" name="nome" value="<%=sa.getNome()%>">
                                                                    </div>
                                                                    <div class="form-group ">
                                                                        <label>Cognome </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input readonly type="text" class="form-control" id="cognome" name="cognome" value="<%=sa.getCognome()%>">
                                                                    </div>
                                                                    <div class="form-group ">
                                                                        <label>Data Nascita </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input readonly type="text" class="form-control" value="<%=new SimpleDateFormat("dd/MM/yyyy").format(sa.getDatanascita())%>" name="datanascita"/>
                                                                    </div>
                                                                    <div class="form-group ">
                                                                        <label>Numero Documento </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input readonly class="form-control " type="text" value="<%=sa.getNro_documento()%>" name="nrodocumento" id="nrodocumento" >
                                                                    </div>
                                                                    <div class="form-group ">
                                                                        <label>Scadenza Documento </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input readonly type="text" class="form-control" value="<%=new SimpleDateFormat("dd/MM/yyyy").format(sa.getScadenza())%>" name="scadenza"/>
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-5">
                                                                    <div class="form-group form-group-sm row" id="div_preview"></div>
                                                                </div>
                                                                <div class="col-md-2 kt-align-right">
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="tab-pane" id="kt_widget5_tab3_content">
                                                    <div class="col-md-12 col-sm-12">
                                                        <div class="kt-section kt-section--space-md">
                                                            <div class="form-group form-group-sm row">
                                                                <div class="col-md-5">
                                                                    <h5>Referente </h5><br>
                                                                    <div class="form-group ">
                                                                        <label>Nome </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input readonly type="text" class="form-control" id="nome_ref" name="nome_ref" value="<%=sa.getNome_refente()%>">
                                                                    </div>
                                                                    <div class="form-group ">
                                                                        <label>Telefono </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input readonly type="text" class="form-control" value="<%=sa.getTelefono_referente()%>" name="tel_ref" id="tel_ref" onkeypress="return isNumber(event);"/>
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-5">
                                                                    <h5>&nbsp;</h5><br>
                                                                    <div class="form-group ">
                                                                        <label>Cognome </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input readonly type="text" class="form-control" id="cognome_ref" name="cognome_ref" value="<%=sa.getCognome_referente()%>">
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-2 kt-align-right">
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="tab-pane" id="kt_widget5_tab4_content">
                                                    <div class="col-md-12 col-sm-12">
                                                        <div class="kt-section kt-section--space-md">
                                                            <h5>Aggiornamenti anagrafica </h5><br>
                                                            <table class="table table-bordered" id="kt_table_1" style="width:100%; border-collapse: collapse;">
                                                                <thead>
                                                                    <tr>
                                                                        <th class="text-uppercase text-center">Data</th> 
                                                                        <th class="text-uppercase text-center">Operazione</th> 
                                                                        <th class="text-uppercase text-center">File</th> 
                                                                    </tr> 
                                                                </thead> 
                                                            </table> 
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!--end:: Widgets/Best Sellers-->
                                    </form>     
                                </div>
                            </div>
                        </div>
                    </div>	
                </div>
                <!-- end:: Content -->
            </div>
        </div>

        <!-- end:: Page -->

        <!-- begin::Quick Panel -->


        <!-- end::Quick Panel -->

        <!-- begin::Scrolltop -->
        <div id="kt_scrolltop" class="kt-scrolltop">
            <i class="fa fa-arrow-up"></i>
        </div>

        <!--begin:: Global Mandatory Vendors -->
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
        <script src="<%=src%>/assets/vendors/custom/vendors/bootstrap-multiselectsplitter/bootstrap-multiselectsplitter.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-select/dist/js/bootstrap-select.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/jquery-validation/dist/jquery.validate.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/jquery-validation/dist/additional-methods.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/custom/components/vendors/jquery-validation/init.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/components/extended/blockui1.33.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/soop/js/utility.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/bundle/app.bundle.js" type="text/javascript"></script>

        <script src="<%=src%>/assets/vendors/custom/datatables/datatables.bundle.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/soop/js/loadTable.js" type="text/javascript"></script>
        <script>
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
                                                                            $(document).ready(function () {
                                                                                $.get("<%=request.getContextPath()%>/OperazioniGeneral?type=pdfTob64&path=<%=sa.getCartaid()%>", function (data) {
                                                                                            $("<iframe />", {
                                                                                                "src": "data:application/pdf;base64," + data,
                                                                                                "width": '100%',
                                                                                                "height": '650px',
                                                                                                "type": "application/pdf",
                                                                                                css: {
                                                                                                    "margin": 5,
                                                                                                    "border": 0,
                                                                                                    "border-radius": 10,
                                                                                                }
                                                                                            }).appendTo($('#div_preview'));
                                                                                        });
                                                                                    });
        </script>
        
        <script>
            $("#kt_table_1").DataTable({
                dom: `<'row'<'col-sm-12'ftr>><'row'<'col-sm-6 col-md-6 col-lg-6 kt-align-left'i><'col-sm-6 col-lg-6 dataTables_pager 'lp >>`,
                lengthMenu: [5, 8],
                language: {
                    "lengthMenu": "Mostra _MENU_",
                    "infoEmpty": "Mostrati 0 di 0 per 0",
                    "loadingRecords": "Caricamento...",
                    "search": "Cerca:",
                    "zeroRecords": "Nessun risultato trovato",
                    "info": "Mostrati _END_ di _TOTAL_ ",
                    "emptyTable": "Nessun risultato",
                    "sInfoFiltered": "(filtrato su _MAX_ risultati totali)"
                },
                searchDelay: 500,
                processing: true,
                        ajax: '<%=request.getContextPath()%>/QueryMicro?type=getPec&id=<%=sa.getId()%>',
                                order: [],
                                columns: [
                                    {data: 'data',},
                                    {data: 'operazione'},
                                    {defaultContent: ''}
                                ],
                                columnDefs: [
                                    {"className": "dt-center", "targets": "_all"},
                                    {
                                        targets: 0,
                                        type: 'date-it',
                                        render: function (data, type, row, meta) {
                                            return formattedDate(new Date(row.data));
                                        }
                                    },
                                    {
                                        targets: 2,
                                        render: function (data, type, row, meta) {
                                            return "<a data-container='body' data-toggle='kt-tooltip' data-placement='top' title='Scarica' href='<%=request.getContextPath()%>/OperazioniGeneral?type=downloadDoc&path=" + row.path + "'><u><b>" + row.path.substring(row.path.lastIndexOf("/") + 1) + "</b><u></a>";
                                        }
                                    }
                                ],
                            });
        </script>
    </body>
</html>
<%}
    }%>
