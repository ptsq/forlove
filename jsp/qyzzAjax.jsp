<%@page import="forlove.CorpQualifications"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="base.general.*" %>
<%
String src = Util.null2String(request.getParameter("src"));
if(src.equals("querydata")){
String pg = request.getParameter("pg");
String pgsz = request.getParameter("pgsz");
String apt_code = request.getParameter("apt_code");
String qy_name = Util.null2String(request.getParameter("qy_name"));
System.out.println("pg=" + pg + ",pgsz=" + pgsz + ",apt_code=" + apt_code);
CorpQualifications cq = new CorpQualifications();
String str = cq.getData(apt_code, "",qy_name, pg, pgsz);
out.clear();
out.print(str);
}
if(src.equals("selectzz")){
	String zzname = Util.null2String(request.getParameter("zzname"));
	CorpQualifications cq = new CorpQualifications();
	String result = cq.aptData(zzname);
	out.clear();
	out.print(result);
}
//out.close();
%>