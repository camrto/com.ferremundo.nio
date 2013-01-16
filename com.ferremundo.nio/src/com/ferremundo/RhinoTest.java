package com.ferremundo;

import java.util.HashMap;

import mx.nafiux.Rhino;

public class RhinoTest {
	public static void main(String[] args) {
		Rhino rhino = new Rhino( "/opt/fiaTest/aaa010101aaa__csd_01.cer",
	            "/opt/fiaTest/aaa010101aaa__csd_01.key",
	            "12345678a");

		rhino.setOpenSSL("/usr/bin/openssl");
		HashMap datosfiscales=rhino.generarDatosFiscales(
                "México", //pais
                "Distrito Federal",//estado 
                "Distrito Federal",//String municipio, 
                "Guerrero",//String colonia,
                "Av. Hidalgo",//,String calle , 
                "77",//String noExterior, 
                "",//String noInterior, 
                "",//String codigoPostal, 
                "Coyoacán",//String localidad, 
                ""//String referencia);
                );
		rhino.setEmisor("A.C. de pruebas",//String razonSocial,
                "aaa010101aaa",//String rfc,
                datosfiscales,
                "Mediana empresa");//String regimenFiscal);
		
	}


}
