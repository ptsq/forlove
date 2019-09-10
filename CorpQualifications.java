package forlove;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import base.general.BaseBean;
import base.general.Util;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonSyntaxException;


/**
 * 全国建筑市场监管公共服务平台---企业资质查询
 * @author songqi
 * @tel 13256247773
 * 2019年8月17日 下午10:34:33
 */
public class CorpQualifications extends BaseBean {

	/**
	 * 
	 * <br/>2019年8月20日 下午10:06:36<br/>
	 * @param apt_code 类型编码
	 * @param qy_reg_addr 注册地址
	 * @param qy_name 查询使用，企业名称
	 * @param pg 第几页
	 * @param pgsz 每页显示行数
	 * @return
	 */
	public String getData(String apt_code,String qy_reg_addr,String qy_name,String pg,String pgsz) {
		if(pg.isEmpty()){
			pg = "1";
		}
		if(pgsz.isEmpty()){
			pgsz = "10";
		}
		if(qy_reg_addr.isEmpty()){
			qy_reg_addr = "山东省";
		}
		if(apt_code.isEmpty()){
			apt_code = "D101A";
		}
		String qy_region = "";	// 邮编
		if(apt_code.equals("search")){
			apt_code = "";	// 为空时根据输入的企业名称查询
		}
		// 根据企业名称查询，则企业名称不能为空
		if(apt_code.isEmpty()){
			if(null == qy_name ||qy_name.isEmpty()){
				return "";
			}
			qy_region = "";
		}else{
			qy_region = getPostCode(qy_reg_addr);
		}
		
		String html = "";
		Document doc = null;
		Map<String, String> map = new HashMap<String, String>();
		//{"apt_code":"D101A", "apt_scope":"建筑工程施工总承包一级"}
		//{"apt_code":"D211A", "apt_scope":"建筑装修装饰工程专业承包一级"}
		
		map.put("apt_scope", "");
		map.put("apt_code", apt_code);	
		map.put("qy_reg_addr", qy_reg_addr);
		map.put("qy_region", qy_region);
		if(qy_name.isEmpty()){
			map.put("$pg", pg);
			map.put("$pgsz", pgsz);
		}else{
			map.put("qy_name", qy_name);
		}
		try {
			doc = Jsoup.connect("http://jzsc.mohurd.gov.cn/dataservice/query/comp/list").data(map)
					.userAgent("Mozilla").cookie("auth", "token").timeout(300000).post();

			Elements elementsByClass = doc.getElementsByClass("mtop");
			elementsByClass.select("script").remove();
			//System.out.println("size=" + elementsByClass.size());
			Elements select = elementsByClass.select("a");
			String href = "";
			for(Element a : select){
				href = a.attr("href");
				href = "http://jzsc.mohurd.gov.cn" + href;
				a.attr("href",href);
			}
			
			html = elementsByClass.html();
		} catch (Exception e) {
			e.printStackTrace();
			html = "";
		}
//		System.out.println(html);
//		System.out.println("============");
//		html = html.replaceAll("<\\s*?script[^>]*?>[\\s\\S]*?<\\s*?/\\s*?script\\s*?>", "");
		//System.out.println("返回页面html=" + html);
		//writeLog(html);
		return html;
	}
	
