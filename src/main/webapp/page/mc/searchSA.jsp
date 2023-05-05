
<%@page import="rc.soop.domain.EstensioniFile"%>
<%@page import="rc.soop.domain.TipoDoc"%>
<%@page import="rc.soop.domain.TipoDoc_Allievi"%>
<%@page import="rc.soop.db.Entity"%>
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
            EstensioniFile ext = e.getEm().find(EstensioniFile.class, "pdf");
            e.close();
            String src = session.getAttribute("src").toString();
            String iva = request.getParameter("piva") != null ? request.getParameter("piva") : "";
%>
<html>
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%> - Soggetti Attuatori Cerca</title>
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

        <link href="<%=src%>/assets/vendors/general/select2/dist/css/select2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/owl.carousel/dist/assets/owl.carousel.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/owl.carousel/dist/assets/owl.theme.default.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/socicon/css/socicon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/line-awesome/css/line-awesome.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/flaticon/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/flaticon2/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/fontawesome5/css/all.min.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/resource/animate.css" rel="stylesheet" type="text/css"/>
        <link href="<%=src%>/resource/datatbles.bundle.css" rel="stylesheet" type="text/css"/>
        <link href="<%=src%>/assets/demo/default/base/style.bundle.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/resource/custom.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/header/base/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/brand/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/aside/light.css" rel="stylesheet" type="text/css" />
        <link rel="shortcut icon" href="<%=src%>/assets/media/logos/favicon.ico" />
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
                                    <h3 class="kt-subheader__title">Soggetti Attuatori</h3>
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
                                                        <label class="kt-section__title" style="color: #646c9a;">Soggetto Attuatore:</label>
                                                        <div class="kt-separator kt-separator--border kt-separator--space-xs col-lg-9"></div>
                                                        <div class="form-group row">
                                                            <div class="col-lg-3">
                                                                <label>Ragione Sociale</label>
                                                                <input class="form-control" name="ragionesociale" id="ragionesociale" autocomplete="off">
                                                            </div>
                                                            <div class="col-lg-2">
                                                                <label>Protocollo</label>
                                                                <input class="form-control" name="protocollo" id="protocollo" autocomplete="off">
                                                            </div>
                                                            <div class="col-lg-2">
                                                                <label>P.Iva</label>
                                                                <input class="form-control" name="piva" id="piva" value="<%=iva%>" autocomplete="off">
                                                            </div>
                                                            <div class="col-lg-2">
                                                                <label>Codice Fiscale</label>
                                                                <input class="form-control" name="cf" id="cf" autocomplete="off">
                                                            </div>
                                                            <div class="col-lg-3">
                                                                <label class="form-label">Da protocollare:</label>
                                                                <div class="kt-radio-inline">
                                                                    <label class="kt-radio">
                                                                        <input type="radio" value="" checked name="protocollare">. .
                                                                        <span></span>
                                                                    </label>
                                                                    <label class="kt-radio kt-radio--io">
                                                                        <input type="radio" value="1" name="protocollare">Si
                                                                        <span></span>
                                                                    </label>
                                                                    <label class="kt-radio kt-radio--io-n">
                                                                        <input type="radio" value="0" name="protocollare">No
                                                                        <span></span>
                                                                    </label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <label class="kt-section__title" style="color: #646c9a;">Amministratore Delegato o Unico:</label>
                                                        <div class="kt-separator kt-separator--border kt-separator--space-xs col-lg-9"></div>
                                                        <div class="form-group row">
                                                            <div class="col-lg-3">
                                                                <label>Nome</label>
                                                                <input class="form-control" name="nome" id="nome" autocomplete="off">
                                                            </div>
                                                            <div class="col-lg-3">
                                                                <label>Cognome</label>
                                                                <input class="form-control" name="cognome" id="cognome" autocomplete="off">
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
                                            <table class="table table-striped table-bordered " cellspacing="0" id="kt_table_1"style="width:100%;border-collapse: collapse;"> 
                                                <thead>
                                                    <tr>
                                                        <th class="text-uppercase text-center">Azioni</th>
                                                        <th class="text-uppercase text-center">Ragionesociale</th>
                                                        <th class="text-uppercase text-center">P.Iva</th>
                                                        <th class="text-uppercase text-center">Cod. Fiscale</th>
                                                        <th class="text-uppercase text-center">Provincia</th>
                                                        <th class="text-uppercase text-center">Comune</th>
                                                        <th class="text-uppercase text-center">Via</th>
                                                        <th class="text-uppercase text-center">Nome Amministratore</th>
                                                        <th class="text-uppercase text-center">Cognome Amministratore</th>
                                                        <th class="text-uppercase text-center">Telefono</th>
                                                        <th class="text-uppercase text-center">N. Protocollo</th>
                                                        <th class="text-uppercase text-center">Scheda S.A.</th>
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
        <script src="<%=src%>/assets/vendors/general/perfect-scrollbar/dist/perfect-scrollbar.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/jquery/dist/jquery.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/popper.js/dist/umd/popper.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap/dist/js/bootstrap.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/js-cookie/src/js.cookie.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/moment/min/moment.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/tooltip.js/dist/umd/tooltip.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/sticky-js/dist/sticky.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/demo/default/base/scripts.bundle.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/soop/js/utility.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/bundle/app.bundle.js" type="text/javascript"></script>
        <!-- this page -->
        <script src="<%=src%>/assets/vendors/custom/datatables/datatables.bundle.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/soop/js/loadTable.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/js/bootstrap-datepicker.js" type="text/javascript"></script>

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
            $.getScript('<%=request.getContextPath()%>/page/partialView/partialView.js', function () {});

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
                        ScrollX: "100%",
                        sScrollXInner: "110%",
                        searchDelay: 500,
                        processing: true,
                        pageLength: 10,
                        ajax: '<%=request.getContextPath()%>/QueryMicro?type=searchSA&ragionesociale=' + $('#ragionesociale').val()
                                + '&protocollo=' + $('#protocollo').val() + '&piva=' + $('#piva').val() + '&cf=' + $('#cf').val() + '&protocollare=' + $('input[name=protocollare]:checked').val()
                                + '&nome=' + $('#nome').val() + '&cognome=' + $('#cognome').val(),
                        order: [],
                        columns: [
                            {defaultContent: ''},
                            {data: 'ragionesociale'},
                            {data: 'piva'},
                            {data: 'codicefiscale'},
                            {data: 'comune.nome_provincia'},
                            {data: 'comune.nome'},
                            {data: 'indirizzo'},
                            {data: 'nome'},
                            {data: 'cognome'},
                            {data: 'telefono_sa'},
                            {data: 'protocollo'},
                            {defaultContent: ''},
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
                                            + '<i class="flaticon-more-1"></i>'
                                            + '</button>'
                                            + '<div class="dropdown-menu dropdown-menu-left">';
                                    //opzione protocollo
                                    option += '<a class="dropdown-item" href="javascript:void(0);" onclick="setProtocollo(' + row.id + ','
                                            + (row.protocollo == null ? '\'\'' : row.protocollo)
                                            + ',' + (row.dataprotocollo == null ? '\'' + new Date() + '\'' : row.dataprotocollo)
                                            + ');"><i class="la la-edit"></i> Protocolla</a>';
                                    //aggiornamento anagrafica
                                    option += '<a class="dropdown-item" href="javascript:void(0);" onclick="uploadPec(' + row.id + ',\'' + row.ragionesociale + '\','
                                            + (row.piva == null ? '\'\'' : '\'' + row.piva + '\'')
                                            + ',' + (row.codicefiscale == null ? '\'\'' : '\'' + row.codicefiscale + '\'')
                                            + ');"><i class="fa fa-mail-bulk"></i> Aggiorna anagrafica</a>';
                                    option += '<a class="dropdown-item" href="<%=request.getContextPath()%>/redirect.jsp?page=page/mc/searchAllieviMicro.jsp&idsa=' + row.id + '" target="_blank"><i class="flaticon-users-1"></i> Allievi</a>'
                                    option += '<a class="dropdown-item" href="<%=request.getContextPath()%>/redirect.jsp?page=page/mc/searchPFMicro.jsp&idsa=' + row.id + '" target="_blank"><i class="fa fa-graduation-cap"></i> Progetti Formativi</a>'
                                    option += '</div></div>';
                                    return option;
                                }
                            },
                            {
                                targets: 1,
                                title: "RAGIONE SOCIALE",
                            },
                            {
                                targets: 9,
                                orderable: false,
                            },
                            {
                                targets: 11,
                                className: 'text-center',
                                orderable: false,
                                render: function (data, type, row, meta) {
                                    return '<a href="schedaSA.jsp?id=' + row.id + '" class="btn btn-io fa fa-address-card fancyProfileNoRef" style="font-size: 20px"'
                                            + 'data-container="body" data-html="true" data-toggle="kt-tooltip"'
                                            + 'data-placement="top" title="<h5>Visualizza scheda<br>Soggetto Attuatore</h5>"></a>'
                                }
                            }
                        ]
                    }).columns.adjust();
                };
                return {
                    init: function () {
                        initTable1();
                    },
                };
            }();
            jQuery(document).ready(function () {
                KTDatatablesDataSourceAjaxServer.init();
                $('.kt-scroll-x').each(function () {
                    const ps = new PerfectScrollbar($(this)[0], {suppressScrollY: true});
                });
            });
            function refresh() {
                $("#toolbar").css("display", "none");
                $('html, body').animate({scrollTop: $('#offsetresult').offset().top}, 500);
                load_table($('#kt_table_1'), '<%=request.getContextPath()%>/QueryMicro?type=searchSA&ragionesociale=' + $('#ragionesociale').val()
                        + '&protocollo=' + $('#protocollo').val() + '&piva=' + $('#piva').val() + '&cf=' + $('#cf').val() + '&protocollare='
                        + $('input[name=protocollare]:checked').val() + '&nome=' + $('#nome').val() + '&cognome=' + $('#cognome').val());
            }

            function setProtocollo(id, protocollo, data) {
                swal.fire({
                    title: 'Inserisci protocollo',
                    html: "<input class='form-control' id='new_protocollo' name='new_protocollo' placeholder='protocollo' value='" + protocollo + "'><br>"
                            + "<input class='form-control dp' id='dataprotocollo' name='dataprotocollo' placeholder='data protocollo' value='" + formattedDate(new Date(data)) + "'>",
                    animation: false,
                    showCancelButton: true,
                    confirmButtonText: '&nbsp;<i class="la la-check"></i>',
                    cancelButtonText: '&nbsp;<i class="la la-close"></i>',
                    cancelButtonClass: "btn btn-io-n",
                    confirmButtonClass: "btn btn-io",
                    customClass: {
                        popup: 'animated bounceInUp'
                    },
                    onOpen: function () {
                        $('input.dp').datepicker({
                            rtl: KTUtil.isRTL(),
                            orientation: "bottom left",
                            todayHighlight: true,
                            autoclose: true,
                            format: 'dd/mm/yyyy',
                        });
                    },
                    preConfirm: function () {
                        var protocollo = $('#new_protocollo');
                        var data = $('#dataprotocollo');
                        var err = false;
                        err = checkValue(protocollo, false) ? true : err;
                        err = checkValue(data, false) ? true : err;
                        if (!err) {
                            return new Promise(function (resolve) {
                                resolve([
                                    protocollo.val(),
                                    data.val(),
                                ]);
                            });
                        } else {
                            return false;
                        }
                    },
                }).then((result) => {
                    if (result.value) {
                        showLoad();
                        $.ajax({
                            type: "GET",
                            url: '<%=request.getContextPath()%>/OperazioniMicro?type=setProtocollo&id=' + id + '&protocollo=' + result.value[0] + '&data=' + result.value[1],
                            success: function (data) {
                                closeSwal();
                                var json = JSON.parse(data);
                                if (json.result) {
                                    reload_table($('#kt_table_1'));
                                    swal.fire({
                                        "title": 'Successo',
                                        "text": "Protocollo assegnato con successo",
                                        "type": "success",
                                        confirmButtonClass: "btn btn-io",
                                    });
                                } else {
                                    swal.fire({
                                        "title": 'Errore',
                                        "text": json.message,
                                        "type": "error",
                                        cancelButtonClass: "btn btn-io-n",
                                    });
                                }
                            }
                        });
                    } else {
                        swal.close();
                    }
                }
                );
            }

            function uploadPec(idsa, rs, piva, cf) {

                var htmlp = getHtml("pecAnag", "<%=request.getContextPath()%>").replace("@func", "checkFileExtAndDim('" + <%=ext.getEstensione()%> + "');").replace("@mime", "<%=ext.getMime_type()%>").replace("@ragionesociale", rs).replace("@piva", piva).replace("@cf", cf).replace("@numb", "PivaNumberLength(event);").replace("@prevpiva", piva).replace("@prevcf", cf);
                swal.fire({
                    title: 'Aggiornamento anagrafica',
                    html: htmlp,
                    animation: false,
                    showCancelButton: true,
                    confirmButtonText: '&nbsp;<i class="la la-check"></i>',
                    cancelButtonText: '&nbsp;<i class="la la-close"></i>',
                    cancelButtonClass: "btn btn-io-n",
                    confirmButtonClass: "btn btn-io",
                    customClass: {
                        popup: 'animated bounceInUp'
                    },
                    onOpen: function () {
                        $('#doc').change(function (e) {
                            if (e.target.files.length != 0)
                                if (e.target.files[0].name.length > 30)
                                    $('#label_file').html(e.target.files[0].name.substring(0, 30) + "...");
                                else
                                    $('#label_file').html(e.target.files[0].name);
                            else
                                $('#label_file').html("Seleziona File");
                        });
                    },
                    preConfirm: function () {
                        var err = false;
                        var req_piva = false;
                        var req_cf = false;
                        var ra_sa = $('#ragionesociale_sa');
                        var piva_sa = $('#piva_sa');
                        var cf_sa = $('#cf_sa');
                        if (checkValue(ra_sa, false)) {
                            err = true;
                        }
                        if (checkPIva(piva_sa) || pivaPresent()) {
                            req_piva = true;
                        }
                        if (check_PIVA_CF(cf_sa) || CFPresent()) {
                            req_cf = true;
                        }
                        if (req_piva && req_cf) {
                            err = true;
                        }

                        err = !checkRequiredFileContent($('#pecAnag')) ? true : err;
                        if (!err) {
                            return new Promise(function (resolve) {
                                resolve({
                                    "rs_sa": $('#ragionesociale_sa').val(),
                                    "piva_sa": $('#piva_sa').val(),
                                    "cf_sa": $('#cf_sa').val(),
                                    "file": $('#doc')[0].files[0]
                                });
                            });
                        } else {
                            return false;
                        }
                    },
                }).then((result) => {
                    if (result.value) {
                        showLoad();
                        var fdata = new FormData();
                        fdata.append("file", result.value.file);
                        fdata.append("cf_sa", result.value.cf_sa);
                        fdata.append("piva_sa", result.value.piva_sa);
                        fdata.append("rs_sa", result.value.rs_sa);
                        upDoc(idsa, fdata);
                    } else {
                        swal.close();
                    }
                }
                );
            }

            function upDoc(id, fdata) {
                $.ajax({
                    type: "POST",
                    url: '<%=request.getContextPath()%>/OperazioniMicro?type=uploadPec&idsa=' + id,
                    data: fdata,
                    processData: false,
                    contentType: false,
                    success: function (data) {
                        var json = JSON.parse(data);
                        if (json.result) {
                            swalSuccessReload("Documento Caricato", "Operazione effettuata con successo");
                        } else {
                            swalError("Errore", json.message);
                        }
                    },
                    error: function () {
                        swalError("Errore", "Non è stato possibile caricare il documento");
                    }
                });
            }

            $(document).on('change', '#piva_sa', function (e) {
                $("#warning_iva").css("display", "none");
                if (!checkPIva($('#piva_sa'))) {
                    pivaPresent();
                }
                if ($('#piva_sa').val() == "") {
                    $('#piva_sa').attr("class", "form-control");
                }
            });

            $(document).on('change', '#cf_sa', function (e) {
                $("#warning_cf").css("display", "none");
                if (!check_PIVA_CF($('#cf_sa'))) {
                    CFPresent();
                }
                if ($('#cf_sa').val() == "") {
                    $('#cf_sa').attr("class", "form-control");
                }
            });

            function pivaPresent() {
                var err;
                if ($('#piva_sa').val() != $('#prevpiva').val()) {
                    $.ajax({
                        type: "GET",
                        async: false,
                        url: '<%=request.getContextPath()%>/OperazioniMicro?type=checkPiva&piva=' + $('#piva_sa').val(),
                        success: function (data) {
                            if (data != null && data != 'null') {
                                $('#warning_iva').css("display", "");
                                $('#piva_sa').attr("class", "form-control is-invalid");
                                err = true;
                            } else {
                                $("#warning_iva").css("display", "none");
                                $('#piva_sa').attr("class", "form-control is-valid");
                                err = false;
                            }
                        }
                    });
                } else {
                    err = false;
                }
                return err;
            }

            function CFPresent() {
                var err;
                if ($('#cf_sa').val() != $('#prevcf').val()) {
                    $.ajax({
                        type: "GET",
                        async: false,
                        url: '<%=request.getContextPath()%>/OperazioniMicro?type=checkCF&cf=' + $('#cf_sa').val(),
                        success: function (data) {
                            if (data != null && data != 'null') {
                                $('#warning_cf').css("display", "");
                                $('#cf_sa').attr("class", "form-control is-invalid");
                                err = true;
                            } else {
                                $("#warning_cf").css("display", "none");
                                $('#cf_sa').attr("class", "form-control is-valid");
                                err = false;
                            }
                        }
                    });
                } else {
                    err = false;
                }
                return err;
            }
        </script>
    </body>
</html>
<%
        }
    }
%>