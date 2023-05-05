"use strict";

var KTPortletDraggable = function () {

    return {
        //main function to initiate the module
        init: function () {
            $("#kt_sortable_portlets").sortable({
                connectWith: ".kt-portlet__head",
                items: ".kt-portlet",
                opacity: 0.8,
                handle: '.kt-portlet__head',
                coneHelperSize: true,
                placeholder: 'kt-portlet--sortable-placeholder',
                forcePlaceholderSize: true,
                tolerance: "pointer",
                helper: "clone",
                tolerance: "pointer",
                forcePlaceholderSize: !0,
                helper: "clone",
                cancel: ".kt-portlet--sortable-empty", // cancel dragging if portlet is in fullscreen mode
                revert: 250, // animation in milliseconds
                update: function (b, c) {
                    if (c.item.prev().hasClass("kt-portlet--sortable-empty")) {
                        c.item.prev().before(c.item);
                    }
                    getClassifica();
                }
            });
        }
    };
}();

function getClassifica() {
    var loghi = $('div[titolo=classifica] input[title=id]');
    for (var i = 0; i < loghi.length; i++) {
        $('#' + loghi[i].value + '_ordine').val(i + 1);
    }
    var title = $('div[titolo=classifica] h3');
    for (var i = 0; i < loghi.length; i++) {
        title[i].innerText = 'Logo ' + (i + 1);
    }
}

jQuery(document).ready(function () {
    KTPortletDraggable.init();
});