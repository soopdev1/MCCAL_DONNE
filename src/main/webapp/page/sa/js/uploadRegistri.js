/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var context = document.getElementById("uploadRegistri").getAttribute("data-context");
var millis_start_fb = Number(document.getElementById("uploadRegistri").getAttribute("data-start-fb"));
$.getScript(context + '/page/partialView/partialView.js', function () {});

var ore_max_daily = document.getElementById("ore_max").getAttribute("data-context");
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

var ore_inizili_registro;

function remainingHH(total) {
    var hh20 = 20;
    return (hh20 - total + (ore_inizili_registro / 3600000));
}

function returnTotalHHbyAllievo(idallievo) {
    var totaleore = 0;
    $.ajax({
        type: "GET",
        async: false,
        url: context + "/OperazioniSA?type=getTotalHoursRegistriByAllievo&idallievo=" + idallievo,
        success: function (resp) {
            if (resp != null)
                totaleore = resp;
        }
    });
    return totaleore;
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

function changeRegistro(idallievo, iddocumento, idprogetto, totalems) {
    swal.fire({
        title: 'Modifica Registro', //getHtml("swalReg", context),
        html: getHtml("swalModReg", context),
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
            //var totalms = 0;
            var arrows = {
                leftArrow: '<i class="la la-angle-left"></i>',
                rightArrow: '<i class="la la-angle-right"></i>'
            }
            $('#giorno').datepicker({
                orientation: "bottom left",
                templates: arrows,
                autoclose: true,
                format: 'dd/mm/yyyy',
                endDate: new Date(),
                startDate: new Date(millis_start_fb),
            });


            var docenteselected = "";
            $.ajax({
                type: "GET",
                async: false,
                url: context + "/QuerySA?type=getDocAllievoById&iddocumento=" + iddocumento,
                success: function (data) {
                    var json = JSON.parse(data);
                    docenteselected = json.docente.id;
                    $('#orario1_start').val(formattedTime(json.orariostart_mattina));
                    $('#orario1_end').val(formattedTime(json.orarioend_mattina));
                    if (json.orariostart_pom != null) {
                        $('#check').prop('checked', true);
                        $('#orario2_start').val(formattedTime(json.orariostart_pom));
                        $('#orario2_end').val(formattedTime(json.orarioend_pom));
                        $('#div_pm').css("display", "");
                    } else {
                        $('#check').prop('checked', false);
                        $('#orario2_start').val(formattedTime(json.orarioend_mattina));
                        $('#orario2_end').val('21:00');
//                        var mintoadd = 1800000;
//                        $('#orario2_start').val(formattedTime(json.orarioend_mattina + mintoadd));
//                        $('#orario2_end').val(formattedTime(json.orarioend_mattina + mintoadd));
                    }
                    $('#giorno').datepicker("setDate", new Date(json.giorno))//.val(formattedDate(new Date(json.giorno)));

                    var m_s = $('#orario1_start').val();
                    var m_e = $('#orario1_end').val();
                    var p_s = $('#orario2_start').val();
                    var p_e = $('#orario2_end').val()
                    ore_inizili_registro = new Date('00', '00', '00', m_e.split(':')[0], m_e.split(':')[1]).getTime() - new Date('00', '00', '00', m_s.split(':')[0], m_s.split(':')[1]).getTime();
                    if ($('#check').is(":checked")) {
                        ore_inizili_registro += new Date('00', '00', '00', p_e.split(':')[0], p_e.split(':')[1]).getTime() - new Date('00', '00', '00', p_s.split(':')[0], p_s.split(':')[1]).getTime();
                    }


                    $("#tot_hh").html('Totale ore di lezione rimanenti (max 20h):&nbsp;<b>' + (remainingHH(totalems) - (ore_inizili_registro / 3600000)) + '</b>');
                },
                error: function () {
                    swalError("Errore", "Errore durante il caricamento del registro");
                }
            });
            $.get(context + "/QuerySA?type=getDocentiByPrg&idprogetto=" + idprogetto, function (resp) {
                var json = JSON.parse(resp);
                for (var i = 0; i < json.length; i++) {
                    if (docenteselected == json[i].id) {
                        $("#docente").append('<option selected value="' + json[i].id + '">' + json[i].cognome + " " + json[i].nome + '</option>');
                    } else {
                        $("#docente").append('<option value="' + json[i].id + '">' + json[i].cognome + " " + json[i].nome + '</option>');
                    }
                }
            });
            $('#docente').select2({
                dropdownCssClass: "select2-on-top",
                minimumResultsForSearch: -1
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
                checkRegistroAlievoExist(idallievo, $(this).val(), iddocumento);
            });
            $('input.time').timepicker({
                showMeridian: false,
                interval: 5,
                showInputs: false,
                snapToStep: true,
                icons:
                        {
                            up: 'la la-angle-up',
                            down: 'la la-angle-down'
                        }
            });
        },
        preConfirm: function () {
            var err = false;
            err = checkObblFieldsContent($('#swalModReg')) ? true : err;
            err = checkRegistroAlievoExist(idallievo, $("#giorno").val(), iddocumento) ? true : err;
            err = !checkTotalHH($('#orario1_start').val(), $('#orario1_end').val(), $('#orario2_start').val(), $('#orario2_end').val(), $('#check').is(":checked"), totalems) ? true : err;
            if (!err) {
                return new Promise(function (resolve) {
                    resolve({
                        "giorno": $('#giorno').val(),
                        "docente": $('#docente').val(),
                        "orario1_start": $('#orario1_start').val(),
                        "orario1_end": $('#orario1_end').val(),
                        "orario2_start": $('#orario2_start').val(),
                        "orario2_end": $('#orario2_end').val(),
                        "check": $('#check').is(":checked"),
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
            fdata.append("giorno", result.value.giorno);
            fdata.append("docente", result.value.docente);
            fdata.append("orario1_start", result.value.orario1_start);
            fdata.append("orario1_end", result.value.orario1_end);
            fdata.append("orario2_start", result.value.orario2_start);
            fdata.append("orario2_end", result.value.orario2_end);
            fdata.append("check", result.value.check);
            $.ajax({
                type: "POST",
                url: context + '/OperazioniSA?type=modifyRegistro&iddocumento=' + iddocumento,
                data: fdata,
                processData: false,
                contentType: false,
                success: function (data) {
                    closeSwal();
                    var json = JSON.parse(data);
                    if (json.result) {
                        swalSuccessReload("Registro Modificato", (json.message = !"" ? json.message : ""));
                    } else {
                        swalError("Errore", json.message);
                    }
                },
                error: function () {
                    swalError("Errore", "Non è stato possibile modificare il registro");
                }
            });
        } else {
            swal.close();
        }
    });
}

function checkRegistroAlievoExist(idallievo, giorno, iddocumento) {
    var presente = false;
    $.ajax({
        async: false,
        type: "post",
        url: context + '/QuerySA?type=checkRegistroAlievoExist',
        data: {"idallievo": idallievo, "giorno": giorno},
        success: function (data) {
            var json = JSON.parse(data);
            if (json !== null) {
                if (json.id == iddocumento) {
                    presente = false;
                    $('#alertmsg_day').html("");
                    $('#warning_day').css("display", "none");
                    $('#giorno').removeClass('is-invalid').addClass('is-valid');
                } else {
                    presente = true;
                    $('#alertmsg_day').html("Registro già presente per questo giorno");
                    $('#warning_day').css("display", "");
                    $('#giorno').removeClass('is-valid').addClass('is-invalid');
                }

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

function changeDocs(doc, idse, idea, protocollo, idtipodoc, estensione, mime_type) {
    var ext = estensione.split('"').join("&quot;");
    if (idtipodoc === 6) {
        changeSE(doc, idse, protocollo, ext, mime_type);
    } else if (idtipodoc === 7) {
        changeM8(doc, idea, ext, mime_type);
    } else {
        changeDoc(doc, ext, mime_type);
    }
}

function uploadDocs(idallievo, id_tipoDoc, estensione, mime_type) {
    var ext = estensione.split('"').join("&quot;");
    if (id_tipoDoc === 6) {
        uploadSE(idallievo, id_tipoDoc, ext, mime_type);
    } else if (id_tipoDoc === 7) {
        uploadM8(idallievo, id_tipoDoc, ext, mime_type);
    } else {
        uploadDoc(idallievo, id_tipoDoc, ext, mime_type);
    }
}

function changeDoc(id, estensione, mime_type) {
    var htmldoc = getHtml("uploadDoc", context).replace("@func", "checkFileExtAndDim(" + estensione + ");").replace("@mime", mime_type);
    swal.fire({
        title: 'Modifica Documento',
        html: htmldoc,
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
                if (e.target.files.length != 0)
                    //$('#label_doc').html(e.target.files[0].name);
                    if (e.target.files[0].name.length > 30)
                        $('#label_doc').html(e.target.files[0].name.substring(0, 30) + "...");
                    else
                        $('#label_doc').html(e.target.files[0].name);
                else
                    $('#label_doc').html("Seleziona File");
            });
        },
        preConfirm: function () {
            var err = false;
            err = !checkRequiredFileContent($('#uploadDoc')) ? true : err;
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
            modDoc(id, fdata);
        } else {
            swal.close();
        }
    });
}

function uploadSE(idallievo, id_tipoDoc, estensione, mime_type) {
    var htmlSE = getHtml("docSE", context).replace("@func", "checkFileExtAndDim(" + estensione + ");").replace("@protocollo", "").replace("@mime", mime_type);
    swal.fire({
        title: 'Carica SELFIEmployement',
        html: htmlSE,
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
                if (e.target.files.length != 0) {
                    //$('#label_file').html(e.target.files[0].name);
                    if (e.target.files[0].name.length > 30) {
                        $('#label_file').html(e.target.files[0].name.substring(0, 30) + "...");
                    } else {
                        $('#label_file').html(e.target.files[0].name);
                    }
                } else {
                    $('#label_file').html("Seleziona File");
                }
            });
            $('#prestiti').select2({
                dropdownCssClass: "select2-on-top",
                minimumResultsForSearch: -1,
            });
            $.get(context + "/QuerySA?type=getSE_Prestiti", function (resp) {
                var json = JSON.parse(resp);
                for (var i = 0; i < json.length; i++) {
                    $("#prestiti").append('<option value="' + json[i].id + '">' + json[i].descrizione + '</option>');
                }
            });
        },
        preConfirm: function () {
            var err = false;
            err = !checkRequiredFileContent($('#docSE')) ? true : err;
            err = checkObblFieldsContent($('#docSE')) ? true : err;
            if (!err) {
                return new Promise(function (resolve) {
                    resolve({
                        "prestiti": $('#prestiti').val(),
                        "protocollo": $('#protocollo').val(),
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
            fdata.append("prestiti", result.value.prestiti);
            fdata.append("protocollo", result.value.protocollo);
            upDoc(idallievo, id_tipoDoc, fdata);
        } else {
            swal.close();
        }
    }
    );
}

function changeSE(iddocumento, idse, protocollo, estensione, mime_type) {
    var htmlSE = getHtml("docSE", context).replace("@func", "checkFileExtAndDim(" + estensione + ");").replace("@protocollo", "").replace("@mime", mime_type);
    swal.fire({
        title: 'Modifica SELFIEmployment',
        html: htmlSE,
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
            $('#prestiti').select2({
                dropdownCssClass: "select2-on-top",
                minimumResultsForSearch: -1,
            });
            $.get(context + "/QuerySA?type=getSE_Prestiti", function (resp) {
                var json = JSON.parse(resp);
                for (var i = 0; i < json.length; i++) {
                    if (idse == json[i].id) {
                        $("#prestiti").append('<option selected value="' + json[i].id + '">' + json[i].descrizione + '</option>');
                    } else {
                        $("#prestiti").append('<option value="' + json[i].id + '">' + json[i].descrizione + '</option>');
                    }
                }
            });
            $('#doc').change(function (e) {
                if (e.target.files.length != 0)
//                    $('#label_file').html(e.target.files[0].name);
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
            err = !checkRequiredFileContent($('#docSE')) ? true : err;
            err = checkObblFields($('#docSE')) ? true : err;
            if (!err) {
                return new Promise(function (resolve) {
                    resolve({
                        "prestiti": $('#prestiti').val(),
                        "protocollo": $('#protocollo').val(),
                        "file": $('#doc')[0].files[0]
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
            fdata.append("prestiti", result.value.prestiti);
            fdata.append("protocollo", result.value.protocollo);
            modDoc(iddocumento, fdata);
        } else {
            swal.close();
        }
    });
}

function uploadM8(idallievo, id_tipoDoc, estensione, mime_type) {
    var htmlm8 = getHtml("docM8", context).replace("@func", "checkFileExtAndDim(" + estensione + ");").replace("@idea", "").replace("@mime", mime_type);
    swal.fire({
        title: 'Carica Modello 8',
        html: htmlm8,
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
                    //$('#label_file').html(e.target.files[0].name);
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
            err = !checkRequiredFileContent($('#docM8')) ? true : err;
            err = checkObblFieldsContent($('#docM8')) ? true : err;
            if (!err) {
                return new Promise(function (resolve) {
                    resolve({
                        "idea": $('#idea').val(),
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
            fdata.append("idea", result.value.idea);
            upDoc(idallievo, id_tipoDoc, fdata);
        } else {
            swal.close();
        }
    }
    );
}

function changeM8(iddocumento, idea, estensione, mime_type) {
    var htmlm8 = getHtml("docM8", context).replace("@func", "checkFileExtAndDim(" + estensione + ");").replace("@idea", "").replace("@mime", mime_type);
    swal.fire({
        title: 'Modifica Modello 8',
        html: htmlm8,
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
                    //$('#label_file').html(e.target.files[0].name);
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
            err = !checkRequiredFileContent($('#docM8')) ? true : err;
            err = checkObblFields($('#docM8')) ? true : err;
            if (!err) {
                return new Promise(function (resolve) {
                    resolve({
                        "idea": $('#idea').val(),
                        "file": $('#doc')[0].files[0]
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
            fdata.append("idea", result.value.idea);
            modDoc(iddocumento, fdata);
        } else {
            swal.close();
        }
    });
}

function uploadDoc(idallievo, id_tipoDoc, estensione, mime_type) {
    var htmldoc = getHtml("uploadDoc", context).replace("@func", "checkFileExtAndDim(" + estensione + ");").replace("@mime", mime_type);
    swal.fire({
        title: 'Carica Documento',
        html: htmldoc,
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
                if (e.target.files.length != 0)
                    //$('#label_doc').html(e.target.files[0].name);
                    if (e.target.files[0].name.length > 30)
                        $('#label_doc').html(e.target.files[0].name.substring(0, 30) + "...");
                    else
                        $('#label_doc').html(e.target.files[0].name);
                else
                    $('#label_doc').html("Seleziona File");
            });
        },
        preConfirm: function () {
            var err = false;
            err = !checkRequiredFileContent($('#uploadDoc')) ? true : err;
            if (!err) {
                return new Promise(function (resolve) {
                    resolve({
                        "file": $('#file')[0].files[0]
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
            upDoc(idallievo, id_tipoDoc, fdata);
        } else {
            swal.close();
        }
    });
}

function upDoc(id, id_tipoDoc, fdata) {
    $.ajax({
        type: "POST",
        url: context + '/OperazioniSA?type=uploadDocPrg_FaseB&idallievo=' + id + "&id_tipo=" + id_tipoDoc,
        data: fdata,
        processData: false,
        contentType: false,
        success: function (data) {
            var json = JSON.parse(data);
            if (json.result) {
                swalSuccessReload("Documento Caricato", (json.message = !"" ? json.message : ""));
            } else {
                swalError("Errore", json.message);
            }
        },
        error: function () {
            swalError("Errore", "Non è stato possibile caricare il documento");
        }
    });
}

function modDoc(id, fdata) {
    $.ajax({
        type: "POST",
        url: context + '/OperazioniSA?type=modifyDocPrg_FaseB&id=' + id,
        data: fdata,
        processData: false,
        contentType: false,
        success: function (data) {
            closeSwal();
            var json = JSON.parse(data);
            if (json.result) {
                swalSuccessReload("Documento Modificato", "Documento modificato con successo");
            } else {
                swalError("Errore", json.message);
            }
        },
        error: function () {
            swalError("Errore", "Non è stato possibile modificare il documento");
        }
    });
}
