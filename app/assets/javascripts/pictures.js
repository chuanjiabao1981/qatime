//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/
$(
    function() {
        var options = {
            target:        '#output1',   // target element(s) to be updated with server response
            dataType:       'json',
//            beforeSubmit:  showRequest,  // pre-submit callback
            success:       showResponse,  // post-submit callback
            uploadProgress: function(event, position, total, percentComplete) {
                var percentVal = percentComplete + '%';
                $("div#progressbar").css({width:percentComplete});

            }

            // other available options:
            //url:       url         // override for form's 'action' attribute
            //type:      type        // 'get' or 'post', override for form's 'method' attribute
            //dataType:  null        // 'xml', 'script', or 'json' (expected server response type)
            //clearForm: true        // clear all form fields after successful submit
            //resetForm: true        // reset the form after successful submit

            // $.ajax options can be used here too, for example:
            //timeout:   3000
        };
        // bind 'myForm' and provide a simple callback function
        $("#picture_name").on(
            "change",
            function(){
                $("#new_picture").ajaxSubmit(options);

            }
        );
    }
);


// pre-submit callback
function showRequest(formData, jqForm, options) {
    // formData is an array; here we use $.param to convert it to a string to display it
    // but the form plugin does this for you automatically when it submits the data
    var queryString = $.param(formData);

    // jqForm is a jQuery object encapsulating the form element.  To access the
    // DOM element for the form do this:
    // var formElement = jqForm[0];

    alert('About to submit: \n\n' + queryString);

    // here we could return false to prevent the form from being submitted;
    // returning anything other than false will allow the form submit to continue
    return true;
}

// post-submit callback
function showResponse(responseText, statusText, xhr, $form)  {
    // for normal html responses, the first argument to the success callback
    // is the XMLHttpRequest object's responseText property

    // if the ajaxForm method was passed an Options Object with the dataType
    // property set to 'xml' then the first argument to the success callback
    // is the XMLHttpRequest object's responseXML property

    // if the ajaxForm method was passed an Options Object with the dataType
    // property set to 'json' then the first argument to the success callback
    // is the json data object returned by the server
//    alert(responseText.name.url);
//    alert(statusText);
    $('#pic_block').append("<img src="+responseText.name.url+"  style=\"width:64px;height:64px;\" />");
}