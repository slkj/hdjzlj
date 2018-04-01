<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>准运证信息核准</title>
</head>
<body>
	<div style="padding-left: 10px; padding-right: 10px;">
		<form id="czzPostForm">
			<ul class="ulColumn2">
				<li><span class="item_name" style="width: 60px;">建设单位：</span> <input name="jsUnit" type="text" class="textbox textbox_165"
					readonly="readonly" /> <span class="item_name" style="width: 60px;">运输单位：</span> <input name="groupName" type="text" class="textbox textbox_165"
					readonly="readonly" /></li>
				<li><span class="item_name" style="width: 60px;">工程名称：</span> <input name="gcName" type="text" class="textbox textbox_165"
					readonly="readonly" /> <span class="item_name" style="width: 60px;">工程地点：</span> <input name="site" type="text" class="textbox textbox_165"
					readonly="readonly" /></li>
				<li><span class="item_name" style="width: 60px;">车牌号：</span> <input id="carNumber" name="carNumber" type="text" class="textbox textbox_165"
					readonly="readonly" /> <span class="item_name" style="width: 60px;">处置场地：</span> <input name="czArea" type="text" class="textbox textbox_165" />
				</li>
				<li><span class="item_name" style="width: 60px;">路线：</span> <textarea name="line" class="textarea" style="width: 380px; height: 55px;"></textarea>
					<!-- 									<input name="line" type="text" class="textbox" style="width: 400px;height: 55px;text-align:left;vertical-align:middle;" />  --></li>
				<li><span class="item_name" style="width: 60px;">有效日期：</span> <input name="vdTimeStart" class="textbox textbox_165 Wdate" type="text"
					onFocus="WdatePicker({isShowClear:false,readOnly:true,dateFmt:'yyyy-MM-dd'})" /> - <input name="vdTimeEend" class="textbox textbox_165 Wdate"
					type="text" onFocus="WdatePicker({isShowClear:false,readOnly:true,dateFmt:'yyyy-MM-dd'})" /></li>
				<li><span class="item_name" style="width: 60px;">经办人：</span> <input type="text" name="manager" class="textbox textbox_165"
					value="${userSession.realname }" readonly="readonly" /></li>
				<!-- 							<li> -->
				<!-- 								<span class="item_name" style="width:200px;"></span> -->
				<!-- 								<input type="button" value="办理" class="link_btn" onclick="saveTranspot()"/> -->
				<!-- 							</li> -->
			</ul>
		</form>
	</div>
</body>
</html>