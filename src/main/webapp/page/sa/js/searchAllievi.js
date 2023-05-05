/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var prg1 = new Map();
var context = document.getElementById("searchAllievi").getAttribute("data-context");
$.getScript(context + '/page/partialView/partialView.js', function () {});

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
//            responsive: true,
            searchDelay: 500,
            ScrollX: "true",
            sScrollXInner: "110%",
            processing: true,
            pageLength: 10,
            ajax: context + '/QuerySA?type=searchAllievi&nome=' + $('#nome').val()
                    + '&cognome=' + $('#cognome').val() + '&cf=' + $('#cf').val() + '&stato=' + $('input[name=stato]:checked').val() + '&cpi=' + $('#cpi').val(),
            order: [],
            columns: [
                {defaultContent: ''},
                {data: 'allievo',
                    className: 'text-center',
                    render: function (data, type, row) {
                        return row.nome + ' ' + row.cognome;
                    }},
                {data: 'codicefiscale', className: 'text-center'},
                {data: 'datanascita',
                    className: 'text-center',
                    type: 'date-it',
                    render: function (data, type, row) {
                        return moment(row.datanascita).format("DD/MM/YYYY");
                    }},
                {data: 'residenza',
                    className: 'text-center',
                    render: function (data, type, row) {
                        return row.comune_residenza.nome + ' (' + row.comune_residenza.provincia + '),<br>' + row.indirizzoresidenza + ' ' + row.civicoresidenza;
                    }},
                {data: 'domicilio',
                    className: 'text-center',
                    render: function (data, type, row) {
                        return row.comune_domicilio.nome + ' (' + row.comune_domicilio.provincia + '),<br>' + row.indirizzodomicilio + ' ' + row.civicodomicilio;
                    }},
                {data: 'titoloStudio.descrizione', className: 'text-center'},
                {data: 'iscrizionegg',
                    className: 'text-center',
                    type: 'date-it',
                    render: function (data, type, row) {
                        return moment(row.iscrizionegg).format("DD/MM/YYYY");
                    }},
                {data: 'cpi.descrizione'},
                {data: 'stato',
                    className: 'text-center',
                    render: function (data, type, row) {
                        if (row.stato == 'A') {
                            return 'Attivo';
                        } else if (row.stato == 'D')
                            return 'Disattivo';
                    }
                },
                {data: 'protocollo', className: 'text-center'},
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
                                + '   <i class="flaticon-more-1"></i>'
                                + '</button>'
                                + '<div class="dropdown-menu dropdown-menu-left">';
                        option += '<a class="dropdown-item" href="javascript:void(0);" onclick="swalDocumentAllievo(' + row.id + ')"><i class="fa fa-file-alt"></i> Visualizza Documenti</a>';
                        if (new Date(row.scadenzadocid) <= new Date()) {
                            option += '<a class="dropdown-item" href="javascript:void(0);" onclick="rinnovoCartaID(' + row.id + ');">' +
                                    '<i class="fa fa-exclamation" style="color:#b30000"></i><i class="fa fa-id-card" style="color:#b30000"></i> Carica nuovo documento d\'identità</a>';
                        }
                        option += '<a class="dropdown-item fancyBoxAntoRef" href="' + context + '/redirect.jsp?page=page/sa/updtAllievo.jsp?id=' + row.id + '"><i class="fa fa-user-edit"></i> Scheda Allievo</a>'
                        if (row.progetto != null) {
                            prg1.set(row.progetto.id, row.progetto);
                            option += '<a class="dropdown-item" href="javascript:void(0);" onclick="swalTableProgFormativo(' + row.progetto.id + ')"><i class="fa fa-file-alt"></i> Visualizza Progetto Formativo</a>'
                        }
                        option += '</div></div>';
                        return option;
                    }
                },
                {
                    targets: 9,
                    orderable: false,
                }, {
                    targets: 11,
                    className: 'text-center',
                    orderable: false,
                    render: function (data, type, row, meta) {
                        var option = '<a href="' + context + '/OperazioniGeneral?type=showDoc&path=' + row.docid + '" class="btn btn-io fa fa-address-card fancyDocument" style="font-size: 20px;"'
                                + 'data-container="body" data-html="true" data-toggle="kt-tooltip"'
                                + 'data-placement="top" title="<h6>Scadenza:</h6><h5>' + formattedDate(new Date(row.scadenzadocid)) + '</h5>"></a>'
                        if (new Date(row.scadenzadocid) <= new Date()) {
                            option = '<a href="' + context + '/OperazioniGeneral?type=showDoc&path=' + row.docid + '" class="btn btn-io-n fancyDocument" style="font-size: 20px"'
                                    + 'data-container="body" data-html="true" data-toggle="kt-tooltip"'
                                    + 'data-placement="top" title="<h6>Scadenza:</h6><h5>' + formattedDate(new Date(row.scadenzadocid)) + '</h5>">&nbsp;<i class="fa fa-exclamation-triangle"></i></a>'
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
//            $('.dataTables_length').addClass('bs-select');
        },
    };
}();

