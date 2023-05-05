<%-- 
    Document   : profile
    Created on : 18-set-2019, 12.31.26
    Author     : rcosco
--%>
<%@page import="rc.soop.domain.NomiProgetto"%>
<%@page import="rc.soop.domain.StatiPrg"%>
<%@page import="rc.soop.domain.TipoDoc"%>
<%@page import="rc.soop.domain.Docenti"%>
<%@page import="java.util.ArrayList"%>
<%@page import="rc.soop.domain.SediFormazione"%>
<%@page import="rc.soop.domain.Allievi"%>
<%@page import="rc.soop.db.Action"%>
<%@page import="java.util.List"%>
<%@page import="rc.soop.db.Entity"%>
<%@page import="rc.soop.domain.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
            String src = session.getAttribute("src").toString();
            Entity e = new Entity();
            List<Allievi> alunni = e.getAllieviSoggettoNoPrg(us.getSoggettoAttuatore());
            List<SediFormazione> sedi = e.findAll(SediFormazione.class);
            List<NomiProgetto> nomi = e.findAll(NomiProgetto.class);
            List<Docenti> docente = e.getActiveDocenti();
            List<TipoDoc> tipo_doc = e.getTipoDoc(e.getEm().find(StatiPrg.class, "S"));
            sedi = sedi == null ? new ArrayList() : sedi;
            int n_allievi = Integer.parseInt(e.getPath("min_allievi"));
            int max_allievi = Integer.parseInt(e.getPath("max_alunni"));
            e.close();
            boolean fancy = request.getParameter("fb") != null && request.getParameter("fb").equals("1") ? false : true;
