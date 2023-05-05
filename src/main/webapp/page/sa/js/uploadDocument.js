/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var context = document.getElementById("uploadDocument").getAttribute("data-context");
$.getScript(context + '/page/partialView/partialView.js', function () {});

function changeDoc(id, scadenza, estensione, mime_type) {
    if (scadenza !== null) {
        modifyDocId(id, estensione.split('"').join("&quot;"), mime_type);
    } else {
        modifyDoc(id, estensione.split('"').join("&quot;"), mime_type);
    }
}

function modifyDocId(id, estensione, mime_type) {
    var swalDocId = getHtml("swalDocId", context).replace("@func", "checkFileExtAndDim(" + estensione + ");").replace("@mime", mime_type);
    swal.fire({
        title: 'Carica Documento Id ',
        html: swalDocId,
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
            $('#docid').change(function (e) {
                if (e.target.files.length !== 0)
                    //$('#label_doc').html(e.target.files[0].name);
                    if (e.target.files[0].name.length > 30)
                        $('#label_doc').html(e.target.files[0].name.substring(0, 30) + "...");
                    else
                        $('#label_doc').html(e.target.files[0].name);
                else
                    $('#label_doc').html("Seleziona File");
            });
            $('#scadenza').datepicker({
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
            var err = false;
            err = !checkRequiredFileContent($('#swalDocId')) ? true : err;
            err = checkObblFieldsContent($('#swalDocId')) ? true : err;
            if (!err) {
                return new Promise(function (resolve) {
                    resolve({
                        "scadenza": $('#scadenza').val(),
                        "file": $('#docid')[0].files[0]
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
            fdata.append("scadenza", result.value.scadenza);
            modDoc(id, fdata);
        } else {
            swal.close();
        }
    }
    );
}

function modifyDoc(id, estensione, mime_type) {
    var swalDoc = getHtml("swalDoc", context).replace("@func", "checkFileExtAndDim(" + estensione + ");").replace("@mime", mime_type);
    swal.fire({
        title: 'Modifica Documento',
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
                if (e.target.files.length != 0)
                    ////$('#label_file').html(e.target.files[0].name);
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
        },
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

function modDoc(id, fdata) {
    $.ajax({
        type: "POST",
        url: context + '/OperazioniSA?type=modifyDoc&id=' + id,
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

function uploadDoc(idprogetto, id_tipoDoc, estensione, mime_type) {
    var ext = estensione.split('"').join("&quot;");
    var swalDoc = getHtml("swalDoc", context).replace("@func", "checkFileExtAndDim(" + ext + ");").replace("@mime", mime_type);
    swal.fire({
        title: 'Carica Documento',
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
                if (e.target.files.length !== 0)
                    //$('#label_file').html(e.target.files[0].name);
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
        },
    }).then((result) => {
        if (result.value) {
            showLoad();
            var fdata = new FormData();
            fdata.append("file", result.value.file);
            $.ajax({
                type: "POST",
                url: context + '/OperazioniSA?type=uploadDocPrg&idprogetto=' + idprogetto + "&id_tipo=" + id_tipoDoc,
                data: fdata,
                processData: false,
                contentType: false,
                success: function (data) {
                    closeSwal();
                    var json = JSON.parse(data);
                    if (json.result) {
                        swalSuccessReload("Documento Caricato", "Documento caricato con successo." + (json.message = !"" ? "<br>" + json.message : ""));
                    } else {
                        swalError("Errore", json.message);
                    }
                },
                error: function () {
                    swalError("Errore", "Non è stato possibile caricare il documento");
                }
            });
        } else {
            swal.close();
        }
    });
}

function deleteRegister(idRegistro, day) {
    swalConfirm("Attenzione!", "Sicuro di voler eliminare tutti i registri del " + day + "?",
            function confirmDeleteRegistr() {
                showLoad();
                $.ajax({
                    type: "POST",
                    url: context + '/OperazioniSA?type=deleteRegister',
                    data: {"id": idRegistro},
                    success: function (data) {
                        closeSwal();
                        var json = JSON.parse(data);
                        if (json.result) {
                            swalSuccessReload("Registro Eliminato", "Registro Eliminato con successo");
                        } else {
                            swalError("Errore", json.message);
                        }
                    },
                    error: function () {
                        swalError("Errore", "Non è stato possibile modificare il documento");
                    }
                });
            })
}

