
<%@page import="rc.soop.util.Utility"%>
<%@page import="rc.soop.domain.Condizione_Lavorativa"%>
<%@page import="rc.soop.domain.Comuni"%>
<%@page import="rc.soop.domain.Condizione_Mercato"%>
<%@page import="java.util.Date"%>
<%@page import="rc.soop.domain.CPI"%>
<%@page import="java.text.DateFormat"%>
<%@page import="rc.soop.domain.Allievi"%>
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
            Allievi a = e.getEm().find(Allievi.class, Long.parseLong(request.getParameter("id")));
            List<Comuni> cittadinanza = e.listaCittadinanza();
            List<Item> regioni = e.listaRegioni();
            List<TitoliStudio> ts = e.listaTitoliStudio();
            List<CPI> cpi = e.listaCPI();
            List<Condizione_Mercato> condizione = e.findAll(Condizione_Mercato.class);
            List<Condizione_Lavorativa> condlavprec = e.findAll(Condizione_Lavorativa.class);
            e.close();
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<html>
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%> - Allievi</title>
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
        <link href="<%=src%>/assets/vendors/general/bootstrap-select/dist/css/bootstrap-select.css" rel="stylesheet" type="text/css"/>
        <link href="<%=src%>/assets/vendors/general/bootstrap-switch/dist/css/bootstrap3/bootstrap-switch.css" rel="stylesheet" type="text/css"/>
        <link href="<%=src%>/assets/vendors/general/bootstrap-datepicker/dist/css/bootstrap-datepicker3.css" rel="stylesheet" type="text/css"/>

        <link href="<%=src%>/assets/vendors/general/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet" type="text/css" />
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
        <style type="text/css">
            .form-group {
                margin-bottom: 1rem;
            }

            .custom-file-label::after {
                color:#fff;
                background-color: #eaa21c;
            }

            .custom-file-label.selected{
                background-color: #f3f3f3!important;
                color: #a7abc3!important;
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
                                <div class="kt-portlet__body">
                                    <form class="kt-form" id="kt_form" action="<%=request.getContextPath()%>/OperazioniSA?type=updtAllievo" style="padding-top: 0;"  method="post" enctype="multipart/form-data">
                                        <div class="kt-portlet__head">
                                            <div class="kt-portlet__head-label">
                                                <div class="kt-portlet__head-label">
                                                    <h3 class="kt-portlet__head-title">
                                                        Allievo: <b><%=a.getNome()%> <%=a.getCognome()%></b>
                                                    </h3>
                                                </div>
                                            </div>
                                            <div class="kt-portlet__head-toolbar">
                                                <ul class="nav nav-pills nav-pills-sm nav-pills-label nav-pills-bold" role="tablist">
                                                    <li class="nav-item">
                                                        <a class="nav-link" id="tab1" data-toggle="tab" href="#kt_widget5_tab1_content" role="tab">
                                                            Anagrafica
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a class="nav-link" id="tab2" data-toggle="tab" href="#kt_widget5_tab2_content"  role="tab">
                                                            Documenti
                                                        </a>
                                                    </li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="kt-portlet__body">
                                            <div class="tab-content">
                                                <div class="tab-pane" id="kt_widget5_tab1_content" aria-expanded="true">
                                                    <div class="col-lg-12 col-sm-12">
                                                        <div class="kt-section kt-section--space-md">
                                                            <div class="form-group form-group-sm row">
                                                                <div class="col-lg-10">
                                                                    <h5>Anagrafica</h5>
                                                                    <div class="kt-separator kt-separator--border kt-separator--space-xs"></div>
                                                                    <div class="form-row">
                                                                        <div class="form-group col-xl-3 col-lg-6">
                                                                            <label>Nome </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <input type="text" class="form-control obbligatory" id="nome" name="nome" value="<%=a.getNome()%>" />
                                                                        </div>
                                                                        <div class="form-group col-xl-3 col-lg-6">
                                                                            <label>Cognome </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <input type="text" class="form-control obbligatory" id="cognome" name="cognome" value="<%=a.getCognome()%>" />
                                                                        </div>
                                                                        <div class="form-group col-xl-3 col-lg-6">
                                                                            <label>Codice fiscale </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <input class="form-control obbligatory" type="text" name="codicefiscale" id="codicefiscale" value="<%=a.getCodicefiscale()%>" />
                                                                        </div>
                                                                        <div class="form-group col-xl-3 col-lg-6">
                                                                            <label>Stato nascita </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <div class="dropdown bootstrap-select form-control kt-" id="stato_div" style="padding: 0;">
                                                                                <select class="form-control kt-select2-general obbligatory" id="stato" name="stato"  style="width: 100%">
                                                                                    <option value="-">Seleziona Stato nascita</option>
                                                                                    <%boolean it = a.getComune_nascita().getCittadinanza() == 0;
                                                                                        for (Comuni c : cittadinanza) {
                                                                                            if (c.getIstat().equals("000") && it) {%>
                                                                                    <option selected value="<%=c.getIstat()%>"><%=c.getNome()%></option>
                                                                                    <%} else {%>
                                                                                    <option value="<%=c.getIstat()%>"><%=c.getNome()%></option>
                                                                                    <%}
                                                                                        }%>
                                                                                </select>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-row">
                                                                        <div class="form-group col-xl-3 col-lg-3">
                                                                            <label>Data nascita </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <input type="text" class="form-control dp obbligatory" name="datanascita" id="datanascita" value="<%=sdf.format(a.getDatanascita())%>" />
                                                                        </div>
                                                                        <div class="form-group col-xl-3 col-lg-3">
                                                                            <label>Regione di nascita </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <div class="dropdown bootstrap-select form-control kt-" id="regionenascita_div" style="padding: 0;">
                                                                                <select class="form-control kt-select2-general obbligatory" id="regionenascita" name="regionenascita"  style="width: 100%">
                                                                                    <option value="-">Seleziona Regione</option>
                                                                                    <%for (Item i : regioni) {
                                                                                            if (i.getValue().equals(a.getComune_nascita().getRegione())) {%>
                                                                                    <option value="<%=i.getValue()%>" selected><%=i.getDesc()%></option>
                                                                                    <%} else {%>
                                                                                    <option value="<%=i.getValue()%>"><%=i.getDesc()%></option>
                                                                                    <%}
                                                                                        }%>
                                                                                </select>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group col-xl-3 col-lg-3">
                                                                            <label>Provincia di nascita </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <div class="dropdown bootstrap-select form-control kt-" id="provincianascita_div" style="padding: 0;">
                                                                                <select class="form-control kt-select2-general obbligatory" id="provincianascita" name="provincianascita"  style="width: 100%;">
                                                                                    <option value="-">Seleziona Provincia</option>
                                                                                </select>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group col-xl-3 col-lg-3">
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
                                                                            <label>Cittadinanza</label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <div class="dropdown bootstrap-select form-control kt-" id="cittadinanza_div" style="padding: 0;">
                                                                                <select class="form-control kt-select2-general obbligatory" id="cittadinanza" name="cittadinanza"  style="width: 100%">
                                                                                    <option value="-">Seleziona Cittadinanza</option>
                                                                                    <%for (Comuni c : cittadinanza) {
                                                                                            if (c.equals(a.getCittadinanza())) {%>
                                                                                    <option selected value="<%=c.getIstat()%>"><%=c.getNome()%></option>
                                                                                    <%} else {%>
                                                                                    <option value="<%=c.getIstat()%>"><%=c.getNome()%></option>
                                                                                    <%}
                                                                                        }%>
                                                                                </select>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group col-xl-3 col-lg-3">
                                                                            <label>Telefono </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <input type="text" class="form-control obbligatory" id="telefono" name="telefono" value="<%=a.getTelefono()%>" onkeypress="return isNumber(event);" />
                                                                        </div>        
                                                                    </div>
                                                                    <h5>Residenza</h5>
                                                                    <div class="kt-separator kt-separator--border kt-separator--space-xs"></div>
                                                                    <div class="form-row">
                                                                        <div class="form-group col-lg-4">
                                                                            <label>Indirizzo </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <input type="text" class="form-control obbligatory" id="indirizzores" name="indirizzores" value="<%=a.getIndirizzoresidenza()%>" />
                                                                        </div>
                                                                        <div class="form-group col-lg-2">
                                                                            <label>Civico </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <input type="text" class="form-control obbligatory" id="civicores" name="civicores" value="<%=a.getCivicoresidenza()%>" />
                                                                        </div>
                                                                        <div class="form-group col-lg-2">
                                                                            <label>CAP </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <input type="text" class="form-control obbligatory" id="capres" name="capres" value="<%=a.getCapresidenza()%>" onkeypress="return isNumber(event);"/>
                                                                        </div>
                                                                        <div class="form-group col-lg-4 kt-align-right">
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
                                                                                    <%for (Item i : regioni) {
                                                                                            if (i.getValue().equals(a.getComune_residenza().getRegione())) {%>
                                                                                    <option value="<%=i.getValue()%>" selected><%=i.getDesc()%></option>
                                                                                    <%} else {%>
                                                                                    <option value="<%=i.getValue()%>"><%=i.getDesc()%></option>
                                                                                    <%}
                                                                                        }%>
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
                                                                        <div class="form-group col-lg-4">
                                                                            <label>Indirizzo </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <input type="text" class="form-control" id="indirizzodom" name="indirizzodom" value="<%=a.getIndirizzodomicilio()%>" />
                                                                        </div>
                                                                        <div class="form-group col-lg-2">
                                                                            <label>Civico </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <input type="text" class="form-control" id="civicodom" name="civicodom" value="<%=a.getCivicodomicilio()%>" />
                                                                        </div>
                                                                        <div class="form-group col-lg-2">
                                                                            <label>CAP </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <input type="text" class="form-control" id="capdom" name="capdom" value="<%=a.getCapdomicilio()%>" onkeypress="return isNumber(event);"/>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-row">
                                                                        <div class="form-group col-lg-4">
                                                                            <label>Regione di domicilio </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <div class="dropdown bootstrap-select form-control kt-" id="regionedom_div" style="padding: 0;">
                                                                                <select class="form-control kt-select2-general" id="regionedom" name="regionedom"  style="width: 100%">
                                                                                    <option value="-">Seleziona Regione</option>
                                                                                    <%for (Item i : regioni) {
                                                                                            if (i.getValue().equals(a.getComune_domicilio().getRegione())) {%>
                                                                                    <option value="<%=i.getValue()%>" selected><%=i.getDesc()%></option>
                                                                                    <%} else {%>
                                                                                    <option value="<%=i.getValue()%>"><%=i.getDesc()%></option>
                                                                                    <%}
                                                                                        }%>
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
                                                                    <h5>Documentazione</h5>
                                                                    <div class="kt-separator kt-separator--border kt-separator--space-xs"></div>
                                                                    <div class="form-row">
                                                                        <div class="form-group col-lg-4">
                                                                            <label>Titolo di studio </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <div class="dropdown bootstrap-select form-control kt-" id="titolo_studio_div" style="padding: 0;">
                                                                                <select class="form-control kt-select2-general obbligatory" id="titolo_studio" name="titolo_studio"  style="width: 100%">
                                                                                    <option value="-">Seleziona titolo di studio</option>
                                                                                    <%for (TitoliStudio t : ts) {
                                                                                            if (t.getCodice().equals(a.getTitoloStudio().getCodice())) {%>
                                                                                    <option value="<%=t.getCodice()%>" selected><%=t.getDescrizione()%></option>
                                                                                    <%} else {%>
                                                                                    <option value="<%=t.getCodice()%>"><%=t.getDescrizione()%></option>
                                                                                    <%}
                                                                                        }%>
                                                                                </select>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group col-lg-4">
                                                                            <label>Condizione lavorativa precedente </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <!--29-04-2020 MODIFICA - CONDIZIONE LAVORATIVA PRECEDENTE-->
                                                                            <!--<input type="text" class="form-control obbligatory" id="neet" name="neet" value="<%=a.getNeet()%>" />-->
                                                                            <div class="dropdown bootstrap-select form-control kt-" id="condizione_lavorativa_div" style="padding: 0;">
                                                                                <select class="form-control kt-select2-general obbligatory" id="condizione_lavorativa" name="condizione_lavorativa"  style="width: 100%">
                                                                                    <option value="-">Seleziona condizione di mercato</option>
                                                                                    <%for (Condizione_Lavorativa c : condlavprec) {
                                                                                            if (c.equals(a.getCondizione_lavorativa())) {%>
                                                                                    <option selected value="<%=c.getId()%>"><%=c.getDescrizione()%></option>
                                                                                    <%} else {%>
                                                                                    <option value="<%=c.getId()%>"><%=c.getDescrizione()%></option>
                                                                                    <%}
                                                                                        }%>
                                                                                </select>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group col-xl-4 col-lg-6">
                                                                            <label>Condizione di Mercato </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <div class="dropdown bootstrap-select form-control kt-" id="condizione_div" style="padding: 0;">
                                                                                <select class="form-control kt-select2-general obbligatory" id="condizione" name="condizione"  style="width: 100%">
                                                                                    <option value="-">Seleziona condizione di mercato</option>
                                                                                    <%for (Condizione_Mercato c : condizione) {
                                                                                            if (c.equals(a.getCondizione_mercato())) {%>
                                                                                    <option selected value="<%=c.getId()%>"><%=c.getDescrizione()%></option>
                                                                                    <%} else {%>
                                                                                    <option value="<%=c.getId()%>"><%=c.getDescrizione()%></option>
                                                                                    <%}
                                                                                        }%>
                                                                                </select>
                                                                            </div>
                                                                        </div>
                                                                    </div>  
                                                                    <div class="form-row">
                                                                        <div class="form-group col-lg-4">
                                                                            <label>Email </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <input type="text" class="form-control" id="email" name="email" value="<%=a.getEmail()%>" />
                                                                        </div>
                                                                        <div class="form-group col-lg-4">
                                                                            <label>Centro per l'impiego di competenza </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <div class="dropdown bootstrap-select form-control kt-" id="cpi_div" style="padding: 0;">
                                                                                <select class="form-control kt-select2-general obbligatory" id="cpi" name="cpi"  style="width: 100%">
                                                                                    <option value="-">Seleziona CPI</option>
                                                                                    <%for (CPI c : cpi) {
                                                                                            if (c.getId().equals(a.getCpi().getId())) {%>
                                                                                    <option value="<%=c.getId()%>" selected><%=c.getDescrizione()%></option>
                                                                                    <%} else {%>
                                                                                    <option value="<%=c.getId()%>"><%=c.getDescrizione()%></option>
                                                                                    <%}
                                                                                        }%>
                                                                                </select>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group col-lg-2">
                                                                            <label>Data iscrizione G.G. </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <input type="text" class="form-control obbligatory" name="iscrizionegg" id="iscrizionegg" value="<%=sdf.format(a.getIscrizionegg())%>"  />
                                                                        </div>
                                                                        <div class="form-group col-lg-2">
                                                                            <label>Presa in carico CPI </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <input type="text" class="form-control obbligatory" name="datacpi" id="datacpi" value="<%=sdf.format(a.getDatacpi())%>"  />
                                                                        </div>
                                                                    </div> 
                                                                </div>    
                                                                <div class="col-lg-2 kt-align-right">
                                                                    <a href="jascript:void(0);" class="btn btn-io submit_change" style="font-family: Poppins"><i class="flaticon2-accept"></i> Aggiorna</a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="tab-pane" id="kt_widget5_tab2_content">
                                                    <div class="col-lg-12 col-sm-12">
                                                        <div class="kt-section kt-section--space-md">
                                                            <div class="form-group form-group-sm row">
                                                                <div class="col-lg-10">
                                                                    <h5>Documenti</h5>
                                                                    <div class="form-row">
                                                                        <div class="form-group col-lg-4">
                                                                            <label>Documento di identità </label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <div class="custom-file">
                                                                                <input type="hidden" name="cartaidpath" value="<%=a.getDocid()%>" />
                                                                                <input type="hidden" name="id" value="<%=a.getId()%>" />
                                                                                <input type="file" class="custom-file-input" accept="application/pdf" name="docid" id="docid">
                                                                                <label class="custom-file-label selected" id='label_file'>Carta ID</label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group col-lg-4">
                                                                            <label>Data scadenza documento</label><label class="kt-font-danger kt-font-boldest">*</label>
                                                                            <input type="text" class="form-control obbligatory" name="scadenzadoc" id="scadenzadoc" value="<%=sdf.format(a.getScadenzadocid())%>"  />
                                                                        </div>
                                                                    </div>  
                                                                    <div class="form-row">
                                                                        <div class="col-lg-5">
                                                                            <label>Preview Documento D'Identità</label>
                                                                            <div class="form-group form-group-sm row" id="div_preview"></div>
                                                                        </div>
                                                                    </div>
                                                                </div>    
                                                                <div class="col-lg-2 kt-align-right">
                                                                    <a href="jascript:void(0);" class="btn btn-io submit_change" style="font-family: Poppins"><i class="flaticon2-accept"></i> Aggiorna</a>
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
        <!--this page -->
        <script src="<%=src%>/assets/vendors/general/select2/dist/js/select2.full.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/custom/general/crud/forms/widgets/select2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/bootstrap-select/dist/js/bootstrap-select.js" type="text/javascript"></script>
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
            jQuery(document).ready(function () {
                if ($('#cittadinanza').val() == '-') {
                    $('#cittadinanza').val('000');
                    $('#cittadinanza').trigger('change');
                }
                if ($('#stato').val() != '-') {
                    setCittadinanza();
                }
                $('#kt_widget5_tab1_content').addClass("active");
                $('#tab1').addClass("active");
            <%if (a.getIndirizzoresidenza().equalsIgnoreCase(a.getIndirizzodomicilio()) && a.getCivicoresidenza().equalsIgnoreCase(a.getCivicodomicilio()) && a.getComune_residenza().equals(a.getComune_domicilio()) && a.getCapresidenza().equals(a.getCapdomicilio())) {%>
                $('#checkind').prop('checked', true);
                domicilio();
            <%}%>
            <%if (new Date().after(a.getScadenzadocid())) {%>
                $('#scadenzadoc').attr("class", "form-control is-invalid");
                $('#docid').attr("class", "custom-file-input is-invalid");
            <%}%>
                selectProvinciaN();
                selectProvinciaR();
                selectProvinciaD();
                selectComuneN("<%=a.getComune_nascita().getNome_provincia()%>");
                selectComuneR("<%=a.getComune_residenza().getNome_provincia()%>");
                selectComuneD("<%=a.getComune_domicilio().getNome_provincia()%>");
            });

            $('#scadenzadoc').on("change", function () {
                if (new Date() < moment($('#scadenzadoc').val(), 'DD/MM/YYYY')) {
                    $('#scadenzadoc').attr("class", "form-control");
                } else {
                    $('#scadenzadoc').attr("class", "form-control is-invalid");
                }
            });

            $('#codicefiscale').on("change", function () {
                if ($('#codicefiscale').val() != '<%=a.getCodicefiscale()%>') {
                    if (checkCF($('#codicefiscale'))) {
                        CFPresent();
                    }
                }
            });

            function EmailPresente() {
                var err;
                $.ajax({
                    type: "GET",
                    async: false,
                    url: '<%=request.getContextPath()%>/OperazioniSA?type=checkEmail&email=' + $('#email').val(),
                    success: function (data) {
                        if (data != null && data != 'null') {
                            swal.fire({
                                "title": 'Errore',
                                "html": "<h3>Email già presente</h3>",
                                "type": "error",
                                cancelButtonClass: "btn btn-io-n",
                            });
                            $('#email').attr("class", "form-control is-invalid");
                            err = true;
                        } else {
                            $('#email').attr("class", "form-control is-valid");
                            err = false;
                        }
                    }
                });
                return err;
            }

            function CFPresent() {
                var err;
                $.ajax({
                    type: "GET",
                    async: false,
                    url: '<%=request.getContextPath()%>/OperazioniSA?type=checkCF&cf=' + $('#codicefiscale').val(),
                    success: function (data) {
                        if (data != null && data != 'null') {
                            swal.fire({
                                "title": 'Errore',
                                "html": "<h3>Codice fiscale già presente</h3>",
                                "type": "error",
                                cancelButtonClass: "btn btn-io-n",
                            });
                            $('#codicefiscale').attr("class", "form-control is-invalid");
                            err = true;
                        } else {
                            $('#codicefiscale').attr("class", "form-control is-valid");
                            err = false;
                        }
                    }
                });
                return err;
            }

            $('#regionenascita').on('change', function (e) {
                $("#provincianascita").empty();
                $("#comunenascita").empty();
                $("#comunenascita").append('<option value="-">. . .</option>');
                selectProvinciaN();
            });
            $('#provinciares').on("change", function () {
                selectComuneR($('#provinciares').val());
            });
            $('#regioneres').on('change', function (e) {
                $("#provinciares").empty();
                $("#comuneres").empty();
                $("#comuneres").append('<option value="-">. . .</option>');
                selectProvinciaR();
            });
            $('#provincianascita').on("change", function () {
                selectComuneN($('#provincianascita').val());
            });
            $('#regionedom').on('change', function (e) {
                $("#provinciadom").empty();
                $("#comunedom").empty();
                $("#comunedom").append('<option value="-">. . .</option>');
                selectProvinciaD();
            });
            $('#provinciadom').on("change", function () {
                selectComuneD($('#provinciadom').val());
            });


            function selectProvinciaN() {
                var myTown = "<%=a.getComune_nascita().getNome_provincia()%>";
                $("#provincianascita").empty();
                if ($('#regionenascita').val() != '-') {
                    startBlockUILoad("#provincianascita_div");
                    $("#provincianascita").append('<option value="-">Seleziona Provincia</option>');
                    $.get('<%=request.getContextPath()%>/Login?type=getProvincia&regione=' + $('#regionenascita').val(), function (resp) {
                        var json = JSON.parse(resp);
                        for (var i = 0; i < json.length; i++) {
                            if (myTown.toLowerCase() == json[i].value.toLowerCase()) {
                                $("#provincianascita").append('<option selected value="' + json[i].value + '">' + json[i].desc + '</option>');
                            } else {
                                $("#provincianascita").append('<option value="' + json[i].value + '">' + json[i].desc + '</option>');
                            }
                        }
                        stopBlockUI("#provincianascita_div");
                    });
                } else {
                    $("#provincianascita").append('<option value="-">. . .</option>');
                }
            }
            function selectComuneN(provincia) {
                var myTown = '<%=a.getComune_nascita().getId()%>';
                $("#comunenascita").empty();
                if (provincia != '-') {
                    startBlockUILoad("#comunenascita_div");
                    $("#comunenascita").append('<option value="-">Seleziona Comune</option>');
                    $.get('<%=request.getContextPath()%>/Login?type=getComune&provincia=' + provincia, function (resp) {
                        var json = JSON.parse(resp);
                        for (var i = 0; i < json.length; i++) {
                            if (myTown.toLowerCase() == json[i].value.toLowerCase()) {
                                $("#comunenascita").append('<option selected value="' + json[i].value + '">' + json[i].desc + '</option>');
                            } else {
                                $("#comunenascita").append('<option value="' + json[i].value + '">' + json[i].desc + '</option>');
                            }
                        }
                        stopBlockUI("#comunenascita_div");
                    });
                } else {
                    $("#comunenascita").append('<option value="-">. . .</option>');
                }
            }

            function selectProvinciaR() {
                var myTown = "<%=a.getComune_residenza().getNome_provincia()%>";
                $("#provinciares").empty();
                if ($('#regioneres').val() != '-') {
                    startBlockUILoad("#provinciares_div");
                    $("#provinciares").append('<option value="-">Seleziona Provincia</option>');
                    $.get('<%=request.getContextPath()%>/Login?type=getProvincia&regione=' + $('#regioneres').val(), function (resp) {
                        var json = JSON.parse(resp);
                        for (var i = 0; i < json.length; i++) {
                            if (myTown.toLowerCase() == json[i].value.toLowerCase()) {
                                $("#provinciares").append('<option selected value="' + json[i].value + '">' + json[i].desc + '</option>');
                            } else {
                                $("#provinciares").append('<option value="' + json[i].value + '">' + json[i].desc + '</option>');
                            }
                        }
                        stopBlockUI("#provinciares_div");
                    });
                } else {
                    $("#provinciares").append('<option value="-">. . .</option>');
                }
            }
            function selectComuneR(provincia) {
                var myTown = "<%=a.getComune_residenza().getId()%>";
                $("#comuneres").empty();
                if (provincia != '-') {
                    startBlockUILoad("#comuneres_div");
                    $("#comuneres").append('<option value="-">Seleziona Comune</option>');
                    $.get('<%=request.getContextPath()%>/Login?type=getComune&provincia=' + provincia, function (resp) {
                        var json = JSON.parse(resp);
                        for (var i = 0; i < json.length; i++) {
                            if (myTown.toLowerCase() == json[i].value.toLowerCase()) {
                                $("#comuneres").append('<option selected value="' + json[i].value + '">' + json[i].desc + '</option>');
                            } else {
                                $("#comuneres").append('<option value="' + json[i].value + '">' + json[i].desc + '</option>');
                            }
                        }
                        stopBlockUI("#comuneres_div");
                    });
                } else {
                    $("#comuneres").append('<option value="-">. . .</option>');
                }
            }

            function selectProvinciaD() {
                var myTown = "<%=a.getComune_domicilio().getNome_provincia()%>";
                $("#provinciadom").empty();
                if ($('#regionedom').val() != '-') {
                    startBlockUILoad("#provinciadom_div");
                    $("#provinciadom").append('<option value="-">Seleziona Provincia</option>');
                    $.get('<%=request.getContextPath()%>/Login?type=getProvincia&regione=' + $('#regionedom').val(), function (resp) {
                        var json = JSON.parse(resp);
                        for (var i = 0; i < json.length; i++) {
                            if (myTown.toLowerCase() == json[i].value.toLowerCase()) {
                                $("#provinciadom").append('<option selected value="' + json[i].value + '">' + json[i].desc + '</option>');
                            } else {
                                $("#provinciadom").append('<option value="' + json[i].value + '">' + json[i].desc + '</option>');
                            }
                        }
                        stopBlockUI("#provinciadom_div");
                    });
                } else {
                    $("#provinciadom").append('<option value="-">. . .</option>');
                }
            }
            function selectComuneD(provincia) {
                var myTown = "<%=a.getComune_domicilio().getId()%>";
                $("#comunedom").empty();
                if (provincia != '-') {
                    startBlockUILoad("#comunedom_div");
                    $("#comunedom").append('<option value="-">Seleziona Comune</option>');
                    $.get('<%=request.getContextPath()%>/Login?type=getComune&provincia=' + provincia, function (resp) {
                        var json = JSON.parse(resp);
                        for (var i = 0; i < json.length; i++) {
                            if (myTown.toLowerCase() == json[i].value.toLowerCase()) {
                                $("#comunedom").append('<option selected value="' + json[i].value + '">' + json[i].desc + '</option>');
                            } else {
                                $("#comunedom").append('<option value="' + json[i].value + '">' + json[i].desc + '</option>');
                            }
                        }
                        stopBlockUI("#comunedom_div");
                    });
                } else {
                    $("#comunedom").append('<option value="-">. . .</option>');
                }
            }

            $('#stato').on("change", function () {
                setCittadinanza();
            });

            function setCittadinanza() {
                if ($('#stato').val() != '000') {
                    $('#regionenascita').attr("disabled", true);
                    $('#provincianascita').attr("disabled", true);
                    $('#comunenascita').attr("disabled", true);
                    $('#regionenascita').removeClass("obbligatory");
                    $('#provincianascita').removeClass("obbligatory");
                    $('#comunenascita').removeClass("obbligatory");
                    $('#regionenascita_div').removeClass("obbligatory is-invalid-select is-valid-select");
                    $('#provincianascita_div').removeClass("obbligatory is-invalid-select is-valid-select");
                    $('#comunenascita_div').removeClass("obbligatory is-invalid-select is-valid-select");
                } else {
                    $('#regionenascita').removeAttr("disabled");
                    $('#provincianascita').removeAttr("disabled");
                    $('#comunenascita').removeAttr("disabled");
                    $('#regionenascita').addClass("obbligatory");
                    $('#provincianascita').addClass("obbligatory");
                    $('#comunenascita').addClass("obbligatory");
                }
            }

            function domicilio() {
                if ($('#checkind').is(":checked") === false) {
                    $('#msgdom').css("display", "none");
                    $("#indirizzodom").removeAttr("disabled");
                    $("#capdom").removeAttr("disabled");
                    $("#civicodom").removeAttr("disabled");
                    $("#regionedom").removeAttr("disabled");
                    $("#provinciadom").removeAttr("disabled");
                    $("#comunedom").removeAttr("disabled");
                    $("#indirizzodom").removeAttr("placeholder");
                    $("#capdom").removeAttr("placeholder");
                    $("#civicodom").removeAttr("placeholder");
                } else {
                    $('#msgdom').css("display", "");
                    $("#indirizzodom").attr("disabled", true);
                    $("#indirizzodom").attr("placeholder", "Indirizzo residenza");
                    $("#capdom").attr("disabled", true);
                    $("#capdom").attr("placeholder", "Cap residenza");
                    $("#capdom").removeClass("is-invalid");
                    $("#indirizzodom").removeClass("is-invalid");
                    $("#civicodom").attr("disabled", true);
                    $("#civicodom").attr("placeholder", "Civico res.");
                    $("#civicodom").removeClass("is-invalid");
                    $("#regionedom").attr("disabled", true);
                    $("#provinciadom").attr("disabled", true);
                    $("#comunedom").attr("disabled", true);
                    $("#comunedom_div").removeClass("is-invalid is-invalid-select");
                    $("#provinciadom_div").removeClass("is-invalid is-invalid-select");
                    $("#regionedom_div").removeClass("is-invalid is-invalid-select");
                }
            }

            function ctrlForm() {
                var err = false;
                if (!$('#checkind').is(":checked")) {
                    $('#indirizzodom').addClass("obbligatory");
                    $('#capdom').addClass("obbligatory");
                    $('#civicodom').addClass("obbligatory");
                    $('#comunedom').addClass("obbligatory");
                    $('#regionedom').addClass("obbligatory");
                    $('#provinciadom').addClass("obbligatory");
                } else {
                    $('#indirizzodom').removeClass("obbligatory");
                    $('#capdom').removeClass("obbligatory");
                    $('#civicodom').removeClass("obbligatory");
                    $('#comunedom').removeClass("obbligatory");
                    $('#regionedom').removeClass("obbligatory");
                    $('#provinciadom').removeClass("obbligatory");
                }

                err = checkObblFields() ? true : err;
                if (checkCF($('#codicefiscale'))) {
                    if ($('#codicefiscale').val() != '<%=a.getCodicefiscale()%>') {
                        err = CFPresent() ? true : err;
                    }
                    err = checkinfoCF() ? true : err;
                } else {
                    err = true;
                }
                if (!checkEmail($('#email'))) {
                    if ($('#email').val() != '<%=a.getEmail()%>') {
                        err = EmailPresente();
                    }
                } else {
                    err = true;
                }
                err = !checkRequiredFile() ? true : err;
                err = !checkFileExtAndDim(['pdf']) ? true : err;
                return !err;
                
            }

            $('a.submit_change').on('click', function () {
                if (ctrlForm()) {
                    showLoad();
                    $('#kt_form').ajaxSubmit({
                        error: function () {
                            closeSwal();
                            swal.fire({
                                "title": 'Errore',
                                "text": "Riprovare, se l'errore persiste contattare il servizio clienti",
                                "type": "error",
                                cancelButtonClass: "btn btn-io-n",
                            });
                        },
                        success: function (resp) {
                            var json = JSON.parse(resp);
                            closeSwal();
                            if (json.result) {
                                swal.fire({
                                    "title": '<h2 class="kt-font-io"><b>Profilo allievo aggiornato!</b></h2><br>',
                                    "html": "<h4>Operazione effettuata con successo.</h4>",
                                    "type": "success",
                                    "width": '45%',
                                    "confirmButtonClass": "btn btn-io",
                                });
                            } else {
                                swal.fire({
                                    "title": '<h2 class="kt-font-io-n"><b>Errore!</b></h2><br>',
                                    "html": "<h4>" + json.message + "</h4>",
                                    "type": "error",
                                    cancelButtonClass: "btn btn-io-n"
                                });
                            }
                        }
                    });
                }
            });

            $('#docid').on('change', function () {
                if (checkFileDim()) {
                    ctrlPdf2($('#docid'), $('#div_preview'), $('#label_file'), '600');
                }
            });

            $('#capres').keydown(function (e) {
                if (this.value.length > 4)
                    if (!(e.which == '46' || e.which == '8' || e.which == '13')) // backspace/enter/del
                        e.preventDefault();
            });
            $('#capdom').keydown(function (e) {
                if (this.value.length > 4)
                    if (!(e.which == '46' || e.which == '8' || e.which == '13')) // backspace/enter/del
                        e.preventDefault();
            });

            $(document).ready(function () {
                $.get("<%=request.getContextPath()%>/OperazioniGeneral?type=pdfTob64&path=<%=a.getDocid()%>", function (data) {
                            $("<iframe />", {
                                "src": "data:application/pdf;base64," + data,
                                "width": '100%',
                                "height": '600px',
                                "type": "application/pdf",
                                css: {
                                    "margin": 5,
                                    "border": 0,
                                    "border-radius": 10,
                                }
                            }).appendTo($('#div_preview'));

                        });
                    });

                    function checkinfoCF() {
                        var cf = $('#codicefiscale');
                        var nome = $('#nome');
                        var cognome = $('#cognome');
                        var data = $('#datanascita');
                        var stato = $('#stato');
                        var checkdata = false;
                        var err = false;
                        var msg = "<b style='padding:10px;color: #fd397a!important;'>Attenzione i seguenti dati anagrafici non sono conformi con il codice fiscale inserito (";
                        //CONTROLLO NOME ---> 1,3,4 CONSONANTI SE CE NE SONO ALMENO 4, ALTRIMENTI AGGIUNGO VOCALI NEL LORO ORDINE 
                        if (!check_nome_CF(nome.val().toUpperCase(), cf.val().substring(3, 6).toUpperCase())) {
                            msg += "Nome";
                            $('#nome').removeClass("is-valid").addClass("is-invalid");
                            err = true;
                        } else {
                            $('#nome').removeClass("is-invalid").addClass("is-valid");
                        }
                        //CONTROLLO COGNOME ---> 1,2,3 CONSONANTI SE CE NE SONO ALMENO 3, ALTRIMENTI AGGIUNGO VOCALI NEL LORO ORDINE 
                        if (!check_cognome_CF(cognome.val().toUpperCase(), cf.val().substring(0, 3).toUpperCase())) {
                            msg += err ? ", Cognome" : "Cognome";
                            $('#cognome').removeClass("is-valid").addClass("is-invalid");
                            err = true;
                        } else {
                            $('#cognome').removeClass("is-invalid").addClass("is-valid");
                        }
                        //CONTROLLO MESE - GIORNO - ANNO
                        if (!check_mese_CF(data.val().substring(3, 5), cf.val().substring(8, 9).toUpperCase())) {
                            msg += err ? ", Mese di nascita" : "Mese di nascita";
                            checkdata = true;
                        }
                        if (!check_giorno_CF(Number(data.val().substring(0, 2)), Number(cf.val().substring(9, 11)))) {
                            msg += err ? ", Giorno di nascita" : "Giorno di nascita";
                            checkdata = true;
                        }
                        if (data.val().substring(8) != cf.val().substring(6, 8)) {
                            msg += err ? ", Anno di nascita" : "Anno di nascita";
                            checkdata = true;
                        }
                        if (checkdata) {
                            err = true;
                            $('#datanascita').removeClass("is-valid").addClass("is-invalid");
                        } else {
                            $('#datanascita').removeClass("is-invalid").addClass("is-valid");
                        }
                        //CONTROLLO COMUNE O, SE ESTERO, STATO
                        $('#regionenascita_div').removeClass("is-valid-select").removeClass("is-invalid-select");
                        $('#provincianascita_div').removeClass("is-valid-select").removeClass("is-invalid-select");
                        $('#comunenascita_div').removeClass("is-valid-select").removeClass("is-invalid-select");
                        if (stato.val() == "000") {
                            if ($('#comunenascita').val() != null && $('#comunenascita').val() != "-") {
                                $.ajax({
                                    type: "GET",
                                    async: false,
                                    url: "<%=request.getContextPath()%>/OperazioniSA?type=getCodiceCatastaleComune&idcomune=" + $('#comunenascita').val(),
                                    success: function (resp) {
                                        $('#stato_div').removeClass("is-invalid-select").addClass("is-valid-select");
                                        if (check_comune_CF(resp,cf.val().substring(11, 15).toUpperCase())) {
//                                        if (resp != cf.val().substring(11, 15).toUpperCase()) {
                                            msg += err ? ", Comune di nascita" : "Comune di nascita";
                                            $('#comunenascita_div').removeClass("is-valid-select").addClass("is-invalid-select");
                                            err = true;
                                        } else {
                                            $('#comunenascita_div').removeClass("is-invalid-select").addClass("is-valid-select");
                                        }
                                    }
                                });
                            } else {
                                msg += err ? ", Comune di nascita" : " Comune di nascita";
                                $('#comunenascita_div').removeClass("is-valid-select").addClass("is-invalid-select");
                                err = true;
                            }
                        } else {
                            if (("Z" + stato.val()) != cf.val().substring(11, 15).toUpperCase()) {
                                msg += err ? ", Stato di nascita" : "Stato di nascita";
                                $('#stato_div').removeClass("is-valid-select").addClass("is-invalid-select");
                                err = true;
                            } else {
                                $('#stato_div').removeClass("is-invalid-select").addClass("is-valid-select");
                            }
                        }

                        if (err) {
                            msg += ").</b>";
                            $("#msg_cf").html(msg);
                            $("#msgrow").css("display", "");
                        } else {
                            $("#msg_cf").html("<b style='padding:10px;color: #0abb87!important;'>Dati anagrafici coerenti con il codice fiscale inserito.</b>");
                            $("#msgrow").css("display", "");
                        }
                        return err;
                    }

        </script>
    </body>
</html>
<%}
    }%>