jQuery(document).ready(function () {
    KTDatatablesDataSourceAjaxServer.init();
    $('.kt-scroll').each(function () {
        const ps = new PerfectScrollbar($(this)[0]);
    });
    $('.kt-scroll-x').each(function () {
        const ps = new PerfectScrollbar($(this)[0],{suppressScrollY:true});
    });
});


function refresh() {
    $("#toolbar").css("display", "none");
    $('html, body').animate({scrollTop: $('#offsetresult').offset().top}, 500);
    load_table($('#kt_table_1'), context + '/QuerySA?type=searchAllievi&nome=' + $('#nome').val()
            + '&cognome=' + $('#cognome').val() + '&cf=' + $('#cf').val() + '&stato=' + $('input[name=stato]:checked').val() + '&cpi=' + $('#cpi').val());
}

function reload() {
    reload_table($('#kt_table_1'));
}

var formCartaId;

function rinnovoCartaID(id) {
    swal.fire({
        title: 'Nuovo documento d\'identità',
        html: "<form id='formCartaId' action='" + context + "/OperazioniSA?type=updtCartaID&id=" + id + "' method='post' enctype='multipart/form-data'>"
                + "<div class='custom-file'>"
                + "<input type='file' class='custom-file-input' accept='application/pdf' name='cartaid' id='cartaid'>"
                + "<label class='custom-file-label selected' id='label_file'>Seleziona File</label>"
                + "</div>"
                + "<div><br><input class='form-control dp' id='datascadenza' name='datascadenza' placeholder='Data scadenza'><br></div>"
                + "<div id='preview-image' style='display:none'></div>"
                + "</form>",
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

            $('#cartaid').on('change', function () {
                ctrlPdf($('#cartaid'));
            })
            $('input.dp').datepicker({
                rtl: KTUtil.isRTL(),
                orientation: "bottom left",
                templates: {
                    leftArrow: '<i class="la la-angle-left"></i>',
                    rightArrow: '<i class="la la-angle-right"></i>'
                },
                todayHighlight: true,
                autoclose: true,
                format: 'dd/mm/yyyy',
                startDate: new Date(),
            });
        },
        preConfirm: function () {
            var docid = $('#cartaid');
            var data = $('#datascadenza');
            var err = false;
            err = (!ctrlPdf(docid) || !checkFileDim()) ? true : err;
            err = checkValue(data, false) ? true : err;
            if (!err) {
                return new Promise(function (resolve) {
                    formCartaId = $('#formCartaId');
                    resolve([
                        docid.val(),
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
            formCartaId.ajaxSubmit({
                success: function (data) {
                    closeSwal();
                    var json = JSON.parse(data);
                    if (json.result) {
                        reload_table($('#kt_table_1'));
                        swal.fire({
                            "title": 'Successo',
                            "text": "Documento d'identità aggiornata con successo",
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

function swalTableProgFormativo(id) {
    var progetto = prg1.get(id);

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

//function swalDocumentAllievo(idallievo) {
//    $("#prg_docs").empty();
//    $.get(context + "/QuerySA?type=getDocAllievo&idallievo=" + idallievo, function (resp) {
//        var json = JSON.parse(resp);
//        var scadenza;
//        for (var i = 0; i < json.length; i++) {
//            scadenza = json[i].scadenza != null ? "<br>scad. " + formattedDate(new Date(json[i].scadenza)) : "";
//            scadenza = json[i].tipo.id == 5 ? "<br>del " + formattedDate(new Date(json[i].giorno)) : scadenza;
//            $("#prg_docs").append("<div class='col-lg-2 col-md-4 col-sm-6'><a target='_blank' href='" + context + "/OperazioniGeneral?type=showDoc&path=" + json[i].path + "' class='btn-icon kt-font-io document'>"
//                    + "<i class='fa fa-file-pdf' style='font-size: 100px;'></i></a>"
//                    + "<h5 class='kt-font-io-n'>" + json[i].tipo.descrizione + scadenza + "</h5></div>");
//        }
//        $('#doc_modal').modal('show');
//    });
//}

var registri = new Map();
var registri_aula = new Map();
function swalDocumentAllievo(idallievo) {
    $("#prg_docs").empty();
    var giorno;
    var doc_registro_aula = getHtml("documento_registro", context);
    var doc_prg = getHtml("documento_prg", context);
    $.get(context + "/QuerySA?type=getDocAllievo&idallievo=" + idallievo, function (resp) {
        var json = JSON.parse(resp);
        for (var i = 0; i < json.length; i++) {
            registri.set(json[i].id, json[i]);
            giorno = json[i].giorno != null ? " del " + formattedDate(new Date(json[i].giorno)) : "";

            if (json[i].giorno != null) {
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
    var doc_registro;
    if (registro.orariostart_pom != null) {
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
            .replace("@tot_ore", calculateHoursRegistro(registro.orariostart_mattina, registro.orarioend_mattina, registro.orariostart_pom, registro.orarioend_pom).replace(":0", ":00"));
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
