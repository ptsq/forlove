<%@page import="forlove.CorpQualifications"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE HTML>
<html>
  <head>
    <title>企业资质查询</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<jsp:include page="/common/bootstrap/bootstrapAndZtreeImport.jsp"></jsp:include>
	<link rel="stylesheet" href="${pageContext.request.contextPath }/common/jquery-ui/jquery-ui.min.css">
	<script type="text/javascript" src="${pageContext.request.contextPath }/common/jquery-ui/jquery-ui.min.js"></script>
	<style type="text/css">
	.footer{
		position: fixed;
		bottom:0px;
		width: 100%;
		
	}
	</style>
	<script type="text/javascript">
	var flag = false;
	$(function(){
		$('[data-toggle="tooltip"]').tooltip();
		// 页面加载完成，显示第一页数据
		flag = true;
		//showData(1,15);
	});
	
	function showData(){
		if(flag){
			flag = false;
		// 查询数据
		$("#div1").html("");
		var form = $("#form1").serialize();
		jQuery.ajax({
			url : "qyzzAjax.jsp?src=querydata",
			method:"POST",
			data : form,
			dataType : "text",
			beforeSend: function () {
				ShowDiv();
			},
			complete: function () {
				HiddenDiv();
			},
			success : function(data){
				flag = true;
				$("#div1").html(data);
			}
		});
		}
	}
	function previousFun(t){
		if(flag){
		var no = $("#curno").val();
		no = no*1-1;
		if(no<1){
			alert("当前已经是第一页了。");	
		}else{
		$("#curno").val(no);
		showData();
		}
		}else{
			alert("请等待当前检索完成在执行新的任务。");
		}
	}
	function nextFun(t){
		if(flag){
		var no = $("#curno").val();
		no = no*1+1;
		$("#curno").val(no);
		showData();
		}else{
			alert("请等待当前检索完成在执行新的任务。");
		}
	}
	function ShowDiv(){
		$("#loading").show();
	}
	function HiddenDiv(){
		$("#loading").hide();
	}
	
	/**
	 * 生成遮罩
	 * @param context
	 * @param soh
	 * @param cl
	 */
	function showAjaxTips(context,soh,cl){
		var tips = $("#showAjaxTip");
		if(!cl){
			cl = "showAjaxTip";
		}
		if(tips.length==0){
			tips = $("<div id='showAjaxTip' style='font-size:12px;' class='"+cl+"'></div>");
			$("body").append(tips);
		}
		if(soh){
			tips.show();
			tips.css({
				"position":"fixed","top":0,"left":0,"width":"100%","height":"100%","background":"#f8f8f8","opacity":"0.6","z-index":"15000"
			});
			tips.html("<div style='position:absolute;top:50%;left:50%;margin-top:-15px;margin-left:-15px;'><img src='/vote/common/bootstrap/zTreeStyle/img/loading.gif' style='width:30px;height:30px;' /><div style='margin-left:-10px;'>"+context+"</div></div>");
		}else{
			tips.hide();
		}
	}
	/*
	输入框改变
	存在：后端取得大类
	不存在：使用预置的4个选项
	*/
	function selectzz(t){
		var select_zz = $("#select_zz").val();
		if(select_zz == ""){
			var op = '<option value="search">根据企业名称查询</option><option value="D211A">建筑装修装饰工程专业承包一级</option><option value="D101A">建筑工程施工总承包一级</option><option value="D211B">建筑装修装饰工程专业承包二级</option>';
			$("#apt_code").html(op);
		}else{
			$("#apt_code").html("");
			$.ajax({
				//async:false,
			  	type: 'POST',
			  	url: "qyzzAjax.jsp?src=selectzz",
			  	beforeSend:function(){
					try{
						showAjaxTips('正在查询...',true);
					}catch(e){alert(e);}
				},
				complete:function(){
					showAjaxTips('',false);
				},
			  	data: {"zzname":select_zz},
			  	dataType: "json",
			  	success: function(result){
			  		var op = "";
			  		console.log(result)	
					for(i in result){
						op+='<option value="'+result[i].apt_code+'">'+result[i].apt_scope+'</option>';
					}
			  		$("#apt_code").html(op);
			  	}
			});
		}
	}
	/*
	点击时显示帮助框
	*/
	function showHelp(){
		$(".footer").show(500);
		$("#helpbtn").hide();
	}
	function hideHelp(){
		$(".footer").hide();
		$("#helpbtn").show();
	}
	</script>
  </head>
  
  <body>
  <div class="container-build" >
  	<!-- 查询条件 -->
  	<div class="panel panel-info">
  	<div class="panel-heading">查询条件</div>
  	<div class="panel-body">
  		<form id="form1" class="form-inline">
  			<!-- 当前页数 -->
  			<input type="hidden" id="curno" name="pg" value="1" />
  			<input type="hidden" id="pgsz" name="pgsz" value="15" />
  			<div class="form-group">
  				<label for="select_zz">选择资质</label>
  				<input type="text" id="select_zz" name="select_zz" class="form-control" value="" onchange="selectzz(this);"/>
  			</div>
  			<div class="form-group">
	  			<label for="apt_code">选择大类</label>
	  			<select id="apt_code" name="apt_code" class="form-control" style="width:244px;" onclick="">
	  				 <option value="search">根据企业名称查询</option>
	  				<option value="D211A">建筑装修装饰工程专业承包一级</option>
	  				<option value="D101A">建筑工程施工总承包一级</option>
	  				<option value="D211B">建筑装修装饰工程专业承包二级</option>
	  			</select>
  			</div>
  			<div class="form-group">
  				<label for="qy_name">企业名称</label>
  				<input type="text" id="qy_name" name="qy_name" class="form-control" value="" />
  			</div>
  			<a href="javascript:;" class="btn btn-primary btn-sm" onclick="showData();">查询</a>
  		</form>
  	</div><!-- panel-body end -->
  	</div><!-- panel end -->
  	<!-- 数据正文 -->
  	<div class="panel panel-success" >
  	<div class="panel-body">
  <div id="loading" class="alert alert-danger" role="alert" style="display:none;">请等待...</div>
  	<!-- 数据显示 -->
    <div id="div1" class="container-fluid">
	</div>
	
	<nav aria-label="...">
  <ul class="pager">
    <li class="previous"><a href="javascript:;" onclick="previousFun(this);"><span aria-hidden="true">&larr;</span> 上一页</a></li>
    <li class="next"><a href="javascript:;" onclick="nextFun(this);">下一页 <span aria-hidden="true">&rarr;</span></a></li>
  </ul>
