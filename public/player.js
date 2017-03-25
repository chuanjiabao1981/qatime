'use strict';

var Component = neplayer.getComponent("Component");

// 错误组件 start
var errorElement = document.createElement("div");
errorElement.innerHTML = '<div>网络错误点击刷新</div>'
neplayer.addClass(errorElement, "my-error-display");

var ErrorComponent = neplayer.extend(Component, {});
var errorComponent = new ErrorComponent(null, { el: errorElement });
// 错误组件 end

// 结束画面 start
var endedElement = document.createElement("div");
endedElement.innerHTML = '<div>直播已结束</div>'
neplayer.addClass(endedElement, "my-ended-display");

var EndedComponent = neplayer.extend(Component, {});
var endedComponent = new EndedComponent(null, { el: endedElement });
// 结束画面 end

// 刷新组件 start
var refreshElement = document.createElement("button");
refreshElement.innerHTML = '<img src="imgs/refresh.png" />'
neplayer.addClass(refreshElement, "my-refresh-button");


var RefreshComponent = neplayer.extend(Component, {});
var refreshComponent = new RefreshComponent(null, { el: refreshElement });
// 刷新组件 end