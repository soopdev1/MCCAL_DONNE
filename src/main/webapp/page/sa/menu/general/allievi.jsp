<%-- 
    Document   : allievi
    Created on : 25-ott-2019, 15.51.49
    Author     : rcosco
--%>

<li class="kt-menu__item <%=allievi%>" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
    <a href="javascript:;" class="kt-menu__link kt-menu__toggle">
        <span class="kt-menu__link-icon"><i class="flaticon-users-1"></i></span>
        <span class="kt-menu__link-text">Allievi</span>
        <i class="kt-menu__ver-arrow la la-angle-right"></i>
    </a>
    <div class="kt-menu__submenu">
        <span class="kt-menu__arrow"></span>
        <ul class="kt-menu__subnav">
            <li class="kt-menu__item <%=pageName.equals("newAllievo.jsp") ? "kt-menu__item--active" : ""%>" aria-haspopup="true">
                <a href="newAllievo.jsp" class="kt-menu__link ">
                    <i class="kt-menu__link-bullet fa fa-user-plus">
                        <span></span>
                    </i>
                    <span class="kt-menu__link-text">Aggiungi</span>
                </a>
            </li>
            <li class="kt-menu__item <%=pageName.equals("searchAllievi.jsp") ? "kt-menu__item--active" : ""%>" aria-haspopup="true">
                <a href="searchAllievi.jsp" class="kt-menu__link ">
                    <i class="kt-menu__link-bullet fa fa-search">
                        <span></span>
                    </i>
                    <span class="kt-menu__link-text">Cerca</span>
                </a>
            </li>
            
        </ul>
    </div>
</li>