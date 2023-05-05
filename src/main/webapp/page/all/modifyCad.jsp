
<%@page import="rc.soop.util.Utility"%>
<%@page import="rc.soop.domain.Cad"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="rc.soop.domain.FadMicro"%>
<%@page import="rc.soop.entity.Item"%>
<%@page import="java.util.List"%>
<%@page import="rc.soop.domain.User"%>
<%@page import="rc.soop.db.Entity"%>
<%@page import="rc.soop.db.Action"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    User us = (User) session.getAttribute("user");
    if (us == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    } else {
        String uri_ = request.getRequestURI();
        String pageName_ = uri_.substring(uri_.lastIndexOf("/") + 1);
        if (!Action.isVisibile(String.valueOf(us.getTipo()), pageName_)) {
            response.sendRedirect(request.getContextPath() + "/page_403.jsp");
        } else {
            Entity e = new Entity();
            Cad cad = e.getEm().find(Cad.class, Long.parseLong(request.getParameter("idCad")));
            e.close();
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            SimpleDateFormat sdf_h = new SimpleDateFormat("HH:mm");
            String src = session.getAttribute("src").toString();
%>
<html>
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%> - Crea Conferenza</title>
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
        <!-- this page -->
        <link href="<%=src%>/assets/vendors/general/bootstrap-daterangepicker/daterangepicker.css" rel="stylesheet" type="text/css"/>
        <link href="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/css/bootstrap-datepicker3.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-timepicker/css/bootstrap-timepicker.css" rel="stylesheet" type="text/css" />
        <!-- - -->
        <link href="<%=src%>/assets/vendors/general/owl.carousel/dist/assets/owl.carousel.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/owl.carousel/dist/assets/owl.theme.default.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/line-awesome/css/line-awesome.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/flaticon/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/flaticon2/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/fontawesome5/css/all.min.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/resource/animate.css" rel="stylesheet" type="text/css"/>
        <link href="<%=src%>/assets/demo/default/base/style.bundle.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/resource/custom.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/header/base/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/brand/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/aside/light.css" rel="stylesheet" type="text/css" />
        <!-- this page -->

        <link rel="shortcut icon" href="<%=src%>/assets/media/logos/favicon.ico" />
        <style>
            .kt-section__title {
                font-size: 1.2rem!important;
            }
            .input-group {
                margin-bottom: 5px;
            }
        </style>
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
                                        <h3 class="kt-portlet__head-title">
                                            Modifica Conferenza:
                                        </h3>
                                    </div>
                                </div>
                                <div class="kt-portlet__body">
                                    <form id="kt_form" action="<%=request.getContextPath()%>/OperazioniCi?type=modifyCad" class="kt-form kt-form--label-right" accept-charset="ISO-8859-1" method="post">
                                        <input type="hidden" name="idCad" value="<%=cad.getId()%>">
                                        <div class="kt-portlet__body paddig_0_t paddig_0_b">
                                            <div class="kt-section kt-section--first">
                                                <div class="kt-section__body"><br>
                                                    <h5>Dati personali:</h5>
                                                    <div class="kt-separator kt-separator--border kt-separator--space-sm"></div>
                                                    <div class="row form-group">
                                                        <div class="col-lg-3 col-md-6">
                                                            <label>Nome</label><label class="kt-font-danger">*</label>
                                                            <input class="form-control obbligatory" name="nome" value="<%=cad.getNome()%>">
                                                        </div>
                                                        <div class="col-lg-3 col-md-6">
                                                            <label>Cognome</label><label class="kt-font-danger">*</label>
                                                            <input class="form-control obbligatory" name="cognome" value="<%=cad.getCognome()%>">
                                                        </div>
                                                        <div class="col-lg-3 col-md-6">
                                                            <label>Numero</label><label class="kt-font-danger">*</label>
                                                            <input class="form-control obbligatory" name="numero" onkeypress="return isNumber(event);" value="<%=cad.getNumero()%>">
                                                        </div>
                                                        <div class="col-lg-3 col-md-6">
                                                            <label>Email</label><label class="kt-font-danger">*</label>
                                                            <input class="form-control obbligatory" name="email" id="email" value="<%=cad.getEmail()%>">
                                                        </div>
                                                    </div>
                                                    <h5>Data e ora colloquio:</h5>
                                                    <div class="kt-separator kt-separator--border kt-separator--space-sm"></div>
                                                    <div class="row form-group">
                                                        <div class="col-lg-3 col-md-6">
                                                            <label>Data</label><label class="kt-font-danger">*</label>
                                                            <input type="text" class="form-control obbligatory" name="giorno" id="giorno"  autocomplete="off" readonly value="<%=sdf.format(cad.getGiorno())%>">
                                                        </div>
                                                        <div class="col-lg-3 col-md-6">
                                                            <label>ora di inizio e fine</label><label class="kt-font-danger">*</label>
                                                            <div class="input-group" >
                                                                <div class="col-6" style="padding-left: 0px; ">
                                                                    <input type="text" class="form-control time obbligatory" disabled name="start" id="start" value="<%=sdf_h.format(cad.getOrariostart())%>" autocomplete="off" readonly/>
                                                                </div>
                                                                <div class="col-6" style="padding-right: 0px;">
                                                                    <input type="text" class="form-control time obbligatory" disabled name="end" id="end" value="<%=sdf_h.format(cad.getOrarioend())%>" autocomplete="off" readonly/>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6">
                                                            <div id="impegni">
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <label class="kt-font-danger kt-font-bold"><font size="2" >* Campi Obbligatori</font></label>
                                                <div class="kt-portlet__foot">
                                                    <div class="kt-form__actions">
                                                        <div class="row">
                                                            <div class="offset-6 col-6 kt-align-right">
                                                                <a id="submit" href="javascript:void(0);" class="btn btn-io"><font color='white'>Salva</font></a>
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
            </div>
        </div>
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
        <script src="<%=src%>/assets/vendors/general/jquery-form/dist/jquery.form.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/demo/default/base/scripts.bundle.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/bundle/app.bundle.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/components/extended/blockui1.33.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/soop/js/utility.js<%="?dummy=" + String.valueOf(new Date().getTime())%>" type="text/javascript"></script>
        <!-- this page -->
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/bootstrap-timepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-timepicker/js/bootstrap-timepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-daterangepicker/daterangepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/js/bootstrap-datepicker.js" type="text/javascript"></script>
        <script id="createCad" src="<%=src%>/page/all/js/createCad.js<%="?dummy=" + String.valueOf(new Date().getTime())%>" data-context="<%=request.getContextPath()%>" type="text/javascript"></script>
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
            id =<%=cad.getId()%>;
        </script>
    </body>
</html>
<%
        }
    }
%>