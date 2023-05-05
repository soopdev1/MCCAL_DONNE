/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var context = document.getElementById("registration").getAttribute("data-context");
var g_key = document.getElementById("registration").getAttribute("data-gKey");

grecaptcha.ready(function () {
    showLoadTitle('Stiamo verificando la tua identità');
    grecaptcha.execute(g_key).then(function (token) {
        $.ajax({
            type: "POST",
            async: false,
            url: context + '/Login',
            data: {'type': "botAreU", 'g-recaptcha-response': token},
            success: function (data) {
                closeSwal();
                var json = JSON.parse(data);
                if (json.result) {
                    $('#submit_change').css('display', '');
                } else {
                    $("#kt_form").remove();
                    $('#submit_change').remove();
                    fastSwalElementResponsive('<h4>Ci dispiace ma Google ti ha rilevato come bot</h4>', 'OK');
                }
            }
        });
    });
});

$('#regione').on('change', function (e) {
    $("#provincia").empty();
    $("#comune").empty();
    $("#comune").append('<option value="-">. . .</option>');
    if ($('#regione').val() != '-') {
        startBlockUILoad("#provincia_div");
        $("#provincia").append('<option value="-">Seleziona Provincia</option>');
        $.get(context + '/Login?type=getProvincia&regione=' + $('#regione').val(), function (resp) {
            var json = JSON.parse(resp);
            for (var i = 0; i < json.length; i++) {
                $("#provincia").append('<option value="' + json[i].value + '">' + json[i].desc + '</option>');
            }
            stopBlockUI("#provincia_div");
        });
    } else {
        $("#provincia").append('<option value="-">. . .</option>');
    }
});
$('#provincia').on('change', function (e) {
    $("#comune").empty();
    if ($('#provincia').val() != '-') {
        startBlockUILoad("#comune_div");
        $("#comune").append('<option value="-">Seleziona Comune</option>');
        $.get(context + '/Login?type=getComune&provincia=' + $('#provincia').val(), function (resp) {
            var json = JSON.parse(resp);
            for (var i = 0; i < json.length; i++) {
                $("#comune").append('<option value="' + json[i].value + '">' + json[i].desc + '</option>');
            }
            stopBlockUI("#comune_div");
        });
    } else {
        $("#comune").append('<option value="-">. . .</option>');
    }
});
function ctrlForm() {
    var err = false;
    var ra = $('#ragionesociale');
    var piva = $('#piva');
    var email = $('#email');
    var pec = $('#pec');
    var tel = $('#telefono_sa');
    var cel = $('#cell_sa');
    var indirizzo = $('#indirizzo');
    var cap = $('#cap');
    var comune = $('#comune');
    var nome_ad = $('#nome_ad');
    var cognome_ad = $('#cognome_ad');
    var datanascita = $('#kt_datepicker_4_2');
    var scadenza = $('#kt_datepicker_4_3');
    var nrodocumento = $('#nrodocumento');
    var nome_ref = $('#nome_ref');
    var cognome_ref = $('#cognome_ref');
    var tel_ref = $('#tel_ref');
    var agree = $('#agree');
    var cartaid = $('#cartaid');
    var cf = $('#cf');
    var req_piva = false;
    var req_cf = false;
    if (checkValue(ra, false)) {
        err = true;
    }
    if (checkValue(tel, false)) {
        err = true;
    }
    if (checkValue(cel, false)) {
        err = true;
    }
    if (checkValue(indirizzo, false)) {
        err = true;
    }
    if (checkCap(cap)) {
        err = true;
    }
    if (checkValue(nome_ad, false)) {
        err = true;
    }
    if (checkValue(cognome_ad, false)) {
        err = true;
    }
    if (checkValue(datanascita, false)) {
        err = true;
    }
    if (checkValue(scadenza, false)) {
        err = true;
    }
    if (checkValue(nrodocumento, false)) {
        err = true;
    }
    if (checkValue(nome_ref, false)) {
        err = true;
    }
    if (checkValue(cognome_ref, false)) {
        err = true;
    }
    if (checkValue(tel_ref, false)) {
        err = true;
    }
    if (checkValue(comune, true)) {
        err = true;
    }
    if (checkEmail(email) || Emailpresente()) {
        err = true;
    }
    if (checkEmail(pec)) {
        err = true;
    }
    if (checkPIva(piva) || pivaPresent()) {
        req_piva = true;
    }
    if (check_PIVA_CF(cf) || CFPresent()) {
        req_cf = true;
    }

    if (req_piva && req_cf) {
        err = true;
        if (req_piva && piva.val() == "") {
            piva.attr("class", "form-control");
        }
        if (req_cf && cf.val() == "") {
            cf.attr("class", "form-control");
        }
    }
    if (isChecked(agree, $('#l_termini'))) {
        err = true;
    }
    if (!ctrlPdf(cartaid) || !checkFileDim()) {
        err = true;
    }
    if (err) {
//        $('#msg_obbfield').css('display', '');
        return false;
    }
    return true;
}

