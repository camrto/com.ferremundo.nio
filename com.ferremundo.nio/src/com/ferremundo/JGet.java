package com.ferremundo;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;

public class JGet {

	public static void get(String url) {
		URL u;
		InputStream is = null;
		BufferedReader dis;
		String s;

		try {
			u = new URL(url);
			is = u.openStream();
			// dis = new DataInputStream(new BufferedInputStream(is));

			dis = new BufferedReader(new InputStreamReader(is));

			while ((s = dis.readLine()) != null) {
				System.out.println(s);
			}
		} catch (MalformedURLException mue) {
			System.err.println("Ouch - a MalformedURLException happened.");
			mue.printStackTrace();
			System.exit(2);
		} catch (IOException ioe) {
			System.err.println("Oops- an IOException happened.");
			ioe.printStackTrace();
			System.exit(3);
		} finally {
			try {
				is.close();
			} catch (IOException ioe) {
			}
		}

	}
	
	public static void download(String url,String file) throws IOException{
		URL website = new URL(url);
	    ReadableByteChannel rbc = Channels.newChannel(website.openStream());
	    FileOutputStream fos = new FileOutputStream(file);
	    fos.getChannel().transferFrom(rbc, 0, 1 << 24);
	}
	
	public static void stringTofile(String content,String dir){
		FileOutputStream fop = null;
		File file;
		try {
 
			file = new File(dir);
			fop = new FileOutputStream(file);
 
			// if file doesnt exists, then create it
			if (!file.exists()) {
				file.createNewFile();
			}
 
			// get the content in bytes
			byte[] contentInBytes = content.getBytes();
 
			fop.write(contentInBytes);
			fop.flush();
			fop.close();
 
			System.out.println("Done");
 
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if (fop != null) {
					fop.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

	}
	
	public static void main(String[] args) {
		try {
			JGet.download("http://google.com","/home/lucifer/tmp/google.com");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}