<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>申报清运证</title>
	<%@ include file="../common/taglibs.jsp" %>

	<script type="text/javascript">

        var grid;
        $(function () {
            loadDataGrid();
            $("#search_btn").click(function () {
                $('#listGrid').datagrid({
                    queryParams: {
                        gcName: $('#s_gcName').val(),
                        jsUnit: $('#s_jsUnit').val(),
                        groupName: $("#s_groupName").val(),
                        zNumber: $("#s_zNumber").val(),
                        approved: '1'
                    }
                });
                $('#gridForm').form('clear');
            });
        });
        function printSBB(page) {
            window
                .open(
                    "sbb.jsp",
                    "newwindow",
                    "height=500,width=600,,top=50,left=100,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no");
        }
		/*加载数据*/
        function loadDataGrid() {
            grid = $('#listGrid').datagrid({
                url: '../qyz/list.htmls',
                queryParams: {
                    approved: '1'
                },
                fit: true,
                nowrap: true,
                rownumbers: true,
                striped: true,
                singleSelect: true,
                sortOrder: "desc",
                sortName: "hdEntryTime",
                pagination: true,
                pageSize: 20,
                pageList: [10, 20, 30, 50, 100],
                loadMsg: '数据加载中,请稍后……',
                columns: [[{
                    field: '_operate', title: '操作', align: 'center', width: 90,
                    formatter: function (val, row, index) {
                        return '<a class="sbclsbtn" href="#" onclick="feeOK(' + index + ')">申办</a>';
                    }
                },
                    {field: 'zNumber', title: '处置字号'},
                    {
                        field: 'gcType', title: '工程类型', align: 'center',
                        formatter: function (value, row, index) {
                            if (row.cqtype != null && row.cqtype != "" && row.cqtype != "null") {
                                return row.gcType + "-" + row.cqtype;
                            } else {
                                return row.gcType
                            }
                        }
                    },
                    {field: 'gcName', title: '工程名称'},
                    {field: 'jsUnit', title: '建设单位'},
                    {field: 'site', title: '施工地点'},
                    {
                        field: 'groupName', title: '清运单位'
                    }]],
                onLoadSuccess: function () {

                    $('.sbclsbtn').linkbutton({text: '申办', plain: true, iconCls: 'icon-key'});
                    grid.datagrid('fixRowHeight');
                }
            });
            // 设置分页控件
            grid.datagrid('getPager').pagination({
                beforePageText: '第',
                // 页数文本框前显示的汉字
                afterPageText: '页    共 {pages} 页',
                displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录'
            });
        }
        //弹出详细信息窗口
        function oppenInfo(index) {
            var row = grid.datagrid('getData').rows[index];
            if (row) {
                SL.showWindow({
                    title: '建筑垃圾处置证',
                    width: 540,
                    height: 420,
                    top: 4,
                    url: 'qyzInfo.jsp',
                    onLoad: function () {
                        $('#czzPostForm').form('load', row);
                        $("#bztime").val(new Date().format("yyyy-MM-dd hh:mm:ss"));
                    },
                });
            }
        }
        //弹出申办清运证窗口
        function feeOK(index) {
            var row = grid.datagrid('getData').rows[index];
            if (row) {
                SL.showWindow({
                    title: '建筑垃圾处置证',
                    width: 800,
                    height: 400,
                    top: 40,
                    url: 'qyzAdd.jsp',
                    onLoad: function () {

                        $('#czzPostForm').form('load', row);
                        $('#jdGroupId').val(row.groupId);

                        $('#carListGrid').datagrid({
                            url: '../vehicle/getAllGps.htmls',
                            queryParams: {
                                cid: row.groupId
                            },
                            fit: true,
                            nowrap: true, // false:折行
                            rownumbers: true, // 行号
                            striped: true, // 隔行变色
                            singleSelect: false,// 是否单选
                            loadMsg: '数据加载中,请稍后……',
                            columns: [[{field: 'ck', checkbox: true},
                                {field: 'selfNumber', title: '自编号',width: 100},
								{field: 'carName', title: '车牌号'},
                                {
                                    field: 'wzCount', title: '违章情况', align: 'center',
                                    formatter: function (val, row, index) {
                                        if (row.wzCount > 0) {
                                            return "<div  style='background-color:#FFFF00;text-align:center;margin:0px;padding:0px;color:#000000;'>异常(" + row.wzCount + ")起</div>";
                                        }
                                        return "<div  style='background-color:green;text-align:center;margin:0px;padding:0px;color:#FFFFFF;'>正常</div>";
                                    }
                                },
                                {
                                    field: 'state2', title: '状态', width: 80, align: 'center',
                                    formatter: function (val, row, index) {
                                        // 第一步、根据gps时间和服务器时间是否相同，判断是 在线 还是 离线。
                                        // 第二步、判断是否有速度，没有速度显示静止
                                        if (row.av == 0) {
                                            return "<div  style='background-color: #333;text-align:center;margin:0px;padding:0px;color:#FFFFFF;'>无效定位</div>";
                                        } else {
                                            if (!row.state2) {
                                                return "<div  style='background-color:red;text-align:center;margin:0px;padding:0px;color:#FFFFFF;'>离线</div>";
                                            } else {
                                                return "<div  style='background-color:green;text-align:center;margin:0px;padding:0px;color:#FFFFFF;'>在线</div>";
                                            }
                                        }
                                    }
                                }
                            ]],
                            onLoadSuccess: function (data) {
                                if (data.total == 0) {
                                    var body = $(this).data().datagrid.dc.body2;
                                    body.find('table tbody').append('<tr><td width="' + body.width() + '" style="height: 35px; text-align: center;"><h1>暂无数据</h1></td></tr>');
                                }
                            },
                            onDblClickRow: function (rowIndex, rowData) {
                                if (rowData.av == 0) {
                                    if (confirm("无效定位，请联系服务商检测设备。是否继续办理？")) {
                                        $('#carName').val(rowData.carName);
                                    }
                                } else {
                                    if (row.state2) {
                                        $('#carName').val(rowData.carName);
                                        $('#carId').val(rowData.id);
                                    } else {
                                        if (confirm("当前车辆离线，是否继续办理？")) {
                                            $('#carName').val(rowData.carName);
                                        }
                                    }
                                }
                            },
                            onClickRow: function (rowIndex, rowData){
                                //单击行的时候，判断违章情况和定位状态
                               if(rowData.wzCount > 0){
                                   $.messager.alert('信息提示', '该车辆存在违章记录，请先处理', 'info');
                                   $(this).datagrid('unselectRow', rowIndex);
							   }
                                if (rowData.av == 0) {
                                    $.messager.alert('信息提示', '车辆无效定位，无法办理', 'info');
                                    $(this).datagrid('unselectRow', rowIndex);
                                } else {
                                    if (!rowData.state2) {
                                        $.messager.alert('信息提示', '车辆离线，无法办理', 'info');
                                        $(this).datagrid('unselectRow', rowIndex);
                                    }
                                }
							}
                        });
                        $('#qydwBox').combobox({
                            url: '../group/list.htmls',
                            prompt: '选择借调单位搜索',
                            valueField: 'id',
                            textField: 'name',
// 						required : true,
                            onSelect: function (record) {
                                //实时获取页面选中车队的id
                                $('#jdGroupId').val(record.id);
                                $('#carListGrid').datagrid({
                                    url: '../vehicle/getAllGps.htmls',
                                    queryParams: {
                                        cid: record.id
                                    }
                                });
                            }
                        });
                    },
                });
            }
        }
        function reloadCar() {
            var gid;
            var id = $('#groupId').val();
            var jdid = $('#jdGroupId').val();
            if (id != jdid) {
                gid = jdid;
            } else {
                gid = id;
            }
            $('#carListGrid').datagrid({
                url: '../vehicle/getAllGps.htmls',
                queryParams: {
                    cid: gid
                }
            });
        }
        function printSBB(page) {

            parent.SL.showWindow({
                title: '建筑垃圾清运证',
                width: 820,
                height: 580,
                top: 30,
                url: 'czz/sbb.jsp',
                onLoad: function () {
                    // 				$('#czzPostForm').form('load', row);
                    // 				$("#bztime").val(new Date().format("yyyy-MM-dd hh:mm:ss"));
                },
            });
        }
        function saveData() {
            if ($("#czzPostForm").form('enableValidation').form('validate')) {
                var data = $('#czzPostForm').serialize();
                $.ajax({
                    type: "POST",
                    url: "../qyz/save.htmls",
                    data: data,
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.success) {
                            SL.closeWindow();
                            grid.datagrid('load');
                        }
                    }
                });
            }
        }
        //办理车辆清运证
        function saveTranspot() {

            var vdTimeStart = $("#vdTimeStart").val();
            var vdTimeEend = $("#vdTimeEend").val();
            if (vdTimeStart == "") {
                $.messager.alert('信息提示', '请选择有效期限', 'info');
                return;
            } else {
                if (vdTimeEend == "") {
                    $.messager.alert('信息提示', '请选择有效期限', 'info');
                    return;
                }
            }
            var rows = $('#carListGrid').datagrid('getChecked');
            var ids = [];
            if (rows.length > 0) {
                $.each(rows, function (index, item) {
                    ids.push(item.id);
                });
            } else {
                $.messager.alert('信息提示', '请选择车辆', 'info');
            }
            if ($("#czzPostForm").form('enableValidation').form('validate')) {
// 			var data = $('#czzPostForm').serialize();
                var data = {
                    ids: ids,
// 					fid : $('#fid').val(),
                    jsUnit: $('#jsUnit').val(),
                    groupName: $('#groupName').val(),
                    gcName: $('#gcName').val(),
                    site: $('#site').val(),
                    carNumber: $('#carName').val(),
// 					czArea : $('#czArea').combobox('getValue'),
                    czArea: $('#czArea').val(),
                    line: $('#line').val(),
                    vdTimeStart: $('#vdTimeStart').val(),
                    vdTimeEend: $('#vdTimeEend').val(),
                    managers: $('#managers').val(),
                    groupId: $('#groupId').val(),
                    vdTime: $("input[id='vdTime']:checked").val(),
                    jdGroupId: $('#jdGroupId').val()
                };
                $.ajax({
                    type: "POST",
                    url: "../tran/save.htmls",
                    data: data,
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.success) {
                            $.messager.alert('信息提示', '办理成功！', 'info');
                        } else {
                            $.messager.alert('信息提示', '系统 异常', 'info');
                        }
                    }
                });
            }
        }


        function searchCar() {
            var data = {
                carName: $("#carnumber").val()
            };
            $.ajax({
                type: "POST",
                url: "../vehicle/carGps.htmls",
                data: data,
                dataType: "json",
                async: false,
                success: function (data) {
                    if (data.success) {
                        if (data.flag) {
                            $('#carId').val(data.carId);
                            $('#carName').val($("#carnumber").val());
                            $('#jdstate').val("1");
                        } else {
                            if (confirm("该车辆离线，是否继续办理？")) {
                                $('#carId').val(data.carId);
                                $('#carName').val($("#carnumber").val());
                                $('#jdstate').val("1");
                            }
                        }
                    } else {
                        $.messager.alert('信息提示', '该车辆不存在，请重新输入，或更新车辆列表。', 'info');
                    }

                }
            });

        }


        function startTimeFocus() {
            return WdatePicker({
// 	        minDate:'#F{$dp.$D(\'endTime\',{d:-30});}',
// 	        maxDate : '#F{$dp.$D(\'endTime\')||\'%y-%M-%d\'}',
// 	        doubleCalendar:true,
                onpicked: function () {
                    $dp.$('vdTimeEend').focus();
                },
                dateFmt: 'yyyy-MM-dd'
            });
        }

        function endTimeFocus() {
            return WdatePicker({
                minDate: '#F{$dp.$D(\'vdTimeStart\')}',
//                maxDate: '#F{$dp.$D(\'vdTimeStart\',{d:60})||\'%y-%M-%d\'}',
                doubleCalendar: true,
                dateFmt: 'yyyy-MM-dd'
            });
        }

	</script>
</head>
<body class="easyui-layout" data-options="fit:true">
<div id="grid-toolbar">
	<div class="wu-toolbar-button">
		<form id="gridForm">
			<label>工程名称：</label><input id="s_gcName" class="easyui-textbox" style="width:150px">
			<label>字&nbsp;&nbsp;号：</label><input id="s_zNumber" class="easyui-textbox" style="width:150px">
			<label>建设单位：</label><input id="s_jsUnit" type="text" class="easyui-textbox" style="width:150px"/>
			<label>清运单位：</label><input id="s_groupName" type="text" class="easyui-textbox" style="width:150px"/>
			<a id="search_btn" href="#" class="easyui-linkbutton" iconCls="icon-search">检索</a>
		</form>
	</div>
</div>
<!-- End of toolbar -->
<table id="listGrid" class="easyui-datagrid" toolbar="#grid-toolbar"></table>
</body>
</html>