<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>车辆准运证查询</title>
    <%@ include file="../common/taglibs.jsp" %>
    <script src="../js/LodopFuncs.js" type="text/javascript"></script>
    <script src="../js/DateUtil.js" type="text/javascript"></script>
    <script type="text/javascript">
        var grid;
        $(function () {
            loadDataGrid();
            $("#search_btn").click(function () {
                $('#listGrid').datagrid({
                    queryParams: {
                        gcName: $('#s_gcName').val(),
                        vdTimeStart: $("#s_vdTimeStart").val(),
                        vdTimeEend: $("#s_vdTimeEend").val(),
                        jsUnit: $("#s_jsUnit").val(),
                        zNumber: $("#s_zNumber").val(),
                        groupId: $("#groupId").val(),
                        jdGroupId: $("#jdGroupId").val(),
                    }
                });
                $('#gridForm').form('clear');
            });
        });
        /*加载数据*/
        function loadDataGrid() {
            grid = $('#listGrid').datagrid(
                {
                    url: '../tran/list.htmls',
                    //                                height: 390,
                    nowrap: true,
                    fit: true,
                    rownumbers: true,
                    striped: true,
                    singleSelect: false,
                    pagination: true,
                    pageSize: 20,
                    pageList: [10, 20, 30, 50, 100],
                    loadMsg: '数据加载中,请稍后……',
                    columns: [[{field: 'ck', checkbox: true},
                        {
                            field: '_operate', title: '操作', align: 'center', width: 90,
                            formatter: function (val, row, index) {
                                var str = "";
                                str += ' <a class="editcls" href="#"  onclick="printView(' + index + ')">打印</a>';
                                return str;
                            }
                        },
//                         {
//                             field: 'approved', title: '核准', width: 60, align: 'center',
//                             formatter: function (value, row) {
//                                 var s = "";
//                                 if (value == "1") {

//                                     s = "<div  style='background-color:green;text-align:center;margin:0px;padding:0px;color:#FFFFFF;'>已核准</div>";
//                                 } else {
//                                     s = "<div  style='background-color:#999999;text-align:center;margin:0px;padding:0px;color:#FFFFFF;'>待核准</div>";
//                                 }
//                                 return s;
//                             }
//                         },
                        {field: 'zNumber', title: '字号'},
                        {
                            field: 'carNumber', title: '车牌号',
                            formatter: function (val, row, index) {
                                if (row.groupId != row.jdGroupId) {
                                    return "借●" + row.carNumber;
                                }
                                return row.carNumber;
                            }
                        },
                        {field: 'gcName', title: '工程名称'},
                        {field: 'jsUnit', title: '建设单位'},
                        {field: 'site', title: '施工地点'},
                        {field: 'czArea', title: '处置场地'},
                        {field: 'line', title: '路线'},
                        {
                            field: 'vdTime', title: '有效期',
                            formatter: function (val, row, index) {
                                if (row.vdTimeEend != null
                                    || row.vdTimeEend != undefined) {
                                    return row.vdTimeStart + "/"
                                        + row.vdTimeEend;
                                }

                            }
                        },
                        {field: 'managers', title: '办理人'},
                        {
                            field: 'entryTime',
                            title: '办理时间'
                        }]],
                    onLoadSuccess: function (data) {
                        $('.editcls').linkbutton({text: '打印', plain: true, iconCls: 'icon-print'});
                        grid.datagrid('fixRowHeight');
//                         for (var i = 0; i < data.rows.length; i++) {
//                             if (data.rows[i].approved != 1) {
//                                 //禁用checkbox
//                                 $(".datagrid-row[datagrid-row-index=" + i + "] input[type='checkbox']")[0].disabled = true;
//                             }
//                         }
                    }
//                     onClickRow: function (rowIndex, rowData){
//                         //单击行的时候，判断违章情况和定位状态
//                         if(rowData.approved != 1){
//                             $(this).datagrid('unselectRow', rowIndex);
//                         }
//                     }
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
                    width: 520,
                    height: 350,
                    url: 'zyzInfo.jsp',
                    onLoad: function () {
                        $('#dataForm').form('load', row);
                        if (row.groupId != row.jdGroupId) {
                            alert("借●" + row.carNumber)
                            $('#carNumber').val("借●" + row.carNumber);
                        }
                    },
                    buttons: [{
                        text: '打印',
                        handler: function () {
                            printView(row);
                        }
                    }, {
                        text: '关闭',
                        handler: function () {
                            SL.closeWindow();
                        }
                    }]
                });
            }
        }
        //打印
        function printView(index) {
            var row = grid.datagrid('getData').rows[index];
//             if (row.approved != 1) {
//                 $.messager.alert('信息提示', '该车辆未核准，请重新选择！', 'info');
//                 return;
//             }
            initView(row);
//             LODOP.PREVIEW();
//             LODOP.PRINT_DESIGN();
            LODOP.PRINTA();
        }
        var LODOP; //声明为全局变量
        function initView(row) {
            var carNumber = "";
            if (row.groupId != row.jdGroupId) {

                carNumber = "借●" + row.carNumber;
            }else {
                carNumber = row.carNumber;
            }
            LODOP = getLodop();
            LODOP.PRINT_INITA("0mm", "0mm", "255mm", "115mm", "打印车辆处置证");
            LODOP.SET_PRINT_PAGESIZE(1, "255mm", "115mm", "打印车辆处置证");
// 		名称：设定纸张大小
// 		格式：SET_PRINT_PAGESIZE(intOrient, PageWidth,PageHeight,strPageName)
            //头部编号
            LODOP.ADD_PRINT_TEXT(20, 130, 113, 25, row.zNumber);
            LODOP.SET_PRINT_STYLEA(0, "FontSize", 13);
            LODOP.SET_PRINT_STYLEA(0, "Bold", 1);

            LODOP.ADD_PRINT_TEXT(20, 770, 100, 25, row.zNumber);
            LODOP.SET_PRINT_STYLEA(0, "FontSize", 13);
            LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
            //左侧存根
            LODOP.ADD_PRINT_TEXT(180, 100, 200, 20, "建设单位：" + row.jsUnit);
            LODOP.ADD_PRINT_TEXT(210, 100, 200, 20, "工程名称：" + row.gcName);
            LODOP.ADD_PRINT_TEXT(240, 100, 200, 20, "施工地点：" + row.site);
            LODOP.ADD_PRINT_TEXT(270, 100, 200, 20, "运输单位：" + row.groupName);
            LODOP.ADD_PRINT_TEXT(290, 100, 200, 20, "车牌号：" + carNumber);
            LODOP.ADD_PRINT_TEXT(310, 100, 200, 65, "路线：（晚23点至早5点通行）" + row.line);
            LODOP.ADD_PRINT_TEXT(370, 100, 200, 20, "处置场地：" + row.czArea);
            var da1 = DateUtil.dateToStr("yy.MM.dd", DateUtil.strToDate(row.vdTimeStart));
            var da2 = DateUtil.dateToStr("yy.MM.dd", DateUtil.strToDate(row.vdTimeEend));
            LODOP.ADD_PRINT_TEXT(390, 100, 205, 20, "有效日期：" + da1 + " - " + da2);

            //右侧清运信息
            LODOP.ADD_PRINT_TEXT(220, 320, 300, 25, "建设单位: " + row.jsUnit);
            LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
            LODOP.ADD_PRINT_TEXT(270, 320, 300, 25, "运输单位: " + row.groupName);
            LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
            LODOP.ADD_PRINT_TEXT(310, 320, 300, 25, "车 牌 号: " + carNumber);
            LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
            LODOP.ADD_PRINT_TEXT(330,320,614,50, "路    线: （晚23点至早5点通行）" + row.line);
            LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
            var da3 = DateUtil.dateToStr("yyyy-MM-dd", DateUtil.strToDate(row.vdTimeStart));
            var da4 = DateUtil.dateToStr("yyyy-MM-dd", DateUtil.strToDate(row.vdTimeEend));
            LODOP.ADD_PRINT_TEXT(385,320,525,25, "有效日期： " + da3 + "至" + da4);
            LODOP.SET_PRINT_STYLEA(0, "FontSize", 13);
            LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
            LODOP.ADD_PRINT_TEXT(220, 650, 320, 25, "工程名称： " + row.gcName);
            LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
            LODOP.ADD_PRINT_TEXT(270, 650, 320, 25, "施工地点： " + row.site);
            LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
            LODOP.ADD_PRINT_TEXT(310, 650, 320, 25, "处置场地： " + row.czArea);
            LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
            LODOP.ADD_PRINT_TEXT(350, 775, 120, 25, "发 证 机 关");
            LODOP.SET_PRINT_STYLEA(0, "FontSize", 13);
            LODOP.ADD_PRINT_TEXT(365, 760, 172, 25, DateUtil.dateToStr("yyyy年MM月dd日", DateUtil.strToDate(row.entryTime)));
            LODOP.SET_PRINT_STYLEA(0, "FontSize", 13);
            LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
        }
        function CreateOneFormPage() {

            LODOP.PRINTA();
        }

        function printList() {
            var rows = $('#listGrid').datagrid('getChecked');
            var ids = [];
            if (rows.length > 0) {
                $.messager.confirm('信息提示', '确定批量打印吗?', function (r) {
                    if (r) {
                        $.each(rows, function (index, item) {
                            initView(item);
                            LODOP.PRINT();
                        });
                    }
                });
//                if (confirm("确定批量打印吗？")) {
//                    $.each(rows, function (index, item) {
//                        initView(item);
//                        LODOP.PRINT();
//                    });
//                }

            } else {
                $.messager.alert('信息提示', '请选择要打印的车辆!', 'info');
            }
        }

    </script>
