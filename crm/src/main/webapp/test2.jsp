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
$("#qx").prop("checked",false);

//jstl
<c:forEach items="clueStateList" var="clueState">
    <option value="${clueState.value}">${clueState.text}</option>
</c:forEach>


//计算总页数--只有值全部传入才能运行（确信）
var totalPages = Math.ceil(data.total / pageSize);
//数据处理完毕后，结合分页查询插件 对前端进行分页展示
$("#activityPage").bs_pagination({
currentPage: pageNo, // 页码
rowsPerPage: pageSize, // 每页显示的记录条数
maxRowsPerPage: 20, // 每页最多显示的记录条数
totalPages: totalPages, // 总页数
totalRows: data.total, // 总记录条数

visiblePageLinks: 3, // 显示几个卡片

showGoToPage: true,
showRowsPerPage: true,
showRowsInfo: true,
showRowsDefaultInfo: true,

onChangePage: function (event, data) {
pageList(data.currentPage, data.rowsPerPage);
}
})


//分页插件
pageList($("#xxxPage").bs_pagination('getOption', 'currentPage')
,$("#xxxPage").bs_pagination('getOption', 'rowsPerPage'));


//            EL表达式从application   变量
<c:forEach items="${xxxList}" var="xxx">
    <option value="${xxx.value}">${xxx.text}</option>
</c:forEach>
</body>
</html>


线索转换使用 当有交易时:表单提交 没有交易时:window.location.href = "workbench/clue/convert.do?cId=${param.cId}"

$("#convertBtn").click(function () {

    if ($("#isCreateTransaction").prop("checked")){

        //获取参数  workbench/clue/convert.do

        $("#tranForm").submit();
    }else {
        window.location.href = "workbench/clue/convert.do?cId=${param.cId} "
    }

})
分析：转换的实现步骤？
(1) 获取到线索id，通过线索id获取线索对象（线索对象当中封装了线索的信息）
(2) 通过线索对象提取客户信息，当该客户不存在的时候，新建客户（根据公司的名称精确匹配，判断该客户是否存在！）
(3) 通过线索对象提取联系人信息，保存联系人
(4) 线索备注转换到客户备注以及联系人备注
(5) “线索和市场活动”的关系转换到“联系人和市场活动”的关系
(6) 如果有创建交易需求，创建一条交易
(7) 如果创建了交易，则创建一条该交易下的交易历史
(8) 删除线索备注
(9) 删除线索和市场活动的关系
(10) 删除线索
