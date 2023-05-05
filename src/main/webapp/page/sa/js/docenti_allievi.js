/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var context = document.getElementById("docenti_allievi").getAttribute("data-context");
var doc_docenti = new Map();

$('#docenti').select2({//setta placeholder nella multiselect
    placeholder: "Seleziona Docenti",
});

$('#docenti').on("change", function () {
    updateDivDoenti();
});


function updateDivDoenti() {
    var today = new Date();
    var docenti = $('#docenti').val();
    var input = '<div id="tracher_@id" class="col-lg-6 col-md-12">'
            + '<div class="input-group">'
            + '<input class="form-control" id="@id_teacher" value="@nome" readonly>'
            + '<div class="input-group-append">'
            + '@docid'
            + '</div>'
            + '<div class="input-group-append">'
            + '@curr'
            + '</div>'
            + '</div>'
            + '</div>';
    //fancyDocument
    var doc_id = '<a class=" btn btn-io btn-icon" target="blank_" href="' + context + '/OperazioniGeneral?type=showDoc&path=@path"'
            + ' data-container="body" data-html="true" data-toggle="kt-tooltip" title="Visualizza Documento d\'Identità">'
            + '<i class="fa fa-id-card"></i></a>';
    var curr = '<a class=" btn btn-io-n btn-icon" target="blank_" href="' + context + '/OperazioniGeneral?type=showDoc&path=@path"'
            + ' data-container="body" data-html="true" data-toggle="kt-tooltip" title="Visualizza CV">'
            + '<i class="fa fa-file-alt"></i></a>';
    var no_doc_id = '<input type="hidden" id="docente_@id" class="obbligatory">'
            + '<a class="btn btn-danger btn-icon" onclick="uploadDocId(@id);" href="javascript:void(0);"'
            + ' data-container="body" data-html="true" data-toggle="kt-tooltip" title="<b class=&quot;kt-font-danger&quot;>Necessario caricare Documento d\'Identità</b>">'
            + '<i class="fa fa-cloud-upload-alt"></i></a>';
    var no_curr = '<input type="hidden" id="docente_@id" class="obbligatory">'
            + '<a class="btn btn-danger btn-icon" onclick="uploadCurriculum(@id);" href="javascript:void(0);"'
            + ' data-container="body" data-html="true" data-toggle="kt-tooltip" title="<b class=&quot;kt-font-danger&quot;>Necessario caricare CV</b>">'
            + '<i class="fa fa-file-upload"></i></a>';
    var all_doc = "";

    $('#teacher_doc').empty();

    if (docenti.length > 0) {
        $.each(docenti, function (i, a) {
            all_doc = input;
            if (doc_docenti.get(a).docid != null && doc_docenti.get(a).docid != 'null' && doc_docenti.get(a).scadenza > today) {
                all_doc = all_doc.replace("@docid", doc_id.replace("@path", doc_docenti.get(a).docid));
            } else {
                all_doc = all_doc.replace("@docid", no_doc_id);
            }
            if (doc_docenti.get(a).curriculum != null && doc_docenti.get(a).curriculum != 'null') {
                all_doc = all_doc.replace("@curr", curr.replace("@path", doc_docenti.get(a).curriculum));
            } else {
                all_doc = all_doc.replace("@curr", no_curr);
            }
            $('#teacher_doc').append(
                    all_doc.split("@id").join(a)
                    .replace("@nome", $("#docenti option[value='" + a + "']").text()));
        });
        $('[data-toggle="kt-tooltip"]').tooltip();
    }
}

function uploadDocId(id) {
    swal.fire({
        title: "Carica Documento d'Identità ",
        html: '<div id="swalDocId">'
                + '<div class="custom-file">'
                + '<input type="file" tipo="obbligatory" class="custom-file-input" accept="application/pdf" name="docid" id="docid" onchange="return checkFileExtAndDim([&quot;pdf&quot;]);">'
                + '<label class="custom-file-label selected" id="label_file" style="text-align: left;">Seleziona File</label>'
                + '</div><br><br>'
                + '<input type="text" class="form-control obbligatory" name="scadenza" id="scadenza" placeholder="data scadenza documento" autocomplete="off" readonly/>'
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
            $('#docid').change(function (e) {
                if (e.target.files.length != 0)
                    //$('#label_file').html(e.target.files[0].name);
                    if (e.target.files[0].name.length > 30)
                        $('#label_file').html(e.target.files[0].name.substring(0, 30) + "...");
                    else
                        $('#label_file').html(e.target.files[0].name);
                else
                    $('#label_file').html("Seleziona File");
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
            $.ajax({
                type: "POST",
                url: context + '/OperazioniSA?type=uploadDocIdDocente&id=' + id,
                data: fdata,
                processData: false,
                contentType: false,
                success: function (data) {
                    closeSwal();
                    var json = JSON.parse(data);
                    if (json.result) {
                        doc_docenti.get(id.toString()).docid = json.path;
                        doc_docenti.get(id.toString()).scadenza = new Date(json.scadenza);
                        updateDivDoenti();
                        swalSuccess("Documento Caricato", "Documento caricato con successo");
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
    }
    );
}

function uploadCurriculum(id) {
    swal.fire({
        title: 'Carica Curriculum ',
        html: '<div id="swalCurriculum">'
                + '<div class="custom-file">'
                + '<input type="file" tipo="obbligatory" class="custom-file-input" accept="application/pdf" name="curriculum" id="curriculum" onchange="return checkFileExtAndDim([&quot;pdf&quot;]);">'
                + '<label class="custom-file-label selected" id="label_file" style="text-align: left;">Seleziona File</label>'
                + '</div>'
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
            $('#curriculum').change(function (e) {
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
            err = !checkRequiredFileContent($('#swalCurriculum')) ? true : err;
            if (!err) {
                return new Promise(function (resolve) {
                    resolve({
                        "file": $('#curriculum')[0].files[0]
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
                url: context + '/OperazioniSA?type=uploadCurriculumDocente&id=' + id,
                data: fdata,
                processData: false,
                contentType: false,
                success: function (data) {
                    closeSwal();
                    var json = JSON.parse(data);
                    if (json.result) {
                        doc_docenti.get(id.toString()).curriculum = json.path;
                        updateDivDoenti();
                        swalSuccess("Documento Caricato", "Documento caricato con successo");
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

var canali = new Map();
var allievi_old = [];
$('#allievi').on("change", function () {
    conoscenzeAllevi();
});

$('#allievi').select2({//setta placeholder nella multiselect
    placeholder: "Seleziona Allievi",
});

function conoscenzeAllevi() {
    var allievi = $('#allievi').val();
    var input = "<div id='knowledge_@id' class='col-lg-12 col-md-12'>"
            + "<div class='input-group'>"
            + "<input class='form-control col-6' value='@nome' readonly>"
            + "<input class='form-control col-6 obbligatory' name='knowledge_@id_input' value='@canale' placeholder='canale conoscenza'>"
            + "</div>"
            + "</div>";
    if (allievi.length > 0) {
        if (allievi_old.length > 0) {
            $.each(allievi_old, function (i, a) {
                if (!allievi.includes(a)) {
                    $('#knowledge_' + a).remove();
                }
            });
        }
        $.each(allievi, function (i, a) {
            if (!allievi_old.includes(a)) {
                $('#knowlege_channel').append(
                        input.split("@id").join(a)
                        .replace("@nome", $("#allievi option[value='" + a + "']").text())
                        .replace("@canale", canali.get(a) == null ? "" : canali.get(a)));
            }
        });
        allievi_old = allievi;
    } else {
        allievi_old = [];
        $('#knowlege_channel').empty();
    }
}
