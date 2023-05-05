// Class definition

var KTBootstrapDaterangepicker = function () {

// Private functions
    var demos = function () {
// minimum setup
        var d = new Date();
        var d2 = new Date();//massimo selezionabile
        var d3 = new Date(d.getFullYear(), d.getMonth(), d.getDate() - 30);//giono settimana scorsa
        d2.setMonth(d.getMonth() - 3)
        $('#kt_daterangepicker_1, #kt_daterangepicker_1_modal').daterangepicker({
            maxDate: d.toLocaleDateString(),
            minDate: d2.toLocaleDateString(),
            endDate: d.toLocaleDateString(),
            startDate: d3.toLocaleDateString(),
            autoApply: true,
            locale: {
                firstDay: 1,
                format: 'DD/MM/YYYY',
                "daysOfWeek": [
                    "Do",
                    "Lu",
                    "Ma",
                    "Me",
                    "Gi",
                    "Ve",
                    "Sa"
                ],
                "monthNames": [
                    "Gen",
                    "Feb",
                    "Mar",
                    "Apr",
                    "Mag",
                    "Giu",
                    "Lug",
                    "Ago",
                    "Set",
                    "Ott",
                    "Nov",
                    "Dic"
                ],
            }
        }
        );
        $('#kt_daterange').daterangepicker({
            minDate: d.toLocaleDateString(),
            autoApply: true,
            locale: {
                firstDay: 1,
                format: 'DD/MM/YYYY',
                "daysOfWeek": [
                    "Do",
                    "Lu",
                    "Ma",
                    "Me",
                    "Gi",
                    "Ve",
                    "Sa"
                ],
                "monthNames": [
                    "Gen",
                    "Feb",
                    "Mar",
                    "Apr",
                    "Mag",
                    "Giu",
                    "Lug",
                    "Ago",
                    "Set",
                    "Ott",
                    "Nov",
                    "Dic"
                ],
            }
        });
         $('#kt_daterange').val("");
        // input group and left alignment setup
        $('#kt_daterangepicker_1_2').daterangepicker({
            maxDate: d.toLocaleDateString(),
            endDate: d.toLocaleDateString(),
            startDate: new Date(d.getFullYear() - 1, d.getMonth(), d.getDate()).toLocaleDateString(),
            autoApply: true,
            locale: {
                firstDay: 1,
                format: 'DD/MM/YYYY',
                "daysOfWeek": [
                    "Do",
                    "Lu",
                    "Ma",
                    "Me",
                    "Gi",
                    "Ve",
                    "Sa"
                ],
                "monthNames": [
                    "Gen",
                    "Feb",
                    "Mar",
                    "Apr",
                    "Mag",
                    "Giu",
                    "Lug",
                    "Ago",
                    "Set",
                    "Ott",
                    "Nov",
                    "Dic"
                ],
            }
        });
        $('#kt_daterangepicker_2_modal').daterangepicker({
            buttonClasses: ' btn',
            applyClass: 'btn-primary',
            cancelClass: 'btn-secondary'
        }, function (start, end, label) {
            $('#kt_daterangepicker_2 .form-control').val(start.format('YYYY-MM-DD') + ' / ' + end.format('YYYY-MM-DD'));
        });
        // left alignment setup
        $('#kt_daterangepicker_3').daterangepicker({
            buttonClasses: ' btn',
            applyClass: 'btn-primary',
            cancelClass: 'btn-secondary'
        }, function (start, end, label) {
            $('#kt_daterangepicker_3 .form-control').val(start.format('YYYY-MM-DD') + ' / ' + end.format('YYYY-MM-DD'));
        });
        $('#kt_daterangepicker_3_modal').daterangepicker({
            buttonClasses: ' btn',
            applyClass: 'btn-primary',
            cancelClass: 'btn-secondary'
        }, function (start, end, label) {
            $('#kt_daterangepicker_3 .form-control').val(start.format('YYYY-MM-DD') + ' / ' + end.format('YYYY-MM-DD'));
        });
        // date & time
        $('#kt_daterangepicker_4').daterangepicker({
            buttonClasses: ' btn',
            applyClass: 'btn-primary',
            cancelClass: 'btn-secondary',
            timePicker: true,
            startDate: moment().startOf('minute'),
            endDate: moment().startOf('minute').add(1, 'hour'),
            //timePickerIncrement: 30,
            timePickerIncrement: 1,
            locale: {
                firstDay: 1,
                //format: 'MM/DD/YYYY h:mm A'
                format: 'DD/MM/YYYY HH:mm ',
                "daysOfWeek": [
                    "Do",
                    "Lu",
                    "Ma",
                    "Me",
                    "Gi",
                    "Ve",
                    "Sa"
                ],
                "monthNames": [
                    "Gennaio",
                    "Febbraio",
                    "Marzo",
                    "April",
                    "Maggio",
                    "Giugno",
                    "Luglio",
                    "Agosto",
                    "Settembre",
                    "Ottobre",
                    "Novembre",
                    "Dicembre"
                ],
            }
        }, function (start, end, label) {
//$('#kt_daterangepicker_4 .form-control').val( start.format('MM/DD/YYYY h:mm A') + ' / ' + end.format('MM/DD/YYYY h:mm A'));
            $('#kt_daterangepicker_4 .form-control').val(start.format('DD/MM/YYYY HH:mm') + ' | ' + end.format('DD/MM/YYYY HH:mm'));
        });
        // date picker
        $('#kt_daterangepicker_5').daterangepicker({
            buttonClasses: ' btn',
            applyClass: 'btn-primary',
            cancelClass: 'btn-secondary',
            singleDatePicker: true,
            showDropdowns: true,
            locale: {
                format: 'MM/DD/YYYY'
            }
        }, function (start, end, label) {
            $('#kt_daterangepicker_5 .form-control').val(start.format('MM/DD/YYYY') + ' / ' + end.format('MM/DD/YYYY'));
        });
        // predefined ranges
        var start = moment().subtract(29, 'days');
        var end = moment();
        $('#kt_daterangepicker_6').daterangepicker({
            buttonClasses: ' btn',
            applyClass: 'btn-primary',
            cancelClass: 'btn-secondary',
            startDate: start,
            endDate: end,
            ranges: {
                'Today': [moment(), moment()],
                'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                'This Month': [moment().startOf('month'), moment().endOf('month')],
                'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
            }
        }, function (start, end, label) {
            $('#kt_daterangepicker_6 .form-control').val(start.format('MM/DD/YYYY') + ' / ' + end.format('MM/DD/YYYY'));
        });
    }

    var validationDemos = function () {
// input group and left alignment setup
        $('#kt_daterangepicker_1_validate').daterangepicker({
            buttonClasses: ' btn',
            applyClass: 'btn-primary',
            cancelClass: 'btn-secondary'
        }, function (start, end, label) {
            $('#kt_daterangepicker_1_validate .form-control').val(start.format('YYYY-MM-DD') + ' / ' + end.format('YYYY-MM-DD'));
        });
        // input group and left alignment setup
        $('#kt_daterangepicker_2_validate').daterangepicker({
            buttonClasses: ' btn',
            applyClass: 'btn-primary',
            cancelClass: 'btn-secondary'
        }, function (start, end, label) {
            $('#kt_daterangepicker_3_validate .form-control').val(start.format('YYYY-MM-DD') + ' / ' + end.format('YYYY-MM-DD'));
        });
        // input group and left alignment setup
        $('#kt_daterangepicker_3_validate').daterangepicker({
            buttonClasses: ' btn',
            applyClass: 'btn-primary',
            cancelClass: 'btn-secondary'
        }, function (start, end, label) {
            $('#kt_daterangepicker_3_validate .form-control').val(start.format('YYYY-MM-DD') + ' / ' + end.format('YYYY-MM-DD'));
        });
    }

    return {
// public functions
        init: function () {
            demos();
            validationDemos();
        }
    };
}();
jQuery(document).ready(function () {
    KTBootstrapDaterangepicker.init();
});