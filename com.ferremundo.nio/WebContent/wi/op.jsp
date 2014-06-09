<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
var REQUEST_NUMBER=0;

var TOKEN="${token}";
var CLIENT_REFERENCE="${clientReference}";
var SHOPMAN=${shopman};
var CONTEXT_PATH="${pageContext.request.contextPath}";
var AUTHORIZED=true;

var shopman=SHOPMAN;
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/URLEncode.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.capsule.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/fmd/auth.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/fmd/opcommandline.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.idle.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.caret.1.02.min.js"></script>
<script type="text/javascript">

$.capsule([
           {
        	   name:"aTable",
        	   doc:"form a table from data. data[0] is the head row",
        	   defaults:{
        		   id:function(){
				   return "aTableID"+$.capsule.randomString(1,15,'aA0');
           		   },
        	   },
        	   html:function(data){
        		   var ret="<table><tr>";
        		   for(var i in data[0]){
        			   ret+='<th>'+data[0][i]+'</th>';
        		   }
        		   ret+='</tr>';
        		   for(var l=1;l<data.length;l++){
        			   ret+='<tr id="'+(l-1)+'">';
        			   for(var i in data[l]){
            			   ret+='<td>'+data[l][i]+'</td>';
            		   }
        			   ret+='</tr>';
        		   }
        		   ret+='</table>';
        		   return ret;
        	   }
           }
]);
function registering(){
	
}
$(document).ready(function(){
	$('#shopmanSession').html(':'+SHOPMAN.name+":"+SHOPMAN.login);
	$( document ).idle({
		idle:1000*60*5,
		onIdle: function(){
			var doIdle=document.isIdle?false:true;
			if(doIdle)document.isIdle=true;
			else return;
			lockin();
			var passinid='passid'+$.capsule.randomString(1,15,'aA0');
			passin({
				id:passinid,
				success:function(data){
					AUTHORIZED=true;
					//alert("success " +data.authenticated+". #"+passinid+" to be removed")
					$('#'+passinid).remove();
					document.isIdle=false;
					$('#commands').focus();
				},
				message:"desbloquear "+SHOPMAN.name+"-"+SHOPMAN.login
			});
		}
	});
	$('#lockbutton').click(function(){
		var doIdle=document.isIdle?false:true;
		if(doIdle)document.isIdle=true;
		else return;
		lockin();
		var passinid='passid'+$.capsule.randomString(1,15,'aA0');
		passin({
			id:passinid,
			success:function(data){
				AUTHORIZED=true;
				//alert("success " +data.authenticated+". #"+passinid+" to be removed")
				$('#'+passinid).remove();
				document.isIdle=false;
				$('#commands').focus();
			},
			message:"desbloquear "+SHOPMAN.name+"-"+SHOPMAN.login
		});
	});
	$("#op").focus().keydown(function(event){
		if(event.which!=13)return;
		opcommandline($("#op"),event);
	});
});

</script>
</head>
<body>
	<div id="shopmanSession"></div>
	<button type="button" id="lockbutton">lock</button>
	com:<input id="op">
	<div id='form'></div>
	<div id='menu'></div>
	<div id='log'></div>
</body>
</html>