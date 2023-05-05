function load_table(table, url) {
    table.DataTable().ajax.url(url).load();
}

function reload_table(table){
    table.DataTable().ajax.reload(null, false);
}

function clear_table(table){
    table.DataTable().clear().draw();
}

