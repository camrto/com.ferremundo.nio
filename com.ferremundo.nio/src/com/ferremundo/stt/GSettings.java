package com.ferremundo.stt;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.InvalidPropertiesFormatException;
import java.util.Properties;

public class GSettings extends Properties{

	private static GSettings gSettings=null;
	private static Properties properties;//=new Properties();
	
	public GSettings(){
		if(properties==null){
			String path=
					File.separator+
					this.getClass().getName().replace(".",File.separator)+
					".xml";
			InputStream is=this.getClass().getResourceAsStream(path);
			System.out.println(path);
			try {
				this.loadFromXML(is);
				is.close();
			} catch (InvalidPropertiesFormatException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			properties=this;
		}
	}
	
	public static GSettings instance(){
		if(gSettings==null){
			gSettings=new GSettings();
		}
		return gSettings;
	}
	
	public boolean hasKey(String key){
		return this.containsKey(key);
	}
	
	public static boolean has(String key){
		if(gSettings==null){
			gSettings=new GSettings();
		}
		return gSettings.hasKey(key);
	}
	
	public String getKey(String key){
		return properties.getProperty(key);
	}
	
	public static String get(String key){
		if(gSettings==null){
			gSettings=new GSettings();
		}
		return gSettings.getKey(key);
	}
}