</nav>
</div><!-- panel-body end -->
</div><!-- panel end -->
<!-- 使用说明 -->
<div class="footer">
<div class="panel panel-success">
  	<div class="panel-heading">使用说明<button type="button" class="close" onclick="hideHelp();" aria-label="Close"><span aria-hidden="true">&times;</span></button></div>
  	<div class="panel-body">
  	<div class="row">
  	<div class="col-xs-12 col-md-6">
<div class="media">
  <div class="media-body">
    <h5 class="media-heading">单个企业查询</h5>
    <p><ol><li><small>选择大类下拉框中选择</small><mark>根据企业名称查询</mark></li>
    <li><small>输入要查询的企业名称，点击查询按钮即可</small></li>
    </ol>
    </p>
  </div>
</div><!-- meida end -->
</div><!-- col-xs-xx -->
<div class="col-xs-12 col-md-6">
<div class="media">
<div class="media-body">
    <h5 class="media-heading">根据资质查询</h5>
    <p><ol><li><mark>选择资质</mark><small>中输入要查询的资质（支持模糊搜索）系统会根据输入的资质去校验符合条件的内容</small></li>
    <li><small>选择大类下拉框中选择要查询的大类，点击查询按钮即可</small></li>
    </ol>
    </p>
  </div>
</div><!-- meida end -->
</div><!-- col-xs-xx -->
</div><!-- row -->
</div>
</div><!-- panel -->
</div><!-- footer -->
	</div><!-- container -->
	<!-- 右下角帮助按钮 -->
	<div id="helpbtn" style="position: fixed;bottom:5px;right:0px;display:none;">
	<a title="显示帮助" data-toggle="tooltip" data-placement="left" class="btn btn-lg" onclick="showHelp();">
		<span class="glyphicon glyphicon-user"> </span>
	</a></div>
  </body>
</html>
