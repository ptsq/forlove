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
	<script type="text/javascript">
	var flag = false;
	$(function(){
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
	/*
	点击下拉框时，先取资质名称是否存在
	存在：后端取得大类
	不存在：使用预置的4个选项
	*/
	function showType(t){
		var select_zz = $("#select_zz").val();
		if(select_zz == ""){
			var op = '<option value="search">根据企业名称查询</option><option value="D211A">建筑装修装饰工程专业承包一级</option><option value="D101A">建筑工程施工总承包一级</option><option value="D211B">建筑装修装饰工程专业承包二级</option>';
			$(t).html(op);
		}else{
			$(t).html("");
			$.ajax({
				async:false,
			  	type: 'POST',
			  	url: "qyzzAjax.jsp?src=selectzz",
			  	data: {"zzname":select_zz},
			  	dataType: "json",
			  	success: function(result){
			  		var op = "";
			  		console.log(result)	
					for(i in result){
						op+='<option value="'+result[i].apt_code+'">'+result[i].apt_scope+'</option>';
					}
			  		$(t).html(op);
			  	}
			});
		}
		return ;
	}
	</script>
  </head>
  
  <body>
  <div class="container-build">
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
  				<input type="text" id="select_zz" name="select_zz" class="form-control" value="" />
  			</div>
  			<div class="form-group">
	  			<label for="apt_code">选择大类</label>
	  			<select id="apt_code" name="apt_code" class="form-control" style="width:244px;" onclick="showType(this);return false;">
	  				 <option value="search">根据企业名称查询</option>
	  				<!--<option value="D211A">建筑装修装饰工程专业承包一级</option>
	  				<option value="D101A">建筑工程施工总承包一级</option>
	  				<option value="D211B">建筑装修装饰工程专业承包二级</option> -->
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
  	<div class="panel panel-success">
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
	</div>
  </body>
</html>
