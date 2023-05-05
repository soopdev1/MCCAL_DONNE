/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var context = document.getElementById("searchProgettiFormativi").getAttribute("data-context");
$.getScript(context + '/page/partialView/partialView.js', function () {});
var ore_max_daily = document.getElementById("ore_max").getAttribute("data-context");
var KTDatatablesDataSourceAjaxServer = function () {
    var initTable1 = function () {
        var table = $('#kt_table_1');
        table.DataTable({
            dom: `<'row'<'col-sm-12'ftr>><'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
            lengthMenu: [5, 10, 25, 50],
            language: {
                "lengthMenu": "Mostra _MENU_",
                "infoEmpty": "Mostrati 0 di 0 per 0",
                "loadingRecords": "Caricamento...",
                "search": "Cerca:",
                "zeroRecords": "Nessun risultato trovato",
                "info": "Mostrati _START_ di _TOTAL_ ",
                "emptyTable": "Nessun risultato",
                "sInfoFiltered": "(filtrato su _MAX_ risultati totali)"
            },
//            responsive: true,
            ScrollX: "100%",
            sScrollXInner: "110%",
            searchDelay: 500,
            processing: true,
            pageLength: 10,
            ajax: context + '/QuerySA?type=searchProgetti&cip=' + $('#cip').val()
                    + '&stato=' + $('#stato').val(),
            order: [],
            columns: [
                {defaultContent: ''},
                {data: 'id',
                    className: 'text-center'},
                {data: 'descrizione',
                    className: 'text-center'},
                {data: 'misto',
                    className: 'text-center',
                    render: function (data, type, row) {
                        if (row.misto) {
                            if (row.cip_misto === null) {
                                return "SI";
                            } else {
                                return "SI<br>(" + row.cip_misto + ")";
                            }
                        } else {
                            return "NO";
                        }
                    }},
                {data: 'ore',
                    className: 'text-center'},
                {data: 'start',
                    className: 'text-center'},
                {data: 'end',
                    className: 'text-center'},
                {data: 'cip',
                    className: 'text-center'},
                {data: 'soggetto.ragionesociale',
                    className: 'text-center'},
                {data: 'stato.descrizione',
                    className: 'text-center'},
                {data: 'motivo',
                    className: 'text-center'},
                {data: 'stato.de_tipo',
                    className: 'text-center'}
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
                        option += '<a class="dropdown-item" href="javascript:void(0);" onclick="swalTableAllievi(' + row.id + ')"><i class="flaticon-users-1"></i> Visualizza Allievi</a>';
                        option += '<a class="dropdown-item" href="javascript:void(0);" onclick="swalTableDocenti(' + row.id + ')"><i class="fa fa-chalkboard-teacher"></i> Visualizza Docenti</a>';
                        option += '<a class="dropdown-item" href="javascript:void(0);" onclick="swalDocumentPrg(' + row.id + ')"><i class="fa fa-file-alt"></i> Visualizza Documenti</a>';
                        if (row.stato.controllare === 0) {
                            if (row.stato.modificabile === 1) {
                                option += '<a class="dropdown-item fancyBoxAntoRef" href="modifyProgetto.jsp?id=' + row.id + '"><i class="fa fa-pencil-alt"></i> Modifica</a>';
                            }
                            if (row.stato.modifiche.docenti === 1) {
                                option += '<a class="dropdown-item fancyBoxAntoRef" href="modifyDocentiProgetto.jsp?id=' + row.id + '"><i class="fas fa-user-edit"></i> Modifica Docenti</a>';
                            }
                            if (row.stato.id === "FA" || row.stato.id === "FB" || row.stato.id === "FBE" || row.stato.id === "CE") {
                                option += '<a class="dropdown-item fancyBoxReload" href="uploadRegistroAula.jsp?id=' + row.id + '" ><i class="flaticon2-calendar-6"></i> Carica Registro d\'Aula</a>';
                            }
                            if (row.stato.modifica_doc === 1) {
                                option += '<a class="dropdown-item fancyBoxAntoRef" href="uploadDocumet.jsp?id=' + row.id + '" ><i class="fa fa-file-upload"></i> Modifica/Carica Doc.</a>';
                            }
                            if (row.controllable === 1) {
                                option += '<a class="dropdown-item kt-font-success" href="javascript:void(0);" onclick="confirmNext(' + row.id + ',\'' + row.stato.id + '\')"> Manda avanti la pratica &nbsp;<i class="fa fa-angle-double-right kt-font-success" style="margin-top:-2px"></i></a>';
                            }
                        }
                        if (row.fadroom !== null) {

                            for (var x1 = 0; x1 < row.fadroom.length; x1++) {
                                var formnuovo = '<form target="_blank" id="frfad_' + row.fadroom[x1].nomestanza + '" method="post" action="' + row.fadlink + '">' +
                                        '<input type="hidden" name="type" value="login_fad_mc_multi"/> ' +
                                        '<input type="hidden" name="roomname" value="' + row.fadroom[x1].nomestanza + '"/> ' +
                                        '<input type="hidden" name="corso" value="' + row.fadroom[x1].numerocorso + '"/> ' +
                                        '<input type="hidden" name="codfisc" value="' + row.usermc + '"/> ' +
                                        '<input type="hidden" name="progetto" value="' + row.id + '"/> ' +
                                        '<input type="hidden" name="view" value="2"/> ' +
                                        '</form>';
                                option += '<a class="dropdown-item" href="javascript:void(0);" onclick="return document.getElementById(\'frfad_' + row.fadroom[x1].nomestanza +
                                        '\').submit();"><i class="fa fa-video" style="margin-top:-2px"></i>Apri FAD - CORSO ' + row.fadroom[x1].numerocorso + '</a>' + formnuovo;
                            }


                            if (row.fadreport) {
                                var formapriexc = '<form target="_blank" id="frexc_' + row.id + '" method="post" action="../../OperazioniGeneral">' +
                                        '<input type="hidden" name="type" value="excelfad"/> ' +
                                        '<input type="hidden" name="idpr" value="' + row.id + '"/> ' +
                                        '<input type="hidden" name="roomname" value="' + row.fadroom + '"/> ' +
                                        '</form>';

                                option += '<a class="dropdown-item" href="javascript:void(0);" onclick="return document.getElementById(\'frexc_' + row.id + '\').submit();"><i class="fa fa-file-excel" style="margin-top:-2px"></i>Scarica Registro FAD</a>' + formapriexc;
                            }
                        }

                        option += '</div></div>';
                        return option;
                    }
                }
                , {
                    targets: 4,
                    title: "ORE FASE A",
                    render: function (data, type, full) {
                        return data.toFixed(2);
                    }
                }
                , {
                    targets: 5,
                    type: 'date-it',
                    render: function (data, type, row, meta) {
                        return formattedDate(new Date(data));
                    }
                }, {
                    targets: 6,
                    type: 'date-it',
                    render: function (data, type, row, meta) {
                        return formattedDate(new Date(data));
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

function refresh() {
    $('html, body').animate({scrollTop: $('#offsetresult').offset().top}, 500);
    load_table($('#kt_table_1'), context + '/QuerySA?type=searchProgetti&cip=' + $('#cip').val()
            + '&stato=' + $('#stato').val(), );
}

function reload() {
    $('html, body').animate({scrollTop: $('#kt_table_1').offset().top}, 500);
    reload_table($('#kt_table_1'));
}

var DatatablesAllievi = function () {
    var initTableAllievi = function () {
        var table = $('#kt_table_allievi');
        table.DataTable({
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
//            scrollY: "40vh",
//                        ajax: context + '/QueryMicro?type=searchAllieviProgetti&idprogetto=' + idprogetto,
            order: [],
            columns: [
                {defaultContent: ''},
                {data: 'nome'},
                {data: 'cognome'},
                {data: 'codicefiscale'},
                {data: 'datanascita'},
                {data: 'comune_domicilio'},
            ],
            drawCallback: function () {
                $('[data-toggle="kt-tooltip"]').tooltip();
            },
            columnDefs: [
                {
                    targets: 0,
                    className: 'text-center',
                    orderable: false,
                    render: function (data, type, row, meta) {
                        var sp;
                        var option = '<div class="dropdown dropdown-inline">'
                                + '<button type="button" class="btn btn-icon btn-sm btn-icon-md btn-circle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">'
                                + '   <i class="flaticon-more-1"></i>'
                                + '</button>'
                                + '<div class="dropdown-menu dropdown-menu-left">';
                        option += '<a class="dropdown-item" href="javascript:void(0);" onclick="swalDocumentAllievo(' + row.id + ')"><i class="fa fa-file-alt"></i> Visualizza Documenti</a>';

                        if (row.statopartecipazione.id == "01") {
                            if (row.progetto.stato.controllare == 0) {
                                option += '<a class="dropdown-item " href="javascript:void(0);" onclick="swalSigma(' + row.id + ',\'' + row.statopartecipazione.id + '\')"><i class="fa fa-user-check kt-font-success" data-container="body" data-html="true" data-toggle="kt-tooltip" title="Stato ' + row.statopartecipazione.descrizione + '"></i>Cambia stato di partecipazione</a>';
                                if (row.progetto.stato.id == "FA") {
                                    if (row.esito == "Fase A") {
                                        option += '<a class="dropdown-item " href="javascript:void(0);" onclick="setEsito(' + row.id + ',\'Fase B\')"><i class="fa fa-check-circle kt-font-io"></i>Continua alla Fase B</a>';
                                    } else if (row.esito == "Fase B") {
                                        option += '<a class="dropdown-item " href="javascript:void(0);" onclick="setEsito(' + row.id + ',\'Fase A\')"><i class="fa fa-check-circle kt-font-io-n"></i>Ferma alla Fase A</a>';
                                    }
                                } else if (row.progetto.stato.id == "FB") {
                                    if (row.esito == "Fase A") {
                                        option += '<a class="dropdown-item "><i class="fa fa-check-circle kt-font-io"></i>Non assegnato alla Fase B</a>';
                                    } else if (row.esito == "Fase B") {
                                        option += '<a class="dropdown-item " href="javascript:void(0);" style="pointer-events: none;cursor: default;"><i class="fa fa-check-circle kt-font-io-n"></i>Assegnato alla Fase B</a>';
                                        option += '<a class="dropdown-item" href="javascript:void(0);" onclick="uploadRegistro(' + row.id + ',' + row.progetto.id + ',' + row.progetto.end_fa + ')" ><i class="flaticon-list"></i> Carica Registro giornaliero</a>';
                                    }
                                } else if (row.progetto.stato.id == "FBE") {
                                    if (row.esito == "Fase A") {
                                        option += '<a class="dropdown-item "><i class="fa fa-check-circle kt-font-io"></i>Non assegnato alla Fase B</a>';
                                    } else if (row.esito == "Fase B") {
                                        option += '<a class="dropdown-item " href="javascript:void(0);" style="pointer-events: none;cursor: default;"><i class="fa fa-check-circle kt-font-io-n"></i>Assegnato alla Fase B</a>';
                                        option += '<a class="dropdown-item" href="javascript:void(0);" onclick="uploadRegistro(' + row.id + ',' + row.progetto.id + ',' + row.progetto.end_fa + ')" ><i class="flaticon-list"></i> Carica Registro giornaliero</a>';
                                    }
                                }

//                                if (row.esito == "Fase A") {
//                                    option += '<a class="dropdown-item " href="javascript:void(0);" onclick="setEsito(' + row.id + ',\'Fase B\')"><i class="fa fa-check-circle kt-font-io"></i>Continua alla Fase B</a>';
//                                } else if (row.esito == "Fase B") {
//                                    option += '<a class="dropdown-item " href="javascript:void(0);" style="pointer-events: none;cursor: default;"><i class="fa fa-check-circle kt-font-io-n"></i>Assegnato alla Fase B</a>';
//
//                                }
                                option += '<a class="dropdown-item fancyBoxAntoRef" href="uploadRegistri.jsp?id=' + row.id + '" ><i class="fa fa-file-upload"></i> Modifica/Carica Doc.</a>';
                            }
                        } else {
                            option += '<a class="dropdown-item " href="javascript:void(0);" style="pointer-events: none;cursor: default;"><i class="fa fa-user-times kt-font-danger"></i>' + row.statopartecipazione.descrizione + '</a>';
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
                }, {
                    targets: 5,
                    className: 'text-center',
                    orderable: false,
                    render: function (data, type, row, meta) {
                        return row.comune_domicilio.nome + " (" + row.comune_domicilio.provincia + "),<br> " + row.indirizzodomicilio + " " + row.civicodomicilio;
                    }
                }]
        });
    };
    return {
        init: function () {
            initTableAllievi();
        }
    };
}();

function swalTableAllievi(idprogetto) {
    clear_table($('#kt_table_allievi'));
    load_table($('#kt_table_allievi'), context + '/QuerySA?type=searchAllieviProgetti&idprogetto=' + idprogetto);
    $('#allievi_table').modal('show');
    $('#allievi_table').on('shown.bs.modal', function () {
        $('.kt-scroll').each(function () {
            const ps = new PerfectScrollbar($(this)[0]);
        });
        $('#kt_table_allievi').DataTable().columns.adjust();
    });
}

jQuery(document).ready(function () {
    KTDatatablesDataSourceAjaxServer.init();
    DatatablesAllievi.init();
    $('.kt-scroll').each(function () {
        const ps = new PerfectScrollbar($(this)[0]);
    });
    $('.kt-scroll-x').each(function () {
        const ps = new PerfectScrollbar($(this)[0], {suppressScrollY: true});
    });
});

function swalTableDocenti(idprogetto) {
    swal.fire({
        html: '<table class="table table-bordered" id="kt_table_docenti">'
                + '<thead>'
                + '<tr>'
                + '<th class="text-uppercase text-center">Nome</th>'
                + '<th class="text-uppercase text-center">Cognome</th>'
                + '<th class="text-uppercase text-center">Codice Fiscale</th>'
                + '<th class="text-uppercase text-center">Data Nascita</th>'
                + '</tr>'
                + '</thead>'
                + '</table>',
        width: '95%',
        scrollbarPadding: true,
        showCloseButton: true,
        showCancelButton: false,
        showConfirmButton: false,
        animation: false,
        customClass: {
            popup: 'animated bounceInDown'
        },
        onOpen: function () {
            $("#kt_table_docenti").DataTable({
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
                ajax: context + '/QuerySA?type=searchDocentiProgetti&idprogetto=' + idprogetto,
                order: [],
                columns: [
                    {data: 'nome'},
                    {data: 'cognome'},
                    {data: 'codicefiscale'},
                    {data: 'datanascita'}
                ],
                columnDefs: [
                    {
                        targets: 3,
                        type: 'date-it',
                        render: function (data, type, row, meta) {
                            return formattedDate(new Date(row.datanascita));
                        }
                    }]
            });
        }
    });
}

var registri_aula = new Map();
function swalDocumentPrg(idprogetto) {
    $("#prg_docs").empty();
    $.get(context + "/QuerySA?type=getDocPrg&idprogetto=" + idprogetto, function (resp) {
        var json = JSON.parse(resp);
        var docente;
        var scadenza;
        var giorno;
        var doc_prg = getHtml("documento_prg", context);
        var doc_registro_aula = getHtml("documento_registro", context);
        var registri = [];
        $.each(json, function (i, j) {
            docente = j.docente !== null ? " " + j.docente.nome + " " + j.docente.cognome : "";
            scadenza = j.scadenza !== null ? "<br>scad. " + formattedDate(new Date(j.scadenza)) : "";
            giorno = j.giorno !== null ? " del " + formattedDate(new Date(j.giorno)) + "<br> Docente: " : "";
            if (j.giorno !== null) {
                registri.push(j);
            } else if (j.tipo.visible_sa === 1) {
                $("#prg_docs").append(doc_prg.replace("@href", context + "/OperazioniGeneral?type=showDoc&path=" + j.path)
                        .replace("#ex", j.tipo.estensione.id)
                        .replace("@nome", j.tipo.descrizione + docente + scadenza));
            }
        });
        if (registri.length > 0) {
            $("#prg_docs").append("<div class='col-12 form-group text-left text-dark'><h3>Registri</h3></div><br>");
            $.each(registri, function (i, j) {
                docente = j.docente !== null ? " " + j.docente.nome + " " + j.docente.cognome : "";
                giorno = j.giorno !== null ? " del " + formattedDate(new Date(j.giorno)) + "<br> Docente: " : "";
                registri_aula.set(j.id, j);
                $("#prg_docs").append(doc_registro_aula.replace("@func", "showRegistroAula(" + j.id + "," + j.progetto.stato.errore + "," + idprogetto + ")")
                        .replace("@nome", j.tipo.descrizione + giorno + docente)
                        .replace("#color", "io"));
            });
        }
        $('#doc_modal').modal('show');
        $('[data-toggle="kt-tooltip"]').tooltip();
        $('.kt-scroll').each(function () {
            const ps = new PerfectScrollbar($(this)[0]);
        });
    });
}

var registri = new Map();
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
                $("#prg_docs").append(doc_registro_aula.replace("@func", "showRegistro(" + json[i].id + ")")
                        .replace("@nome", json[i].tipo.descrizione + giorno));
            } else {
                $("#prg_docs").append(doc_prg.replace("@href", context + "/OperazioniGeneral?type=showDoc&path=" + json[i].path)
                        .replace("#ex", json[i].tipo.estensione.id)
                        .replace("@nome", json[i].tipo.descrizione + giorno));
            }
        }
        $('#doc_modal').modal('show');
        $('.kt-scroll').each(function () {
            const ps = new PerfectScrollbar($(this)[0]);
        });
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

function confirmNext(id, stato) {
    var msg = "Sicuro di voler inviare a controllo il Progetto Formativo?";
    if (stato === 'FA') {
        msg += "<br><br><b class='kt-font-danger'>Stai per terminare la FASE A.<br>&Egrave; necessario selezionare tutti gli allievi che accederanno alla FASE B; in caso contrario, non potranno essere caricati i registri individuali per gli allievi."
                + "<br><br>Inoltre, una volta terminata La FASE A, non potranno essere caricati altri registri relativi ad essa.</b>"
                + "<br>";
    } else if (stato === 'FB') {
        msg += "<br><br><b class='kt-font-danger'>Stai per terminare la FASE B.<br>"
                + "Inoltre, una volta terminata La FASE B, non potranno essere caricati altri registri individuali relativi ad essa.</b>"
                + "<br><br><b>Ti ricordiamo che non potranno essere effettuate modifiche fino ad avvenuto controllo da parte dell'ente Microcredito.</b>";
    } else {
        msg += "<br><br><b>Ti ricordiamo che non potranno essere effettuate modifiche fino ad avvenuto controllo da parte dell'ente Microcredito.</b>";
    }

    swalConfirm("Conferma Invio Progetto", msg, function goNext() {
        showLoad();
        $.ajax({
            type: "POST",
            url: context + '/OperazioniSA?type=goNext&id=' + id,
            success: function (data) {
                closeSwal();
                var json = JSON.parse(data);
                if (json.result) {
                    swalSuccess("Progetto inviato", "Progetto inviato con successo al controllo del Microcredito");
                    reload();
                } else {
                    swalError("Errore", json.message);
                }
            },
            error: function () {
                swalError("Errore", "Non è stato possibile inviare il progetto a controllo");
            }
        });
    });
}

function setEsito(id, esito) {

    swalConfirm('Cambio esito',
            "Sicuro di voler confermare l'esito, <b class='kt-font-danger'>asseganto alla " + esito + "</b>, per il seguente allievo?",
            function setValueEsito() {
                showLoad();
                $.ajax({
                    type: "POST",
                    url: context + '/OperazioniSA?type=setEsitoAllievo&id=' + id + '&esito=' + esito,
                    success: function (data) {
                        closeSwal();
                        var json = JSON.parse(data);
                        if (json.result) {
                            swalSuccess("Esito allievo", "Esito allievo impostato");
                            reload_table($('#kt_table_allievi'));
                        } else {
                            swalError("Errore", json.message);
                        }
                    },
                    error: function () {
                        swalError("Errore", "Non è stato possibile impostare l'esito per l'attuale allievo");
                    }
                });
            });
}

function checkpm() {
    if ($('#check').is(":checked")) {
        $("#orario2_start").removeAttr("disabled");
        $("#orario2_end").removeAttr("disabled");
        $('#div_pm').css("display", "");
    } else {
        $("#orario2_start").attr("disabled", true);
        $("#orario2_end").attr("disabled", true);
        $('#div_pm').css("display", "none");
    }
}

function remainingHH(total) {
    var hh20 = 20;
    return (hh20 - total);
}

function checkTotalHH(m_s, m_e, p_s, p_e, check, totalms) {
    var err = false;
    var msg = "";
    var hhregistro;
    hhregistro = new Date('00', '00', '00', m_e.split(':')[0], m_e.split(':')[1]).getTime() - new Date('00', '00', '00', m_s.split(':')[0], m_s.split(':')[1]).getTime();
    if (check) {
        hhregistro += new Date('00', '00', '00', p_e.split(':')[0], p_e.split(':')[1]).getTime() - new Date('00', '00', '00', p_s.split(':')[0], p_s.split(':')[1]).getTime();
    }

    if ((hhregistro / 3600000) > remainingHH(totalms)) {
        err = true;
        msg = "Attenzione, il totale delle ore di lezione per la Fase B ha superato le 20 ore.";
    }
    if ((hhregistro / 3600000) > ore_max_daily) {
        err = true;
        msg = "Attenzione, la lezione giornaliera non può superare le 5 ore.";
    }
    if (err) {
        $('#alertmsg').html(msg);
        $('#warning_hh').css("display", "");
        $('input.time').removeClass('is-valid').addClass('is-invalid');
    } else {
        $('#alertmsg').html("");
        $('#warning_hh').css("display", "none");
        $('input.time').removeClass('is-invalid').addClass('is-valid');
    }
    return err ? false : true;
}

function returnTotalHHbyAllievo(idallievo) {
    var totaleore = 0;
    var today = false;
    $.ajax({
        type: "GET",
        async: false,
        url: context + "/OperazioniSA?type=getTotalHoursRegistriByAllievo&idallievo=" + idallievo,
        success: function (resp) {
            var json = JSON.parse(resp);
            if (resp != null)
                totaleore = json.totale;
            today = json.today;
        }
    });
    return [totaleore, today];
}

function uploadRegistro(idallievo, idprogetto, srtartFb) {
    var values = returnTotalHHbyAllievo(idallievo);
    var totalms = values[0];
    var today = values[1];
    if (totalms !== null && totalms < 20) {//&& today == false
        swaluploadRegistro(idallievo, idprogetto, totalms, srtartFb);
    } else if (totalms === 20) {
        swalWarning("Registro Allievo", "Il numero di ore di lezione (20h) è stato raggiunto.<br>È possibile comunque modificare nell'apposita sezione i registri caricati precedentemente.");
    }
//    else if (today == true) {
//        swalWarning("Registro Allievo", "Il registro di oggi è già stato caricato.<br>È possibile comunque modificarlo dall'apposita sezione.");
//    }
}

function swaluploadRegistro(idallievo, idprogetto, totalms, srtartFb) {//swalReg
    srtartFb = srtartFb == null ? 0 : srtartFb;
    swal.fire({
        title: 'Carica Registro',
        html: getHtml("swalReg", context),
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
            $('#orario1_start').val('8:00');
            $('#orario1_end').val($('#orario1_start').val());
            $('#orario2_start').val('14:00');
            $('#orario2_end').val('21:00');
            $('#giorno').val(formattedDate(new Date()));
            $("#tot_hh").html('Totale ore di lezione rimanenti (max 20h):&nbsp;<b>' + remainingHH(totalms) + '</b>');
            $('#docente').select2({
                dropdownCssClass: "select2-on-top",
                minimumResultsForSearch: -1
            });
            $.get(context + "/QuerySA?type=getDocentiByPrg&idprogetto=" + idprogetto, function (resp) {
                var json = JSON.parse(resp);
                for (var i = 0; i < json.length; i++) {
                    $("#docente").append('<option value="' + json[i].id + '">' + json[i].cognome + " " + json[i].nome + '</option>');
                }
            });

            $('#orario1_start').change(function (e) {
                $('#orario1_start').val(checktime($('#orario1_start').val(), '8:00', $('#orario1_end').val()));
            });
            $('#orario1_end').change(function (e) {
                $('#orario1_end').val(checktime($('#orario1_end').val(), $('#orario1_start').val(), '15:00'));
            });
            $('#orario2_start').change(function (e) {
                $('#orario2_start').val(checktime($('#orario2_start').val(), $('#orario1_end').val(), $('#orario2_end').val()));
            });
            $('#orario2_end').change(function (e) {
                $('#orario2_end').val(checktime($('#orario2_end').val(), $('#orario2_start').val(), '21:00'));
            });
            $('#giorno').change(function (e) {
                checkRegistroAlievoExist(idallievo, $(this).val());
            });
            $('input.time').timepicker({
                showMeridian: false,
                interval: 5,
                showInputs: false,
                snapToStep: true,
                icons: {
                    up: 'la la-angle-up',
                    down: 'la la-angle-down'
                }
            });

            var arrows = {
                leftArrow: '<i class="la la-angle-left"></i>',
                rightArrow: '<i class="la la-angle-right"></i>'
            };

            $('#giorno').datepicker({
                orientation: "bottom left",
                todayHighlight: true,
                templates: arrows,
                autoclose: true,
                format: 'dd/mm/yyyy',
                endDate: new Date(),
                startDate: new Date(Number(srtartFb))
            });

        },
        preConfirm: function () {
            var err = false;
            err = checkObblFieldsContent($('#swalReg')) ? true : err;
            err = checkRegistroAlievoExist(idallievo, $("#giorno").val()) ? true : err;
            err = !checkTotalHH($('#orario1_start').val(), $('#orario1_end').val(), $('#orario2_start').val(), $('#orario2_end').val(), $('#check').is(":checked"), totalms) ? true : err;
            if (!err) {
                return new Promise(function (resolve) {
                    resolve({
                        "giorno": $('#giorno').val(),
                        "docente": $('#docente').val(),
                        "orario1_start": $('#orario1_start').val(),
                        "orario1_end": $('#orario1_end').val(),
                        "orario2_start": $('#orario2_start').val(),
                        "orario2_end": $('#orario2_end').val(),
                        "check": $('#check').is(":checked")
                    });
                });
            } else {
                return false;
            }
        }
    }).then((result) => {
        if (result.value) {
            showLoad();
            var fdata = new FormData();
            fdata.append("giorno", result.value.giorno);
            fdata.append("docente", result.value.docente);
            fdata.append("orario1_start", result.value.orario1_start);
            fdata.append("orario1_end", result.value.orario1_end);
            fdata.append("orario2_start", result.value.orario2_start);
            fdata.append("orario2_end", result.value.orario2_end);
            fdata.append("check", result.value.check);
            $.ajax({
                type: "POST",
                url: context + '/OperazioniSA?type=uploadRegistro&idallievo=' + idallievo,
                data: fdata,
                processData: false,
                contentType: false,
                success: function (data) {
                    closeSwal();
                    var json = JSON.parse(data);
                    if (json.result) {
                        swalSuccess("Registro Caricato", "Registro caricato con successo." + (json.message = !"" ? "<br>" + json.message : ""));
                    } else {
                        swalError("Errore", json.message);
                    }
                },
                error: function () {
                    swalError("Errore", "Non è stato possibile caricare il registro");
                }
            });
        } else {
            swal.close();
        }
    });
}

function checkRegistroAlievoExist(idallievo, giorno) {
    var presente = false;
    $.ajax({
        async: false,
        type: "post",
        url: context + '/QuerySA?type=checkRegistroAlievoExist',
        data: {"idallievo": idallievo, "giorno": giorno},
        success: function (data) {
            var json = JSON.parse(data);
            if (json !== null) {
                presente = true;
                $('#alertmsg_day').html("Registro già presente per questo giorno");
                $('#warning_day').css("display", "");
                $('#giorno').removeClass('is-valid').addClass('is-invalid');
            } else {
                presente = false;
                $('#alertmsg_day').html("");
                $('#warning_day').css("display", "none");
                $('#giorno').removeClass('is-invalid').addClass('is-valid');
            }
        }
    });
    return presente;
}


function warningSigma() {
    if ($("#sigma").val() !== "-" || $("#sigma").val() !== "01") {
        $('#warning_sp').css("display", "");
        $('#warningmsg').html('Impostando l\'alunno come \'' + $("#sigma option:selected").text() + '\', questo verrà escluso definitivamente.');
    } else {
        $('#warning_sp').css("display", "none");
    }
}

function swalSigma(id, idsp) {
    swal.fire({
        title: 'Stato di partecipazione (Codice SIGMA)',
        html: '<div id="swalDoc">'
                + '<div id="warning_sp" class="form-group kt-font-io-n row col" style="margin-left: 0px;margin-right: 0px; display: none;" ><div class="col-1"><i class="fa fa-exclamation-triangle" style="position: absolute;top: 50%;left: 50%;transform: translate(-50%,-50%);font-size:20px;" ></i></div><div id="warningmsg" class="col-10" ></div><div class="col-1"><i class="fa fa-exclamation-triangle" style="position: absolute;top: 50%;left: 50%;transform: translate(-50%,-50%);font-size:20px;"></i></div></div>'
                + '<div class="select-div" id="sigma_div">'
                + '<select class="form-control kt-select2-general obbligatory" id="sigma" name="sigma"  style="width: 100%" onchange="return warningSigma();">'
                + '<option value="-">Seleziona stato di partecipazione</option>'
                + '</select></div><br>'
                + '</div>',
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
            $('#sigma').select2({
                dropdownCssClass: "select2-on-top",
                minimumResultsForSearch: -1
            });
            $.get(context + "/QuerySA?type=getSIGMA", function (resp) {
                var json = JSON.parse(resp);
                for (var i = 0; i < json.length; i++) {
                    if (json[i].id === idsp) {
                        $("#sigma").append('<option selected value="' + json[i].id + '">' + json[i].descrizione + '</option>');
                    } else {
                        $("#sigma").append('<option value="' + json[i].id + '">' + json[i].descrizione + '</option>');
                    }
                }
            });
        },
        preConfirm: function () {
            var err = false;
            err = checkObblFieldsContent($('#swalDoc')) ? true : err;
            if (!err) {
                return new Promise(function (resolve) {
                    resolve({
                        "sigma": $('#sigma').val()
                    });
                });
            } else {
                return false;
            }
        }
    }).then((result) => {
        if (result.value) {
            setValueStato(id, result.value.sigma);
        } else {
            swal.close();
        }
    }
    );
}

function setValueStato(id, sigma) {
    showLoad();
    $.ajax({
        type: "POST",
        url: context + '/OperazioniSA?type=setSIGMA&id=' + id + '&sigma=' + sigma,
        success: function (data) {
            closeSwal();
            var json = JSON.parse(data);
            if (json.result) {
                swalSuccess("Codice SIGMA", "Stato di partecipazione assegnato correttamente");
                reload_table($('#kt_table_allievi'));
            } else {
                swalError("Errore", json.message);
            }
        },
        error: function () {
            swalError("Errore", "Non è stato possibile impostare lo stato di partecipazione");
        }
    });
}

function showRegistroAula(id, var2, var3) {
    alert(var2);
    alert(var3);
    var registro = registri_aula.get(id);
    var doc = getHtml("doc_registro_aula", context);
    var presenze = getHtml("div_presenza", context);

    $('#register_docs_modal').empty();
    $('#register_docs_modal').append(doc.replace("@date", formattedDate(new Date(registro.giorno)))
            .replace("@start", formattedTime(registro.orariostart).replace(":0", ":00"))
            .replace("@end", formattedTime(registro.orarioend).replace(":0", ":00"))
            .replace("@docente", registro.docente.cognome + " " + registro.docente.nome)
            .replace("@ore", doubletoHHmm(registro.ore))
            .replace("@ore_conv", registro.ore_convalidate === "00:00" ? "" : doubletoHHmm(registro.ore_convalidate))
            .replace("@readonly", "readonly")
            .replace("@presenti",
                    registro.presenti_list.map(p => {
                        return presenze.replace("@nome", p.cognome + " " + p.nome)
                                .replace("@in", formattedTime(p.start).replace(":0", ":00"))
                                .replace("@out", formattedTime(p.end).replace(":0", ":00"))
                                .replace("@ore", doubletoHHmm(p.ore))
                                .replace("@max", p.ore)
                                .replace("@readonly", "readonly")
                                .replace("@ore_riconosciute", p.ore_riconosciute === "00:00" ? "" : doubletoHHmm(p.ore_riconosciute))
                                .replace("@id", p.id);
                    })).split(",").join(""));
    $('#register_modal').modal('show');
}