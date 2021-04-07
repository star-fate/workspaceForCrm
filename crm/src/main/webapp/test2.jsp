<%--
  Created by IntelliJ IDEA.
  User: 范志文
  Date: 2021/3/26
  Time: 15:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() +":"+request.getServerPort()
            +request.getContextPath()+"/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>

// ajax 后台验证 密码信息是否在正确
$.ajax({
url:"",
data:{

},
type:"",
dataType:"json",
success:function (data) {

}
})

String id = UUIDUtil.getUUID();
String owner = request.getParameter("create-owner");
String name = request.getParameter("create-name");
String startDate = request.getParameter("create-startDate");
String endDate = request.getParameter("create-endDate");
String cost = request.getParameter("create-cost");
String description = request.getParameter("create-description");


//时间控件 在需要添加时间控件的输入控件上面的 class 属性上面 添加 time
$(".time").datetimepicker({
minView: "month",
language: 'zh-CN',
format: 'yyyy-mm-dd',
autoclose: true,
todayBtn: true,
pickerPosition: "bottom-left"
});


//复选框---begin
$("#qx").click(function () {
//如果全选框的值为 checked 则 所有复选框的值均为 checked
$("input[name=xz]").prop("checked",this.checked)
})
//需要绑定元素的有效外层元素
// 		|			  	动作  需要绑定事件的jQuery对象   回调函数
$("#activityBody").on("click",$("input[name=xz]"),function () {

$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
})
//复选框---end
</body>
</html>
