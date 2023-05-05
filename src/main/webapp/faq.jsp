<%-- 
    Document   : login1
    Created on : 15-ott-2019, 10.42.32
    Author     : rcosco
--%>
<%@page import="rc.soop.util.Utility"%>
<%@page import="rc.soop.domain.Faq"%>
<%@page import="java.util.List"%>
<%@page import="rc.soop.db.Entity"%>
<%@page import="rc.soop.entity.Item"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Entity e = new Entity();
    List<Faq> faqs = e.getFaqPublic();
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
        <link href="assets/app/custom/login/login-v3.default.css" rel="stylesheet" type="text/css" />
        <!-- - -->
        <!--this page-->
        <link href="assets/vendors/general/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/general/bootstrap-select/dist/css/bootstrap-select.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/general/select2/dist/css/select2.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/general/sweetalert2/dist/sweetalert2.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/custom/vendors/line-awesome/css/line-awesome.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/custom/vendors/flaticon/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/custom/vendors/flaticon2/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/custom/vendors/fontawesome5/css/all.min.css" rel="stylesheet" type="text/css" />
        <link href="resource/animate.css" rel="stylesheet" type="text/css"/>
        <link href="resource/faq.css" rel="stylesheet" type="text/css"/>
        <!----->
        <link href="assets/demo/default/base/style.bundle.css" rel="stylesheet" type="text/css" />
        <link href="resource/custom.css" rel="stylesheet" type="text/css" />
        <link href="assets/demo/default/skins/header/base/light.css" rel="stylesheet" type="text/css" />
        <link href="assets/demo/default/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
        <link href="assets/demo/default/skins/brand/light.css" rel="stylesheet" type="text/css" />
        <link href="assets/demo/default/skins/aside/light.css" rel="stylesheet" type="text/css" />
        <link rel="shortcut icon" href="assets/media/logos/favicon.ico" />
    </head>
    <!-- end::Head -->

    <!-- begin::Body -->
    <body class="kt-header--fixed kt-header-mobile--fixed kt-subheader--fixed kt-subheader--enabled kt-subheader--solid kt-aside--enabled kt-aside--fixed kt-page--loading">

        <!-- begin:: Page -->
        <div class="kt-grid kt-grid--ver kt-grid--root">
            <div class="kt-grid kt-grid--hor kt-grid--root  kt-login kt-login--v3 kt-login--signin" id="kt_login">
                <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor" style="background-image: url(assets/media/bg/bg-3.jpg);">
                    <div class="kt-grid__item kt-grid__item--fluid kt-login__wrapper paddig_0_t" style="width: 100%">
                        <div class="kt-login__container" style="width: 100%">
                            <div class="kt-login__logo" style="margin-bottom: 10px;">
                                <a href="login.jsp">
                                    <img src="assets/media/logos/logo.png" width="320">
                                </a>
                            </div>
                            <div class="kt-login__signin">
                                <div class="kt-login__head">
                                    <h3 class="kt-login__title kt-font-io" style="font-size:2.2rem"><b>FAQs</b></h3>
                                </div>
                                <div class="center col-lg-8 col-md-10 col-sm-12">
                                    <div class="row kt-login__extra">
                                        <div class="col-6 kt-align-left">
                                            <div class="col">
                                                <a href="login.jsp" class="kt-login__link">torna indietro</a>
                                            </div>
                                        </div>
                                    </div><br>
                                    <div class="accordion accordion-solid accordion-toggle-plus" id="accordionExample1">
                                        <%for (Faq f : faqs) {%>
                                        <div class="card">
                                            <div class="card-header">
                                                <div class="card-title collapsed kt-font-io-n" data-toggle="collapse" data-target="#collapse_<%=f.getId()%>" aria-expanded="false" aria-controls="collapse_<%=f.getId()%>" style="text-align: left;">
                                                    <%=f.getDomanda_mod()%>
                                                </div>
                                            </div>
                                            <div id="collapse_<%=f.getId()%>" class="collapse" aria-labelledby="headingOne" data-parent="#accordionExample1">
                                                <div class="card-body" style="text-align: left;">
                                                    <%=f.getRisposta()%>
                                                </div>
                                            </div>
                                        </div>
                                        <%}%>
                                    </div>
                                </div>
                            </div>   
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="assets/vendors/general/jquery/dist/jquery.js" type="text/javascript"></script>
        <script src="assets/vendors/general/popper.js/dist/umd/popper.js" type="text/javascript"></script>
        <script src="assets/vendors/general/bootstrap/dist/js/bootstrap.min.js" type="text/javascript"></script>
        <script src="assets/vendors/general/js-cookie/src/js.cookie.js" type="text/javascript"></script>
        <script src="assets/vendors/general/moment/min/moment.min.js" type="text/javascript"></script>
        <script src="assets/vendors/general/tooltip.js/dist/umd/tooltip.min.js" type="text/javascript"></script>
        <script src="assets/vendors/general/perfect-scrollbar/dist/perfect-scrollbar.js" type="text/javascript"></script>
        <script src="assets/vendors/general/sticky-js/dist/sticky.min.js" type="text/javascript"></script>
        <script src="assets/demo/default/base/scripts.bundle.js" type="text/javascript"></script>
        <script src="assets/vendors/general/jquery-form/dist/jquery.form.min.js" type="text/javascript"></script>
        <script src="assets/vendors/general/jquery-validation/dist/jquery.validate.js" type="text/javascript"></script>
        <script src="assets/vendors/general/jquery-validation/dist/additional-methods.js" type="text/javascript"></script>
        <script src="assets/vendors/custom/components/vendors/jquery-validation/init.js" type="text/javascript"></script>
        <script src="assets/vendors/general/sweetalert2/dist/sweetalert2.js" type="text/javascript"></script>
        <script src="assets/soop/js/utility.js" type="text/javascript"></script>
        <script src="assets/app/bundle/app.bundle.js" type="text/javascript"></script>
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