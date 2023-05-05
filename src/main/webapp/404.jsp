<%-- 
    Document   : login1
    Created on : 15-ott-2019, 10.42.32
    Author     : rcosco
--%>
<%@page import="rc.soop.util.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String src = session.getAttribute("src") == null ? "" : session.getAttribute("src").toString()+"/";
%>
<html>
    <!-- begin::Head -->
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%></title>
        <script src="<%=src%>resource/webfont.js"></script>
        <script>
            WebFont.load({
                google: {
                    "families": ["Roboto:300,400,500,600,700", "Bree Serif:300,400,500,600,700", "Comic Neue:300,400,500,600,700"]
                },
                active: function () {
                    sessionStorage.fonts = true;
                }
            });
        </script>
        <link href="<%=src%>assets/vendors/general/animate.css/animate.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>assets/vendors/general/sweetalert2/dist/sweetalert2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>assets/vendors/custom/vendors/line-awesome/css/line-awesome.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>assets/vendors/custom/vendors/flaticon/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>assets/vendors/custom/vendors/flaticon2/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>assets/vendors/custom/vendors/fontawesome5/css/all.min.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>assets/demo/default/base/style.bundle.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>assets/demo/default/skins/header/base/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>assets/demo/default/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>assets/demo/default/skins/brand/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>assets/demo/default/skins/aside/light.css" rel="stylesheet" type="text/css" />
        <link rel="shortcut icon" href="<%=src%>assets/media/logos/favicon.ico" />
        <link href="<%=src%>resource/custom.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>resource/404.css" rel="stylesheet" type="text/css"/>
    </head>
    <body class="kt-header--fixed kt-header-mobile--fixed kt-subheader--fixed kt-subheader--enabled kt-subheader--solid kt-aside--enabled kt-aside--fixed kt-page--loading">
        <div class="kt-grid kt-grid--ver kt-grid--root">
            <div class="kt-grid kt-grid--hor kt-grid--root  kt-login kt-login--v3 kt-login--signin">
                <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor" style="background: #fff;">

                    <div class="wrapper">
                        <div class="col-xl-8 col-lg-10 col-md-12 center" id="all_n">
                            <div class="row">
                                <div class="col-4 number_4 text-center" id="1_4" style="display: none;">
                                    4
                                </div>
                                <div class="col-4 zero" id="img" style="display: none;">
                                    <div class="col-12 center-2">
                                        <img src="<%=src%>resource/0.png"/>
                                    </div>
                                </div>
                                <div class="col-4 number_4 text-center" id="2_4" style="display: none;">
                                    4
                                </div>
                            </div>
                            <div class="row">
                                <div class="offset-xl-3 offset-lg-2 offset-md-2 offset-sm-0 col-xl-6 col-lg-8 col-md-8 col-sm-12">
                                    <div class="message sent" id="question" style="display: none;">
                                        Che succede?
                                        <span class="metadata" id="spunte">
                                            <span class="tick"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="15" id="msg-dblcheck-ack" x="2063" y="2076"><path d="M15.01 3.316l-.478-.372a.365.365 0 0 0-.51.063L8.666 9.88a.32.32 0 0 1-.484.032l-.358-.325a.32.32 0 0 0-.484.032l-.378.48a.418.418 0 0 0 .036.54l1.32 1.267a.32.32 0 0 0 .484-.034l6.272-8.048a.366.366 0 0 0-.064-.512zm-4.1 0l-.478-.372a.365.365 0 0 0-.51.063L4.566 9.88a.32.32 0 0 1-.484.032L1.892 7.77a.366.366 0 0 0-.516.005l-.423.433a.364.364 0 0 0 .006.514l3.255 3.185a.32.32 0 0 0 .484-.033l6.272-8.048a.365.365 0 0 0-.063-.51z" fill="#8c8c8c"/></svg></span>
                                        </span>
                                    </div>
                                    <div class="message received" id="answer" style="display: none;">
                                        La pagina che stai cercando non esiste. 
                                    </div>
                                    <div class="message received" id="answer2" style="display: none;">
                                        Ti consigliamo di tornare indietro.
                                    </div>
                                    <div class="message received" id="answer3" style="display: none;">
                                        Buona navigazione! 
                                        <svg height="70" width="70" version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xml:space="preserve"><path style="fill:#54B88B;" d="M399.112,340.385h-43.064c0-55.254-44.793-100.047-100.047-100.047S155.954,285.13,155.954,340.385H112.89c0-79.032,64.079-143.111,143.111-143.111S399.112,261.352,399.112,340.385z"/><path style="fill:#FBDD56;" d="M442.176,340.385h-43.064c0-79.032-64.079-143.111-143.111-143.111S112.89,261.353,112.89,340.385H69.826c0-102.822,83.354-186.175,186.175-186.175S442.176,237.563,442.176,340.385z"/><path style="fill:#FF6E6E;" d="M485.24,340.385h-43.064c0-102.822-83.354-186.175-186.175-186.175S69.826,237.563,69.826,340.385H26.761c0-126.6,102.64-229.239,229.239-229.239S485.24,213.785,485.24,340.385z"/><path style="opacity:0.1;enable-background:new ;" d="M95.451,259.915c-25.536,0-49.191,12.503-63.713,32.804c-3.253,15.378-4.977,31.32-4.977,47.666h129.192c0-14.112,2.928-27.539,8.2-39.715C150.511,275.73,124.171,259.915,95.451,259.915z M480.263,292.719c-14.523-20.301-38.178-32.804-63.713-32.804c-28.719,0-55.058,15.816-68.702,40.755c5.272,12.176,8.2,25.602,8.2,39.715H485.24C485.24,324.038,483.516,308.097,480.263,292.719z"/><g><path style="fill:#C9F4FF;" d="M157.447,321.199c-3.903-0.651-7.199-3.295-8.824-6.903c-9.128-20.269-29.5-34.381-53.172-34.381s-44.044,14.112-53.172,34.381c-1.625,3.608-4.921,6.251-8.824,6.903c-18.763,3.131-33.118,19.285-33.449,38.858c-0.38,22.435,18.449,40.797,40.887,40.797h109.115c22.438,0,41.267-18.362,40.887-40.797C190.565,340.484,176.211,324.33,157.447,321.199z"/><path style="fill:#C9F4FF;" d="M478.546,321.199c-3.903-0.651-7.199-3.295-8.824-6.903c-9.128-20.269-29.5-34.381-53.171-34.381c-23.672,0-44.044,14.112-53.172,34.381c-1.625,3.608-4.921,6.251-8.824,6.903c-18.763,3.131-33.118,19.285-33.449,38.858c-0.38,22.435,18.449,40.797,40.887,40.797h109.115c22.439,0,41.267-18.362,40.887-40.797C511.664,340.484,497.309,324.33,478.546,321.199z"/></g><g><path style="fill:#AEEAF9;" d="M87.617,280.447c-20.267,2.724-37.234,15.856-45.337,33.849c-1.625,3.608-4.921,6.251-8.824,6.903c-18.763,3.131-33.118,19.285-33.449,38.858c-0.38,22.435,18.449,40.797,40.887,40.797h68.428C39.16,377.655,54.661,300.15,87.617,280.447z"/><path style="fill:#AEEAF9;" d="M408.715,280.447c-20.267,2.724-37.234,15.856-45.337,33.849c-1.625,3.608-4.921,6.251-8.824,6.903c-18.763,3.131-33.118,19.285-33.449,38.858c-0.38,22.435,18.449,40.797,40.887,40.797h68.428C360.258,377.655,375.76,300.15,408.715,280.447z"/></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g></svg>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
                <div style="font-size: 10px;">Icons made by <a href="https://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
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
        <script src="<%=src%>assets/vendors/general/jquery/dist/jquery.js" type="text/javascript"></script>
        <script src="<%=src%>assets/vendors/general/popper.js/dist/umd/popper.js" type="text/javascript"></script>
        <script src="<%=src%>assets/vendors/general/bootstrap/dist/js/bootstrap.min.js" type="text/javascript"></script>
        <script src="<%=src%>assets/vendors/general/js-cookie/src/js.cookie.js" type="text/javascript"></script>
        <script src="<%=src%>assets/vendors/general/tooltip.js/dist/umd/tooltip.min.js" type="text/javascript"></script>
        <script src="<%=src%>assets/vendors/general/sticky-js/dist/sticky.min.js" type="text/javascript"></script>
        <script src="<%=src%>assets/demo/default/base/scripts.bundle.js" type="text/javascript"></script>
        <script src="<%=src%>assets/vendors/general/sweetalert2/dist/sweetalert2.js" type="text/javascript"></script>
        <script src="<%=src%>assets/app/bundle/app.bundle.js" type="text/javascript"></script>
        <script src="<%=src%>assets/vendors/base/vendors.bundle.js" type="text/javascript"></script>

        <script>

            var spunte = '<span class="metadata"><span class="tick"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="15" id="msg-dblcheck-ack" x="2063" y="2076"><path d="M15.01 3.316l-.478-.372a.365.365 0 0 0-.51.063L8.666 9.88a.32.32 0 0 1-.484.032l-.358-.325a.32.32 0 0 0-.484.032l-.378.48a.418.418 0 0 0 .036.54l1.32 1.267a.32.32 0 0 0 .484-.034l6.272-8.048a.366.366 0 0 0-.064-.512zm-4.1 0l-.478-.372a.365.365 0 0 0-.51.063L4.566 9.88a.32.32 0 0 1-.484.032L1.892 7.77a.366.366 0 0 0-.516.005l-.423.433a.364.364 0 0 0 .006.514l3.255 3.185a.32.32 0 0 0 .484-.033l6.272-8.048a.365.365 0 0 0-.063-.51z" fill="#4fc3f7"/></svg></span></span>'

            jQuery(document).ready(function () {
                setTimeout(function () {
                    $("#1_4").css("display", "");
                    $("#1_4").addClass("fadeInUpBig animated");
                    setTimeout(function () {
                        $("#img").css("display", "");
                        $("#img").addClass("fadeInRightBig animated");
                        setTimeout(function () {
                            $("#2_4").css("display", "");
                            $("#2_4").addClass("fadeInDownBig animated");
                            setTimeout(function () {
                                $("#all_n").addClass("tada animated");
                                setTimeout(function () {
                                    $("#question").css("display", "");
                                    $("#question").addClass("fadeInDown animated");
                                    setTimeout(function () {
                                        $("#spunte").remove();
                                        $("#question").append(spunte);
                                        setTimeout(function () {
                                            $("#answer").css("display", "");
                                            $("#answer").addClass("fadeInUp animated");
                                            setTimeout(function () {
                                                $("#answer2").css("display", "");
                                                $("#answer2").addClass("fadeInUp animated");
                                                setTimeout(function () {
                                                    $("#answer3").css("display", "");
                                                    $("#answer3").addClass("fadeInUp animated");
                                                }, 1500);
                                            }, 1500);
                                        }, 1000);
                                    }, 1500);
                                }, 1000);
                            }, 1000);
                        }, 500);
                    }, 500);
                }, 400);

            });

        </script>


    </body>
</html>