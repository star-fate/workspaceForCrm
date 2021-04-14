<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
		//时间输入控件
		$(".time").datetimepicker({
			minView: "month",
			language: 'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});
		//添加数据按钮
		$("#addBtn").click(function () {
			//所有数据加载完成之后打开窗口 其中需要userList
			//而其他的值 例如下拉框则是 el 表达式 来获取
			//自然而然需要reset信息
			$("#clueAddModal")[0].reset();
			//ajax 来获取 userList
			$.ajax({
				url:"workbench/clue/getUserList.do",
				type:"get",
				dataType:"json",
				success:function (data) {
					var html = "<option></option>";
					$.each(data,function (i,n) {
						 html += "<option value='"+n.id+"'>"+n.name+"</option>";
					})
					$("#create-owner").html(html);
					$("#create-owner").val("${user.id}");
					$("#createClueModal").modal("show");
				}
			})
		})
		//保存数据
		$("#saveBtn").click(function () {

			//获取信息
			$.ajax({
				url:"workbench/clue/save.do",
				data:{
					"fullname":$.trim($("#create-fullname").val()),
					"appellation":$.trim($("#create-appellation").val()),
					"owner":$.trim($("#create-owner").val()),
					"company":$.trim($("#create-company").val()),
					"job":$.trim($("#create-job").val()),
					"email":$.trim($("#create-email").val()),
					"phone":$.trim($("#create-phone").val()),
					"website":$.trim($("#create-website").val()),
					"mphone":$.trim($("#create-mphone").val()),
					"state":$.trim($("#create-state").val()),
					"source":$.trim($("#create-source").val()),
					"description":$.trim($("#create-description").val()),
					"contactSummary":$.trim($("#create-contactSummary").val()),
					"nextContactTime":$.trim($("#create-nextContactTime").val()),
					"address":$.trim($("#create-address").val())
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					//返回数据 success
					if (data.success){
						$("#createClueModal").modal("hide");
						pageList(1
								,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
					}else{
						alert("添加线索失败")
					}
				}
			})

		})
		//修改数据按钮
		$("#editBtn").click(function () {
			//需要将数据全部拿到，然后填入到里面
			var $xz = $("input[name=xz]:checked");
			if ($xz.length == 0){
				alert("请选择要修改的线索")
			}else if ($xz.length > 1){
				alert("每次只能修改一条线索")
			}else {
				$.ajax({
					url:"workbench/clue/getUserListAndClue.do",
					data:{
						"clueId":$xz.val()
					},
					type:"post",
					dataType:"json",
					success:function (data) {
						var html ="<option></option>";
						$.each(data.uList,function (i,n) {
							html += "<option value='"+n.id+"'>"+n.name+"</option>";
						})
						$("#edit-owner").html(html);

						$("#edit-id").val(data.clue.id)
						$("#edit-owner").val(data.clue.owner)
						$("#edit-fullname").val(data.clue.fullname)
						$("#edit-appellation").val(data.clue.appellation)
						$("#edit-company").val(data.clue.company)
						$("#edit-job").val(data.clue.job)
						$("#edit-email").val(data.clue.email)
						$("#edit-phone").val(data.clue.phone)
						$("#edit-website").val(data.clue.website)
						$("#edit-mphone").val(data.clue.mphone)
						$("#edit-state").val(data.clue.state)
						$("#edit-source").val(data.clue.source)
						$("#edit-description").val(data.clue.description)
						$("#edit-contactSummary").val(data.clue.contactSummary)
						$("#edit-nextContactTime").val(data.clue.nextContactTime)
						$("#edit-address").val(data.clue.address)
					}
				})
				$("#editClueModal").modal("show");
			}

		})
		//更新修改的数据
		$("#updateBtn").click(function () {
			//需求 将修改的数据更新到数据库
			/*
				需要取得的数据 首先包括 id
				在 editBtn 点击操作中 将其ID保存在
				隐藏域中
			*/
			$("#edit-id").val();
			$.ajax({
				url:"workbench/clue/update.do",
				data:{
					"id":$.trim($("#edit-id").val()),
					"fullname":$.trim($("#edit-fullname").val()),
					"appellation":$.trim($("#edit-appellation").val()),
					"owner":$.trim($("#edit-owner").val()),
					"company":$.trim($("#edit-company").val()),
					"job":$.trim($("#edit-job").val()),
					"email":$.trim($("#edit-email").val()),
					"phone":$.trim($("#edit-phone").val()),
					"website":$.trim($("#edit-website").val()),
					"mphone":$.trim($("#edit-mphone").val()),
					"state":$.trim($("#edit-state").val()),
					"source":$.trim($("#edit-source").val()),
					"description":$.trim($("#edit-description").val()),
					"contactSummary":$.trim($("#edit-contactSummary").val()),
					"nextContactTime":$.trim($("#edit-nextContactTime").val()),
					"address":$.trim($("#edit-address").val())
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					//返回数据 success
					if (data.success){
						$("#editClueModal").modal("hide");
						pageList($("#cluePage").bs_pagination('getOption', 'currentPage')
								,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
					}else{
						alert("修改线索失败")
					}
				}
			})

		})

		//删除选择的数据
		$("#deleteBtn").click(function () {
			//首先先要获取所要删除数据的ID编号
			var $xz = $("input[name=xz]:checked");
			if ($xz.length == 0){
				alert("请选择要删除的数据");
			}
			var pram = "";
			for (i = 0;i<$xz.length;i++){
				//当做是拼接 ？ 后面的字符串
				pram += "id="+$xz[i].value;
				if (i<$xz.length-1){
					pram += "&";
				}
			}
			$.ajax({
				url:"workbench/clue/delete.do",
				data:pram,
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data.success){
						pageList(1
								,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
					}else {
						alert("删除数据失败！")
					}
				}
			})

			alert(pram)

		})
		//根据条件查询数据-->向隐藏域中填写值，根据隐藏域来查询
		$("#searchBtn").click(function () {
			$("#hidden-fullname").val($.trim($("#search-fullname").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-phone").val($.trim($("#search-phone").val()));
			$("#hidden-mphone").val($.trim($("#search-mphone").val()));
			$("#hidden-state").val($.trim($("#search-state").val()));
			$("#hidden-source").val($.trim($("#search-source").val()));
			$("#hidden-company").val($.trim($("#search-company").val()));
			pageList($("#cluePage").bs_pagination('getOption', 'currentPage')
					,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
		})
		//全选与全不选
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		})
		$("#clueBody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]:checked").length == $("input[name=xz]").length)
		})

	});
	//展示clue数据的函数
	function pageList(pageNo,pageSize) {
		//对于每张页面来说每次更新时 都需要全不选
		$("#qx").prop("checked",false);
		//使用 动态sql + 分页 来完成 配合隐藏域
		/*需要获取的信息
			包含 搜索框中的信息
			当点击搜索按钮时，将信息保存在隐藏域中
			根据隐藏域中的信息来进行搜索
		 */
		$("#search-fullname").val($.trim($("#hidden-fullname").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-phone").val($.trim($("#hidden-phone").val()));
		$("#search-mphone").val($.trim($("#hidden-mphone").val()));
		$("#search-state").val($.trim($("#hidden-state").val()));
		$("#search-source").val($.trim($("#hidden-source").val()));
		$("#search-company").val($.trim($("#hidden-company").val()));

		var fullname = $.trim($("#search-fullname").val());
		var owner = $.trim($("#search-owner").val());
		var phone = $.trim($("#search-phone").val());
		var mphone = $.trim($("#search-mphone").val());
		var state =  $.trim($("#search-state").val());
		var source = $.trim($("#search-source").val());
		var company =  $.trim($("#search-company").val());
		//根据所取的值进行动态sql查询
		//调用ajax
		$.ajax({
			url:"workbench/clue/pageList.do",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"fullname":fullname,
				"owner":owner,
				"phone":phone,
				"mphone":mphone,
				"state ":state,
				"source":source,
				"company":company
			},
			type:"get",
			dataType:"json",
			success:function (data) {
				//返会 success and ClueList as cList
				var html = "";
				$.each(data.dataList, function (i,n) {
					html += '<tr class="active">';
					html += '<td><input type="checkbox" value="'+n.id+'" name="xz"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench\/clue\/detail.do?id=' + n.id + '\';">' + n.fullname + '</a></td>';
					html += '<td>' + n.company + '</td>';
					html += '<td>' + n.phone + '</td>';
					html += '<td>' + n.mphone + '</td>';
					html += '<td>' + n.source + '</td>';
					html += '<td>' + n.owner + '</td>';
					html += '<td>' + n.state + '</td>';
					html += '</tr>';
				})
				$("#clueBody").html(html);

				//计算总页数--只有值全部传入才能运行（确信）
				var totalPages = Math.ceil(data.total / pageSize);
				//数据处理完毕后，结合分页查询插件 对前端进行分页展示
				$("#cluePage").bs_pagination({
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
			}
		})

	}
</script>
</head>
<body>

<input type="hidden" id="hidden-fullname">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-company">
<input type="hidden" id="hidden-phone">
<input type="hidden" id="hidden-mphone">
<input type="hidden" id="hidden-state">
<input type="hidden" id="hidden-source">
	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="clueAddModal" role="form">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-appellationList" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
									<option></option>
									<c:forEach items="${appellationList}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								  <%--<option></option>
								  <option>先生</option>
								  <option>夫人</option>
								  <option>女士</option>
								  <option>博士</option>
								  <option>教授</option>--%>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
									<option></option>
								  	<c:forEach items="${clueStateList}" var="clueState">
									  	<option value="${clueState.value}">${clueState.text}</option>
								  	</c:forEach>
									<%--<option></option>
								  <option>试图联系</option>
								  <option>将来联系</option>
								  <option>已联系</option>
								  <option>虚假线索</option>
								  <option>丢失线索</option>
								  <option>未联系</option>
								  <option>需要条件</option>--%>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.value}">${source.text}</option>
									</c:forEach>
								  <%--<option>广告</option>
								  <option>推销电话</option>
								  <option>员工介绍</option>
								  <option>外部介绍</option>
								  <option>在线商场</option>
								  <option>合作伙伴</option>
								  <option>公开媒介</option>
								  <option>销售邮件</option>
								  <option>合作伙伴研讨会</option>
								  <option>内部研讨会</option>
								  <option>交易会</option>
								  <option>web下载</option>
								  <option>web调研</option>
								  <option>聊天</option>--%>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="clueEditModal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
									<option></option>
									<c:forEach items="${appellationList}" var="appellation">
										<option value="${appellation.value}">${appellation.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" >
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" >
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" >
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state" >
								<%--  <option></option>
								  <option>试图联系</option>
								  <option>将来联系</option>
								  <option selected>已联系</option>
								  <option>虚假线索</option>
								  <option>丢失线索</option>
								  <option>未联系</option>
								  <option>需要条件</option>
								--%>

									<option></option>
									<c:forEach items="${clueStateList}" var="state">
										<option value="${state.value}">${state.text}</option>
									</c:forEach>

								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <%--<option></option>
								  <option selected>广告</option>
								  <option>推销电话</option>
								  <option>员工介绍</option>
								  <option>外部介绍</option>
								  <option>在线商场</option>
								  <option>合作伙伴</option>
								  <option>公开媒介</option>
								  <option>销售邮件</option>
								  <option>合作伙伴研讨会</option>
								  <option>内部研讨会</option>
								  <option>交易会</option>
								  <option>web下载</option>
								  <option>web调研</option>
								  <option>聊天</option>--%>
									  <option></option>
									  <c:forEach items="${sourceList}" var="source">
										  <option value="${source.value}">${source.text}</option>
									  </c:forEach>

								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label"></label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>

	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" id="search-fullname" type="text">
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" id="search-company" type="text">
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" id="search-phone" type="text">
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="search-source">
					  	  <%--<option></option>
					  	  <option>广告</option>
						  <option>推销电话</option>
						  <option>员工介绍</option>
						  <option>外部介绍</option>
						  <option>在线商场</option>
						  <option>合作伙伴</option>
						  <option>公开媒介</option>
						  <option>销售邮件</option>
						  <option>合作伙伴研讨会</option>
						  <option>内部研讨会</option>
						  <option>交易会</option>
						  <option>web下载</option>
						  <option>web调研</option>
						  <option>聊天</option>--%>
							  <option></option>
							  <c:forEach items="${sourceList}" var="source">
								  <option value="${source.value}">${source.text}</option>
							  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" id="search-owner" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" id="search-mphone" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="search-state">
					  	<%--<option></option>
					  	<option>试图联系</option>
					  	<option>将来联系</option>
					  	<option>已联系</option>
					  	<option>虚假线索</option>
					  	<option>丢失线索</option>
					  	<option>未联系</option>
					  	<option>需要条件</option>--%>
						  <option></option>
						  <c:forEach items="${clueStateList}" var="clueState">
							  <option value="${clueState.value}">${clueState.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<%--
					data-toggle="modal" data-target="#createClueModal"
					data-toggle="modal" data-target="#editClueModal"
					--%>
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="qx" type="checkbox" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueBody">
                        <%--<tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>
                            <td>动力节点</td>
                            <td>010-84846003</td>
                            <td>12345678901</td>
                            <td>广告</td>
                            <td>zhangsan</td>
                            <td>已联系</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 60px;">
				<div id="cluePage">
				</div>
			</div>
		
	</div>
</body>
</html>