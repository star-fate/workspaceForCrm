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

    <%--
        eCharts  不属于jQuery的分支  使用原生的 jQuery  操控
    --%>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="ECharts/echarts.min.js"></script>

    <script type="text/javascript">
        $(function () {

            //页面加载后 绘制统计图表
            getCharts();

        })
        function getCharts(){

            $.ajax({
                url:"workbench/transaction/myCharts.do",
                type:"get",
                dataType:"json",
                success:function (data) {
                    //基于准备好的Dom对象 初始化方法
                    var myCharts = echarts.init(document.getElementById("main"));
                    // 指定图表的配置项和数据
                    var option = {
                        title: {
                            text: '交易漏斗图',
                            subtext: '统计交易阶段的漏斗图'
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: "{a} <br/>{b} : {c}%"
                        },
                        toolbox: {
                            feature: {
                                dataView: {readOnly: false},
                                restore: {},
                                saveAsImage: {}
                            }
                        },


                        series: [
                            {
                                name:'交易漏斗图',
                                type:'funnel',
                                left: '10%',
                                top: 60,
                                //x2: 80,
                                bottom: 60,
                                width: '80%',
                                // height: {totalHeight} - y - y2,
                                min: 0,
                                max: data.total,
                                minSize: '0%',
                                maxSize: '100%',
                                sort: 'descending',
                                gap: 2,
                                label: {
                                    show: true,
                                    position: 'inside'
                                },
                                labelLine: {
                                    length: 10,
                                    lineStyle: {
                                        width: 1,
                                        type: 'solid'
                                    }
                                },
                                itemStyle: {
                                    borderColor: '#fff',
                                    borderWidth: 1
                                },
                                emphasis: {
                                    label: {
                                        fontSize: 20
                                    }
                                },
                                data: data.dataList
                                /*[

                                    {value: 60, name: '访问'},
                                    {value: 40, name: '咨询'},
                                    {value: 20, name: '订单'},
                                    {value: 80, name: '点击'},
                                    {value: 100, name: '展现'}

                                ]*/
                            }
                        ]
                    };

                    // 使用刚指定的  【配置】-->set   项和数据显示图表。
                    myCharts.setOption(option);
                }
                })
            }



    </script>
</head>
<body>
    <!-- 为ECharts准备一个具备大小（宽高）的Dom -->
    <div id="main" style="width: 600px;height:400px;"></div>


</body>
</html>