var jcrop_api,
    model_name;

// 上传头像js
function showimagepreview(input) {
    var model_avatar_id = input.id
    model_name = model_avatar_id.substr(0, model_avatar_id.length-7)
    if (input.files && input.files[0]) {
        var filerdr = new FileReader();

        filerdr.onload = function(e) {
            $('#user_avatar_preview').attr('src', e.target.result);

            var user_avatar_preview_height = $('#user_avatar_preview').height()
            $('#user_avatar_preview').parent().css({
                paddingTop : Math.round((240 - user_avatar_preview_height) / 2) + 'px'
            });
        }
        if (jcrop_api){
            jcrop_api.destroy();

        }
        filerdr.readAsDataURL(input.files[0]);
        filerdr.onloadend = function(e){
            $('#user_avatar_preview').Jcrop({
                bgFade:     true,
                bgOpacity: .4,
                aspectRatio: 1 ,
                setSelect: [ 0, 0, 240, 240 ],
                onSelect: updateCoords,
                onChange: updateCoords,
                keySupport : false
            },function(){
                jcrop_api = this;
            });
        }
    }
}
function updateCoords(coords)
{
    var model_name_crop = "#" + model_name + "_crop_"
    $(model_name_crop + 'x').val(coords.x)
    $(model_name_crop + 'y').val(coords.y)
    $(model_name_crop + 'w').val(coords.w)
    $(model_name_crop + 'h').val(coords.h)
}
