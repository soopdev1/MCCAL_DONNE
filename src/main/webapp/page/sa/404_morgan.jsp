<%-- 
    Document   : login1
    Created on : 15-ott-2019, 10.42.32
    Author     : rcosco
--%>
<%@page import="rc.soop.util.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
    <!-- begin::Head -->
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%></title>
        <script src="resource/webfont.js"></script>
        <script>
            WebFont.load({
                google: {
                    "families": ["Bellota:300,400,500,600,700", "Bree Serif:300,400,500,600,700", "Comic Neue:300,400,500,600,700"]
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
                font-family: Comic Neue;
            }
            h1{
                font-weight: 700;
            }
            .wrapper{
                width: 100%;
            }
            .number_4{
                font-size: 30rem;
                font-family: Bree Serif;
                font-weight: 500;
                font-style: italic;
                color:#004ba6;
            }
            img {
                width: 25rem;
                display: block;
                margin-left: auto;
                margin-right: auto;
            }
            .center-2{
                margin: auto;
                padding: 70px 0;
            }
            .zero{
                padding: 5% 0;
            }
            .message {
                color: #000;
                clear: both;
                line-height: 18px;
                font-size: 30px;
                padding: 12px;
                position: relative;
                margin: 8px 0;
                max-width: 85%;
                word-wrap: break-word;
                z-index: -1;
            }

            .message:after {
                position: absolute;
                content: "";
                width: 0;
                height: 0;
                border-style: solid;
            }

            .metadata {
                display: inline-block;
                float: right;
                padding: 0 0 0 7px;
                position: relative;
                bottom: -4px;
            }

            .metadata .time {
                color: rgba(0, 0, 0, .45);
                font-size: 11px;
                display: inline-block;
            }

            .metadata .tick {
                display: inline-block;
                margin-left: 2px;
                position: relative;
                top: 4px;
                height: 16px;
                width: 16px;
            }

            .metadata .tick svg {
                position: absolute;
                transition: .5s ease-in-out;
            }

            .metadata .tick svg:first-child {
                -webkit-backface-visibility: hidden;
                backface-visibility: hidden;
                -webkit-transform: perspective(800px) rotateY(180deg);
                transform: perspective(800px) rotateY(180deg);
            }

            .metadata .tick svg:last-child {
                -webkit-backface-visibility: hidden;
                backface-visibility: hidden;
                -webkit-transform: perspective(800px) rotateY(0deg);
                transform: perspective(800px) rotateY(0deg);
            }

            .metadata .tick-animation svg:first-child {
                -webkit-transform: perspective(800px) rotateY(0);
                transform: perspective(800px) rotateY(0);
            }

            .metadata .tick-animation svg:last-child {
                -webkit-transform: perspective(800px) rotateY(-179.9deg);
                transform: perspective(800px) rotateY(-179.9deg);
            }

            .message:first-child {
                margin: 16px 0 8px;
            }

            .message.received {
                background: #e8e8e8;
                border-radius: 0px 5px 5px 5px;
                float: left;
            }

            .message.received .metadata {
                padding: 0 0 0 16px;
            }

            .message.received:after {
                border-width: 0px 10px 10px 0;
                border-color: transparent #e8e8e8 transparent transparent;
                top: 0;
                left: -10px;
            }

            .message.sent {
                background: #e1ffc7;
                border-radius: 5px 0px 5px 5px;
                float: right;
            }

            .message.sent:after {
                border-width: 0px 0 10px 10px;
                border-color: transparent transparent transparent #e1ffc7;
                top: 0;
                right: -10px;
            }
            @media(max-width:1000px){
                .number_4{
                    font-size: 18rem;
                }
                img {
                    width: 18rem;
                }
                .center-2{
                    padding: 5px 0;
                }
            }
            @media(max-width:550px){
                .number_4{
                    font-size: 12rem;
                }
                img {
                    width: 12rem;
                }
            }
        </style>
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
                                        <img src="resource/0.png"/>
                                    </div>
                                </div>
                                <div class="col-4 number_4 text-center" id="2_4" style="display: none;">
                                    4
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-1"></div>
                                <div class="col-5" >
                                    <div class="col-12" id="morgan" style="display: none;">
                                        <img src="resource/morgan.jpg" alt="" style="border-radius: 1000px;"/>
                                    </div>
                                    <div class="col-12" id="morgan_label" style="display: none;">
                                        <h2 class="text-center">Che succede!</h2>
                                    </div>
                                </div>
                                <div class="col-5">
                                    <div class="message received" id="question" style="display: none;">
                                        Che succede?
                                        <span class="metadata"><span class="time"></span></span>
                                    </div>
                                    <div class="message received" id="question2" style="display: none;">
                                        Dov'è Bugo?!?
                                        <span class="metadata"><span class="time"></span></span>
                                    </div>
                                    <div class="message sent" id="answer" style="display: none;">
                                        Ci dispiace ma Bugo non è qui.
                                        <span class="metadata">
                                            <span class="time"></span><span class="tick"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="15" id="msg-dblcheck-ack" x="2063" y="2076"><path d="M15.01 3.316l-.478-.372a.365.365 0 0 0-.51.063L8.666 9.88a.32.32 0 0 1-.484.032l-.358-.325a.32.32 0 0 0-.484.032l-.378.48a.418.418 0 0 0 .036.54l1.32 1.267a.32.32 0 0 0 .484-.034l6.272-8.048a.366.366 0 0 0-.064-.512zm-4.1 0l-.478-.372a.365.365 0 0 0-.51.063L4.566 9.88a.32.32 0 0 1-.484.032L1.892 7.77a.366.366 0 0 0-.516.005l-.423.433a.364.364 0 0 0 .006.514l3.255 3.185a.32.32 0 0 0 .484-.033l6.272-8.048a.365.365 0 0 0-.063-.51z" fill="#4fc3f7"/></svg></span>
                                        </span>
                                    </div>
                                </div>
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

        <script>
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
                                    $("#morgan").css("display", "");
                                    $("#morgan").addClass("flipInY animated");
                                    setTimeout(function () {
                                        $("#question").css("display", "");
                                        $("#question").addClass("fadeInDown animated");
                                        setTimeout(function () {
                                            $("#question2").css("display", "");
                                            $("#question2").addClass("fadeInDown animated");
                                            setTimeout(function () {
                                                $("#answer").css("display", "");
                                                $("#answer").addClass("fadeInUp animated");
                                            }, 1500);
                                        }, 1000);
                                    }, 1000);
                                }, 1000);
                            }, 1000);
                        }, 500);
                    }, 500);
                }, 400);

            });

        </script>


    </body>
</html>