<%-- 
    Document   : profile
    Created on : 18-set-2019, 12.31.26
    Author     : rcosco
--%>

<%@page import="rc.soop.util.Utility"%>
<%@page import="rc.soop.domain.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User us = (User) session.getAttribute("user");
    if (us == null) {
    } else {
        String uri_ = request.getRequestURI();
        //String pageName_ = uri_.substring(uri_.lastIndexOf("/") + 1);
        //String type_ = session.getAttribute("abbonamento").toString();
        //if (!Action.isVisibile(type_, pageName_)) {
        //    response.sendRedirect(request.getContextPath() + "/page_403.jsp");
        //} else {
        String src = session.getAttribute("src").toString();

        String active = request.getParameter("active") == null ? "no" : request.getParameter("active");
%>
<html>
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%> - Password</title>
        <meta name="description" content="Updates and statistics">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <!--begin::Fonts -->
        <script src="<%=src%>/resource/webfont.js"></script>
        <script>
            WebFont.load({
                google: {
                    "families": ["Poppins:300,400,500,600,700", "Roboto:300,400,500,600,700"]
                },
                active: function () {
                    sessionStorage.fonts = true;
                }
            });
        </script>

        <!--end::Fonts -->

        <!--begin::Page Vendors Styles(used by this page) -->

        <!--end::Page Vendors Styles -->

        <!--begin:: Global Mandatory Vendors -->
        <link href="<%=src%>/assets/vendors/general/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet" type="text/css" />

        <!--end:: Global Mandatory Vendors -->

        <!--begin:: Global Optional Vendors -->
        <link href="<%=src%>/assets/vendors/general/bootstrap-touchspin/dist/jquery.bootstrap-touchspin.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-select/dist/css/bootstrap-select.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-switch/dist/css/bootstrap3/bootstrap-switch.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/select2/dist/css/select2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/ion-rangeslider/css/ion.rangeSlider.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/nouislider/distribute/nouislider.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/owl.carousel/dist/assets/owl.carousel.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/owl.carousel/dist/assets/owl.theme.default.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/socicon/css/socicon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/line-awesome/css/line-awesome.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/flaticon/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/flaticon2/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/fontawesome5/css/all.min.css" rel="stylesheet" type="text/css" />

        <!--end:: Global Optional Vendors -->

        <!--begin::Global Theme Styles(used by all pages) -->
        <link href="<%=src%>/assets/demo/default/base/style.bundle.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/resource/custom.css" rel="stylesheet" type="text/css" />

        <!--end::Global Theme Styles -->
        <link href="<%=src%>/assets/vendors/general/bootstrap-daterangepicker/daterangepicker.css" rel="stylesheet" type="text/css"/>
        <!--begin::Layout Skins(used by all pages) -->
        <link href="<%=src%>/assets/demo/default/skins/header/base/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/brand/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/aside/light.css" rel="stylesheet" type="text/css" />

        <link href="<%=src%>/resource/animate.css" rel="stylesheet" type="text/css"/>
        <!--end::Layout Skins -->
        <link rel="shortcut icon" href="<%=src%>/assets/media/logos/favicon.ico" />

        <!--end::countDown -->

    </head>
    <body class="kt-header--fixed kt-header-mobile--fixed kt-subheader--fixed kt-subheader--enabled kt-subheader--solid kt-aside--enabled kt-aside--fixed">
        <!-- begin:: Page -->
        <div class="kt-grid kt-grid--hor kt-grid--root">
            <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--ver kt-page">
                <!-- end:: Aside -->
                <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor">
                    <!-- begin:: Footer -->
                    <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor">
                        <!-- begin:: Content Head -->
                        <!-- end:: Content Head -->
                        <!-- begin:: Content -->
                        <div class="kt-content  kt-grid__item kt-grid__item--fluid" id="kt_content">
                            <div class="kt-portlet kt-portlet--mobile">
                                <div class="kt-portlet__head kt-portlet__head--noborder">
                                    <div class="kt-portlet__head-label">
                                        <h3 class="kt-portlet__head-title kt-font-io">
                                            <i class="flaticon2-user"></i> Cambio Password <% if (us.getSoggettoAttuatore() != null) {%>| <b><%=us.getSoggettoAttuatore().getRagionesociale()%></b>&nbsp;&nbsp;&nbsp;<%}%>
                                        </h3>
                                    </div>
                                </div>
                                <div class="kt-portlet__body">
                                    <form class="kt-form" id="kt_form_pwd" action="<%=request.getContextPath()%>/Login?type=changePwd" style="padding-top: 0;" method="post">
                                        <input type="hidden" name="active" value="<%=active%>" />
                                        <div class="col-md-8 col-sm-12">
                                            <div class="kt-section kt-section--space-md">
                                                <br><br><br>
                                                <div class="form-group form-group-sm row">
                                                    <div class="col-md-6">
                                                        <div class="form-group ">
                                                            <label>Vecchia Password</label><label class="kt-font-danger kt-font-boldest">*</label>
                                                            <input type="password" class="form-control" id="old_pwd" name="old_pwd" placeholder="vecchia password">
                                                        </div>
                                                        <div class="form-group ">
                                                            <label>Nuova Password</label><label class="kt-font-danger kt-font-boldest">*</label>
                                                            <input type="password" class="form-control" id="new_pwd" name="new_pwd" placeholder="nuova password">
                                                        </div>
                                                        <div class="form-group ">
                                                            <label>Ripeti Password</label><label class="kt-font-danger kt-font-boldest">*</label>
                                                            <input type="password" class="form-control" id="new_pwd_2" name="new_pwd_2" placeholder="ripeti password">
                                                        </div>
                                                        <div class="form-group form-group-marginless ">
                                                            <div class="col">
                                                                <br><br>
                                                                <a href="jascript:void(0);" id="submit_change" class="btn btn-io" style="font-family: Poppins"><i class="fa fa-exchange-alt"></i> Modifica</a>
                                                            </div>
                                                        </div>
                                                        <br><br>
                                                    </div>
                                                    <div class="col-md-1"></div>
                                                    <div class="col-md-5">
                                                        <div class="col row" style="border-radius: 10px;  border: 2px solid #363a90;">
                                                            <div class="form-group">
                                                                <label class="kt-font-io-n kt-font-bold"><font size="2" >
                                                                    <br>
                                                                    <b>Requisiti nuova password</b><br><br>
                                                                    - lunghezza minima 8 caratteri;<br>
                                                                    - un carattere maiuscolo;<br>
                                                                    - un carattere minuscolo;<br>
                                                                    - un numero;<br>
                                                                    - un carattere speciale;<br>
                                                                    </font></label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </form>     
                                </div>
                            </div>
                        </div>
                    </div>	
                </div>
                <!-- end:: Content -->
            </div>
        </div>

        <!-- end:: Page -->

        <!-- begin::Quick Panel -->


        <!-- end::Quick Panel -->

        <!-- begin::Scrolltop -->
        <div id="kt_scrolltop" class="kt-scrolltop">
            <i class="fa fa-arrow-up"></i>
        </div>

        <!--begin:: Global Mandatory Vendors -->
        <script src="<%=src%>/assets/vendors/general/jquery/dist/jquery.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/popper.js/dist/umd/popper.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap/dist/js/bootstrap.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/js-cookie/src/js.cookie.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/moment/min/moment.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/tooltip.js/dist/umd/tooltip.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/perfect-scrollbar/dist/perfect-scrollbar.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/sticky-js/dist/sticky.min.js" type="text/javascript"></script>
        <!--end:: Global Mandatory Vendors -->
        <script src="<%=src%>/assets/vendors/general/select2/dist/js/select2.full.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/select2.js" type="text/javascript"></script>
        <!--begin::Global Theme Bundle(used by all pages) -->
        <script src="<%=src%>/assets/demo/default/base/scripts.bundle.js" type="text/javascript"></script>
        <!--end::Global Theme Bundle -->
        <!--begin::Page Vendors(used by this page) -->
        <script src="<%=src%>/assets/vendors/general/jquery-form/dist/jquery.form.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/custom/vendors/bootstrap-multiselectsplitter/bootstrap-multiselectsplitter.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-select/dist/js/bootstrap-select.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/jquery-validation/dist/jquery.validate.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/jquery-validation/dist/additional-methods.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/custom/components/vendors/jquery-validation/init.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/components/extended/blockui1.33.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/soop/js/utility.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/bundle/app.bundle.js" type="text/javascript"></script>
        <!--DATERANGEPICKER -->
        <script type="text/javascript">
            var KTAppOptions = {
                "colors": {
                    "state": {
                        "brand": "#5d78ff",
                        "dark": "#282a3c",
                        "light": "#ffffff",
                        "primary": "#5867dd",
                        "success": "#34bfa3",
                        "info": "#36a3f7",
                        "warning": "#ffb822"
                    },
                    "base": {
                        "label": ["#c5cbe3", "#a1a8c3", "#3d4465", "#3e4466"],
                        "shape": ["#f0f3ff", "#d9dffa", "#afb4d4", "#646c9a"]
                    }
                }
            };
        </script>
        <script>
            $("#new_pwd").change(function () {
                if (!veryPass($("#new_pwd").val())) {
                    $("#new_pwd").attr("class", "form-control is-invalid");
                } else {
                    $("#new_pwd").attr("class", "form-control is-valid");
                    samePass($("#new_pwd").val(), $("#new_pwd_2").val());
                }
            });

            $("#new_pwd_2").change(function () {
                samePass($("#new_pwd").val(), $("#new_pwd_2").val());
            });

            function veryPass(pass) {
                var err = true;
                if (pass.length < 8) {
                    err = false;
                }
                if (!(/[!@#$%^&*(),.?":{}|<>_-]/.test(pass))) {
                    err = false;
                }
                if (!(/[A-Z]/.test(pass))) {
                    err = false;
                }
                if (!(/[a-z]/.test(pass))) {
                    err = false;
                }
                if (!err) {
                    $("#new_pwd").attr("class", "form-control is-invalid");
                    $("#new_pwd_2").attr("class", "form-control is-invalid");
                    fastSwal("La nuova password non rispetta i requisiti:"
                            +"<div class='text-left'><br>lunghezza minima 8 caratteri;"
                            + "<br>un carattere maiuscolo;"
                            + "<br>un carattere minuscolo;"
                            + "<br>un numero;"
                            + "<br>un carattere speciale;<div>", "Chiudi", "wobble")
                }
                return err;
            }
            function samePass(pwd1, pwd2) {
                if (pwd2 != "") {
                    if (pwd1 != pwd2) {
                        $("#new_pwd_2").attr("class", "form-control is-invalid");
                        fastSwal("Errore", "Le due password sono diverse", "wooble")
                        return false;
                    } else {
                        $("#new_pwd").attr("class", "form-control is-valid");
                        $("#new_pwd_2").attr("class", "form-control is-valid");
                        return true;
                    }
                }
                return false;
            }

            $("#submit_change").on('click', function () {
                var pwd1 = $("#new_pwd").val();
                var pwd2 = $("#new_pwd_2").val();
                if (veryPass(pwd1) && veryPass(pwd2) && samePass(pwd1, pwd2)) {
                    showLoad()
                    $('#kt_form_pwd').ajaxSubmit({
                        error: function () {
                            closeSwal();
                            swal.fire({
                                "title": 'Errore',
                                "text": "Riprovare, se l'errore persiste contattare il servizio clienti",
                                "type": "error",
                                cancelButtonClass: "btn btn-io-n",
                            });
                        },
                        success: function (resp) {
                            var json = JSON.parse(resp);
                            closeSwal();
                            if (json.result) {
                                swal.fire({
                                    "title": '<h3><b>Password modificata con successo!</b></h3><br>',
                                    "html": "<h5>ora la tua password è stata modificata</h5>",
                                    "type": "success",
                                    "width": '45%',
                                    "confirmButtonClass": "btn btn-io",
                                    onClose: () => {
                                        parent.fancyBoxClose();
                                    }
                                });
                            } else {
                                swal.fire({
                                    "title": '<h3><b>Errore!</b></h3><br>',
                                    "html": "<h5>" + json.messagge + "</h5>",
                                    "type": "error",
                                    cancelButtonClass: "btn btn-io-n",
                                });
                            }
                        }
                    });
                }
            });

            if (<%=us.getStato()%> == '2') {
                jQuery(document).ready(function () {
                    swal.fire({
                        html: '<h3><b>Cambio password</b></h3><br>'
                                + '<h5>Se si è aperta questa pagina vuol dire che sei al primo accesso oppure hai effettuato il recupero password.</h5>',
                        width: '45%',
                        imageWidth: 300,
                        imageHeight: 200,
                        buttonsStyling: false,
                        confirmButtonText: "OK",
                        confirmButtonClass: "btn btn-io",
                        animation: false,
                        customClass: {
                            popup: 'animated bounceInDown'
                        }
                    });
                });
            }
        </script>

    </body>
</html>
<%}//}%>
