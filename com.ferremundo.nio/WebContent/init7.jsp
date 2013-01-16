<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">



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

<script type="text/javascript" src="js/util.js"></script>
<link rel="stylesheet" type="text/css" href="css/layout.css">
<link rel="stylesheet" type="text/css" href="css/jquery-ui-1.8.4.cupertino.css" />


<script type="text/javascript">
setClient=function(code,consummer,consummertype,address,city,country,state,email,cp,rfc,tel,payment){
	this.id=-1;
	this.code=code;
	this.consummer=consummer;
	this.consummertype=consummertype;
	this.address=address;
	this.city=city;
	this.country=country;
	this.state=state;
	this.email=email;
	this.cp=cp;
	this.rfc=rfc;
	this.tel=tel;
	this.payment=payment;
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
	var client=new setClient("dflt","PUBLICO",1,".","MORELIA",".","MICH",".",".",".",".",0);
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
	
	$("#commands").autocomplete({
		source: function(request, response) {
			commandline=commandLine();
			//alert("kind:"+c.kind+"\nquantity:"+c.quantity+"\nargs:"+c.args+"\nargssize:"+c.argssize+"\ngetFRomBD:"+c.getFromDB+"\ncommand:"+c.command);
			var args="";
			for(var i=0;i<commandline.args.length;i++)args+=commandline.args[i]+(i==(commandline.args.length-1)?"":" ");
			if(commandline.getFromDB){
				//alert(commandline.command);
				$.ajax({
					url: "port",
					dataType: "json",
					data: {
						search: url.encode(args),
						searchrequestid: "0",
						commandkind: commandline.kind,
						consummertype: client.consummertype
					},
					success: function(data) {
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
							args : url.encode(commandline.args.join(" "))
						},
						success: function(data){
							if(commandline.command=='@b'){
								$('#commands').val('');
								//window.location="init6.jsp";
							}
							else if(commandline.command=='@-'){
								
							}
						},
						dataType:"json"
					});
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
								for(var i=itms.length-1; i>=0;i--){
									//itms[i].quantity=parseFloat(itms[i].quantity);
									//itms[i].product.unitprice=parseFloat(itms[i].product.unitprice);
									log(
											(itms[i].quantity),
											itms[i].product.unit,
											itms[i].product.description,
											itms[i].product.code,
											itms[i].product.mark,
											itms[i].product.unitprice
									);
									productsLog.unshift(itms[i].product);
									productsLog[0].quantity=parseFloat(itms[i].quantity);
									
								}
								onLogChange();
								$('#commands').val('');
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
			
				log(quantity,p[i].unit,p[i].description,p[i].code,p[i].mark,p[i].unitprice);
				productsLog.unshift(p[i]);
				productsLog[0].quantity=quantity;
				onLogChange();
				
				//alert(productsLog[i].key);
			}
			else if(commandline.kind=='client'){
				if(confirm("cambiar el cliente puede modificar los datos")){
					client=clients[i];
					$('#client').html(client.consummer);
					$('#client-address').html(client.address);
					$('#client-city').html(client.city);
					$('#client-state').html(client.state);
					$('#client-cp').html(client.cp);
					$('#client-rfc').html(client.rfc);
					$('#client-tel').html(client.tel);
					$('#client-email').html(client.email);
					$('#client-country').html(client.country);
					
					var code=client.code;
					//alert($.URLEncode(jsonsrt));
					
					for(var j=0;j<productsLog.length;j++){
						var jsonsrt="["+$.toJSON(productsLog[j])+"]";
						$.ajax({
							index : j,
							url: "getthis",
							data: {
								list:$.URLEncode(jsonsrt),
								code:url.encode(code)
							},
							dataType: "json",
							error: function(jqXHR, textStatus, errorThrown){
								alert(textStatus);
							},
							success: function(data) {
								//alert(productsLog[0].quantity+" ->"+this.index);
								var j=this.index;
								if(productsLog[j].key!="-1"){
									//alert(jsonsrt);
									//$('.quantity').eq(j).text(data[j].quantity);
									$(".tableingrow").unbind('DOMSubtreeModified');
									$('.unit').eq(j).html(data[0].unit);
									$('.description').eq(j).html(data[0].description);
									$('.code').eq(j).html(data[0].code);
									$('.mark').eq(j).html(data[0].mark);
									$('.unitprice').eq(j).html(data[0].unitprice);
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
							"<div class='product-attr' style='width=10%; position:absolute; top:0%; left:0%;'>"+code+"</div>"+
							"<div class='product-attr' style='width=60%; position:absolute; top:0%; left:10%;'>"+description+"</div>"+
							"<div class='product-attr' style='width=10%; position:absolute; top:0%; left:70%;'>"+mark+"</div>"+
							"<div class='product-attr' style='width=10%; position:absolute; top:0%; left:80%;'>"+p[i].unit+"</div>"+
							"<div class='product-attr' style='width=10%; position:absolute; top:0%; left:90%;'>"+p[i].unitprice+"</div></div>"
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
					//alert("args:"+commandline.args+" commandline.argssize:"+commandline.argssize);
					for(var j=0;j<commandline.argssize;j++){
						consummer=consummer.replace(args[j],"<b>"+args[j]+"</b>");
						code=code.replace(args[j],"<b>"+args[j]+"</b>");
						rfc=rfc.replace(args[j],"<b>"+args[j]+"</b>");
						address=address.replace(args[j],"<b>"+args[j]+"</b>");
					}
					$(this).empty().append("<div style='position: relative;width: 100%; height:auto;'>"+
							"<div class='client-attr' style='width=10%; position:absolute; top:0%; left:0%;'>"+code+"</div>"+
							"<div class='client-attr' style='width=30%; position:absolute; top:0%; left:10%;'>"+consummer+"</div>"+
							"<div class='client-attr' style='width=20%; position:absolute; top:0%; left:40%;'>"+rfc+"</div>"+
							"<div class='client-attr' style='width=40%; position:absolute; top:0%; left:60%;'>"+c[i].address+"</div></div>"
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
		delay: 50
		
	});
	//end autocomplete
	/*.val("c vip")
	.trigger(keyup).trigger(keyup)
	.trigger(keyenter);*/

	function commandLine(){
		this.value=$('#commands').val().replace(/ +(?= )/g,''); 			//value
		//clean
		
		for(var i=0;i<this.value.length;i++){
			if(this.value.charAt(i)==' '){this.value=this.value.replace(" ","");i--;}
			else break;
		}
		//alert("'"+this.value+"'");
		var splited=this.value.split(" ");
		this.command=splited[0];
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

	function log(quantity,unit,description,code,mark,unitprice){
		if(!quantity)quantity=1;
		if(!unitprice)unitprice=0;
		$("#log").sexytable({
			row:[
					{content: "<div class='quantity'>"+quantity+"</div>", width:5},
					{content: "<div class='unit'>"+unit+"</div>", width:10},
					{content: "<div class='description'>"+description+"</div>", width:40},
					{content: "<div class='code'>"+code+"</div>", width:10},
					{content: "<div class='mark'>"+mark+"</div>", width:10},
					{content: "<div class='unitprice'>"+unitprice+"</div>", width:10},
					{content: "<div class='total'>"+(quantity*unitprice)+"</div>", width:10}
					],animate:100,class_:"tableingrow"
			});
		var row=$('.tableingrow').get(0);
		$('.quantity',row).editable();
		$('.unitprice',row).editable();
		$('.description',row).editable();
		$('.unit',row).editable();
		$('.code',row).editable();
		$('.mark',row).editable();
		
		$('*',row).bind("contextmenu",function(e) {
	    	e.preventDefault();
		});
		/*$(".unitprice, .description, .unit, .code, .mark",row).bind('DOMSubtreeModified',function(e){
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
		$('.unitprice').each(function(){
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
			if($('.unitprice, .description, .unit, .code, .mark',this).is(e.target)){
				productsLog[index].key=-1;
				productsLog[index].unitprice=$($('.unitprice',this).get(0)).html();
				productsLog[index].description=$($('.description',this).get(0)).html();
				productsLog[index].unit=$($('.unit',this).get(0)).html();
				productsLog[index].code=$($('.code',this).get(0)).html().replace(".","")+".";
				productsLog[index].mark=$($('.mark',this).get(0)).html();
				$('#log').sexytable({'editedRow':true,'index':this});
				//onLogChange();
				//alert("edited");
				/*if($('.unitprice',this).is(e.target)){
					productsLog[index].unitprice=$($('.unitprice',this).get(0)).html();
					//alert("unitprice "+e.target.nodeName);
				}*/
			}
			if($('.quantity',this).is(e.target)){
				productsLog[index].quantity=parseFloat($($('.quantity',this).get(0)).html());
				//alert("quantity "+e.target.nodeName+"\n"+$($('.quantity',this).get(0)).html());
			}
			onLogChange();
			
		});
		total=0;
		for(var i=0;i<productsLog.length;i++)total+=productsLog[i].disabled?0:parseFloat(productsLog[i].quantity)*parseFloat(productsLog[i].unitprice);
		$('.g-total2').html("$ "+total.toFixed(2));
		
	};
	logToJson=function(){
		var json="{";
		p=productsLog;
		for(var i=0;i<p.length;i++){
			json+="\""+p[i].key+"\"";
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
			var unitprice=e6;
			if(unitprice==''||!parseFloat(e6)||quantity==''||!parseFloat(quantity)){alert("precio unitario invalido y/o cantidad");return;}
			var json="{"+
				'"quantity":"'+quantity+'",'+
				'"unit":"'+unit+'",'+
				'"description":"'+description+'",'+
				'"code":"'+code+'",'+
				'"mark":"'+mark+'",'+
				'"productpricekind":"-1",'+
				'"unitprice":"'+unitprice+'",'+
				'"key":"-1" }';
			productsLog.unshift($.parseJSON( json ));
			$('#editproduct').hide('slow');
			$('#commands').focus().val('');
			log(quantity,unit,description,code,mark,unitprice);
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
			
			client=new setClient(e0?e0:'dflt',e1?e1:'publico',e2?e2:'1',e3?e3:'.',e4?e4:'morelia','mexico',e5?e5:'michoacan','.',e6?e6:'.',e7?e7:'.',e8?e8:'.',e9?e9:'0');
							  //(code,consummer,consummertype,address,city,country,state,email,cp,rfc,tel,payment){
			alert($.toJSON(client));
			$('#client').html(e1?e1:'publico');
			$('#client-address').html(e3?e3:'.');
			$('#client-city').html(e4?e4:'morelia');
			$('#client-state').html(e5?e5:'michoacan');
			$('#client-cp').html(e6?e6:'.');
			$('#client-rfc').html(e7?e7:'.');
			$('#client-tel').html(e8?e8:'.');
			$('#client-email').html('.');
			$('#client-country').html('.');
			$('#editclient').hide();
		}
	});
	$('#editclient').hide();
	$('#editproduct').hide();
	
	function isNumber(n) {
		  return !isNaN(parseFloat(n)) && isFinite(n);
	}


});

</script>


<title>Ferremundo - pedidos</title>
</head>
<body>

<div class="ui-widget">
	<label for="comandos">com:</label>
	<input id="commands" />
	<p class="g-total2">$0<p>
	<div id="editproduct">
		<input id="editproduct-1" /><input id="editproduct-2"/><input id="editproduct-3"/><input id="editproduct-4"/><input id="editproduct-5"/><input id="editproduct-6"/>
	</div>
		<div id="editclient">
		<input id="editclient-0"/><input id="editclient-1"/><input id="editclient-2"/><input id="editclient-3"/><input id="editclient-4"/><input id="editclient-5"/><input id="editclient-6"/><input id="editclient-7"/><input id="editclient-8"/><input id="editclient-9"/>
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
</body>

</html>
