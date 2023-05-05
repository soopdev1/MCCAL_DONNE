<%@page import="java.util.Date"%>
<!-- begin:: Header -->
<%String no_cache = "?dummy=" + String.valueOf(new Date().getTime());%>
<div id="kt_header" class="kt-header kt-grid__item  kt-header--fixed ">
    <!-- begin:: Header Menu -->
    <button class="kt-header-menu-wrapper-close" id="kt_header_menu_mobile_close_btn"><i class="la la-close"></i></button>
    <div class="kt-header-menu-wrapper " id="kt_header_menu_wrapper">
        <div style="display: inline-block;  vertical-align: middle;  line-height: normal;"> 
            <a href="#" onclick="return false;">
                <img  height="75" style="padding-left: 10px;padding-top:10px;"title="" src="<%=src%>/assets/media/logos/Loghi_donne_v2.jpg">
            </a>
        </div>
    </div>
    <!-- end:: Header Menu -->
    <!-- begin:: Header Topbar -->
    <div class="kt-header__topbar">
        <!--begin: User Bar -->
        <div class="kt-header__topbar-item kt-header__topbar-item--user">
            <div class="kt-header__topbar-wrapper" data-toggle="dropdown" data-offset="0px,0px">
                <div class="kt-header__topbar-user">
                    <span class="kt-header__topbar-welcome kt-hidden-mobile">Ciao,</span>
                    <span class="kt-header__topbar-username kt-hidden-mobile"><%=us.getSoggettoAttuatore().getRagionesociale()%></span>
                    <!--use below badge element instead the user avatar to display username's first letter(remove kt-hidden class to display it) -->
                    <span class="kt-badge kt-badge--username kt-badge--unified-io kt-badge--lg kt-badge--rounded kt-badge--bold">
                        <%=us.getSoggettoAttuatore().getRagionesociale().substring(0, 1).toUpperCase()%>
                    </span>
                </div>
            </div>
            <div class="dropdown-menu dropdown-menu-fit dropdown-menu-right dropdown-menu-anim dropdown-menu-top-unround dropdown-menu-xl">
                <!--begin: Head -->
                <div class="kt-user-card kt-user-card--skin-dark kt-notification-item-padding-x"
                     style="background-image: url(<%=src%>/assets/media/bg/bg-3.jpg);background-position: left bottom ;background-repeat: repeat-x;">
                    <div class="kt-user-card__avatar">
                        <span class="kt-badge kt-badge--lg kt-badge--rounded kt-badge--bold kt-font-io"> <i class="flaticon-presentation-1"></i></span>
                    </div>
                    <div class="kt-user-card__name kt-font-io">
                        <%=us.getSoggettoAttuatore().getRagionesociale()%>
                    </div>
                    <div class="kt-user-card__badge">
                        <a href="<%=request.getContextPath()%>/Login?type=logout" id="a_logout" class="btn btn-io btn-bold" data-container="body" data-toggle="kt-popover" data-placement="bottom" data-content="Esci">
                            <i class="flaticon-logout" style="padding: 0;"></i>
                        </a>
                        <!--                        <a href="../profile.jsp" class="btn btn-io btn-bold fancyBoxRaf" data-container="body" data-toggle="kt-popover" data-placement="bottom" data-content="Modifica Profilo">
                                                    <i class="flaticon2-user" style="padding: 0;"></i>
                                                </a>-->
                    </div>

                </div>
                <div class="kt-notification">
                    <a href="<%=src%>/page/personal/profile.jsp" class="kt-notification__item fancyProfile" style="margin-bottom: 0px;">
                        <div class="kt-notification__item-icon">
                            <i class="flaticon2-calendar-3 kt-font-io-n"></i>
                        </div>
                        <div class="kt-notification__item-details">
                            <div class="kt-notification__item-title kt-font-bold">
                                Profilo Personale
                            </div>
                            <div class="kt-notification__item-time">
                                Informazioni e altro
                            </div>
                        </div>
                    </a>     
                    <a href="<%=src%>/page/personal/chgPwd.jsp?active=yes" class="kt-notification__item fancyProfile" style="margin-bottom: 0px;">
                        <div class="kt-notification__item-icon">
                            <i class="flaticon2-gear kt-font-io-n"></i>
                        </div>
                        <div class="kt-notification__item-details">
                            <div class="kt-notification__item-title kt-font-bold">
                                Password
                            </div>
                            <div class="kt-notification__item-time">
                                Cambia
                            </div>
                        </div>
                    </a>
                    <a href="<%=src%>/OperazioniGeneral?type=downloadDoc&path=<%=session.getAttribute("guida").toString()%>" class="kt-notification__item" style="margin-bottom: 0px;">
                        <div class="kt-notification__item-icon">
                            <i class="flaticon-book kt-font-io-n"></i>
                        </div>
                        <div class="kt-notification__item-details">
                            <div class="kt-notification__item-title kt-font-bold">
                                Manuale Operativo
                            </div>
                            <div class="kt-notification__item-time">
                                Guida all'utilizzo della piattaforma
                            </div>
                        </div>
                    </a>    
                </div>
                <!--end: Head -->
            </div>
        </div>
        <!--end: User Bar -->
    </div>
    <!-- end:: Header Topbar -->
</div>
<!-- end:: Header -->
<link href="<%=src%>/assets/soop/css/jquery.fancybox.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="<%=src%>/assets/soop/js/jquery-1.10.1.min.js"></script>
<script type="text/javascript" src="<%=src%>/assets/soop/js/jquery.fancybox.js?v=2.1.5"></script>
<script type="text/javascript" src="<%=src%>/assets/soop/js/fancy.js"></script>