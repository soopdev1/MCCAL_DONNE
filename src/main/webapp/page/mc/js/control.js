/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function controlHourRegister() {
    $(".hour-recognized").change(function (e) {
        var div = $($(this).parent()[0]);
        var row = $($(div).parent()[0]);
        var make = $(row.find('input.hour-make')[0]);
        checkHour(make, $(this));
    });
}

function checkHour(make, recognized) {
    if (make.val() < recognized.val() || recognized.val() == "") {
        recognized.removeClass("is-valid");
        recognized.addClass("is-invalid");
        return false;
    } else {
        recognized.addClass("is-valid");
        recognized.removeClass("is-invalid");
        return true;
    }
}

function checkAllHour() {
    var err = false;
    $(".hour-recognized").each(function () {
        var div = $($(this).parent()[0]);
        var row = $($(div).parent()[0]);
        var make = $(row.find('input.hour-make')[0]);
        if (!checkHour(make, $(this))) {
            err = true;
        }
    });
    return err;
}