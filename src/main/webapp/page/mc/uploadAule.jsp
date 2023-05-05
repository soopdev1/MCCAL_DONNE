
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
            List<Item> regioni = e.listaRegioni();
            e.close();
            String src = session.getAttribute("src").toString();
%>
<html>
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%> - Sedi di Formazione</title>
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
        <link href="<%=src%>/assets/vendors/general/bootstrap-select/dist/css/bootstrap-select.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/select2/dist/css/select2.css" rel="stylesheet" type="text/css" />
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
        </style>
    </head>
    <body class="kt-header--fixed kt-header-mobile--fixed kt-subheader--fixed kt-subheader--enabled kt-subheader--solid kt-aside--enabled kt-aside--fixed">
        <%@ include file="menu/head1.jsp"%>
        <div class="kt-grid kt-grid--hor kt-grid--root">
            <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--ver kt-page">
                <%@ include file="menu/menu.jsp"%>
                <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor kt-wrapper" id="kt_wrapper">
                    <%@ include file="menu/head.jsp"%>
                    <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor">
                        <div class="kt-subheader   kt-grid__item" id="kt_subheader">
                            <div class="kt-subheader   kt-grid__item" id="kt_subheader">
                                <div class="kt-subheader__main">
                                    <h3 class="kt-subheader__title">Sedi di Formazione</h3>
                                    <span class="kt-subheader__separator kt-subheader__separator--v"></span>
                                    <a class="kt-subheader__breadcrumbs-link">Carica</a>
                                </div>
                            </div>
                        </div>
                        <div class="kt-content  kt-grid__item kt-grid__item--fluid" id="kt_content">
