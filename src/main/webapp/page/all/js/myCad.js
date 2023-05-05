var context = document.getElementById("myCad").getAttribute("data-context");
var calendar;

document.addEventListener('DOMContentLoaded', function () {
    var calendarEl = document.getElementById('kt_calendar');
    var first = getFirstDayCalendar();
    calendar = new FullCalendar.Calendar(calendarEl, {
        events: {url: context + "/QueryCi?type=getMyCad&data=" + first},
        locale: 'it',
        plugins: ['interaction', 'dayGrid', 'timeGrid', 'list'],
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
        },
        contentHeight: 920,
        validRange: {
            start: first,
        },
//        eventLimit: true,
        defaultDate: new Date(),
        editable: false,
        eventRender: function (e) {
            var t = $(e.el);
            t.attr("id", e.event.id);//aggiungo id all'elemento
            e.event.extendedProps && e.event.extendedProps.description && (t.hasClass("fc-day-grid-event") ? (t.data("content", e.event.extendedProps.description), t.data("placement", "top"), t.data("html", true), KTApp.initPopover(t)) : t.hasClass("fc-time-grid-event") ? t.find(".fc-title").append('<div class="fc-description">' + e.event.extendedProps.description + "</div>") : 0 !== t.find(".fc-list-item-title").lenght && t.find(".fc-list-item-title").append('<div class="fc-description">' + e.event.extendedProps.description + "</div>"))
        },
        eventClick: function (info) {
            option(info.event.id, info.event.extendedProps.stato, info.event.title);
        }

    });
    calendar.render();
});

function option(id, stato, titolo) {
    var html = '<h4>Colloquio di ' + titolo + '</h4><div class="row">'
            + '<div class="col-6"><a class="btn btn-outline-brand block fancyBoxReload2" onclick="swal.close();" href="'+context+'/page/all/modifyCad.jsp?idCad=@id"><i class="fa fa-edit"></i> Modifica</a></div>';

    if (stato == 0) {
        html += '<div class="col-6"><a class="btn btn-outline-brand block" onclick="swal.close();logCAD(@id)" href="javascript:void(0);"><i class="fa fa-sign-in-alt"></i> Accedi</a></div>'
        html += '<div class="col-6"><a class="btn btn-outline-brand block" onclick="changeStateCAD(@id, 1, \'chiudere\', \'chiusa\')" href="javascript:void(0);"><i class="fa fa-power-off"></i> Chiudi</a></div>';
    } else {
        html += '<div class="col-6"><a class="btn btn-outline-brand block" onclick="changeStateCAD(@id, 0, \'aprire\', \'aperto\')" href="javascript:void(0);"><i class="fa fa-door-open"></i> Apri</a></div>';
    }
    html += '<div class="col-6"><a class="btn btn-outline-brand block" onclick="changeStateCAD(@id, 2, \'eliminare\', \'eliminato\')" href="javascript:void(0);"><i class="fa fa-trash-alt"></i> Elimina</a></div>'

    html += "</div>";

    swal.fire({
        html: html.split("@id").join(id),
        showConfirmButton: false,
    });
}

function getFirstDayCalendar() {
    var date = new Date();
    return date.getFullYear() + "-" + (date.getMonth() < 10 ? '0' + (date.getMonth()) : date.getMonth()) + "-01";
}

function reload() {
    var eventSources = calendar.getEventSources();
    if (eventSources[0] != undefined) {
        eventSources[0].remove();
    }
    calendar.addEventSource(context + "/QueryCi?type=getMyCad&data=" + getFirstDayCalendar());
    calendar.refetchEvents();
}

function changeStateCAD(idCad, stato, swal, confirm) {//finisci questa
    swalConfirm(capitalize(swal) + " Stanza", "Sicuro di voler " + swal + " questo CAD?", function close() {
        showLoad();
        $.ajax({
            type: "POST",
            url: context + '/OperazioniCi',
            data: {type: "changeStateCAD", id: idCad, "stato": stato},
            success: function (data) {
                closeSwal();
                var json = JSON.parse(data);
                if (json.result) {
                    swalSuccess('Successo', 'CAD ' + confirm + ' con successo')
                    reload();
                } else {
                    swalError('Errore', json.message);
                }
            }
        });
    });
}

function logCAD(idCad) {
    showLoad();
    $.post(context + '/QueryCi', {"type": "getSingleCad", "id": idCad}, function (data) {
        connectCAD(data);
        swal.close();
    });
}

function connectCAD(json) {
    var form = $("#goCAD");
    form.attr("action", json.link);
    $("#id").val(json.id);
    $("#password").val(json.password);
    $("#user").val(json.user.email);
    form.submit();
}