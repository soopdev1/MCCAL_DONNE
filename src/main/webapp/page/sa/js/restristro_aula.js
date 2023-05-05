/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var context = document.getElementById("restristro_aula").getAttribute("data-context");

var offset = moment().utcOffset() * 60 * 1000;

var millis_start = 0, millis_end = 0, millis_day = 0, millis_my_end = 0, millis_my_start = 0;//vengono settati nella pagina UploadRegistroAula_new.jsp

var start, end;
var old_start, old_end;
var my_start, my_end;

function setDay() {
    old_start = new Date(millis_start);
    old_end = new Date(millis_end);
    if (millis_start === 0) {
        old_start.setHours(7, 0, 0);
    }
    if (millis_end === 0) {
        old_end.setHours(22, 0, 0);
    }
    start = new Date(millis_day), end = new Date(millis_day);

    start.setHours(old_start.getHours(), old_start.getMinutes());//setto ora minima inizio a fine lezione precedente
    end.setHours(old_end.getHours(), old_end.getMinutes());

    if (millis_my_end === 0 && millis_my_start === 0) {
        my_start = start;
        my_end = end;
    } else {
        my_start = new Date(millis_day + millis_my_start + offset);
        my_end = new Date(millis_day + millis_my_end + offset);
    }
}

var min_time = "", max_time = "";//sono l'ora inizio e fine della darate della lezione. serve per fare i controlli sul singolo ragazzo.
var days = ["Do", "Lu", "Ma", "Me", "Gi", "Ve", "Sa"];
var months = ["Gennaio", "Febbraio", "Marzo", "April", "Maggio", "Giugno", "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"];




function genetateTime() {
    setDay();
    $('#range').daterangepicker({
        timePicker: true,
        autoApply: true,
        minDate: start,
        maxDate: end,
        startDate: my_start,
        endDate: my_end,
        timePickerIncrement: 5,
        locale: {
            firstDay: 1,
            format: 'HH:mm',
            daysOfWeek: days,
            monthNames: months,
        }
    }, function (start, end, label) {
        min_time = start.format('HH:mm');
        max_time = end.format('HH:mm');
        $('#range2').val(start.format('HH:mm') + ' - ' + end.format('HH:mm'));
        $('#range2').trigger("change");
    });

    $(".daterangepicker.ltr.show-calendar.opensright").change(function () {
        cssDatePicker();
    });
}

$("#range2").click(function () {
    $('#range').trigger("click");
    cssDatePicker();
});

$(".daterangepicker.ltr.show-calendar.opensright").change(function () {
    cssDatePicker();
});

function cssDatePicker() {
    var top_ = Number($("#range2").last().offset().top) + Number($("#range2").outerHeight());
    var left_ = Number($("#range2").last().offset().left);
    $("table.table-condensed").css("display", "none");
    $(".daterangepicker.ltr.show-calendar.opensright").css({"top": top_, "left": left_});
}

$('#range2').change(function (e) {
    var date = $(e.target).val();
    if (date != "") {
        $('input.time-a.in').val(min_time);
        $('input.time-a.out').val(max_time);
        initTimeAllievi();
        $('input.time-a').removeAttr("disabled");
        $('input.time-a').removeClass("disable-input");
    } else {
        $('input.time-a').attr("disabled", true);
        $('input.time-a').addClass("disable-input");
        $('input.time-a').val("");
    }
});

var allievi_old = [];
$('#allievi').on("change", function () {
    ingressiAllevi();
});

$('#allievi').select2({//setta placeholder nella multiselect
    placeholder: "Seleziona Allievi",
});