	/**
	 * 根据省份取得对应邮编
	 * <br/>2019年8月18日 下午10:11:03<br/>
	 * @param name
	 * @return
	 */
	public static String getPostCode(String name){
		String code = "";
		String postcode = "";
		postcode = Util.null2String(new BaseBean().getPropValue("qyzz", "postcode"));
		if(postcode.isEmpty()){
			postcode = "{\"json\":{\"category\":{\"provinces\":[{\"region_id\":\"110000\",\"region_name\":\"北京\",\"region_fullname\":\"北京市\"},{\"region_id\":\"120000\",\"region_name\":\"天津\",\"region_fullname\":\"天津市\"},{\"region_id\":\"130000\",\"region_name\":\"河北\",\"region_fullname\":\"河北省\"},{\"region_id\":\"140000\",\"region_name\":\"山西\",\"region_fullname\":\"山西省\"},{\"region_id\":\"150000\",\"region_name\":\"内蒙古\",\"region_fullname\":\"内蒙古自治区\"},{\"region_id\":\"210000\",\"region_name\":\"辽宁\",\"region_fullname\":\"辽宁省\"},{\"region_id\":\"220000\",\"region_name\":\"吉林\",\"region_fullname\":\"吉林省\"},{\"region_id\":\"230000\",\"region_name\":\"黑龙江\",\"region_fullname\":\"黑龙江省\"},{\"region_id\":\"310000\",\"region_name\":\"上海\",\"region_fullname\":\"上海市\"},{\"region_id\":\"320000\",\"region_name\":\"江苏\",\"region_fullname\":\"江苏省\"},{\"region_id\":\"330000\",\"region_name\":\"浙江\",\"region_fullname\":\"浙江省\"},{\"region_id\":\"340000\",\"region_name\":\"安徽\",\"region_fullname\":\"安徽省\"},{\"region_id\":\"350000\",\"region_name\":\"福建\",\"region_fullname\":\"福建省\"},{\"region_id\":\"360000\",\"region_name\":\"江西\",\"region_fullname\":\"江西省\"},{\"region_id\":\"370000\",\"region_name\":\"山东\",\"region_fullname\":\"山东省\"},{\"region_id\":\"410000\",\"region_name\":\"河南\",\"region_fullname\":\"河南省\"},{\"region_id\":\"420000\",\"region_name\":\"湖北\",\"region_fullname\":\"湖北省\"},{\"region_id\":\"430000\",\"region_name\":\"湖南\",\"region_fullname\":\"湖南省\"},{\"region_id\":\"440000\",\"region_name\":\"广东\",\"region_fullname\":\"广东省\"},{\"region_id\":\"450000\",\"region_name\":\"广西\",\"region_fullname\":\"广西壮族自治区\"},{\"region_id\":\"460000\",\"region_name\":\"海南\",\"region_fullname\":\"海南省\"},{\"region_id\":\"500000\",\"region_name\":\"重庆\",\"region_fullname\":\"重庆市\"},{\"region_id\":\"510000\",\"region_name\":\"四川\",\"region_fullname\":\"四川省\"},{\"region_id\":\"520000\",\"region_name\":\"贵州\",\"region_fullname\":\"贵州省\"},{\"region_id\":\"530000\",\"region_name\":\"云南\",\"region_fullname\":\"云南省\"},{\"region_id\":\"540000\",\"region_name\":\"西藏\",\"region_fullname\":\"西藏自治区\"},{\"region_id\":\"610000\",\"region_name\":\"陕西\",\"region_fullname\":\"陕西省\"},{\"region_id\":\"620000\",\"region_name\":\"甘肃\",\"region_fullname\":\"甘肃省\"},{\"region_id\":\"630000\",\"region_name\":\"青海\",\"region_fullname\":\"青海省\"},{\"region_id\":\"640000\",\"region_name\":\"宁夏\",\"region_fullname\":\"宁夏回族自治区\"},{\"region_id\":\"650000\",\"region_name\":\"新疆\",\"region_fullname\":\"新疆维吾尔自治区\"}]}}}";
		}
		try {
			JsonParser jp = new JsonParser();
			JsonElement parse = jp.parse(postcode);
			JsonObject asJsonObject = parse.getAsJsonObject();	//转json对象
			JsonElement json = asJsonObject.get("json");	// 解包第一层到json
			JsonObject jsonObject = json.getAsJsonObject();	// 第一层解包后再转json对象
			JsonElement jsonCategory = jsonObject.get("category");	//解包第二层到category
			JsonObject jsonProvinces = jsonCategory.getAsJsonObject();
			JsonArray jsonArray = jsonProvinces.getAsJsonArray("provinces");	// 转json数组
			for(JsonElement e :jsonArray){
				JsonObject jsonObj = e.getAsJsonObject();
				JsonElement region_name = jsonObj.get("region_name");
				JsonElement region_id = jsonObj.get("region_id");
				JsonElement region_fullname = jsonObj.get("region_fullname");
				if(region_name.getAsString().equals(name) || region_fullname.getAsString().equals(name)){
					code = region_id.getAsString();
					break;
				}
			}
		} catch (JsonSyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return code;
	}

	public static void main(String[] args) {
		
		CorpQualifications tg = new CorpQualifications(); 
		//tg.getData("","","","","1","1");
		String html = tg.getData("search", "", "奉新县聚亿建筑有限公司", "", "");
		System.out.println(html);

	}

}
