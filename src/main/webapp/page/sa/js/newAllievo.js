/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


var context = document.getElementById("newAllievo").getAttribute("data-context");

$('#regionenascita').on('change', function (e) {
    $("#provincianascita").empty();
    $("#comunenascita").empty();
    $("#comunenascita").append('<option value="-">. . .</option>');
    if ($('#regionenascita').val() !== '-') {
        startBlockUILoad("#provincianascita_div");
        $("#provincianascita").append('<option value="-">Seleziona Provincia</option>');
        $.get(context + '/Login?type=getProvincia&regione=' + $('#regionenascita').val(), function (resp) {
            var json = JSON.parse(resp);
            for (var i = 0; i < json.length; i++) {
                $("#provincianascita").append('<option value="' + json[i].value + '">' + json[i].desc + '</option>');
            }
            stopBlockUI("#provincianascita_div");
        });
    } else {
        $("#provincianascita").append('<option value="-">. . .</option>');
    }
});

$('#provincianascita').on('change', function (e) {
    $("#comunenascita").empty();
    if ($('#provincianascita').val() !== '-') {
        startBlockUILoad("#comunenascita_div");
        $("#comunenascita").append('<option value="-">Seleziona Comune</option>');
        $.get(context + '/Login?type=getComune&provincia=' + $('#provincianascita').val(), function (resp) {
            var json = JSON.parse(resp);
            for (var i = 0; i < json.length; i++) {
                $("#comunenascita").append('<option value="' + json[i].value + '">' + json[i].desc + '</option>');
            }
            stopBlockUI("#comunenascita_div");
        });
    } else {
        $("#comunenascita").append('<option value="-">. . .</option>');
    }
});

$('#regioneres').on('change', function (e) {
    $("#provinciares").empty();
    $("#comuneres").empty();
    $("#comuneres").append('<option value="-">. . .</option>');
    if ($('#regioneres').val() !== '-') {
        startBlockUILoad("#provincia_div");
        $("#provinciares").append('<option value="-">Seleziona Provincia</option>');
        $.get(context + '/Login?type=getProvincia&regione=' + $('#regioneres').val(), function (resp) {
            var json = JSON.parse(resp);
            for (var i = 0; i < json.length; i++) {
                $("#provinciares").append('<option value="' + json[i].value + '">' + json[i].desc + '</option>');
            }
            stopBlockUI("#provinciares_div");
        });
    } else {
        $("#provinciares").append('<option value="-">. . .</option>');
    }
});

$('#provinciares').on('change', function (e) {
    $("#comuneres").empty();
    if ($('#provinciares').val() !== '-') {
        startBlockUILoad("#comuneres_div");
        $("#comuneres").append('<option value="-">Seleziona Comune</option>');
        $.get(context + '/Login?type=getComune&provincia=' + $('#provinciares').val(), function (resp) {
            var json = JSON.parse(resp);
            for (var i = 0; i < json.length; i++) {
                $("#comuneres").append('<option value="' + json[i].value + '">' + json[i].desc + '</option>');
            }
            stopBlockUI("#comuneres_div");
        });
    } else {
        $("#comuneres").append('<option value="-">. . .</option>');
    }
});

$('#regionedom').on('change', function (e) {
    $("#provinciadom").empty();
    $("#comunedom").empty();
    $("#comunedom").append('<option value="-">. . .</option>');
    if ($('#regionedom').val() !== '-') {
        startBlockUILoad("#provinciadom_div");
        $("#provinciadom").append('<option value="-">Seleziona Provincia</option>');
        $.get(context + '/Login?type=getProvincia&regione=' + $('#regionedom').val(), function (resp) {
            var json = JSON.parse(resp);
            for (var i = 0; i < json.length; i++) {
                $("#provinciadom").append('<option value="' + json[i].value + '">' + json[i].desc + '</option>');
            }
            stopBlockUI("#provinciadom_div");
        });
    } else {
        $("#provinciadom").append('<option value="-">. . .</option>');
    }
});