$("#submit_change").on('click', function () {
    if (ctrlForm()) {
        showLoad();
        grecaptcha.execute(g_key).then(function (token) {
            $('#g-recaptcha-response').val(token);
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
                        swal.fire({
                            "title": '<h2 class="kt-font-io"><b>Accreditato con successo!</b></h2><br>',
                            "html": "<h4>Registrazione eseguita con successo, riceverai una email contenente le credenziali per l'accesso.</h4>",
                            "type": "success",
                            "width": '45%',
                            "confirmButtonClass": "btn btn-io",
                            onClose: () => {
                                location.href = 'login.jsp';
                            }
                        });
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
        });
    }
});

$('#piva').keydown(function (e) {
    if (this.value.length > 10)
        if (!(e.which == '46' || e.which == '8' || e.which == '13')) // backspace/enter/del
            e.preventDefault();
});

$('#piva').on("change", function () {
    if (!checkPIva($('#piva'))) {
        pivaPresent();
    }
    if ($('#piva').val() == "") {
        $('#piva').attr("class", "form-control");
    }
});

$('#cf').on("change", function () {
    if (!check_PIVA_CF($('#cf'))) {
        CFPresent();
    }
    if ($('#cf').val() == "") {
        $('#cf').attr("class", "form-control");
    }
});

function CFPresent() {
    var err;
    $.ajax({
        type: "GET",
        async: false,
        url: context + '/Login?type=checkCF&cf=' + $('#cf').val(),
        success: function (data) {
            if (data != null && data != 'null') {
                swal.fire({
                    "title": 'Errore',
                    "html": "<h3>Codice Fiscale già presente</h3>",
                    "type": "error",
                    cancelButtonClass: "btn btn-io-n",
                });
                $('#cf').attr("class", "form-control is-invalid");
                err = true;
            } else {
                $('#cf').attr("class", "form-control is-valid");
                err = false;
            }
        }
    });
    return err;
}

function pivaPresent() {
    var err;
    $.ajax({
        type: "GET",
        async: false,
        url: context + '/Login?type=checkPiva&piva=' + $('#piva').val(),
        success: function (data) {
            if (data != null && data != 'null') {
                swal.fire({
                    "title": 'Errore',
                    "html": "<h3>Partita iva già presente</h3>",
                    "type": "error",
                    cancelButtonClass: "btn btn-io-n",
                });
                $('#piva').attr("class", "form-control is-invalid");
                err = true;
            } else {
                $('#piva').attr("class", "form-control is-valid");
                err = false;
            }
        }
    });
    return err;
}

$('#email').on("change", function () {
    if (!checkEmail($('#email'))) {
        Emailpresente();
    }
});

function Emailpresente() {
    var err;
    $.ajax({
        type: "GET",
        async: false,
        url: context + '/Login?type=checkEmail&email=' + $('#email').val(),
        success: function (data) {
            if (data != null && data != 'null') {
                swal.fire({
                    "title": 'Errore',
                    "html": "<h3>Email già presente</h3>",
                    "type": "error",
                    cancelButtonClass: "btn btn-io-n",
                });
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
$('#cap').keydown(function (e) {
    if (this.value.length > 4)
        if (!(e.which == '46' || e.which == '8' || e.which == '13')) // backspace/enter/del
            e.preventDefault();
});