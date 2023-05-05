<li class="kt-menu__item <%=faq%>" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
    <a href="javascript:;" class="kt-menu__link kt-menu__toggle">
        <span class="kt-menu__link-icon"><i class="fa fa-question-circle"></i></span>
        <span class="kt-menu__link-text">FAQ</span>
        <i class="kt-menu__ver-arrow la la-angle-right"></i>
    </a>
    <div class="kt-menu__submenu">
        <span class="kt-menu__arrow"></span>
        <ul class="kt-menu__subnav">
            <li class="kt-menu__item <%=pageName.equals("myFAQ.jsp") ? "kt-menu__item--active" : ""%>" aria-haspopup="true">
                <a href="myFAQ.jsp" class="kt-menu__link ">
                    <i class="kt-menu__link-bullet fa fa-comments">
                        <span></span>
                    </i>
                    <span class="kt-menu__link-text">Le Mie Domande</span>
                </a>
            </li>
            <li class="kt-menu__item <%=pageName.equals("allFAQ.jsp") ? "kt-menu__item--active" : ""%>" aria-haspopup="true">
                <a href="allFAQ.jsp" class="kt-menu__link ">
                    <i class="kt-menu__link-bullet fa fa-question">
                        <span></span>
                    </i>
                    <span class="kt-menu__link-text">FAQ</span>
                </a>
            </li>
        </ul>
    </div>
</li>