$('#provinciadom').on('change', function (e) {
    $("#comunedom").empty();
    if ($('#provinciadom').val() !== '-') {
        startBlockUILoad("#comunedom_div");
        $("#comunedom").append('<option value="-">Seleziona Comune</option>');
        $.get(context + '/Login?type=getComune&provincia=' + $('#provinciadom').val(), function (resp) {
            var json = JSON.parse(resp);
            for (var i = 0; i < json.length; i++) {
                $("#comunedom").append('<option value="' + json[i].value + '">' + json[i].desc + '</option>');
            }
            stopBlockUI("#comunedom_div");
        });
    } else {
        $("#comunedom").append('<option value="-">. . .</option>');
    }
});

function domicilio() {
    if ($('#checkind').is(":checked") === false) {
        $('#msgdom').css("display", "none");
        $("#indirizzodom").removeAttr("disabled");
        $("#capdom").removeAttr("disabled");
        $("#civicodom").removeAttr("disabled");
        $("#regionedom").removeAttr("disabled");
        $("#provinciadom").removeAttr("disabled");
        $("#comunedom").removeAttr("disabled");
        $("#indirizzodom").removeAttr("placeholder");
        $("#capdom").removeAttr("placeholder");
        $("#civicodom").removeAttr("placeholder");
    } else {
        $('#msgdom').css("display", "");
        $("#indirizzodom").attr("disabled", true);
        $("#indirizzodom").attr("placeholder", "Indirizzo residenza");
        $("#capdom").attr("disabled", true);
        $("#capdom").attr("placeholder", "Cap residenza");
        $("#capdom").removeClass("is-invalid");
        $("#indirizzodom").removeClass("is-invalid");
        $("#civicodom").attr("disabled", true);
        $("#civicodom").attr("placeholder", "Civico res.");
        $("#civicodom").removeClass("is-invalid");
        $("#regionedom").attr("disabled", true);
        $("#provinciadom").attr("disabled", true);
        $("#comunedom").attr("disabled", true);
        $("#comunedom_div").removeClass("is-invalid is-invalid-select");
        $("#provinciadom_div").removeClass("is-invalid is-invalid-select");
        $("#regionedom_div").removeClass("is-invalid is-invalid-select");
    }
}

$('#stato').on("change", function () {
    setCittadinanza();
});

function setCittadinanza() {
    if ($('#stato').val() !== '000') {
        $('#regionenascita').attr("disabled", true);
        $('#provincianascita').attr("disabled", true);
        $('#comunenascita').attr("disabled", true);
        $('#regionenascita').removeClass("obbligatory");
        $('#provincianascita').removeClass("obbligatory");
        $('#comunenascita').removeClass("obbligatory");
        $('#regionenascita_div').removeClass("obbligatory is-invalid-select is-valid-select");
        $('#provincianascita_div').removeClass("obbligatory is-invalid-select is-valid-select");
        $('#comunenascita_div').removeClass("obbligatory is-invalid-select is-valid-select");
    } else {
        $('#regionenascita').removeAttr("disabled");
        $('#provincianascita').removeAttr("disabled");
        $('#comunenascita').removeAttr("disabled");
        $('#regionenascita').addClass("obbligatory");
        $('#provincianascita').addClass("obbligatory");
        $('#comunenascita').addClass("obbligatory");
    }
}

function ctrlForm() {
    var err = false;
    if (!$('#checkind').is(":checked")) {
        $('#indirizzodom').addClass("obbligatory");
        $('#capdom').addClass("obbligatory");
        $('#civicodom').addClass("obbligatory");
        $('#comunedom').addClass("obbligatory");
        $('#regionedom').addClass("obbligatory");
        $('#provinciadom').addClass("obbligatory");
    } else {
        $('#indirizzodom').removeClass("obbligatory");
        $('#capdom').removeClass("obbligatory");
        $('#civicodom').removeClass("obbligatory");
        $('#comunedom').removeClass("obbligatory");
        $('#regionedom').removeClass("obbligatory");
        $('#provinciadom').removeClass("obbligatory");
    }

    err = checkObblFields() ? true : err;
    if (checkCF($('#codicefiscale'))) {
        err = checkinfoCF() ? true : err;
        err = CFPresent() ? true : err;
    } else {
        err = true;
    }
    if (!checkEmail($('#email'))) {
        err = EmailPresente() ? true : err;
    } else {
        err = true;
    }
    err = !checkRequiredFile() ? true : err;
    err = !checkFileExtAndDim(['pdf']) ? true : err;
    return !err;
}

