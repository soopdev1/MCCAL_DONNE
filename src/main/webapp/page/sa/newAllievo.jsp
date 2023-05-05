<%-- 
    Document   : profile
    Created on : 18-set-2019, 12.31.26
    Author     : rcosco
--%>
<%@page import="rc.soop.domain.Condizione_Lavorativa"%>
<%@page import="rc.soop.domain.StatiPrg"%>
<%@page import="rc.soop.domain.TipoDoc_Allievi"%>
<%@page import="rc.soop.domain.Condizione_Mercato"%>
<%@page import="rc.soop.domain.Comuni"%>
<%@page import="rc.soop.domain.CPI"%>
<%@page import="rc.soop.db.Action"%>
<%@page import="rc.soop.domain.TitoliStudio"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="rc.soop.db.Entity"%>
<%@page import="rc.soop.entity.Item"%>
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
            List<Comuni> cittadinanza = e.listaCittadinanza();
            List<Item> regioni = e.listaRegioni();
            List<TitoliStudio> ts = e.listaTitoliStudio();
            List<CPI> cpi = e.listaCPI();
            List<Condizione_Mercato> condizione = e.findAll(Condizione_Mercato.class);
            List<Condizione_Lavorativa> condlavprec = e.findAll(Condizione_Lavorativa.class);
            List<TipoDoc_Allievi> tipo_doc = e.getTipoDocAllievi(e.getEm().find(StatiPrg.class, "S"));
            e.close();
            boolean fancy = request.getParameter("fb") != null && request.getParameter("fb").equals("1") ? false : true;
