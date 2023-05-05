<%-- 
    Document   : uploadDocumet
    Created on : 29-gen-2020, 12.39.45
    Author     : rcosco
--%>

<%@page import="rc.soop.util.Utility"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="rc.soop.domain.DocumentiPrg"%>
<%@page import="rc.soop.domain.Docenti"%>
<%@page import="rc.soop.domain.Allievi"%>
<%@page import="java.util.List"%>
<%@page import="rc.soop.domain.ProgettiFormativi"%>
<%@page import="rc.soop.db.Entity"%>
<%@page import="rc.soop.db.Action"%>
<%@page import="rc.soop.domain.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User us = (User) session.getAttribute("user");
    if (us == null) {
    } else {
        String uri_ = request.getRequestURI();
        String pageName_ = uri_.substring(uri_.lastIndexOf("/") + 1);
        if (!Action.isVisibile(String.valueOf(us.getTipo()), pageName_)) {
            response.sendRedirect(request.getContextPath() + "/page_403.jsp");
        } else {
            String src = session.getAttribute("src").toString();
            Entity e = new Entity();
            ProgettiFormativi p = e.getEm().find(ProgettiFormativi.class, Long.parseLong(request.getParameter("id")));
            List<Allievi> allievi = e.getAllieviProgettiFormativi(p);
            List<Docenti> docenti = e.getDocentiPrg(p);
//            List<DocumentiPrg> registri = e.getRegistriDay(p, new Date());
            long start = 0;
            double ore = 0;
            int max_ore_day = Integer.parseInt(e.getPath("max_ore_day"));
            int max_ore = Integer.parseInt(e.getPath("max_ore_fa"));
            double ore_attuali = p.getOre();
//            if (!registri.isEmpty()) {
//                ore = registri.get(0).getOre();
//                start = registri.get(0).getOrarioend().getTime();
//            }
            e.close();
%>
<html>
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%> - Registri d'aula</title>
        <meta name="description" content="Updates and statistics">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
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

        <!--This page-->
        <link href="<%=src%>/assets/vendors/general/select2/dist/css/select2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-select/dist/css/bootstrap-select.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-timepicker/css/bootstrap-timepicker.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-daterangepicker/daterangepicker.css" rel="stylesheet" type="text/css"/>
        <link href="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/css/bootstrap-datepicker3.css" rel="stylesheet" type="text/css" />
        <!--this page-->
        <link href="<%=src%>/assets/vendors/general/select2/dist/css/select2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/owl.carousel/dist/assets/owl.carousel.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/owl.carousel/dist/assets/owl.theme.default.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/socicon/css/socicon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/line-awesome/css/line-awesome.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/flaticon/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/flaticon2/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/fontawesome5/css/all.min.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/base/style.bundle.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/resource/custom.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/header/base/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/brand/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/aside/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/resource/animate.css" rel="stylesheet" type="text/css"/>
        <link rel="shortcut icon" href="<%=src%>/assets/media/logos/favicon.ico" />
    </head>
    <body class="kt-header--fixed kt-header-mobile--fixed kt-subheader--fixed kt-subheader--enabled kt-subheader--solid kt-aside--enabled kt-aside--fixed">
        <div class="kt-grid kt-grid--hor kt-grid--root">
            <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--ver kt-page">
                <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor">
                    <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor">
                        <div class="kt-content  kt-grid__item kt-grid__item--fluid" id="kt_content">
                            <div class="kt-portlet kt-portlet--mobile">
                                <div class="kt-portlet__head">
                                    <div class="kt-portlet__head-label">
                                        <p>
                                            <label class="kt-portlet__head-title" style="padding-top: 10px;">
                                                Carica Registro Aula:
                                            </label><br>
                                            è possibile caricare un massimo di due registri (mattina, pomeriggio) per un totale di 5 h giornaliere.
                                        </p>
                                    </div>
                                </div>
                                <div class="kt-portlet__body">
                                    <form class="kt-form" id="kt_form" action="<%=request.getContextPath()%>/OperazioniSA?type=uploadRegistrioAula" style="padding-top: 0;"  method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="idprogetto" id="idprogetto" value="<%=p.getId()%>">
                                        <div class="row col" style="color: #464457;">
                                            <h5>Registro del <b id="b_giornio">selezionare giorno</b>. Ore svolte: <b id="b_ore"></b></h5>
                                        </div>
                                        <div class="row">
                                            <div class="col-lg-5">
                                                <div class="form-group">
                                                    <label>Giorno</label><label class='kt-font-danger kt-font-boldest'>*</label>
                                                    <input type="text" class="form-control obbligatory" name="giorno" id="giorno" autocomplete="off" readonly/>
                                                </div>
                                                <div class="form-group">
                                                    <label>Docente</label><label class='kt-font-danger kt-font-boldest'>*</label>
                                                    <div class="select-div" id="docente_div">
                                                        <select class="form-control kt-select2-general obbligatory" id="docente" name="docente">
                                                            <option value="-">Seleziona Docente</option>
                                                            <%for (Docenti s : docenti) {%>
                                                            <option value="<%=s.getId()%>"><%=s.getCognome()%> <%=s.getNome()%></option>
                                                            <%}%>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label>Ora di Inizio e Fine Lezione</label><label class="kt-font-danger kt-font-boldest">*</label>
                                                    <input type="hidden" class="form-control" id="range">
                                                    <input type="text" class="form-control obbligatory disable-input" name="range" id="range2" readonly autocomplete="off" placeholder="Selezionare ora di inzio e fine" disabled>
                                                    <label class='kt-font-danger'>per inserire Ora inizioe fine,selezionare prima il giorno della lezione</label>
                                                </div>
                                            </div>
                                            <div class="col-lg-1">
                                                <div class="center separator"> </div>
                                            </div>
                                            <div class="col-lg-6">
                                                <div class="form-group">
                                                    <label>Presenti</label><label class='kt-font-danger kt-font-boldest'>*</label>
                                                    <div class="select-div" id="allievi_div">
                                                        <select class="form-control kt-select2 obbligatory" id="allievi" name="allievi[]" multiple="multiple">
                                                            <%for (Allievi a : allievi) {%>
                                                            <option selected value="<%=a.getId()%>"><%=a.getCognome()%> <%=a.getNome()%></option>
                                                            <%}%>
                                                        </select>
                                                    </div>
                                                    <label class='kt-font-danger'>per inserire ingresso e uscita per gli alunni settare prima ora inizio e fine lezione</label>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row" id="ingressi_allievi">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                    <div class="form-group">
                                        <div class="kt-form__actions">
                                            <a href="javascript:void(0);" class="btn btn-io" id="submit"><font color='white'>Salva</font></a>
                                            <button onclick="location.reload();" class="btn btn-io-n"><font color='white'>Reset</font></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>	
                </div>
            </div>
        </div>
        <div id="kt_scrolltop" class="kt-scrolltop">
            <i class="fa fa-arrow-up"></i>
        </div>
        <script src="<%=src%>/assets/vendors/general/jquery/dist/jquery.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/popper.js/dist/umd/popper.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap/dist/js/bootstrap.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/js-cookie/src/js.cookie.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/moment/min/moment.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/tooltip.js/dist/umd/tooltip.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/perfect-scrollbar/dist/perfect-scrollbar.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/sticky-js/dist/sticky.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/demo/default/base/scripts.bundle.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/jquery-form/dist/jquery.form.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/jquery-validation/dist/jquery.validate.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/jquery-validation/dist/additional-methods.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/components/extended/blockui1.33.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/soop/js/utility.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/bundle/app.bundle.js" type="text/javascript"></script>
        <!--this page-->
        <script src="<%=src%>/assets/vendors/general/select2/dist/js/select2.full.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/select2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-timepicker/js/bootstrap-timepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-daterangepicker/daterangepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/js/bootstrap-datepicker.js" type="text/javascript"></script>
        <script id="restristro_aula" src="<%=src%>/page/sa/js/restristro_aula.js<%="?dummy=" + String.valueOf(new Date().getTime())%>"
        data-context="<%=request.getContextPath()%>" data-end="0" data-start="<%=start%>" data-day="<%=new Date().getTime()%>" type="text/javascript"></script>
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
            ore = <%=ore%>;
            ore_max = <%=max_ore_day%>;
            ore_max_tot = <%=max_ore%>;
            ore_attuali = <%=ore_attuali%>;
            var date_pick = function () {
                var arrows = {
                    leftArrow: '<i class="la la-angle-left"></i>',
                    rightArrow: '<i class="la la-angle-right"></i>'
                }
                $('#giorno').datepicker({
                    orientation: "bottom left",
                    todayHighlight: true,
                    templates: arrows,
                    autoclose: true,
                    format: 'dd/mm/yyyy',
                    endDate: new Date(),
                    startDate: new Date(<%=p.getStart().getTime()%>),
                });
            }();




            $('#giorno').change(function (e) {
                if ($(this).val() != "") {
                    startBlockUILoad($(this));
                    var registri = getRegisters($(this).val());
                    stopBlockUI($(this))
                    if (registri.length == 0) {
                        ore = 0;
                        millis_start = 0;
                        millis_end = 0;
                        millis_day = 0;
                        ableTime($(this).val(), 0)
                    } else if (registri.length == 1) {
                        ore = registri[0].ore;
                        console.log(ore)
                        millis_start = registri[0].orarioend;
                        millis_day = registri[0].giorno;
                        millis_end = 0;

                        if (ore < ore_max) {
                            ableTime($(this).val(), ore)
                        } else {
                            fastSwalElementResponsive("<h3>Per questo giorno sono state erogate tutte le possibili ore</h3>", "Chiudi");
                        }
                    } else {
                        fastSwalElementResponsive("<h3>Per questo giorno sono stati caricati tutti i possibili registri</h3>", "Chiudi");
                    }
                } else {
                    $('#range2').attr("disabled", "true");
                    $('#range2').addClass("disable-input");
                    $('#b_giornio').html('selezionare giorno');
                }
            });

            function ableTime(giorno, ore) {
                $('#range2').removeAttr("disabled");
                $('#range2').removeClass("disable-input");
                $('#b_giornio').html(giorno);
                $('#b_ore').html(ore);
                genetateTime();
            }


        </script>
    </body>
</html>
<%}
    }%>