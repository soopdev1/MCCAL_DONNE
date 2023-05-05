/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function currencyFormat(num) {
    return '&euro;' + num.toFixed(0).replace('.', ',').replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1.')
}
function currencyFormatDecimal(num) {
    return '&euro;' + num.toFixed(2).replace('.', ',').replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1.')
}

function checknullField(value) {
    if (value == null || value == "null") {
        value = "-";
    }
    return value;
}

function dateFormat(from, to, locale) {
    // Argument shifting
    if (arguments.length === 1) {
        locale = 'en';
        to = from;
        from = 'YYYY-MM-DD';
    } else if (arguments.length === 2) {
        locale = 'en';
    }

    return function (d, type, row) {
        var m = window.moment(d, from, locale, true);
        return m.format(type === 'sort' || type === 'type' ? 'x' : to);
    };
}

function formattedDate(d) {
    return [d.getDate(), d.getMonth() + 1, d.getFullYear()]
            .map(n => n < 10 ? `0${n}` : `${n}`).join('/');
}
function formattedDateTime(d) {
    var day = [d.getDate(), d.getMonth() + 1, d.getFullYear()]
            .map(n => n < 10 ? `0${n}` : `${n}`).join('/');
    var time = [d.getHours(), d.getMinutes(), d.getSeconds()]
            .map(n => n < 10 ? `0${n}` : `${n}`).join(':');
    return day + " " + time;
}

function defaultValue(element, select) {
    if (!select) {
        element.attr("class", "form-control");
    } else {
        $('#' + element.attr('id') + '_div').attr("class", "dropdown bootstrap-select form-control kt-");
        $('#' + element.attr('id') + '_div').css({"height": "40px", "border": "0px"});
    }
}
function checkValue(element, select) {
    if (!select) {
        if (element.val() == "") {
            element.attr("class", "form-control is-invalid");
            return true;
        } else {
            element.attr("class", "form-control is-valid");
            return false;
        }
    } else {
        if (element.val() == "" || element.val() == "-") {
            $('#' + element.attr('id') + '_div').attr("class", "dropdown bootstrap-select form-control kt- is-invalid");
            $('#' + element.attr('id') + '_div').css({"height": "40px", "border": "1px #fd397a solid"});
            return true;
        } else {
            $('#' + element.attr('id') + '_div').attr("class", "dropdown bootstrap-select form-control kt- is-valid");
            $('#' + element.attr('id') + '_div').css({"height": "40px", "border": "1px #0abb87 solid"});
            return false;
        }
    }
}

function checkEmail(email) {
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    if (email.val() === '' || !re.test(email.val().toLowerCase())) {
        email.attr("class", "form-control is-invalid");
        return true;
    } else {
        email.attr("class", "form-control is-valid");
        return false;
    }
}




function checkPIva(piva) {
    if (piva.val() == '' || piva.val().length != 11) {
        piva.attr("class", "form-control is-invalid");
        return true;
    } else {
        piva.attr("class", "form-control is-valid");
        return false;
    }
}

function isChecked(check, label) {
    if (check.prop('checked')) {
        return false;
    } else {
        label.addClass("wobble animated");
        label.css({"color": "#EB0707", "font-weight": "bold"});
        setTimeout(function () {
            label.removeClass("wobble animated");
        }, 1000);
        return true;
    }
}

function checkCU(c_inivoco) {
    if (c_inivoco.val() == '' || c_inivoco.val().length < 6 || c_inivoco.val().length > 7) {
        c_inivoco.attr("class", "form-control is-invalid");
        return true;
    } else {
        c_inivoco.attr("class", "form-control is-valid");
        return false;
    }
}

function checkCap(cap) {
    if (cap.val() == '' || cap.val().length != 5) {
        cap.attr("class", "form-control is-invalid");
        return true;
    } else {
        cap.attr("class", "form-control is-valid");
        return false;
    }
}

