<%-- 
    Document   : rubrica
    Created on : 18-giu-2019, 9.23.22
    Author     : rcosco
--%>
<li class="kt-menu__item <%=cad%>" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
    <a href="javascript:;" class="kt-menu__link kt-menu__toggle">
        <span class="kt-menu__link-icon"><i class="fa fa-headset"></i></span>
        <span class="kt-menu__link-text">CAD</span>
        <i class="kt-menu__ver-arrow la la-angle-right"></i>
    </a>
    <div class="kt-menu__submenu">
        <span class="kt-menu__arrow"></span>
        <ul class="kt-menu__subnav">
            <li class="kt-menu__item <%=pageName.equals("createCad.jsp") ? "kt-menu__item--active" : ""%>" aria-haspopup="true">
                <a href="createCad.jsp" class="kt-menu__link ">
                    <i class="kt-menu__link-bullet fa fa-calendar-plus">
                        <span></span>
                    </i>
                    <span class="kt-menu__link-text">Crea</span>
                </a>
            </li>
            <li class="kt-menu__item <%=pageName.equals("myCad.jsp") ? "kt-menu__item--active" : ""%>" aria-haspopup="true">
                <a href="myCad.jsp" class="kt-menu__link ">
                    <i class="kt-menu__link-bullet fa fa-calendar-alt">
                        <span></span>
                    </i>
                    <span class="kt-menu__link-text">I Miei CAD</span>
                </a>
            </li>
        </ul>
    </div>
</li>