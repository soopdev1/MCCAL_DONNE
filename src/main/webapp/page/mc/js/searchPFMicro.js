
/* global getHtml, calculateHoursRegistro, formattedTime, KTUtil */

var context = document.getElementById("searchPFMicro").getAttribute("data-context");

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
            searchDelay: 500,
            ScrollX: "100%",
            sScrollXInner: "110%",
            processing: true,
            pageLength: 10,
            ajax: context + '/QueryMicro?type=searchProgetti&soggettoattuatore=' + $('#soggettoattuatore').val() + '&cip=' + $('#cip').val()
                    + '&stato=' + $('#stato').val() + '&rendicontato=' + $('#rendicontato').val(),
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
                {data: 'sede.denominazione',
                    className: 'text-center'},
                {data: 'stato.descrizione',
                    className: 'text-center'},
                {data: 'stato.de_tipo',
                    className: 'text-center'},
                {data: 'rendicontato',
                    className: 'text-center'},
                {data: 'importo',
                    className: 'text-center'},
                {data: 'importo_ente',
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

                        var option = '<div class="dropdown dropdown-inline dropdown-raf">'
                                + '<button type="button" class="btn btn-icon btn-sm btn-icon-md btn-circle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">'
                                + '   <i class="flaticon-more-1"></i>'
                                + '</button>'
                                + '<div class="dropdown-menu dropdown-menu-left">';

                        option += '<a class="dropdown-item" href="javascript:void(0);" onclick="modifyDate(' + row.id + ',' + row.start + ',' + row.end + ',' + row.end_fa + ')"><i class="fa fa-calendar-alt"></i> Modifica Date</a>';
                        option += '<a class="dropdown-item" href="javascript:void(0);" onclick="swalTableAllievi(' + row.id + ')"><i class="flaticon-users-1"></i> Visualizza Allievi</a>';
                        option += '<a class="dropdown-item" href="javascript:void(0);" onclick="swalTableDocenti(' + row.id + ')"><i class="fa fa-chalkboard-teacher"></i> Visualizza Docenti</a>';
                        option += '<a class="dropdown-item" href="javascript:void(0);" onclick="swalDocumentPrg(' + row.id + ')"><i class="fa fa-file-alt"></i> Visualizza Documenti</a>';
                        option += '<a class="dropdown-item" href="javascript:void(0);" onclick="swalTableStory(' + row.id + ')"><i class="fa fa-clipboard-list"></i> Visualizza Storico Progetto</a>';
                        if (row.stato.id === "CL") {
                            option += '<a class="dropdown-item fancyBoxAntoRef" href="checkList2.jsp?id=' + row.id + '" ><i class="fa fa-file-excel"></i> Compila Checklist 2</a>';
                            option += '<a class="dropdown-item fancyBoxAntoRef" href="uploadCL.jsp?id=' + row.id + '" ><i class="fa fa-file-upload"></i> Modifica/Carica Checklist</a>';
                        }
                        
                        if (row.stato.id === "FA") {
                            option += '<a class="dropdown-item fancyBoxAntoRef" href="uploadCL.jsp?id=' + row.id + '" ><i class="fa fa-file-upload"></i> Modifica/Carica Documenti</a>';
                        }
                        
                        if (row.stato.controllare === 1) {
                            option += '<a class="dropdown-item kt-font-success" href="javascript:void(0);" onclick="valitdatePrg(' + row.id
                                    + ',&quot;' + row.stato.id + '&quot;,&quot;' + row.misto + '&quot;)"><i class="fa fa-check kt-font-success" style="margin-top:-2px"></i>Convalida Progetto</a>';
                            option += '<a class="dropdown-item kt-font-danger" href="javascript:void(0);" onclick="rejectPrg(' + row.id + ')"><i class="flaticon2-delete kt-font-danger" style="margin-top:-2px"></i>Segnala Progetto</a>';
                        }
                        
                        if (row.archiviabile === 1) {
                            option += '<a class="dropdown-item kt-font-success" href="javascript:void(0);" onclick="confirmNext(' + row.id + ',\'' + row.stato.id + '\')">Archivia Progetto&nbsp;<i class="fa fa-angle-double-right kt-font-success" style="margin-top:-2px"></i></a>';
                        }
                        
                        if (row.stato.id === "AR") {
                            option += '<a class="dropdown-item" href="javascript:void(0);" onclick="downloadArchive(' + row.id + ',\'' + row.cip + '\')"><i class="fa fa-file-archive" style="margin-top:-2px"></i> Scarica Pacchetto Files</a>';
                            if (row.rendicontato === 0) {
                                option += '<a class="dropdown-item" href="javascript:void(0);" onclick="rendiconta(' + row.id + ')"><i class="fa fa-coins"></i> Rendiconta</a>';
                            } else if (row.rendicontato === 1) {
                                option += '<a class="dropdown-item" href="javascript:void(0);" onclick="liquida(' + row.id + ')"><i class="fa fa-coins"></i> Liquida</a>';
                            }
                        }

                        if (row.fadroom !== null) {
                            option += '<div class="dropdown-divider"></div>';

                            option += '<a class="dropdown-item fancyBoxAntoRef" href="fad_calendar.jsp?id=' + row.id + '"><i class="fa fa-calendar"></i> Calendario FAD</a>';
                            for (var x1 = 0; x1 < row.fadroom.length; x1++) {
                                var formnuovo = '<form target="_blank" id="frfad_' + row.fadroom[x1].nomestanza + '" method="post" action="' + row.fadlink + '">' +
                                        '<input type="hidden" name="type" value="login_fad_mc_multi"/> ' +
                                        '<input type="hidden" name="roomname" value="' + row.fadroom[x1].nomestanza + '"/> ' +
                                        '<input type="hidden" name="corso" value="' + row.fadroom[x1].numerocorso + '"/> ' +
                                        '<input type="hidden" name="codfisc" value="' + row.usermc + '"/> ' +
                                        '<input type="hidden" name="progetto" value="' + row.id + '"/> ' +
                                        '<input type="hidden" name="view" value="1"/> ' +
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
                                option += '<a class="dropdown-item" href="javascript:void(0);" onclick="return document.getElementById(\'frexc_' + row.id + '\').submit();"><i class="fa fa-file-excel" style="margin-top:-2px"></i> Scarica Registro FAD</a>' + formapriexc;
                            }

                            if (row.fadtemp) {
                                option += '<a class="dropdown-item" href="javascript:void(0);" onclick="uploadFad('
                                        + row.id + ')"><i class="fa fa-upload" style="margin-top:-2px"></i> Carica Registro FAD</a>';
                            }
                        }
                        if (row.stato.id !== "KO" && row.stato.id !== "AR") {
                            option += '<div class="dropdown-divider"></div>';
                            option += '<a class="dropdown-item kt-font-danger" href="javascript:void(0);" onclick="deletePrg(' + row.id + ')"><i class="flaticon2-delete kt-font-danger" style="margin-top:-2px"></i> Annulla Progetto</a>';
                        }
                        option += '</div></div>';
                        return option;
                    }
                }, {
                    targets: 4,
                    title: "ORE FASE A",
                    render: function (data, type, full) {
                        return data.toFixed(2);
                    }
                },
                {
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
                }, {
                    targets: 12,
                    render: function (data, type, row, meta) {
                        if (data === 1)
                            return "Rendicontato";
                        else if (data === "2")
                            return "Liquidato";
                        else
                            return "No";
                    }
                }, {
                    targets: 13,
                    orderable: false,
                    render: function (data, type, row, meta) {
                        return currencyFormatDecimal(Number(data));
                    }
                }, {
                    targets: 14,
                    orderable: false,
                    render: function (data, type, row, meta) {
                        return currencyFormatDecimal(Number(data));
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


function uploadFad(id) {
    var swalDoc = getHtml("swalDoc", context).replace("@func", "checkFileExtAndDim(&quot;xlsx&quot;)").replace("@mime", 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    swal.fire({
        title: 'CARICA REGISTRO FAD',
        html: swalDoc,
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
            $('#file').change(function (e) {
                if (e.target.files.length !== 0) {
                    if (e.target.files[0].name.length > 30) {
                        $('#label_doc').html(e.target.files[0].name.substring(0, 30) + "...");
                    } else {
                        $('#label_doc').html(e.target.files[0].name);
                    }
                } else {
                    $('#label_doc').html("Seleziona File");
                }
            });
        },
        preConfirm: function () {
            var err = false;
            err = !checkRequiredFileContent($('#swalDoc')) ? true : err;
            if (!err) {
                return new Promise(function (resolve) {
                    resolve({
                        "file": $('#file')[0].files[0]
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
            fdata.append("file", result.value.file);
            cambiaDocReportFad(id, fdata);
        } else {
            swal.close();
        }
    });
}

function cambiaDocReportFad(id, fdata) {
    $.ajax({
        type: "POST",
        url: context + '/OperazioniMicro?type=cambiaDocReportFad&idpr=' + id,
        data: fdata,
        processData: false,
        contentType: false,
        success: function (data) {
            closeSwal();
            var json = JSON.parse(data);
            if (json.result) {
                swalSuccessReload("Registro FAD caricato!", "Documento caricato con successo.");
            } else {
                swalError("Errore", json.message);
            }
        },
        error: function () {
            swalError("Errore", "Non è stato possibile caricare il registro.");
        }
    });
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
            scrollX: true,
            sScrollXInner: "110%",
            order: [],
            columns: [
                {defaultContent: ''},
                {data: 'nome'},
                {data: 'cognome'},
                {data: 'codicefiscale'},
                {data: 'datanascita'},
                {data: 'comune_domicilio'},
                {data: 'idea_impresa'},
                {data: 'selfiemployement.descrizione'},
                {defaultContent: ''},
                {data: 'esito'},
                {data: 'importo'}
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
                        var option = '<div class="dropdown dropdown-inline">'
                                + '<button type="button" class="btn btn-icon btn-sm btn-icon-md btn-circle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">'
                                + '<i class="flaticon-more-1"></i>'
                                + '</button>'
                                + '<div class="dropdown-menu dropdown-menu-left">';
                        option += '<a class="dropdown-item" href="javascript:void(0);" onclick="swalDocumentAllievo(' + row.id + ');"><i class="fa fa-file-alt"></i> Visualizza Documenti</a>';
                        option += '</div></div>';

                        return option;
                    }
                }
                , {
                    targets: 4,
                    type: 'date-it',
                    render: function (data, type, row, meta) {
                        return formattedDate(new Date(row.datanascita));
                    }
                }, {
                    targets: 5,
//                    className: 'text-center',
                    orderable: false,
                    render: function (data, type, row, meta) {
                        return row.comune_domicilio.nome + " (" + row.comune_domicilio.provincia + "),<br> " + row.indirizzodomicilio + " " + row.civicodomicilio;
                    }
                }, {
                    targets: 7,
                    render: function (data, type, row, meta) {
                        return row.selfiemployement === null ? "" : row.selfiemployement.descrizione;
                    }
                }, {
                    targets: 8,
                    className: 'text-center',
                    orderable: false,
                    render: function (data, type, row, meta) {
                        var option = '<a target="_blank" href="' + context + '/OperazioniGeneral?type=showDoc&path=' + row.docid + '" class="btn btn-io fa fa-address-card" style="font-size: 20px;"'
                                + 'data-container="body" data-html="true" data-toggle="kt-tooltip"'
                                + 'data-placement="top" title="<h6>Scadenza:</h6><h5>' + formattedDate(new Date(row.scadenzadocid)) + '</h5>"></a>';
                        if (new Date(row.scadenzadocid) <= new Date()) {
                            option = '<a target="_blank" href="' + context + '/OperazioniGeneral?type=showDoc&path=' + row.docid + '" class="btn btn-io-n " style="font-size: 20px"'
                                    + 'data-container="body" data-html="true" data-toggle="kt-tooltip"'
                                    + 'data-placement="top" title="<h6>Scadenza:</h6><h5>' + formattedDate(new Date(row.scadenzadocid)) + '</h5>">&nbsp;<i class="fa fa-exclamation-triangle"></i></a>';
                        }
                        return option;
                    }
                }, {
                    targets: 10,
                    orderable: false,
                    render: function (data, type, row, meta) {
                        return currencyFormatDecimal(Number(data));
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

function refresh() {
    $('html, body').animate({scrollTop: $('#offsetresult').offset().top}, 500);
    load_table($('#kt_table_1'), context + '/QueryMicro?type=searchProgetti&soggettoattuatore=' + $('#soggettoattuatore').val() + '&cip=' + $('#cip').val()
            + '&stato=' + $('#stato').val() + '&rendicontato=' + $('#rendicontato').val());
}

function reload() {
    $('html, body').animate({scrollTop: $('#offsetresult').offset().top}, 500);
    reload_table($('#kt_table_1'));
}

function swalTableAllievi(idprogetto) {
    clear_table($('#kt_table_allievi'));
    load_table($('#kt_table_allievi'), context + '/QueryMicro?type=searchAllieviProgetti&idprogetto=' + idprogetto);
    $('#allievi_table').modal('show');
    $('#allievi_table').on('shown.bs.modal', function () {
        $('.kt-scroll').each(function () {
            const ps = new PerfectScrollbar($(this)[0]);
        });
        $('#kt_table_allievi').DataTable().columns.adjust();
        $(".dataTables_scrollHead").css("overflow", "visible");
    });
}

var registri_aula = new Map();
function swalDocumentPrg(idprogetto) {
    $("#prg_docs").empty();
    var docente;
    var scadenza;
    var giorno;
    $.get(context + "/QueryMicro?type=getDocPrg&idprogetto=" + idprogetto, function (resp)
    {
        var json = JSON.parse(resp);
        var doc_registro_aula = getHtml("documento_registro", context);
        var doc_prg = getHtml("documento_prg", context);
        var registri = [];
        $.each(json, function (i, j) {
            docente = j.docente !== null ? " " + j.docente.nome + " " + j.docente.cognome : "";
            scadenza = j.scadenza !== null ? "<br>scad. " + formattedDate(new Date(j.scadenza)) : "";
            if (j.giorno !== null) {
                registri.push(j);
            } else {
                $("#prg_docs").append(doc_prg
                        .replace("@href", context + "/OperazioniGeneral?type=showDoc&path=" + j.path)
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
                $("#prg_docs").append(doc_registro_aula.replace("@href", context + "/OperazioniGeneral?type=showDoc&path=" + j.path)
                        .replace("@func", "showRegistroAula(" + j.id + "," + j.progetto.stato.controllare + "," + idprogetto + ")")
                        .replace("@nome", j.tipo.descrizione + giorno + docente)
                        .replace("#color", j.validate === 0 ? "warning" : "success"));
            });
        }
        $('#doc_modal').modal('show');
        $('[data-toggle="kt-tooltip"]').tooltip();
    });
}

var registri = new Map();
function swalDocumentAllievo(idallievo) {
    $("#prg_docs").empty();
    var giorno, color;
    var doc_registro_aula = getHtml("documento_registro", context);
    var doc_prg = getHtml("documento_prg", context);
    $.get(context + "/QueryMicro?type=getDocAllievo&idallievo=" + idallievo, function (resp) {
        var json = JSON.parse(resp);
        for (var i = 0; i < json.length; i++) {
            registri.set(json[i].id, json[i]);
            giorno = json[i].giorno !== null ? " del " + formattedDate(new Date(json[i].giorno)) : "";
            color = json[i].allievo.progetto.stato.controllare === 0 ? "io" : (json[i].orericonosciute === null ? "warning" : "success");
            if (json[i].giorno !== null) {
                registri_aula.set(json[i].id, json[i]);
                $("#prg_docs").append(doc_registro_aula.replace("@href", context + "/OperazioniGeneral?type=showDoc&path=" + json[i].path)
                        .replace("@func", "showRegistro(" + json[i].id + "," + json[i].allievo.progetto.stato.controllare + ")")
                        .replace("@nome", json[i].tipo.descrizione + giorno)
                        .replace("#color", color));
            } else {
                $("#prg_docs").append(doc_prg.replace("@href", context + "/OperazioniGeneral?type=showDoc&path=" + json[i].path)
                        .replace("#ex", json[i].tipo.estensione.id)
                        .replace("@nome", json[i].tipo.descrizione + giorno));
            }
        }
        $('#doc_modal').modal('show');
    });
}

function showRegistro(idregistro, controllare) {
    var registro = registri.get(idregistro);
    var doc_registro = "";
    var totalhh = calculateHoursRegistro(registro.orariostart_mattina, registro.orarioend_mattina, registro.orariostart_pom, registro.orarioend_pom).replace(":0", ":00");
    totalhh = totalhh.indexOf(":") === 1 ? "0" + totalhh : totalhh;

    if (registro.orariostart_pom !== null) {
        doc_registro += getHtml("doc_registro_individiale_pomeriggio", context);
        doc_registro = doc_registro.replace("@start_pome", formattedTime(registro.orariostart_pom).replace(":0", ":00"))
                .replace("@end_pome", formattedTime(registro.orarioend_pom).replace(":0", ":00"));
    } else {
        doc_registro = getHtml("doc_registro_individiale_mattina", context);
    }
    doc_registro = controllare === 1 ? (doc_registro + getHtml("doc_registro_individiale_ctrlore", context)) : doc_registro;
    doc_registro = doc_registro.replace("@start_pome", formattedTime(registro.orariostart_pom).replace(":0", ":00"))
            .replace("@date", formattedDate(new Date(registro.giorno)))
            .replace("@docente", registro.docente.cognome + " " + registro.docente.nome)
            .replace("@start_mattina", formattedTime(registro.orariostart_mattina).replace(":0", ":00"))
            .replace("@end_mattina", formattedTime(registro.orarioend_mattina).replace(":0", ":00"))
            .replace("@tot_ore", totalhh);
    ;
    doc_registro = registro.orericonosciute === null ? doc_registro.replace('@hh', totalhh).replace('@max', totalhh).replace("@msg", "Ore da riconoscere") : doc_registro.replace('@hh', doubletoHHmm(registro.orericonosciute)).replace('@max', totalhh).replace("@msg", "Ore riconosciute");

    swal.fire({
        title: 'Informazioni Registro',
        html: doc_registro,
        animation: false,
        showCancelButton: false,
        confirmButtonText: '<i class="fa fa-check"></i> Conferma ore',
        showConfirmButton: controllare === 1,
        showCloseButton: true,
        customClass: {
            popup: 'animated bounceInUp',
            container: 'my-swal'
        },
        onOpen: function () {
            $(document).off('focusin.modal');
        },
        preConfirm: function () {
            var err = false;
            err = checkObblFieldsContent($('#doc_registro_individiale_ctrlore')) ? true : err;
            err = !checkTime($("#orericonosciute"), totalhh) ? true : err;
            if (!err) {
                return new Promise(function (resolve) {
                    resolve({
                        "orericonosciute": $('#orericonosciute').val(),
                        "id": idregistro
                    });
                });
            } else {
                return false;
            }
        }
    }).then((result) => {
        if (result.value) {
            showLoad();
            $.ajax({
                url: context + "/OperazioniMicro?type=setHoursRegistro",
                type: 'POST',
                data: result.value,
                error: function () {
                    closeSwal();
                    swalError("Errore", "Riprovare, se l'errore persiste contattare l'assistenza");
                },
                success: function (resp) {
                    var json = JSON.parse(resp);
                    closeSwal();
                    if (json.result) {
                        swalDocumentAllievo(registro.allievo.id);
                        swalSuccess("Ore Convalidate", "Le ore del registro sono state convalidate con successo");
                    } else {
                        swalError("Errore!", json.message);
                    }
                }
            });
        } else {
            swal.close();
        }
    });
}

function swalTableStory(idprogetto) {
    swal.fire({
        html: '<table class="table table-bordered" id="kt_table_story">'
                + '<thead>'
                + '<tr>'
                + '<th class="text-uppercase text-center">Descrizione</th>'
                + '<th class="text-uppercase text-center">Data</th>'
                + '<th class="text-uppercase text-center">Stato</th>'
                + '</tr>'
                + '</thead>'
                + '</table>',
        width: '80%',
        scrollbarPadding: true,
        showCloseButton: true,
        showCancelButton: false,
        showConfirmButton: false,
        onOpen: function () {
            $("#kt_table_story").DataTable({
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
                ajax: context + '/QueryMicro?type=getStoryPrg&idprogetto=' + idprogetto,
                order: [],
                columns: [
                    {data: 'motivo'},
                    {data: 'data'},
                    {data: 'stato.descrizione'}
                ],
                columnDefs: [
                    {
                        targets: 1,
                        type: 'date-it',
                        render: function (data, type, row, meta) {
                            return formattedDate(new Date(data));
                        }
                    }]
            });
        }
    });
}

function valitdatePrg(id, stato, misto) {
    var html = "";
    if (stato === "S1") {
        if (misto === "true") {
            html = "<div class='form-group' id='swal_cip'>"
                    + "<label>Assegna Codice Identificativo Percorso (CIP)</label>"
                    + "<input class='form-control obbligatory' id='new_cip' placeholder='CIP'>"
                    + "</div><div class='dropdown-divider'></div><div class='form-group' id='swal_cip_misto'>"
                    + "<label>Inserisci Codice Identificativo Percorso (CIP) del progetto collegato</label>"
                    + "<input class='form-control obbligatory' id='new_cip_misto' placeholder='CIP Altro Progetto'>"
                    + "</div>";
        } else {
            html = "<div class='form-group' id='swal_cip'>"
                    + "<label>Assegna Codice Identificativo Percorso (CIP)</label>"
                    + "<input class='form-control obbligatory' id='new_cip' placeholder='CIP'>"
                    + "</div><input type='hidden' id='new_cip_misto' value='0' />";
        }
    } else {
        html = "<h4 style='text-align:left;'>Sicuro di voler validare il Progetto Formativo?";
    }
    swal.fire({
        title: '<h2 class="kt-font-io-n"><b>Valida Progetto</b></h2><br>',
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
            if (stato === "S1") {
                var err = false;
                err = checkObblFieldsContent($('#swal_cip')) ? true : err;

                if (misto === "true") {
                    err = checkObblFieldsContent($('#swal_cip_misto')) ? true : err;
                }

                if (!err) {
                    return new Promise(function (resolve) {
                        resolve({
                            "cip": $('#new_cip').val(),
                            "cip_misto": $('#new_cip_misto').val()
                        });
                    });
                } else {
                    return false;
                }
            }
        }
    }).then((result) => {
        if (result.value) {
            validate(id, result.value);
        } else {
            swal.close();
        }
    });
}

function validate(id, result) {
    showLoad();
    $.ajax({
        type: "POST",
        url: context + '/OperazioniMicro?type=validatePrg&id=' + id,
        data: result,
        success: function (data) {
            closeSwal();
            var json = JSON.parse(data);
            if (json.result) {
                reload();
                swalSuccess("Progetto Validato", "Progetto formativo validato con successo");
            } else {
                swalError("Errore", json.message);
            }
        },
        error: function () {
            swalError("Errore", "Non è stato possibile validare il progetto formativo");
        }
    });
}
//ANNULLA PROGETTO 17-08
function deletePrg(id) {
    swal.fire({
        title: '<h2 class="kt-font-io-n"><b>Annulla Progetto</b></h2><br>',
        html: "<div class='form-group' id='swal_motivo'>"
                + "<textarea class='form-control' id='motivo' placeholder='Motivazione'></textarea>"
                + "</div>",
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
            return new Promise(function (resolve) {
                resolve({
                    "motivo": $('#motivo').val()
                });
            });
        }
    }).then((result) => {
        if (result.value) {
            annullaProgetto(id, result.value);
        } else {
            swal.close();
        }
    });
}

function annullaProgetto(id, result) {
    showLoad();
    $.ajax({
        type: "POST",
        url: context + '/OperazioniMicro?type=annullaPrg&id=' + id,
        data: result,
        success: function (data) {
            closeSwal();
            var json = JSON.parse(data);
            if (json.result) {
                reload();
                swalSuccess("Progetto Errato Segnalato", "Progetto formativo annullato");
            } else {
                swalError("Errore", json.message);
            }
        },
        error: function () {
            swalError("Errore", "Non è stato possibile annullare il progetto formativo");
        }
    });
}

function rejectPrg(id) {
    var html = "";
    swal.fire({
        title: '<h2 class="kt-font-io-n"><b>Segnala Progetto Errato</b></h2><br>',
        html: "<div class='form-group' id='swal_motivo'>"
                + "<textarea class='form-control obbligatory' id='motivo' placeholder='Motivazione del rigetto'></textarea>"
                + "</div>",
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
            err = checkObblFieldsContent($('#swal_motivo')) ? true : err;
            if (!err) {
                return new Promise(function (resolve) {
                    resolve({
                        "motivo": $('#motivo').val()
                    });
                });
            } else {
                return false;
            }
        }
    }).then((result) => {
        if (result.value) {
            reject(id, result.value);
        } else {
            swal.close();
        }
    });
}

function reject(id, result) {
    showLoad();
    $.ajax({
        type: "POST",
        url: context + '/OperazioniMicro?type=rejectPrg&id=' + id,
        data: result,
        success: function (data) {
            closeSwal();
            var json = JSON.parse(data);
            if (json.result) {
                reload();
                swalSuccess("Progetto Errato Segnalato", "Progetto formativo segnalato con successo");
            } else {
                swalError("Errore", json.message);
            }
        },
        error: function () {
            swalError("Errore", "Non è stato possibile segnalare il progetto formativo");
        }
    });
}

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
                ajax: context + '/QueryMicro?type=searchDocentiProgetti&idprogetto=' + idprogetto,
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

function showRegistroAula(id, control, idprogetto) {
    var registro = registri_aula.get(id);
    var doc = getHtml("doc_registro_aula", context);
    var presenze = getHtml("div_presenza", context);

    $('#register_docs_modal').empty();

    var form = "<form id='kt_form_reg' action='" + context + "/OperazioniMicro?type=validateHourRegistroAula' mothod='post'>"
            + "<input type='hidden' value='" + id + "' name='id'>"
            + "<input type='hidden' value='" + idprogetto + "' id='idprogetto'>";
    var end_form = "<div class='input-group'><a class='btn btn-io' id='submit_reg' href='javascript:void(0);'>Convalida</a></div></form>";

    $('#register_docs_modal').append((control === 1 ? form : "") +
            doc.replace("@date", formattedDate(new Date(registro.giorno)))
            .replace("@start", formattedTime(registro.orariostart).replace(":0", ":00"))
            .replace("@end", formattedTime(registro.orarioend).replace(":0", ":00"))
            .replace("@docente", registro.docente.cognome + " " + registro.docente.nome)
            .replace("@ore", doubletoHHmm(registro.ore))
            .replace("@ore_conv", registro.ore_convalidate === "00:00" ? "" : doubletoHHmm(registro.ore_convalidate))
            .replace("@readonly", control === 1 ? "" : "readonly")
            .replace("@presenti",
                    registro.presenti_list.map(p => {
                        return presenze.replace("@nome", p.cognome + " " + p.nome)
                                .replace("@in", formattedTime(p.start).replace(":0", ":00"))
                                .replace("@out", formattedTime(p.end).replace(":0", ":00"))
                                .replace("@ore", doubletoHHmm(p.ore))
                                .replace("@max", p.ore)
                                .replace("@readonly", control === 1 ? "" : "readonly")
                                .replace("@ore_riconosciute", p.ore_riconosciute === "00:00" ? "" : doubletoHHmm(p.ore_riconosciute))
                                .replace("@id", p.id);
                    }))
            .split(",").join("") + (control === 1 ? end_form : ""));

    $('#register_modal').modal('show');

    controlHourRegister();

    $("#submit_reg").click(function () {
        if (!checkObblFieldsContent($("#kt_form_reg")) && !checkAllHour()) {
            showLoad();
            $("#kt_form_reg").ajaxSubmit({
                error: function () {
                    closeSwal();
                    swalError("Errore", "Riprovare, se l'errore persiste contattare l'assistenza");
                },
                success: function (resp) {
                    var json = JSON.parse(resp);
                    closeSwal();
                    if (json.result) {
                        swalDocumentPrg(Number($("#idprogetto").val()));
                        swalSuccess("Ore Convalidate", "Le ore del registro sono state convalidate con successo");
                    } else {
                        swalError("Errore!", json.message);
                    }
                }
            });
        }
    });

}

function confirmNext(id, stato) {
    var msg = "Sicuro di voler archivaire questo progetto formativo?"
            + "<br><br> Archiviando il progetto potrà essere scaricato il pacchetto con tutti i files da inviare in regione.";

    swal.fire({
        title: '<h2 class="kt-font-io-n"><b>Conferma Archiviazione Progetto</b></h2><br>',
        html: "<h4 style='text-align:left;'>" + msg + "</h4>",
        animation: false,
        showCancelButton: true,
        confirmButtonText: '&nbsp;<i class="la la-check"></i>',
        cancelButtonText: '&nbsp;<i class="la la-close"></i>',
        cancelButtonClass: "btn btn-io-n",
        confirmButtonClass: "btn btn-io",
        customClass: {
            popup: 'large-swal animated bounceInUp'
        }
    }).then((result) => {
        if (result.value) {
            goNext(id);
        } else {
            swal.close();
        }
    });
}

function goNext(id) {
    showLoad();
    $.ajax({
        type: "POST",
        url: context + '/OperazioniMicro?type=validatePrg&id=' + id,
        success: function (data) {
            closeSwal();
            var json = JSON.parse(data);
            if (json.result) {
                swalSuccess("Progetto Archiviato", "Progetto archiviato con successo");
                reload();
            } else {
                swalError("Errore", json.message);
            }
        },
        error: function () {
            swalError("Errore", "Non è stato possibile archiviare il progetto");
        }
    });
}//	

function downloadArchive(id, cip) {
    showLoad();
    $.ajax({
        type: "POST",
        url: context + '/OperazioniMicro?type=downloadTarGz_only',
        data: {id: id},
        success: function (data) {
            closeSwal();
            download(cip + ".tar.gz", data, "application/x-tar");
        },
        error: function () {
            swalError("Errore", "Non è stato possibile scaricare i files");
        }
    });
}

function modifyDate(id, start, end, fb) {
    swal.fire({
        title: '<h2 class="kt-font-io-n"><b>Modifica Date</b></h2><br>',
        html: "<div class='form-group' id='mod_date'>"
                + '<label>Date Inizio e Fine Progetto</label>'
                + '<input type="text" class="form-control obbligatory" id="kt_daterange"  name="date_progetto" autocomplete="off"><br>'
                + (fb !== null ? '<label>Data Fine Fase A e Inizio Fase B</label>' : '')
                + (fb !== null ? "<input class='form-control dp obbligatory' id='data_s_fb' name='data_s_fb' placeholder='data protocollo' value='" + formattedDate(new Date(fb)) + "'>" : "")
                + "<div class='form-group' id='data_err'></div>"
                + "</div>",
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
            $('#kt_daterange').daterangepicker({
                autoApply: true,
                startDate: new Date(start),
                endDate: new Date(end),
                locale: {
                    format: 'DD/MM/YYYY',
                    "daysOfWeek": [
                        "Do",
                        "Lu",
                        "Ma",
                        "Me",
                        "Gi",
                        "Ve",
                        "Sa"
                    ],
                    "monthNames": [
                        "Gen",
                        "Feb",
                        "Mar",
                        "Apr",
                        "Mag",
                        "Giu",
                        "Lug",
                        "Ago",
                        "Set",
                        "Ott",
                        "Nov",
                        "Dic"
                    ]}});

            $('input.dp').datepicker({
                rtl: KTUtil.isRTL(),
                orientation: "bottom left",
                todayHighlight: true,
                autoclose: true,
                format: 'dd/mm/yyyy'
            });
        },
        preConfirm: function () {
            var err = false;
            err = checkObblFieldsContent($('#mod_date')) ? true : err;
            if (fb !== null) {
                var split = $("#kt_daterange").val().split("-");
                var start = getDate(split[0].trim());
                var end = getDate(split[1].trim());
                var data_fb = getDate($("#data_s_fb").val());
                if (start > data_fb || data_fb > end) {
                    err = true;
                    $("#data_err").empty();
                    $("#kt_daterange").removeClass("is-valid").addClass("is-invalid");
                    $("#data_s_fb").removeClass("is-valid").addClass("is-invalid");
                    $("#data_err").append('<label class="kt-font-danger">Data inizio Fase B errata, fuori range.</label>');
                }
            }
            if (!err) {
                return new Promise(function (resolve) {
                    resolve({
                        "id": id,
                        "date": $("#kt_daterange").val(),
                        "fb": ($("#data_s_fb").val() !== undefined ? $("#data_s_fb").val() : null)
                    });
                });
            } else {
                return false;
            }
        }
    }).then((result) => {
        showLoad();
        if (result.value) {
            $.post(context + '/OperazioniMicro?type=updateDateProgetto', result.value, function (data) {
                if (data.result) {
                    swalSuccess("Progetto Aggiornato", "Date del progetto aggiornate con successo");
                    reload();
                }
            });
        } else {
            swal.close();
        }
    });
}

function getDate(data) {
    var arr = data.split("/");
    return new Date(arr[2] + "/" + arr[1] + "/" + arr[0]);
}

function rendiconta(idPrg) {
    swalConfirm("Rendiconta Progetto", "Sicuro di voler rendicontare questo progetto?", function rendicontaPrg() {
        showLoad();
        $.ajax({
            type: "POST",
            url: context + '/OperazioniMicro?type=rendicontaProgetto&id=' + idPrg,
            success: function (data) {
                closeSwal();
                if (data.result) {
                    swalSuccess('Successo', 'Progetto rendicontato con successo');
                    reload();
                } else {
                    swalError('Errore', data.message);
                }
            }
        });
    });
}

function liquida(idPrg) {
    swalConfirm("Liquida Progetto", "Sicuro di voler liquidare questo progetto?", function liquida() {
        showLoad();
        $.ajax({
            type: "POST",
            url: context + '/OperazioniMicro?type=liquidaPrg&id=' + idPrg,
            success: function (data) {
                closeSwal();
                if (data.result) {
                    swalSuccess('Successo', 'Progetto liquidato con successo');
                    reload();
                } else {
                    swalError('Errore', data.message);
                }
            }
        });
    });
}

////////////////////////////////////////////////////////////////////////////////
function liquida_old(id) {
    var html = "<div class='form-group-marginless' id='swal_liquida'>"
            + "<input class='form-control obbligatory' id='importo' placeholder='IMPORTO RICONOSCIUTO AL SOGGETTO ATTUATORE'>"
            + "</div>";
    swal.fire({
        title: '<h2 class="kt-font-io-n"><b>Liquida Progetto</b></h2><br>',
        html: html,
        animation: false,
        width:'50%',
        showCancelButton: true,
        confirmButtonText: '&nbsp;<i class="la la-check"></i>',
        cancelButtonText: '&nbsp;<i class="la la-close"></i>',
        cancelButtonClass: "btn btn-io-n",
        confirmButtonClass: "btn btn-io",
        customClass: {
            popup: 'animated bounceInUp'
        },
        onOpen: function () {
            $("#importo").inputmask('€ 999.999.999,99', {
                numericInput: true
            });
        },
        preConfirm: function () {
            var err = false;
            err = checkObblFieldsContent($('#swal_liquida')) ? true : err;
            if (!err) {
                return new Promise(function (resolve) {
                    resolve({
                        "importo": $('#importo').val()
                    });
                });
            } else {
                return false;
            }
        }
    }).then((result) => {
        if (result.value) {
            liquidaPrg_old(id, result.value);
        } else {
            swal.close();
        }
    });
}

function liquidaPrg_old(id, result) {
    showLoad();
    $.ajax({
        type: "POST",
        url: context + '/OperazioniMicro?type=liquidaPrg&id=' + id,
        data: result,
        success: function (data) {
            closeSwal();
            var json = JSON.parse(data);
            if (json.result) {
                reload();
                swalSuccess("Progetto Validato", "Progetto formativo validato con successo");
            } else {
                swalError("Errore", json.message);
            }
        },
        error: function () {
            swalError("Errore", "Non è stato possibile validare il progetto formativo");
        }
    });
}