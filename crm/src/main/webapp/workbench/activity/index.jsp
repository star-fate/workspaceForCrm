
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() +":"+request.getServerPort()
            +request.getContextPath()+"/";
%>
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

        $(function () {

            //时间控件 在需要添加时间控件的输入控件上面的 class 属性上面 添加 time
            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });
            $("#addBtn").click(function () {
                //jQuery对象转换为Dom对象 调用form表单中的reset
                $("#activityAddModal")[0].reset();

                $.ajax({
                    url: "workbench/activity/getUserList.do",
                    type: "get",
                    data: {},
                    dataType: "json",
                    success: function (data) {
                        //需要接收所有的user信息
                        /*
                            userList
                            {[],[]}
                        */
                        var html = "<option></option>"
                        $.each(data, function (i, n) {
                            html += "<option value='" + n.id + "'>" + n.name + "</option>";
                        })
                        $("#create-owner").html(html);

                        var id = "${user.id}";
                        $("#create-owner").val(id)
                        $("#createActivityModal").modal("show");

                    }
                })
            })

            $("#saveBtn").click(function () {
                var owner = $("#create-owner").val();
                var name = $("#create-name").val();
                var startDate = $("#create-startDate").val();
                var endDate = $("#create-endDate").val();
                var cost = $("#create-cost").val();
                var description = $("#create-description").val();
                $.ajax({
                    url: "workbench/activity/save.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        "owner": $.trim(owner),
                        "name": $.trim(name),
                        "startDate": $.trim(startDate),
                        "endDate": $.trim(endDate),
                        "cost": $.trim(cost),
                        "description": $.trim(description),
                    },
                    success: function (data) {
                        /*
                        *
                        * success：true,false
                        * */
                        if (data.success) {
                            $("#createActivityModal").modal("hide");
                        } else {
                            alert("数据添加失败")
                        }
                        pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

                    }

                })

            })

            $("#searchBtn").click(function () {
                $("#hidden-name").val($.trim($("#search-name").val()))
                $("#hidden-owner").val($.trim($("#search-owner").val()))
                $("#hidden-startDate").val($.trim($("#search-startDate").val()))
                $("#hidden-endDate").val($.trim($("#search-endDate").val()))
                pageList(1
                    ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

            })
            pageList(1,2);

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


            //================ 	删除操作---begin
            $("#deleteBtn").click(function () {
                var $xz =$("input[name=xz]:checked");

                if ($xz.length == 0){
                    alert("请选择需要删除的数据")
                }else {
                    if (confirm("确认需要删除选中数据吗？")){
                        //获取复选框的value 拼接字符串
                        var pram = "";

                        for (var i = 0; i < $xz.length; i++) {
                            pram += "id="+$($xz[i]).val();
                            if (i < $xz.length-1){
                                pram += "&";
                            }
                        }

                        $.ajax({
                            url:"workbench/activity/delete.do",
                            data:pram,
                            type:"post",
                            dataType:"json",
                            success:function (data) {
                                //返回参数 接收
                                /*
                                * ["success":true/false]
                                *  */
                                if (data.success){
                                    pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                                        ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

                                }else {
                                    alert("删除数据操作失败")
                                }
                            }
                        })
                    }


                }


            })
            //==============	删除操作---end
            //==============	修改操作---begin
            $("#editBtn").click(function () {
                //功能同保存相似
                /*
                * 点击所需要修改的市场活动需要一个 id
                * 返回值 getUserList And Activity
                *	返回的值 getUserList  用于展示用户列表
                * 	返回的值 Activity     用于展示所选框的数据
                *
                *
                * 当需要保存的时候需要点击 updateBtn
                * 	将页面的修改的值保存
                * 	刷新页面
                *
                * */
                //获取选中的id

                var $xz = $("input[name=xz]:checked");
                if ($xz.length == 0){
                    alert("请选择所要修改的一条记录")
                }else if ($xz.length > 1){
                    alert("每次只能修改一条记录")
                }else {
                    var id = $xz.val();
                    $.ajax({
                        url:"workbench/activity/getUserListAndActivity.do",
                        data:{
                            "id":id
                        },
                        type:"post",
                        dataType:"json",
                        success:function (data) {
                            /*
                            data：
                            用户活动列表 市场活动对象
                            {"uList":[{用户1},{2}],
                            "activity":activity}
                             */
                            var html = "<option></option>";
                            $.each(data.uList,function (i,n) {
                                html += "<option value='"+n.id+"'>"+n.name+"</option>"
                            })
                            $("#edit-owner").html(html);

                            //不需要默认以前的所有者
                            /*$("#edit-owner").val("<%--${sessionScope.user.owner}--%>");*/
                            $("#edit-id").val(data.activity.id)
                            $("#edit-owner").val(data.activity.owner);
                            $("#edit-name").val(data.activity.name)
                            $("#edit-startDate").val(data.activity.startDate)
                            $("#edit-endDate").val(data.activity.endDate)
                            $("#edit-cost").val(data.activity.cost)
                            $("#edit-description").val(data.activity.description)
                            //所有的值填好之后 就可以打开
                            $("#editActivityModal").modal("show");
                        }
                    })
                }
            })

            $("#updateBtn").click(function () {

                $.ajax({
                    url:"workbench/activity/update.do",
                    data:{
                        "id":$.trim($("#edit-id").val()),
                        "name":$.trim($("#edit-name").val()),
                        "owner":$.trim($("#edit-owner").val()),
                        "startDate":$.trim($("#edit-startDate").val()),
                        "endDate":$.trim($("#edit-endDate").val()),
                        "cost":$.trim($("#edit-cost").val()),
                        "description":$.trim($("#edit-description").val())
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.success == true){
                            $("#editActivityModal").modal("hide");
                        }else {
                            alert("更新市场活动信息失败");
                        }
                        pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                            ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

                    }
                })

            })


            //==============	修改操作---end

        });
        /*
        *
        * 需要放在六个地方
        *
        * */
        function pageList(pageNo,pageSize) {

            // 每次加载后 清空复选框的状态 只需要取消全选框的选中状态就好
            $("input[id=qx]").prop("checked",false);

            //查询前，将隐藏框中的内容赋值给搜索框
            //切记  #  不要忘记  |||
            $("#search-name").val($.trim($("#hidden-name").val()))
            $("#search-owner").val($.trim($("#hidden-owner").val()))
            $("#search-startDate").val($.trim($("#hidden-startDate").val()))
            $("#search-endDate").val($.trim($("#hidden-endDate").val()))

            $.ajax({
                url:"workbench/activity/pageList.do",
                //特别注意 特别注意 特别注意
                data:{
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "name": $.trim($("#search-name").val()),
                    "owner": $.trim($("#search-owner").val()),
                    "startDate": $.trim($("#search-startDate").val()),
                    "endDate": $.trim($("#search-endDate").val())
                },
                type:"get",
                dataType:"json",
                success:function (data) {
                    /*
                    * total  总条数
                    *
                    * List<Activity>  市场活动信息列表
                    * */
                    var html = "";
                    $.each(data.dataList,function (i,n) {
                        html += '<tr class="active">',
                            html += '<td><input type="checkbox" value="'+n.id+'" name="xz" /></td>',
                            html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench\/activity\/detail.do?id='+n.id+'\'">'+n.name+'</a></td>',
                            html += '<td>'+n.owner+'</td>',
                            html += '<td>'+n.startDate+'</td>',
                            html += '<td>'+n.endDate+'</td>',
                            html += '</tr>'
                    })
                    //将所有拼接的字符串写入到 市场信息列表中
                    $("#activityBody").html(html);

                    //计算总页数--只有值全部传入才能运行（确信）
                    var totalPages = Math.ceil(data.total/pageSize);
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
<%--
    隐藏域
        用于存放信息
--%>
<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-startDate">
<input type="hidden" id="hidden-endDate">
<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form id="activityAddModal" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">

                            </select>
                        </div>
                        <label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-startDate">
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-endDate">
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
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

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" id="activityEditModal" role="form">
                    <input type="hidden" id="edit-id">
                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <%--
                                                                  <option>zhangsan</option>
                                                                  <option>lisi</option>
                                                                  <option>wangwu</option>
                                --%>
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-startDate">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-endDate">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
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
            <h3>市场活动列表</h3>
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
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control time" type="text" id="search-startDate" />
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control time" type="text" id="search-endDate">
                    </div>
                </div>

                <button type="button" id="searchBtn" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <%-- data-toggle="modal" data-target="#createActivityModal" --%>
                <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                <%--data-toggle="modal" data-target="#editActivityModal"--%>
                <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="activityBody">
                <%--<tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">
            <div id="activityPage">
            </div>

        </div>

    </div>
</div>
</body>
</html>