%>
<html>
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%> - Progetti Formativi</title>
        <meta name="description" content="Updates and statistics">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <!--begin::Fonts -->
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
        <link href="<%=src%>/assets/app/custom/wizard/wizard-v1_io.css" rel="stylesheet" type="text/css"/>
        <link href="<%=src%>/assets/vendors/general/select2/dist/css/select2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-select/dist/css/bootstrap-select.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/css/bootstrap-datepicker3.css" rel="stylesheet" type="text/css" />

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

        <style type="text/css">
            .form-group {
                margin-bottom: 1rem;
            }

            .custom-file-label::after {
                color:#fff;
                background-color: #eaa21c;
            }
            .offset-sm-1{
                margin-left: 5%;
            }
        </style>
    </head>
    <body class="kt-header--fixed kt-header-mobile--fixed kt-subheader--fixed kt-subheader--enabled kt-subheader--solid kt-aside--enabled kt-aside--fixed">
        <!-- begin:: Page -->
        <%if (fancy) {%>
        <%@ include file="menu/head1.jsp"%>
        <div class="kt-grid kt-grid--hor kt-grid--root">
            <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--ver kt-page">
                <%@ include file="menu/menu.jsp"%>
                <!-- end:: Aside -->
                <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor kt-wrapper" id="kt_wrapper">
                    <%@ include file="menu/head.jsp"%>
                    <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor">
                        <div class="kt-subheader   kt-grid__item" id="kt_subheader">
                            <div class="kt-subheader   kt-grid__item" id="kt_subheader">
                                <div class="kt-subheader__main">
                                    <h3 class="kt-subheader__title">Progetti Formativi</h3>
                                    <span class="kt-subheader__separator kt-subheader__separator--v"></span>
                                    <a class="kt-subheader__breadcrumbs-link">Aggiungi</a>
                                </div>
                            </div>
                        </div>
                        <%} else {%>
                        <div class="kt-grid kt-grid--hor kt-grid--root">
                            <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--ver kt-page">
                                <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor">
                                    <%}%>
                                    <!-- end:: Content Head -->
                                    <!-- begin:: Content -->
                                    <div class="kt-content  kt-grid__item kt-grid__item--fluid" id="kt_content">
                                        <div class="row" style="height: 100%;">
                                            <div class="kt-grid  kt-wizard-v1 kt-wizard-v1--white" id="kt_wizard_v1" data-ktwizard-state="step-first" style="width: 100%;">
                                                <div class="kt-grid__item" style="">
                                                    <!--begin: Form Wizard Nav -->
                                                    <div class="kt-wizard-v1__nav">
                                                        <div class="kt-wizard-v1__nav-items" style="background: #fff; border-top-left-radius: 10px; border-top-right-radius: 10px;">
                                                            <a class="kt-wizard-v1__nav-item" href="#" data-ktwizard-type="step" data-ktwizard-state="current">
                                                                <div class="kt-wizard-v1__nav-body " >
                                                                    <div class="kt-wizard-v1__nav-icon">
                                                                        <i class="fa fa-pencil-alt" ></i>
                                                                    </div>
                                                                    <div class="kt-wizard-v1__nav-label">
                                                                        1 - Informazioni generali
                                                                    </div>
                                                                </div>
                                                            </a>
                                                            <a class="kt-wizard-v1__nav-item" href="#" data-ktwizard-type="step">
                                                                <div class="kt-wizard-v1__nav-body">
                                                                    <div class="kt-wizard-v1__nav-icon">
                                                                        <i class="flaticon-presentation-1"></i>
                                                                    </div>
                                                                    <div class="kt-wizard-v1__nav-label">
                                                                        2 - Aula e Allievi
                                                                    </div>
                                                                </div>
                                                            </a>
                                                            <a class="kt-wizard-v1__nav-item" href="#" data-ktwizard-type="step">
                                                                <div class="kt-wizard-v1__nav-body">
                                                                    <div class="kt-wizard-v1__nav-icon">
                                                                        <i class="fa fa-chalkboard-teacher"></i>
                                                                    </div>
                                                                    <div class="kt-wizard-v1__nav-label">
                                                                        3 - Docente
                                                                    </div>
                                                                </div>
                                                            </a>						
                                                            <a class="kt-wizard-v1__nav-item" href="#" data-ktwizard-type="step">
                                                                <div class="kt-wizard-v1__nav-body">
                                                                    <div class="kt-wizard-v1__nav-icon">
                                                                        <i class="fa fa-file-pdf"></i>
                                                                    </div>
                                                                    <div class="kt-wizard-v1__nav-label">
                                                                        4 - Documenti
                                                                    </div>
                                                                </div>
                                                            </a>						
                                                            <a class="kt-wizard-v1__nav-item" href="#" data-ktwizard-type="step">
                                                                <div class="kt-wizard-v1__nav-body">
                                                                    <div class="kt-wizard-v1__nav-icon">
                                                                        <i class="fa fa-list"></i>
                                                                    </div>
                                                                    <div class="kt-wizard-v1__nav-label">
                                                                        5 - Riepilogo
                                                                    </div>
                                                                </div>
                                                            </a>						
                                                        </div>
                                                    </div>
                                                </div>
                                                <!--end: Form Wizard Nav -->
                                                <div class="kt-grid__item kt-grid__item--fluid kt-wizard-v1__wrapper">
                                                    <form id="kt_form" action="<%=request.getContextPath()%>/OperazioniSA?type=newProgettoFormativo" style="padding: 0;" class="kt-form kt-form--label-right" accept-charset="ISO-8859-1" method="post">
                                                        <!--step: 1-->
                                                        <div class="kt-wizard-v1__content" id="step1" data-ktwizard-type="step-content" data-ktwizard-state="current">
                                                            <div class="kt-form__section kt-form__section--first">
                                                                <div class="kt-wizard-v1__form" style="color: #6c7293; min-height: 40vh">
                                                                    <div class="form-group row">
                                                                        <div class="col-lg-12">
                                                                            <label>Nome</label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <div class="dropdown bootstrap-select form-control kt- paddig_0" id="nome_pf_div">
                                                                                <select class="form-control kt-select2-general obbligatory" id="nome_pf" name="nome_pf">
                                                                                    <option value="-">Seleziona Nome</option>
                                                                                    <%for (NomiProgetto s : nomi) {%>
                                                                                    <option value="<%=s.getId()%>"><%=s.getDescrizione()%></option>
                                                                                    <%}%>
                                                                                </select>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-group">
                                                                        <label>Descrizione</label>
                                                                        <textarea class="form-control" id="descrizione_pf" name="descrizione_pf" placeholder="Descrizione Progetto Formativo" rows="5"></textarea>
                                                                    </div>
                                                                    <div class="form-group">
                                                                        <label>Progetto Formativo Misto</label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <div class="dropdown bootstrap-select form-control kt- paddig_0" id="misto_div">
                                                                            <select class="form-control kt-select2-general obbligatory" id="misto" name="misto">
                                                                                <option value="NO">NO</option>
                                                                                <option value="SI">SI</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>

                                                                    <div class="form-group row">
                                                                        <div class="col-lg-12">
                                                                            <label>Date Inizio - Fine </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <input type="text" class="form-control obbligatory" name="date" id="kt_daterange" value="" placeholder="Date Inizio e Fine" readonly autocomplete="off">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <label class="kt-font-danger kt-font-bold"><font size="2" >* Campi Obbligatori</font></label>
                                                        </div>
                                                        <!--step: 2-->
                                                        <div class="kt-wizard-v1__content" id="step2" data-ktwizard-type="step-content">
                                                            <div class="kt-form__section kt-form__section--first">
                                                                <div class="kt-wizard-v1__form" style="color: #6c7293;">
                                                                    <div class="kt-scroll col-12 center" data-scroll="true" style="min-height: 40vh">
                                                                        <div class="form-group">
                                                                            <label>Sede di Formazione</label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <div class="dropdown bootstrap-select form-control kt-" id="sede_div" style="padding: 0;">
                                                                                <select class="form-control kt-select2-general obbligatory" id="sede" name="sede"  style="width: 100%">
                                                                                    <option value="-">Seleziona Sede</option>
                                                                                    <%for (SediFormazione s : sedi) {%>
                                                                                    <option value="<%=s.getId()%>"><%=s.getDenominazione()%> (<%=s.getIndirizzo()%> - <%=s.getComune().getNome()%>)</option>
                                                                                    <%}%>
                                                                                </select>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <label>Allievi</label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <div class="select-div" id="allievi_div">
                                                                                <select class="form-control kt-select2 obbligatory" id="allievi" name="allievi[]" multiple="multiple" style="width: 100%">
                                                                                    <%for (Allievi a : alunni) {%>
                                                                                    <option value="<%=a.getId()%>"><%=a.getCognome()%> <%=a.getNome()%> (<%=a.getCodicefiscale()%>)</option>
                                                                                    <%}%>
                                                                                </select>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group row" id="knowlege_channel">

                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--step: 3-->
                                                        <div class="kt-wizard-v1__content" id="step3" data-ktwizard-type="step-content">
                                                            <div class="kt-form__section kt-form__section--first">
                                                                <div class="kt-wizard-v1__form" style="color: #6c7293;">
                                                                    <div class="kt-scroll col-12 center" data-scroll="true" style="min-height: 40vh">
                                                                        <div class="form-group">
                                                                            <label>Docenti</label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <div class="dropdown bootstrap-select form-control kt-" id="docenti_div" style="padding: 0;">
                                                                                <select class="form-control kt-select2 obbligatory" id="docenti" name="docenti[]" multiple="multiple" style="width: 100%">
                                                                                    <%for (Docenti d : docente) {%>
                                                                                    <option value="<%=d.getId()%>"><%=d.getCognome()%> <%=d.getNome()%></option>
                                                                                    <%}%>
                                                                                </select>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group row" id="teacher_doc">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <label class="kt-font-danger kt-font-boldest">&Egrave; possibile aggiornare i documenti dei docenti da: Progetti Formativi - Cerca - Azioni - Modifica/Carica Doc. </label>
                                                        </div>
                                                        <!--step: 4-->
                                                        <div class="kt-wizard-v1__content" id="step4" data-ktwizard-type="step-content">
                                                            <div class="kt-form__section kt-form__section--first">
                                                                <div class="kt-wizard-v1__form" style="color: #6c7293;">
                                                                    <div class="form-group col">
                                                                        <div class="row">
                                                                            <%for (TipoDoc t : tipo_doc) {%>
                                                                            <div class="form-group col-xl-4 col-lg-6">
                                                                                <label><%=t.getDescrizione()%></label><%=t.getObbligatorio() == 1 ? "<label class='kt-font-danger kt-font-boldest'>*</label>" : ""%>
                                                                                <div class="custom-file">
                                                                                    <input type="file" <%=t.getObbligatorio() == 1 ? "tipo='obbligatory'" : ""%> class="custom-file-input" accept="application/pdf" name="doc_<%=t.getId()%>" onchange="return checkFileExtAndDim(['pdf']);">
                                                                                    <label class="custom-file-label selected" style="color: #a7abc3; text-align: left;">Scegli File</label>
                                                                                </div>
                                                                            </div>
                                                                            <%}%>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--step: 5-->
                                                        <div class="kt-wizard-v1__content" id="step5" data-ktwizard-type="step-content">
                                                            <div class="kt-form__section kt-form__section--first">
                                                                <div class="kt-wizard-v1__form" style="color: #6c7293;">
                                                                    <h4>Informazioni Generali</h4>
                                                                    <div class="kt-separator kt-separator--border kt-separator--space-xs"></div>
                                                                    <div class="form-group">
                                                                        <div class="offset-sm-1">
                                                                            <div class="row">
                                                                                <h5>Nome Progetto:&nbsp;</h5><label id="label_titolo" style="color:#000;"></label>
                                                                            </div>
                                                                            <div class="row">
                                                                                <h5>Descrizione:&nbsp;</h5><label id="label_descrizione" style="color:#000;"></label>
                                                                            </div>
                                                                            <div class="row">
                                                                                <h5>Progetto Formativo Misto:&nbsp;</h5><label id="label_misto" style="color:#000;"></label>
                                                                            </div>
                                                                            <div class="row">
                                                                                <h5>Date inizio e fine:&nbsp;</h5><label id="label_date" style="color:#000;"></label>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <h4>Aula e Allievi</h4>
                                                                    <div class="kt-separator kt-separator--border kt-separator--space-xs"></div>
                                                                    <div class="form-group">
                                                                        <div class="offset-sm-1">
                                                                            <div class="row">
                                                                                <h5>Aula:&nbsp;</h5><label id="label_aula" style="color:#000;"></label>
                                                                            </div>
                                                                            <div class="row">
                                                                                <h5>Allievi:&nbsp;</h5><label id="label_alunni" style="color:#000;"></label>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <h4>Docenti</h4>
                                                                    <div class="kt-separator kt-separator--border kt-separator--space-xs"></div>
                                                                    <div class="form-group">
                                                                        <div class="offset-sm-1">
                                                                            <div class="row">
                                                                                <label id="label_docenti" style="color:#000;"></label>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="kt-form__actions">
                                                            <div class="btn btn-io-n btn-md btn-tall btn-wide kt-font-bold kt-font-transform-u" data-ktwizard-type="action-prev">
                                                                Indietro
                                                            </div>
                                                            <div class="btn btn-io btn-md btn-tall btn-wide kt-font-bold kt-font-transform-u" data-ktwizard-type="action-submit">
                                                                Salva
                                                            </div>
                                                            <div id="go_next" class="btn btn-io btn-md btn-tall btn-wide kt-font-bold kt-font-transform-u" data-ktwizard-type="action-next">
                                                                Avanti
                                                            </div>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>                        
                                    </div>
                                </div>
                                <%if (fancy) {%>
                                <%@ include file="menu/footer.jsp"%>
                                <%}%>
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
        <script src="<%=src%>/assets/soop/js/utility.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/jquery-form/dist/jquery.form.min.js" type="text/javascript"></script>
        <!--this page-->
        <script src="<%=src%>/assets/vendors/general/select2/dist/js/select2.full.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/select2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/bootstrap-daterangepicker.js" type="text/javascript"></script><!--usa questo per modificare daterangepicker-->
        <script src="<%=src%>/assets/vendors/general/bootstrap-daterangepicker/daterangepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/wizard/wizard-progetto.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/js/bootstrap-datepicker.js" type="text/javascript"></script>

        <script id="docenti_allievi" src="<%=src%>/page/sa/js/docenti_allievi.js<%="?dummy=" + String.valueOf(new Date().getTime())%>" data-context="<%=request.getContextPath()%>" type="text/javascript"></script>
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
            jQuery(document).ready(function () {

            });

            min_allievi = <%=n_allievi%>;
            max_allievi = <%=max_allievi%>;

            <%for (Docenti d : docente) {%>
            doc_docenti.set('<%=d.getId()%>', {"docid": "<%=d.getDocId()%>", "curriculum": "<%=d.getCurriculum()%>", "scadenza": new Date(<%=d.getScadenza_doc() == null ? "0" : d.getScadenza_doc().getTime()%>)});
            <%}%>

            $("#nome_pf").change(function (e) {
                $("#label_titolo").html("<b>" + $(this).val() + "</b>");
            });
            $("#descrizione_pf").change(function (e) {
                $("#label_descrizione").html("<b>" + $(this).val() + "</b>");
            });
            $("#misto").change(function (e) {
                $("#label_misto").html("<b>" + $(this).val() + "</b>");
            });
            $("#kt_daterange").change(function (e) {
                $("#label_date").html("<b>" + $(this).val() + "</b>");
            });
            $("#sede").change(function (e) {
                $("#label_aula").html("<b>" + $("#" + this.id + " option[value='" + $(this).val() + "']").text() + "</b>");
            });
            $("#allievi").change(function (e) {
                var allievi = "";
                $.each($('#allievi').val(), function (i, a) {
                    allievi = allievi + $("#allievi option[value='" + a + "']").text() + "; ";
                });
                $("#label_alunni").html("<b>" + allievi + "</b>");
            });
            $("#docenti").change(function (e) {
                var docenti = "";
                $.each($('#docenti').val(), function (i, a) {
                    docenti = docenti + $("#docenti option[value='" + a + "']").text() + "; ";
                });
                $("#label_docenti").html("<b>" + docenti + "</b>");
            });
        </script>
    </body>
</html>
<%}
    }%>