<!--                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="kt-portlet" id="kt_portlet" data-ktportlet="true">io-background
                                        <div class="kt-portlet__head">
                                            <div class="kt-portlet__head-label">
                                                <h3 class="kt-portlet__head-title" >
                                                    Carica File Aule :
                                                </h3>
                                            </div>
                                            <div class="kt-portlet__head-toolbar">
                                                <div class="kt-portlet__head-group">
                                                    <a href="#" data-ktportlet-tool="toggle" class="btn btn-sm btn-icon btn-clean btn-icon-md"><i class="la la-angle-down" id="toggle_search"></i></a>
                                                </div>
                                            </div>
                                        </div>
                                        <form id="kt_form_file" action="/OperazioniMicro?type=addAuleFile" class="kt-form kt-form--label-right" accept-charset="ISO-8859-1" method="post">
                                            <div class="kt-portlet__body paddig_0_t paddig_0_b">
                                                <div class="kt-section kt-section--first">
                                                    <div class="kt-section__body"><br>
                                                        <div class="form-group row">
                                                            <div class="col-xl-4 col-lg-6 col-md-8">
                                                                <div class="custom-file">
                                                                    <input type="file" tipo="obbligatory" class="custom-file-input" accept="application/vnd.ms-excel, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" name="file" id="file" onchange="return checkFileExtAndDim(['xls', 'xlsx']);">
                                                                    <label class="custom-file-label" id="label_file" style="text-align: left;">Scegli File</label>
                                                                </div>
                                                            </div>
                                                            <div class="col-lg-3">
                                                                <a href="javascript:void(0);" id="submit_file" class="btn btn-io">Carica</a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>-->
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="kt-portlet" id="kt_portlet" data-ktportlet="true"><!--io-background-->
                                        <div class="kt-portlet__head">
                                            <div class="kt-portlet__head-label">
                                                <h3 class="kt-portlet__head-title" >
                                                    Aggiungi Manualmente :
                                                </h3>
                                            </div>
                                            <div class="kt-portlet__head-toolbar">
                                                <div class="kt-portlet__head-group">
                                                    <a href="#" data-ktportlet-tool="toggle" class="btn btn-sm btn-icon btn-clean btn-icon-md"><i class="la la-angle-down" id="toggle_search"></i></a>
                                                </div>
                                            </div>
                                        </div>
                                        <form id="kt_form" action="<%=request.getContextPath()%>/OperazioniMicro?type=addAula" class="kt-form kt-form--label-right" accept-charset="ISO-8859-1" method="post">
                                            <div class="kt-portlet__body paddig_0_t paddig_0_b">
                                                <div class="kt-section kt-section--first">
                                                    <div class="kt-section__body"><br>
                                                        <div class="form-group row">
                                                            <div class="col-lg-4">
                                                                <label>Denominazione</label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                <input class="form-control obbligatory" name="denom" id="denom">
                                                            </div>
                                                        </div>
                                                        <div class="form-group row">
                                                            <div class="col-lg-4">
                                                                <label>Regione</label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                <div class="dropdown bootstrap-select form-control kt- " id="regione_div" style="padding: 0;">
                                                                    <select class="form-control kt-select2-general obbligatory" id="regione" name="regione"  style="width: 100%">
                                                                        <option value="-">Seleziona Regione</option>
                                                                        <%for (Item i : regioni) {%>
                                                                        <option value="<%=i.getValue()%>"><%=i.getDesc()%></option>
                                                                        <%}%>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="col-lg-4">
                                                                <label>Provincia</label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                <div class="dropdown bootstrap-select form-control kt-" id="provincia_div" style="padding: 0;">
                                                                    <select class="form-control kt-select2-general obbligatory" id="provincia" name="provincia"  style="width: 100%;">
                                                                        <option value="-">Seleziona Provincia</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="col-lg-4">
                                                                <label>Comune</label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                <div class="dropdown bootstrap-select form-control kt-" id="comune_div" style="padding: 0;">
                                                                    <select class="form-control kt-select2-general obbligatory" id="comune" name="comune"  style="width: 100%;">
                                                                        <option value="-">Seleziona Comune</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="form-group row">
                                                            <div class="col-lg-12">
                                                                <label>Indirizzo</label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                <input class="form-control obbligatory" name="via" id="via">
                                                            </div>
                                                        </div>
                                                        <div class="form-group row">
                                                            <div class="col-lg-4">
                                                                <label>Referente</label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                <input class="form-control obbligatory" name="referente" id="referente">
                                                            </div>
                                                        </div>
                                                        <div class="form-group row">
                                                            <div class="col-lg-4">
                                                                <label>Telefono</label>
                                                                <input class="form-control" name="phone" id="phone" onkeypress="return isNumber(event);">
                                                            </div>
                                                            <div class="col-lg-4">
                                                                <label>Cellullare</label>
                                                                <input class="form-control" name="cellulare" id="cellulare" onkeypress="return isNumber(event);">
                                                            </div>
                                                            <div class="col-lg-4">
                                                                <label>Email</label>
                                                                <input class="form-control" name="email" id="email">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <label class="kt-font-danger kt-font-bold"><font size="2" >* Campi Obbligatori</font></label>
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
                    <%@ include file="menu/footer.jsp"%>
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
        <script src="<%=src%>/assets/soop/js/utility.js" type="text/javascript"></script>
        <!-- this page -->
        <script src="<%=src%>/assets/vendors/general/bootstrap-select/dist/js/bootstrap-select.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/select2/dist/js/select2.full.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/select2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/js/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/dropzone/dist/dropzone.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/dropzone/dist/min/dropzone.min.js" type="text/javascript"></script>
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
            $('#regione').on('change', function (e) {
                $("#provincia").empty();
                $("#comune").empty();
                $("#comune").append('<option value="-">. . .</option>');
                if ($('#regione').val() != '-') {
                    startBlockUILoad("#provincia_div");
                    $("#provincia").append('<option value="-">Seleziona Provincia</option>');
                    $.get('<%=request.getContextPath()%>/Login?type=getProvincia&regione=' + $('#regione').val(), function (resp) {
                        var json = JSON.parse(resp);
                        for (var i = 0; i < json.length; i++) {
                            $("#provincia").append('<option value="' + json[i].value + '">' + json[i].desc + '</option>');
                        }
                        stopBlockUI("#provincia_div");
                    });
                } else {
                    $("#provincia").append('<option value="-">. . .</option>');
                }
            });
        </script>
        <script>
            $('#provincia').on('change', function (e) {
                $("#comune").empty();
                if ($('#provincia').val() != '-') {
                    startBlockUILoad("#comune_div");
                    $("#comune").append('<option value="-">Seleziona Comune</option>');
                    $.get('<%=request.getContextPath()%>/Login?type=getComune&provincia=' + $('#provincia').val(), function (resp) {
                        var json = JSON.parse(resp);
                        for (var i = 0; i < json.length; i++) {
                            $("#comune").append('<option value="' + json[i].value + '">' + json[i].desc + '</option>');
                        }
                        stopBlockUI("#comune_div");
                    });
                } else {
                    $("#comune").append('<option value="-">. . .</option>');
                }
            });
        </script>
        <script>
            function ctrlForm() {
                var err = false;
                err = checkObblFields() ? true : err;
                if ($('#email').val() != '') {
                    err = checkEmail($('#email')) ? true : err;
                }
                return err ? false : true;
            }
            $('#submit').on('click', function () {
                if (ctrlForm()) {
                    showLoad();
                    $('#kt_form').ajaxSubmit({
                        error: function () {
                            closeSwal();
                            swalError("Errore", "Riprovare, se l'errore persiste contattare l'assistenza");
                        },
                        success: function (resp) {
                            var json = JSON.parse(resp);
                            closeSwal();
                            if (json.result) {
                                resetInput();
                                swalSuccess("Sede di formazione aggiunta!", "Operazione effettuata con successo.");
                            } else {
                                swalError("Errore!", json.message);
                            }
                        }
                    });
                }
            });


            function ctrlFile() {
                var err = false;
                err = !checkRequiredFile() ? true : err;
                err = !checkFileExtAndDim(['xls', 'xlsx']) ? true : err;
                return err ? false : true;
            }

            $('#submit_file').on('click', function () {
                if (ctrlFile()) {
                    showLoad();
                    $('#kt_form_file').ajaxSubmit({
                        error: function () {
                            closeSwal();
                            swalError("Errore", "Riprovare, se l'errore persiste contattare l'assistenza");
                        },
                        success: function (resp) {
                            var json = JSON.parse(resp);
                            closeSwal();
                            if (json.result) {
                                $('.custom-file-input').val('');
                                $('.custom-file-input').removeClass('is-valid');
                                swalSuccess("Aula aggiunta!", "Operazione effettuata con successo.");
                            } else {
                                swalError("Errore!", json.message);
                            }
                        }
                    });
                }
            });
        </script>
    </body>
</html>
<%
        }
    }
%>