function check_mese_CF(mesedata, mesecf) {
    var err = false;
    switch (mesedata) {
        case "01":
            err = mesecf == "A" ? true : false;
            return err;
        case "02":
            err = mesecf == "B" ? true : false;
            return err;
        case "03":
            err = mesecf == "C" ? true : false;
            return err;
        case "04":
            err = mesecf == "D" ? true : false;
            return err;
        case "05":
            err = mesecf == "E" ? true : false;
            return err;
        case "06":
            err = mesecf == "H" ? true : false;
            return err;
        case "07":
            err = mesecf == "L" ? true : false;
            return err;
        case "08":
            err = mesecf == "M" ? true : false;
            return err;
        case "09":
            err = mesecf == "P" ? true : false;
            return err;
        case "10":
            err = mesecf == "R" ? true : false;
            return err;
        case "11":
            err = mesecf == "S" ? true : false;
            return err;
        case "12":
            err = mesecf == "T" ? true : false;
            return err;
        default:
            return err;
    }
}

function check_giorno_CF(giornodata, giornocf) {
    var err = false;
    if (giornodata == giornocf || (giornodata + 40 == giornocf)) {
        err = true;
    }
    return err;
}

function check_comune_CF(comune, comunecf) {
    var err = true;
    var index = 0;
    if (comune.includes("-")) {
        var listcomuni = comune.split("-");
        for (index = 0; index < listcomuni.length; index++) {
            if (listcomuni[index] == comunecf) {
                err = false;
            }
        }
    } else {
        if (comune == comunecf) {
            err = false;
        }
    }
    return err;
}



function check_cognome_CF(cognome, cognomecf) {
    var err = false;
    var consonanticognome = cognome.replace(/[aeiouAEIOU]/g, "").replace(/\s/g, "");
    var vocalicognome = cognome.replace(/[qwrtypsdfghjklzxcvbnmQWRTYPSDFGHJKLZXCVBNM]/g, "").replace(/\s/g, "");
    vocalicognome = vocalicognome.padEnd(3, "XXX");
    var temp = consonanticognome;
    if (consonanticognome.length > 3) {
        temp = consonanticognome.substring(0, 3);
    } else {
        temp = temp.padEnd(3, vocalicognome);
    }
    err = temp == cognomecf ? true : false;
    return err;
}

function check_nome_CF(nome, nomecf) {
    var err = false;
    var consonantinome = nome.replace(/[aeiouAEIOU]/g, "").replace(/\s/g, "");
    var vocalinome = nome.replace(/[qwrtypsdfghjklzxcvbnmQWRTYPSDFGHJKLZXCVBNM]/g, "").replace(/\s/g, "");
    vocalinome = vocalinome.padEnd(3, "XXX");
    var temp = consonantinome;
    if (consonantinome.length > 3) {
        temp = consonantinome.substring(0, 1) + consonantinome.substring(2, 3) + consonantinome.substring(3, 4);
    } else {
        temp = temp.padEnd(3, vocalinome);
    }
    err = temp == nomecf ? true : false;
    return err;
}

function allnumericplusminus(inputtxt) {
    if (inputtxt.match(/^[0-9]*$/)) {
        return true;
    } else {
        return false;
    }
}
function check_PIVA_CF(input) {
    var codicefiscale = input.val();
    var esitopiva = false;
    var esitocf = true;
    if (codicefiscale == '' || codicefiscale.length != 11 || !allnumericplusminus(codicefiscale)) {
        esitopiva = true;
    } else {
        esitopiva = false;
    }

    var validi, i, s, set1, set2, setpari, setdisp;
    if (codicefiscale === '')
        esitocf = false;
    codicefiscale = codicefiscale.toUpperCase();
    if (codicefiscale.length === 16) {
        if (codicefiscale.length !== 16) {
            esitocf = false;
        } else {
            validi = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            for (i = 0; i < 16; i++) {
                if (validi.indexOf(codicefiscale.charAt(i)) === -1)
                    esitocf = false;
            }
            set1 = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            set2 = "ABCDEFGHIJABCDEFGHIJKLMNOPQRSTUVWXYZ";
            setpari = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            setdisp = "BAKPLCQDREVOSFTGUHMINJWZYX";
            s = 0;
            for (i = 1; i <= 13; i += 2)
                s += setpari.indexOf(set2.charAt(set1.indexOf(codicefiscale.charAt(i))));
            for (i = 0; i <= 14; i += 2)
                s += setdisp.indexOf(set2.charAt(set1.indexOf(codicefiscale.charAt(i))));
            if (s % 26 !== codicefiscale.charCodeAt(15) - 'A'.charCodeAt(0)) {
                esitocf = false;
            }
        }
    } else {
        esitocf = false;
    }

    if (esitocf || !esitopiva) {
        input.attr("class", "form-control is-valid");
        return false;
    } else {
        input.attr("class", "form-control is-invalid");
        return true;
    }
}

