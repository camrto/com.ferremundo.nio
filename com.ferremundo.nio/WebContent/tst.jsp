
<%@page import="com.ferremundo.REF"%>
<%@page import="com.ferremundo.EMF"%>
<%@page import="javax.persistence.EntityManager"%>
<%@page import="com.ferremundo.Sampling"%>
<%@page import="com.ferremundo.Client"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.File"%><%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

for(int i=0;i<10;i++){
	out.write(":"+REF.next());
}
%>