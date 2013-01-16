package com.ferremundo;

import java.net.URLDecoder;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ferremundo.InvoiceLog.LogKind;
import com.ferremundo.db.Mongoi;
import com.google.gson.Gson;
import com.mongodb.DBObject;

public class InvoiceCancelling extends HttpServlet{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response){
		try{
			int clientReference=new Integer(request.getParameter("clientReference"));
			OnlineClient onlineClient=OnlineClients.instance().get(clientReference);
			response.setCharacterEncoding("utf-8");
			response.setContentType("application/json");
			if(!onlineClient.isAuthenticated(request)&&!(
					onlineClient.hasAccess(AccessPermission.INVOICE_CANCEL)||
					onlineClient.hasAccess(AccessPermission.ROOT)
					)){
				response.setStatus( HttpServletResponse.SC_UNAUTHORIZED);
				response.getWriter().write("acceso denegado");
			}
			String argsParam=request.getParameter("args");
			String args=URLDecoder.decode(argsParam,"utf-8").toUpperCase();
			String invoiceREF=null;
			DBObject oInvoice=null;
			Invoice invoice=null;
			String[] argsspl=null;
			if(!args.equals("")){
				argsspl=args.split(" ");
				if(argsspl.length>=3){
					invoiceREF=argsspl[0].toUpperCase();
					oInvoice=new Mongoi().doFindOne(Mongoi.INVOICES, "{ \"reference\" : \""+invoiceREF+"\" }");
					if(oInvoice==null){
						response.setStatus( HttpServletResponse.SC_BAD_REQUEST);
						response.getWriter().write("error: referencia no encontrada '"+argsspl[0]+"'");
						return;
					}
					invoice=new Gson().fromJson(oInvoice.toString(), InvoiceFM01.class);
					if(invoice.attemptToLog(LogKind.CANCEL).isAllowed()){
						InvoiceLog log=new InvoiceLog(InvoiceLog.LogKind.CANCEL,true,onlineClient.getShopman().getLogin());
						InvoiceLog closeLog=new InvoiceLog(InvoiceLog.LogKind.CLOSE,true,onlineClient.getShopman().getLogin());
						new Mongoi().doPush(Mongoi.INVOICES, "{ \"reference\" : \""+invoiceREF+"\"}", "{\"logs\" : "+new Gson().toJson(log)+" }");
						new Mongoi().doPush(Mongoi.INVOICES, "{ \"reference\" : \""+invoiceREF+"\"}", "{\"logs\" : "+new Gson().toJson(closeLog)+" }");
						new Mongoi().doUpdate(Mongoi.INVOICES, "{ \"reference\" : \""+invoiceREF+"\"}", "{\"updated\" : "+closeLog.getDate()+" }");
						float cashIn=0;
						if(invoice.hasLog(LogKind.AGENT_PAYMENT))cashIn=invoice.getAgentPayment();
						float cashOut=invoice.getTotal()-invoice.getDebt();
						TheBox.instance().plus(cashIn-cashOut);
						TheBox.instance().addLog(new TheBoxLog(
								cashOut-cashIn, 
								log.getDate(),
								invoice.getReference(),
								LogKind.CANCEL.toString(),
								onlineClient.getShopman().getLogin()
								));
						String successResponse="CANCELADO "+invoice.getReference()+": se realizó entrada-salida en caja $"+cashIn+"-$"+cashOut+" --> $"+(cashIn-cashOut);
						response.getWriter().write("{ \"message\":\""+successResponse+"\" }");
						return;
					}
					else {
						response.setStatus( HttpServletResponse.SC_UNAUTHORIZED);
						response.getWriter().write(invoice.attemptToLog(LogKind.CANCEL).getMessage());
						return;
					}
				}
				else{
					response.setStatus( HttpServletResponse.SC_UNAUTHORIZED);
					response.getWriter().write("");
					return;
				}
			
			}
			else{
				response.setStatus( HttpServletResponse.SC_BAD_REQUEST);
				response.getWriter().write("error: define una referencia");
				return;
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}

}
