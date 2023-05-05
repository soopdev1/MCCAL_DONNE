/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var context = document.getElementById("mangeFAQ").getAttribute("data-context");
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
            ScrollX: "100%",
            sScrollXInner: "110%",
            processing: true,
            pageLength: 10,
            ajax: context + '/QueryMicro?type=getMyConference&nome=' + $('#nome').val() + "&stato=" + $('input[name=stato]:checked').val(),
            order: [],
            columns: [
                {defaultContent: ''},
                {data: 'nomestanza'},
                {data: 'list_partecipanti'},
                {data: 'datacreazione'},
                {data: 'stato'},
                {data: 'inizio'},
                {data: 'fine'},
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
                        if (row.stato == 1) {
                            option += '<a class="dropdown-item" href="javascript:void(0);" onclick="closeFAD(' + row.id + ', 0, \'aprire\', \'aperta\')"><i class="fa fa-door-open"></i> Apri Stanza</a>';
                        } else {
                            option += '<a class="dropdown-item" href="javascript:void(0);" onclick="closeFAD(' + row.id + ', 1, \'chiudere\', \'chiusa\')"><i class="fa fa-power-off"></i> Chiudi Stanza</a>';
                        }
                        option += '<a class="dropdown-item" href="javascript:void(0);" onclick="closeFAD(' + row.id + ', 2, \'eliminare\', \'eliminata\')"><i class="fa fa-trash-alt"></i> Elimina Stanza</a>';
                        if (row.stato === 0) {
                            option += '<a class="dropdown-item" href="javascript:void(0);" onclick="logFAD(' + row.id + ')"><i class="fa fa-sign-in-alt"></i> Accedi</a>';
                        }
                        option += '<a class="dropdown-item fancyBoxAntoRef" href="modifyFadConference.jsp?idFad=' + row.id + '"><i class="fa fa-edit"></i> Modifica</a>';
                        option += '</div></div>';
                        return option;
                    }
                },
                {
                    targets: 2,
                    orderable: false,
                    render: function (data, type, row, meta) {
                        return showList(data, 0);
                    },
                }, {
                    targets: 3,
                    type: 'date-it',
                    render: function (data, type, row, meta) {
                        return formattedDate(new Date(data));
                    },
                }, {
                    targets: 4,
                    className: 'text-center',
                    render: function (data, type, row, meta) {
                        return data == 0 ? "Aperta" : "Chiusa";
                    }
                },{
                    targets: 5,
                    type: 'date-it',
                    render: function (data, type, row, meta) {
                        return formattedDateTime(new Date(data));
                    },
                },{
                    targets: 6,
                    type: 'date-it',
                    render: function (data, type, row, meta) {
                        return formattedDateTime(new Date(data));
                    },
                }]
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
    $('.kt-scroll').each(function () {
        const ps = new PerfectScrollbar($(this)[0]);
    });
    $('.kt-scroll-x').each(function () {
        const ps = new PerfectScrollbar($(this)[0], {suppressScrollY: true});
    });
});

function refresh() {
    $('html, body').animate({scrollTop: $('#offsetresult').offset().top}, 500);
    load_table($('#kt_table_1'), context + '/QueryMicro?type=getMyConference&nome=' + $('#nome').val() + "&stato=" + $('input[name=stato]:checked').val());
}

function reload() {
    $('html, body').animate({scrollTop: $('#offsetresult').offset().top}, 500);
    reload_table($('#kt_table_1'));
}

function closeFAD(idFad, stato, swal, confirm) {
    swalConfirm(capitalize(swal) + " Stanza", "Sicuro di voler " + swal + " questa stanza?", function close() {
        showLoad();
        $.ajax({
            type: "POST",
            url: context + '/OperazioniMicro?type=closeFAd&id=' + idFad + "&stato=" + stato,
            success: function (data) {
                closeSwal();
                var json = JSON.parse(data);
                if (json.result) {
                    swalSuccess('Successo', 'Stanza ' + confirm + ' con successo')
                    reload();
                } else {
                    swalError('Errore', json.message);
                }
            }
        });
    });
}

function logFAD(idFad) {
    showLoad();
    $.post(context + '/QueryMicro', {"type": "getFAD", "id": idFad}, function (data) {
        connectFAD(data);
        swal.close();
    });
}

function reinvita(idFad) {
    showLoad();
    $.post(context + '/OperazioniMicro', {"type": "reinvitaFAD", "id": idFad}, function (data) {
        closeSwal();
        var json = JSON.parse(data);
        if (json.result) {
            swalSuccess('Successo', 'Inviti inviati correttamente');
        } else {
            swalError('Errore', json.message);
        }
    }).fail(function () {
        swalError("Errore", "Riprovare, se l'errore persiste contattare l'assistenza");
    });
}


function connectFAD(json) {
    var form = $("#goFAD");
    form.attr("action", json.link);
    $("#id").val(json.id);
    $("#password").val(json.password);
    $("#user").val(json.user.email);
    form.submit();
}


function showList(json, index) {
    if (json.length > index) {
        return (index == 0 ? "" : "<b class='kt-font-io-n'> | </b>") + (index % 3 == 0 ? "<br>" : "") + json[index] + showList(json, index + 1);
    } else {
        return "";
    }
}