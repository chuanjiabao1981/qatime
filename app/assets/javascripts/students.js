var jcrop_api;
function showimagepreview(input) {
    if (input.files && input.files[0]) {
        var filerdr = new FileReader();

        filerdr.onload = function(e) {
            $('#user_avatar_preview').attr('src', e.target.result);
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
                onChange: updateCoords
            },function(){
                jcrop_api = this;
            });
        }
    }
}
function updateCoords(coords)
{
    $('#student_crop_x').val(coords.x)
    $('#student_crop_y').val(coords.y)
    $('#student_crop_w').val(coords.w)
    $('#student_crop_h').val(coords.h)
}
