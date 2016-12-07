<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <!-- 引入 ECharts 文件 -->


    </head>

    <body>
        <!-- 为 ECharts 准备一个具备大小（宽高）的 DOM -->
        <div id="main" style="width: 600px;height:400px;"></div>
    </body>
    <script src="echarts.min.js"></script>
    <script src="http://echarts.baidu.com//vendors/jquery/jquery.min.js"></script>
    <script type="text/javascript">
        $(function () {
            // 基于准备好的dom，初始化echarts实例
            var myChart = echarts.init(document.getElementById('main'));
            var data = {mem: [], thread: []};
            var now = +new Date(Date.parse("2016-12-06 09:25:58"));
            var value = Math.random();
            var _flag = false;


            $.ajax({
                type: "GET",
                url: 'file.php',
                data: {type: 1},
                success: function (result) {//返回数据根据结果进行相应的处理  
                    if (result) {
                        var tmp = result.split("\n");
                        for (var i in tmp) {
                            data = getData(tmp[i]);
                        }

                        console.log(data);
                        option = {
                            title: {
                                text: 'PHP 健康度'
                            },
                            xAxis: {
                                type: 'time',
                                splitLine: {
                                    show: false
                                }
                            },
                            yAxis: {
                                type: 'value',
                            },
                            series: [{
                                    name: '内存',
                                    type: 'line',
                                    data: data['mem']
                                }, {
                                    name: '线程',
                                    type: 'bar',
                                    data: data['thread']
                                }

                            ]
                        };
                        myChart.setOption(option);
                        _flag = true;
                    } else {
                        $("#tipMsg").text("删除数据失败");
                    }
                }
            });



            function randomData() {
                now = new Date(+now + 5000);
                var value = Math.random() * 100;
                return {
                    name: now.toString(),
                    value: [
                        '' + now.getFullYear() + '/' + (now.getMonth() + 1) + '/' + now.getDate() + ' ' + now.getHours() + ':' + now.getMinutes() + ':' + now.getSeconds(),
                        Math.round(value)
                    ]
                }
            }

            function getData(param) {
                var tmp = param.split('|');
                var date = new Date(Date.parse(tmp[0].replace(/-/g, "/")));
                data['mem'].length >= 50 ? data['mem'].shift() : null;
                data['thread'].length >= 50 ? data['thread'].shift() : null;
                data['mem'].push({
                    name: date.toString(),
                    value: [
                        tmp[0],
                        Math.round(tmp[3]) / 1000
                    ]
                });
                data['thread'].push({
                    name: date.toString(),
                    value: [
                        tmp[0],
                        Math.round(tmp[1])
                    ]
                });
                return data;
            }


            setInterval(function () {
                if (_flag) {
                    _flag = false;
                    $.ajax({
                        type: "POST",
                        url: 'file.php',
                        data: {},
                        success: function (result) {//返回数据根据结果进行相应的处理  
                            if (result) {
                                _flag = true;
                                console.log(result);
                                data = getData(result);
                                myChart.setOption({
                                    series: [{
                                            data: data['mem']
                                        },
                                        {
                                            data: data['thread']
                                        }]
                                });
                            } else {
                                $("#tipMsg").text("删除数据失败");
                            }
                        }
                    });
                }
            }, 5000);
        });
    </script>
</html>