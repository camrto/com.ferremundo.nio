<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">



<%@page import="com.ferremundo.OnlineClients"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="js/jquery.sexytable-1.1.js"></script>
<script type="text/javascript" src="js/jquery.editable.js"></script>
<!-- 
<script type="text/javascript" src="js/jquery.ui.core.js"></script>
<script type="text/javascript" src="js/jquery.ui.widget.js"></script>
<script type="text/javascript" src="js/jquery.ui.position.js"></script>
<script type="text/javascript" src="js/jquery.effects.core.js"></script>
<script type="text/javascript" src="js/jquery.ui.autocomplete.js"></script>
<script type="text/javascript" src="js/jquery.ui.accordion.js"></script>
 -->
<script type="text/javascript" src="js/jquery-ui-1.8.21.custom.min.js"></script>
<script type="text/javascript" src="js/jquery.json-2.2.js"></script>
<script type="text/javascript" src="js/jquery.editable.js"></script>
<script type="text/javascript" src="js/jquery.caret.1.02.min.js"></script>
<script type="text/javascript" src="js/URLEncode.js"></script>
<script type="text/javascript" src="js/jquery.capsule.js"></script>
<script type="text/javascript" src="cps/tableing.cps.js"></script>

<script type="text/javascript" src="js/util.js"></script>
<link rel="stylesheet" type="text/css" href="css/layout.css">
<link rel="stylesheet" type="text/css" href="css/jquery-ui-1.8.4.cupertino.css" />


<script type="text/javascript">
<%
	OnlineClients clients= OnlineClients.instance();
	String ipAddres=request.getRemoteAddr();
	out.println("var IP_ADDRESS='"+ipAddres+"';");
	out.println("var CLIENT_REFERENCE="+clients.add(ipAddres,"")+";");
%>

var REQUEST_NUMBER=0;

