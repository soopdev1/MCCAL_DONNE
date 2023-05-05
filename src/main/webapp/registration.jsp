<%-- 
    Document   : login1
    Created on : 15-ott-2019, 10.42.32
    Author     : rcosco
--%>
<%@page import="rc.soop.util.Utility"%>
<%@page import="java.util.List"%>
<%@page import="rc.soop.db.Entity"%>
<%@page import="rc.soop.entity.Item"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Entity e = new Entity();
    List<Item> regioni = e.listaRegioni();
    String g_p_key = e.getPath("googleSiteKey");
    e.close();
%>

<html>
    <!-- begin::Head -->
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%></title>
        <meta name="description" content="Login page example">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
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
        <!-- this page -->
        <link href="assets/vendors/general/bootstrap-select/dist/css/bootstrap-select.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/general/select2/dist/css/select2.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/general/bootstrap-datepicker/dist/css/bootstrap-datepicker3.css" rel="stylesheet" type="text/css" />
        <link href="assets/app/custom/login/login-v3.default.css" rel="stylesheet" type="text/css" />
        <!-- - -->
        <link href="assets/vendors/general/owl.carousel/dist/assets/owl.theme.default.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/general/animate.css/animate.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/general/sweetalert2/dist/sweetalert2.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/custom/vendors/line-awesome/css/line-awesome.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/custom/vendors/flaticon/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/custom/vendors/flaticon2/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/custom/vendors/fontawesome5/css/all.min.css" rel="stylesheet" type="text/css" />
        <link href="assets/demo/default/base/style.bundle.css" rel="stylesheet" type="text/css" />
        <link href="resource/custom.css" rel="stylesheet" type="text/css" />
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
            .kt-login__head{
                margin-bottom: 1rem!important;
            }
            .kt-login__container{
                max-width:1400px!important; 
                width: 100%!important;
            }
            .kt-login__signin{
                max-width:1500px;
                width: 1500px;
                width: 100%;
            }
            .kt-form{
                max-width:1500px;
                width: 100%;
            }
            .kt-login__actions{
                margin-top: 1%!important;
            }
            .select2-container--default .select2-selection--single .select2-selection__rendered {
                background-color: #f3f3f3!important;
            }
            .custom-file-label::after {
                color:#fff;
                background-color: #eaa21c;
            }
            .kt-login.kt-login--v3 .kt-login__wrapper .kt-login__container .kt-form .form-control {
                height: 46px;
                padding-left: 1.5rem;
                padding-right: 1.5rem;
                margin-top: 1.5rem;
                background: rgba(243, 243, 243);
            }
            .custom-file-label::after {
                height: 44px;
                padding-top: 10px;
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
                    <div class="kt-grid__item kt-grid__item--fluid kt-login__wrapper paddig_0_t">
                        <div class="kt-login__container">
                            <div class="kt-login__logo" style="margin-bottom: 10px;">
                                <a href="#">
                                    <img src="assets/media/logos/logo.png" width="320">
                                </a>
                            </div>
                            <div class="kt-login__signin">
                                <div class="kt-login__head">
                                    <h3 class="kt-login__title kt-font-io" style="font-size:2.2rem"><b>YES I START UP</b><br>Calabria</h3>
                                    <div class="kt-login__desc">Inserisci i dati per creare il tuo account:</div>
                                </div>
                                <form class="kt-form" id="kt_form" action="<%=request.getContextPath()%>\Login?type=saveSoggettoAttuatore" method="post" enctype="multipart/form-data">
                                    <input type="hidden" name="g-recaptcha-response" id="g-recaptcha-response">
                                    <div class="row kt-align-right" id="msg_obbfield" name="msg_obbfield" ><div class="col-lg-12"><h6 style="padding-right: 10px;color: #fd397a!important;">I campi contrassegnati da asterisco (* ) sono obbligatori</h6></div></div><br>
                                    <div class="row">
                                        <div class="col-lg-5">
                                            <h5 style="padding-left: 10px;">Soggetto Attuatore</h5>
                                            <div class="col-lg-12">
                                                <input class="form-control" type="text" placeholder="Ragione Sociale *" name="ragionesociale" id="ragionesociale" autocomplete="off">
                                            </div>
                                            <div class="col-lg-12">
                                                <input class="form-control" type="text" placeholder="Partita IVA " name="piva" id="piva" onkeypress="return isNumber(event);"  autocomplete="off">
                                            </div>
                                            <div class="col-lg-12">
                                                <input class="form-control" type="text" placeholder="Codice Fiscale " name="cf" id="cf"  autocomplete="off">
                                            </div>
                                            <div class="col-lg-12">
                                            <h6 style="padding-right: 10px; padding-top:10px;color: #fd397a!important;">È obbligatorio inserire il CF o la P.IVA</h6>
                                            </div>
                                            <h5 style="padding-left: 10px;">Contatti</h5>
                                            <div class="input-group">
                                                <div class="col-lg-6">
                                                    <input class="form-control" type="text" placeholder="Email *" name="email" id="email" autocomplete="off">
                                                </div>
                                                <div class="col-lg-6">
                                                    <input class="form-control" type="text" placeholder="PEC *" name="pec" id="pec" autocomplete="off">
                                                </div>
                                            </div>
                                            <div class="input-group">
                                                <div class="col-lg-6">
                                                    <input class="form-control" type="text" placeholder="Telefono *" name="telefono_sa" id="telefono_sa" onkeypress="return isNumber(event);" autocomplete="off">
                                                </div>
                                                <div class="col-lg-6">
                                                    <input class="form-control" type="text" placeholder="Cellulare *" name="cell_sa" id="cell_sa" onkeypress="return isNumber(event);" autocomplete="off">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-lg-2"></div><br>
                                        <div class="col-lg-5">
                                            <h5 style="padding-left: 10px;">Amministratore Delegato / Unico</h5>
                                            <div class="col-lg-12">
                                                <input class="form-control" type="text" placeholder="Nome *" name="nome_ad" id="nome_ad" autocomplete="off">
                                            </div>
                                            <div class="col-lg-12">
                                                <input class="form-control" type="text" placeholder="Cognome *" name="cognome_ad" id="cognome_ad" autocomplete="off">
                                            </div>
                                            <div class="input-group">
                                                <div class="date col-lg-6">
                                                    <input type="text" class="form-control" placeholder="Data di Nascita *" name="datanascita" id="kt_datepicker_4_2" autocomplete="off">
                                                </div>
                                                <div class="col-lg-6">
                                                    <input class="form-control" type="text" placeholder="Numero Documento *" name="nrodocumento" id="nrodocumento" autocomplete="off">
                                                </div>
                                                <div class="date col-lg-6">
                                                    <input type="text" class="form-control" placeholder="Scadenza Documento *" name="scadenza" data-start="+0d" id="kt_datepicker_4_3" autocomplete="off">
                                                </div>
                                                <div class="col-lg-6">
                                                    <br>
                                                    <div class="custom-file">
                                                        <input type="file" class="custom-file-input" accept="application/pdf" name="cartaid" id="cartaid">
                                                        <label class="custom-file-label selected" id='label_file' style="background-color: #f3f3f3;color: #a7abc3; height: 46px">Carica Doc. *</label>
                                                    </div>
                                                </div>
                                            </div>
                                            <br>
                                            <h5 style="padding-left: 10px;">Referente</h5>
                                            <div class="input-group">
                                                <div class="col-lg-6">
                                                    <input class="form-control " type="text" placeholder="Nome *" name="nome_ref" id="nome_ref" autocomplete="off">
                                                </div>
                                                <div class="col-lg-6">
                                                    <input class="form-control" type="text" placeholder="Cognome *" name="cognome_ref" id="cognome_ref" autocomplete="off">
                                                </div>
                                            </div>
                                            <div class="input-group">
                                                <div class="col-lg-6">
                                                    <input class="form-control" type="text" placeholder="Telefono *" name="tel_ref" id="tel_ref" autocomplete="off" onkeypress="return isNumber(event);">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-12">
                                            <h5 style="padding-left: 10px;">Indirizzo Sede Legale</h5>
                                            <div class="input-group">
                                                <div class="col-xl-4">
                                                    <input class="form-control" type="text" placeholder="Indirizzo *" name="indirizzo" id="indirizzo" autocomplete="off">
                                                </div>
                                                <div class="col-xl-2 ">
                                                    <input class="form-control" type="text" placeholder="CAP *" name="cap" id="cap" autocomplete="off" onkeypress="return isNumber(event);">
                                                </div>
                                            </div>
                                        </div>
                                    </div>  
                                    <div class="col-lg-12 row" style="padding-right: 0px;">
                                        <div class="col-xl-4"style="padding-right: 0px;">
                                            <div class="dropdown bootstrap-select form-control kt-" id="regione_div" style="padding: 0;height: 35px;">
                                                <select class="form-control kt-select2-general" id="regione" name="regione"  style="width: 100%">
                                                    <option value="-">Seleziona Regione *</option>
                                                    <%for (Item i : regioni) {%>
                                                    <option value="<%=i.getValue()%>"><%=i.getDesc()%></option>
                                                    <%}%>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-xl-4"style="padding-right: 0px;">
                                            <div class="dropdown bootstrap-select form-control kt-" id="provincia_div" style="padding: 0;height: 35px;">
                                                <select class="form-control kt-select2-general" id="provincia" name="provincia"  style="width: 100%;">
                                                    <option value="-">Seleziona Provincia *</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-xl-4"style="padding-right: 0px;">
                                            <div class="dropdown bootstrap-select form-control kt-" id="comune_div" style="padding: 0;height: 35px;">
                                                <select class="form-control kt-select2-general" id="comune" name="comune"  style="width: 100%;">
                                                    <option value="-">Seleziona Comune *</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row kt-login__extra">
                                        <div class="col-lg-6">
                                            <label class="kt-checkbox" id="l_termini">
                                                <input type="checkbox" name="agree" id="agree">Accetto <a href="#" class="kt-link kt-login__link kt-font-bold">termini e condizioni</a>.
                                                <span></span>
                                            </label>
                                            <span class="form-text text-muted"></span>
                                        </div>
                                        <div class="col-lg-2"></div>
                                        <div hidden class="col-lg-4">
                                            <div class="g-recaptcha" data-sitekey="6LdnLwgUAAAAAAIb9L3PQlHQgvSCi16sYgbMIMFR"></div>
                                            <script src='https://www.google.com/recaptcha/api.js'></script>
                                        </div>
                                    </div>
                                    <div class="kt-login__actions">
                                        <a  id="submit_change" class="btn btn-io" style="display: none;" >Continua</a>&nbsp;&nbsp;
                                        <a href="registration.jsp" class="btn btn-io-n">Reset</a>
                                    </div>
                                    <div class="kt-login__account">
                                        <span class="kt-login__account-msg">
                                            Sei già accreditato?
                                        </span>
                                        &nbsp;&nbsp;
                                        <a href="login.jsp" class="kt-login__account-link">Torna alla pagina di login</a>
                                    </div>     
                                </form>
                            </div>   
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- end:: Page -->
        <script src="assets/vendors/general/jquery/dist/jquery.js" type="text/javascript"></script>
        <script src="assets/vendors/general/popper.js/dist/umd/popper.js" type="text/javascript"></script>
        <script src="assets/vendors/general/bootstrap/dist/js/bootstrap.min.js" type="text/javascript"></script>
        <script src="assets/vendors/general/js-cookie/src/js.cookie.js" type="text/javascript"></script>
        <script src="assets/vendors/general/moment/min/moment.min.js" type="text/javascript"></script>
        <script src="assets/vendors/general/tooltip.js/dist/umd/tooltip.min.js" type="text/javascript"></script>
        <script src="assets/vendors/general/perfect-scrollbar/dist/perfect-scrollbar.js" type="text/javascript"></script>
        <script src="assets/vendors/general/sticky-js/dist/sticky.min.js" type="text/javascript"></script>
        <script src="assets/vendors/general/jquery-form/dist/jquery.form.min.js" type="text/javascript"></script>
        <script src="assets/vendors/general/jquery-validation/dist/jquery.validate.js" type="text/javascript"></script>
        <script src="assets/vendors/general/jquery-validation/dist/additional-methods.js" type="text/javascript"></script>
        <script src="assets/vendors/custom/components/vendors/jquery-validation/init.js" type="text/javascript"></script>
        <script src="assets/vendors/general/sweetalert2/dist/sweetalert2.js" type="text/javascript"></script>
        <script src="assets/vendors/base/vendors.bundle.js" type="text/javascript"></script>
        <script src="assets/demo/default/base/scripts.bundle.js" type="text/javascript"></script>
        <script src="assets/app/bundle/app.bundle.js" type="text/javascript"></script>
        <script src="assets/app/custom/general/components/extended/blockui1.33.js" type="text/javascript"></script>
        <script src="assets/soop/js/utility.js" type="text/javascript"></script>
        <script src="assets/app/custom/general/components/extended/blockui1.33.js" type="text/javascript"></script>
        <!-- this page -->
        <script src="assets/vendors/custom/vendors/bootstrap-multiselectsplitter/bootstrap-multiselectsplitter.min.js" type="text/javascript"></script>
        <script src="assets/vendors/general/bootstrap-select/dist/js/bootstrap-select.js" type="text/javascript"></script>
        <script src="assets/vendors/general/select2/dist/js/select2.full.js" type="text/javascript"></script>
        <script src="assets/app/custom/general/crud/forms/widgets/select2.js" type="text/javascript"></script>
        <script src="assets/app/custom/general/crud/forms/widgets/bootstrap-select.js" type="text/javascript"></script>
        <script src="assets/vendors/custom/vendors/bootstrap-multiselectsplitter/bootstrap-multiselectsplitter.min.js" type="text/javascript"></script>
        <script src="assets/vendors/general/bootstrap-select/dist/js/bootstrap-select.js" type="text/javascript"></script>
        <script src="assets/app/custom/general/crud/forms/widgets/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="assets/vendors/general/bootstrap-datepicker/dist/js/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="https://www.google.com/recaptcha/api.js?render=<%=g_p_key%>"></script>
        <script id="registration" src="z_js/Registration.js" data-context="<%=request.getContextPath()%>" data-gKey="<%=g_p_key%>" type="text/javascript"></script>
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
    </body>
</html>