function ingressiAllevi() {
    var allievi = $('#allievi').val();
    var input = "<div id='ingressi_@id' class='col-lg-12 col-md-12'>"
            + "<div class='row'>"
            + "<div class='col-6'>"
            + "<input class='form-control' value='@nome' readonly>"
            + "</div>"
            + "<div class='col-3'>"
            + "<input class='form-control disable-input obbligatory time-a in' readonly autocomplete='off' disabled placeholder='ingresso' name='time_start_@id' id='time_start_@id'>"
            + "</div>"
            + "<div class='col-3'>"
            + "<input class='form-control disable-input obbligatory time-a out' readonly autocomplete='off' disabled placeholder='uscita' name='time_end_@id' id='time_end_@id'>"
            + "</div>"
            + "</div>"
            + "</div>";
    if (allievi.length > 0) {
        if (allievi_old.length > 0) {
            $.each(allievi_old, function (i, a) {
                if (!allievi.includes(a)) {
                    $('#ingressi_' + a).remove();
                }
            });
        }
        $.each(allievi, function (i, a) {
            if (!allievi_old.includes(a)) {
                $('#ingressi_allievi').append(
                        input.split("@id").join(a)
                        .replace("@nome", $("#allievi option[value='" + a + "']").text()));
            }
        });
        if (min_time != "" && max_time != "") {
            initTimeAllievi();
            $('input.time-a').removeAttr("disabled");
            $('input.time-a').removeClass("disable-input");
        }
        createEvent();
        allievi_old = allievi;
    } else {
        allievi_old = [];
        $('#ingressi_allievi').empty();
    }
}

function initTimeAllievi() {
    $('input.time-a').timepicker({
        showMeridian: false,
        interval: 5,
        showInputs: false,
        snapToStep: true,
        icons: {
            up: 'la la-angle-up',
            down: 'la la-angle-down'
        }
    });
}

function createEvent() {//dovuto fare doppio perchè singolo dava i numeri
    $(".time-a.in").change(function (e) {
        var div = $($(this).parent()[0]);
        var row = $($(div).parent()[0]);
        var input_out = $(row.find('input.time-a.out')[0]);
        var input_in = $(row.find('input.time-a.in')[0]);
        input_in.val(checktime(input_in.val(), min_time, getMinHour(max_time, input_out.val())));
    });
    $(".time-a.out").change(function (e) {
        var div = $($(this).parent()[0]);
        var row = $($(div).parent()[0]);
        var input_out = $(row.find('input.time-a.out')[0]);
        var input_in = $(row.find('input.time-a.in')[0]);
        input_out.val(checktime(input_out.val(), getMaxHour(min_time, input_in.val()), max_time));
    });
}

function setStartEnd(json) {

    $.each(json, function (i, j) {
        $("#time_start_" + j.id).val(getTime(new Date(j.start)));
        $("#time_end_" + j.id).val(getTime(new Date(j.end)));
    });
}

var ore, ore_max, ore_max_tot, ore_attuali;

function ctrlForm() {
    var err = false;
//                err = !checkRequiredFile() ? true : err;
    err = checkObblFields() ? true : err;
    err = controlTotHour() ? true : err;
    return !err;
}

$('#range2').change(function (e) {
    controlTotHour();
});

function controlTotHour() {
    if ((ore + calculateHour()) > ore_max) {
        fastSwalShow("<h2>Superate le " + ore_max + " h giornaliere</h2>");
        $('#range2').removeClass("is-valid").addClass("is-invalid");
        $('input.time-a').removeClass("is-valid").addClass("is-invalid");
        return true;
    } else if ((ore_attuali + calculateHour()) > ore_max_tot) {
        fastSwalShow("<h2>Superate le " + ore_max_tot + " h tot.<br> Max h disponibili " + (ore_max_tot - ore_attuali) + "</h2>");
        $('#range2').removeClass("is-valid").addClass("is-invalid");
        $('input.time-a').removeClass("is-valid").addClass("is-invalid");
        return true;
    }
    return false;
}

function calculateHour() {
    if ($('#range2').val() != '') {
        var range = $('#range2').val().split("-");
        var h1 = range[0].trim().split(":");
        var h2 = range[1].trim().split(":");
        return (new Date("00", "00", "00", h2[0], h2[1]).getTime() - new Date("00", "00", "00", h1[0], h1[1]).getTime()) / 3600000;
    }
    return false;
}

$('#submit').on('click', function () {
    submitForm($('#kt_form'), "Registro caricato", "Registro caricato con successo", ctrlForm(), true);
});


function getRegisters(giorno) {
    var registri;
    $.ajax({
        async: false,
        type: 'POST',
        url: context + "/QuerySA",
        data: {'type': 'getRegistriDay', 'idprogetto': $("#idprogetto").val(), "giorno": giorno},
        success: function (data) {
            registri = JSON.parse(data);
        },
        error: {
            //gestisci errore
        },
    });
    return registri;
}

jQuery(document).ready(function () {
    ingressiAllevi();
});