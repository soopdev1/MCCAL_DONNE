<%@page import="rc.soop.domain.SoggettiAttuatori"%>
<%@page import="rc.soop.domain.Faq"%>
<%@page import="rc.soop.domain.CPI"%>
<%@page import="java.util.List"%>
<%@page import="rc.soop.db.Entity"%>
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
            List<Faq> faqs = e.faqNoAnswer();
            List<SoggettiAttuatori> soggetti = e.findAll(SoggettiAttuatori.class);
            e.close();
%>
<html>
    <head>
        <meta charset="utf-8" />
        <title><%=Utility.titlepro%> - FAQ</title>
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
        <!--this page-->
        <link href="<%=src%>/assets/vendors/general/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/bootstrap-select/dist/css/bootstrap-select.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/select2/dist/css/select2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/line-awesome/css/line-awesome.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/flaticon/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/flaticon2/flaticon.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/vendors/custom/vendors/fontawesome5/css/all.min.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/resource/animate.css" rel="stylesheet" type="text/css"/>
        <link href="<%=src%>/resource/faq.css" rel="stylesheet" type="text/css"/>
        <!----->
        <link href="<%=src%>/assets/demo/default/base/style.bundle.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/resource/custom.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/header/base/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/brand/light.css" rel="stylesheet" type="text/css" />
        <link href="<%=src%>/assets/demo/default/skins/aside/light.css" rel="stylesheet" type="text/css" />
        <link rel="shortcut icon" href="<%=src%>/assets/media/logos/favicon.ico" />

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
                    <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor">
                        <!-- begin:: Content Head -->
                        <div class="kt-subheader   kt-grid__item" id="kt_subheader">
                            <div class="kt-subheader   kt-grid__item" id="kt_subheader">
                                <div class="kt-subheader__main">
                                    <h3 class="kt-subheader__title">FAQ</h3>
                                    <span class="kt-subheader__separator kt-subheader__separator--v"></span>
                                    <a class="kt-subheader__breadcrumbs-link">Domande Enti</a>
                                </div>
                            </div>
                        </div>
                        <div class="kt-content  kt-grid__item kt-grid__item--fluid" id="kt_content">
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="kt-portlet" id="kt_portlet" data-ktportlet="true">
                                        <div class="kt-portlet__head">
                                            <div class="kt-portlet__head-label col-lg-8">
                                                <div class="col-lg-12">
                                                    <h3 class="kt-portlet__head-title text" >
                                                        FAQs:
                                                    </h3>
                                                </div>
                                            </div>
                                            <div class="kt-portlet__head-toolbar">
                                                <div class="kt-portlet__head-group">
                                                    <a href="#" data-ktportlet-tool="toggle" class="btn btn-sm btn-icon btn-clean btn-icon-md"><i class="la la-angle-down" id="toggle_search"></i></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="kt-portlet__body ">
                                            <div class="row">
                                                <div class="row col-12" style="margin-top: 0.5rem;">
                                                    <div class="col-lg-4 col-md-6 col-sm-12" style="margin: 0.5rem 0 1rem 0;">
                                                        <div class="input-group">
                                                            <div class="input-group-prepend">
                                                                <a class="btn btn-info btn-icon"><i class="fa fa-search"></i></a>
                                                            </div>
                                                            <input type="text" id="search" class="form-control" placeholder="Cerca ...">
                                                        </div>                                                       
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-12">
                                                    <h4 class="kt-section__title">Enti:</h4>
                                                    <div class="kt-separator kt-separator--border kt-separator--space-xs col-12"></div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="row col-12">
                                                    <%for (Faq f : faqs) {
                                                            if (f.getRisposta() == null) {
                                                                soggetti.remove(f.getSoggetto());%>
                                                    <div class="col-lg-4 col-md-6 col-sm-12 contatto" style="margin-top: 0.5rem;">
                                                        <div class="input-group">
                                                            <div class="input-group-prepend">
                                                                <a href="javascript:void(0);" onclick="showConversation(<%=f.getSoggetto().getId()%>, true)" class="btn btn-io-n btn-icon"><i class="fa fa-comment"></i></a>
                                                            </div>
                                                            <input type="text" class="form-control" readonly value="<%=f.getSoggetto().getRagionesociale()%>">
                                                            <div class="input-group-append">
                                                                <a class="btn btn-danger btn-icon"><i class="fa fa-exclamation"></i></a>
                                                            </div>
                                                        </div>                                                       
                                                    </div>
                                                    <%}
                                                        }
                                                        for (SoggettiAttuatori s : soggetti) {%>
                                                    <div class="col-lg-4 col-md-6 col-sm-12 contatto" style="margin-top: 0.5rem;">
                                                        <div class="input-group">
                                                            <div class="input-group-prepend">
                                                                <a href="javascript:void(0);" onclick="showConversation(<%=s.getId()%>, false)" class="btn btn-io btn-icon"><i class="fa fa-comment"></i></a>
                                                            </div>
                                                            <input type="text" class="form-control" readonly value="<%=s.getRagionesociale()%>">
                                                        </div>                                                       
                                                    </div>
                                                    <%}%>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- end:: Content Head -->
                    </div>
                    <%@ include file="menu/footer.jsp"%>
                </div>
            </div>
        </div>
        <!-- begin::Scrolltop -->
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
        <script src="<%=src%>/assets/vendors/custom/components/vendors/jquery-validation/init.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/vendors/general/sweetalert2/dist/sweetalert2.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/soop/js/utility.js" type="text/javascript"></script>
        <script src="<%=src%>/assets/app/bundle/app.bundle.js" type="text/javascript"></script>
        <!--this page -->
        <script id="myFAQ" src="<%=src%>/page/mc/js/saFAQ.js<%=no_cache%>" type="text/javascript" data-context="<%=request.getContextPath()%>"></script>
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

        </script>
    </body>
</html>
<%
        }
    }
%>