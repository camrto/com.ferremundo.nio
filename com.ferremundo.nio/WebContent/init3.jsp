<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="com.ferremundo.Product"%>
<%@page import="java.util.List"%>
<%@page import="com.ferremundo.ProductsStore"%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
	.ui-autocomplete-loading { background: white url('images/ui-anim_basic_16x16.gif') right center no-repeat; }
</style>
<script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="js/jquery.sexytable-1.1.js"></script>
<script type="text/javascript" src="js/jquery.editable.js"></script>
<script type="text/javascript" src="js/jquery.ui.core.js"></script>
<script type="text/javascript" src="js/jquery.ui.widget.js"></script>
<script type="text/javascript" src="js/jquery.ui.position.js"></script>
<script type="text/javascript" src="js/jquery.ui.autocomplete.js"></script>

<script type="text/javascript" src="js/util.js"></script>
<link rel="stylesheet" type="text/css" href="css/layout.css">
<link rel="stylesheet" type="text/css" href="css/jquery-ui-1.8.4.cupertino.css" />


<script type="text/javascript">
$(document).ready(function(){

$(function() {

	$("#log").sexytable({
		row:[
				{content:'cant',width:5},
				{content:'unidad',width:10},
				{content:'descripción',width:40},
				{content:'codigo',width:10},
				{content:'marca',width:10},
				{content:'$ unit',width:10},
				{content:"<div class='g-total'>total</div>",width:10}
				],animate:100
		});
	
	function log(quantity,unit,description,code,mark,unitprice){
		$("#log").sexytable({
			row:[
					{content: quantity, width:5},
					{content: unit, width:10},
					{content: description, width:40},
					{content: code, width:10},
					{content: mark, width:10},
					{content: unitprice, width:10},
					{content: quantity*unitprice, width:10}
					],animate:100
			});
	};

	function rendLog(){
		
	}
	
	var inputValue;
	var products;
	var commandline;
	var emptyCommand=false;
	$("#commands").autocomplete({
		source: function(request, response) {
			commandline=commandLine();
			//alert("kind:"+c.kind+"\nquantity:"+c.quantity+"\nargs:"+c.args+"\nargssize:"+c.argssize+"\ngetFRomBD:"+c.getFromDB+"\ncommand:"+c.command);
			var args="";
			for(var i=0;i<commandline.args.length;i++)args+=" "+commandline.args[i];
			if(commandline.getFromDB){
				$.ajax({
					url: "port",
					dataType: "json",
					data: {
						search: args,
						searchrequestid: "0",
						commandkind: commandline.kind
					},
					success: function(data) {
						inputValue=$("#commands").val();
						products=data.products;
						response($.map(data.products, function(item) {
							return {
								label: "<b>"+item.code+"</b> "+item.description,
								value: inputValue
							};
						}));
					}
				});
			}
		},
		minLength: 1,
		select: function(event, ui) {

			var i=$('#ui-active-menuitem').parent().index('.ui-menu-item');
			//alert(i);
			var quantity=0;
			if(commandline.kind=='product')quantity=commandline.quantity;
			p=products;
			
			log(quantity,p[i].unit,p[i].description,p[i].code,p[i].mark,p[i].unitprice);
			emptyCommand=true;
			//log(ui.item ? ("Selected: " + ui.item.label) : "Nothing selected, input was " + this.value);
		},
		open: function() {
			var i=0;
			$('.ui-autocomplete').css({width:'80%',height:'auto'});
			$('a.ui-corner-all').each(function(){
				var p=products;
				var description=p[i].description;
				var code=p[i].code;
				var mark=p[i].mark;
				var args=commandline.args;
				//alert("args:"+commandline.args+" commandline.argssize:"+commandline.argssize);
				for(var j=0;j<commandline.argssize;j++){
					description=description.replace(args[j],"<b>"+args[j]+"</b>");
					code=code.replace(args[j],"<b>"+args[j]+"</b>");
					mark=mark.replace(args[j],"<b>"+args[j]+"</b>");
				}
				$(this).empty().append("<div style='position: relative;width: 100%; height:auto;'>"+
						"<div class='product-attr' style='width=10%; position:absolute; top:0%; left:0%;'>"+code+"</div>"+
						"<div class='product-attr' style='width=60%; position:absolute; top:0%; left:10%;'>"+description+"</div>"+
						"<div class='product-attr' style='width=10%; position:absolute; top:0%; left:70%;'>"+mark+"</div>"+
						"<div class='product-attr' style='width=10%; position:absolute; top:0%; left:80%;'>"+p[i].unit+"</div>"+
						"<div class='product-attr' style='width=10%; position:absolute; top:0%; left:90%;'>"+p[i].unitprice+"</div>"
				).addClass(i%2==0?"even":"odd");
				var H=0;
				$('.product-attr',this).each(function(){H<$(this).height()?H=$(this).height():0;});
				$(this).css({height:H+'px'});
				$(this).parent().css({height:H+'px'});
				i++;
			});
			$(this).removeClass("ui-corner-all").addClass("ui-corner-top");
		},
		close: function() {
			$(this).removeClass("ui-corner-top").addClass("ui-corner-all");
			if(emptyCommand)$('#commands').val("");
			emptyCommand=false;
		}
	});


	function commandLine(){
		this.value=$('#commands').val(); 			//value
		var splited=this.value.split(" ");
		this.command=splited[0];
		this.kind=false;
		this.quantity=parseFloat(splited[0]);		//quantity
		this.args=[];								//args
		this.argssize=0;
		this.getFromDB=false;
		if(quantity){
			this.kind ='product';
			for(var i=1;i<splited.length;i++)if(splited[i]!=""){
				this.args[i-1]=splited[i];
				this.argssize++;
			}
		}
		else if(this.command=='c'||this.command=='client'){
			this.kind ='client';
			for(var i=1;i<splited.length;i++)if(splited[i]!=""){
				this.args[i-1]=splited[i];
				this.argssize++;
			}
		}
		else if(this.command=='o'||this.command=='order'){
			this.kind= 'order';
			for(var i=1;i<splited.length;i++)if(splited[i]!=""){
				this.args[i-1]=splited[i];
				this.argssize++;
			}
		}
		else {
			this.kind= "retrieve";
			for(var i=0;i<splited.length;i++)if(splited[i]!=""){
				this.args[i]=splited[i];
				this.argssize++;
			}
		}

		if(this.argssize>=1)this.getFromDB=true;

		return this;
	}
	
	function commandKind(){
		var val=$('#commands').val().split(" ")[0];
		var numterms=$('#commands').val().split(" ").length;
		alert(val+" "+numterms);
		if(parseFloat(val)&&numterms>1)return "product";
		else if((val=='c'||val=='client')&&numterms>1) return 'client';
		else if((val=='o'||val=='order')&&numterms>1) return 'order';
		else return "retrieve";
	}

	function getQuantity(){
		var val=$('#commands').val().split(" ")[0];
		if(parseFloat(val))return parseFloat(val);
		return false;
	}

});

});

</script>


<title>Ferremundo - pedidos</title>
</head>
<body>

<div class="demo">

<div class="ui-widget">
	<label for="comandos:">com:</label>
	<input id="commands" />
</div>
<div style="position: relative; width: 100%">
<div id="log" style="height: 500px; width: 100%; overflow: auto;" class="ui-widget-content"></div>
</div>
</body>

</html>