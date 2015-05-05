$(function(){
    $('div.card.course').tooltip()
})
$(function(){
        var $menu = $("ul#menu");

        $menu.menuAim({
            activate: activateSubmenu,
            deactivate: deactivateSubmenu,
            exitMenu: function() {return true}
        });
  }
);
$(document).click(function() {
    // Simply hide the submenu on any click. Again, this is just a hacked
    // together menu/submenu structure to show the use of jQuery-menu-aim.
    $(".submenu_popover").css("display", "none");
    $("a.maintainHover").removeClass("maintainHover");
});
function activateSubmenu(row) {
    var $menu = $("ul#menu");


    var $row = $(row),
        submenuId = $row.data("submenuId"),
        $submenu = $("#" + submenuId),
        height = $menu.outerHeight()* 1.5,
        width = $menu.outerWidth();

    // Show the submenu
    $submenu.css({
        display: "block",
        top: -1,
        left: width-3,   // main should overlay submenu
        height: height-4  // padding for main dropdown's arrow
    });
    console.log(row);

    // Keep the currently activated row's highlighted look
    $row.addClass("maintainHover");
}

function deactivateSubmenu(row) {

    var $row = $(row),
        submenuId = $row.data("submenuId"),
        $submenu = $("#" + submenuId);
    // Hide the submenu and remove the row's highlighted look
    $submenu.css("display", "none");
    $(row).removeClass("maintainHover")

}