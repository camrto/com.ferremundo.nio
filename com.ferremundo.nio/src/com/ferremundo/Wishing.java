package com.ferremundo;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLDecoder;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.ferremundo.InvoiceLog.LogKind;
import com.ferremundo.db.Mongoi;
import com.ferremundo.mailing.HotmailSend;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.mongodb.DBObject;


/**
 * Servlet implementation class Wishing
 */
public class Wishing extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Wishing() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		try{
			int clientReference=new Integer(request.getParameter("clientReference"));
			OnlineClient onlineClient=OnlineClients.instance().get(clientReference);
			response.setCharacterEncoding("utf-8");
			response.setContentType("application/json");
			if(!(onlineClient.isAuthenticated(request)&&(
					onlineClient.hasAccess(AccessPermission.INVOICE_SAMPLE)||
					onlineClient.hasAccess(AccessPermission.INVOICE_ORDER)||
					onlineClient.hasAccess(AccessPermission.INVOICE_FACTURE)||
					onlineClient.hasAccess(AccessPermission.BASIC)||
					onlineClient.hasAccess(AccessPermission.ROOT)
					))){
				response.sendError(response.SC_UNAUTHORIZED,"acceso denegado");return;
			}
			
			
			String clientParam=request.getParameter("client");
			String listParam=request.getParameter("list");
			String sellerParam=request.getParameter("seller");
			String agentParam=request.getParameter("agent");
			String requesterParam=request.getParameter("requester");
			String shopmanParam=request.getParameter("shopman");
			String destinyParam=request.getParameter("destiny");
			String argsParam=request.getParameter("args");
			String commandParam=request.getParameter("command");
			System.out.println("wishing '"+argsParam+"'");
			Float payment=0f;
			if(null!=clientParam&&null!=listParam){
				String listJson=URLDecoder.decode(listParam,"utf-8");
				String clientJson=URLDecoder.decode(clientParam,"utf-8");
				String sellerJson=URLDecoder.decode(sellerParam,"utf-8");
				String agentJson=URLDecoder.decode(agentParam,"utf-8");
				String requesterJson=URLDecoder.decode(requesterParam,"utf-8");
				String shopmanJson=URLDecoder.decode(shopmanParam,"utf-8");
				String destinyJson=URLDecoder.decode(destinyParam,"utf-8");
				String args=URLDecoder.decode(argsParam,"utf-8");
				String command=URLDecoder.decode(commandParam,"utf-8");
				JSONArray jList=null;
				JSONObject jClient=null;
				JSONObject jSeller=null;
				JSONObject jAgent=null;
				JSONObject jRequester=null;
				JSONObject jShopman=null;
				JSONObject jDestiny=null;
				LinkedList<InvoiceItem> items=new LinkedList<InvoiceItem>();
				Client client=null;
				Client agent=null;
				Seller seller=null;;
				Shopman shopman=null;
				Destiny destiny=null;
				Requester requester=null;
				
				try{
					
					jList=new JSONArray(listJson);
					jClient=new JSONObject(clientJson);
					jSeller=new JSONObject(sellerJson);
					jAgent=new JSONObject(agentJson);
					jRequester=new JSONObject(requesterJson);
					jShopman=new JSONObject(shopmanJson);
					jDestiny=new JSONObject(destinyJson);
					
					seller=new Seller(jSeller);
					shopman=onlineClient.getShopman();
					destiny=new Destiny(jDestiny);
					requester=new Requester(jRequester);
					for(int i=jList.length()-1;i>=0;i--){
						InvoiceItem item=new InvoiceItem(jList.getJSONObject(i));
						//System.out.println(item.toJson());
						items.add(item);
					}
					client=ClientFactory.create(jClient);
					agent=ClientFactory.create(jAgent);
					System.out.println(new Gson().toJson(agent));
				}catch(JSONException e){}
				
				String[] argsspl=null;
				if(!args.equals(""))argsspl=args.split(" ");
				String csv=null;
				System.out.println("command="+command);
				if(
						command.equals("@oa")||command.equals("@oc")||
						command.equals("$fa")||command.equals("$fc")||
						command.equals("$oa")||command.equals("$oc")||
						command.equals("@ia")||command.equals("@ic")){
					//String printer=argsspl[1];
					//long re

					InvoiceMetaData metaData=null;
					if(command.equals("$fc")||command.equals("$fa")){
						if(!(
								onlineClient.hasAccess(AccessPermission.INVOICE_FACTURE)||
								onlineClient.hasAccess(AccessPermission.BASIC)||
								onlineClient.hasAccess(AccessPermission.ROOT)
								)){
							response.sendError(response.SC_UNAUTHORIZED,"acceso denegado");return;
						}
						metaData=new InvoiceMetaData(Invoice.INVOICE_TYPE_TAXES_APLY);
					}
					else if(command.equals("@ic")||command.equals("@ia")){
						if(!(
								onlineClient.hasAccess(AccessPermission.INVOICE_SAMPLE)||
								onlineClient.hasAccess(AccessPermission.BASIC)||
								onlineClient.hasAccess(AccessPermission.ROOT)
								)){
							response.sendError(response.SC_UNAUTHORIZED,"acceso denegado");return;
						}
						metaData=new InvoiceMetaData(Invoice.INVOICE_TYPE_SAMPLE);
					}
					else if(command.equals("@oc")||command.equals("$oc")||
							command.equals("@oa")||command.equals("$oa")){
						if(!(
								onlineClient.hasAccess(AccessPermission.INVOICE_ORDER)||
								onlineClient.hasAccess(AccessPermission.BASIC)||
								onlineClient.hasAccess(AccessPermission.ROOT)
								)){
							response.sendError(response.SC_UNAUTHORIZED,"acceso denegado");return;
						}
						metaData=new InvoiceMetaData(Invoice.INVOICE_TYPE_ORDER);
					}
					else {
						response.sendError(response.SC_UNAUTHORIZED,"acceso denegado");return;
					}
					System.out.println("invoiceType (int): "+metaData.getInvoiceType());
					
					if(command.equals("$fa")||command.equals("$fc")||command.equals("$oa")||command.equals("$oc")){
						if(argsspl!=null){
							try{
								payment=new Float(argsspl[0]);
							}
							catch(NumberFormatException e){
								//TODO responde que el numero vale verga
								e.printStackTrace();
							}
						}
						else payment=Float.MAX_VALUE;
					}
					else if(command.equals("@oa")||command.equals("@oc")){
						payment=0f;
					}
					System.out.println("trying to create invoice");
					Invoice invoice= new InvoiceFM01(client, seller, shopman, items, metaData, requester, destiny, agent,payment);
					//System.out.println("invoice: "+invoice.toJson());
					client.persist(Mongoi.CLIENTS);
					agent.persist(Mongoi.AGENTS);
					String hashC=client.getHash();
					String hashA=agent.getHash();
					
					new Mongoi().doUpdate(Mongoi.CLIENTS, "{ \"code\" : \""+hashC+"\" }", "{ \"agentCode\" : \""+hashA+"\" }");
					
					invoice.getShopman().setPassword(null);
					InvoiceLog createdLog=invoice.getLog(LogKind.CREATED);
					
					
					String adRef=
						(client.getConsummer()!=null?(!client.getConsummer().equals("")?(client.getConsummer()):("")):(""))+
						(client.getAddress()!=null?(!client.getAddress().equals("")?(". "+client.getAddress()):("")):(""))+
						(client.getExteriorNumber()!=null?(!client.getExteriorNumber().equals("")?(". #"+client.getExteriorNumber()):("")):(""))+
						(client.getInteriorNumber()!=null?(!client.getInteriorNumber().equals("")?("-"+client.getInteriorNumber()):("")):(""))+
						(client.getSuburb()!=null?(!client.getSuburb().equals("")?(". "+client.getSuburb()):("")):(""))+
						(client.getTel()!=null?(!client.getTel().equals("")?(". TEL:"+client.getTel()):("")):(""));
					
					//*TODO controlar inventario 
					if(command.equals("@ic")){
						//invoice.getLogs().add(new InvoiceLog(InvoiceLog.LogKind.CLOSE,true,shopman.getLogin()));
						invoice.setUpdated(createdLog.getDate());
						invoice.setPrintedTo(client);
						invoice.persist();
						
					}
					else if(command.equals("@ia")){
						//invoice.getLogs().add(new InvoiceLog(InvoiceLog.LogKind.CLOSE,true,shopman.getLogin()));
						invoice.setUpdated(createdLog.getDate());
						invoice.setPrintedTo(agent);
						
						agent.setAditionalReference(adRef);
						invoice.persist();
						
					}
					else if(command.equals("@oc")){
						invoice.setUpdated(createdLog.getDate());
						invoice.setPrintedTo(client);
						invoice.persist();
					}
					else if(command.equals("@oa")){
						invoice.setUpdated(createdLog.getDate());
						agent.setAditionalReference(adRef);
						invoice.setPrintedTo(agent);
						invoice.persist();
					}
					else if(command.equals("$oc")){
						InvoiceLog paymentLog=new InvoiceLog(InvoiceLog.LogKind.PAYMENT,invoice.getTotal()-invoice.getDebt(),shopman.getLogin());
						invoice.getLogs().add(paymentLog);
						invoice.setUpdated(paymentLog.getDate());
						
						invoice.setPrintedTo(client);
						invoice.persist();
						TheBox.instance().plus(invoice.getTotal());
						TheBox.instance().addLog(new TheBoxLog(
								invoice.getTotal(), 
								paymentLog.getDate(),
								invoice.getReference(),
								LogKind.PAYMENT.toString(),
								onlineClient.getShopman().getLogin()
								));
					}
					else if(command.equals("$oa")){
						InvoiceLog paymentLog=new InvoiceLog(InvoiceLog.LogKind.PAYMENT,invoice.getTotal()-invoice.getDebt(),shopman.getLogin());
						invoice.getLogs().add(paymentLog);
						invoice.setUpdated(paymentLog.getDate());
						agent.setAditionalReference(adRef);
						invoice.setPrintedTo(agent);
						invoice.persist();
						TheBox.instance().plus(invoice.getTotal());
						TheBox.instance().addLog(new TheBoxLog(
								invoice.getTotal(), 
								paymentLog.getDate(),
								invoice.getReference(),
								LogKind.PAYMENT.toString(),
								onlineClient.getShopman().getLogin()
								));
					}
					else if(command.equals("$fc")||command.equals("$fa")){
						InvoiceLog paymentLog=new InvoiceLog(InvoiceLog.LogKind.PAYMENT,invoice.getTotal()-invoice.getDebt(),shopman.getLogin());
						invoice.getLogs().add(new InvoiceLog(InvoiceLog.LogKind.FACTURE,true,shopman.getLogin()));
						invoice.getLogs().add(paymentLog);
						invoice.setUpdated(paymentLog.getDate());

						
						if(command.equals("$fc")){
							invoice.setFacturedTo(client);
							invoice.setPrintedTo(client);
							invoice.persist();
							
						}
						else {
							invoice.setFacturedTo(agent);
							
							invoice.setPrintedTo(agent);
							invoice.persist();
						}
						
						TheBox.instance().plus(invoice.getTotal());
						TheBox.instance().addLog(new TheBoxLog(
								invoice.getTotal(), 
								paymentLog.getDate(),
								invoice.getReference(),
								LogKind.PAYMENT.toString(),
								onlineClient.getShopman().getLogin()
								));
					}
					
					if(invoice.getAgentPayment()==0){
						InvoiceLog log=new InvoiceLog(LogKind.AGENT_PAYMENT, 0, onlineClient.getShopman().getLogin());
						new Mongoi().doPush(Mongoi.INVOICES, "{ \"reference\" : \""+invoice.getReference()+"\"}", "{\"logs\" : "+new Gson().toJson(log)+" }");
						invoice.getLogs().add(log);
					}
					
					try{
						  // Create file
						//HARD CODED HERE, write to *pdf.csv 
						String path=(command.equals("f"))?"/home/dios/FERREMUNDO/facturas/":"/home/dios/FERREMUNDO/pedidos/";
						path+=invoice.getReference()+".pdf.csv";
						csv=path;
						FileWriter fstream = new FileWriter(path);
						BufferedWriter out = new BufferedWriter(fstream);
						out.write(invoice.getConsummer()+"\n"+invoice.getAddress()+"\n"+invoice.getCity()+"\n"+invoice.getCp()+"\n"+invoice.getRfc()+"\n");
						List<InvoiceItem> items2=invoice.getItems();
						for(InvoiceItem item : items2){
							out.write(item.getQuantity()+"\t"+item.getCode()+"\t"+item.getUnit()+"\t"+item.getDescription()+"\t"+item.getMark()+"\t"+item.getUnitPrice()+"\n");
						}
						//Close the output stream
						out.close();
					}catch (Exception e){//Catch exception if any
						  System.err.println("Error: " + e.getMessage());
					}
					
					System.out.println("INVOICE is : "+new GsonBuilder().setPrettyPrinting().create().toJson(invoice));
					Invoice[] invoices=invoice.subdivide(InvoiceFormFM01.ROWS_NUMBER);

					String[] paths=new String[invoices.length+1];
					String[] fileNames=new String[invoices.length+1];
					for(int i=0;i<invoices.length;i++){
						String pathname=ProjectProperties.TMP_DIR+invoices[i].getReference()+"."+i;
						File pdf= new PDF(invoices[i], pathname).make();
						//System.out.println("invoices["+i+"]: "+invoices[i].toJson());
						//TODO this is printing time
						//new PrinterFM01(pdf, PrinterFM01.PRINTER_ONE).print();
						paths[i]=pathname;
						fileNames[i]=pdf.getName()+".pdf";
						//emis.persist(invoices[i]);
					}
					paths[invoices.length]=csv;
					fileNames[invoices.length]=new File(csv).getName().replace(".pdf", "");
					String[] mails= client.getEmail().split(" ");
					
					
					String subject=null;
					if(invoice.getInvoiceMetaData().getInvoiceType()==InvoiceFM01.INVOICE_TYPE_ORDER){
						subject="Pedido ";
					}
					else if(invoice.getInvoiceMetaData().getInvoiceType()==InvoiceFM01.INVOICE_TYPE_SAMPLE){
						subject="Cotización ";
					}
					else if(invoice.getInvoiceMetaData().getInvoiceType()==InvoiceFM01.INVOICE_TYPE_TAXES_APLY){
						subject="Factura ";
					}
					subject+=invoice.getInvoiceMetaData().getReference()+" : $"+invoice.getTotal();
					System.out.println(subject);
					for(int i=0;i<paths.length;i++){
						System.out.print("mailing "+paths[i]);
						for(String mail : mails)System.out.println(" a '"+mail+"' como "+fileNames[i]);
					}
					System.out.println("mails->"+mails.length);
					//TODO handle sent var
					boolean sent=HotmailSend.send(subject, "FERREMUNDO AGRADECE SU PREFERENCIA", mails, paths,fileNames);
					mails= agent.getEmail().split(" ");
					sent=HotmailSend.send(subject, "FERREMUNDO AGRADECE SU PREFERENCIA", mails, paths,fileNames);
					//if(!sent)HotmailSend.send("no enviado", "FERREMUNDO AGRADECE SU PREFERENCIA", new String[]{"ferremundo@live.com"}, paths,fileNames);
					
					//emis.getTransaction().commit();
					//emis.close();
					
					
					String successResponse="Cotizado "+invoice.getReference()+" por $"+invoice.getTotal();
					if(command.equals("$fa")||command.equals("$fc")||command.equals("$oa")||command.equals("$oc")){
						if(argsspl!=null){
							try{
								if(new Float(argsspl[0])>=invoice.getTotal())
									successResponse="Regresar $"+(new Float(argsspl[0])-invoice.getTotal());
								else successResponse="Se abonó $"+(new Float(argsspl[0]))+" a "+invoice.getReference();
							}
							catch(NumberFormatException e){
								//TODO responde que el numero vale verga
								e.printStackTrace();
							}
						}
						else successResponse="Se liquidó "+invoice.getReference()+" por $"+invoice.getTotal();
					}
					else if(command.equals("@oa")||command.equals("@oc")){
						successResponse="Se otorgó credito por $"+invoice.getTotal()+" al "+invoice.getReference();
					}
					response.getWriter().print(
							"{ \"invoice\" : "+new Gson().toJson(invoice)+
							", \"successResponse\" : \""+successResponse+"\"}");
					
					System.out.println(new Gson().toJson(onlineClient));
					
					return;
				}
				
			}
			else{
				response.getWriter().print("{\"failed\":\"true\"}");}
			}
		catch(Exception e){
			System.out.println("algo salio de la mierda:");
			e.printStackTrace();
		}
	}
	
	private static Invoice getInvoice(JSONObject client, JSONArray products){
		return null;
	}

	public static void main(String[] args) {
		EntityManager em=EMF.get(EMF.UNIT_PRODUCT).createEntityManager();
		List<Product> listStore=em.createNativeQuery("select * from Product",Product.class).getResultList();
		Query query=em.createQuery("SELECT p FROM Product p WHERE UPPER(p.code) LIKE :keyword ");
		query.setParameter("keyword","%AD3%");
		List<Product> res=query.getResultList();
		System.out.println(res.get(0).toJsonL1());
		
	}
}
