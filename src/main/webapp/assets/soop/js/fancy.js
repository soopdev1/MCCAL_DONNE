$('.fancybox').fancybox();

$("a.fancyBoxRaf").fancybox({
    prevEffect: 'none',
    nextEffect: 'none',
    closeBtn: true,
    type: 'iframe',
    autoSize: false,
    fitToView: false,
    height: '80%',
    width: 1200,
    centerOnScroll: true,
    overlayOpacity: 0,
    overlayShow: true,
});

$("a.fancyBoxReload").fancybox({
    prevEffect: 'none',
    nextEffect: 'none',
    closeBtn: true,
    type: 'iframe',
    autoSize: false,
    fitToView: false,
    height: '85%',
    width: 1200,
    centerOnScroll: true,
    overlayOpacity: 0,
    overlayShow: true,
    afterClose: function () {
        reload();
    }
});

$("a.fancyBoxReload2").fancybox({
    prevEffect: 'none',
    nextEffect: 'none',
    closeBtn: true,
    type: 'iframe',
    autoSize: false,
    fitToView: false,
    height: '85%',
    width: 1200,
    centerOnScroll: true,
    overlayOpacity: 0,
    overlayShow: true,
    afterClose: function () {
        reload();
    },
    helpers: {
        overlay: {
            locked: false
        }
    }
});

$("a.fancyBoxRafNotReload").fancybox({
    prevEffect: 'none',
    nextEffect: 'none',
    closeBtn: true,
    type: 'iframe',
    autoSize: false,
    fitToView: false,
    height: "90%",
    width: "75%",
    centerOnScroll: true,
    overlayOpacity: 0,
    overlayShow: true
});

$("a.fancySmallNotReload").fancybox({
    openEffect: 'elastic',
    closeEffect: 'elastic',
    prevEffect: 'fade',
    nextEffect: 'fade',
    fitToView: false, // images won't be scaled to fit to browser's height
    maxWidth: "90%" // images won't exceed the browser's width
});

$("a.fancyProfile").fancybox({
    prevEffect: 'none',
    nextEffect: 'none',
    closeBtn: true,
    type: 'iframe',
    autoSize: false,
    fitToView: false,
    height: 700,
    width: 1000,
    centerOnScroll: true,
    overlayOpacity: 0,
    overlayShow: true,
    afterClose: function () {
        location.reload();
    }

});

$("a.fancyProfileNoRef").fancybox({
    prevEffect: 'none',
    nextEffect: 'none',
    closeBtn: true,
    type: 'iframe',
    autoSize: false,
    fitToView: false,
    height: 700,
    width: 1000,
    centerOnScroll: true,
    overlayOpacity: 0,
    overlayShow: true
});

$("a.fancyDocument").fancybox({
    prevEffect: 'none',
    nextEffect: 'none',
    closeBtn: true,
    type: 'iframe',
    autoSize: false,
    fitToView: false,
    height: 1000,
    width: 1000,
    centerOnScroll: true,
    overlayOpacity: 0,
    overlayShow: true

});

$("a.fancyProfileNoClose").fancybox({
    prevEffect: 'none',
    nextEffect: 'none',
    closeBtn: false,
    closeClick: false,
    helpers: {
        overlay: {closeClick: false}
    },
    keys: {
        close: null
    },
    type: 'iframe',
    autoSize: false,
    fitToView: false,
    height: 653,
    width: 1000,
    centerOnScroll: true,
    overlayOpacity: 0,
    overlayShow: true
});

$("a.fancyForgotPwd").fancybox({
    prevEffect: 'none',
    nextEffect: 'none',
    closeBtn: true,
    type: 'iframe',
    autoSize: false,
    fitToView: false,
    height: 500,
    width: 450,
    centerOnScroll: true,
    overlayOpacity: 0,
    overlayShow: true
});

$("a.fancyBoxProfileS").fancybox({
    prevEffect: 'none',
    nextEffect: 'none',
    closeBtn: true,
    type: 'iframe',
    autoSize: false,
    fitToView: false,
    height: 950,
    width: 1200,
    centerOnScroll: true,
    overlayOpacity: 0,
    overlayShow: true,
    afterClose: function () {
        location.reload();
    }
});

$("a.fancyBoxAntoRef").fancybox({
    prevEffect: 'none',
    nextEffect: 'none',
    closeBtn: true,
    type: 'iframe',
    autoSize: false,
    fitToView: false,
    height: "90%",
    width: "80%",
    centerOnScroll: true,
    overlayOpacity: 0,
    overlayShow: true,
    afterClose: function () {
        reload();
    }

});

$("a.fancyBoxDon").fancybox({
    prevEffect: 'none',
    nextEffect: 'none',
    closeBtn: true,
    type: 'iframe',
    autoSize: false,
    fitToView: false,
    height: 450,
    width: 1100,
    centerOnScroll: true,
    overlayOpacity: 0,
    overlayShow: true
});

$("a.fancyBoxDonRef").fancybox({
    prevEffect: 'none',
    nextEffect: 'none',
    closeBtn: true,
    type: 'iframe',
    autoSize: false,
    fitToView: false,
    height: 450,
    width: 900,
    centerOnScroll: true,
    overlayOpacity: 0,
    overlayShow: true,
    afterClose: function () {
        location.reload();
    }
});

$("a.fancyBoxRafRef").fancybox({
    prevEffect: 'none',
    nextEffect: 'none',
    closeBtn: true,
    type: 'iframe',
    centerOnScroll: true,
    width: "85%",
    overlayOpacity: 0,
    overlayShow: true,
    afterClose: function () {
        location.reload();
    }
});

$("a.fancyBoxRafFull").fancybox({
    prevEffect: 'none',
    nextEffect: 'none',
    openEffect: 'elastic',
    closeEffect: 'elastic',
    closeBtn: true,
    type: 'iframe',
    centerOnScroll: true,
    width: '90%',
    height: '85%',
    overlayOpacity: 0,
    overlayShow: true
});

$("a.fancyBoxRafFullRef").fancybox({
    prevEffect: 'none',
    nextEffect: 'none',
    openEffect: 'elastic',
    closeEffect: 'elastic',
    closeBtn: true,
    type: 'iframe',
    centerOnScroll: true,
    width: '100%',
    height: '100%',
    overlayOpacity: 0,
    overlayShow: true,
    afterClose: function () {
        location.reload();
    }
});
$("a.fancyBoxRafFullRefTable").fancybox({
    prevEffect: 'none',
    nextEffect: 'none',
    openEffect: 'elastic',
    closeEffect: 'elastic',
    closeBtn: true,
    type: 'iframe',
    centerOnScroll: true,
    width: '100%',
    height: '100%',
    overlayOpacity: 0,
    overlayShow: true,
    afterClose: function () {
        reload_table($('#kt_table_1'));
    }
});