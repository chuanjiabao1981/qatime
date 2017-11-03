

/**
*
*   浏览器以及设备判断类
*
*/
var Browsers = {};

/**
*   原生js
*/

/*
 *  alert(" 是否mac终端: "+Browsers.versions.isMac);
 *  alert(" 是否Linux终端: "+Browsers.versions.isLinux);
 *  alert(" 是否为移动终端: "+Browsers.versions.mobile);
 *  alert(" ios终端: "+Browsers.versions.ios);
 *  alert(" android终端: "+Browsers.versions.android);
 *  alert(" 是否为iPhone: "+Browsers.versions.iPhone);
 *  alert(" 是否为iPod: "+Browsers.versions.iPod);
 *  alert(" 是否iPad: "+Browsers.versions.iPad);
 */

Browsers = {

    versions:function()
    {
        var u = navigator.userAgent, app = navigator.appVersion;
        return {
            trident: u.indexOf('Trident') > -1, //IE内核
            presto: u.indexOf('Presto') > -1, //opera内核
            webKit: u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核
            gecko: u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1, //火狐内核
            mobile: !!u.match(/AppleWebKit.*Mobile.*/)||!!u.match(/AppleWebKit/), //是否为移动终端
            ios: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端
            android: u.indexOf('Android') > -1, //android终端或者uc浏览器
            iPhone: u.indexOf('iPhone') > -1, //是否为iPhone或者QQHD浏览器
            iPod: u.indexOf('iPod') > -1, //是否为iPod或者QQHD浏览器
            iPad: u.indexOf('iPad') > -1, //是否iPad
            webApp: u.indexOf('Safari') == -1, //是否web应该程序，没有头部与底部
            isMac: u.indexOf('Mac') > -1, //是否是mac终端
            isLinux: u.indexOf('Linux') > -1,//是否是linux系统
            isWeiXin:navigator.userAgent.indexOf('MicroMessenger') > -1,//判断是不是微信浏览器
            isWindowsPhone:u.indexOf('Windows Phone') > -1//是否是windows phone
        };
    }()

};
/**
 *  获取不同浏览器返回的值
 *
 */


Browsers.BrowserId = function()
{
    var id;
    if($.browser.msie) {
        id = 'html';
    }
    else if(window.chrome)
    {
        id = 'body';
    }
    else if($.browser.safari)
    {
        id = 'body';
    }
    else if($.browser.mozilla)
    {
        id = 'html';
    }
    else if($.browser.opera)
    {
        id = 'html';
    }
    return id;
};




/*

* 智能机浏览器版本信息:

*

*/

var browser={

versions:function(){

var u = navigator.userAgent, app = navigator.appVersion;

return {//移动终端浏览器版本信息

trident: u.indexOf('Trident') > -1, //IE内核

presto: u.indexOf('Presto') > -1, //opera内核

webKit: u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核

gecko: u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1, //火狐内核

mobile: !!u.match(/AppleWebKit.*Mobile.*/)||!!u.match(/AppleWebKit/), //是否为移动终端

ios: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端

android: u.indexOf('Android') > -1 || u.indexOf('Linux') > -1, //android终端或者uc浏览器

iPhone: u.indexOf('iPhone') > -1 || u.indexOf('Mac') > -1, //是否为iPhone或者QQHD浏览器

iPad: u.indexOf('iPad') > -1, //是否iPad

webApp: u.indexOf('Safari') == -1 //是否web应该程序，没有头部与底部

};

}(),

language:(navigator.browserLanguage || navigator.language).toLowerCase()

}


/*判断是不是微信浏览器：
var ua = "0";
       
       if (navigator.userAgent.indexOf('MicroMessenger') > -1) {
           ua = "1";
       }
MicroMessenger代表就是微信浏览器，其他特殊情况，可以枚举。
*/
