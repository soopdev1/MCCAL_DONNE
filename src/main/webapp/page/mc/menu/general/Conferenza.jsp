<%-- 
    Document   : rubrica
    Created on : 18-giu-2019, 9.23.22
    Author     : rcosco
--%>
<li class="kt-menu__item <%=fad%>" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
    <a href="javascript:;" class="kt-menu__link kt-menu__toggle">
        <span class="kt-menu__link-icon"><i class="fa fa-video"></i></span>
        <span class="kt-menu__link-text">Conferenze</span>
        <i class="kt-menu__ver-arrow la la-angle-right"></i>
    </a>
    <div class="kt-menu__submenu">
        <span class="kt-menu__arrow"></span>
        <ul class="kt-menu__subnav">
            <li class="kt-menu__item <%=pageName.equals("createFADconference.jsp") ? "kt-menu__item--active" : ""%>" aria-haspopup="true">
                <a href="createFADconference.jsp" class="kt-menu__link ">
                    <i class="kt-menu__link-bullet fa fa-play">
                        <span></span>
                    </i>
                    <span class="kt-menu__link-text">Crea</span>
                </a>
            </li>
            <li class="kt-menu__item <%=pageName.equals("myConference.jsp") ? "kt-menu__item--active" : ""%>" aria-haspopup="true">
                <a href="myConference.jsp" class="kt-menu__link ">
                    <i class="kt-menu__link-bullet fa fa-list">
                        <span></span>
                    </i>
                    <span class="kt-menu__link-text">Le Mie Conferenze</span>
                </a>
            </li>
        </ul>
    </div>
</li>