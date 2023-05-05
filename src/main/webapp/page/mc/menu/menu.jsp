<%-- 
    Document   : menu
    Created on : 18-giu-2019, 9.14.36
    Author     : rcosco
--%>

<%@page import="rc.soop.db.Entity"%>
<%
    String uri = request.getRequestURI();
    String pageName = uri.substring(uri.lastIndexOf("/") + 1);
    String home = "", sa = "", allievi = "", docenti = "", aule = "", progettoformativo = "", cloud = "", faq = "", fad = "", activity = "",
            cad = "";
    switch (pageName) {
        case "indexMicrocredito.jsp":
            home = "kt-menu__item--active";
            break;
        case "searchSA.jsp":
            sa = "kt-menu__item--open kt-menu__item--here";
            break;
        case "searchAllieviMicro.jsp":
            allievi = "kt-menu__item--open kt-menu__item--here";
            break;
        case "uploadDocenti.jsp":
        case "searchDocenti.jsp":
            docenti = "kt-menu__item--open kt-menu__item--here";
            break;
        case "uploadAule.jsp":
        case "searchAule.jsp":
            aule = "kt-menu__item--open kt-menu__item--here";
            break;
        case "searchPFMicro.jsp":
        case "extractFiles.jsp":
            progettoformativo = "kt-menu__item--open kt-menu__item--here";
            break;
        case "downloadModelli.jsp":
            cloud = "kt-menu__item--open kt-menu__item--here";
            break;
        case "saFAQ.jsp":
        case "mangeFAQ.jsp":
            faq = "kt-menu__item--open kt-menu__item--here";
            break;
        case "createFADconference.jsp":
        case "myConference.jsp":
            fad = "kt-menu__item--open kt-menu__item--here";
            break;
        case "createCad.jsp":
        case "myCad.jsp":
        case "addCpiUser.jsp":
        case "cpiUser.jsp":
            cad = "kt-menu__item--open kt-menu__item--here";
            break;
        case "addActivity.jsp":
        case "searchActivity.jsp":
        case "showActivity.jsp":
            activity = "kt-menu__item--open kt-menu__item--here";
            break;
        default:
            break;
    }

    Entity entity = new Entity();
    String a_cad = entity.getPath("abilitate_cad");
    entity.close();
%>
<!DOCTYPE html>
<div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--ver kt-page">
    <button class="kt-aside-close " id="kt_aside_close_btn"><i class="la la-close"></i></button>
    <div class="kt-aside  kt-aside--fixed  kt-grid__item kt-grid kt-grid--desktop kt-grid--hor-desktop" id="kt_aside">
        <div class="kt-aside__brand kt-grid__item " id="kt_aside_brand">
            <div class="kt-aside__brand-logo">
                <a href="indexMicrocredito.jsp">
                    <img src="<%=src%>/assets/media/logos/logo_pages.png" width="150" style="padding-top: 10px;" alt=""/>
                </a>
            </div>
            <div class="kt-aside__brand-tools">
                <button class="kt-aside__brand-aside-toggler" id="kt_aside_toggler">
                    <%@include file="arrow.html" %>
                </button>
            </div>
        </div>
        <div class="kt-aside-menu-wrapper kt-grid__item kt-grid__item--fluid" id="kt_aside_menu_wrapper">
            <div id="kt_aside_menu" class="kt-aside-menu " data-ktmenu-vertical="1" data-ktmenu-scroll="1" data-ktmenu-dropdown-timeout="500">
                <ul class="kt-menu__nav ">
                    <li class="kt-menu__item  <%=home%>" aria-haspopup="true">
                        <a href="indexMicrocredito.jsp" class="kt-menu__link ">
                            <span class="kt-menu__link-icon"><i class="flaticon-home-2"></i></span>
                            <span class="kt-menu__link-text">Home</span>
                        </a>
                    </li>
                    <%@include file="general/soggettiattuatori.jsp"%>
                    <%@include file="general/Aule.jsp"%>
                    <%@include file="general/Docenti.jsp"%>
                    <%@include file="general/Allievi.jsp"%>
                    <%@include file="general/ProgettiFormativi.jsp"%>
                    <%@include file="general/Cloud.jsp"%>
                    <%@include file="general/Faq.jsp"%>
                    <%@include file="general/Conferenza.jsp"%>
                    <%if (false) {%>
                    <%@include file="general/Attivita.jsp"%>
                    <%@include file="general/Cad.jsp"%>
                    <%}%>
                </ul>
            </div>
        </div>
    </div>