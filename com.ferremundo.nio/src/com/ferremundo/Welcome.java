package com.ferremundo;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONException;
import org.json.JSONObject;

import com.ferremundo.db.Mongoi;
import com.google.gson.Gson;
import com.mongodb.BasicDBObject;
import com.mongodb.DBObject;

public class Welcome extends HttpServlet{
	//EntityManager emis=EMF.get(EMF.UNIT_INVOICEFM01).createEntityManager();

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
		throws ServletException, IOException{
		int clientReference=new Integer(req.getParameter("clientReference"));
		OnlineClient onlineClient=OnlineClients.instance().get(clientReference);
		if(!(onlineClient.isAuthenticated(req)&&(
				onlineClient.hasAccess(AccessPermission.CONSUMMER_CREATE)||
				onlineClient.hasAccess(AccessPermission.BASIC)||
				onlineClient.hasAccess(AccessPermission.ROOT)
				))){
			resp.sendError(resp.SC_UNAUTHORIZED,"acceso denegado");return;
		}
		
		String clientParam=req.getParameter("client");
		String clientJson="";
		try {
			clientJson = URLDecoder.decode(clientParam,"utf-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("persisting client "+clientJson);
		JSONObject jClient=null;
		try {
			jClient=new JSONObject(clientJson);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Client client=null;
		client=ClientFactory.create(jClient);
		String clientDB=Mongoi.CLIENTS;
		if(req.getParameter("agent")!=null){
			if(new Boolean(req.getParameter("agent")))clientDB=Mongoi.AGENTS;
		}
		int id=client.persist(clientDB);
		DBObject dbClient=new Mongoi().doFindOne(clientDB, "{ \"id\" : "+id+" }");
		resp.setCharacterEncoding("utf-8");
		resp.setContentType("application/json");
		System.out.println(id+" -> "+new Gson().toJson(dbClient));
		try {
			resp.getWriter().print(dbClient);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}


}
