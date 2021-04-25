<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" +
request.getServerName() +":"+request.getServerPort()
+request.getContextPath()+"/";
%>

<%--
	将在 application 域中的 阶段可能性 保存到 json 数组中
	使用foreach来完成json字符串的传入
--%>


<!DOCTYPE html>
<html>

<head>
	<base href="<%=basePath%>">
	<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
<script type="text/javascript">

	$(function(){
		pageList(1,2);
		//时间控件  这个里面基本没有用
		$(".time1").datetimepicker({
			minView: "mont  h",
			language: 'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});
		$(".time2").datetimepicker({
			minView: "month",
			language: 'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});
		//
		$("#searchBtn").click(function () {
			//将填写的数据保存在隐藏域当中 根据隐藏域中的内容进行动态 sql 模糊查询 需要
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-customerName").val($.trim($("#search-customerName").val()));
			$("#hidden-stage").val($.trim($("#search-stage").val()));
			$("#hidden-type").val($.trim($("#search-type").val()));
			$("#hidden-source").val($.trim($("#search-source").val()));
			$("#hidden-contactsName").val($.trim($("#search-contactsName").val()));
			pageList(1,2)
		})
		//全选、全不选
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		})
		$("#tranBody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length == $("input[name=xz]:checked").length);
		})

		//删除 修改 等等 之后再写 删除 修改 也是 刷新页面 不同的是修改的时候 分页数据不能跳转 需要显示当前选择的分页数据



	});
	//需要在修改，删除，添加，查询，页面刷新时进行数据的更新 另外还需要做 动态 SQL 模糊查询
	// 但是这个页面 添加 以及 编辑都在另外的页面 通过 重定向方法跳转到该页面
	function pageList(pageNo,pageSize){
		//每次刷新页面都需要将全选按钮取消
		$("#qx").prop("checked",false);
		$("input[name=xz]").prop("checked",false);
		//需要获取隐藏域对象 取得里面的值进行查询

		//将 值 更新到 搜索域中

		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-customerName").val($.trim($("#hidden-customerName").val()));
		$("#search-stage").val($.trim($("#hidden-stage").val()));
		$("#search-type").val($.trim($("#hidden-type").val()));
		$("#search-source").val($.trim($("#hidden-source").val()));
		$("#search-contactsName").val($.trim($("#hidden-contactsName").val()));
		//获取值 根据条件查询数据
		$("#hidden-owner").val();
		$("#hidden-name").val();
		$("#hidden-customerName").val();
		$("#hidden-stage").val();
		$("#hidden-type").val();
		$("#hidden-source").val();
		$("#hidden-contactsName").val();

		//调用 ajax 局部刷新
		$.ajax({
			url:"workbench/transaction/pageList.do",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"owner":$.trim($("#hidden-owner").val()),
				"name":$.trim($("#hidden-name").val()),
				"customerName":$.trim($("#hidden-customerName").val()),
				"stage":$.trim($("#hidden-stage").val()),
				"type":$.trim($("#hidden-type").val()),
				"source":$.trim($("#hidden-source").val()),
				"contactsName":$.trim($("#hidden-contactsName").val())

			},
			type:"get",
			dataType:"json",
			success:function (data) {
				//返回一个VO类 total  以及  tranList as tList

				var html = "";
				//拼接 window.location.href : 只需要将内部的内容 添加转义字符即可
				$.each(data.dataList,function (i,n) {
					html += '<tr class="active">';
					html += '<td><input type="checkbox" value="'+n.id+'" name="xz" /></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench\/transaction\/detail.do?id='+n.id+'\';">'+n.customerId+'-'+n.name+'</a></td>';
					html += '<td>'+n.customerId+'</td>';
					html += '<td>'+n.stage+'</td>';
					html += '<td>'+n.type+'</td>';
					html += '<td>'+n.owner+'</td>';
					html += '<td>'+n.source+'</td>';
					html += '<td>'+n.contactsId+'</td>';
					html += '</tr>';
				})
				$("#tranBody").html(html);
				//计算总页数
				var totalPages = Math.ceil(data.total/pageSize);
				//分页插件
				$("#tranPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数

					visiblePageLinks: 2, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});

			}
		})

	}
</script>
</head>
<body>


<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-customerName">
<input type="hidden" id="hidden-stage">
<input type="hidden" id="hidden-type">
<input type="hidden" id="hidden-source">
<input type="hidden" id="hidden-contactsName">
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="search-customerName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control" id="search-stage">
					  	<option></option>
					  	<c:forEach items="${stageList}" var="stage">
							<option value="${stage.value}">${stage.text}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" id="search-type">
					  	<option></option>
					  	<option>已有业务</option>
					  	<option>新业务</option>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="search-source">
						  <option></option>
						  <c:forEach items="${sourceList}" var="source">
							  <option value="${source.value}">${source.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="search-contactsName">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/add.do';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" onclick="window.location.href='workbench/transaction/edit.html';"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="tranBody">
					<%--
					<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.jsp';">动力节点-交易01</a></td>
							<td>动力节点</td>
							<td>谈判/复审</td>
							<td>新业务</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>李四</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.jsp';">动力节点-交易01</a></td>
                            <td>动力节点</td>
                            <td>谈判/复审</td>
                            <td>新业务</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>李四</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 20px;">
				<div id="tranPage">
				</div>
			</div>

		</div>

	</div>
</body>
</html>