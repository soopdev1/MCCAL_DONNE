/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var context = document.getElementById("myFAQ").getAttribute("data-context");
$.getScript(context + '/page/partialView/partialView.js', function () {});

function getConversation(idsoggetto) {
    $.ajax({
        type: "POST",
        url: context + "/QueryMicro?type=getConversationSA",
        data: {"idsoggetto": idsoggetto},
        success: function (resp) {
            if (resp != null && resp != "") {
                var json = JSON.parse(resp);
                setConversation(json);
            }
        }
    });
}


function setConversation(json) {
    var mittente = getHtml("mittente", context);//@testo @data
    var destinatario = getHtml("destinatario", context);
    $.each(json, function (i, j) {
        $("#answers").append(destinatario
                .replace("@testo", j.domanda)
                .replace("@data", formattedDate(new Date(j.date_ask))));
        if (j.risposta != null) {
            $("#answers").append(mittente
                    .replace("@testo", j.risposta)
                    .replace("@data", formattedDate(new Date(j.date_answer))));
        }
    });
    $('#answers').scrollTop(($('#answers').height() * 1000));//per scrollare fino alla fine
}

function sendAnswer(idsoggetto) {
    if (!ctrlForm()) {
        $.ajax({
            type: "POST",
            url: context + "/OperazioniMicro?type=sendAnswer",
            data: {"text": $("#text").val(), "idsoggetto": idsoggetto},
            success: function (resp) {
                var json = JSON.parse(resp);
                if (json.result) {
                    var mittente = getHtml("mittente", context);
                    $("#answers").append(mittente
                            .replace("@testo", $("#text").val())
                            .replace("@data", formattedDate(new Date())));
                    $('#answers').scrollTop(($('#answers').height() * 1000));
                    $('#send').remove();
                } else {
                    swalError("Errore", json.message);
                }
            },
            error: function () {
                swalError("Errore", "Non è stato possibile inviare il messaggio");
            }
        });
    }
}


function ctrlForm() {
    var err = false;
    err = checkObblFieldsContent($('#send')) ? true : err;
    return err;
}

jQuery(document).ready(function () {

});


function showConversation(idsoggetto, resp) {
    var whatsapp = getHtml("whatsapp_micro", context).replace("@func", "sendAnswer(" + idsoggetto + ")");
    swal.fire({
        title: '',
        html: whatsapp,
        animation: false,
        showCancelButton: false,
        showConfirmButton: false,
        showCloseButton: true,
        customClass: {
            popup: 'animated bounceInUp',
            container: 'my-swal'
        },
        onOpen: function () {

            $("#answers").css({"min-height": ($("#kt_content").height() * 0.3) + "px", "max-height": ($("#kt_content").height() * 0.5) + "px"})
            getConversation(idsoggetto);
            $('.kt-scroll').each(function () {
                const ps = new PerfectScrollbar($(this)[0]);
            });
            $("body").css({"overflow": "hidden!important;"});
            if (!resp) {
                $('#send').remove();
            }
        },
        onClose: function () {
            $("body").css({"overflow": ""});
            if (resp) {
                location.reload();
            }
        },
    });
}

$("#search").on("input", function () {
    search($(this).val());
});

function search(search) {
    var contatti = $(".contatto");
    search = search.toUpperCase();
    if (search != null && search !== "") {
        contatti.each(function () {
            if (!$(this).find("input").val().toUpperCase().includes(search)) {
                $(this).css("display", "none");
            } else {
                $(this).css("display", "");
            }
        });
    } else {
        $(".contatto").css("display", "");
    }


}