function checkCF(cf) {
    var codicefiscale = cf.val();
    var esito = true;
    var validi, i, s, set1, set2, setpari, setdisp;
    if (codicefiscale === '')
        esito = false;
    codicefiscale = codicefiscale.toUpperCase();
    if (codicefiscale.length === 16) {
        if (codicefiscale.length !== 16) {
            esito = false;
        } else {
            validi = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            for (i = 0; i < 16; i++) {
                if (validi.indexOf(codicefiscale.charAt(i)) === -1)
                    esito = false;
            }
            set1 = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            set2 = "ABCDEFGHIJABCDEFGHIJKLMNOPQRSTUVWXYZ";
            setpari = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            setdisp = "BAKPLCQDREVOSFTGUHMINJWZYX";
            s = 0;
            for (i = 1; i <= 13; i += 2)
                s += setpari.indexOf(set2.charAt(set1.indexOf(codicefiscale.charAt(i))));
            for (i = 0; i <= 14; i += 2)
                s += setdisp.indexOf(set2.charAt(set1.indexOf(codicefiscale.charAt(i))));
            if (s % 26 !== codicefiscale.charCodeAt(15) - 'A'.charCodeAt(0)) {
                esito = false;
            }
            if (esito) {
                cf.attr("class", "form-control is-valid");
            } else {
                cf.attr("class", "form-control is-invalid");
            }
            return esito;
        }
    } else {
        cf.attr("class", "form-control is-invalid");
        return false;
    }
}

function validateCardNumber(number) {
    if (number.val() == '' || number.val().split(" ").join("").length < 12 || !Stripe.card.validateCardNumber(number.val())) {
        number.attr("class", "form-control is-invalid");
        return true;
    } else {
        number.attr("class", "form-control is-valid");
        return false;
    }
}

function startBlockUI(elem) {
    $(elem).block({message: null,
        css: {
            backgroundColor: 'none',
        },
        overlayCSS: {
            backgroundColor: '#000000',
            opacity: 0.1,
            cursor: 'wait',
            zIndex: '10'
        }});
}

function startBlockUILoad(elem) {
    KTApp.block(elem, {
        overlayColor: '#000000',
        type: 'v1',
        state: 'io',
        message: 'Caricamento...',
    });
}

function startBlockUIDownload(elem, img) {
    $(elem).block({
        message: '<img height="100" class="animated bounceInDown" src="' + img + '" />',
        centerY: false,
        centerX: false,
        timeout: 6000,
        css: {
            backgroundColor: 'transparent',
            border: 0,
            width: '100px',
            top: $(window).height() - 110,
            left: '10px',
        },
        overlayCSS: {
            backgroundColor: '#000000',
            opacity: 0.3,
            cursor: 'wait',
        }});
}


function stopBlockUI(elem) {
    KTApp.unblock(elem);
}

function sleep(milliseconds) {
    var start = new Date().getTime();
    for (var i = 0; i < 1e7; i++) {
        if ((new Date().getTime() - start) > milliseconds) {
            break;
        }
    }
}

