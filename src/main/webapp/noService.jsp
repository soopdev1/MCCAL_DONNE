<%-- 
    Document   : login1
    Created on : 15-ott-2019, 10.42.32
    Author     : rcosco
--%>
<%@page import="rc.soop.db.Entity"%>
<%@page import="rc.soop.util.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
     <%   Entity e = new Entity();
        String mantenance = e.getPath("mantenance");
            e.close();
            if (mantenance.equals("N")) {
                Utility.redirect(request, response, "login.jsp");
        }
    %>
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%></title>S
        <script src="resource/webfont.js"></script>
        <script>
            WebFont.load({
                google: {
                    "families": ["Roboto:300,400,500,600,700", "Poppins:300,400,500,600,700"]
                },
                active: function () {
                    sessionStorage.fonts = true;
                }
            });
        </script>
        <link href="assets/vendors/general/animate.css/animate.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/general/sweetalert2/dist/sweetalert2.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/custom/vendors/line-awesome/css/line-awesome.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/custom/vendors/flaticon/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/custom/vendors/flaticon2/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="assets/vendors/custom/vendors/fontawesome5/css/all.min.css" rel="stylesheet" type="text/css" />
        <link href="assets/demo/default/base/style.bundle.css" rel="stylesheet" type="text/css" />
        <link href="assets/demo/default/skins/header/base/light.css" rel="stylesheet" type="text/css" />
        <link href="assets/demo/default/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
        <link href="assets/demo/default/skins/brand/light.css" rel="stylesheet" type="text/css" />
        <link href="assets/demo/default/skins/aside/light.css" rel="stylesheet" type="text/css" />
        <link rel="shortcut icon" href="assets/media/logos/favicon.ico" />
        <link href="resource/custom.css" rel="stylesheet" type="text/css" />
        <style>
            body{
                font-family: Poppins;
            }
            h1{
                font-size: 4rem;
            }
        </style>
    </head>
    <body class="kt-header--fixed kt-header-mobile--fixed kt-subheader--fixed kt-subheader--enabled kt-subheader--solid kt-aside--enabled kt-aside--fixed kt-page--loading">
        <div class="kt-grid kt-grid--ver kt-grid--root">
            <div class="kt-grid kt-grid--hor kt-grid--root  kt-login kt-login--v3 kt-login--signin">
                <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor" style="background: #fff;">

                        <div class="col-12 center" >
                            <div class="col-xl-6 col-lg-8 col-md-12 center" style="padding: 2% 0 0 0;">
                                <img src="resource/maintenance.png" width="100%" alt="" style="border-radius: 50px;"/>
                            </div>
                            <div class="row">
                                <div class="col-xl-6 col-lg-8 col-md-12 center text-center" style="padding: 20 0 0 0;">
                                    <h1>Il portale del Microcredito è attualmente in manutenzione.</h1>
                                </div>
                            </div>
                    </div>
                </div>
            </div>
        </div>
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
        <script src="assets/vendors/general/jquery/dist/jquery.js" type="text/javascript"></script>
        <script src="assets/vendors/general/popper.js/dist/umd/popper.js" type="text/javascript"></script>
        <script src="assets/vendors/general/bootstrap/dist/js/bootstrap.min.js" type="text/javascript"></script>
        <script src="assets/vendors/general/js-cookie/src/js.cookie.js" type="text/javascript"></script>
        <script src="assets/vendors/general/tooltip.js/dist/umd/tooltip.min.js" type="text/javascript"></script>
        <script src="assets/vendors/general/sticky-js/dist/sticky.min.js" type="text/javascript"></script>
        <script src="assets/demo/default/base/scripts.bundle.js" type="text/javascript"></script>
        <script src="assets/vendors/general/sweetalert2/dist/sweetalert2.js" type="text/javascript"></script>
        <script src="assets/app/bundle/app.bundle.js" type="text/javascript"></script>
        <script src="assets/vendors/base/vendors.bundle.js" type="text/javascript"></script>

    </body>
</html>