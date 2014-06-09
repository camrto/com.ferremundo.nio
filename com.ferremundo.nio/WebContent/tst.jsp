<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="js/jquery.capsule.js"></script>

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
        		   var ret="<table>";
          		   if(data.head){
        			   ret="<tr>";
            		   for(var i=0;i<data.head.length;i++){
            			   ret+='<th>'+data.head[i]+'</th>';
            		   }
            		   ret+='</tr>';
          		   }
        		   for(var i=0;i<data.body.length;i++){
        			   ret+='<tr id="'+i+'">';
        			   for(var j=0;j<data.body[i].length;j++){
            			   ret+='<td>'+data.body[i][j]+'</td>';
            		   }
        			   ret+='</tr>';
        		   }
        		   ret+='</table>';
        		   return ret;
        	   }
           }
]);
doRepeat=function(condition,function_,interval){
	if(condition){
		if(this.timer){
			window.clearInterval(this.timer);
		}
		this.timer=window.setInterval(function_, interval);
	}
	else{
		window.clearInterval(this.timer);
		function_();
	}
};


$(document).ready(function(){
	var data=[];
	for(var i=0;i<100;i++){
		data.push($.capsule.randomString(1,5,3,15,'a'));
	}
	$('#input').commandro({
		data:{1:data}/*,
		render:function(data){
			var inp=$(this.input);
			var pos=inp.position();
			var height=inp.height();
			this.renderTo.empty()
			.css({//**TODO fix this height thing 
				top:pos.top+1.5*height,left:pos.left,
				position:'absolute',width:'auto',padding: 0, margin: 0})
			.aTable({body:data}).css({'background-color':'#fff','border':'1px','border-style':'outset'});
			this.show();
			this.moveTo(0);
		},
		highlight:function(init,end){
    		$(this.renderTo).find('table > tbody > tr').eq(init).css('background-color','#fff');
    		$(this.renderTo).find('table > tbody > tr').eq(end).css('background-color','#bad0f7');
    	}*/
	}).focus();
});
</script>
</head>
<body>
<input id="input">
<br>saasdadasasd
</body>
</html>