function Item(quantity,code,unit,mark,description,unitPrice,total){
	this.quantity=quantity;
	this.unit=unit;
	this.description=description;
	this.code=code;
	this.mark=mark;
	this.unitPrice=unitPrice;
	this.total=total;
};
randomString=function(minWords,maxWords, minLength, maxLength, kind){
    var text = '';
    var possible='';
    var low = 'abcdefghijklmnopqrstuvwxyz';
    var upp = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    var num = '0123456789';
    if(kind.search('a')>=0)possible+=low;
    if(kind.search('A')>=0)possible+=upp;
    if(kind.search('0')>=0)possible+=num;
    var w=minWords+Math.floor(Math.random() * (maxWords-minWords));
    for( var i=0; i < w; i++ ){
    	var l=minLength+Math.floor(Math.random() * (maxLength-minLength));
    	text+=i>0?' ':'';
    	for( var j=0; j < l; j++ )
    		text += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    return text;
};

setClient=function(code,consummer,consummerType,address,city,country,state,email,cp,rfc,tel,payment,email){
	this.id=-1;
	this.code=code;
	this.consummer=consummer;
	this.consummerType=consummerType;
	this.address=address;
	this.city=city;
	this.country=country;
	this.state=state;
	this.email=email;
	this.cp=cp;
	this.rfc=rfc;
	this.tel=tel;
	this.payment=payment;
	this.email=email;
	$('#client').html("[ "+consummerType+" ] [ "+payment+" ] "+consummer+ " [ "+rfc+" ]");
	$('#client-address').html(consummer+" "+address);
	$('#client-city').html(city);
	$('#client-state').html(state);
	$('#client-cp').html(cp);
	$('#client-rfc').html(rfc);
	$('#client-tel').html(tel);
	$('#client-email').html(email);
	$('#client-country').html(country);
	document.title=this.consummer+" "+this.consummerType;
	return this;
};
setShopman=function(login){
	this.id=-1;
	this.login=login;
	return this;
};
setMetadata=function(invoicetype){
	this.invoicetype=invoicetype;
	return this;
};
setRequester=function(id,name,consummer){
	this.id=id;
	this.name=name;
	this.consummer=consummer;
	return this;
};
setSeller=function(id,code){
	this.id=id;
	this.code=code;
	return this;
};
setDestiny=function(id,address){
	this.id=id;
	this.address=address;
	return this;
};
$(document).ready(function(){

	//INIT
	$('#commands').focus();


	var inputValue;
	var products;
	var productsLog=[];
	var clients;
	var client=new setClient("-1","PUBLICO EN GRAL",1,".","MORELIA",".","MICH",".",".","PARA FACTURAR",".",0,"");
	var shopman=new setShopman("unauthorized");
	var metadata=new setMetadata(1);// INVOICE_TYPE_ORDER
	var requester=new setRequester(-1,"publico","publico");
	var seller=new setSeller(-1,"none");
	var destiny=new setDestiny(-1,"mostrador");
	var commandline;
	var emptyCommand=false;
	var key_down = $.Event("keydown.autocomplete"); key_down.keyCode =  $.ui.keyCode.DOWN;
	var keyup = $.Event("keydown.autocomplete"); keyup.keyCode =  $.ui.keyCode.UP;
	var keyenter = $.Event("keydown.autocomplete"); keyenter.keyCode =  $.ui.keyCode.ENTER;
	var sample=function(){
		return $('#sample').is(':checked');
	};

	///INIT

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
	$("#commands").bind('autocompleteopen', function(event, ui) {
	    $(this).autocomplete( "option" , 'isOpen' , true );
	});

	$("#commands").bind('autocompleteclose', function(event, ui) {
		$(this).autocomplete( "option" , 'isOpen' , false );
	});
	$("#commands").bind('keyup',function(event){
		//console.log(event.which);
		if(event.which!=13)return;
		//alert(event.which);
		commandline=commandLine();
		//console.log(commandline.kind);
		if(!(commandline.kind=='product'||commandline.kind=='retrieve'))return;
		//console.log("l="+commandline.args.length);
		if(!$(this).autocomplete( "option" , 'isOpen')&&commandline.args.length==1) {
			
			REQUEST_NUMBER=REQUEST_NUMBER+1;
			$.ajax({
				url: "getproductbycode",
				dataType: "json",
				data: {
					code: commandline.args[0],
					requestNumber: REQUEST_NUMBER,
					consummerType: client.consummerType
				},
				success: function(data) {
					//console.log(data);
					var p=data.product;
					var quantity=commandline.quantity;
					
					log(quantity,p.unit,p.description,p.code,p.mark,p.unitPrice);
					productsLog.unshift(p);
					productsLog[0].quantity=quantity;
					onLogChange();
					$("#commands").val('');
				}
			});
	    }
	});
	$("#commands").autocomplete({
		source: function(request, response) {
			commandline=commandLine();
			//alert("kind:"+c.kind+"\nquantity:"+c.quantity+"\nargs:"+c.args+"\nargssize:"+c.argssize+"\ngetFRomBD:"+c.getFromDB+"\ncommand:"+c.command);
			var args="";
			for(var i=0;i<commandline.args.length;i++)args+=commandline.args[i]+(i==(commandline.args.length-1)?"":" ");
			if(commandline.getFromDB){
				//alert(commandline.command);
				REQUEST_NUMBER=REQUEST_NUMBER+1;
				$.ajax({
					url: "port",
					dataType: "json",
					data: {
						search: url.encode(args),
						requestNumber: REQUEST_NUMBER,
						clientReference: CLIENT_REFERENCE,
						commandkind: commandline.kind,
						consummerType: client.consummerType
					},
					success: function(data) {
						if(REQUEST_NUMBER!=data.requestNumber){
							//console.log("distintos id's");
							return;
						}
						inputValue=$("#commands").val();

						if(commandline.kind=='product'||commandline.kind=='retrieve'){
							products=data.products;
							response($.map(data.products, function(item) {
								return {
									label: item.code+" "+item.description,
									value: inputValue
								};
							}));
						}
						else if(commandline.kind=='client'){
							clients=data.clients;
							response($.map(data.clients, function(item) {
								return {
									label: item.consummer+" "+item.rfc,
									value: inputValue
								};
							}));
						}
						//$("#commands").trigger(key_down);
					}
				});
			}
			else if(commandline.kind=='editproduct'){
				$('#editproduct').show('slow');
				$('#editproduct-1').val('');
				$('#editproduct-2').val('');
				$('#editproduct-3').val('');
				$('#editproduct-4').val('');
				$('#editproduct-5').val('');
				$('#editproduct-6').val('');
				$('#editproduct-1').focus();
				$('#commands').val('');
			}
			else if(commandline.kind=='editclient'){
				$('#editclient').show('slow');
				$('#editclient-0').val('');
				$('#editclient-1').val('');
				$('#editclient-2').val('');
				$('#editclient-3').val('');
				$('#editclient-4').val('');
				$('#editclient-5').val('');
				$('#editclient-6').val('');
				$('#editclient-7').val('');
				$('#editclient-8').val('');
				$('#editclient-9').val('');
				$('#editclient-10').val('');
				$('#editclient-0').focus();
				$('#commands').val('');
			}
			else if(commandline.kind=='sample'){
				//alert(" kind "+commandline.kind+" argsL "+commandline.args.length);
				if(commandline.args.length>=0&&productsLog.length>0){
					//alert(" kind "+commandline.kind);
					$.ajax({
						type: 'POST',
						url: 'wishing',
						data: {
							client : url.encode($.toJSON(client)),
							list : url.encode($.toJSON(productsLog)),
							shopman : url.encode($.toJSON(shopman)),
							metadata : url.encode($.toJSON(metadata)),
							requester : url.encode($.toJSON(requester)),
							seller : url.encode($.toJSON(seller)),
							destiny : url.encode($.toJSON(destiny)),
							args : url.encode(commandline.args.join(" "))
						},
						success: function(data){
							$('#commands').val('');
							//window.location="init6.jsp";
						},
						dataType:"json"
					});
				}
				else {
					alert('ningun item en lista');
					$('#commands').val('');
				}
			}
			
			else if(commandline.kind=='facture'){
				if(commandline.args.length>=1&&commandline.args[0].charAt(commandline.args[0].length-1)=='.'){
					$.ajax({
						url: 'facture',
						data: {
							command : commandline.command,
							args : url.encode(commandline.args.join(" ")),
							client : url.encode($.toJSON(client))
						},
						success: function(data){
							if(commandline.command=='@b'){
								$('#commands').val('');
								//window.location="init6.jsp";
							}
							else if(commandline.command=='@-'){
								
							}
						},
						error : function(jqXHR, textStatus, errorThrown){
							alert(textStatus);
						},
						dataType:"json"
					});
				}
			}
			else if(commandline.kind=='discount'){
				if(commandline.args.length>=1&&commandline.args[0].charAt(commandline.args[0].length-1)==','){
					alert("discounting "+(parseFloat(commandline.args[0])));
					for(var j=0;j<productsLog.length;j++){
						//$(".tableingrow").unbind('DOMSubtreeModified');
						
						var newPrice=Math.round(productsLog[j].unitPrice*(100-parseFloat(commandline.args[0])))/100;
						$('.unitPrice').eq(j).html(newPrice);
						productsLog[j].unitPrice=newPrice;
						
						onLogChange();
									//productsLog[j].quantity=$('.quantity').eq(j).val();
					}
					$('#commands').val('');
				}
				
			}
			else if(commandline.kind=='getinvoice'){
				if(commandline.args.length>=1&&commandline.args[0].charAt(commandline.args[0].length-1)=='.'){
					$.ajax({
						url: 'getinvoice',
						data: {
							command : commandline.command,
							reference : url.encode(commandline.args.join(" "))
						},
						success: function(data){
							if(commandline.command=='@r'){
								var itms=data.items;
								alert($.toJSON(data));
								for(var i=itms.length-1; i>=0;i--){
									//itms[i].quantity=parseFloat(itms[i].quantity);
									//itms[i].product.unitPrice=parseFloat(itms[i].product.unitPrice);
									log(
											parseFloat(itms[i].quantity),
											itms[i].unit,
											itms[i].description,
											itms[i].code,
											itms[i].mark,
											parseFloat(itms[i].unitPrice)
									);
									//productsLog.unshift(itms[i].product);
									itms[i].quantity=parseFloat(itms[i].quantity);
									itms[i].unitPrice=parseFloat(itms[i].unitPrice);
									productsLog.unshift(itms[i]);
									if(itms[i].id==-1){
										$('#log').sexytable({'editedRow':true,'index':0});
									}
									//productsLog[0].quantity=parseFloat(itms[i].quantity);
									
								}
								onLogChange();
								$('#commands').val('');
							}
						},
						dataType:"json"
					});
				}
			}
			else if(commandline.kind=='searchinvoices'){
				//console.log('going search: '+commandline.args.join(" "));
				if(commandline.args.length>=1&&commandline.args[commandline.args.length-1].charAt(commandline.args[commandline.args.length-1].length-1)=='.'){
					commandline.args[commandline.args.length-1]=commandline.args[commandline.args.length-1].replace(/\./g,'');
					$("#resultset").prepend("<img src=img/wait.gif width=70px height=70px/>");
					$.ajax({
						url: 'searchinvoices',
						data: {
							paths : url.encode(commandline.args.join(" "))
						},
						success: function(data){
							$('#resultset').empty();
							//alert("hora de empezar");
							
							for(var i=0;i<data.invoices.length;i++){
								var gtotal=0;
								for(var j=0;j<data.invoices[i].items.length;j++){
									var item=data.invoices[i].items[j];
									var quantity=item.quantity;
									var unitPrice=item.unitPrice;
									data.invoices[i].items[j].total=Math.round(quantity*unitPrice*100)/100;
									gtotal+=quantity*unitPrice;
									for(var field in item){
										for(var k=0;k<commandline.args.length;k++){
											if(!isNumber(item[field])){
												item[field]=item[field].replace(commandline.args[k].toUpperCase(),"<i style='background-color:#fbff8d'><b>"+commandline.args[k].toUpperCase()+"</b></i>");
												//if(item[field].indexOf(commandline.args[k].toUpperCase())!=-1)contains=true;	
											}
										}
									}
								}

								var consummer=data.invoices[i].client.consummer;
								var consummerType=data.invoices[i].client.consummerType;
								var address=data.invoices[i].client.address;
								var city=data.invoices[i].client.city;
								var state=data.invoices[i].client.state;
								var country=data.invoices[i].client.country;
								var email=data.invoices[i].client.email;
								var cp=data.invoices[i].client.cp;
								var rfc=data.invoices[i].client.rfc;
								var payment=data.invoices[i].client.payment;
								var reference=data.invoices[i].reference;
								var consummerContent=reference+" "+(Math.round(gtotal*100)/100)+"<br>"+
									consummer+" "+
									"tipo:"+consummerType+" credito:"+payment+"<br>"+
									address+" "+city+" "+state+" "+cp+"<br>"+
									rfc+"<br>"+email;
								for(var k=0;k<commandline.args.length;k++){
									if(!isNumber(consummer[field])){
										consummerContent=consummerContent.replace(commandline.args[k].toUpperCase(),"<i style='background-color:#fbff8d'><b>"+commandline.args[k].toUpperCase()+"</b></i>");
										//if(item[field].indexOf(commandline.args[k].toUpperCase())!=-1)contains=true;	
									}
								}
								
								var consummerObj={content:consummerContent};
								
								$('#resultset').incapsule({dclass:'box fleft', width:'100%',content:''},'com.ferremundo.cps.GenericDiv')
								.capsule(data.invoices[i].items,'com.ferremundo.cps.TB').addClass(i%2!=0?'odd':'even')
								.precapsule(consummerObj,'com.ferremundo.cps.GenericDiv');
								/*
								for(var j=0;j<data.invoices[i].items.length;j++){
									
									
									var item=data.invoices[i].items[j];
									var quantity=item.quantity;
									var unitPrice=item.unitPrice;
									var total=Math.round(quantity*unitPrice*100)/100;
									item.total=total;
									data.invoices[i].items[j].total=total;
									var contains=false;
									for(var field in item){
										for(var k=0;k<commandline.args.length;k++){
											if(!isNumber(item[field])){
												item[field]=item[field].replace(commandline.args[k].toUpperCase(),"<b>"+commandline.args[k].toUpperCase()+"</b>");
												if(item[field].indexOf(commandline.args[k].toUpperCase())!=-1)contains=true;	
											}
										}
									}
									gtotal+=quantity*unitPrice;
									if(contains)data.invoices[i].items[j].gclasses='highlight';
								}
								//$('#resultset').capsule(data.invoices[i].items).addClass('box');
								var divID=randomString(1,1,10,10,'aA0')+new Date().getTime();
								var tableID=randomString(1,1,10,10,'aA0')+new Date().getTime();
								$('#resultset').append("<div class='box' id='"+divID+"'></div>");
								$("<table id='"+tableID+"'></table>").appendTo('#'+divID)
								//$("<table></table>").appendTo('#resultset')
								.capsule(data.invoices[i].items,'com.ferremundo.cps.TB');
								
								var consummer=data.invoices[i].client.consummer;
								var consummerType=data.invoices[i].client.consummerType;
								var address=data.invoices[i].client.address;
								var city=data.invoices[i].client.city;
								var state=data.invoices[i].client.state;
								var country=data.invoices[i].client.country;
								var email=data.invoices[i].client.email;
								var cp=data.invoices[i].client.cp;
								var rfc=data.invoices[i].client.rfc;
								var payment=data.invoices[i].client.payment;
								var reference=data.invoices[i].reference;
								var consummerContent=reference+" "+(Math.round(gtotal*100)/100)+"<br>"+
									consummer+" "+
									"tipo:"+consummerType+" credito:"+payment+"<br>"+
									address+" "+city+" "+state+" "+cp+"<br>"+
									rfc+"<br>"+email;
								var consummerObj={content:consummerContent};
								$(('#'+divID)).precapsule(consummerObj,'com.ferremundo.cps.GenericDiv');
							*/
							}
							
						},
						dataType:"json"
					});
				}
			}



			
		},
		minLength: 1,
		select: function(event, ui) {

			var i=$('#ui-active-menuitem').parent().index('.ui-menu-item');
			if(commandline.kind=='product'||commandline.kind=='retrieve'){
				var quantity=0;
				quantity=commandline.quantity?commandline.quantity:1;
				p=products;
			
				log(quantity,p[i].unit,p[i].description,p[i].code,p[i].mark,p[i].unitPrice);
				productsLog.unshift(p[i]);
				productsLog[0].quantity=quantity;
				onLogChange();
				
				//alert(productsLog[i].key);
			}
			else if(commandline.kind=='client'){
				if(event.which==2){
					if(confirm("quitar cliente de lista?:"+$.toJSON(clients[i]))){
						$.ajax({
							index : j,
							url: "changeclientstatus",
							data: {
								active:false,
								id:clients[i].id
							},
							dataType: "json",
							error: function(jqXHR, textStatus, errorThrown){
								alert(textStatus);
							},
							success: function(data) {
							
							}
						});
					}		
				}
				else if(confirm("cambiar el cliente puede modificar los datos")){
					client=clients[i];
					$('#client').html("[ "+client.consummerType+" ] "+client.consummer+ " [ "+client.rfc+" ]");
					$('#client-address').html(client.address);
					$('#client-city').html(client.city);
					$('#client-state').html(client.state);
					$('#client-cp').html(client.cp);
					$('#client-rfc').html(client.rfc);
					$('#client-tel').html(client.tel);
					$('#client-email').html(client.email);
					$('#client-country').html(client.country);

					
					$('#vips option').eq(client.consummerType-1).attr('selected', 'selected');
					var id=client.id;
					//alert($.URLEncode(jsonsrt));
					//alert($.toJSON(productsLog));
					for(var j=0;j<productsLog.length;j++){
						var jsonsrt="["+$.toJSON(productsLog[j])+"]";
						$.ajax({
							index : j,
							url: "getthis",
							data: {
								list:$.URLEncode(jsonsrt),
								id:url.encode(id+"")
							},
							dataType: "json",
							error: function(jqXHR, textStatus, errorThrown){
								alert(textStatus);
							},
							success: function(data) {
								//alert(productsLog[0].quantity+" ->"+this.index);
								var j=this.index;
								if(productsLog[j].id!="-1"){
									//alert(jsonsrt);
									//$('.quantity').eq(j).text(data[j].quantity);
									$(".tableingrow").unbind('DOMSubtreeModified');
									$('.unit').eq(j).html(data[0].unit);
									$('.description').eq(j).html(data[0].description);
									$('.code').eq(j).html(data[0].code);
									$('.mark').eq(j).html(data[0].mark);
									$('.unitPrice').eq(j).html(data[0].unitPrice);
									var quantity=productsLog[j].quantity;
									if(productsLog[j].disabled){
										productsLog[j]=data[0];
										productsLog[j].disabled=true;
									}
									else productsLog[j]=data[0];
									productsLog[j].quantity=quantity;
									onLogChange();
									//productsLog[j].quantity=$('.quantity').eq(j).val();
								}
									
									//else{alert("code");}
								
							}
						});
					}
					
				}

				//
			}



			emptyCommand=true;
			//log(ui.item ? ("Selected: " + ui.item.label) : "Nothing selected, input was " + this.value);
		},
		open: function() {
			$('.ui-autocomplete').css({width:'80%',height:'auto'});
			
			if(commandline.kind=='product'||commandline.kind=='retrieve'){
				var i=0;
				$('a.ui-corner-all').each(function(){
					var p=products;
					var description=p[i].description;
					var code=p[i].code;
					var mark=p[i].mark;
					var args=commandline.args;
					//alert("args:"+commandline.args+" commandline.argssize:"+commandline.argssize);
					for(var j=0;j<commandline.argssize;j++){
						description=description.replace(args[j].toUpperCase(),"<b>"+args[j].toUpperCase()+"</b>");
						code=code.replace(args[j].toUpperCase(),"<b>"+args[j].toUpperCase()+"</b>");
						mark=mark.replace(args[j].toUpperCase(),"<b>"+args[j].toUpperCase()+"</b>");
					}
					$(this).empty().append("<div style='position: relative;width: 100%; height:auto;'>"+
							"<div class='product-attr' style='width:10%; position:absolute; top:0%; left:0%;word-wrap: break-word;'>"+code+"</div>"+
							"<div class='product-attr' style='width:60%; position:absolute; top:0%; left:10%;word-wrap: break-word;'>"+description+"</div>"+
							"<div class='product-attr' style='width:10%; position:absolute; top:0%; left:70%;word-wrap: break-word;'>"+mark+"</div>"+
							"<div class='product-attr' style='width:10%; position:absolute; top:0%; left:80%;word-wrap: break-word;'>"+p[i].unit+"</div>"+
							"<div class='product-attr' style='width:10%; position:absolute; top:0%; left:90%;word-wrap: break-word;'>"+p[i].unitPrice+"</div></div>"
					).addClass(i%2==0?"even":"odd");
					var H=0;
					$('.product-attr',this).each(function(){H<$(this).height()?H=$(this).height():0;});
					$(this).css({height:H+'px'});
					$(this).parent().css({height:H+'px'});
					i++;
				});
			}
			else if(commandline.kind=='client'){
				var i=0;
				$('a.ui-corner-all').each(function(){
					var c=clients;
					var consummer=c[i].consummer;
					var rfc=c[i].rfc;
					var code=c[i].code;
					var address=c[i].address;
					var args=commandline.args;
					var consummerType=c[i].consummerType;
					var payment=c[i].payment;
					var email=c[i].email;
					//alert("args:"+commandline.args+" commandline.argssize:"+commandline.argssize);
					for(var j=0;j<commandline.argssize;j++){
						consummer=consummer.replace(args[j].toUpperCase(),"<b>"+args[j].toUpperCase()+"</b>");
						code=code.replace(args[j].toUpperCase(),"<b>"+args[j].toUpperCase()+"</b>");
						rfc=rfc.replace(args[j].toUpperCase(),"<b>"+args[j].toUpperCase()+"</b>");
						address=address.replace(args[j].toUpperCase(),"<b>"+args[j].toUpperCase()+"</b>");
					}
					$(this).empty().append("<div style='position: relative;width: 100%; height:auto;'>"+
							"<div class='client-attr' style='width:5%; position:absolute; top:0%; left:0%;word-wrap: break-word;'>[ "+consummerType+" ]</div>"+
							"<div class='client-attr' style='width:5%; position:absolute; top:0%; left:5%;word-wrap: break-word;'>[ "+payment+" ]</div>"+
							"<div class='client-attr' style='width:30%; position:absolute; top:0%; left:10%;word-wrap: break-word;'>"+consummer+"</div>"+
							"<div class='client-attr' style='width:20%; position:absolute; top:0%; left:40%;word-wrap: break-word;'>"+rfc+"</div>"+
							"<div class='client-attr' style='width:40%; position:absolute; top:0%; left:60%;word-wrap: break-word;'>"+address+" "+email+"</div></div>"
					).addClass(i%2==0?"even":"odd");
					var H=0;
					$('.client-attr',this).each(function(){H<$(this).height()?H=$(this).height():0;});
					$(this).css({height:H+'px'});
					$(this).parent().css({height:H+'px'});
					i++;
				});
			}
			$(this).removeClass("ui-corner-all").addClass("ui-corner-top");
			//alert('down:');
			$("#commands").trigger(key_down);
		},
		close: function() {
			$(this).removeClass("ui-corner-top").addClass("ui-corner-all");
			if(emptyCommand)$('#commands').val("");
			emptyCommand=false;
		},
		delay: 0
		
	});
	//end autocomplete
	/*.val("c vip")
	.trigger(keyup).trigger(keyup)
	.trigger(keyenter);*/

	function commandLine(){
		$('#commands').autocomplete('close');
		this.value=$('#commands').val().replace(/^\s+/,"");		//value
		//clean
		
		for(var i=0;i<this.value.length;i++){
			if(this.value.charAt(i)==' '){this.value=this.value.replace(" ","");i--;}
			else break;
		}
		//alert("'"+this.value+"'");
		var splited=this.value.split(" ");
		this.command=splited[0];
		//if(command!='@s')$('#resultset').empty();
		this.kind=false;
		this.args=[];								//args
		this.argssize=0;
		this.getFromDB=false;
		if(isNumber(command)){
			this.kind ='product';
			this.quantity=command;
			for(var i=1;i<splited.length;i++)if(splited[i]!=""){
				this.args[i-1]=splited[i];
				this.argssize++;
			}
			if(this.argssize>=1)this.getFromDB=true;
		}
		else if(this.command=='c'){
			this.kind ='client';
			for(var i=1;i<splited.length;i++)if(splited[i]!=""){
				this.args[i-1]=splited[i];
				this.argssize++;
			}
			if(this.argssize>=1)this.getFromDB=true;
		}
		else if(this.command=='@i'||this.command=='@f'||this.command=='@o'){
			this.kind= 'sample';
			this.args[0]=this.command;
			this.getFromDB=false;
		}
		else if(this.command=='@1'||this.command=='@p'){
			this.kind= 'editproduct';
			this.getFromDB=false;
		}
		else if(this.command=='@2'||this.command=='@c'){
			this.kind= 'editclient';
			this.getFromDB=false;
		}
		else if(this.command=='@b'){
			this.kind="facture";
			for(var i=1;i<splited.length;i++)if(splited[i]!=""){
				this.args[i-1]=splited[i];
				this.argssize++;
			}
			this.getFromDB=false;
		}
		else if(this.command=='@r'){
			this.kind="getinvoice";
			for(var i=1;i<splited.length;i++)if(splited[i]!=""){
				this.args[i-1]=splited[i];
				this.argssize++;
			}
			this.getFromDB=false;
		}
		else if(this.command=='@j'){
			this.kind="justprint";
			for(var i=1;i<splited.length;i++)if(splited[i]!=""){
				this.args[i-1]=splited[i];
				this.argssize++;
			}
			this.getFromDB=false;
		}
		else if(this.command=='@d'){
			this.kind="discount";
			for(var i=1;i<splited.length;i++)if(splited[i]!=""){
				this.args[i-1]=splited[i];
				this.argssize++;
			}
			this.getFromDB=false;
		}
		else if(this.command=='@s'){
			this.kind="searchinvoices";
			for(var i=1;i<splited.length;i++)if(splited[i]!=""){
				this.args[i-1]=splited[i];
				this.argssize++;
			}
			this.getFromDB=false;
		}
		/*
		else if(this.command=='@l'||this.command=='@w'||this.command=='@ł'){
			this.kind="editrow";
		}
		else if(this.command=='@l'||this.command=='@w'||this.command=='@ł'){
			this.kind="editrow";
		}
		else if(this.command=='@p'||this.command=='@o'||this.command=='orden'){
			this.kind="order";
			for(var i=1;i<splited.length;i++)if(splited[i]!=""){
				this.args[i-1]=splited[i];
				this.argssize++;
			}
		}
		*/
		else {
			this.quantity=1;
			this.kind= "retrieve";
			for(var i=0;i<splited.length;i++)if(splited[i]!=""){
				this.args[i]=splited[i];
				this.argssize++;
			}
			if(this.argssize>=1)this.getFromDB=true;
		}

		

		return this;
	}

	$(function() {
		$("#accordion").accordion({
			collapsible: true,
			active: false,
			header:'p',
			autoHeight: false/*,
			change: function(event, ui) {
				var H=0;
				$('.accordion-e').each(function(){
					H+=$(this).height();
				});
				$('#accordion').animate({height:H+"px"},300);
			}*/
		
		});
	});

	function log(quantity,unit,description,code,mark,unitPrice){
		if(!quantity)quantity=1;
		if(!unitPrice)unitPrice=0;
		$("#log").sexytable({
			row:[
					{content: "<div class='quantity'>"+quantity+"</div>", width:5},
					{content: "<div class='unit'>"+unit+"</div>", width:10},
					{content: "<div class='description'>"+description+"</div>", width:40},
					{content: "<div class='code'>"+code+"</div>", width:10},
					{content: "<div class='mark'>"+mark+"</div>", width:10},
					{content: "<div class='unitPrice'>"+unitPrice+"</div>", width:10},
					{content: "<div class='total'>"+(quantity*unitPrice)+"</div>", width:10}
					],animate:100,class_:"tableingrow"
			});
		var row=$('.tableingrow').get(0);
		$('.quantity',row).editable();
		$('.unitPrice',row).editable();
		$('.description',row).editable();
		$('.unit',row).editable();
		$('.code',row).editable();
		$('.mark',row).editable();
		
		$('*',row).bind("contextmenu",function(e) {
	    	e.preventDefault();
		});
		/*$(".unitPrice, .description, .unit, .code, .mark",row).bind('DOMSubtreeModified',function(e){
			var thisrow=$(e.target).parent().parent().get(0);
			var index=$('.tableingrow').index(thisrow);
			alert("index="+index);
			productsLog[index].key=-1;
			productsLog[index].code=productsLog[index].code.replace(/_/gi,"");+"_";
			$('#log').sexytable({'editedRow':true,'index':thisrow});
			onLogChange();
		});
		$(".quantity",row).bind('DOMSubtreeModified',function(e){
			//var row=$(e).parent().parent();
			var index=$('.tableingrow').index(row);
			productsLog[index].quantity=parseFloat($($('.quantity',row).get(0)).html());
			onLogChange();
		});
		*/
	};

	function rendLog(){
		
	}
	
	function onLogChange(){
		var q=[];
		var up=[];
		var i=0;
		
		$('.quantity').each(function(){
			q[i]=parseFloat($(this).text());
			i++;
		});
		i=0;
		$('.unitPrice').each(function(){
			up[i]=parseFloat($(this).text());
			i++;
		});
		i=0;
		var total=0;
		$('.total').each(function(){
			$(this).html((q[i]*up[i]).toFixed(2));
			total+=q[i]*up[i];
			i++;
		});
		$('.g-total').html("$ "+total.toFixed(2));
		$(".tableingrow").unbind('mousedown').mousedown(function(e){
			var index=$('.tableingrow').index(this);
			if(e.which==2){
				productsLog.splice(index,1);
				$('#log').sexytable({'removeRow':true,'index':this});
				onLogChange();
			}
			else if(e.which==3){
				if(productsLog[index].disabled){
					productsLog[index].disabled=false;
					$('#log').sexytable({'enabledRow':true,'index':this});
				}
				else {
					productsLog[index].disabled=true;
					$('#log').sexytable({'disabledRow':true,'index':this});
				}
				onLogChange();
			}
		});

		$(".tableingrow").unbind('DOMSubtreeModified').bind('DOMSubtreeModified',function(e){
			//alert("clicked "+ event.target);
			var index=$('.tableingrow').index(this);
			if($('.unitPrice, .description, .unit, .code, .mark',this).is(e.target)){
				productsLog[index].id=-1;
				productsLog[index].unitPrice=$($('.unitPrice',this).get(0)).html();
				productsLog[index].description=$($('.description',this).get(0)).html();
				productsLog[index].unit=$($('.unit',this).get(0)).html();
				productsLog[index].code=$($('.code',this).get(0)).html().replace(".","")+".";
				productsLog[index].mark=$($('.mark',this).get(0)).html();
				$('#log').sexytable({'editedRow':true,'index':this});
				//onLogChange();
				//alert("edited");
				/*if($('.unitPrice',this).is(e.target)){
					productsLog[index].unitPrice=$($('.unitPrice',this).get(0)).html();
					//alert("unitPrice "+e.target.nodeName);
				}*/
			}
			if($('.quantity',this).is(e.target)){
				productsLog[index].quantity=parseFloat($($('.quantity',this).get(0)).html());
				//alert("quantity "+e.target.nodeName+"\n"+$($('.quantity',this).get(0)).html());
			}
			onLogChange();
			
		});
		total=0;
		for(var i=0;i<productsLog.length;i++)total+=productsLog[i].disabled?0:parseFloat(productsLog[i].quantity)*parseFloat(productsLog[i].unitPrice);
		$('.g-total2').html("$ "+total.toFixed(2));
		var length_=$(".tableingrow").length;
		$('.g-area-to-print').html(length_+" -> "+Math.ceil(length_/17)+" hojas");
		
		
	};
	logToJson=function(){
		var json="{";
		p=productsLog;
		for(var i=0;i<p.length;i++){
			json+="\""+p[i].id+"\"";
		}
	}

	$('#editproduct-6').keyup(function(event){
		if(event.keyCode==$.ui.keyCode.ENTER){
			var e1=$('#editproduct-1').val();
			var e2=$('#editproduct-2').val();
			var e3=$('#editproduct-3').val();
			var e4=$('#editproduct-4').val();
			var e5=$('#editproduct-5').val();
			var e6=$('#editproduct-6').val();
			var quantity=e1;
			var unit=e2!=''?e2:'s/u';
			var description=e3!=''?e3:'s/d';
			var code=e4!=''?e4:'s/c';
			var mark=e5!=''?e5:'s/m';
			var unitPrice=e6;
			if(unitPrice==''||!parseFloat(e6)||quantity==''||!parseFloat(quantity)){alert("precio unitario invalido y/o cantidad");return;}
			var json="{"+
				'"quantity":"'+quantity+'",'+
				'"unit":"'+unit+'",'+
				'"description":"'+description+'",'+
				'"code":"'+code+'",'+
				'"mark":"'+mark+'",'+
				'"productPriceKind":"-1",'+
				'"unitPrice":"'+unitPrice+'",'+
				'"id":"-1" }';
			productsLog.unshift($.parseJSON( json ));
			$('#editproduct').hide('slow');
			$('#commands').focus().val('');
			log(quantity,unit,description,code,mark,unitPrice);
			$('.tableingrow').sexytable({'editedRow':true,'index':$('.tableingrow').get(0)});
			onLogChange();
		}
	});
	$('#editclient-9').keyup(function(event){
		if(event.keyCode==$.ui.keyCode.ENTER){
			var e0=$('#editclient-0').val();
			var e1=$('#editclient-1').val();
			var e2=$('#editclient-2').val();
			var e3=$('#editclient-3').val();
			var e4=$('#editclient-4').val();
			var e5=$('#editclient-5').val();
			var e6=$('#editclient-6').val();
			var e7=$('#editclient-7').val();
			var e8=$('#editclient-8').val();
			var e9=$('#editclient-9').val();
			var e10=$('#editclient-10').val();
			
			client=new setClient(e0?e0:'-1',e1?e1:'publico',e2?e2:'1',e3?e3:'.',e4?e4:'morelia','mexico',e5?e5:'michoacan','.',e6?e6:'.',e7?e7:'.',e8?e8:'.',e9?e9:'0',e10);
							  //(code,consummer,consummerType,address,city,country,state,email,cp,rfc,tel,payment){
			$('#vips option').eq(e2-1).attr('selected', 'selected');
			
			$.ajax({
				url: 'welcome',
				data: {
					client : url.encode($.toJSON(client))
				},
				success: function(data){
					//console.log(client.consummer +" creado");
					var id=data.id;
					for(var j=0;j<productsLog.length;j++){
						var jsonsrt="["+$.toJSON(productsLog[j])+"]";
						$.ajax({
							index : j,
							url: "getthis",
							data: {
								list:$.URLEncode(jsonsrt),
								id:url.encode(id+"")
							},
							dataType: "json",
							error: function(jqXHR, textStatus, errorThrown){
								alert(textStatus);
							},
							success: function(data) {
								//alert(productsLog[0].quantity+" ->"+this.index);
								var j=this.index;
								if(productsLog[j].id!="-1"){
									//alert(jsonsrt);
									//$('.quantity').eq(j).text(data[j].quantity);
									$(".tableingrow").unbind('DOMSubtreeModified');
									$('.unit').eq(j).html(data[0].unit);
									$('.description').eq(j).html(data[0].description);
									$('.code').eq(j).html(data[0].code);
									$('.mark').eq(j).html(data[0].mark);
									$('.unitPrice').eq(j).html(data[0].unitPrice);
									var quantity=productsLog[j].quantity;
									if(productsLog[j].disabled){
										productsLog[j]=data[0];
										productsLog[j].disabled=true;
									}
									else productsLog[j]=data[0];
									productsLog[j].quantity=quantity;
									onLogChange();
									//productsLog[j].quantity=$('.quantity').eq(j).val();
								}									
									//else{alert("code");}
								
							}
						});
					}
				},
				error : function(jqXHR, textStatus, errorThrown){
					alert("maldito error-> status :"+textStatus+". thrown : "+errorThrown);
				},
				dataType:"json"
			});
			
			alert($.toJSON(client));
			//$('#client').html(e1?e1:'publico');
			/*$('#client').html(e1?e1:'publico');
			$('#client-address').html(e3?e3:'.');
			$('#client-city').html(e4?e4:'morelia');
			$('#client-state').html(e5?e5:'michoacan');
			$('#client-cp').html(e6?e6:'.');
			$('#client-rfc').html(e7?e7:'.');
			$('#client-tel').html(e8?e8:'.');
			$('#client-email').html('.');
			$('#client-country').html('.');
			*/
			$('#editclient').hide();
			
		}
	});
	$('#editclient').hide();
	$('#editproduct').hide();
	
	function isNumber(n) {
		  return !isNaN(parseFloat(n)) && isFinite(n);
	}

	$("#vips").change(function(){
		var selectedValue = $(this).find(":selected").val();
		var autocreate=$("#autocreate").is(":checked");
		if(autocreate){
			client=new setClient(client.code,
					client.consummer,
					selectedValue,
					client.address,
					client.city,
					client.country,
					client.state,
					client.email,
					client.cp,
					client.rfc,
					client.tel,
					client.payment,
					client.email
					);
			
			$.ajax({
				url: 'welcome',
				data: {
					client : url.encode($.toJSON(client))
				},
				success: function(data){
					//console.log(client.consummer +" creado");
					client=data;
					
					var id=data.id;
					for(var j=0;j<productsLog.length;j++){
						var jsonsrt="["+$.toJSON(productsLog[j])+"]";
						$.ajax({
							index : j,
							url: "getthis",
							data: {
								list:$.URLEncode(jsonsrt),
								id:url.encode(id+"")
							},
							dataType: "json",
							error: function(jqXHR, textStatus, errorThrown){
								alert(textStatus);
							},
							success: function(data) {
								//alert(productsLog[0].quantity+" ->"+this.index);
								var j=this.index;
								if(productsLog[j].id!="-1"){
									//alert(jsonsrt);
									//$('.quantity').eq(j).text(data[j].quantity);
									$(".tableingrow").unbind('DOMSubtreeModified');
									$('.unit').eq(j).html(data[0].unit);
									$('.description').eq(j).html(data[0].description);
									$('.code').eq(j).html(data[0].code);
									$('.mark').eq(j).html(data[0].mark);
									$('.unitPrice').eq(j).html(data[0].unitPrice);
									var quantity=productsLog[j].quantity;
									if(productsLog[j].disabled){
										productsLog[j]=data[0];
										productsLog[j].disabled=true;
									}
									else productsLog[j]=data[0];
									productsLog[j].quantity=quantity;
									onLogChange();
									//productsLog[j].quantity=$('.quantity').eq(j).val();
								}									
									//else{alert("code");}
								
							}
						});
					}
				},
				error : function(jqXHR, textStatus, errorThrown){
					alert("maldito error-> status :"+textStatus+". thrown : "+errorThrown);
				},
				dataType:"json"
			});
		}
		else{
			var id=client.id;
			for(var i=0;i<productsLog.length;i++){
				var jsonsrt="["+$.toJSON(productsLog[i])+"]";
				$.ajax({
					index : i,
					url: "getthis",
					data: {
						list:$.URLEncode(jsonsrt),
						id:url.encode(id+""),
						consummerType:selectedValue
					},
					dataType: "json",
					error: function(jqXHR, textStatus, errorThrown){
						alert(textStatus);
					},
					success: function(data) {
						//alert(productsLog[0].quantity+" ->"+this.index);
						
						var j=this.index;
						//console.log(data);
						//console.log('index='+j);
						if(productsLog[j].id!="-1"){
							//alert(jsonsrt);
							//$('.quantity').eq(j).text(data[j].quantity);
							$(".tableingrow").unbind('DOMSubtreeModified');
							$('.unit').eq(j).html(data[0].unit);
							$('.description').eq(j).html(data[0].description);
							$('.code').eq(j).html(data[0].code);
							$('.mark').eq(j).html(data[0].mark);
							$('.unitPrice').eq(j).html(data[0].unitPrice);
							var quantity=productsLog[j].quantity;
							if(productsLog[j].disabled){
								productsLog[j]=data[0];
								productsLog[j].disabled=true;
							}
							else productsLog[j]=data[0];
							productsLog[j].quantity=quantity;
							onLogChange();
							//productsLog[j].quantity=$('.quantity').eq(j).val();
						}									
							//else{alert("code");}
						
					}
				});
			}
		}
		client.consummerType=selectedValue;
		$("#autocreate").removeAttr("checked");
		//
		//console.log("the value you selected: " + selectedValue);
	});


});

</script>


<title>Ferremundo - pedidos</title>
</head>
<body>

<div class="ui-widget">
	<label for="comandos">com:</label>
	<input id="commands" />
	
	<select id="vips">
		<option value="1">vip1</option>
		<option value="2">vip2</option>
		<option value="3">vip3</option>
	</select>
	 <i>autocrear cliente</i><input name="elemento1" type="checkbox" value="1" id="autocreate"/>


	<p class="g-total2">$0</p>
	<p class="g-area-to-print">0 -> 0 hojas</p>
	<div id="editproduct">
		<input id="editproduct-1" /><input id="editproduct-2"/><input id="editproduct-3"/><input id="editproduct-4"/><input id="editproduct-5"/><input id="editproduct-6"/>
	</div>
		<div id="editclient">
		<input id="editclient-0"/><input id="editclient-1"/><input id="editclient-2"/><input id="editclient-3"/><input id="editclient-4"/><input id="editclient-5"/><input id="editclient-6"/><input id="editclient-7"/><input id="editclient-8"/><input id="editclient-10"/><input id="editclient-9"/>
	</div>
</div>

<div id="accordion" style="height: auto;">
	<p><a href="#" id="client" class="accordion-e"></a></p>
	<div>
	<div id="client-address" class="accordion-e"></div>
	<div id="client-city" class="accordion-e"></div>
	<div id="client-state" class="accordion-e"></div>
	<div id="client-cp" class="accordion-e"></div>
	<div id="client-rfc" class="accordion-e"></div>
	<div id="client-tel" class="accordion-e"></div>
	<div id="client-email" class="accordion-e"></div>
	<div id="client-country" class="accordion-e"></div>

	</div>
</div>

<div style="position: relative; width: 100%">
<div id="log" style="height: 500px; width: 100%; overflow: auto;" class="ui-widget-content"></div>

</div>
<div id="resultset" style="width: 100%;" class=""></div>
</body>

</html>
