$(
    function(){
        var remove_fields = document.getElementsByClassName('remove_fields');
        for(var i = 0; i < remove_fields.length; i++)
        {
            $(remove_fields[i]).click(function(e)
            {
                console.log("remove_fields is called")
                $(this).prev('input[type=hidden]').val('1')
                $(this).closest('fieldset').hide()
                e.preventDefault()
            });
        }

        var add_fields = document.getElementsByClassName('add_fields');
        for(var i = 0; i < add_fields.length; i++)
        {
            $(add_fields[i]).click(function(e)
            {
                time = new Date().getTime()
                regexp = new RegExp($(this).data('id'), 'g')
                $(this).before($(this).data('fields').replace(regexp, time))
                e.preventDefault()
            });
        }


    }

)