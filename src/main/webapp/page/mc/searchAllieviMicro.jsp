
<%@page import="rc.soop.domain.CPI"%>
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
            List<CPI> cpi = e.listaCPI();
            List<SoggettiAttuatori> sa_list = e.findAll(SoggettiAttuatori.class);
            e.close();
            String src = session.getAttribute("src").toString();
%>
<html>
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%> - Allievi</title>
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
        <!-- this page -->
        <link href="<%=src%>/assets/vendors/general/bootstrap-select/dist/css/bootstrap-select.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/select2/dist/css/select2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/resource/datatbles.bundle.css" rel="stylesheet" type="text/css"/>
        <!-- - -->
        <link href="<%=src%>/assets/vendors/general/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/socicon/css/socicon.css" rel="stylesheet" type="text/css" />
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
    </head>
    <body class="kt-header--fixed kt-header-mobile--fixed kt-subheader--fixed kt-subheader--enabled kt-subheader--solid kt-aside--enabled kt-aside--fixed">
        <%@ include file="menu/head1.jsp"%>
        <div class="kt-grid kt-grid--hor kt-grid--root">
            <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--ver kt-page">
                <%@ include file="menu/menu.jsp"%>
                <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor kt-wrapper" id="kt_wrapper">
                    <%@ include file="menu/head.jsp"%>
                    <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor">
                        <div class="kt-subheader   kt-grid__item" id="kt_subheader">
                            <div class="kt-subheader   kt-grid__item" id="kt_subheader">
                                <div class="kt-subheader__main">
                                    <h3 class="kt-subheader__title">Allievi</h3>
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
                                        <form action="" class="kt-form kt-form--label-right" accept-charset="ISO-8859-1" method="post">
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
                                                        <div class="form-group row">
                                                            <div class="col-lg-3">
                                                                <label>Centro per l'impiego di iscrizione </label>
                                                                <div class="dropdown bootstrap-select form-control kt-" id="cpi_div" style="padding: 0;height: 35px;">
                                                                    <select class="form-control kt-select2-general" id="cpi" name="cpi"  style="width: 100%">
                                                                        <option value="-">Seleziona CPI</option>
                                                                        <%for (CPI c : cpi) {%>
                                                                        <option value="<%=c.getId()%>"><%=c.getDescrizione()%></option>
                                                                        <%}%>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="col-lg-4">
                                                                <label>Pregresso:</label><br>
                                                                <div class="kt-radio-inline">
                                                                    <label class="kt-radio">
                                                                        <input type="radio" value="" checked name="pregresso">. .
                                                                        <span></span>
                                                                    </label>
                                                                    <label class="kt-radio kt-radio--io">
                                                                        <input type="radio" value="1" name="pregresso">Si
                                                                        <span></span>
                                                                    </label>
                                                                    <label class="kt-radio kt-radio--io-n">
                                                                        <input type="radio" value="0" name="pregresso">No
                                                                        <span></span>
                                                                    </label>
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
                                            <table class="table table-striped table-bordered " cellspacing="0" id="kt_table_1"style="width:100%;border-collapse: collapse;"> 
                                                <thead>
                                                    <tr>
                                                        <th class="text-uppercase text-center">Azioni</th>
                                                        <th class="text-uppercase text-center">Nome</th>
                                                        <th class="text-uppercase text-center">Cognome</th>
                                                        <th class="text-uppercase text-center">Codice Fiscale</th>
                                                        <th class="text-uppercase text-center">Titolo Di Studio</th>
                                                        <th class="text-uppercase text-center">Data Nascita</th>
                                                        <th class="text-uppercase text-center">Residenza</th>
                                                        <th class="text-uppercase text-center">Domicilio</th>
                                                        <th class="text-uppercase text-center">Data Iscrizione G.G.</th>
                                                        <th class="text-uppercase text-center">C.P.I.</th>
                                                        <th class="text-uppercase text-center">Protocollo</th>
                                                        <th class="text-uppercase text-center">Ore Fase A</th>
                                                        <th class="text-uppercase text-center">Ore Fase B</th>
                                                        <th class="text-uppercase text-center">Documento Id.</th>
                                                    </tr>
                                                </thead>
                                            </table>  
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%@ include file="menu/footer.jsp"%>
                </div>
            </div>
        </div>
        <div id="kt_scrolltop" class="kt-scrolltop">
            <i class="fa fa-arrow-up"></i>
        </div>
        <!--start:Modal-->
        <div class="modal fade" id="doc_modal" tabindex="-1" role="dialog" aria-labelledby="Documenti Allievo" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Documenti Allievo</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        </button>
                    </div>
                    <div class="modal-body">
                        <div style="text-align: center;">
                            <div class="row col-12" id="prg_docs"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--end:Modal-->
        <script src="<%=src%>/assets/vendors/general/jquery/dist/jquery.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/popper.js/dist/umd/popper.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap/dist/js/bootstrap.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/js-cookie/src/js.cookie.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/moment/min/moment.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/tooltip.js/dist/umd/tooltip.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/perfect-scrollbar/dist/perfect-scrollbar.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/sticky-js/dist/sticky.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/demo/default/base/scripts.bundle.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/soop/js/utility.js" type="text/javascript"></script>
        <!-- this page -->
        <script src="<%=src%>/assets/vendors/custom/datatables/datatables.bundle.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/soop/js/loadTable.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/select2/dist/js/select2.full.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/select2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/js/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/bundle/app.bundle.js" type="text/javascript"></script>
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

            var prg = new Map();
            var context = '<%=request.getContextPath()%>';
            $.getScript(context + '/page/partialView/partialView.js', function () {});

            var KTDatatablesDataSourceAjaxServer = function () {
                var initTable1 = function () {
                    var table = $('#kt_table_1');
                    table.DataTable({
                        dom: `<'row'<'col-sm-12'ftr>><'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
//                        dom: "<'row'<'col-sm-6'B><'col-sm-6'ft>>" +
//                                "t" +
//                                "<'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>",
//                        buttons: [{
//                                extend: 'excel',
//                                className: 'btn btn-excel',
//                                text: '<i class="fa fa-file-excel"></i>Esporta Excel',
//                                title: 'Allievi_' + formattedDate(new Date()),
//                                exportOptions: {
//                                    columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
//                                }
//                            },
//                        ],
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
                        ajax: context + '/QueryMicro?type=searchAllievo&soggettoattuatore=' + $('#soggettoattuatore').val() + '&cf=' + $('#cf').val()
                                + '&nome=' + $('#nome').val() + '&cognome=' + $('#cognome').val() + '&cpi=' + $('#cpi').val() + '&pregresso=' + $('input[name=pregresso]:checked').val(),
                        order: [],
                        columns: [
                            {defaultContent: ''},
                            {data: 'nome'},
                            {data: 'cognome'},
                            {data: 'codicefiscale'},
                            {data: 'titoloStudio.descrizione'},
                            {data: 'datanascita'},
                            {data: 'indirizzoresidenza'},
                            {data: 'indirizzodomicilio'},
                            {data: 'iscrizionegg'},
                            {data: 'cpi.descrizione'},
                            {data: 'protocollo'},
                            {data: 'ore_fa'},
                            {data: 'ore_fb'},
                            {defaultContent: ''}
                        ],
                        drawCallback: function () {
                            $('[data-toggle="kt-tooltip"]').tooltip();
                        },
                        rowCallback: function (row, data) {
                            if (!data.pregresso) {
                                $(row).attr("id", "row_" + data.id);
                            } else {
                                $(row).attr("id", "row_" + data.id + "_pregresso");
                            }
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
                                    if (row.progetto !== null) {
                                        prg.set(row.progetto.id, row.progetto);
                                        option += '<a class="dropdown-item" href="javascript:void(0);" onclick="showPrg(' + row.progetto.id + ')"><i class="flaticon-presentation-1"></i> Visualizza Progetto Formativo</a>';
                                    }
                                    option += '<a class="dropdown-item" href="javascript:void(0);" onclick="swalDocumentAllievo(' + row.id + ')"><i class="fa fa-file-alt"></i> Visualizza Documenti</a>';
//                                    option += '<a class="dropdown-item" href="#"><i class="fa fa-list"></i> Visualizza Registro</a>';

                                    if (!row.pregresso) {
                                        option += '<a class="dropdown-item" href="javascript:void(0);" onclick="swalNoteAllievo('
                                                + row.id + ')"><i class="fa fa-sticky-note"></i> Visualizza/Modifica Note</a>';
                                    }

                                    option += '</div></div>';
                                    if (row.pregresso) {
                                        option = '<div class="dropdown dropdown-inline">'
                                                + '<button type="button" class="btn btn-icon btn-icon-md btn-io" data-toggle="dropdown" aria-haspopup="true" '
                                                + 'aria-expanded="false" data-container="body" data-html="true" data-toggle="kt-tooltip" data-placement="top" title="Pregresso">'
                                                + '<font color="white">P</font>'
                                                + '</button>'
                                                + '<div class="dropdown-menu dropdown-menu-left">';
                                        option += '<a class="dropdown-item fancyBoxAntoRef" href="uploadDocAllieviPregresso.jsp?id=' + row.id + '"><i class="fa fa-file-alt"></i> Visualizza/Carica Documenti</a>';
                                        option += '</div></div>';
//                                        return '<div><button type="button" class="btn btn-io" data-container="body" data-html="true" data-toggle="kt-tooltip" data-placement="top" title="Pregresso"><font color="white">P</font></button></div>';
                                    }

                                    return option;

                                }
                            }, {
                                targets: 5,
                                type: 'date-it',
                                render: function (data, type, row, meta) {
                                    return formattedDate(new Date(row.datanascita));
                                }
                            }, {
                                targets: 6,
                                render: function (data, type, row, meta) {
                                    var comune = (row.comune_residenza.nome === null ? "N.I." : row.comune_residenza.nome)
                                            + " (" + (row.comune_residenza.provincia === null ? "N.I." : row.comune_residenza.provincia) + ")";
                                    return comune + ",<br> " + row.indirizzoresidenza + " " + row.civicoresidenza;
                                }
                            }, {
                                targets: 7,
                                render: function (data, type, row, meta) {
                                    var comune = (row.comune_domicilio.nome === null ? "N.I." : row.comune_domicilio.nome)
                                            + " (" + (row.comune_domicilio.provincia === null ? "N.I." : row.comune_domicilio.provincia) + ")";
                                    return comune + ",<br> " + row.indirizzodomicilio + " " + row.civicodomicilio;
                                }
                            }, {
                                targets: 8,
                                type: 'date-it',
                                render: function (data, type, row, meta) {
                                    if (row.pregresso) {
                                        return "<div></div>";
                                    } else {
                                        return formattedDate(new Date(row.iscrizionegg));
                                    }
                                }
                            }, {
                                targets: 13,
                                className: 'text-center',
                                orderable: false,
                                render: function (data, type, row, meta) {
                                    var option = '<a href="' + context + '/OperazioniGeneral?type=showDoc&path=' + row.docid + '" class="btn btn-io fa fa-address-card fancyDocument" style="font-size: 20px;"'
                                            + 'data-container="body" data-html="true" data-toggle="kt-tooltip"'
                                            + 'data-placement="top" title="<h6>Scadenza:</h6><h5>' + formattedDate(new Date(row.scadenzadocid)) + '</h5>"></a>';
                                    if (new Date(row.scadenzadocid) <= new Date()) {
                                        option = '<a href="' + context + '/OperazioniGeneral?type=showDoc&path=' + row.docid + '" class="btn btn-io-n fancyDocument" style="font-size: 20px"'
                                                + 'data-container="body" data-html="true" data-toggle="kt-tooltip"'
                                                + 'data-placement="top" title="<h6>Scadenza:</h6><h5>'
                                                + formattedDate(new Date(row.scadenzadocid)) + '</h5>">&nbsp;<i class="fa fa-exclamation-triangle"></i></a>';
                                    }
                                    if (row.pregresso) {
                                        if (row.docid === null || row.docid === "") {
                                            option = '<a class="btn btn-io-n" style="font-size: 20px"'
                                                    + 'data-container="body" data-html="true" data-toggle="kt-tooltip"'
                                                    + 'data-placement="top" title="<h6>Doc Id. non caricato</h6>">&nbsp;<i class="fa fa-exclamation-triangle"></i></a>';
                                        } else {
                                            option = '<a href="' + context + '/OperazioniGeneral?type=showDoc&path=' + row.docid + '" class="btn btn-io fa fa-address-card fancyDocument" style="font-size: 20px;"'
                                                    + 'data-container="body" data-html="true" data-toggle="kt-tooltip"'
                                                    + 'data-placement="top" title="<h6>Doc Id.</h6>"></a>';
                                        }
                                    }
                                    return option;
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
                    const ps = new PerfectScrollbar($(this)[0], {suppressScrollY: true});
                });
            });
            function refresh() {
                $('html, body').animate({scrollTop: $('#offsetresult').offset().top}, 500);
                load_table($('#kt_table_1'), context + '/QueryMicro?type=searchAllievo&soggettoattuatore=' + $('#soggettoattuatore').val()
                        + '&cf=' + $('#cf').val() + '&nome=' + $('#nome').val() + '&cognome=' + $('#cognome').val()
                        + '&cpi=' + $('#cpi').val() + '&pregresso=' + $('input[name=pregresso]:checked').val(), );
            }

            function reload() {
                $('html, body').animate({scrollTop: $('#offsetresult').offset().top}, 500);
                reload_table($('#kt_table_1'));
            }

            function showPrg(id) {
                var progetto = prg.get(id);

                var html = "<div class='col-12' style='text-align:left;'>"
                        + "<dl class='row'>"
                        + "<dt class='col-sm-6'><h4><label class='font-weight-bold'>Nome:</label></h4></dt><dd class='col-sm-6'><h4>" + progetto.nome.descrizione + "</h4></dd>"
                        + "<dt class='col-sm-6'><h4><label class='font-weight-bold'>CIP:</label></h4></dt><dd class='col-sm-6'><h4>" + checknullField(progetto.cip) + "</h4></dd>"
                        + "<dt class='col-sm-6'><h4><label class='font-weight-bold'>Ore:</label></h4></dt><dd class='col-sm-6'><h4>" + progetto.ore + "</h4></dd>"
                        + "<dt class='col-sm-6'><h4><label class='font-weight-bold'>Inizio:</label></h4></dt><dd class='col-sm-6'><h4>" + formattedDate(new Date(progetto.start)) + "</h4></dd>"
                        + "<dt class='col-sm-6'><h4><label class='font-weight-bold'>Fine:</label></h4></dt><dd class='col-sm-6'><h4>" + formattedDate(new Date(progetto.end)) + "</h4></dd>"
                        + "<dt class='col-sm-6'><h4><label class='font-weight-bold'>Sog. Attuatore:</label></h4></dt><dd class='col-sm-6'><h4>" + progetto.soggetto.ragionesociale + "</h4></dd>"
                        + "<dt class='col-sm-6'><h4><label class='font-weight-bold'>Stato:</label></h4></dt><dd class='col-sm-6'><h4>" + progetto.stato.descrizione + "</h4></dd>"
                        + "</dl>";
                +"</div>";

                fastSwalShow(html, "bounceInUp");
            }

            var registri = new Map();
            var registri_aula = new Map();
            function swalDocumentAllievo(idallievo) {
                $("#prg_docs").empty();
                var giorno;
                var doc_registro_aula = getHtml("documento_registro", context);
                var doc_prg = getHtml("documento_prg", context);
                $.get(context + "/QueryMicro?type=getDocAllievo&idallievo=" + idallievo, function (resp) {
                    var json = JSON.parse(resp);
                    for (var i = 0; i < json.length; i++) {
                        registri.set(json[i].id, json[i]);
                        giorno = json[i].giorno !== null ? " del " + formattedDate(new Date(json[i].giorno)) : "";
                        if (json[i].giorno !== null) {
                            registri_aula.set(json[i].id, json[i]);
                            $("#prg_docs").append(doc_registro_aula.replace("@href", context + "/OperazioniGeneral?type=showDoc&path=" + json[i].path)
                                    .replace("@func", "showRegistro(" + json[i].id + ")")
                                    .replace("@nome", json[i].tipo.descrizione + giorno));
                        } else {
                            $("#prg_docs").append(doc_prg.replace("@href", context + "/OperazioniGeneral?type=showDoc&path=" + json[i].path)
                                    .replace("#ex", json[i].tipo.estensione.id)
                                    .replace("@nome", json[i].tipo.descrizione + giorno));
                        }
                    }
                    $('#doc_modal').modal('show');
                });
            }

            function showRegistro(idregistro) {

                var registro = registri.get(idregistro);
                var doc_registro = "";
                if (registro.orariostart_pom !== null) {
                    doc_registro = getHtml("doc_registro_individiale_pomeriggio", context);
                    doc_registro = doc_registro.replace("@start_pome", formattedTime(registro.orariostart_pom).replace(":0", ":00"))
                            .replace("@end_pome", formattedTime(registro.orarioend_pom).replace(":0", ":00"));
                } else {
                    doc_registro = getHtml("doc_registro_individiale_mattina", context);
                }
                doc_registro = doc_registro.replace("@start_pome", formattedTime(registro.orariostart_pom).replace(":0", ":00"))
                        .replace("@date", formattedDate(new Date(registro.giorno)))
                        .replace("@docente", registro.docente.cognome + " " + registro.docente.nome)
                        .replace("@start_mattina", formattedTime(registro.orariostart_mattina).replace(":0", ":00"))
                        .replace("@end_mattina", formattedTime(registro.orarioend_mattina).replace(":0", ":00"))
                        .replace("@tot_ore", calculateHoursRegistro(registro.orariostart_mattina, registro.orarioend_mattina, registro.orariostart_pom, registro.orarioend_pom));
                swal.fire({
                    title: 'Informazioni Registro',
                    html: doc_registro,
                    animation: false,
                    showCancelButton: false,
                    showConfirmButton: false,
                    showCloseButton: true,
                    customClass: {
                        popup: 'animated bounceInUp',
                        container: 'my-swal'
                    }
                });
            }
            
            //NOTE 16-08-2021
            function getNoteAllievo(idallievo) {
                var notes = "";
                $.ajax({
                    type: "POST",
                    async: false,
                    url: context + '/QueryMicro?type=searchNoteAllievo&idallievo=' + idallievo,
                    success: function (data) {
                        notes = data;
                    },
                    error: function () {
                        notes = "";
                    }
                });
                return notes;
            }

            function swalNoteAllievo(idallievo) {
                var html = "";
                var notes = getNoteAllievo(idallievo);
                html = "<div class='form-group' id='swal_notes'>"
                        + "<label>Note:</label>"
                        + "<textarea class='form-control obbligatory' maxlength='500' rows='6' id='new_notes' name='notes' style='white-space: pre-wrap;'>" + notes + "</textarea>"
                        + "</div>";
                swal.fire({
                    title: '<h2 class="kt-font-io-n"><b>Modifica / Visualizza Note Allievo:</b></h2><br>',
                    html: html,
                    animation: false,
                    showCancelButton: true,
                    confirmButtonText: '&nbsp;<i class="la la-check"></i>',
                    cancelButtonText: '&nbsp;<i class="la la-close"></i>',
                    cancelButtonClass: "btn btn-io-n",
                    confirmButtonClass: "btn btn-io",
                    customClass: {
                        popup: 'animated bounceInUp'
                    },
                    preConfirm: function () {
                        var err = false;
                        err = checkObblFieldsContent($('#swal_notes')) ? true : err;
                        if (!err) {
                            return new Promise(function (resolve) {
                                resolve({
                                    "notes": $('#new_notes').val()
                                });
                            });
                        } else {
                            return false;
                        }
                    }
                }).then((result) => {
                    if (result.value) {
                        salvanote(idallievo, result.value);
                    } else {
                        swal.close();
                    }
                });
            }

            function salvanote(idallievo, result) {
                showLoad();
                $.ajax({
                    type: "POST",
                    url: context + '/OperazioniMicro?type=salvaNoteAllievo&idallievo=' + idallievo,
                    data: result,
                    success: function (data) {
                        closeSwal();
                        var json = JSON.parse(data);
                        if (json.result) {
                            swalSuccess("Allievo Modificato", "Note allievo salvate con successo.");
                        } else {
                            swalError("Errore", json.message);
                        }
                    },
                    error: function () {
                        swalError("Errore", "Non è stato possibile salvare le note per questo allievo.");
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