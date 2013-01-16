package com.ferremundo;

import java.io.File;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedList;
import java.util.Vector;

import javax.persistence.EntityManager;

import com.ferremundo.gth.InvoiceRow;
import com.lowagie.text.Rectangle;

public class tst {

	public static void main(String[] args) {
		File dir=new File("/home/dog/FERREMUNDO/pedidos/");
		String[] children = dir.list();
		if (children == null) {
		    // Either dir does not exist or is not a directory
		} else {
			boolean contin=true;
		    for (int i=0; i<children.length; i++) {
		        // Get filename of file or directory
		    	if(!contin&&children[i].endsWith(".csv")){System.out.println(children[i]);break;}
		    	if(children[i].equals("LKD.pdf.csv"))contin=false;
		    	if(children[i].endsWith(".csv")){
		    		String path=dir.getPath()+"/"+children[i];
		    		File file=new File(path);
		    		Date date= new Date(file.lastModified());
		    		String dates= ((DateFormat)(new SimpleDateFormat("dd/MM/yyyy"))).format(new Date((new Date(file.lastModified())).getTime() ));
		    		System.out.println(dir.getPath()+"/"+children[i]+" -> "+dates);
		    		
		    	}
		    }
		}
		//listStore=em.createNativeQuery("select * from Product",Product.class).getResultList();
		/*for(int i=0;i<20;i++){
			EntityManager emis=EMF.get(EMF.UNIT_INVOICEFM01).createEntityManager();
			emis.getTransaction().begin();
			InvoiceFM01 invoice = (InvoiceFM01)emis.createNativeQuery("select * from InvoiceFM01 x where x.reference like 'N5N'",InvoiceFM01.class).getResultList().get(0);
			emis.close();
			System.out.println("open?"+emis.isOpen());
			System.out.println(invoice.getJson());
			System.out.println(LevenshteinDistance.LD("ab","AB"));
			System.out.println("add".startsWith(""));
			
		}*/
		
	}

}