$('#submit_change').on('click', function () {
    if (ctrlForm()) {
        showLoad();
        $('#kt_form').ajaxSubmit({
            error: function () {
                closeSwal();
                swal.fire({
                    "title": 'Errore',
                    "text": "Riprovare, se l'errore persiste contattare il servizio clienti",
                    "type": "error",
                    cancelButtonClass: "btn btn-io-n",
                });
            },
            success: function (resp) {
                var json = JSON.parse(resp);
                closeSwal();
                if (json.result) {
                    resetInput();
                    swalSuccessReload("Allievo aggiunto!", "Operazione effettuata con successo.");
//                                swal.fire({
//                                    "title": '<h2 class="kt-font-io"><b>Allievo aggiunto!</b></h2><br>',
//                                    "html": "<h4>Operazione effettuata con successo.</h4>",
//                                    "type": "success",
//                                    "width": '45%',
//                                    "confirmButtonClass": "btn btn-io",
//                                });
                } else {
                    swal.fire({
                        "title": '<h2 class="kt-font-io-n"><b>Errore!</b></h2><br>',
                        "html": "<h4>" + json.message + "</h4>",
                        "type": "error",
                        cancelButtonClass: "btn btn-io-n"
                    });
                }
            }
        });
    }
});

$('#email').on("change", function () {
    if (checkEmail($('#email'))) {
        EmailPresente();
    }
});

function EmailPresente() {
    var err;
    $.ajax({
        type: "GET",
        async: false,
        url: context + '/OperazioniSA?type=checkEmail&email=' + $('#email').val(),
        success: function (data) {
            if (data !== null && data !== 'null') {
                swal.fire({
                    "title": 'Errore',
                    "html": "<h3>Email già presente</h3>",
                    "type": "error",
                    cancelButtonClass: "btn btn-io-n"
                });
                fastSwal("Attenzione!", "Email già presente", "wobble");
                $('#email').attr("class", "form-control is-invalid");
                err = true;
            } else {
                $('#email').attr("class", "form-control is-valid");
                err = false;
            }
        }
    });
    return err;
}


$('#codicefiscale').on("change", function () {
    if (checkCF($('#codicefiscale'))) {
        CFPresent();
    }
});

