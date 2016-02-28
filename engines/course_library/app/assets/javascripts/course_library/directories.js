// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function () {
    $('#dir_tree').jstree(eval("(" + $('#dir_tree_json').val() +")"));
    $('#dir_tree').on('changed.jstree', function (e, data) {
        if(data.action == 'select_node'){
            window.location.href = data.instance.get_node(data.selected[0]).a_attr.href;
        }
    })
    //treeview for move directory and course
    $('.dir_tree_move').jstree(eval("(" + $('#dir_tree_move_json').val() +")"));
    $('.dir_tree_move').on('changed.jstree', function (e, data) {
        if(data.action == 'select_node'){
            select_dir_id = data.instance.get_node(data.selected[0]).id.split('_')[1]
            availabe_dirs = $(e.target).parents('.modal').find('#available_move_dir_ids_json').val().split('_');
            if($.inArray(select_dir_id, availabe_dirs) >= 0){
                $(e.target).parents('.modal').find('#fullpath')
                    .text(data.instance.get_node(data.selected[0]).a_attr.id)
                $(e.target).parents('.modal').find('#directory_parent_id')
                    .val(select_dir_id)
                $(e.target).parents('.modal').find('#course_directory_id')
                    .val(select_dir_id)
            }else{
                alert("不能移动到当前目录");
            }
        }
    })
});