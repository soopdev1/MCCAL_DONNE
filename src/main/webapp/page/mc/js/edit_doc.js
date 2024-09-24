/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var context = document.getElementById("myFAQ").getAttribute("data-context");
$.getScript(context + '/page/partialView/partialView.js', function () {});

function rigenera_report(id) {
    showLoad();
    $.ajax({
        type: "POST",
        url: context + '/OperazioniMicro?type=rigenerareportfad&idpr=' + id,
        processData: false,
        contentType: false,
        success: function (data) {
            closeSwal();
            try {
                var json = JSON.parse(data);
                if (json.result) {
                    swalSuccessReload("Report rigenerato!", "Documento disponibile nell'apposita sezione.");
                } else {
                    swalError("Errore", json.message);
                }
            } catch (e) {
                swalError("Errore", "Non è stato possibile generare il documento. " + e.message);
            }
        },
        error: function () {
            swalError("Errore", "Non è stato possibile caricare il documento.");
        }
    });
}

function sost_docprg(id, ext, mime, tipo) {
    var swalDoc = getHtml("swalDoc", context).replace("@func", "checkFileExtAndDim(&quot;" + ext + "&quot;)")
            .replace("@mime", mime);
    swal.fire({
        title: 'SOSTITUISCI DOC ID: ' + id,
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
            if (tipo === 1) {
                cambiaDoc(id, fdata, "sostituisciDocProgetto");
            } else if (tipo === 2) {
                cambiaDoc(id, fdata, "sostituisciDocAllievo");
            }
        } else {
            swal.close();
        }
    });
}

function cambiaDoc(id, fdata, action) {
    $.ajax({
        type: "POST",
        url: context + '/OperazioniMicro?type=' + action + '&iddoc=' + id,
        data: fdata,
        processData: false,
        contentType: false,
        success: function (data) {
            closeSwal();
            try {
                var json = JSON.parse(data);
                if (json.result) {
                    swalSuccessReload("Documento sostituito!", "Documento caricato con successo.");
                } else {
                    swalError("Errore", json.message);
                }
            } catch (e) {
                swalError("Errore", "Non è stato possibile caricare il documento. " + e.message);
            }
        },
        error: function () {
            swalError("Errore", "Non è stato possibile caricare il documento.");
        }
    });
}