function swalCountDown(title, message, path) {
    let timerInterval;
    Swal.fire({
        title: '<h2 class="kt-font-io-n"><b>' + title + '</b></h2><br>',
        html: "<h4>" + message + ' <b></b> secondi. </h4><br>',
        type: "success",
        timer: 5000,
        timerProgressBar: true,
        onBeforeOpen: () => {
            Swal.showLoading()
            timerInterval = setInterval(() => {
                const content = Swal.getContent()
                if (content) {
                    const b = content.querySelector('b')
                    if (b) {
                        b.textContent = Math.round(Swal.getTimerLeft() / 1000);
                    }
                }
            }, 100)
        },
        onClose: () => {
            clearInterval(timerInterval)
        }
    }).then((result) => {
        window.location.href = path;
    })
}
function swalCountDownFunc(title, message, func) {
    let timerInterval;
    Swal.fire({
        title: '<h2 class="kt-font-io-n"><b>' + title + '</b></h2><br>',
        html: "<h4>" + message + ' <b></b> secondi. </h4><br>',
        type: "success",
        timer: 4000,
        timerProgressBar: true,
        onBeforeOpen: () => {
            Swal.showLoading()
            timerInterval = setInterval(() => {
                const content = Swal.getContent()
                if (content) {
                    const b = content.querySelector('b')
                    if (b) {
                        b.textContent = Math.round(Swal.getTimerLeft() / 1000);
                    }
                }
            }, 100)
        },
        onClose: () => {
            clearInterval(timerInterval);
        }
    }).then((result) => {
        func();
    });
}

function showLoadTitle(title) {
    swal.fire({
        title: title,
        text: '',
        onOpen: function () {
            swal.showLoading()
        }
    });
}

function fastSwalElementResponsive(HTMLmessage, buttonMessage) {
    swal.fire({
        html: HTMLmessage,
        buttonsStyling: false,
        scrollbarPadding: true,
        confirmButtonText: buttonMessage,
        confirmButtonClass: "btn btn-io",
    });
}

function showLoad() {
    swal.fire({
        title: '',
        text: '',
        onOpen: function () {
            swal.showLoading()
        },
        customClass: {
            container: 'my-swal',
        }
    });
}
function showLoad(title) {
    swal.fire({
        title: title,
        text: '',
        onOpen: function () {
            swal.showLoading()
        },
        customClass: {
            container: 'my-swal',
        }
    });
}

function fastSwalShow(HTMLmessage, animation) {
    swal.fire({
        html: HTMLmessage,
        showCloseButton: true,
        showCancelButton: false,
        showConfirmButton: false,
        width: '50%',
        buttonsStyling: false,
        animation: false,
        customClass: {
            popup: 'animated ' + animation,
            container: 'my-swal',
        }
    });
}

function fastSwal(HTMLmessage, buttonMessage, animation) {
    swal.fire({
        html: '<h3>' + HTMLmessage + '</h3>',
        width: '45%',
        buttonsStyling: false,
        confirmButtonText: buttonMessage,
        confirmButtonClass: "btn btn-io",
        animation: false,
        customClass: {
            popup: 'animated ' + animation,
            container: 'my-swal',
        }
    });
}

function fastSwalElement(HTMLmessage, buttonMessage) {
    swal.fire({
        html: HTMLmessage,
        width: '45%',
        buttonsStyling: false,
        confirmButtonText: buttonMessage,
        confirmButtonClass: "btn btn-io",
        customClass: {
            container: 'my-swal',
        }
    });
}

function swalSuccessReload(title, HTMLmessage) {
    swal.fire({
        "title": '<h2 class="kt-font-io-n"><b>' + title + '</b></h2><br>',
        "html": "<h4>" + HTMLmessage + "</h4><br>",
        "type": "success",
        "confirmButtonColor": '#363a90',
        "confirmButtonClass": "btn btn-io",
        customClass: {
            container: 'my-swal',
        }
    }).then(function () {
        showLoad();
        location.reload();
    });
}

function swalSuccessReload2(title, HTMLmessage) {
    swal.fire({
        "title": '<h2 class="kt-font-io-n"><b>' + title + '</b></h2><br>',
        "html": HTMLmessage,
        "type": "success",
        "confirmButtonColor": '#363a90',
        "confirmButtonClass": "btn btn-io",
        customClass: {
            container: 'my-swal',
        }
    }).then(function () {
        showLoad();
        location.reload();
    });
}

