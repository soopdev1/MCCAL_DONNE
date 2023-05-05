/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
function ctrlSession() {
    var context = document.getElementById("ctrlSession").getAttribute("data-context");
    $.ajax({
        type: "GET",
        async: false,
        url: context + "/OperazioniGeneral?type=ctrlSession",
        success: function (data) {
            if (data != 'false') {
                swal.fire({
                    "title": '<h2 class="kt-font-io-n">Sessione Scaduta!</b></h2><br>',
                    "html": "<h4>La tua sessione &egrave; scaduta.<br>&Egrave; necessario rieffettuare l'accesso</h4>",
                    confirmButtonClass: "btn btn-m",
                    confirmButtonText: "OK",
                    onClose: () => {
                        $('#a_logout')[0].click();
                    }
                });
            }
        }
    });
}
$(document).ready(function () {
    ctrlSession();
    setInterval(function () {
        ctrlSession();
    }, 1805000); //30.5 min
});

