<%-- 
    Document   : uploadDocumet
    Created on : 29-gen-2020, 12.39.45
    Author     : rcosco
--%>

<%@page import="rc.soop.entity.FadCalendar"%>
<%@page import="java.util.Date"%>
<%@page import="rc.soop.util.Utility"%>
<%@page import="org.apache.commons.lang3.StringEscapeUtils"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="rc.soop.domain.DocumentiPrg"%>
<%@page import="rc.soop.domain.TipoDoc"%>
<%@page import="java.util.List"%>
<%@page import="rc.soop.domain.StatiPrg"%>
<%@page import="rc.soop.domain.ProgettiFormativi"%>
<%@page import="rc.soop.db.Entity"%>
<%@page import="rc.soop.db.Action"%>
<%@page import="rc.soop.domain.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User us = (User) session.getAttribute("user");
    if (us == null) {
    } else {

        String src = session.getAttribute("src").toString();
        Entity e = new Entity();
        ProgettiFormativi p = e.getEm().find(ProgettiFormativi.class, Long.parseLong(request.getParameter("id")));

%>
<html>
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%> - Calendario</title>
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
        <!--this page-->
        <link href="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/css/bootstrap-datepicker3.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-timepicker/css/bootstrap-timepicker.css" rel="stylesheet" type="text/css" />
        <!--fancy-->
        <link href="<%=src%>/assets/soop/css/jquery.fancybox.css" rel="stylesheet" type="text/css"/>
        <script type="text/javascript" src="<%=src%>/assets/soop/js/jquery-1.10.1.min.js"></script>
        <script type="text/javascript" src="<%=src%>/assets/soop/js/jquery.fancybox.js?v=2.1.5"></script>
        <script type="text/javascript" src="<%=src%>/assets/soop/js/fancy.js"></script>
    </head>
    <body class="kt-header--fixed kt-header-mobile--fixed kt-subheader--fixed kt-subheader--enabled kt-subheader--solid kt-aside--enabled kt-aside--fixed">

        <%if (p != null) {

                List<FadCalendar> calendarioFAD = Action.calendarioFAD(request.getParameter("id"));
        %>


        <div class="kt-grid kt-grid--hor kt-grid--root">
            <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--ver kt-page">
                <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor">
                    <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor">
                        <div class="kt-content  kt-grid__item kt-grid__item--fluid" id="kt_content">
                            <div class="kt-portlet kt-portlet--mobile">
                                <div class="kt-portlet__head">
                                    <div class="kt-portlet__head-label">
                                        <h3 class="kt-portlet__head-title">
                                            Progetto Formativo ID <%=p.getId()%> - Soggetto Attuatore <%=p.getSoggetto().getRagionesociale()%> - Calendario FAD
                                        </h3>
                                    </div>
                                </div>
                                <div class="kt-portlet__body">
                                    <%if (!calendarioFAD.isEmpty()) {%>
                                    <div class="kt-portlet__body paddig_0_t paddig_0_b">
                                        <div class="kt-section kt-section--first">
                                            <h4 class="kt-portlet__head-title">
                                                LEZIONI CONFERMATE
                                            </h4>
                                            <div class="kt-section__body">
                                                <div class="table-responsive">
                                                    <table class="table">
                                                        <thead>
                                                            <tr>
                                                                <th scope="col">Data</th>
                                                                <th scope="col">Numero Corso</th>
                                                                <th scope="col">Ora Inizio</th>
                                                                <th scope="col">Ora Fine</th>
                                                                <th scope="col"></th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <%
                                                                for (int i = 0; i < calendarioFAD.size(); i++) {
                                                                    FadCalendar lez = calendarioFAD.get(i);%>
                                                        <form action="../../OperazioniMicro?type=removelez" method="post">
                                                            <input type="hidden" name="idpr1" value="<%=p.getId()%>" />
                                                            <input type="hidden" name="data1" value="<%=lez.getData()%>" />
                                                            <input type="hidden" name="corso1" value="<%=lez.getNumerocorso()%>" />
                                                            <input type="hidden" name="inizio1" value="<%=lez.getOrainizio()%>" />
                                                            <tr>
                                                                <th scope="row">
                                                                    <%=lez.getData()%></th>
                                                                <td><%=lez.getNumerocorso()%></td>
                                                                <td><%=lez.getOrainizio()%></td>
                                                                <td><%=lez.getOrafine()%></td>
                                                                <td><button type="submit" class="btn btn-sm btn-outline-danger">
                                                                        <i class="fa fa-trash"></i> Elimina</button>
                                                                </td>
                                                            </tr>
                                                        </form>
                                                        <%}%>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col"><hr></div>
                                        <%}%>
                                    <form action="../../OperazioniMicro?type=addlez" method="post" onsubmit="return checkform()">
                                        <input type="hidden" name="idpr1" value="<%=p.getId()%>" />
                                        <div class="kt-portlet__body paddig_0_t paddig_0_b">
                                            <div class="kt-section kt-section--first">
                                                <h4 class="kt-portlet__head-title">
                                                    AGGIUNGI NUOVA LEZIONE
                                                </h4>
                                                <div class="kt-section__body"><br>
                                                    <div class="form-group row">
                                                        <div class="col-lg-3">
                                                            <label>Data</label>
                                                            <input type="text" class="form-control kt_datepicker_r"
                                                                   name="datalezione" required
                                                                   id="datalezione" 
                                                                   autocomplete="off"/>
                                                        </div>
                                                        <div class="col-lg-3">
                                                            <label>Numero Corso</label>
                                                            <div class="dropdown bootstrap-select form-control kt-"style="padding: 0;height: 35px;">
                                                                <select class="form-control kt-select2-general" id="corso" name="corso" style="width: 100%" required>
                                                                    <option value="">Seleziona Corso</option>
                                                                    <option value="1">Corso 1</option>
                                                                    <option value="2">Corso 2</option>
                                                                    <option value="3">Corso 3</option>
                                                                    <option value="4">Corso 4</option>
                                                                    <option value="5">Corso 5</option>
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <div class="col-lg-3">
                                                            <label>Ora Inizio</label>
                                                            <input class="form-control kt_timepicker_r" required id="orainizio" name="orainizio" placeholder="Ora Inizio" type="text" />
                                                        </div>

                                                        <div class="col-lg-3">
                                                            <label>Ora Fine</label>
                                                            <input class="form-control kt_timepicker_r2" required id="orafine" name="orafine" placeholder="Ora Fine" type="text" />
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <div class="offset-lg-6 col-lg-6 kt-align-right">
                                                            <button type="submit" class="btn btn-io"><i class="fa fa-save"></i>
                                                                Salva</button>
                                                        </div>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>
                                    </form>
                                    <script type="text/javascript">
                                        function checkform() {
                                            var orainizio = document.getElementById('orainizio').value.trim();
                                            if (orainizio.length === 4) {
                                                orainizio = "0" + orainizio;
                                            }
                                            var orafine = document.getElementById('orafine').value.trim();
                                            if (orafine.length === 4) {
                                                orafine = "0" + orafine;
                                            }
                                            var dateToCompare1 = moment("2013-02-08 " + orainizio + ":00");
                                            var dateToCompare2 = moment("2013-02-08 " + orafine + ":00");
                                            var out = dateToCompare1.isBefore(dateToCompare2);

                                            if (!out) {
                                                document.getElementById('modalerrortxt').innerHTML = "L'ORA DI INIZIO DEVE ESSERE ANTECEDENTE A QUELLA DI FINE.";
                                                document.getElementById('openmodalerror').click();
                                                return false;
                                            }


                                        }
                                    </script>
                                    <!-- Button trigger modal -->
                                    <div class="modal fade"  tabindex="-1" role="dialog" aria-hidden="true">
                                        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#exampleModal" id="openmodalerror">
                                            Launch demo modal
                                        </button>
                                    </div>
                                    <!-- Modal -->
                                    <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                        <div class="modal-dialog" role="document">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title text-danger" id="exampleModalLabel"><i class="fa fa-exclamation-triangle"></i> ERRORE!</h5>
                                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                        <span aria-hidden="true">&times;</span>
                                                    </button>
                                                </div>
                                                <div class="modal-body" id="modalerrortxt">
                                                    
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>	
                </div>
            </div>
        </div>
        <%}%>
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
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/bootstrap-timepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/js/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-timepicker/js/bootstrap-timepicker.js" type="text/javascript"></script>
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
    </body>
</html>
<%
    }%>