function swalSuccess(title, HTMLmessage) {
    swal.fire({
        "title": '<h2 class="kt-font-io-n"><b>' + title + '</b></h2><br>',
        "html": "<h4>" + HTMLmessage + "</h4><br>",
        "type": "success",
        "confirmButtonColor": '#363a90',
        "confirmButtonClass": "btn btn-io",
        customClass: {
            container: 'my-swal',
        }
    });
}
function swalError(title, message) {
    swal.fire({
        "title": title,
        "html": message,
        "type": "error",
        cancelButtonClass: "btn btn-io-n",
        customClass: {
            container: 'my-swal',
        }
    });
}
function swalWarning(title, message) {
    swal.fire({
        "title": title,
        "html": message,
        "type": "warning",
        cancelButtonClass: "btn btn-io-n",
        customClass: {
            container: 'my-swal',
        }
    });
}

function swalConfirm(title, HTMLmessage, func) {
    swal.fire({
        "title": '<h2 class="kt-font-io-n"><b>' + title + '</b></h2><br>',
        "html": "<h4>" + HTMLmessage + "</h4><br>",
        animation: false,
        showCancelButton: true,
        confirmButtonText: '&nbsp;<i class="la la-check"></i>',
        cancelButtonText: '&nbsp;<i class="la la-close"></i>',
        cancelButtonClass: "btn btn-io-n",
        confirmButtonClass: "btn btn-io",
        customClass: {
            popup: 'large-swal animated bounceInUp',
        },
    }).then((result) => {
        if (result.value) {
            func();
        } else {
            swal.close();
        }
    });
}


function isNumber(evt) {
    evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}

function closeSwal() {
    swal.close();
}


function ctrlImg() {
    var image_holder = $("#preview-image");
    var countFiles = $("#imageupload")[0].files.length;
    if (countFiles > 0) {
        var extn1 = '';
        for (var i = 0; i < countFiles; i++) {
            extn1 = $("#imageupload")[0].files[i].name.substring($("#imageupload")[0].files[i].name.lastIndexOf('.') + 1).toLowerCase();
            if (extn1 !== "jpg" && extn1 !== "jpeg" && extn1 !== "png" && extn1 !== "pdf") {
                $("#imageupload").val("");
                $("#preview-image").css('display', 'none');
                image_holder.empty();
                fastSwal('Selezionare solo immagini in formato jpeg, jpg o png oppure file formato pdf', 'OK', 'tada');
                $('#imageupload').attr("class", "custom-file-input is-invalid");
                return false;
            }
        }
        image_holder.empty();
        if (extn1 != 'pdf') {
            $("#preview-image").css('display', '');
            for (var i = 0; i < countFiles; i++) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $("<img/>", {
                        "src": e.target.result,
                        "width": '100%',
                        css: {
                            "padding": 5,
                            "border-radius": 10,
                        }
                    }).appendTo(image_holder);
                },
                        image_holder.show();
                reader.readAsDataURL($("#imageupload")[0].files[i]);
            }
        } else {
            for (var i = 0; i < countFiles; i++) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $("<iframe />", {
                        "src": e.target.result,
                        "width": '100%',
                        "height": '500px',
                        css: {
                            "margin": 5,
                            "border": 0,
                            "border-radius": 10,
                        }
                    }).appendTo(image_holder);
                },
                        image_holder.show();
                reader.readAsDataURL($("#imageupload")[0].files[i]);
            }
        }
        $('#imageupload').attr("class", "custom-file-input is-valid");
        return true;
    } else {
        $("#preview-image").css('display', 'none');
        $('#imageupload').attr("class", "custom-file-input is-invalid");
        return false;
    }
}

