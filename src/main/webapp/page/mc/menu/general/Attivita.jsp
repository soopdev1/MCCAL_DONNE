<li class="kt-menu__item <%=activity%>" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
    <a href="javascript:;" class="kt-menu__link kt-menu__toggle">
        <span class="kt-menu__link-icon"><i class="fa fa-map-marker-alt"></i></span>
        <span class="kt-menu__link-text">Attività</span>
        <i class="kt-menu__ver-arrow la la-angle-right"></i>
    </a>
    <div class="kt-menu__submenu">
        <span class="kt-menu__arrow"></span>
        <ul class="kt-menu__subnav">
            <li class="kt-menu__item <%=pageName.equals("addActivity.jsp") ? "kt-menu__item--active" : ""%>" aria-haspopup="true">
                <a href="addActivity.jsp" class="kt-menu__link ">
                    <i class="kt-menu__link-bullet fas fa-plus">
                        <span></span>
                    </i>
                    <span class="kt-menu__link-text">Aggiungi</span>
                </a>
            </li>
            <li class="kt-menu__item <%=pageName.equals("searchActivity.jsp") ? "kt-menu__item--active" : ""%>" aria-haspopup="true">
                <a href="searchActivity.jsp" class="kt-menu__link ">
                    <i class="kt-menu__link-bullet fa fa-list">
                        <span></span>
                    </i>
                    <span class="kt-menu__link-text">Cerca</span>
                </a>
            </li>
            <li class="kt-menu__item <%=pageName.equals("showActivity.jsp") ? "kt-menu__item--active" : ""%>" aria-haspopup="true">
                <a href="showActivity.jsp" class="kt-menu__link ">
                    <i class="kt-menu__link-bullet fa fa-map-marked-alt">
                        <span></span>
                    </i>
                    <span class="kt-menu__link-text">Visualizza</span>
                </a>
            </li>
        </ul>
    </div>
</li>