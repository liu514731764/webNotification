<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<base href="<%=basePath%>">
<title>My WebSocket</title>
<script type="text/javascript" src="js/jquery-1.8.3.min.js"></script>
</head>
<body>
	Welcome
	<br />
	<input id="text" type="text" />
	<button onclick="send()">Send</button>
	<button onclick="closeWebSocket()">Close</button>
	<div id="message"></div>
</body>

<script type="text/javascript">
	var Notification = window.Notification || window.mozNotification
			|| window.webkitNotification;

	var websocket = null;

	//判断当前浏览器是否支持WebSocket
	if ('WebSocket' in window) {
		websocket = new WebSocket("ws://192.168.1.245:8080/webSocketTest/websocket");
	} else {
		alert('Not support websocket')
	}

	//连接发生错误的回调方法
	websocket.onerror = function() {
		setMessageInnerHTML("error");
	};

	//连接成功建立的回调方法
	websocket.onopen = function(event) {
		//setMessageInnerHTML("open");
	}

	//接收到消息的回调方法
	websocket.onmessage = function() {
		
		setMessageInnerHTML(event.data);
	}

	//连接关闭的回调方法
	websocket.onclose = function() {
		//setMessageInnerHTML("close");
	}

	//监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
	window.onbeforeunload = function() {
		websocket.close();
	}

	//将消息显示在网页上
	function setMessageInnerHTML(innerHTML) {
		//判断浏览器是否支持notification
		if (Notification) {

			Notification.requestPermission(function(permission) {

				var instance = new Notification("消息通知", {
					body : innerHTML,
					icon : "http://photocdn.sohu.com/20151203/Img429508884.jpg"
				});

			});

		} else {

			alert("您的浏览器不支持桌面通知特性，请下载谷歌浏览器试用该功能");
		}
		document.getElementById('message').innerHTML += innerHTML + '<br/>';
	}

	//关闭连接
	function closeWebSocket() {
		websocket.close();
	}

	//发送消息
	function send() {
		var message = document.getElementById('text').value;
		websocket.send(message);
	}
</script>
</body>
</html>