function ctrlPdf(file) {
    var image_holder = $("#preview-image");
    var countFiles = file[0].files.length;
    if (countFiles > 0) {
        var extn1 = '';
        for (var i = 0; i < countFiles; i++) {
            extn1 = file[0].files[i].name.substring(file[0].files[i].name.lastIndexOf('.') + 1).toLowerCase();
            if (extn1 !== "pdf") {
                file.val("");
                image_holder.empty();
                fastSwal('Selezionare solo file formato pdf', 'OK', 'tada');
                file.attr("class", "custom-file-input is-invalid");
                $('#label_file').html('Seleziona File');
                return false;
            }
        }
        image_holder.empty();
        for (var i = 0; i < countFiles; i++) {
            var reader = new FileReader();
            reader.onload = function (e) {
                $("<iframe />", {
                    "src": e.target.result,
                    "width": '100%',
                    "height": '500px',
                    css: {
                        "margin": 5,
                        "border": 0,
                        "border-radius": 10,
                    }
                }).appendTo(image_holder);
            }
            image_holder.show();
            reader.readAsDataURL(file[0].files[i]);
        }
        file.attr("class", "custom-file-input is-valid");
        if (countFiles > 1) {
            $('#label_file').html(countFiles + " files selezionati");
        } else {
            $('#label_file').html(file[0].files[0].name);
        }
        return true;
    } else {
        $("#preview-image").css('display', 'none');
        $('#label_file').html("Seleziona File");
        file.attr("class", "custom-file-input is-invalid");
        return false;
    }
}



function ctrlPdf2(file, field, label, height) {
    var image_holder = field;
    var countFiles = file[0].files.length;
    if (countFiles > 0) {
        var extn1 = ''
        for (var i = 0; i < countFiles; i++) {
            extn1 = file[0].files[i].name.substring(file[0].files[i].name.lastIndexOf('.') + 1).toLowerCase();
            if (extn1 !== "pdf") {
                file.val("");
                image_holder.empty();
                fastSwal('Selezionare solo file formato pdf', 'OK', 'tada');
                file.attr("class", "custom-file-input is-invalid");
                label.html('Seleziona File');
                return false;
            }
        }
        image_holder.empty();
        for (var i = 0; i < countFiles; i++) {
            var reader = new FileReader();
            reader.onload = function (e) {
                $("<iframe />", {
                    "src": e.target.result,
                    "width": '100%',
                    "height": height + 'px',
                    css: {
                        "margin": 5,
                        "border": 0,
                        "border-radius": 10,
                    }
                }).appendTo(image_holder);
            }
            image_holder.show();
            reader.readAsDataURL(file[0].files[i]);
        }
        file.attr("class", "custom-file-input is-valid");
        if (countFiles > 1) {
            label.html(countFiles + " files selezionati");
        } else {
            label.html(file[0].files[0].name);
        }
        return true;
    } else {
        field.css('display', 'none');
        label.html("Seleziona File");
        file.attr("class", "custom-file-input is-invalid");
        return false;
    }
}

function checkFileDim() {
    var err = false;
    var dim = 0;

    $('input[type=file]').each(function () {
        if (typeof this.files[0] !== 'undefined') {
            dim = dim + this.files[0].size;
        }
    });
    if (dim > 10485760) {
        $('input[type=file]').attr("class", "custom-file-input is-invalid");
        fastSwal('Dimensione totale dei Files eccessiva. Non deve superare i 10MB', 'OK', 'tada');
        err = true;
    }

    return err ? false : true;
}

function checkObblFields() {
    var err = false;
    $('input.obbligatory').each(function () {
        if ($(this).val() == '') {
            err = true;
            $(this).removeClass("is-valid").addClass("is-invalid");
        } else {
            $(this).removeClass("is-invalid").addClass("is-valid");
        }
    });
    $('textarea.obbligatory').each(function () {
        if ($(this).val() == '') {
            err = true;
            $(this).removeClass("is-valid").addClass("is-invalid");
        } else {
            $(this).removeClass("is-invalid").addClass("is-valid");
        }
    });
    $('select.obbligatory').each(function () {
        if ($(this).val() == '' || $(this).val() == '-') {
            err = true;
            $('#' + this.id + '_div').removeClass("is-valid-select").addClass("is-invalid-select");
        } else {
            $('#' + this.id + '_div').removeClass("is-invalid-select").addClass("is-valid-select");
        }
    });
    return err;
}

