<%-- 
    Document   : uploadDocumet
    Created on : 29-gen-2020, 12.39.45
    Author     : rcosco
--%>

<%@page import="rc.soop.util.Utility"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.stream.Collectors"%>
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
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            Entity e = new Entity();
            ProgettiFormativi p = e.getEm().find(ProgettiFormativi.class, Long.parseLong(request.getParameter("id")));
//            List<Allievi> allievi = p.getAllievi().stream().filter(a -> a.getStatopartecipazione().getId().equalsIgnoreCase("01")).collect(Collectors.toList());
            List<Allievi> allievi = new ArrayList<>();
//            List<Allievi> all = p.getAllievi();
            for (Allievi a : p.getAllievi()) {
                if (a.getStatopartecipazione().getId().equals("01")) {
                    allievi.add(a);
                }
            }

            double percentage = allievi.size() == 0 ? 0 : Math.round(allievi.size() * 100 / p.getAllievi().size());
            double percentage2 = percentage >= 80 ? 100 : Math.round(percentage / 80 * 100);

            e.close();
%>
<html>
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%> - CheckList 2</title>
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
        <link href="<%=src%>/assets/vendors/general/bootstrap-daterangepicker/daterangepicker.css" rel="stylesheet" type="text/css"/>
        <link href="<%=src%>/assets/vendors/general/select2/dist/css/select2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-select/dist/css/bootstrap-select.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-timepicker/css/bootstrap-timepicker.css" rel="stylesheet" type="text/css" />
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
                                                Compila Checklist 2 - Verifiche amministrative percorso
                                            </label>
                                        </p>
                                    </div>
                                </div>
                                <div class="kt-portlet__body">
                                    <form class="kt-form" id="kt_form" action="<%=request.getContextPath()%>/OperazioniMicro?type=compileCL2" style="padding-top: 0;"  accept-charset="ISO-8859-1"  method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="idprogetto" value="<%=p.getId()%>">
                                        <div class="row">

                                            <div class="col-lg-5">
                                                <div class="row col" style="color: #464457;">
                                                    <h5>Anagrafica percorso</h5>
                                                </div>
                                                <div class="form-group row">
                                                    <div class="col-lg-6">
                                                        <label>S.A. sottoposto a controllo</label>
                                                        <input class="form-control" type="text" readonly="" value="<%=p.getSoggetto().getRagionesociale()%>">
                                                    </div>
                                                    <div class="col-lg-6">
                                                        <label>Codice di protocollo</label>
                                                        <input class="form-control" type="text" readonly="" value="<%=p.getSoggetto().getProtocollo()%>">
                                                    </div>
                                                </div>
                                                <div class="form-group row">
                                                    <div class="col-lg-3">
                                                        <label>ID Piattaforma</label>
                                                        <input class="form-control" type="text" readonly="" value="<%=p.getId()%>" />
                                                    </div>
                                                    <div class="col-lg-3">
                                                        <label>CIP</label>
                                                        <input class="form-control" type="text" readonly="" value="<%=p.getCip()%>">
                                                    </div>
                                                    <div class="col-lg-6">
                                                        <label>Date avvio - chiusura</label>
                                                        <input type="text" class="form-control" readonly value="<%=sdf.format(p.getStart()) + " - " + sdf.format(p.getEnd())%>" >
                                                    </div>
                                                </div>
                                                <div class="form-group row">
                                                    <div class="col-lg-6">
                                                        <label>Allievi iscritti</label>
                                                        <input class="form-control" type="text" readonly value="<%=p.getAllievi().size()%>" name="allievi_start">
                                                    </div>
                                                    <div class="col-lg-6">
                                                        <label>Allievi che hanno terminato il corso</label>
                                                        <input class="form-control" type="text" readonly value="<%=allievi.size()%>" name="allievi_end">
                                                    </div>
                                                </div>
                                                <label>Percentuale di performance 1% di allievi che termina il percorso  <b class="kt-font-io"><%=percentage%>%</b> &nbsp; <b class="kt-font-danger"><%=percentage2%>%</b></label>
                                                <div class="form-group kt-align-left row customcheck">
                                                    <div class="col-10 kt-align-left"><b>Verifica validità corso</b><br>Il numero minimo di allievi previsto dall'avviso ha frequentato la FASE A per un numero di ore pari o superiore a 36?</div>
                                                    <div class="col-2 kt-align-right"><span class="kt-switch kt-switch--outline kt-switch--icon kt-switch--primary">
                                                            <label>
                                                                <input type="checkbox" name="check_valid" id="check_valid" checked>
                                                                <span></span>
                                                            </label>
                                                        </span>
                                                    </div>
                                                </div>
                                                <br>
                                                <div class="row col" style="color: #464457;">
                                                    <h5>Verifiche di sistema, presenza dei documenti amministrativi di percorso</h5>
                                                </div>
                                                <div class="form-group row customcheck">
                                                    <div class="col-2 kt-align-right"><span class="kt-switch kt-switch--outline kt-switch--icon kt-switch--primary">
                                                            <label>
                                                                <input type="checkbox" name="check_swot" id="check_swot" checked>
                                                                <span></span>
                                                            </label>
                                                        </span>
                                                    </div>
                                                    <div class="col-10 kt-align-left">Presenza Analisi Swot</div>
                                                </div>
                                                <div class="form-group row customcheck">
                                                    <div class="col-2 kt-align-right"><span class="kt-switch kt-switch--outline kt-switch--icon kt-switch--primary">
                                                            <label>
                                                                <input type="checkbox" name="check_m9_1" id="check_m9_1" checked>
                                                                <span></span>
                                                            </label>
                                                        </span>
                                                    </div>
                                                    <div class="col-10 kt-align-left">Presenza Modello 9 con i relativi allegati</div>
                                                </div>
                                                <div class="form-group row customcheck">
                                                    <div class="col-2 kt-align-right"><span class="kt-switch kt-switch--outline kt-switch--icon kt-switch--primary">
                                                            <label>
                                                                <input type="checkbox" name="check_cvdoc" id="check_cvdoc" checked>
                                                                <span></span>
                                                            </label>
                                                        </span>
                                                    </div>
                                                    <div class="col-10 kt-align-left">Presenza di tutti i CV dei docenti coinvolti nel percorso</div>
                                                </div>
                                                <div class="form-group row customcheck">
                                                    <div class="col-2 kt-align-right"><span class="kt-switch kt-switch--outline kt-switch--icon kt-switch--primary">
                                                            <label>
                                                                <input type="checkbox" name="check_regdoc" id="check_regdoc" checked>
                                                                <span></span>
                                                            </label>
                                                        </span>
                                                    </div>
                                                    <div class="col-10 kt-align-left">Registro presenza on-line del docente è stato alimentato secondo la tab.2 (allegata al Modello 9)?</div>
                                                </div>
                                                <div class="form-group row customcheck">
                                                    <div class="col-2 kt-align-right"><span class="kt-switch kt-switch--outline kt-switch--icon kt-switch--primary">
                                                            <label>
                                                                <input type="checkbox" name="check_chiuso" id="check_chiuso" checked>
                                                                <span></span>
                                                            </label>
                                                        </span>
                                                    </div>
                                                    <div class="col-10 kt-align-left">Stato del corso aggiornato da In Attuazione a Chiuso</div>
                                                </div>
                                                <div class="form-group row customcheck" >
                                                    <div class="col-2 kt-align-right"><span class="kt-switch kt-switch--outline kt-switch--icon kt-switch--primary">
                                                            <label>
                                                                <input type="checkbox" name="check_m13" id="check_m13" checked>
                                                                <span></span>
                                                            </label>
                                                        </span>
                                                    </div>
                                                    <div class="col-10 kt-align-left">Presenza Modello 13 (attestazione consegna materiale)</div>
                                                </div>
                                                <div class="form-group row">
                                                    <div class="col-lg-12">
                                                        <label>Specificare cosa è stato consegnato</label>
                                                        <input class="form-control obbligatory" type="text" name="m9_input" id="m9_input" >
                                                    </div>
                                                </div>
                                                <div class="form-group row" >
                                                    <div class="col-lg-12">
                                                        <label>Note: in caso di esito negativo, richiedere integrazioni via mail, riportando data di invio mail della richiesta nel presente box.</label>
                                                        <textarea class="form-control" name="note_esito" id="note_esito" rows="4" cols="50"></textarea>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-lg-1">
                                                <div class="center separator"> </div>
                                            </div>
                                            <div class="col-lg-6">
                                                <div class="row col" style="color: #464457;">
                                                    <h5>Verifiche amministrative extra-sistema</h5>
                                                </div>
                                                <div class="form-group row customcheck">
                                                    <div class="col-2 kt-align-right"><span class="kt-switch kt-switch--outline kt-switch--icon kt-switch--primary">
                                                            <label>
                                                                <input type="checkbox" name="check_m2" id="check_m2" checked>
                                                                <span></span>
                                                            </label>
                                                        </span>
                                                    </div>
                                                    <div class="col-10 kt-align-left">Presenza Modello 2 (richiesta di autorizzazione avvio)</div>
                                                </div>
                                                <div class="form-group row customcheck">
                                                    <div class="col-2 kt-align-right"><span class="kt-switch kt-switch--outline kt-switch--icon kt-switch--primary">
                                                            <label>
                                                                <input type="checkbox" name="check_m6_1" id="check_m6_1" checked>
                                                                <span></span>
                                                            </label>
                                                        </span>
                                                    </div>
                                                    <div class="col-10 kt-align-left">Modello 6 (comunicazione di avvio e calendari FASE A): è stato trasmesso prima dell'avvio della FASE A?</div>
                                                </div>
                                                <div class="form-group row customcheck">
                                                    <div class="col-2 kt-align-right"><span class="kt-switch kt-switch--outline kt-switch--icon kt-switch--primary">
                                                            <label>
                                                                <input type="checkbox" name="check_m6_2" id="check_m6_2" checked>
                                                                <span></span>
                                                            </label>
                                                        </span>
                                                    </div>
                                                    <div class="col-10 kt-align-left">Modello 6 (comunicazione di avvio e calendari FASE A): sono presenti tutti gli allegati obbligatori?</div>
                                                </div>
                                                <div class="form-group row customcheck">
                                                    <div class="col-2 kt-align-right"><span class="kt-switch kt-switch--outline kt-switch--icon kt-switch--primary">
                                                            <label>
                                                                <input type="checkbox" name="check_m7_1" id="check_m7_1" checked>
                                                                <span></span>
                                                            </label>
                                                        </span>
                                                    </div>
                                                    <div class="col-10 kt-align-left">Modello 7 (comunicazione calendari FASE B): è stato trasmesso prima dell'avvio della FASE B?</div>
                                                </div>
                                                <div class="form-group row customcheck ">
                                                    <div class="col-2 kt-align-right"><span class="kt-switch kt-switch--outline kt-switch--icon kt-switch--primary">
                                                            <label>
                                                                <input type="checkbox" name="check_m7_2" id="check_m7_2" checked>
                                                                <span></span>
                                                            </label>
                                                        </span>
                                                    </div>
                                                    <div class="col-10 kt-align-left">Modello 7 (comunicazione calendari FASE B): sono presenti tutti gli allegati obbligatori?</div>
                                                </div>
                                                <div class="form-group row customcheck">
                                                    <div class="col-2 kt-align-right"><span class="kt-switch kt-switch--outline kt-switch--icon kt-switch--primary">
                                                            <label>
                                                                <input type="checkbox" name="check_m9_2" id="check_m9_2" checked>
                                                                <span></span>
                                                            </label>
                                                        </span>
                                                    </div>
                                                    <div class="col-10 kt-align-left">Modello 9 (dichiarazione chiusura percorso in originale) è completo di tutti gli allegati obbligatori?  </div>
                                                </div>
                                                <div class="form-group row">
                                                    <div class="col-lg-12">
                                                        <label>Note</label>
                                                        <textarea class="form-control" id="note" name="note" rows="4" cols="50"></textarea>
                                                    </div>
                                                </div>
                                                <div class="row col" style="color: #464457;">
                                                    <h5>Verifiche di sistema documenti allievo</h5>
                                                </div>
                                                <div class="form-group">
                                                    <label>Lista allievi</label><label class='kt-font-danger kt-font-boldest'>*</label>
                                                    <div class="select-div" id="allievi_div">
                                                        <select class="form-control kt-select2 obbligatory" id="allievi" name="allievi[]" multiple="multiple">
                                                            <%for (Allievi a : allievi) {%>
                                                            <option selected value="<%=a.getId()%>"><%=a.getCognome()%> <%=a.getNome()%></option>
                                                            <%}%>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row" id="doc_allievi">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row separator"><hr></div>
                                        <div class="row" style="display: none;">
                                            <div class="col-lg-6">
                                                <label>Sigla Controllore  (<%=new SimpleDateFormat("dd/MM/yyyy").format(new Date())%>)</label>
                                                <input class="form-control col-lg-5" type="text" >
                                            </div>
                                        </div>
                                    </form>
                                    <div class="form-group">
                                        <div class="kt-form__actions">
                                            <a href="javascript:void(0);" class="btn btn-io" id="submit"><font color='white'><i class="fa fa-save"></i> Salva</font></a>
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
        <script src="<%=src%>/assets/vendors/general/inputmask/dist/inputmask/inputmask.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/inputmask/dist/inputmask/jquery.inputmask.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/input-mask.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/select2/dist/js/select2.full.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/select2.js" type="text/javascript"></script>
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
        <script>
            function ctrlForm() {
                var err = false;
                err = checkObblFields() ? true : err;
                return !err;
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
                                var message = json.message !== null ? "<h4>" + json.message + "</h4>" : "";
                                console.log(json);
//                                if (true) {
                                message += "<a href='<%=request.getContextPath()%>/OperazioniGeneral?type=downloadDoc&path=" + json.filedl + "' ><u><b>Clicca qui se il download non è iniziato.</b></u></a> ";//<i class='fa fa-cloud-download-alt'></i>
                                swalSuccessReload2("Checklist 2", message);
                                //dowbload automatico del file                                
                                var a = document.createElement('a');
                                a.href = "<%=request.getContextPath()%>/OperazioniGeneral?type=downloadDoc&path=" + json.filedl;
                                document.body.appendChild(a);
                                a.click();
                                a.remove();
                            } else {
                                swalError("Errore!", json.message);
                            }
                        }
                    });
                }

            });
            var allievi_old = [];
            $('#allievi').on("change", function () {
                docsAllievi();
            });
            $('#allievi').select2({//setta placeholder nella multiselect
                placeholder: "Seleziona Allievi"
            });
            jQuery(document).ready(function () {
                docsAllievi();
            });
            function docsAllievi() {
                var allievi = $('#allievi').val();
                var input = "<div id='docs_@id' class='col-lg-12 col-md-12'>"
                        + "<label><b>@nome</b></label>"
                        + "<div class='row customcheck'>"
                        + "<table style='width:100%;'>"
                        + "<thead>"
                        + "<tr style='font-size:13px;'>"
                        + "<th style='width:20%;font-weight:300;'>Modello 1</th>"
                        + "<th style='width:20%;font-weight:300;'>Modello 8</th>"
                        + "<th style='width:20%;font-weight:300;'>Selfiemployement</th>"
                        + "<th style='width:20%;font-weight:300;'>Piano di Impresa</th>"
                        + "<th style='width:20%;font-weight:300;'>Registro presenza</th>"
                        + "</tr>"
                        + "</thead>"
                        + "<tbody>"
                        + "<td><span class='kt-switch kt-switch--outline kt-switch--icon kt-switch--primary'><label><input type='checkbox' name='m1_@id' id='m1_@id' checked><span></span></label></span></td>"
                        + "<td><span class='kt-switch kt-switch--outline kt-switch--icon kt-switch--primary'><label><input type='checkbox' name='m8_@id' id='m8_@id' checked><span></span></label></span></td>"
                        + "<td><span class='kt-switch kt-switch--outline kt-switch--icon kt-switch--primary'><label><input type='checkbox' name='se_@id' id='se_@id' checked><span></span></label></span></td>"
                        + "<td><span class='kt-switch kt-switch--outline kt-switch--icon kt-switch--primary'><label><input type='checkbox' name='idim_@id' id='idim_@id' checked><span></span></label></span></td>"
                        + "<td><span class='kt-switch kt-switch--outline kt-switch--icon kt-switch--primary'><label><input type='checkbox' name='reg_@id' id='reg_@id' checked><span></span></label></span></td>"
                        + "</tbody>"
                        + "</table>"
                        + "</div>"
                        + "</div>";
                if (allievi.length > 0) {
                    if (allievi_old.length > 0) {
                        $.each(allievi_old, function (i, a) {
                            if (!allievi.includes(a)) {
                                $('#docs_' + a).remove();
                            }
                        });
                    }
                    $.each(allievi, function (i, a) {
                        if (!allievi_old.includes(a)) {
                            $('#doc_allievi').append(
                                    input.split("@id").join(a)
                                    .replace("@nome", $("#allievi option[value='" + a + "']").text()));
                        }
                    });
                    allievi_old = allievi;
                } else {
                    allievi_old = [];
                    $('#doc_allievi').empty();
                }
            }

        </script>
    </body>
</html>
<%}
    }%>