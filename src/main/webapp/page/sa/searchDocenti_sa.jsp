
<%@page import="rc.soop.db.Entity"%>
<%@page import="java.util.List"%>
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
            Entity e = new Entity();
            e.close();
            String src = session.getAttribute("src").toString();%>
<html>
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%> - Docenti</title>
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

        <link href="<%=src%>/assets/vendors/general/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-touchspin/dist/jquery.bootstrap-touchspin.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-select/dist/css/bootstrap-select.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-switch/dist/css/bootstrap3/bootstrap-switch.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/select2/dist/css/select2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/ion-rangeslider/css/ion.rangeSlider.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/nouislider/distribute/nouislider.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/owl.carousel/dist/assets/owl.carousel.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/owl.carousel/dist/assets/owl.theme.default.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/socicon/css/socicon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/line-awesome/css/line-awesome.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/flaticon/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/flaticon2/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/fontawesome5/css/all.min.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/resource/animate.css" rel="stylesheet" type="text/css"/>
        <!--end:: Global Optional Vendors -->
        <link href="<%=src%>/resource/datatbles.bundle.css" rel="stylesheet" type="text/css"/>
        <!--begin::Global Theme Styles(used by all pages) -->
        <link href="<%=src%>/assets/demo/default/base/style.bundle.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/resource/custom.css" rel="stylesheet" type="text/css" />

        <!--end::Global Theme Styles -->

        <!--begin::Layout Skins(used by all pages) -->
        <link href="<%=src%>/assets/demo/default/skins/header/base/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/brand/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/aside/light.css" rel="stylesheet" type="text/css" />

        <!--end::Layout Skins -->
        <link rel="shortcut icon" href="<%=src%>/assets/media/logos/favicon.ico" />

        <!--end::countDown -->
        <style>
            .kt-section__title {
                font-size: 1.2rem!important;
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
                                    <h3 class="kt-subheader__title">Docenti</h3>
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
                                        <form action="" class="kt-form kt-form--label-right" onsubmit="return ctrlForm();" accept-charset="ISO-8859-1" method="post">
                                            <div class="kt-portlet__body paddig_0_t paddig_0_b">
                                                <div class="kt-section kt-section--first">
                                                    <div class="kt-section__body"><br>
                                                        <div class="form-group row">
                                                            <div class="col-lg-3">
                                                                <label>Nome</label>
                                                                <input class="form-control" name="nome" id="nome" autocomplete="off">
                                                            </div>
                                                            <div class="col-lg-3">
                                                                <label>Cognome</label>
                                                                <input class="form-control" name="cognome" id="cognome" autocomplete="off">
                                                            </div>
                                                            <div class="col-lg-3">
                                                                <label>Codice Fiscale</label>
                                                                <input class="form-control" name="cf" id="cf" autocomplete="off">
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
                                            <table class="table table-striped table-bordered " cellspacing="0"  id="kt_table_1" style="width:100%;border-collapse: collapse;"> 
                                                <thead>
                                                    <tr>
                                                        <th class="text-uppercase text-center">Azioni</th>
                                                        <th class="text-uppercase text-center">Nome</th>
                                                        <th class="text-uppercase text-center">Cognome</th>
                                                        <th class="text-uppercase text-center">Codice Fiscale</th>
                                                        <th class="text-uppercase text-center">Data Nascita</th>
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
        <!--begin:: Global Mandatory Vendors -->
        <script src="<%=src%>/assets/vendors/general/jquery/dist/jquery.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/popper.js/dist/umd/popper.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap/dist/js/bootstrap.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/js-cookie/src/js.cookie.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/moment/min/moment.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/tooltip.js/dist/umd/tooltip.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/perfect-scrollbar/dist/perfect-scrollbar.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/sticky-js/dist/sticky.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/select2/dist/js/select2.full.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/select2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/demo/default/base/scripts.bundle.js" type="text/javascript"></script>
        <!--DATATABLE -->
        <script src="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/custom/datatables/datatables.bundle.js" type="text/javascript"></script>
        <script src="../../assets/vendors/custom/datatables/datatables.bundle.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/soop/js/loadTable.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/soop/js/utility.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/js/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/bundle/app.bundle.js" type="text/javascript"></script>
        <!-- -->
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
            var KTDatatablesDataSourceAjaxServer = function () {
                var initTable1 = function () {
                    var table = $('#kt_table_1');
                    table.DataTable({
                        dom: `<'row'<'col-sm-12'ftr>><'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
                        lengthMenu: [5, 10, 25, 50],
                        language: {
                            'lengthMenu': 'Mostra _MENU_',
                            "infoEmpty": "Mostrati 0 di 0 per 0",
                            "loadingRecords": "Caricamento...",
                            "search": "Cerca:",
                            "zeroRecords": "Nessun risultato trovato",
                            "info": "Mostrati _START_ di _TOTAL_ ",
                            "emptyTable": "Nessun risultato",
                            "sInfoFiltered": "(filtrato su _MAX_ risultati totali)"
                        },
//                        responsive: true,
                        searchDelay: 500,
                        processing: true,
                        ScrollX: "100%",
                        sScrollXInner: "100%",
                        pageLength: 10,
                        ajax: '<%=request.getContextPath()%>/QuerySA?type=searchDocenti&cf=' + $('#cf').val()
                                + '&nome=' + $('#nome').val() + '&cognome=' + $('#cognome').val(),
                        order: [],
                        columns: [
                            {defaultContent: ''},
                            {data: 'nome', className: 'text-center'},
                            {data: 'cognome', className: 'text-center'},
                            {data: 'codicefiscale', className: 'text-center'},
                            {data: 'datanascita', className: 'text-center'}
                        ],
                        drawCallback: function () {
                            $('[data-toggle="kt-tooltip"]').tooltip();
                        },
                        rowCallback: function (row, data) {
                            $(row).attr("id", "row_" + data.id);
                        },
                        columnDefs: [
                            {
                                targets: 0,
                                className: 'text-center',
                                orderable: false,
                                render: function (data, type, row, meta) {

                                    var option = '<div class="dropdown dropdown-inline">'
                                            + '<button type="button" class="btn btn-icon btn-sm btn-icon-md btn-circle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">'
                                            + '   <i class="flaticon-more-1"></i>'
                                            + '</button>'
                                            + '<div class="dropdown-menu dropdown-menu-left">';
                                    if (row.docId !== null) {
                                        option += '<a class="fancyDocument dropdown-item" href="<%=request.getContextPath()%>/OperazioniGeneral?type=showDoc&path=' + row.docId + '"><i class="fa fa-address-card"></i>Visualizza Documento Identità</a>';
                                    }
                                    if (row.curriculum !== null) {
                                        option += '<a class="fancyDocument dropdown-item" href="<%=request.getContextPath()%>/OperazioniGeneral?type=showDoc&path=' + row.curriculum + '"><i class="fa fa-file-invoice"></i>Visualizza Curriculum</a>';
                                    }
                                    if (row.assegnato) {
                                        option += '<a class="dropdown-item" href="javascript:void(0);" onclick="swalTablePrg(' + row.id + ')"><i class="fa fa-list"></i>Progetti Formativi</a>';
                                    } 
                                    option += '</div></div>';
                                    return option;
                                }
                            }, {
                                targets: 4,
                                type: 'date-it',
                                render: function (data, type, row, meta) {
                                    return formattedDate(new Date(row.datanascita));
                                }
                            }
                        ]
                    }).columns.adjust();
                };
                return {
                    init: function () {
                        initTable1();
                    }
                };
            }();
            jQuery(document).ready(function () {
                KTDatatablesDataSourceAjaxServer.init();
                $('.kt-scroll-x').each(function () {
                    const ps = new PerfectScrollbar($(this)[0]);
                });
            });
            function refresh() {
                $("#toolbar").css("display", "none");
                $('html, body').animate({scrollTop: $('#offsetresult').offset().top}, 500);
                load_table($('#kt_table_1'), '<%=request.getContextPath()%>/QuerySA?type=searchDocenti&soggettoattuatore=' + $('#soggettoattuatore').val()
                        + '&cf=' + $('#cf').val() + '&nome=' + $('#nome').val() + '&cognome=' + $('#cognome').val(), );
            }

            function swalTablePrg(iddocente) {
                swal.fire({
                    html: '<table class="table table-bordered" id="kt_table_allievi">'
                            + '<thead>'
                            + '<tr>'
                            + '<th class="text-uppercase text-center">Nome</th>'
                            + '<th class="text-uppercase text-center">Data Inizio</th>'
                            + '<th class="text-uppercase text-center">Data Fine</th>'
                            + '<th class="text-uppercase text-center">Soggetto Attuatore</th>'
                            + '</tr>'
                            + '</thead>'
                            + '</table>',
                    width: '75%',
                    scrollbarPadding: true,
                    showCloseButton: true,
                    showCancelButton: false,
                    showConfirmButton: false,
                    onOpen: function () {
                        $("#kt_table_allievi").DataTable({
                            dom: `<'row'<'col-sm-12'ftr>><'row'<'col-sm-12 col-md-2'i><'col-sm-12 col-md-10 dataTables_pager'lp>>`,
                            lengthMenu: [15, 25, 50],
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
                            scrollY: "40vh",
                            ajax: '<%=request.getContextPath()%>/QuerySA?type=searchProgettiDocente&iddocente=' + iddocente,
                            order: [],
                            columns: [
                                {data: 'nome.descrizione'},
                                {data: 'start'},
                                {data: 'end'},
                                {data: 'soggetto.ragionesociale'}
                            ], columnDefs: [
                                {
                                    targets: 1,
                                    type: 'date-it',
                                    render: function (data, type, row, meta) {
                                        return formattedDate(new Date(data));
                                    }
                                }, {
                                    targets: 2,
                                    type: 'date-it',
                                    render: function (data, type, row, meta) {
                                        return formattedDate(new Date(data));
                                    }
                                }
                            ]
                        });
                    }
                });
            }
        </script>
    </body>
</html>
<%
        }
    }
%>