%>
<html>
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%> - Allievi</title>
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
        <link href="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/css/bootstrap-datepicker3.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/select2/dist/css/select2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-select/dist/css/bootstrap-select.css" rel="stylesheet" type="text/css" />
        <!-- - -->
        <link href="<%=src%>/assets/vendors/general/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/owl.carousel/dist/assets/owl.carousel.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/owl.carousel/dist/assets/owl.theme.default.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/line-awesome/css/line-awesome.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/flaticon/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/flaticon2/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/fontawesome5/css/all.min.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/resource/animate.css" rel="stylesheet" type="text/css"/>
        <link href="<%=src%>/assets/demo/default/skins/header/base/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/brand/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/aside/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/base/style.bundle.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/resource/custom.css" rel="stylesheet" type="text/css" />

        <link rel="shortcut icon" href="<%=src%>/assets/media/logos/favicon.ico" />
        <style type="text/css">
            .form-group {
                margin-bottom: 1rem;
            }

            .custom-file-label::after {
                color:#fff;
                background-color: #eaa21c;
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
                                    <h3 class="kt-subheader__title">Allievi</h3>
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
                                    <div class="kt-content  kt-grid__item kt-grid__item--fluid" id="kt_content">
                                        <div class="kt-portlet kt-portlet--mobile">
                                            <form class="kt-form" id="kt_form" action="<%=request.getContextPath()%>/OperazioniSA?type=newAllievo" style="padding-top: 0;"  method="post" enctype="multipart/form-data">
                                                <div class="kt-portlet__head" style="display: none;">
                                                    <div class="kt-portlet__head-label">
                                                        <h3 class="kt-portlet__head-title">
                                                            Aggiungi:
                                                        </h3>
                                                    </div>
                                                </div>
                                                <div class="kt-portlet__body">
                                                    <div class="kt-section kt-section--space-md">
                                                        <div class="form-group form-group-sm row">
                                                            <div class="col-12">
                                                                <h5>Anagrafica</h5>
                                                                <div class="kt-separator kt-separator--border kt-separator--space-xs"></div>
                                                                <div class="form-row">
                                                                    <div class="form-group col-xl-3 col-lg-6">
                                                                        <label>Nome </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input type="text" class="form-control obbligatory" id="nome" name="nome" />
                                                                    </div>
                                                                    <div class="form-group col-xl-3 col-lg-6">
                                                                        <label>Cognome </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input type="text" class="form-control obbligatory" id="cognome" name="cognome" />
                                                                    </div>
                                                                    <div class="form-group col-xl-3 col-lg-6">
                                                                        <label>Codice fiscale </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input class="form-control obbligatory" type="text" name="codicefiscale" id="codicefiscale" />
                                                                    </div>
                                                                    <div class="form-group col-xl-3 col-lg-6">
                                                                        <label>Stato di nascita </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <div class="dropdown bootstrap-select form-control kt-" id="stato_div" style="padding: 0;">
                                                                            <select class="form-control kt-select2-general obbligatory" id="stato" name="stato"  style="width: 100%">
                                                                                <option value="-">Seleziona Stato</option>
                                                                                <%for (Comuni c : cittadinanza) {%>
                                                                                    <option value="<%=c.getIstat()%>" data-cf="<%=c.getCodicicatastali_altri()%>"><%=c.getNome()%></option>
                                                                                <%}%>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="form-row">
                                                                    <div class="form-group col-xl-3 col-lg-6">
                                                                        <label>Data di nascita </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input type="text" class="form-control obbligatory dateBorth" name="datanascita" id="datanascita" autocomplete="off" readonly/>
                                                                    </div>
                                                                    <div class="form-group col-xl-3 col-lg-6">
                                                                        <label>Regione di nascita </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <div class="dropdown bootstrap-select form-control kt-" id="regionenascita_div" style="padding: 0;">
                                                                            <select class="form-control kt-select2-general obbligatory" id="regionenascita" name="regionenascita"  style="width: 100%">
                                                                                <option value="-">Seleziona Regione</option>
                                                                                <%for (Item i : regioni) {%>
                                                                                <option value="<%=i.getValue()%>"><%=i.getDesc()%></option>
                                                                                <%}%>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-group col-xl-3 col-lg-6">
                                                                        <label>Provincia di nascita </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <div class="dropdown bootstrap-select form-control kt-" id="provincianascita_div" style="padding: 0;">
                                                                            <select class="form-control kt-select2-general obbligatory" id="provincianascita" name="provincianascita"  style="width: 100%;">
                                                                                <option value="-">Seleziona Provincia</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-group col-xl-3 col-lg-6">
                                                                        <label>Comune di nascita </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <div class="dropdown bootstrap-select form-control kt-" id="comunenascita_div" style="padding: 0;">
                                                                            <select class="form-control kt-select2-general obbligatory" id="comunenascita" name="comunenascita"  style="width: 100%;">
                                                                                <option value="-">Seleziona Comune</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="form-row" id="msgrow" style="display:block">
                                                                        <label id="msg_cf"></label>
                                                                </div>
                                                                <div class="form-row">
                                                                    <div class="form-group col-xl-3 col-lg-6">
                                                                        <label>Telefono </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input type="text" class="form-control obbligatory" id="telefono" name="telefono" onkeypress="return isNumber(event);" />
                                                                    </div>
                                                                    <div class="form-group col-xl-3 col-lg-6">
                                                                        <label>Documento di identità </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <div class="custom-file">
                                                                            <input type="file" tipo="obbligatory" class="custom-file-input" accept="application/pdf" name="docid" id="docid" onchange="return checkFileExtAndDim(['pdf']);">
                                                                            <label class="custom-file-label selected" id='label_file'>Scegli File</label>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-group col-xl-3 col-lg-6">
                                                                        <label>Data scadenza documento</label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input type="text" class="form-control obbligatory" name="scadenzadoc" id="kt_datepicker_4_3" autocomplete="off" readonly/>
                                                                    </div>
                                                                    <div class="form-group col-xl-3 col-lg-6">
                                                                        <label>Cittadinanza </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <div class="dropdown bootstrap-select form-control kt-" id="cittadinanza_div" style="padding: 0;">
                                                                            <select class="form-control kt-select2-general obbligatory" id="cittadinanza" name="cittadinanza"  style="width: 100%">
                                                                                <option value="-">Seleziona Cittadinanza</option>
                                                                                <%for (Comuni c : cittadinanza) {%>
                                                                                <option value="<%=c.getIstat()%>"><%=c.getNome()%></option>
                                                                                <%}%>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                </div>  
                                                                <h5>Residenza</h5>
                                                                <div class="kt-separator kt-separator--border kt-separator--space-xs"></div>
                                                                <div class="form-row">
                                                                    <div class="form-group col-xl-4 col-lg-6">
                                                                        <label>Indirizzo </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input type="text" class="form-control obbligatory" id="indirizzores" name="indirizzores" />
                                                                    </div>
                                                                    <div class="form-group col-xl-2 col-lg-6">
                                                                        <label>Civico </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input type="text" class="form-control obbligatory" id="civicores" name="civicores" />
                                                                    </div>
                                                                    <div class="form-group col-xl-2 col-lg-6">
                                                                        <label>CAP </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input type="text" class="form-control obbligatory" id="capres" name="capres"  onkeypress="return isNumber(event);"/>
                                                                    </div>
                                                                    <div class="form-group col-xl-4 col-lg-6 kt-align-right">
                                                                        <label>La residenza coincide con il domicilio?</label>
                                                                        <div class="form-group kt-align-right" style="margin-bottom: 0rem;">
                                                                            <span class="kt-switch kt-switch--outline kt-switch--icon kt-switch--primary" style="">
                                                                                <label>
                                                                                    <input type="checkbox" name="checkind" id="checkind" onchange="return domicilio();">
                                                                                    <span></span>
                                                                                </label>
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="form-row">
                                                                    <div class="form-group col-lg-4">
                                                                        <label>Regione di residenza </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <div class="dropdown bootstrap-select form-control kt-" id="regioneres_div" style="padding: 0;">
                                                                            <select class="form-control kt-select2-general obbligatory" id="regioneres" name="regioneres"  style="width: 100%">
                                                                                <option value="-">Seleziona Regione</option>
                                                                                <%for (Item i : regioni) {%>
                                                                                <option value="<%=i.getValue()%>"><%=i.getDesc()%></option>
                                                                                <%}%>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-group col-lg-4">
                                                                        <label>Provincia di residenza </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <div class="dropdown bootstrap-select form-control kt-" id="provinciares_div" style="padding: 0;">
                                                                            <select class="form-control kt-select2-general obbligatory" id="provinciares" name="provinciares"  style="width: 100%;">
                                                                                <option value="-">Seleziona Provincia</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-group col-lg-4">
                                                                        <label>Comune di residenza </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <div class="dropdown bootstrap-select form-control kt-" id="comuneres_div" style="padding: 0;">
                                                                            <select class="form-control kt-select2-general obbligatory" id="comuneres" name="comuneres"  style="width: 100%;">
                                                                                <option value="-">Seleziona Comune</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <h5>Domicilio <label class="kt-font-danger kt-font-boldest" style="display:none;" id="msgdom">Il domicilio corrisponde con la residenza</label></h5>
                                                                <div class="kt-separator kt-separator--border kt-separator--space-xs"></div>
                                                                <div class="form-row">
                                                                    <div class="form-group col-xl-4 col-lg-6">
                                                                        <label>Indirizzo </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input type="text" class="form-control" id="indirizzodom" name="indirizzodom" />
                                                                    </div>
                                                                    <div class="form-group col-xl-2 col-lg-6">
                                                                        <label>Civico </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input type="text" class="form-control" id="civicodom" name="civicodom" />
                                                                    </div>
                                                                    <div class="form-group col-xl-2 col-lg-6">
                                                                        <label>CAP </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input type="text" class="form-control" id="capdom" name="capdom"  onkeypress="return isNumber(event);"/>
                                                                    </div>
                                                                </div>
                                                                <div class="form-row">
                                                                    <div class="form-group col-lg-4">
                                                                        <label>Regione di domicilio </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <div class="dropdown bootstrap-select form-control kt-" id="regionedom_div" style="padding: 0;">
                                                                            <select class="form-control kt-select2-general" id="regionedom" name="regionedom"  style="width: 100%">
                                                                                <option value="-">Seleziona Regione</option>
                                                                                <%for (Item i : regioni) {%>
                                                                                <option value="<%=i.getValue()%>"><%=i.getDesc()%></option>
                                                                                <%}%>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-group col-lg-4">
                                                                        <label>Provincia di domicilio </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <div class="dropdown bootstrap-select form-control kt-" id="provinciadom_div" style="padding: 0;">
                                                                            <select  class="form-control kt-select2-general" id="provinciadom" name="provinciadom"  style="width: 100%;">
                                                                                <option value="-">Seleziona Provincia</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-group col-lg-4">
                                                                        <label>Comune di domicilio </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <div class="dropdown bootstrap-select form-control kt-" id="comunedom_div" style="padding: 0;">
                                                                            <select class="form-control kt-select2-general" id="comunedom" name="comunedom"  style="width: 100%;">
                                                                                <option value="-">Seleziona Comune</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <br>
                                                                <h5>Documentazione</h5> 
                                                                <div class="kt-separator kt-separator--border kt-separator--space-xs"></div>
                                                                <div class="form-row">
                                                                    <div class="form-group col-xl-4 col-lg-6">
                                                                        <label>Titolo di studio </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <div class="dropdown bootstrap-select form-control kt-" id="titolo_studio_div" style="padding: 0;">
                                                                            <select class="form-control kt-select2-general obbligatory" id="titolo_studio" name="titolo_studio"  style="width: 100%">
                                                                                <option value="-">Seleziona titolo di studio</option>
                                                                                <%for (TitoliStudio t : ts) {%>
                                                                                <option value="<%=t.getCodice()%>"><%=t.getDescrizione()%></option>
                                                                                <%}%>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-group col-xl-4 col-lg-6">
                                                                        <label>Condizione lavorativa precedente </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <!--29-04-2020 MODIFICA - CONDIZIONE LAVORATIVA PRECEDENTE-->
                                                                        <!--<input type="text" class="form-control obbligatory" id="neet" name="neet" />-->
                                                                        <div class="dropdown bootstrap-select form-control kt-" id="condizione_lavorativa_div" style="padding: 0;">
                                                                            <select class="form-control kt-select2-general obbligatory" id="condizione_lavorativa" name="condizione_lavorativa"  style="width: 100%">
                                                                                <option value="-">Seleziona condizione lavorativa precedente</option>
                                                                                <%for (Condizione_Lavorativa c : condlavprec) {%>
                                                                                <option value="<%=c.getId()%>"><%=c.getDescrizione()%></option>
                                                                                <%}%>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-group col-xl-4 col-lg-6">
                                                                        <label>Condizione di Mercato </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <div class="dropdown bootstrap-select form-control kt-" id="condizione_div" style="padding: 0;">
                                                                            <select class="form-control kt-select2-general obbligatory" id="condizione" name="condizione"  style="width: 100%">
                                                                                <option value="-">Seleziona condizione di mercato</option>
                                                                                <%for (Condizione_Mercato c : condizione) {%>
                                                                                <option value="<%=c.getId()%>"><%=c.getDescrizione()%></option>
                                                                                <%}%>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                </div>  
                                                                <div class="form-row">
                                                                    <div class="form-group col-xl-4 col-lg-6">
                                                                        <label>Email </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input type="text" class="form-control obbligatory" id="email" name="email" />
                                                                    </div>
                                                                    <div class="form-group col-xl-4 col-lg-6">
                                                                        <label>Centro per l'impiego di competenza </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <div class="dropdown bootstrap-select form-control kt-" id="cpi_div" style="padding: 0;">
                                                                            <select class="form-control kt-select2-general obbligatory" id="cpi" name="cpi"  style="width: 100%">
                                                                                <option value="-">Seleziona CPI</option>
                                                                                <%for (CPI c : cpi) {%>
                                                                                <option value="<%=c.getId()%>"><%=c.getDescrizione()%></option>
                                                                                <%}%>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-group col-xl-2 col-lg-6">
                                                                        <label>Data iscrizione G.G. </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input type="text" class="form-control obbligatory" name="iscrizionegg" id="iscrizionegg" autocomplete="off" readonly/>
                                                                    </div>
                                                                    <div class="form-group col-xl-2 col-lg-6">
                                                                        <label>Data presa in carico CPI </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                        <input type="text" class="form-control obbligatory" name="datacpi" id="datacpi" autocomplete="off" readonly/>
                                                                    </div>
                                                                </div>
                                                                <div class="form-group row">
                                                                    <%for (TipoDoc_Allievi t : tipo_doc) {%>
                                                                    <div class="form-group col-xl-4 col-lg-6">
                                                                        <label><%=t.getDescrizione()%></label><%=t.getObbligatorio() == 1 ? "<label class='kt-font-danger kt-font-boldest'>*</label>" : ""%>
                                                                        <div class="custom-file">
                                                                            <input type="file" <%=t.getObbligatorio() == 1 ? "tipo='obbligatory'" : ""%> class="custom-file-input" accept="application/pdf" name="doc_<%=t.getId()%>" id="doc_<%=t.getId()%>" onchange="return checkFileExtAndDim(['pdf']);">
                                                                            <label class="custom-file-label selected" name="label_<%=t.getId()%>">Scegli File</label>
                                                                        </div>
                                                                    </div>
                                                                    <%}%>
                                                                </div>
                                                                <div class="kt-portlet__foot" style="padding-left: 10px;">
                                                                    <div class="kt-form__actions">
                                                                        <div class="row">
                                                                            <a id="submit_change"  href="javascript:void(0);" class="btn btn-io" style="font-family: Poppins"><i class="flaticon2-plus-1"></i> Aggiungi</a>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>    
                                                        </div>
                                                    </div>
                                                </div>
                                            </form>     
                                        </div>
                                    </div>
                                    <%if (fancy) {%>
                                </div>
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
        <script src="<%=src%>/assets/vendors/general/tooltip.js/dist/umd/tooltip.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/sticky-js/dist/sticky.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap/dist/js/bootstrap.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/js-cookie/src/js.cookie.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/moment/min/moment.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/perfect-scrollbar/dist/perfect-scrollbar.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/demo/default/base/scripts.bundle.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/jquery-form/dist/jquery.form.min.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/components/extended/blockui1.33.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/soop/js/utility.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/bundle/app.bundle.js" type="text/javascript"></script>
        <!--this page -->
        <script src="<%=src%>/assets/vendors/general/select2/dist/js/select2.full.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/select2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-select/dist/js/bootstrap-select.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/js/bootstrap-datepicker.js" type="text/javascript"></script>
        <script id="newAllievo" src="<%=src%>/page/sa/js/newAllievo.js" data-context="<%=request.getContextPath()%>" type="text/javascript"></script>
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
            var datep = function () {
                var arrows = {
                    leftArrow: '<i class="la la-angle-left"></i>',
                    rightArrow: '<i class="la la-angle-right"></i>'
                }
                var demos = function () {
                    $('input.dateBorth').datepicker({
                        orientation: "bottom left",
                        todayHighlight: true,
                        templates: arrows,
                        autoclose: true,
                        format: 'dd/mm/yyyy',
                        startView: 'decade',
                        endDate: new Date(),
                    });

                }

                return {
                    // public functions
                    init: function () {
                        demos();
                    }
                };
            }();

            jQuery(document).ready(function () {
                datep.init();
            });
        </script>
    </body>
</html>
<%}
    }%>
