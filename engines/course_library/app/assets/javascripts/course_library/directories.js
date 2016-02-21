// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function () {
    $('#dir_tree').jstree(eval("(" + $('#dir_tree_json').val() +")"));
    $('#dir_tree').on('changed.jstree', function (e, data) {
        if(data.action == 'select_node'){
            window.location.href = data.instance.get_node(data.selected[0]).a_attr.href;
        }
    })
});