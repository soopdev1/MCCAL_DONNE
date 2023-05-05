
<%@page import="java.util.ArrayList"%>
<%@page import="rc.soop.util.Utility"%>
<%@page import="java.util.HashMap"%>
<%@page import="rc.soop.domain.StatiPrg"%>
<%@page import="java.util.Map"%>
<%@page import="rc.soop.domain.ProgettiFormativi"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="rc.soop.domain.Allievi"%>
<%@page import="java.util.List"%>
<%@page import="rc.soop.db.Entity"%>
<%@page import="rc.soop.domain.SoggettiAttuatori"%>
<%@page import="rc.soop.domain.User"%>
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
            String src = session.getAttribute("src").toString();
            Entity e = new Entity();
            List<SoggettiAttuatori> lsa = new ArrayList<>();
            List<SoggettiAttuatori> sa_wait = new ArrayList<>();
            for (SoggettiAttuatori sa : e.getSoggettiAttuatori()) {
                if (sa.getProtocollo() != null) {
                    lsa.add(sa);
                } else {
                    sa_wait.add(sa);
                }
            }

            String ex_allievi = e.getPath("estrazione_allievi");
            //String estrazione_allievi_formati = e.getPath("estrazione_allievi_formati");
            String ex_docenti = e.getPath("estrazione_docenti");
            Long messaggi = e.countFAQ();
            e.close();
            int count_sa = lsa.size();
            
            //PREGRESSO RAF
            //int count_preg = Action.countPregresso();
            //count_allieviformati += count_preg;
            //END PREGRESSO RAF
            int i = 0;
            String[] styles;
            String bgc;
            Map<StatiPrg, Long> requirementCountMap = new HashMap();

