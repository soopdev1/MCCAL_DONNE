/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var context = document.getElementById("createCad").getAttribute("data-context");
var cad_json;

function ctrlForm() {
    var err = false;
    err = checkObblFields() ? true : err;
    err = checkEmail($("#email")) ? true : err;
    err = !cotrolTime() ? true : err;
    return !err;
}
$('#submit').on('click', function () {
    submitForm($("#kt_form"), "Cad Salvato!", "Operazione effettuata con successo.", ctrlForm(), id == null);
});

var days = ["Do", "Lu", "Ma", "Me", "Gi", "Ve", "Sa"];
var months = ["Gennaio", "Febbraio", "Marzo", "April", "Maggio", "Giugno", "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"];



$('#giorno').datepicker({
    rtl: KTUtil.isRTL(),
    orientation: "bottom left",
    todayHighlight: true,
    autoclose: true,
    startDate: new Date(),
    format: 'dd/mm/yyyy',
    firstDay: 1,
    templates: {
        leftArrow: '<i class="la la-angle-left"></i>',
        rightArrow: '<i class="la la-angle-right"></i>'
    },
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

$("#giorno").change(function () {
    getImpegni();
});


function getImpegni() {
    $('input.time').attr("disabled", "true");
    if (id == null) {
        $('input.time').val("");
    }
    if ($("#giorno").val() != "") {
        $.ajax({
            type: "POST",
            async: false,
            url: context + '/QueryCi?type=getCad',
            data: {"giorno": $("#giorno").val(), "id": id},
            success: function (data) {
                cad_json = data;
                writeImpegni();
            }
        });

        $('input.time').removeAttr("disabled");
        if (id == null) {
            if (cad_json.length > 0) {
                $('input.time').val(formattedTime(cad_json[cad_json.length - 1].orarioend));
            } else {
                $('input.time').val("08:00");
            }
        }
    } else {
        $('input.time').attr("disabled", "true");
    }
}

function writeImpegni() {
    $("#impegni").empty();
    if (cad_json.length == 0) {
        $("#impegni").append("<label>Nessun altro impegno per questo giorno:</label>");
    } else {
        $("#impegni").append("<label class='text-center'>Colloqui del <b>" + $("#giorno").val() + "</b>:</label><br>")
    }
    $.each(cad_json, function (index, c) {
        $("#impegni").append("<label><b><font class='kt-font-danger'>&diams;</font> " + c.cognome + " " + c.nome + "</b> dalle " + formattedTime(c.orariostart) + " alle " + formattedTime(c.orarioend) + "</label><br>");
    });
}

function cotrolTime() {
    if ($('#start').val() == $('#end').val()) {
        swalError("Attenzione!", "I due orari sono gli stessi");
        $("input.time").removeClass("is-valid").addClass("is-invalid");
        return false
    } else if ($('#start').val() != "" && $('#end').val() != "") {
        return cehckImpegni();
    }
}

function cehckImpegni() {
    var start = new Date('1970', '00', '01', $('#start').val().split(':')[0], $('#start').val().split(':')[1]);
    var end = new Date('1970', '00', '01', $('#end').val().split(':')[0], $('#end').val().split(':')[1]);
    var err = true;
    $.each(cad_json, function (i, c) {
        if ((start > new Date(c.orariostart) && start < new Date(c.orarioend)) || (end > new Date(c.orariostart) && end < new Date(c.orarioend))) {
            swalError("Attenzione!", "Non puoi sovrappore due colloqui");
            $("input.time").removeClass("is-valid").addClass("is-invalid");
            err = false;
        } else if (start <= new Date(c.orariostart) && end >= new Date(c.orarioend)) {
            swalError("Attenzione!", "Non puoi sovrappore due colloqui");
            $("input.time").removeClass("is-valid").addClass("is-invalid");
            err = false;
        }
    });
    return err;
}

$('#start').change(function (e) {
    var start = $('#start').val().split(':');
    var end = $('#end').val().split(':');
    if (new Date('00', '00', '00', start[0], start[1]) > new Date('00', '00', '00', end[0], end[1]))
        $('#end').val($('#start').val());
});
$('#end').change(function (e) {
    var start = $('#start').val().split(':');
    var end = $('#end').val().split(':');
    if (new Date('00', '00', '00', start[0], start[1]) > new Date('00', '00', '00', end[0], end[1]))
        $('#start').val($('#end').val());
});

var id = null;

jQuery(document).ready(function () {
    if (id != null) {
        getImpegni();
    } else {
        $('input.time').val("");
    }
});
