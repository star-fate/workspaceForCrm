<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
String basePath = request.getScheme() + "://" +
request.getServerName() +":"+request.getServerPort()
+request.getContextPath()+"/";
%>

<%--
	从application域取出 pMap对象

--%>
<%
	Map<String,String> pMap = (Map<String, String>) application.getAttribute("pMap");
	Set<String> set = pMap.keySet();
%>
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

	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

	<script type="text/javascript">


		$(function () {

			var json = {
				<%
                    for (String key:set){
                        String value = pMap.get(key);
                %>
					"<%=key%>" : <%=value%>,
				<%
                    }
                %>
			}
			console.log(json)
			$("#create-getCustomerName").typeahead({

				source: function (query, process) {
					$.get(
							"workbench/transaction/getCustomerName.do",
							{ "name" : query },
							function (data) {
								//alert(data);
								process(data);
							},
							"json"
					);
				},
				delay: 1500
			});


			$(".time1").datetimepicker({
				minView: "month",
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

			$("#create-stage").change(function () {
				var stage = this.value;
				//发生变化之后要将变化的值更新到可能性中
				var possibility = json[stage];
				$("#create-possibility").val(possibility);

			})
			/*
				打开模态窗口
			*/

			$("#searchActivityBtn").click(function () {$("#loginAct").focus();
				//打开之前清空内容
				$("#activity-search").html("");
				$("#aname").val("")
				$("#findMarketActivity").modal("show");
				/*$("#aname").focus();*/
			})

			$("#searchContactBtn").click(function () {

				$("#findContacts").modal("show");
				$("#cname").focus();
			})
			/*
				当在当前输入框输入完成时 点击enter

			*/
			$("#aname").keydown(function (event) {
				if (event.keyCode == 13){

					$.ajax({
						url:"workbench/transaction/getActivityListByName.do",
						data:{
							"aname":$.trim($("#aname").val())
						},
						type:"get",
						dataType:"json",
						success:function (data) {
							var html = "";
							//取得传回的数据 aList
							$.each(data,function (i,n) {
										html += '<tr>';
										html += '<td><input type="radio" name="activity" value="'+n.id+'"/></td>';
										html += '<td>'+n.name+'</td>';
										html += '<td>'+n.startDate+'</td>';
										html += '<td>'+n.endDate+'</td>';
										html += '<td>'+n.owner+'</td>';
										html += '</tr>';
							})

							$("#activity-search").html(html);
						}
					})
					//展现完列表后，将模态窗口默认的行为禁止掉。
					//这句话最好放在当前的 回车点击事件之内
					return false;
				}


			})
			$("#cname").keydown(function (event) {
				if (event.keyCode == 13){
					var contactName = $.trim(this.value);
					$.ajax({
						url:"workbench/transaction/getContactListByName.do",
						data:{
							"cname":contactName
						},
						type:"get",
						dataType:"json",
						success:function (data) {
							var html = "";
							//取得传回的数据 aList
							$.each(data,function (i,n) {
								html += '<tr>';
								html += '<td><input type="radio" name="contact" value="'+n.id+'"/></td>';
								html += '<td>'+n.fullname+'</td>';
								html += '<td>'+n.email+'</td>';
								html += '<td>'+n.mphone+'</td>';
								html += '</tr>';
							})
							$("#contacts-search").html(html);

						}
					})
					//展现完列表后，将模态窗口默认的行为禁止掉。
					return false;
				}

			})


			/*
				保存信息，关闭模态窗口
				将选择的Id信息保存在 隐藏域中

				注意：使用标签选择器的时候 后面根据 某个属性 那么，那个属性的值需要添加 '' 英文单引号

				又是查漏补缺的一天  舒服

			*/
			$("#submitActivityBtn").click(function () {
				//点击选择 则将值保存在 隐藏域中
				var activityId = $("input[name='activity']:checked").val()
				$("#hidden-activity").val(activityId);
				$("#findMarketActivity").modal("hide");
			})
			$("#submitContactBtn").click(function () {
				var contactId = $("input[name='contact']:checked").val()
				$("#hidden-contact").val(contactId);
				$("#findContacts").modal("hide");
			})


			/*
				需要实现功能：
					对于用户列表的更新
					==============又被自己蠢到  淦
					需要已经将数据使用请求转发方式
					保存在 request 中——
					直接使用 EL 表达式 结合 JSTL
					从request域中取值

				由于之前使用的是aJax 所以直接在success语句中
					使用传回来的uList进行字符串拼接
			 */



		})
	</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="aname" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
							<tbody id="activity-search">

							<%--
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="submitActivityBtn">确认</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="cname" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contacts-search">

							<%--
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="submitContactBtn">确认</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button"  class="btn btn-primary" id="submitBtn">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-owner">
					<option></option>
						<c:forEach items="${uList}" var="u">
							<option value="${u.id}" ${user.id eq u.id?"selected":""}>${u.name}</option>
						</c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time1" id="create-expectedClosingDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-getCustomerName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-stage">
			  	<option></option>
			  	<c:forEach items="${stageList}" var="stage">
					<option value="${stage.value}">${stage.text}</option>
				</c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType">
				  <option></option>
				  <option>已有业务</option>
				  <option>新业务</option>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSou	rce" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-source">
				  <option></option>
				  <c:forEach items="${sourceList}" var="source">
					  <option value="${source.value}">${source.text}</option>
				  </c:forEach>
				</select>
			</div>
			<%--data-toggle="modal" data-target="#findMarketActivity"--%>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="searchActivityBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="hidden-activity" value="">
				<input type="text" class="form-control" id="create-activityId">
			</div>
		</div>
		
		<div class="form-group">
			<%--data-toggle="modal" data-target="#findContacts"--%>
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="searchContactBtn" ><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="hidden-contact" value=""/>
				<input type="text" class="form-control" id="create-contactsId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time2" id="create-nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>