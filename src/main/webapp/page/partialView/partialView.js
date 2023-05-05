/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function getHtml(id, context) {
    var elem;
    $.ajax({
        async: false,
        url: context + '/page/partialView/Document.html',
        dataType: 'html',
        success: function (data) {
            $(data).each(function () {
                if (this.id === id) {
                    elem = $(this)[0].outerHTML;
                }
            });
        }
    });
    return elem;
}
