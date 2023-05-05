<%-- 
    Document   : uploadDocumet
    Created on : 29-gen-2020, 12.39.45
    Author     : rcosco
--%>

<%@page import="rc.soop.util.Utility"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="rc.soop.domain.Docenti"%>
<%@page import="rc.soop.db.Entity"%>
<%@page import="rc.soop.db.Action"%>
<%@page import="rc.soop.domain.User"%>
<%@page import="rc.soop.domain.FasceDocenti"%>
<%@page import="java.util.List"%>
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
            List<FasceDocenti> fasce = e.findAll(FasceDocenti.class);
            Docenti d = e.getEm().find(Docenti.class, Long.parseLong(request.getParameter("id")));
            e.close();
%>
<html>
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%> - Progetti Formativi</title>
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
        <!--this page-->
        <link href="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/css/bootstrap-datepicker3.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/select2/dist/css/select2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-select/dist/css/bootstrap-select.css" rel="stylesheet" type="text/css" />
        <!-- - -->
        <link href="<%=src%>/assets/vendors/general/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-touchspin/dist/jquery.bootstrap-touchspin.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.css" rel="stylesheet" type="text/css" />
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
                                        <h3 class="kt-portlet__head-title">
                                            Modifica Docente:
                                        </h3>
                                    </div>
                                </div>
                                <div class="kt-portlet__body">
                                    <form id="kt_form" action="<%=request.getContextPath()%>/OperazioniMicro?type=modifyDocente" class="kt-form kt-form--label-right" accept-charset="ISO-8859-1" method="post">
                                        <input  name="id" type="hidden" value="<%=d.getId()%>">
                                        <div class="kt-portlet__body paddig_0_t paddig_0_b">
                                            <div class="kt-section kt-section--first">
                                                <div class="kt-section__body"><br>
                                                    <div class="form-group row">
                                                        <div class="col-lg-3">
                                                            <label>Nome</label>
                                                            <input class="form-control obbligatory" name="nome" id="nome" value="<%=d.getNome()%>">
                                                        </div>
                                                        <div class="col-lg-3">
                                                            <label>Cognome</label>
                                                            <input class="form-control obbligatory" name="cognome" id="cognome" value="<%=d.getCognome()%>">
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <div class="col-lg-3">
                                                            <label>Codice Fiscale</label>
                                                            <input class="form-control obbligatory" name="cf" id="cf" value="<%=d.getCodicefiscale()%>">
                                                        </div>
                                                        <div class="col-lg-3">
                                                            <label>Data Nascita</label>
                                                            <input class="form-control dp obbligatory" name="data" id="data" autocomplete="off" value="<%=new SimpleDateFormat("dd/MM/yyyy").format(d.getDatanascita())%>" readonly>
                                                        </div>
                                                        <div class="col-lg-3">
                                                            <label>Fascia</label>
                                                            <div class="dropdown bootstrap-select form-control kt- paddig_0" id="fascia_div">
                                                                <select class="form-control kt-select2-general obbligatory" id="fascia" name="fascia">
                                                                    <option value="-">Seleziona Fascia</option>
                                                                    <%for (FasceDocenti f : fasce) {
                                                                            if (f.equals(d.getFascia())) {%>
                                                                    <option selected value="<%=f.getId()%>"><%=f.getDescrizione()%></option>
                                                                    <%} else {%>
                                                                    <option value="<%=f.getId()%>"><%=f.getDescrizione()%></option>
                                                                    <%}
                                                                        }%>
                                                                </select>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <div class="col-lg-3">
                                                            <label>Email</label>
                                                            <input class="form-control obbligatory" name="email" id="email" value="<%=d.getEmail() == null ? "" : d.getEmail()%>">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="kt-portlet__foot">
                                                    <div class="kt-form__actions">
                                                        <div class="row">
                                                            <div class="offset-lg-6 col-lg-6 kt-align-right">
                                                                <a id="submit" href="javascript:void(0);" class="btn btn-io"><font color='white'>Salva</font></a>
                                                                <a href="<%=pageName_%>" class="btn btn-io-n"><font color='white'>Reset</font></a>
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
        <script src="<%=src%>/assets/vendors/general/jquery/dist/jquery.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/popper.js/dist/umd/popper.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap/dist/js/bootstrap.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/js-cookie/src/js.cookie.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/moment/min/moment.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/tooltip.js/dist/umd/tooltip.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/perfect-scrollbar/dist/perfect-scrollbar.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/sticky-js/dist/sticky.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/demo/default/base/scripts.bundle.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/bundle/app.bundle.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/bundle/app.bundle.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/components/extended/blockui1.33.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/soop/js/utility.js<%="?dummy=" + String.valueOf(new Date().getTime())%>" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/jquery-form/dist/jquery.form.min.js" type="text/javascript"></script>
        <!--this page-->
        <script src="<%=src%>/assets/vendors/general/select2/dist/js/select2.full.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/select2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/js/bootstrap-datepicker.js" type="text/javascript"></script>
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
            function ctrlForm() {
                var err = false;
                err = checkObblFieldsContent($('#kt_form')) ? true : err;
                err = !checkCF($('#cf')) ? true : err;
                err = checkEmail($('#email')) ? true : err;
                return !err;
            }

            $('#submit').on('click', function () {
                submitForm($('#kt_form'), "Docente modificato!", "Operazione effettuata con successo.", ctrlForm(), false);
            });
        </script>
    </body>
</html>
<%}
    }%>