function checkObblFieldsContent(content) {
    var err = false;
    content.find('input.obbligatory').each(function () {
        if ($(this).val() == '') {
            err = true;
            $(this).removeClass("is-valid").addClass("is-invalid");
        } else {
            $(this).removeClass("is-invalid").addClass("is-valid");
        }
    });
    content.find('textarea.obbligatory').each(function () {
        if ($(this).val() === '') {
            err = true;
            $(this).removeClass("is-valid").addClass("is-invalid");
        } else {
            $(this).removeClass("is-invalid").addClass("is-valid");
        }
    });
    content.find('select.obbligatory').each(function () {
        if ($(this).val() === '' || $(this).val() === '-') {
            err = true;
            $('#' + this.id + '_div').removeClass("is-valid-select").addClass("is-invalid-select");
        } else {
            $('#' + this.id + '_div').removeClass("is-invalid-select").addClass("is-valid-select");
        }
    });
    return err;
}

function checkRequiredFile() {
    var err = false;
    $('input:file[tipo=obbligatory]').each(function () {
        if ($(this)[0].files.length == 0) {
            err = true;
            $(this).attr("class", "custom-file-input is-invalid");
        } else {
            $(this).attr("class", "custom-file-input is-valid");
        }
    });
    return !err;
}

function checkRequiredFileContent(content) {
    var err = false;
    content.find('input:file[tipo=obbligatory]').each(function () {
        if ($(this)[0].files.length == 0) {
            err = true;
            $(this).attr("class", "custom-file-input is-invalid");
        } else {
            $(this).attr("class", "custom-file-input is-valid");
        }
    });
    return err ? false : true;
}

function checkFileExtAndDim(ext) {
    var err = false;
    var extension = '';
    if ($('input[type=file]')[0].files.length > 0) {
        $('input[type=file]').each(function () {
            if (typeof this.files[0] !== 'undefined') {
                extension = this.files[0].name.substring(this.files[0].name.lastIndexOf('.') + 1).toLowerCase();
                if (!ext.includes(extension.toLowerCase())) {
                    $(this).attr("class", "custom-file-input is-invalid");
                    $(this).val('');
                    err = true;
                } else {
                    $(this).attr("class", "custom-file-input is-valid");
                }
            }
        });
        if (!checkFileDim()) {
            err = true;
        }
    } else {
//        $('input[type=file]').attr("class", "custom-file-input");
    }
    return !err;
}


function resetInput() {
    $('.form-control').val('');
    $('.form-control').removeClass('is-valid');
    $('.custom-file-input').val('');
    $('.custom-file-label').html('');
    $('.custom-file-input').removeClass('is-valid');
    $('select').val('-');
    $('select').trigger('change');
    $('div.dropdown.bootstrap-select.form-control.kt-').removeClass('is-valid is-valid-select');
}

/*per i modal a matriosca*/
$('.modal').on('shown.bs.modal', function () {
    setBackdrop();
    $("body").addClass("stop-scroll");
}).on('hidden.bs.modal', function () {
    if ($('.modal.show').length == 0) {
        $("body").removeClass("stop-scroll");
    }
});

/* modal */
function setBackdrop() {
    var i = 0;
    var z = 0;
    $('div.modal-backdrop.show').each(function () {
        i++;
        if (i > 1) {
            $(this).css("z-index", z + (i * 10));
        } else {
            z = Number($(this).css("z-index"));
        }

    });
    i = 0;
    z = 0;
    $('div.modal.fade.show').each(function () {
        i++;
        if (i > 1) {
            $(this).css("z-index", z + (i * 10));
        } else {
            z = Number($(this).css("z-index"));
        }

    });
}
/* ------- */

function checktime(hour, min, max) {
    if (new Date('00', '00', '00', hour.split(':')[0], hour.split(':')[1]) < new Date('00', '00', '00', min.split(':')[0], min.split(':')[1]))
        return min.startsWith("0") ? min.substring(1) : min;
    else if (new Date('00', '00', '00', hour.split(':')[0], hour.split(':')[1]) > new Date('00', '00', '00', max.split(':')[0], max.split(':')[1]))
        return max.startsWith("0") ? max.substring(1) : max;
    else
        return hour;
}

Date.prototype.addHours = function (h) {
    this.setHours(this.getHours() + h);
    return this;
}