%>
<html>
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%> - Home Page</title>
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

        <link href="<%=src%>/assets/vendors/general/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet" type="text/css" />

        <link href="<%=src%>/assets/vendors/general/bootstrap-touchspin/dist/jquery.bootstrap-touchspin.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-select/dist/css/bootstrap-select.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-switch/dist/css/bootstrap3/bootstrap-switch.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/select2/dist/css/select2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/ion-rangeslider/css/ion.rangeSlider.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/nouislider/distribute/nouislider.css" rel="stylesheet" type="text/css" />
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
        <link rel="shortcut icon" href="<%=src%>/assets/media/logos/favicon.ico" />
        <style>
            #containerCanvas {
                position: inherit;
                padding-top: 0;
            }
            .kt-portlet .kt-iconbox .kt-iconbox--animate-slow {
                height: 90%;
            }
            .kt-widget27__title{
                font-size: 7vh!important;
            }
            .accordion.accordion-toggle-plus .card .card-header .card-title:after {
                color: #363a90!important;
            }
            .kt-notification__item2 {
                border-radius: 5px;
                background-color: #c2eee1!important;
                margin-bottom:1.5rem;
            }
            .custom-yellowbox.faq:before{font-family: 'Flaticon';content: "\f177";}
            .custom-bluebox.allievi:before{font-family: 'Flaticon';content: "\f1af";}
            .custom-redbox:before{font-family: 'Flaticon';content: "\f1af";}
            .custom-redbox.terminati:before{font-family: 'Flaticon2';content: "\f126";}
            .custom-greenbox:before{font-family: 'Flaticon';content: "\f1b7";}
            .custom-greenbox.pf:before{font-family: 'Flaticon';content: "\f126";}
            .custom-greybox.docente:before{font-family: 'Flaticon';content: "\f11d";}
            .custom-bluebox:before{font-family: 'Flaticon';content: "\f114";}
            .custom-yellowbox:before{font-family: 'Flaticon2';content: "\f126";}
        </style>
    </head>
    <body class="kt-header--fixed kt-header-mobile--fixed kt-subheader--fixed kt-subheader--enabled kt-subheader--solid kt-aside--enabled kt-aside--fixed">
        <!-- begin:: Page -->
        <%@ include file="menu/head1.jsp"%>
        <div class="kt-grid kt-grid--hor kt-grid--root">
            <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--ver kt-page">
                <%@ include file="menu/menu.jsp"%>
                <!-- end:: Aside -->
                <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor kt-wrapper" id="kt_wrapper">
                    <%@ include file="menu/head.jsp"%>
                    <!-- begin:: Footer -->
                    <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor" style="background-image: url(<%=src%>/resource/bg.png); background-size: cover;background-position: center; background-color: #fff;">
                        <!-- begin:: Content Head -->
                        <div class="kt-subheader   kt-grid__item" id="kt_subheader">
                            <div class="kt-subheader   kt-grid__item" id="kt_subheader">
                                <div class="kt-subheader__main">
                                    <h3 class="kt-subheader__title">Home</h3>
                                    <span class="kt-subheader__separator kt-subheader__separator--v"></span>
                                    <a class="kt-subheader__breadcrumbs-link"><%=Utility.titlepro%></a>
                                </div>
                            </div>
                        </div>
                        <br>
                        <div class="tab-content" style="margin-right: 10px;">
                            <div class="row">
                                <div class="col-xl-8 col-lg-6 col-md-6" style="padding-right: 0px;">
                                    <div class="row flex col-lg-12"  style="margin-right: 0px; padding-right: 0px;">
                                        <%
                                            String[] contatori = Action.contatoriHome();
                                        %>
                                        <div class="col-md-6" style="padding-bottom: 1.5rem;">
                                            <a href="<%=src%>/page/mc/searchAllieviMicro.jsp"> <div class="one-half custom-redbox">Allievi<br>
                                                    <label style="font-size: 3rem; font-weight: 800;"><%=contatori[0]%></label></div></a>
                                        </div>
                                        <div class="col-md-6" style="padding-bottom: 1.5rem;">
                                            <a href="<%=src%>/page/mc/searchAllieviMicro.jsp"> <div class="one-half custom-greenbox">Allievi formati<br>
                                                    <label style="font-size: 3rem; font-weight: 800;"><%=contatori[1]%></label></div></a>
                                        </div>
                                        <div class="col-md-6" style="padding-bottom: 1.5rem;">
                                            <a href="<%=src%>/page/mc/searchAllieviMicro.jsp"> <div class="one-half custom-bluebox allievi">Allievi in formazione<br>
                                                    <label style="font-size: 3rem; font-weight: 800;"><%=contatori[2]%></label></div></a>
                                        </div>
                                        <div class="col-md-6" style="padding-bottom: 1.5rem;">
                                            <a href="<%=src%>/page/mc/searchAllieviMicro.jsp"> <div class="one-half custom-bluebox allievi">Allievi in fase di avvio<br>
                                                    <label style="font-size: 3rem; font-weight: 800;"><%=contatori[3]%></label></div></a>
                                        </div>
                                        <div class="col-md-12" style="padding-bottom: 1.5rem;">
                                            <hr>
                                        </div>

                                        
                                        <div class="col-xl-6 col-lg-12 col-md-6" style="padding-bottom: 1.5rem;">
                                            <a href="<%=src%>/page/mc/searchPFMicro.jsp"><div class="one-half custom-greenbox pf">Progetti formativi<br>
                                                    <label style="font-size: 3rem; font-weight: 800;"><%=contatori[4]%></label></div></a>
                                        </div>
                                        <div class="col-xl-6 col-lg-12 col-md-6" style="padding-bottom: 1.5rem;">
                                            <a href="<%=src%>/page/mc/searchPFMicro.jsp"><div class="one-half custom-redbox terminati">Progetti formativi conclusi<br>
                                                    <label style="font-size: 3rem; font-weight: 800;"><%=contatori[5]%></label></div></a>
                                        </div>
                                        <div class="col-xl-6 col-lg-12 col-md-6" style="padding-bottom: 1.5rem;">
                                            <a href="<%=src%>/page/mc/searchPFMicro.jsp"><div class="one-half custom-yellowbox">Progetti formativi a controllo<br>
                                                    <label style="font-size: 3rem; font-weight: 800;"><%=contatori[6]%></label></div></a>
                                        </div>
                                        <div class="col-xl-6 col-lg-12 col-md-6" style="padding-bottom: 1.5rem;">
                                            <a href="<%=src%>/page/mc/searchPFMicro.jsp"><div class="one-half custom-redbox terminati">Progetti Annullati<br>
                                                    <label style="font-size: 3rem; font-weight: 800;"><%=contatori[7]%></label></div></a>
                                        </div>
                                        <div class="col-md-12" style="padding-bottom: 1.5rem;">
                                            <hr>
                                        </div>
                                        <div class="col-xl-6 col-lg-12 col-md-6" style="padding-bottom: 1.5rem;">
                                            <a href="<%=src%>/page/mc/searchSA.jsp"><div class="one-half custom-bluebox">Soggetti attuatori<br><label style="font-size: 3rem; font-weight: 800;"><%=count_sa%></label></div></a>
                                        </div>
                                        <div class="col-xl-6 col-lg-12 col-md-6" style="padding-bottom: 1.5rem;">
                                            <a href="<%=src%>/page/mc/saFAQ.jsp"><div class="one-half custom-yellowbox faq">FAQ da rispondere<br><label style="font-size: 3rem; font-weight: 800;"><%=messaggi%></label></div></a>
                                        </div>
                                    </div>
                                    <div class="row flex col-lg-12"  style="margin-right: 0px; padding-right: 0px;">
                                        <div class="col-xl-12 col-lg-12 col-md-12">
                                            <a href="javascript:void(0);" onclick='uploadDoc("docenti", "[\"xlx\", \"xlsx\"]", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");'>
                                                <!--<div class="kt-portlet kt-iconbox kt-iconbox--primary kt-iconbox--animate-fast">-->
                                                <div class="one-half custom-greybox docente">
                                                    <div class="kt-portlet__body">
                                                        <div class="center col-lg-6">
                                                            <div class="row">
                                                                <div class="col-lg-12">
                                                                    <div class="text-center" style="font-size: 3rem;">
                                                                        Docenti
                                                                    </div>
                                                                    <h3 class="kt-iconbox__title text-center" style="font-size: 1rem;">
                                                                        Carica file excel
                                                                    </h3>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xl-4 col-lg-6 col-md-6" style="padding-left: 0px;">
                                    <div class="kt-portlet kt-portlet--height-fluid" style="border-radius: 5px; display:block;">
                                        <div class="kt-portlet__head">
                                            <div class="kt-portlet__head-label">
                                                <h3 class="kt-portlet__head-title kt-font-io">
                                                    Bacheca
                                                </h3>
                                            </div>
                                            <div class="kt-portlet__head-toolbar" >
                                                <ul class="nav nav-pills nav-pills-sm nav-pills-label nav-pills-bold" role="tablist">
                                                    <li class="nav-item">
                                                        <a class="nav-link active" data-toggle="tab" href="#sat" role="tab">
                                                            Soggetti Attuatori
                                                        </a>
                                                    </li>
                                                    <li class="nav-item" >
                                                        <a class="nav-link" data-toggle="tab" href="#export" role="tab">
                                                            Esportazioni
                                                        </a>
                                                    </li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="kt-portlet__body" >
                                            <div class="tab-content">
                                                <div class="tab-pane active kt-scroll" id="sat" style="max-height: 550px;" aria-expanded="true">
                                                    <div class="accordion accordion-solid accordion-toggle-plus " id="accordionExample6" >
                                                        <%for (SoggettiAttuatori s : sa_wait) {%>
                                                        <div class="card" style="border-radius: 5px;">
                                                            <div class="card-header" id="heading<%=s.getId()%>" >
                                                                <div class="card-title collapsed kt-font-io " style="background-color:#ffb61d99;" data-toggle="collapse" data-target="#collapse<%=s.getId()%>" aria-expanded="false" aria-controls="collapse<%=s.getId()%>">
                                                                    <i class="fa fa-info-circle kt-font-io" data-container='body' data-toggle='kt-tooltip' data-placement='top' title='In attesa di accreditamento' style="font-size: 2rem;"></i> <b><%=s.getRagionesociale()%></b>
                                                                </div>
                                                            </div>
                                                            <div id="collapse<%=s.getId()%>" class="collapse" aria-labelledby="heading<%=s.getId()%>" data-parent="#accordionExample6">
                                                                <div class="card-body kt-font-io" style="border-radius: 5px;">
                                                                    <div class="row ">
                                                                        <div class="col-lg-8">
                                                                            <h5>
                                                                                <a href="<%=src%>/page/mc/schedaSA.jsp?id=<%=s.getId()%>" class="fancyProfileNoRef" > 
                                                                                    <i class="fa fa-address-card" style="font-size: 1.5rem;"></i>
                                                                                    Scheda S.A.
                                                                                </a>
                                                                            </h5>
                                                                        </div>
                                                                        <div class="col-lg-4">
                                                                            <h5>
                                                                                <a href="javascript:void(0);" onclick="setProtocollo(<%=s.getId()%>);" >
                                                                                    <i class="fa fa-edit" style="font-size: 1.5rem;"></i>
                                                                                    Protocolla 
                                                                                </a>
                                                                            </h5>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <%}%>
                                                        <%for (SoggettiAttuatori s : lsa) {
                                                                bgc = i % 2 == 0 ? "background-color: #46c8ef38" : "background-color: #089eff52";
                                                                i++;%>
                                                        <div class="card" style="border-radius: 5px;">
                                                            <div class="card-header" id="heading<%=s.getId()%>" >
                                                                <div class="card-title collapsed kt-font-io " style="<%=bgc%>" data-toggle="collapse" data-target="#collapse<%=s.getId()%>" aria-expanded="false" aria-controls="collapse<%=s.getId()%>">
                                                                    <i class="flaticon-presentation-1 kt-font-io" style="font-size: 2rem;"></i> <b><%=s.getRagionesociale()%></b>
                                                                </div>
                                                            </div>
                                                            <div id="collapse<%=s.getId()%>" class="collapse" aria-labelledby="heading<%=s.getId()%>" data-parent="#accordionExample6">
                                                                <div class="card-body kt-font-io" style="border-radius: 5px;">
                                                                    <div class="row ">
                                                                        <div class="col-lg-8">
                                                                            <h5>Progetti formativi: <%=s.getProgettiformativi().size()%></h5>
                                                                        </div>
                                                                        <div class="col-lg-4">
                                                                            <h5><i class="flaticon-users-1" style="font-size: 1.5rem;"></i> Allievi: <%=s.getAllievi().size()%></h5>
                                                                        </div>
                                                                    </div>
                                                                    <%requirementCountMap = Utility.GroupByAndCount(s);
                                                                        for (Map.Entry<StatiPrg, Long> sd : requirementCountMap.entrySet()) {
                                                                            styles = Utility.styleMicro(sd.getKey());
                                                                    %>
                                                                    <h6>
                                                                        <a href="<%=src%>/page/mc/searchPFMicro.jsp?tipo=<%=sd.getKey().getTipo()%>&sa=<%=s.getId()%>" style="<%=styles[0]%>">
                                                                            <span class="fa-stack">
                                                                                <span class="fa fa-circle fa-stack-2x" style="<%=styles[0]%>"></span>
                                                                                <strong class="fa-stack-1x kt-font-white">
                                                                                    <%=sd.getValue()%>    
                                                                                </strong>
                                                                            </span>
                                                                            &nbsp;&nbsp;<%=styles[1]%>
                                                                        </a>
                                                                    </h6>
                                                                    <%}%>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <%}%>
                                                    </div>
                                                </div>
                                                <div class="tab-pane" id="export" aria-expanded="false">
                                                    <div class="kt-notification">
                                                        <a href="<%=request.getContextPath()%>/OperazioniGeneral?type=downloadDoc&path=<%=ex_allievi%>" 
                                                           class="kt-notification__item kt-notification__item2">
                                                            <div class="kt-notification__item-icon">
                                                                <i class="fa fa-file-excel" style="font-size: 2rem; color: #006b4c;"></i>
                                                            </div>
                                                            <div class="kt-notification__item-details ">
                                                                <div class="kt-notification__item-title" style="color: #006b4c;">
                                                                    <b style="font-size: 15px;">Esportazione Excel</b>
                                                                </div> 
                                                                <div class="kt-notification__item-time kt-font-io">
                                                                    <b>Lista Allievi</b><br>
                                                                </div>
                                                            </div>
                                                        </a>
                                                    </div>
                                                    <div class="kt-notification">
                                                        <a href="<%=request.getContextPath()%>/OperazioniGeneral?type=downloadDoc&path=<%=ex_docenti%>" class="kt-notification__item kt-notification__item2">
                                                            <div class="kt-notification__item-icon">
                                                                <i class="fa fa-file-excel" style="font-size: 2rem; color: #006b4c;"></i>
                                                            </div>
                                                            <div class="kt-notification__item-details ">
                                                                <div class="kt-notification__item-title" style="color: #006b4c;">
                                                                    <b style="font-size: 15px;">Esportazione Excel</b>
                                                                </div> 
                                                                <div class="kt-notification__item-time kt-font-io">
                                                                    <b>Lista Docenti</b><br>
                                                                </div>
                                                            </div>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                    </div> 
                                </div>

                            </div>      
                            <!-- end:: Content Head -->
                            <a id="chgPwd" href="<%=src%>/page/personal/chgPwd.jsp" class="btn btn-outline-brand btn-sm fancyProfileNoClose" style="display:none;"></a>
                        </div>
                        <!-- end:: Footer -->
                        <!-- end:: Content -->
                    </div>
                    <%@ include file="menu/footer.jsp"%>
                    <div class="modal fade" tabindex="-1" role="dialog" aria-hidden="true">
                        <button id="showmod1" type="button" class="btn btn-outline-brand btn-sm" data-toggle="modal" data-target="#kt_modal_6">Launch Modal</button>
                    </div>
                    <div class="modal fade" id="kt_modal_6" tabindex="-1" role="dialog" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered modal-xl" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="text_modal_title"></h5>
                                    <button type="button" id='close_kt_modal_6' class="close" data-target="#kt_modal_6" data-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body" id="text_modal_html"></div>
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
            <script src="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.js" type="text/javascript"></script>
            <script src="<%=src%>/assets/app/bundle/app.bundle.js" type="text/javascript"></script>
            <script src="<%=src%>/assets/soop/js/utility.js" type="text/javascript"></script>
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

                                                                                    $('.kt-scroll').each(function () {
                                                                                        const ps = new PerfectScrollbar($(this)[0]);
                                                                                    });
            </script>

            <script>
                var context = '<%=request.getContextPath()%>';
                $.getScript(context + '/page/partialView/partialView.js', function () {});
                function uploadDoc(tipo, estensione, mime_type) {
                    var url = context + "/OperazioniMicro?type=addDocenteFile";
                    var titolo = 'Carica file Excel - Sedi di formazione';
                    if (tipo === 'docenti') {
                        url = context + "/OperazioniMicro?type=addDocenteFile";
                        titolo = 'Carica file Excel - Docenti';
                    }
                    var ext = estensione.split('"').join("&quot;");
                    var swalDoc = getHtml("swalDoc", context).replace("@func", "checkFileExtAndDim(" + ext + ");").replace("@mime", mime_type);
                    swal.fire({
                        title: titolo,
                        html: swalDoc,
                        animation: false,
                        showCancelButton: true,
                        confirmButtonText: '&nbsp;<i class="la la-check"></i>',
                        cancelButtonText: '&nbsp;<i class="la la-close"></i>',
                        cancelButtonClass: "btn btn-io-n",
                        confirmButtonClass: "btn btn-io",
                        customClass: {
                            popup: 'animated bounceInUp'
                        },
                        onOpen: function () {
                            $('#file').change(function (e) {
                                if (e.target.files.length != 0)
                                    //$('#label_doc').html(e.target.files[0].name);
                                    if (e.target.files[0].name.length > 30)
                                        $('#label_doc').html(e.target.files[0].name.substring(0, 30) + "...");
                                    else
                                        $('#label_doc').html(e.target.files[0].name);
                                else
                                    $('#label_doc').html("Seleziona File");
                            });
                        },
                        preConfirm: function () {
                            var err = false;
                            err = !checkRequiredFileContent($('#swalDoc')) ? true : err;
                            if (!err) {
                                return new Promise(function (resolve) {
                                    resolve({
                                        "file": $('#file')[0].files[0]
                                    });
                                });
                            } else {
                                return false;
                            }
                        },
                    }).then((result) => {
                        if (result.value) {
                            showLoad();
                            var fdata = new FormData();
                            fdata.append("file", result.value.file);
                            $.ajax({
                                type: "POST",
                                url: url,
                                data: fdata,
                                processData: false,
                                contentType: false,
                                success: function (data) {
                                    closeSwal();
                                    var json = JSON.parse(data);
                                    if (json.result) {
                                        swalSuccess("Docenti Caricati", "Docenti caricati con successo." + (json.message = !"" ? "<br>" + json.message : ""));
                                    } else {
                                        swalError("Errore", json.message);
                                    }
                                },
                                error: function () {
                                    swalError("Errore", "Non è stato possibile modificare il documento");
                                }
                            });
                        } else {
                            swal.close();
                        }
                    });
                }

                function setProtocollo(id) {
                    swal.fire({
                        title: 'Inserisci protocollo',
                        html: "<input class='form-control' id='new_protocollo' name='new_protocollo' placeholder='protocollo' ><br>"
                                + "<input class='form-control dp' id='dataprotocollo' name='dataprotocollo' placeholder='data protocollo' value='" + formattedDate(new Date()) + "'>",
                        animation: false,
                        showCancelButton: true,
                        confirmButtonText: '&nbsp;<i class="la la-check"></i>',
                        cancelButtonText: '&nbsp;<i class="la la-close"></i>',
                        cancelButtonClass: "btn btn-io-n",
                        confirmButtonClass: "btn btn-io",
                        customClass: {
                            popup: 'animated bounceInUp'
                        },
                        onOpen: function () {
                            $('input.dp').datepicker({
                                rtl: KTUtil.isRTL(),
                                orientation: "bottom left",
                                todayHighlight: true,
                                autoclose: true,
                                format: 'dd/mm/yyyy',
                            });
                        },
                        preConfirm: function () {
                            var protocollo = $('#new_protocollo');
                            var data = $('#dataprotocollo');
                            var err = false;
                            err = checkValue(protocollo, false) ? true : err;
                            err = checkValue(data, false) ? true : err;
                            if (!err) {
                                return new Promise(function (resolve) {
                                    resolve([
                                        protocollo.val(),
                                        data.val(),
                                    ]);
                                });
                            } else {
                                return false;
                            }
                        },
                    }).then((result) => {
                        if (result.value) {
                            showLoad();
                            $.ajax({
                                type: "GET",
                                url: '<%=request.getContextPath()%>/OperazioniMicro?type=setProtocollo&id=' + id + '&protocollo=' + result.value[0] + '&data=' + result.value[1],
                                success: function (data) {
                                    closeSwal();
                                    var json = JSON.parse(data);
                                    if (json.result) {
                                        swalSuccessReload('Successo', 'Protocollo assegnato con successo');
                                    } else {
                                        swal.fire({
                                            "title": 'Errore',
                                            "text": json.message,
                                            "type": "error",
                                            cancelButtonClass: "btn btn-io-n",
                                        });
                                    }
                                }
                            });
                        } else {
                            swal.close();
                        }
                    }
                    );
                }

                function fancyBoxClose() {
                    $('div.fancybox-overlay.fancybox-overlay-fixed').css('display', 'none');
                }
                jQuery(document).ready(function () {
                <%if (us.getStato() == 2) {%>
                    $('#chgPwd')[0].click();
                <%}%>
                });

                <%if (request.getParameter("fileNotFound") != null) {%>
                swalError("<h2>File Non Trovato<h2>", "<h4>Il file richiesto non esiste.</h4>");
                <%}%>
            </script>
    </body>
</html>
<%
        }
    }
%>