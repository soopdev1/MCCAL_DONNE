<%-- 
    Document   : rubrica
    Created on : 18-giu-2019, 9.23.22
    Author     : rcosco
--%>
<li class="kt-menu__item <%=docenti%>" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
    <a href="javascript:;" class="kt-menu__link kt-menu__toggle">
        <span class="kt-menu__link-icon"><i class="fa fa-user-tie"></i></span>
        <span class="kt-menu__link-text">Docenti</span>
        <i class="kt-menu__ver-arrow la la-angle-right"></i>
    </a>
    <div class="kt-menu__submenu">
        <span class="kt-menu__arrow"></span>
        <ul class="kt-menu__subnav">
            <li class="kt-menu__item <%=pageName.equals("uploadDocenti.jsp") ? "kt-menu__item--active" : ""%>" aria-haspopup="true">
                <a href="uploadDocenti.jsp" class="kt-menu__link ">
                    <i class="kt-menu__link-bullet fa fa-user-plus">
                        <span></span>
                    </i>
                    <span class="kt-menu__link-text">Carica</span>
                </a>
            </li>
            <li class="kt-menu__item <%=pageName.equals("searchDocenti.jsp") ? "kt-menu__item--active" : ""%>" aria-haspopup="true">
                <a href="searchDocenti.jsp" class="kt-menu__link ">
                    <i class="kt-menu__link-bullet fa fa-search">
                        <span></span>
                    </i>
                    <span class="kt-menu__link-text">Cerca</span>
                </a>
            </li>
        </ul>
    </div>
</li>