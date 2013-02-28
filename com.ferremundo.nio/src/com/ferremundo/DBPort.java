package com.ferremundo;

import java.net.URLDecoder;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ferremundo.InvoiceLog.LogKind;
import com.ferremundo.db.Mongoi;
import com.google.gson.Gson;
import com.mongodb.BasicDBObject;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

public class DBPort extends HttpServlet{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private static final String MAKE_RECORD="@rc";
	private static final String RETURN_RECORDS="@rr";

	private static final String DEACTIVATE_RECORD = "@rb";
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response){
		try{
			int clientReference=new Integer(request.getParameter("clientReference"));
			OnlineClient onlineClient=OnlineClients.instance().get(clientReference);
			response.setCharacterEncoding("utf-8");
			response.setContentType("application/json");
			String command=request.getParameter("command");
			if(command==null){
				response.setStatus( HttpServletResponse.SC_BAD_REQUEST);
				response.getWriter().write("comando indefinido");
				return;
			}
			String dc=URLDecoder.decode(command,"utf-8");
			if(dc.equals(MAKE_RECORD)){
				makeRecord(request, response, onlineClient);
				return;
			}
			else if(dc.equals(DEACTIVATE_RECORD)){
				deactivateRecord(request, response, onlineClient);
				return;
			}
			else if(dc.equals(RETURN_RECORDS)){
				returnRecords(request, response, onlineClient);
				return;
			}
			else{
				response.setStatus( HttpServletResponse.SC_BAD_REQUEST);
				response.getWriter().write("comando indefinido");
				return;
			}
			
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	public static void main(String[] args) {
		DBCursor dbCursor=new Mongoi().
				doFindFieldsMatches(
						Mongoi.TEMPORAL_RECORDS, 
						new String[]{"todo","login"},
						new Object[]{true,"root"});
		for(DBObject dbo : dbCursor){
			System.out.println(dbo);
		}
	}
	private void returnRecords(HttpServletRequest request,
			HttpServletResponse response, OnlineClient onlineClient) {
		try{
			if(
					!onlineClient.isAuthenticated(request)&&!(
					onlineClient.hasAccess(AccessPermission.BASIC)||
					onlineClient.hasAccess(AccessPermission.ROOT)
					)){
				response.setStatus( HttpServletResponse.SC_UNAUTHORIZED);
				response.getWriter().write("acceso denegado");
				return;
			}
			if(requestHasArg(request, "args")){
				String args=request.getParameter("args");
				if(!args.equals("")){
					if(Utils.isIntegerParseInt(args)){
						int n=Integer.parseInt(args);
						DBCursor dbCursor=new Mongoi().
								doFindFieldsMatches(
										Mongoi.TEMPORAL_RECORDS, 
										new String[]{"todo","login"},
										new Object[]{true,onlineClient.getShopman().getLogin()}).limit(n);
						String json="{ \"records\" : [";
						
						int i=0;
						while(dbCursor.hasNext()){
							json+=(i!=0?",":"")+dbCursor.next().toString();
							i++;
						}
						json+="] } ";
						response.getWriter().write(json);
						return;
					}
					else{
						response.setStatus( HttpServletResponse.SC_NOT_ACCEPTABLE);
						response.getWriter().write("ERROR: argumento no valido. Intenta ingresar un valor entero valido");
						return;
					}
				}
				else{
					DBCursor dbCursor=new Mongoi().
							doFindFieldsMatches(
									Mongoi.TEMPORAL_RECORDS, 
									new String[]{"todo","login"},
									new Object[]{true,onlineClient.getShopman().getLogin()});
					String json="{ \"records\" : [";
					
					int i=0;
					while(dbCursor.hasNext()){
						json+=(i!=0?",":"")+dbCursor.next().toString();
						i++;
					}
					json+="] } ";
					response.getWriter().write(json);
					return;
				}
			}
			else{
				response.setStatus( HttpServletResponse.SC_UNAUTHORIZED);
				response.getWriter().write("ERROR: argumentos no especificados");
				return;
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
	}
	private void deactivateRecord(HttpServletRequest request,
			HttpServletResponse response, OnlineClient onlineClient) {
		try{
			if(
					!onlineClient.isAuthenticated(request)&&!(
					onlineClient.hasAccess(AccessPermission.BASIC)||
					onlineClient.hasAccess(AccessPermission.ROOT)
					)){
				response.setStatus( HttpServletResponse.SC_UNAUTHORIZED);
				response.getWriter().write("acceso denegado");
				return;
			}
			if(requestHasArg(request, "args")){
				String args=request.getParameter("args");
				if(!args.equals("")){
					String id=URLDecoder.decode(args,"utf-8");
					TemporalRecord tr=TemporalRecord.deactivate(new Long(id));
					if(tr!=null){
						response.getWriter().write("{\"record\" : "+new Gson().toJson(tr)+"}");	
						return;
					}
					else{
						response.setStatus( HttpServletResponse.SC_UNAUTHORIZED);
						response.getWriter().write("ERROR: id invalido");
						return;	
					}
					
				}
				else{
					response.setStatus( HttpServletResponse.SC_UNAUTHORIZED);
					response.getWriter().write("ERROR: argumentos no especificados");
					return;
				}
			}
			else{
				response.setStatus( HttpServletResponse.SC_UNAUTHORIZED);
				response.getWriter().write("ERROR: argumentos no especificados");
				return;
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
	}
	private void makeRecord(HttpServletRequest request,
			HttpServletResponse response, OnlineClient onlineClient) {
		try{
			if(
					!onlineClient.isAuthenticated(request)&&!(
					onlineClient.hasAccess(AccessPermission.BASIC)||
					onlineClient.hasAccess(AccessPermission.ROOT)
					)){
				response.setStatus( HttpServletResponse.SC_UNAUTHORIZED);
				response.getWriter().write("acceso denegado");
				return;
			}
			if(requestHasArg(request, "args")){
				String args=request.getParameter("args");
				if(!args.equals("")){
					String record=URLDecoder.decode(args,"utf-8");
					TemporalRecord tm=new TemporalRecord(record, onlineClient.getShopman().getLogin());
					boolean success=tm.persist();
					if(success){
						response.getWriter().write("{\"message\" : \"record creado\", \"record\" : "+new Gson().toJson(tm)+" }");
						return;
					}
					else{
						response.setStatus( HttpServletResponse.SC_CONFLICT);
						response.getWriter().write("ERROR: no se registro. error desconocido");
						return;
					}
				}
				else{
					response.setStatus( HttpServletResponse.SC_UNAUTHORIZED);
					response.getWriter().write("ERROR: argumentos no especificados");
					return;
				}
			}
			else{
				response.setStatus( HttpServletResponse.SC_UNAUTHORIZED);
				response.getWriter().write("ERROR: argumentos no especificados");
				return;
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
		
	
	private boolean requestHasArg(HttpServletRequest request,String argName){
		String arg=request.getParameter(argName);
		if(arg!=null)return true;
		return false;
	}
	private void incrementAgentEarning(HttpServletRequest request, HttpServletResponse response,OnlineClient onlineClient){
		try{
			if(
					!onlineClient.isAuthenticated(request)&&!(
					onlineClient.hasAccess(AccessPermission.AGENT_INCREMENT_EARNINGS)||
					onlineClient.hasAccess(AccessPermission.ROOT)
					)){
				response.setStatus( HttpServletResponse.SC_UNAUTHORIZED);
				response.getWriter().write("acceso denegado");
				return;
			}
			if(requestHasArg(request, "args")){
				String args=request.getParameter("args");
				if(!args.equals("")){
					String[] argsspl=URLDecoder.decode(args,"utf-8").split(" ");
					if(argsspl.length==3){
						String ref=argsspl[0].toUpperCase();
						String cancelIssue="";
						for(int i=3;i<argsspl.length;i++){
							if(i!=3)cancelIssue+=" ";
							cancelIssue+=argsspl[i];
						}
						DBObject oInvoice=new Mongoi().doFindOne(Mongoi.INVOICES, "{ \"reference\" : \""+ref+"\" }");
						if(oInvoice==null){
							response.setStatus( HttpServletResponse.SC_BAD_REQUEST);
							response.getWriter().write("ERROR: referencia no encontrada '"+argsspl[0]+"'");
							return;
						}
						
						Float amount=null;
						try{
							amount=new Float(argsspl[1]);
						}
						catch(NumberFormatException exception){
							response.setStatus( HttpServletResponse.SC_BAD_REQUEST);
							response.getWriter().write("ERROR: monto inválido "+argsspl[1]);
							return;
						}
						Float oldAgentPayment=new Float(oInvoice.get("agentPayment").toString());
						Float oldTotalValue=new Float(oInvoice.get("totalValue").toString());
						
						float agentPayment=oldAgentPayment+amount;
						float newTotalValue=oldTotalValue-amount;
						if(agentPayment>=oldTotalValue){
							response.setStatus( HttpServletResponse.SC_BAD_REQUEST);
							response.getWriter().write("ERROR: monto inválido, no puede se mayor o igual que $"+(oldTotalValue-oldAgentPayment));
							return;
						}
						InvoiceLog log=new InvoiceLog(InvoiceLog.LogKind.AGENT_INCREMENT_EARNINGS,amount,onlineClient.getShopman().getLogin());
						new Mongoi().doUpdate(Mongoi.INVOICES, "{ \"reference\" : \""+ref+"\" }", "{ \"agentPayment\" : \""+agentPayment+"\" }");
						new Mongoi().doUpdate(Mongoi.INVOICES, "{ \"reference\" : \""+ref+"\" }", "{ \"totalValue\" : \""+newTotalValue+"\" }");
						new Mongoi().doPush(Mongoi.INVOICES, "{ \"reference\" : \""+ref+"\"}", "{\"logs\" : "+new Gson().toJson(log)+" }");
						new Mongoi().doUpdate(Mongoi.INVOICES, "{ \"reference\" : \""+ref+"\"}", "{\"updated\" : "+log.getDate()+" }");
						DBObject oInvoice2=new Mongoi().doFindOne(Mongoi.INVOICES, "{ \"reference\" : \""+ref+"\" }");
						response.getWriter().write("{ \"invoice\" :"+oInvoice2.toString()+" , \"message\": \"se agregó "+amount+" exitosamente\" }");
					}
					else if(argsspl.length<2){
						response.setStatus( HttpServletResponse.SC_UNAUTHORIZED);
						response.getWriter().write("ERROR: especifica el monto");
						return;
					}
					else {
						response.setStatus( HttpServletResponse.SC_UNAUTHORIZED);
						response.getWriter().write("ERROR: argumentos invalidos");
						return;
					}
				}
				else{
					response.setStatus( HttpServletResponse.SC_UNAUTHORIZED);
					response.getWriter().write("ERROR: argumentos no especificados");
					return;
				}
			}
			else{
				response.setStatus( HttpServletResponse.SC_UNAUTHORIZED);
				response.getWriter().write("ERROR: argumentos no especificados");
				return;
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}

	private void methodTemplate(HttpServletRequest request, HttpServletResponse response,OnlineClient onlineClient){
		try{
			if(
					!onlineClient.isAuthenticated(request)&&!(
					onlineClient.hasAccess(AccessPermission.AGENT_INCREMENT_EARNINGS)||
					onlineClient.hasAccess(AccessPermission.ROOT)
					)){
				response.setStatus( HttpServletResponse.SC_UNAUTHORIZED);
				response.getWriter().write("acceso denegado");
				return;
			}
			if(requestHasArg(request, "args")){
				String args=request.getParameter("args");
				if(!args.equals("")){
					String[] argsspl=URLDecoder.decode(args,"utf-8").split(" ");
				}
				else{
					response.setStatus( HttpServletResponse.SC_UNAUTHORIZED);
					response.getWriter().write("ERROR: argumentos no especificados");
					return;
				}
			}
			else{
				response.setStatus( HttpServletResponse.SC_UNAUTHORIZED);
				response.getWriter().write("ERROR: argumentos no especificados");
				return;
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}

}
