<%-- 
    Document   : login1
    Created on : 15-ott-2019, 10.42.32
    Author     : rcosco
--%>
<%@page import="rc.soop.db.Entity"%>
<%@page import="rc.soop.util.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%></title>
        <meta name="description" content="Login page example">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <!--begin::Fonts -->
        <script src="resource/webfont.js"></script>
        <script>
            WebFont.load({
                google: {
                    "families": ["Poppins:300,400,500,600,700", "Roboto:300,400,500,600,700", "Architects Daughter:300,400,500,600,700"]
                },
                active: function () {
                    sessionStorage.fonts = true;
                }
            });
        </script>
        <link href="assets/app/custom/login/login-v3.default.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/general/bootstrap-touchspin/dist/jquery.bootstrap-touchspin.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/general/animate.css/animate.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/general/sweetalert2/dist/sweetalert2.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/general/socicon/css/socicon.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/custom/vendors/line-awesome/css/line-awesome.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/custom/vendors/flaticon/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/custom/vendors/flaticon2/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/custom/vendors/fontawesome5/css/all.min.css" rel="stylesheet" type="text/css" />
        <link href="assets/demo/default/base/style.bundle.css" rel="stylesheet" type="text/css" />
        <link href="resource/custom.css" rel="stylesheet" type="text/css" />
        <link href="assets/demo/default/skins/header/base/light.css" rel="stylesheet" type="text/css" />
        <link href="assets/demo/default/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
        <link href="assets/demo/default/skins/brand/light.css" rel="stylesheet" type="text/css" />
        <link href="assets/demo/default/skins/aside/light.css" rel="stylesheet" type="text/css" />
        <link rel="shortcut icon" href="assets/media/logos/favicon.ico" />
        <style type="text/css">
            label {
                color: #363a90;
            }
            .kt-login.kt-login--v3 .kt-login__wrapper {
                max-width:1500px;
                padding-top: 5rem;
                width: 100%;
            }
        </style>
    </head>
    <!-- end::Head -->

    <!-- begin::Body -->
    <body class="kt-header--fixed kt-header-mobile--fixed kt-subheader--fixed kt-subheader--enabled kt-subheader--solid kt-aside--enabled kt-aside--fixed kt-page--loading">

        <!-- begin:: Page -->
        <div class="kt-grid kt-grid--ver kt-grid--root">
            <div class="kt-grid kt-grid--hor kt-grid--root  kt-login kt-login--v3 kt-login--signin" id="kt_login">
                <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor" style="background-image: url(assets/media/bg/bg-3.jpg);">
                    <div class="kt-grid__item kt-grid__item--fluid kt-login__wrapper">
                        <div class="kt-login__container">
                            <div class="kt-login__logo">
                                <a href="#">
                                    <img src="assets/media/logos/logo.png" width="350">
                                </a>
                            </div>
                            <div class="kt-login__signin">
                                <div class="kt-login__head">
                                    <h3 class="kt-login__title kt-font-io" style="font-size:2rem"><b>YES I START UP</b><br>Calabria</h3>
                                    <div class="kt-login__title">Accedi</div>
                                </div>
                                <!--<div class="kt-login__head">
                                    <h3 class="kt-login__title">Accedi</h3>
                                </div>-->
                                <form action="Login?type=login" id="kt-form" class="kt-form" onsubmit="return ctrlForm();" accept-charset="ISO-8859-1" method="post">
                                    <div class="form-group">
                                        <input class="form-control" type="text" placeholder="Username" name="username" id="user" autocomplete="off">
                                    </div>
                                    <div class="form-group">
                                        <input class="form-control" type="password" placeholder="Password" name="password" id="password" autocomplete="off">
                                    </div>
                                    <div class="row kt-login__extra">
                                        <!--div class="col">
                                            <label class="kt-checkbox">
                                                <input type="checkbox" name="remember"> Ricordami
                                                <span></span>
                                            </label>
                                        </div-->
                                        <div class="col kt-align-right">
                                            <a href="javascript:;" id="kt_login_forgot" class="kt-login__link">Password dimenticata ?</a>
                                        </div>
                                    </div>
                                    <div class="kt-login__actions">
                                        <button id="kt_login_signin_submit" type="submit" class="btn btn-io kt-login__btn-primary">Login</button>
                                    </div>
                                </form>
                            </div>
                            <div class="kt-login__forgot">
                                <div class="kt-login__head">
                                    <h3 class="kt-login__title">Password dimenticata ?</h3>
                                    <div class="kt-login__desc">Inserisci il tuo username per effettuare il reset password:</div>
                                </div>
                                <form class="kt-form" id="kt_form_pwd" action="Login?type=forgotPwd">
                                    <div class="input-group">
                                        <input class="form-control" type="text" placeholder="Username o Email" name="email" id="email" autocomplete="off">
                                    </div>
                                    <div class="kt-login__actions">
                                        <a href="jascript:void(0);" id="submit_pwd" class="btn btn-io">Continua</a>&nbsp;&nbsp;
                                        <button id="kt_login_forgot_cancel" class="btn btn-io-n ">Reset</button>
                                    </div>
                                </form>
                            </div>
                            <div class="kt-login__account">
                                <span class="kt-login__account-msg">
                                    Non hai un account ?
                                </span>
                                &nbsp;&nbsp;
                                <a href="registration.jsp" class="kt-login__account-link">Accreditati al progetto YES I START UP</a>
                            </div>
                        </div>
                    </div>
                </div>
                <%@ include file="menu/footer.jsp"%>
            </div>
        </div>

        <!-- end:: Page -->
        <!--begin:: Global Mandatory Vendors -->
        <script src="assets/soop/js/utility.js" type="text/javascript"></script>
        <script>
                                    function ctrlForm() {
                                        var err = false;
                                        var user = $("#user");
                                        var pass = $("#password");
                                        if (checkValue(user, false)) {
                                            err = true;
                                        }
                                        if (checkValue(pass, false)) {
                                            err = true;
                                        }
                                        if (err) {
                                            $("#drop_login").trigger('click')
                                            return false;
                                        }
                                        swal.fire({
                                            title: 'Sto Accedendo...',
                                            text: '',
                                            onOpen: function () {
                                                swal.showLoading();
                                            }
                                        });
                                        return true;
                                    }
        </script>

        <script>
            var KTAppOptions = {
                "colors": {
                    "state": {
                        "brand": "#5d78ff",
                        "dark": "#282a3c",
                        "light": "#ffffff",
                        "primary": "#5867dd",
                        "success": "#34bfa3",
                        "info": "#36a3f7",
                        "warning": "#ffb822",
                        "danger": "#fd3995"
                    },
                    "base": {
                        "label": ["#c5cbe3", "#a1a8c3", "#3d4465", "#3e4466"],
                        "shape": ["#f0f3ff", "#d9dffa", "#afb4d4", "#646c9a"]
                    }
                }
            };
        </script>

        <script type="text/javascript" src="assets/soop/js/jquery-1.10.1.min.js"></script>
        <script type="text/javascript" src="assets/soop/js/jquery.fancybox.js?v=2.1.5"></script>
        <script type="text/javascript" src="assets/soop/js/fancy.js"></script>
        <script src="assets/vendors/general/jquery/dist/jquery.js" type="text/javascript"></script>
        <script src="assets/vendors/general/popper.js/dist/umd/popper.js" type="text/javascript"></script>
        <script src="assets/vendors/general/bootstrap/dist/js/bootstrap.min.js" type="text/javascript"></script>
        <script src="assets/vendors/general/js-cookie/src/js.cookie.js" type="text/javascript"></script>
        <script src="assets/vendors/general/moment/min/moment.min.js" type="text/javascript"></script>
        <script src="assets/vendors/general/tooltip.js/dist/umd/tooltip.min.js" type="text/javascript"></script>
        <script src="assets/vendors/general/jquery-form/dist/jquery.form.min.js" type="text/javascript"></script>
        <script src="assets/vendors/general/perfect-scrollbar/dist/perfect-scrollbar.js" type="text/javascript"></script>
        <script src="assets/vendors/general/sticky-js/dist/sticky.min.js" type="text/javascript"></script>
        <script src="assets/demo/default/base/scripts.bundle.js" type="text/javascript"></script>
        <script src="assets/vendors/general/sweetalert2/dist/sweetalert2.js" type="text/javascript"></script>
        <script src="assets/app/custom/login/login-general.js" type="text/javascript"></script>
        <script src="assets/app/bundle/app.bundle.js" type="text/javascript"></script>
        <script src="assets/vendors/base/vendors.bundle.js" type="text/javascript"></script>

        <script type="text/javascript">
            function ctrlEmail() {
                var err = true;
                var email = $('#email');
                if (checkValue(email, false)) {
                    err = false;
                }
                return err;
            }

            $("#submit_pwd").on('click', function () {
                if (ctrlEmail()) {
                    showLoad()
                    $('#kt_form_pwd').ajaxSubmit({
                        error: function () {
                            closeSwal();
                            swal.fire({
                                "title": 'Errore',
                                "text": "Riprovare, se l'errore persiste contattare il servizio clienti",
                                "type": "error",
                                cancelButtonColor: "#3a2c7a",
                                cancelButtonClass: "btn btn-io-n",
                            });
                        },
                        success: function (resp) {
                            var json = JSON.parse(resp);
                            closeSwal();
                            if (json.result) {
                                swalSuccessReload("Password cambiata con successo!", "Hai ricevuto una mail al tuo indirizzo contenente la nuova password da modificare al prossimo accesso")
                            } else {
                                $('#email').attr("class", "form-control is-invalid");
                                swal.fire({
                                    "title": '<h3><b>Errore!</b></h3>',
                                    "html": "<h5>" + json.messagge + "</h5>",
                                    "type": "error",
                                    cancelButtonClass: "btn btn-io-n",
                                });
                            }
                        }
                    });
                }
            }
            );
        </script>

        <script type="text/javascript">
            <%  String esito = request.getParameter("esito");
                if (esito == null) {
                    esito = "";
                } else if (esito.equals("KO")) {%>
            swal.fire({
                type: 'error',
                title: 'Credenziali errate',
                confirmButtonColor: '#363a90',
            });
            <%} else if (esito.equals("banned")) {%>
            swal.fire({
                type: 'error',
                title: 'Utenza bloccata',
                confirmButtonColor: '#363a90',
            });
            <%}%>
        </script>
    </body>

    <!-- end::Body -->
</html>