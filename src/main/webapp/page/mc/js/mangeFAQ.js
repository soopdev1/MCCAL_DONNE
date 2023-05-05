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
            ajax: context + '/QueryMicro?type=geFaqAnswer&soggettoattuatore=' + $('#soggettoattuatore').val()
                    + '&tipo=' + $('#tipo').val(),
            order: [],
            columns: [
                {defaultContent: ''},
                {data: 'soggetto.ragionesociale'},
                {data: 'domanda_mod'},
                {data: 'risposta'},
                {data: 'date_answer'},
                {data: 'tipo.descrizione'},
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

                        option += '<a class="dropdown-item" href="javascript:void(0);" onclick="modifyFAQ(' + row.id + ')"><i class="fa fa-edit"></i> Modifica</a>';
                        option += '<a class="dropdown-item" href="javascript:void(0);" onclick="setVisibility(' + row.id + ', ' + row.tipo.id + ')"><i class="fa fa-users"></i> Cambia Visibilità</a>';
                        option += '</div></div>';
                        return option;
                    }
                },
                {
                    targets: 4,
                    type: 'date-it',
                    render: function (data, type, row, meta) {
                        return formattedDate(new Date(data));
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
    load_table($('#kt_table_1'), context + '/QueryMicro?type=geFaqAnswer&soggettoattuatore=' + $('#soggettoattuatore').val()
            + '&tipo=' + $('#tipo').val());
}

function reload() {
    $('html, body').animate({scrollTop: $('#offsetresult').offset().top}, 500);
    reload_table($('#kt_table_1'));
}

function setVisibility(idFaq, tipo) {
    swal.fire({
        title: 'Seleziona Visibilità',
        html: '<div class="dropdown bootstrap-select form-control kt-" id="tipo_new_div" style="padding: 0;height: 35px;">'
                + '<select class="form-control kt-select2-general obbligatory" id="tipo_new" name="tipo_new"  style="width: 100%">'
                + '<option value="-">Seleziona Tipo</option>'
                + '</select>'
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
        onOpen: function ()
        {
            $('#tipo_new').select2({
                dropdownCssClass: "select2-on-top",
                minimumResultsForSearch: -1
            });
            $.get(context + "/QueryMicro?type=getTipoFaq", function (resp) {
                var json = JSON.parse(resp);
                for (var i = 0; i < json.length; i++) {
                    if (tipo == json[i].id) {
                        $("#tipo_new").append('<option selected value="' + json[i].id + '">' + json[i].descrizione + '</option>');
                    } else {
                        $("#tipo_new").append('<option value="' + json[i].id + '">' + json[i].descrizione + '</option>');
                    }
                }
            });
        },
        preConfirm: function ()
        {
            var err = false;
            err = checkObblFields() ? true : err;
            if (!err) {
                return new Promise(function (resolve) {
                    resolve({
                        "tipo": $('#tipo_new').val(),
                    });
                });
            } else {
                return false;
            }
        }
        ,
    }).then((result) => {
        if (result.value) {
            showLoad();
            $.ajax({
                type: "POST",
                url: context + '/OperazioniMicro?type=setTipoFaq&id=' + idFaq,
                data: result.value,
                success: function (data) {
                    closeSwal();
                    var json = JSON.parse(data);
                    if (json.result) {
                        swalSuccess('Successo', 'Visibilità aggiornata con successo')
                        reload();
                    } else {
                        swalError('Errore', json.message);
                    }
                }
            });
        } else {
            swal.close();
        }
    }

    );
}

function modifyFAQ(idFaq) {
    swal.fire({
        title: 'Mdifica FAQ',
        html: '<label class="form-label">Domanda</label>'
                + '<textarea class="form-control obbligatory" id="domanda" style="min-height:150px"></textarea>'
                + '<label class="form-label">Risposta</label>'
                + '<textarea class="form-control obbligatory" id="risposta" style="min-height:150px"></textarea>',
        animation: false,
        showCancelButton: true,
        confirmButtonText: '&nbsp;<i class="la la-check"></i>',
        cancelButtonText: '&nbsp;<i class="la la-close"></i>',
        cancelButtonClass: "btn btn-io-n",
        confirmButtonClass: "btn btn-io",
        customClass: {
            popup: 'animated bounceInUp swal-responsive',
        },
        onOpen: function ()
        {
            $.get(context + "/QueryMicro?type=getFaq&id=" + idFaq, function (resp) {
                var json = JSON.parse(resp);
                $('#domanda').val(json.domanda_mod);
                $('#risposta').val(json.risposta);
            });
        },
        preConfirm: function ()
        {
            var err = false;
            err = checkObblFields() ? true : err;
            if (!err) {
                return new Promise(function (resolve) {
                    resolve({
                        "domanda": $('#domanda').val(),
                        "risposta": $('#risposta').val(),
                    });
                });
            } else {
                return false;
            }
        }
        ,
    }).then((result) => {
        if (result.value) {
            showLoad();
            $.ajax({
                type: "POST",
                url: context + '/OperazioniMicro?type=modifyFaq&id=' + idFaq,
                data: result.value,
                success: function (data) {
                    closeSwal();
                    var json = JSON.parse(data);
                    if (json.result) {
                        swalSuccess('Successo', 'FAQ aggiornata con successo');
                        reload();
                    } else {
                        swalError('Errore', json.message);
                    }
                }
            });
        } else {
            swal.close();
        }
    }

    );
}