</head>
<body class="easyui-layout" data-options="fit:true">
<div id="grid-toolbar">
    <div class="wu-toolbar-button">
        <form id="gridForm">
            <label>工程名称：</label><input id="s_gcName" class="easyui-textbox" style="width:150px">
            <label>字&nbsp;&nbsp;号：</label><input id="s_zNumber" class="easyui-textbox" style="width:150px">
            <label>办理时间：</label><input id="s_vdTimeStart" class="Wdate" type="text"
                                       onFocus="WdatePicker({isShowClear:false,readOnly:true})"/>
            - <input id="s_vdTimeEend" class="Wdate" type="text"
                     onFocus="WdatePicker({isShowClear:false,readOnly:true})"/>
            <label>建设单位：</label><input id="s_jsUnit" type="text" class="easyui-textbox" style="width:150px"/>
            <a id="search_btn" href="#" class="easyui-linkbutton" iconCls="icon-search">检索</a><br/>
            <%--<a href="#" class="print"--%>
            <%--onclick="printList()"><em>批量打印</em><span></span></a>--%>
        </form>
    </div>
    <div class="wu-toolbar-search">
        <a href="#" class="easyui-linkbutton" iconCls="icon-print" onclick="printList()" plain="true">批量打印</a>
    </div>
</div>
<!-- End of toolbar -->
<table id="listGrid" class="easyui-datagrid" toolbar="#grid-toolbar"></table>
</body>
</html>