function checkinfoCF() {
    var cf = $('#codicefiscale');
    var nome = $('#nome');
    var cognome = $('#cognome');
    var data = $('#datanascita');
    var stato = $('#stato');
    var checkdata = false;
    var err = false;
    var msg = "<b style='padding:10px;color: #fd397a!important;'>Attenzione i seguenti dati anagrafici non sono conformi con il codice fiscale inserito (";
    //CONTROLLO NOME ---> 1,3,4 CONSONANTI SE CE NE SONO ALMENO 4, ALTRIMENTI AGGIUNGO VOCALI NEL LORO ORDINE 
    if (!check_nome_CF(nome.val().toUpperCase(), cf.val().substring(3, 6).toUpperCase())) {
        msg += "Nome";
        $('#nome').removeClass("is-valid").addClass("is-invalid");
        err = true;
    } else {
        $('#nome').removeClass("is-invalid").addClass("is-valid");
    }
    //CONTROLLO COGNOME ---> 1,2,3 CONSONANTI SE CE NE SONO ALMENO 3, ALTRIMENTI AGGIUNGO VOCALI NEL LORO ORDINE 
    if (!check_cognome_CF(cognome.val().toUpperCase(), cf.val().substring(0, 3).toUpperCase())) {
        msg += err ? ", Cognome" : "Cognome";
        $('#cognome').removeClass("is-valid").addClass("is-invalid");
        err = true;
    } else {
        $('#cognome').removeClass("is-invalid").addClass("is-valid");
    }
    //CONTROLLO MESE - GIORNO - ANNO
    if (!check_mese_CF(data.val().substring(3, 5), cf.val().substring(8, 9).toUpperCase())) {
        msg += err ? ", Mese di nascita" : "Mese di nascita";
        checkdata = true;
    }
    if (!check_giorno_CF(Number(data.val().substring(0, 2)), Number(cf.val().substring(9, 11)))) {
        msg += err ? ", Giorno di nascita" : "Giorno di nascita";
        checkdata = true;
    }
    if (data.val().substring(8) !== cf.val().substring(6, 8)) {
        msg += err ? ", Anno di nascita" : "Anno di nascita";
        checkdata = true;
    }
    if (checkdata) {
        err = true;
        $('#datanascita').removeClass("is-valid").addClass("is-invalid");
    } else {
        $('#datanascita').removeClass("is-invalid").addClass("is-valid");
    }
    //CONTROLLO COMUNE O, SE ESTERO, STATO
    $('#regionenascita_div').removeClass("is-valid-select").removeClass("is-invalid-select");
    $('#provincianascita_div').removeClass("is-valid-select").removeClass("is-invalid-select");
    $('#comunenascita_div').removeClass("is-valid-select").removeClass("is-invalid-select");
    if (stato.val() === "000") {
        if ($('#comunenascita').val() !== null && $('#comunenascita').val() !== "-") {
            $.ajax({
                type: "GET",
                async: false,
                url: context + "/OperazioniSA?type=getCodiceCatastaleComune&idcomune=" + $('#comunenascita').val(),
                success: function (resp) {
                    $('#stato_div').removeClass("is-invalid-select").addClass("is-valid-select");
                    if (check_comune_CF(resp, cf.val().substring(11, 15).toUpperCase())) {
                        msg += err ? ", Comune di nascita" : "Comune di nascita";
                        $('#comunenascita_div').removeClass("is-valid-select").addClass("is-invalid-select");
                        err = true;
                    } else {
                        $('#comunenascita_div').removeClass("is-invalid-select").addClass("is-valid-select");
                    }
//                    if (resp != cf.val().substring(11, 15).toUpperCase()) {
//                        msg += err ? ", Comune di nascita" : "Comune di nascita";
//                        $('#comunenascita_div').removeClass("is-valid-select").addClass("is-invalid-select");
//                        err = true;
//                    } else {
//                        $('#comunenascita_div').removeClass("is-invalid-select").addClass("is-valid-select");
//                    }
                }
            });
        } else {
            msg += err ? ", Comune di nascita" : " Comune di nascita";
            $('#comunenascita_div').removeClass("is-valid-select").addClass("is-invalid-select");
            err = true;
        }
    } else {
        var cf_sel = $('#stato').find('option:selected').attr("data-cf");
        if (cf_sel !== cf.val().substring(11, 15).toUpperCase()) {
            msg += err ? ", Stato di nascita" : "Stato di nascita";
            $('#stato_div').removeClass("is-valid-select").addClass("is-invalid-select");
            err = true;
        } else {
            $('#stato_div').removeClass("is-invalid-select").addClass("is-valid-select");
        }
    }

    if (err) {
        msg += ").</b>";
        $("#msg_cf").html(msg);
        $("#msgrow").css("display", "");
    } else {
        $("#msg_cf").html("<b style='padding:10px;color: #0abb87!important;'>Dati anagrafici coerenti con il codice fiscale inserito.</b>");
        $("#msgrow").css("display", "");
    }
    return err;
}

function CFPresent() {
    var err;
    $.ajax({
        type: "GET",
        async: false,
        url: context + '/OperazioniSA?type=checkCF&cf=' + $('#codicefiscale').val(),
        success: function (data) {
            if (data !== null && data !== 'null') {
                swal.fire({
                    "title": 'Errore',
                    "html": "<h3>Codice fiscale già presente</h3>",
                    "type": "error",
                    cancelButtonClass: "btn btn-io-n"
                });
                fastSwal("Attenzione!", "Codice fiscale già presente", "wobble");
                $('#codicefiscale').attr("class", "form-control is-invalid");
                err = true;
            } else {
                $('#codicefiscale').attr("class", "form-control is-valid");
                err = false;
            }
        }
    });
    return err;
}
$('#capres').keydown(function (e) {
    if (this.value.length > 4)
        if (!(e.which === '46' || e.which === '8' || e.which === '13')) // backspace/enter/del
            e.preventDefault();
});
$('#capdom').keydown(function (e) {
    if (this.value.length > 4)
        if (!(e.which === '46' || e.which === '8' || e.which === '13')) // backspace/enter/del
            e.preventDefault();
});

