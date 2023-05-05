<%-- 
    Document   : menu
    Created on : 18-giu-2019, 9.14.36
    Author     : rcosco
--%>

<%
    String uri = request.getRequestURI();
    String pageName = uri.substring(uri.lastIndexOf("/") + 1);
    String home = "", allievi = "", progettiformativi = "", docenti = "", cloud="", faq="";

    switch (pageName) {
        case "indexSoggettoAttuatore.jsp":
            home = "kt-menu__item--active";
            break;
        case "searchAllievi.jsp":
        case "newAllievo.jsp":
            allievi = "kt-menu__item--open kt-menu__item--here";
            break;
        case "searchProgettiFormativi.jsp":
        case "newProgettoFormativo.jsp":
            progettiformativi = "kt-menu__item--open kt-menu__item--here";
            break;
        case "searchDocenti_sa.jsp":
            docenti = "kt-menu__item--open kt-menu__item--here";
            break;
        case "downloadModelli.jsp":
            cloud = "kt-menu__item--open kt-menu__item--here";
            break;
        case "myFAQ.jsp":
        case "allFAQ.jsp":
            faq = "kt-menu__item--open kt-menu__item--here";
            break;
        default:
            break;
    }

%>
<!DOCTYPE html>
<div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--ver kt-page">
    <!-- begin:: Aside -->
    <button class="kt-aside-close " id="kt_aside_close_btn"><i class="la la-close"></i></button>
    <div class="kt-aside  kt-aside--fixed  kt-grid__item kt-grid kt-grid--desktop kt-grid--hor-desktop" id="kt_aside">

        <!-- begin:: Aside -->
        <div class="kt-aside__brand kt-grid__item " id="kt_aside_brand">
            <div class="kt-aside__brand-logo">
                <a href="indexSoggettoAttuatore.jsp">
                    <img src="<%=src%>/assets/media/logos/logo_pages.png" width="150" style="padding-top: 10px;" alt=""/>
                </a>
            </div>
            <div class="kt-aside__brand-tools">
                <button class="kt-aside__brand-aside-toggler" id="kt_aside_toggler">
                    <%@include file="arrow.html" %>
                </button>
            </div>
        </div>
        <!-- end:: Aside -->
        <!-- begin:: Aside Menu -->
        <div class="kt-aside-menu-wrapper kt-grid__item kt-grid__item--fluid" id="kt_aside_menu_wrapper">
            <div id="kt_aside_menu" class="kt-aside-menu " data-ktmenu-vertical="1" data-ktmenu-scroll="1" data-ktmenu-dropdown-timeout="500">
                <ul class="kt-menu__nav ">
                    <li class="kt-menu__item  <%=home%>" aria-haspopup="true">
                        <a href="indexSoggettoAttuatore.jsp" class="kt-menu__link ">
                            <span class="kt-menu__link-icon"><i class="flaticon-home-2"></i></span>
                            <span class="kt-menu__link-text">Home</span>
                        </a>
                    </li>
                    <%if (us.getTipo() == 1) {%>
                    <!--inserire menu qua dentro-->
                    <%@include file="general/allievi.jsp" %>
                    <%@include file="general/docenti.jsp" %>
                    <%@include file="general/progettiformativi.jsp" %>
                    <%@include file="general/Cloud.jsp" %>
                    <%@include file="general/faq.jsp" %>
                    <%}%>
                </ul>
            </div>
        </div>

    </div>
    <!-- end:: Aside Menu -->