function getMaxHour(h1, h2) {
    if (new Date('00', '00', '00', h1.split(':')[0], h1.split(':')[1]) < new Date('00', '00', '00', h2.split(':')[0], h2.split(':')[1])) {
        return h2;
    } else {
        return h1;
    }
}
function getMinHour(h1, h2) {
    if (new Date('00', '00', '00', h1.split(':')[0], h1.split(':')[1]) < new Date('00', '00', '00', h2.split(':')[0], h2.split(':')[1])) {
        return h1;
    } else {
        return h2;
    }
}

function checkTime(hh, max) {
    if (hh.val() > max) {
        hh.removeClass("is-valid");
        hh.addClass("is-invalid");
        return false;
    } else {
        hh.removeClass("is-invalid");
        hh.addClass("is-valid");
        return true;
    }
}

function doubletoHHmm(decimalTimeString) {
    var decimalTime = parseFloat(decimalTimeString);
    decimalTime = decimalTime * 60 * 60;
    var hours = Math.floor((decimalTime / (60 * 60)));
    decimalTime = decimalTime - (hours * 60 * 60);
    var minutes = Math.floor((decimalTime / 60));
    if (hours < 10)
    {
        hours = "0" + hours;
    }
    if (minutes < 10)
    {
        minutes = "0" + minutes;
    }
    return hours + ":" + minutes;
}

function formattedTime(s) {
    s += (+1.00 * 60) * 60 * 1000;  //TIMEZONE +1
    var ms = s % 1000;
    s = (s - ms) / 1000;
    var secs = s % 60;
    s = (s - secs) / 60;
    var mins = s % 60;
    var hrs = (s - mins) / 60;
    return hrs + ':' + (mins < 10 ? "0" + mins : mins);
}


function calculateHoursRegistro(s1_start, s1_end, s2_start, s2_end) {
//    var utc = (+1.00 * 60) * 60 * 1000; //TIMEZONE +1
    var hours = s1_end - s1_start;
    if (s2_start != null || s2_end != null) {
        hours += (s2_end - s2_start);
    }
//    hours += utc;
    var ms = hours % 1000;
    hours = (hours - ms) / 1000;
    var secs = hours % 60;
    hours = (hours - secs) / 60;
    var mins = hours % 60;
    var hrs = (hours - mins) / 60;

    return hrs + ':' + mins;
}

function tConvert(time) {
    // Check correct time format and split into components
    time = time.toString().match(/^([01]\d|2[0-3])(:)([0-5]\d)(:[0-5]\d)?$/) || [time];

    if (time.length > 1) { // If time format correct
        time = time.slice(1);  // Remove full string match value
        time[5] = +time[0] < 12 ? 'am' : 'pm'; // Set AM/PM
        time[0] = +time[0] % 12 || 12; // Adjust hours
    }
    return time.join(''); // return adjusted time or original string
}

function getTime(date) {
    return date.getHours() + ":" + (date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes());
}

function submitForm(form, success_title_msg, success_msg, ctrl, reload) {
    if (ctrl) {
        showLoad();
        form.ajaxSubmit({
            error: function () {
                closeSwal();
                swalError("Errore", "Riprovare, se l'errore persiste contattare l'assistenza");
            },
            success: function (resp) {
                var json = JSON.parse(resp);
                closeSwal();
                if (json.result) {
                    var message = json.message != null ? ".<br>" + json.message : "";
                    if (reload) {
                        swalSuccessReload(success_title_msg, success_msg + message);
                    } else {
                        swalSuccess(success_title_msg, success_msg);
                    }
                } else {
                    swalError("Errore!", json.message);
                }
            }
        });
    }
}

function download(filename, text, mimetype) {
    var element = document.createElement('a');
    element.setAttribute('href', "data:" + mimetype + ";base64," + text);
    element.setAttribute('download', filename);
    element.style.display = 'none';
    document.body.appendChild(element);
    element.click();
    document.body.removeChild(element);
}

function PivaNumberLength(evt) {
    evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    if (evt.target.value.length > 10)
        if (!(evt.which == '46' || evt.which == '8' || evt.which == '13')) // backspace/enter/del
            evt.preventDefault();
    return true;
}

function capitalize(s) {
    return s.charAt(0).toUpperCase() + s.slice(1);
}
