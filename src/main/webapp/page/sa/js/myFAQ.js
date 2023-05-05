/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var context = document.getElementById("myFAQ").getAttribute("data-context");
$.getScript(context + '/page/partialView/partialView.js', function () {});

function getConversation() {
    $.ajax({
        type: "GET",
        url: context + "/QuerySA?type=getConversationSA",
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
        $("#answers").append(mittente
                .replace("@testo", j.domanda)
                .replace("@data", formattedDate(new Date(j.date_ask))));
        if (j.risposta != null) {
            $("#answers").append(destinatario
                    .replace("@testo", j.risposta)
                    .replace("@data", formattedDate(new Date(j.date_answer))));
        }
    });
    $('#answers').scrollTop(($('#answers').height()*1000));//per scrollare fino alla fine
}

function sendAsk() {
    if (!ctrlForm()) {
        $.ajax({
            type: "POST",
            url: context + "/OperazioniSA?type=sendAsk",
            data: {"ask": $("#ask").val()},
            success: function (resp) {
                var json = JSON.parse(resp);
                if (json.result) {
                    var mittente = getHtml("mittente", context);
                    $("#answers").append(mittente
                            .replace("@testo", $("#ask").val())
                            .replace("@data", formattedDate(new Date())));
                    $('#answers').scrollTop(($('#answers').height()*1000));
                    resetInput();
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
    $("#answers").css({"min-height": ($("#kt_content").height() * 0.3) + "px", "max-height": ($("#kt_content").height() * 0.75) + "px"})
    $('.kt-scroll').each(function () {
        const ps = new PerfectScrollbar($(this)[0]);
    });
    getConversation();
//                
});//

function pressEnter(e) {
    if (e.keyCode == 13) {
        sendAsk();
        return false;
    }
}