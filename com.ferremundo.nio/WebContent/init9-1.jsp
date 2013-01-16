<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">



<%@page import="com.ferremundo.OnlineClients"%>
<%@page import="com.ferremundo.OnlineClient"%><html>
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
<script type="text/javascript" src="js/jquery-ui-1.9.0.custom.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.4.custom.min.js"></script>
<script type="text/javascript" src="js/jquery.ui.autocomplete.html.js"></script>


<script type="text/javascript" src="js/jquery.json-2.2.js"></script>
<script type="text/javascript" src="js/jquery.editable.js"></script>
<script type="text/javascript" src="js/jquery.caret.1.02.min.js"></script>
<script type="text/javascript" src="js/URLEncode.js"></script>
<script type="text/javascript" src="js/jquery.capsule.js"></script>
<script type="text/javascript" src="cps/tableing.cps.js"></script>

<script type="text/javascript" src="js/jquery.idle-timer.js"></script>


<script type="text/javascript" src="js/util.js"></script>

<script type="text/javascript" src="js/jquery.ui.autocomplete.js"></script>

<link rel="stylesheet" type="text/css" href="css/layout.css">
<link rel="stylesheet" type="text/css" href="css/jquery-ui-1.8.4.cupertino.css" />


<script type="text/javascript">



/*
 * Date Format 1.2.3
 * (c) 2007-2009 Steven Levithan <stevenlevithan.com>
 * MIT license
 *
 * Includes enhancements by Scott Trenda <scott.trenda.net>
 * and Kris Kowal <cixar.com/~kris.kowal/>
 *
 * Accepts a date, a mask, or a date and a mask.
 * Returns a formatted version of the given date.
 * The date defaults to the current date/time.
 * The mask defaults to dateFormat.masks.default.
 */

var dateFormat = function () {
	var	token = /d{1,4}|m{1,4}|yy(?:yy)?|([HhMsTt])\1?|[LloSZ]|"[^"]*"|'[^']*'/g,
		timezone = /\b(?:[PMCEA][SDP]T|(?:Pacific|Mountain|Central|Eastern|Atlantic) (?:Standard|Daylight|Prevailing) Time|(?:GMT|UTC)(?:[-+]\d{4})?)\b/g,
		timezoneClip = /[^-+\dA-Z]/g,
		pad = function (val, len) {
			val = String(val);
			len = len || 2;
			while (val.length < len) val = "0" + val;
			return val;
		};

	// Regexes and supporting functions are cached through closure
	return function (date, mask, utc) {
		var dF = dateFormat;

		// You can't provide utc if you skip other args (use the "UTC:" mask prefix)
		if (arguments.length == 1 && Object.prototype.toString.call(date) == "[object String]" && !/\d/.test(date)) {
			mask = date;
			date = undefined;
		}

		// Passing date through Date applies Date.parse, if necessary
		date = date ? new Date(date) : new Date;
		if (isNaN(date)) throw SyntaxError("invalid date");

		mask = String(dF.masks[mask] || mask || dF.masks["default"]);

		// Allow setting the utc argument via the mask
		if (mask.slice(0, 4) == "UTC:") {
			mask = mask.slice(4);
			utc = true;
		}

		var	_ = utc ? "getUTC" : "get",
			d = date[_ + "Date"](),
			D = date[_ + "Day"](),
			m = date[_ + "Month"](),
			y = date[_ + "FullYear"](),
			H = date[_ + "Hours"](),
			M = date[_ + "Minutes"](),
			s = date[_ + "Seconds"](),
			L = date[_ + "Milliseconds"](),
			o = utc ? 0 : date.getTimezoneOffset(),
			flags = {
				d:    d,
				dd:   pad(d),
				ddd:  dF.i18n.dayNames[D],
				dddd: dF.i18n.dayNames[D + 7],
				m:    m + 1,
				mm:   pad(m + 1),
				mmm:  dF.i18n.monthNames[m],
				mmmm: dF.i18n.monthNames[m + 12],
				yy:   String(y).slice(2),
				yyyy: y,
				h:    H % 12 || 12,
				hh:   pad(H % 12 || 12),
				H:    H,
				HH:   pad(H),
				M:    M,
				MM:   pad(M),
				s:    s,
				ss:   pad(s),
				l:    pad(L, 3),
				L:    pad(L > 99 ? Math.round(L / 10) : L),
				t:    H < 12 ? "a"  : "p",
				tt:   H < 12 ? "am" : "pm",
				T:    H < 12 ? "A"  : "P",
				TT:   H < 12 ? "AM" : "PM",
				Z:    utc ? "UTC" : (String(date).match(timezone) || [""]).pop().replace(timezoneClip, ""),
				o:    (o > 0 ? "-" : "+") + pad(Math.floor(Math.abs(o) / 60) * 100 + Math.abs(o) % 60, 4),
				S:    ["th", "st", "nd", "rd"][d % 10 > 3 ? 0 : (d % 100 - d % 10 != 10) * d % 10]
			};

		return mask.replace(token, function ($0) {
			return $0 in flags ? flags[$0] : $0.slice(1, $0.length - 1);
		});
	};
}();

// Some common format strings
dateFormat.masks = {
	"default":      "ddd mmm dd yyyy HH:MM:ss",
	shortDate:      "m/d/yy",
	mediumDate:     "mmm d, yyyy",
	longDate:       "mmmm d, yyyy",
	fullDate:       "dddd, mmmm d, yyyy",
	shortTime:      "h:MM TT",
	mediumTime:     "h:MM:ss TT",
	longTime:       "h:MM:ss TT Z",
	isoDate:        "yyyy-mm-dd",
	isoTime:        "HH:MM:ss",
	isoDateTime:    "yyyy-mm-dd'T'HH:MM:ss",
	isoUtcDateTime: "UTC:yyyy-mm-dd'T'HH:MM:ss'Z'"
};

// Internationalization strings
dateFormat.i18n = {
	dayNames: [
		//"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat",
		"dom", "Lun", "Mar", "Mie", "Jue", "Vie", "Sab",
		//"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
		"Domingo", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado"
	],
	monthNames: [
		//"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
		"Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic",
		//"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
		"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
	]
};

// For convenience...
Date.prototype.format = function (mask, utc) {
	return dateFormat(this, mask, utc);
};



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

setAgent=function(code,consummer,consummerType,address,city,country,state,email,cp,rfc,tel,payment,email){
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
	$('#agent').html("[ "+consummerType+" ] [ "+payment+" ] "+consummer+ " [ "+rfc+" ]");
	$('#agent-address').html(consummer+" "+address);
	$('#agent-city').html(city);
	$('#agent-state').html(state);
	$('#agent-cp').html(cp);
	$('#agent-rfc').html(rfc);
	$('#agent-tel').html(tel);
	$('#agent-email').html(email);
	$('#agent-country').html(country);
	
	return this;
}
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
function validateRfc(rfcStr) {
	var strCorrecta;
	strCorrecta = rfcStr.replace(/\-/g,'');	
var valid;
	if (strCorrecta.length == 12){
	valid = '^(([A-Z]|[a-z]){3})([0-9]{6})((([A-Z]|[a-z]|[0-9]){3}))';
	}else{
	valid = '^(([A-Z]|[a-z]|\s){1})(([A-Z]|[a-z]){3})([0-9]{6})((([A-Z]|[a-z]|[0-9]){3}))';
	}
	var validRfc=new RegExp(valid);
	var matchArray=strCorrecta.match(validRfc);
	if (matchArray==null) {
		return false;
	}
	else{
		return true;
	}
	
};
(function ($, undefined) {
    $.fn.getCursorPosition = function() {
        var el = $(this).get(0);
        var pos = 0;
        if('selectionStart' in el) {
            pos = el.selectionStart;
        } else if('selection' in document) {
            el.focus();
            var Sel = document.selection.createRange();
            var SelLength = document.selection.createRange().text.length;
            Sel.moveStart('character', -el.value.length);
            pos = Sel.text.length - SelLength;
        }
        return pos;
    }
})(jQuery);

function setSelectionRange(input, selectionStart, selectionEnd) {
	  if (input.setSelectionRange) {
	    input.focus();
	    input.setSelectionRange(selectionStart, selectionEnd);
	  }
	  else if (input.createTextRange) {
	    var range = input.createTextRange();
	    range.collapse(true);
	    range.moveEnd('character', selectionEnd);
	    range.moveStart('character', selectionStart);
	    range.select();
	  }
	}

	function setCaretToPos (input, pos) {
	  setSelectionRange(input, pos, pos);
	}

	

$(document).ready(function(){
	<%
	OnlineClients clients= OnlineClients.instance();
	String ipAddres=request.getRemoteAddr();
	out.println("\tvar IP_ADDRESS='"+ipAddres+"';");
	int clientReference=clients.add(ipAddres,request.getSession().getId());
	out.println("\tvar CLIENT_REFERENCE="+clientReference+";");
	OnlineClient onlineClient=clients.get(clientReference);
	out.println("\tvar TOKEN='"+onlineClient.getToken()+"';");
	request.getSession().setMaxInactiveInterval(60*60*8);
	System.out.println("CLIENT_REFERENCE="+clientReference+";\n"+"IP_ADDRESS='"+ipAddres+"';\n"+"TOKEN='"+onlineClient.getToken()+"';");

	%>
	var AUTHORIZED=false;
	clientauthenticateLP=function () {
		var ret=false; 
		$.ajax({
			url: "clientauthenticate",
			dataType: "json",
			type: 'POST',
			async: false,
			data: {
				login: $('#login').val(),
				password: $('#password').val(),
				token: TOKEN,
				clientReference: CLIENT_REFERENCE
			},
			success: function(data) {
				//console.log(data.authenticated);
				shopman=data.shopman;
				AUTHORIZED=true;
				$('#login').val('');
				$('#password').val('');
				$('#login-form').dialog('close');
				$('#commands').focus();
				$('#lockbutton').html('lock : '+shopman.name)
				$.idleTimer(1000*60*5);
				$(document).bind("idle.idleTimer", function(){
					lock();
				});
				$( "#lock-form" ).dialog('option','title','Locked - '+shopman.name);
				if(onlineClientHasAccess('SHOPMAN_CREATE')){
					addRegisterButton();
				}
				else console.log('no access to SHOPMAN_CREATE');
				ret=true;
			},
			error: function(jqXHR, textStatus, errorThrown){
				alert(errorThrown);
				//$( "#unauthorizedAlert" ).dialog('open');
				$('#login').focus();
				//$(this).closest('.ui-dialog').find('.ui-dialog-buttonpane button:has(Ok)').focus();
				//$( "#unauthorizedAlert" ).focus();
			}
		});
		return ret;
	}
	clientauthenticateP=function () {
		var ret=false;
		$.ajax({
			url: "clientauthenticate",
			dataType: "json",
			type:'POST',
			async:false,
			data: {
				password: $('#unlockpassword').val(),
				token : TOKEN,
				clientReference: CLIENT_REFERENCE
			},
			success: function(data) {
				AUTHORIZED=true;
				$('#unlockpassword').val('');
				$('#lock-form').dialog('close');
				$('#commands').focus();
				ret=true;
			},
			error: function(jqXHR, textStatus, errorThrown){
				alert(jqXHR.status+" "+textStatus+" : "+jqXHR.responseText);
				//$( "#unauthorizedAlert" ).dialog('open');
				$('#unlockpassword').focus();
				//$($( "#unauthorizedAlert" ).dialog("option", "buttons")['Ok']).focus();
				//
			}
		});
		return ret;
    }

	addRegisterButton=function(){
		$('body').append("<button type='button' id='registerButton'>registrar usuario</button>");
		$('#registerButton').bind('click',function(){
			if(onlineClientHasAccess('SHOPMAN_CREATE')){

				$('#verify-form').dialog("open");
				$('#verify-').hide();
				$('#verifyPassword').hide();
				
			}
		});
	}
	
	onlineClientHasAccess=function(permission){
		var ret=false;
		$.ajax({
			url: "clienthasaccess",
			dataType: "json",
			type:'POST',
			async:false,
			data: {
				permission: permission,
				token: TOKEN,
				clientReference: CLIENT_REFERENCE
			},
			success: function(data) {
				ret=data.hasAccess;
			}
		});
		return ret;
	}

	clientauthenticateR=function () {
		var ret=false;
		$.ajax({
			url: "clientauthenticate",
			dataType: "json",
			type:'POST',
			async:false,
			data: {
				password: $('#verifypassword').val(),
				token : TOKEN,
				clientReference: CLIENT_REFERENCE
			},
			success: function(data) {
				AUTHORIZED=true;
				$('#verifypassword').val('');
				$('#verify-form').dialog('close');
				$('#commands').focus();
				ret=true;
			},
			error: function(jqXHR, textStatus, errorThrown){
				alert(jqXHR.status+" "+textStatus+" : "+jqXHR.responseText);
				
				//$( "#unauthorizedAlert" ).dialog('open');
				$('#unlockpassword').focus();
				//$($( "#unauthorizedAlert" ).dialog("option", "buttons")['Ok']).focus();
				//
			}
		});
		return ret;
	}

	registerShopman=function () {
		var ret=false;
		$.ajax({
			url: "clientauthenticate",
			dataType: "json",
			type:'POST',
			async:false,
			data: {
				newUserName: $('#newUserName').val(),
				newUserLogin: $('#newUserLogin').val(),
				newUserPassword: $('#newUserPassword').val(),
				reNewUserPassword: $('#reNewUserPassword').val(),
				token : TOKEN,
				clientReference: CLIENT_REFERENCE
			},
			success: function(data) {
				//alert("creado :"+ $('#newUserName').val())
				$('#newUserName').val('');
				$('#newUserLogin').val('');
				$('#newUserPassword').val('');
				$('#reNewUserPassword').val('');
				$('#commands').focus();
				ret=true;
			},
			error: function(jqXHR, textStatus, errorThrown){
				alert(jqXHR.status+" "+textStatus+" : "+jqXHR.responseText);
				//alert('no creado : verifica password/re password');
				//$( "#unauthorizedAlert" ).dialog('open');
				$('#newUserName').focus();
				//$($( "#unauthorizedAlert" ).dialog("option", "buttons")['Ok']).focus();
				//
			}
		});
		return ret;
    }
	
	$("#login-form").dialog({
        autoOpen: false,
        //height: 300,
        //width: 350,
        modal: true,
        hide: "explode",
        closeOnEscape:false,
        buttons: {
            "login": function(){
        		return clientauthenticateLP();
        	}
            
        },
        beforeClose: function(event, ui){
        	if(!AUTHORIZED)$('#login-form').dialog("option",'hide','');
		},
        close: function(){
			if(!AUTHORIZED)$('#login-form').dialog('open');
			$('#login-form').dialog("option",'hide','explode');
        }
    });

	$( "#lock-form" ).dialog({
        autoOpen: false,
        //height: 300,
        //width: 350,
        modal: true,
        hide: "explode",
        closeOnEscape:false,
        buttons: {
            "unlock": function(){return clientauthenticateP();}
        },
        beforeClose: function(event, ui){
        	if(!AUTHORIZED)$('#lock-form').dialog("option",'hide','');
		},
        close: function(){
			if(!AUTHORIZED)$('#lock-form').dialog('open');
			$('#lock-form').dialog("option",'hide','explode');
        },
        open:function(unlockMessage){
            this.title=unlockMessage;
            $('#logn').hide();
            $('#unlockpassword').focus();
        }
    });

	$( "#register-form" ).dialog({
        autoOpen: false,
        //height: 300,
        //width: 350,
        modal: true,
        hide: "explode",

        buttons: {
            "registrar": function(){
                if(registerShopman()){
                    alert('creado');
                    $( "#register-form" ).dialog('close');
                }
                else {
                    alert('invalido');
                    $( "#register-form" ).dialog('open');
                } 
			}
        }
    });

	$( "#verify-form" ).dialog({
        autoOpen: false,
        //height: 300,
        //width: 350,
        modal: true,
        hide: "explode",

        buttons: {
            "verificar": function(){
        		if(clientauthenticateR()){
        			$( "#register-form" ).dialog('open');
                }
        		else{
        			$( "#verify-form" ).dialog('open');
            	}
            }
        }
    });

	$('#password').unbind('keydown').unbind('keypress').bind('keypress',function(event){
		if(event.which!=13)return;
		$( "#login-form" ).dialog("option", "buttons")['login'].apply($( "#login-form" )[0]);
	});
	$('#unlockpassword').unbind('keydown').unbind('keypress').bind('keyup',function(event){
		if(event.which!=13)return;
		$( "#lock-form" ).dialog("option", "buttons")['unlock'].apply($( "#lock-form" )[0]);
	});
	
	function authenticate(){
		$( "#login-form" ).dialog('open');
		$('#login').val('');
		$('#password').val('');
	}


	function lock(){
		AUTHORIZED=false;
		$.ajax({
			url: "clientauthenticate",
			dataType: "json",
			type:'POST',
			token : TOKEN,
			data: {
					lock: true,
					token:TOKEN,
					clientReference: CLIENT_REFERENCE
			}
		});
		$( "#lock-form" ).dialog('open');
		

	}
	$( "#unauthorizedAlert" ).dialog({
        modal: true,
        stack:false,
        hide: "explode",
        autoOpen: false,
        buttons: {
            Ok: function() {
                $( this ).dialog( "close" );
            }
        }
    });

	$('#unlockpassword').focus(function(){
	    this.select();
	});
    
	$('#lockbutton').click(function(){
		lock();
	});
	
	//$('#login-form').hide();
	//$('#lock-form').hide();
	//$('#unauthorizedAlert').hide();
	
	
	//INIT
	//$('#commands').focus();

	
	

	var shopman={};
	var inputValue;
	var products;
	var productsLog=[];
	var clients;
	var client=new setClient("-1","PUBLICO EN GRAL",1,".","MORELIA",".","MICH",".",".","PARA FACTURAR",".",0,"");
	var agent=null;
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
	resetClient=function(){
		productsLog=[]
		new setAgent(".","agente indefinido",".",".",".",".",".",".",".",".",".",".",".");
		new setClient(".","cliente indefinido",".",".",".",".",".",".",".",".",".",".",".");
		agent=null;
		client=null;
		$('#log').empty();
		onLogChange();
		$("#commands").val('');
		$("#commands").focus();
		
	}
	resetClient();
	authenticate();
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
	$("#commands").bind('keypress',function(event){
		//console.log(event.which);
		commandline=commandLine(event);
		if(commandline.kind=='product'||
				commandline.kind=='retrieve'||
				commandline.kind=='agent'||
				commandline.kind=='client'){
			$("#commands").autocomplete( "search" );
			return;
		}
		$( "#commands" ).autocomplete( "search" );
		if(event.which!=13)return;
		//alert(event.which);
		//console.log(commandline.kind);
		

		//console.log("l="+commandline.args.length);
		
		if(!$(this).autocomplete( "option" , 'isOpen')&&commandline.args.length==1) {
			
			REQUEST_NUMBER=REQUEST_NUMBER+1;
			$.ajax({
				url: "getproductbycode",
				dataType: "json",
				data: {
					code: commandline.args[0],
					requestNumber: REQUEST_NUMBER,
					consummerType: client?client.consummerType:1,
					token : TOKEN,
					clientReference: CLIENT_REFERENCE
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
				},
				type:'POST'
			});
	    }
	});

/** AUTOCOMPLETE BEGINS*/
	
	$("#commands").autocomplete({
		html:true,
		disabled:true,
		
/** AUTOCOMPLETE SOURCE*/
		source: function(request, response) {
			commandline=commandLine();
			//alert("kind:"+c.kind+"\nquantity:"+c.quantity+"\nargs:"+c.args+"\nargssize:"+c.argssize+"\ngetFRomBD:"+c.getFromDB+"\ncommand:"+c.command);
			var args="";
			for(var i=0;i<commandline.args.length;i++)args+=commandline.args[i]+(i==(commandline.args.length-1)?"":" ");
			if(commandline.getFromDB){
				if(commandline.kind=='client'||commandline.kind=='agent'||commandline.kind=='product'){
					if(commandline.args.length<1)return;
				}
				//alert(commandline.command);
				REQUEST_NUMBER=REQUEST_NUMBER+1;
				$.ajax({
					url: "port",
					dataType: "json",
					type:'POST',
					data: {
						search: encodeURIComponent(args),
						requestNumber: REQUEST_NUMBER,
						clientReference: CLIENT_REFERENCE,
						commandkind: commandline.kind,
						consummerType: client?client.consummerType:1,
						token : TOKEN
					},
					success: function(data) {
						if(REQUEST_NUMBER!=data.requestNumber){
							//console.log("distintos id's");
							return;
						}
						inputValue=$("#commands").val();
						var cpos=$("#commands").getCursorPosition();
						//console.log(cpos);
						//console.log(this);
						if(commandline.kind=='product'||commandline.kind=='retrieve'){
							products=data.products;
							response($.map(data.products, function(item) {
								return {
									label: item.code+" "+item.description,
									value: inputValue
								};
							}));
						}
						else if(commandline.kind=='client'||commandline.kind=='agent'){
							clients=data.clients;
							response($.map(data.clients, function(item) {
								return {
									label: item.consummer+" "+item.rfc,
									value: inputValue
								};
							}));
						}
						setCaretToPos($("#commands")[0],cpos);
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
			else if(commandline.kind=='editagent'){
				$('#editagent').show('slow');
				$('#editagent-0').val('');
				$('#editagent-1').val('');
				$('#editagent-2').val('');
				$('#editagent-3').val('');
				$('#editagent-4').val('');
				$('#editagent-5').val('');
				$('#editagent-6').val('');
				$('#editagent-7').val('');
				$('#editagent-8').val('');
				$('#editagent-9').val('');
				$('#editagent-10').val('');
				$('#editagent-0').focus();
				$('#commands').val('');
			}
			else if(commandline.kind=='sample'){
				if(agent==null){
					alert("error: Agente Indefinido.");
					$('#commands').val('');
					return;
				}
				//alert(" kind "+commandline.kind+" argsL "+commandline.args.length);
				if(commandline.args.length>=0&&productsLog.length>0){
					if(commandline.command=='@f'){
						if(client==null){
							alert("error: cliente Indefinido.");
							$('#commands').val('');
							return;
						}
						if(!validateRfc(client.rfc)){
							$('#commands').val('');
							alert('cliente no facturable RFC invalido');
							return;
						}
					}
					if(commandline.command=='@i'||
							commandline.command=='@o'||
							commandline.command=='+o'){
						if(client==null){
							alert("error: cliente Indefinido.");
							$('#commands').val('');
							return;
						}
					}
					//alert(" kind "+commandline.kind);
					$.ajax({
						type: 'POST',
						url: 'wishing',
						data: {
							client : encodeURIComponent($.toJSON(client)),
							list : encodeURIComponent($.toJSON(productsLog)),
							shopman : encodeURIComponent($.toJSON(shopman)),
							metadata : encodeURIComponent($.toJSON(metadata)),
							requester : encodeURIComponent($.toJSON(requester)),
							seller : encodeURIComponent($.toJSON(seller)),
							agent : encodeURIComponent($.toJSON(agent)),
							destiny : encodeURIComponent($.toJSON(destiny)),
							args : encodeURIComponent(commandline.args.join(" ")),
							token : TOKEN,
	    					clientReference : CLIENT_REFERENCE
						},
						success: function(data){
							resetClient();
							$('#commands').val('');
							var result="TIPO : "+(data.invoiceType==0?'factura':data.invoiceType==1?'pedido':'cotización')+" | "+
								"REF : "+data.reference+" | "+
								"VALOR NETO : "+data.totalValue+" | "+
								"TOTAL : "+data.total+" | "+
								"AGENTE : "+data.agent.consummer+" | "+
								"$ AGENTE : "+data.agentPayment+" | "+
								"CLIENTE : "+data.client.consummer+" | "+
								"ATENDIO : "+data.shopman.login;
								
							var consummerObj={content:result};
							
							//$('#resultset').incapsule({dclass:'box fleft', width:'100%',content:''},'com.ferremundo.cps.GenericDiv')
							//.capsule(data.invoices[i].items,'com.ferremundo.cps.TB').addClass(i%2!=0?'odd':'even')
							//.precapsule(consummerObj,'com.ferremundo.cps.GenericDiv');
							$('#logResultset').preincapsule(consummerObj,'com.ferremundo.cps.GenericDiv').addClass('box fleft');
							
						},
						dataType:"json"
					});
				}
				else {
					alert('ningun item en lista');
					$('#commands').val('');
				}
			}
			else if(commandline.kind=='consultthebox'){
				$.ajax({
					url: 'consultthebox',
					data: {
						command : encodeURIComponent(commandline.command),
						token : TOKEN,
    					clientReference: CLIENT_REFERENCE
					},
					type:'POST',
					success: function(data){
						alert('$'+data.cash);
							$('#commands').val('');
							//window.location="init6.jsp";
						
					},
					error:function(jqXHR, textStatus, errorThrown){
						console.log(jqXHR);
						console.log(textStatus);
						console.log(errorThrown);
						alert("el sistema dice: "+textStatus+" - "+errorThrown+" - "+jqXHR.responseText);
					}/*,
					dataType:"json",
					statusCode: {
					    400: function(jqXHR, textStatus, errorThrown) {
					      alert("el sistema dice: "+textStatus+" - "+errorThrown);
					    }
					  }*/
				});
			}
			
			else if(commandline.kind=='invoicepayment'){
				/***TODO mostrar inf del agente y cliente primero, para confirmar*/
				
				if(commandline.args.length>=1&&commandline.args[0].charAt(commandline.args[0].length-1)=='.'){
					if(!confirm("realizar la siguiente operacion? : "+
							(commandline.command=='++'?'pagar '+commandline.args[0].toUpperCase():'pagar agente para'+commandline.args[0].toUpperCase()))){
						$('#commands').val('');
						return;
					}
					$.ajax({
						url: 'invoicepayment',
						data: {
							command : encodeURIComponent(commandline.command),
							args : commandline.args.join(" "),
							client : encodeURIComponent($.toJSON(client)),
							token : TOKEN,
	    					clientReference: CLIENT_REFERENCE
						},
						type:'POST',
						success: function(data){
							alert(commandline.args+" pago exitoso");
								$('#commands').val('');
								//window.location="init6.jsp";
							
						},
						error:function(jqXHR, textStatus, errorThrown){
							console.log(jqXHR);
							console.log(textStatus);
							console.log(errorThrown);
							alert("el sistema dice: "+textStatus+" - "+errorThrown+" - "+jqXHR.responseText);
						}/*,
						dataType:"json",
						statusCode: {
						    400: function(jqXHR, textStatus, errorThrown) {
						      alert("el sistema dice: "+textStatus+" - "+errorThrown);
						    }
						  }*/
					});
				}
			}
			
			else if(commandline.kind=='facture'){
				if(client==null){
					alert("cliente indefinido");
					$('#commands').val('');
					return;
				}
				if(!validateRfc(client.rfc)){
					$('#commands').val('');
					alert('cliente no facturable RFC invalido');
					return;
				}
				if(commandline.args.length>=1&&commandline.args[0].charAt(commandline.args[0].length-1)=='.'){
					
					if(!confirm("sera facturado "+ commandline.args[0].toUpperCase()+ " a "+client.consummer+" ? "))return;
					$.ajax({
						url: 'facture',
						data: {
							command : commandline.command,
							args : commandline.args.join(" "),
							client : encodeURIComponent($.toJSON(client)),
							token : TOKEN,
	    					clientReference: CLIENT_REFERENCE
						},
						success: function(data){
							if(commandline.command=='+f'){
								$('#commands').val('');
								//window.location="init6.jsp";
							}
							else if(commandline.command=='@-'){
								
							}
						},
						error : function(jqXHR, textStatus, errorThrown){
							alert(textStatus+" : "+errorThrown);
						},
						dataType:"json",
						type:'POST'
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
						type:'POST',
						data: {
							command : commandline.command,
							reference : commandline.args.join(" "),
							token : TOKEN,
	    					clientReference: CLIENT_REFERENCE
						},
						success: function(data){
							if(commandline.command=='@r'){
								var itms=data.items;
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
									productsLog[0].disabled=itms[i].disabled;
									
									if(itms[i].id==-1){
										$('#log').sexytable({'editedRow':true,'index':0});
									}
									if(itms[i].disabled){
										$('#log').sexytable({'disabledRow':true,'index':0});
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
						type:'POST',
						data: {
							paths : encodeURIComponent(commandline.args.join(" ")),
							token : TOKEN,
	    					clientReference: CLIENT_REFERENCE
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
										for(var k=0;k<commandline.pargs.length;k++){
											if(!isNumber(item[field])){
												item[field]=item[field].replace(commandline.pargs[k].toUpperCase().replace(/\"/g,""),"<i style='background-color:#fbff8d'><b>"+commandline.pargs[k].toUpperCase().replace(/\"/g,"")+"</b></i>");
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
								var date=new Date(new Number(data.invoices[i].metaData.date)).format('dd.mmm.yyyy').toUpperCase();
								var shopmanName=null;
								var shopmanLogin=null;
								var agentName=null;
								var agentAddress=null;
								var agentRfc=null;
								var agentType=null;
								if(data.invoices[i].shopman!=null){
									shopmanName=data.invoices[i].shopman.name;
									shopmanLogin=data.invoices[i].shopman.login;
								}
								if(data.invoices[i].agent!=null){
									agentName=data.invoices[i].agent.consummer;
									agentAddress=data.invoices[i].agent.address;
									agentRfc=data.invoices[i].agent.rfc;
									agentType=data.invoices[i].agent.consummerType;
								}
								
								var consummerContent="<b>fecha:</b>"+date+
									" | <b>ref:</b>"+reference+
									(invoices[i].totalValue?" | <b>totalValue:</b>"+invoices[i].totalValue:"")+
									(invoices[i].agentPayment?" | <b>totalValue:</b>"+invoices[i].agentPayment:"")+
									" | <b>total:</b>"+(Math.round(gtotal*100)/100)+"<br>"+
									"<b>cliente:</b>"+consummer+
									" | <b>tipo:</b>"+consummerType+
									" | <b>credito:</b>"+payment+
									" | <b>dir:</b>"+address+
									" | <b>ciudad:</b>"+city+
									" | <b>estado:</b>"+state+
									" | <b>cp:</b>"+cp+
									" | <b>rfc:</b>"+rfc+"<br>"+
									"<b>agente nombre:</b>"+(agentName?agentName:'')+
									" | <b>agente dir:</b>"+(agentAddress?agentAddress:'')+
									" | <b>agente rfc:</b>"+(agentRfc?agentRfc:'')+
									" | <b>agente tipo:</b>"+(agentType?agentType:'')+"<br>"+
									"<b>despachó nombre:</b>"+(shopmanName?shopmanName:'')+
									" | <b>despachó login:</b>"+(shopmanLogin?shopmanLogin:'');
								for(var k=0;k<commandline.pargs.length;k++){
									if(!isNumber(consummer[field])){
										consummerContent=consummerContent.replace(commandline.pargs[k].toUpperCase().replace(/\"/g,""),"<i style='background-color:#fbff8d'><b>"+commandline.pargs[k].toUpperCase().replace(/\"/g,"")+"</b></i>");
										//if(item[field].indexOf(commandline.args[k].toUpperCase())!=-1)contains=true;	
									}
								}
								
								var consummerObj={content:consummerContent};
								
								$('#resultset').incapsule({dclass:'box fleft', width:'100%',content:''},'com.ferremundo.cps.GenericDiv')
								.capsule(data.invoices[i].items,'com.ferremundo.cps.TB').addClass(i%2!=0?'odd':'even')
								.precapsule(consummerObj,'com.ferremundo.cps.GenericDiv');
							}
							
						},
						dataType:"json",
						error:function(){
							$('#resultset').empty();
						}
					});
				}
			}



			
		},
		minLength: 1,
/** AUTOCOMPLETE SELECT*/
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
			else if(commandline.kind=='client'||commandline.kind=='agent'){
				//TODO deactivate agent here
				if(commandline.kind=='agent'){
					agent=clients[i];
					$('#agent').html("[ "+agent.consummerType+" ] "+agent.consummer+ " [ "+agent.id+" ]");
					$('#agent-address').html(agent.address);
					$('#agent-city').html(agent.city);
					$('#agent-state').html(agent.state);
					$('#agent-cp').html(agent.cp);
					$('#agent-rfc').html(agent.rfc);
					$('#agent-tel').html(agent.tel);
					$('#agent-email').html(agent.email);
					$('#agent-country').html(agent.country);

					emptyCommand=true;
					return;
				}
				if(event.which==2){
					if(confirm("quitar cliente de lista?:"+$.toJSON(clients[i]))){
						$("#commands").val("").focus();
						$.ajax({
							index : j,
							type:'POST',
							url: "changeclientstatus",
							data: {
								active:false,
								id:clients[i].id,
								token : TOKEN,
		    					clientReference: CLIENT_REFERENCE
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
				//TODO chambea esto de setear el acordion de esta forma piñata
				
				else if(confirm("cambiar el cliente puede modificar los datos")){
					console.log(clients[i].agentCode);
					if(clients[i].agentCode!=null){
						$.ajax({
							index : j,
							url: "getclientbycode",
							data: {
								hash:clients[i].agentCode,
								token : TOKEN,
								where : 'agents',
		    					clientReference: CLIENT_REFERENCE
							},
							type: 'POST',
							dataType: "json",
							error: function(jqXHR, textStatus, errorThrown){
								alert(textStatus);
							},
							success: function(data) {
								agent=data;
								$('#agent').html("[ "+agent.consummerType+" ] "+agent.consummer+ " [ "+agent.id+" ]");
								$('#agent-address').html(agent.address);
								$('#agent-city').html(agent.city);
								$('#agent-state').html(agent.state);
								$('#agent-cp').html(agent.cp);
								$('#agent-rfc').html(agent.rfc);
								$('#agent-tel').html(agent.tel);
								$('#agent-email').html(agent.email);
								$('#agent-country').html(agent.country);
							}
						});
					}
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
								list:encodeURIComponent(jsonsrt),
								id:id,
								token : TOKEN,
		    					clientReference: CLIENT_REFERENCE
							},
							dataType: "json",
							error: function(jqXHR, textStatus, errorThrown){
								alert(textStatus);
							},
							type:'POST',
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
/** AUTOCOMPLETE OPEN*/
		open: function() {
			$('.ui-autocomplete').css({width:'80%',height:'auto'});
			
			if(commandline.kind=='product'||commandline.kind=='retrieve'){
				var i=0;
				$('li>a.ui-corner-all').each(function(){
					var p=products;
					var description=p[i].description;
					var code=p[i].code;
					var mark=p[i].mark;
					var args=commandline.args;
					//alert("args:"+commandline.args+" commandline.argssize:"+commandline.argssize);
					for(var j=0;j<commandline.pargs.length;j++){
						description=description.replace(pargs[j].toUpperCase().replace(/\"/g,""),"<b>"+pargs[j].toUpperCase().replace(/\"/g,"")+"</b>");
						code=code.replace(pargs[j].toUpperCase().replace(/\"/g,""),"<b>"+pargs[j].toUpperCase().replace(/\"/g,"")+"</b>");
						mark=mark.replace(pargs[j].toUpperCase().replace(/\"/g,""),"<b>"+pargs[j].toUpperCase().replace(/\"/g,"")+"</b>");
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
			else if(commandline.kind=='client'||commandline.kind=='agent'){
				var i=0;
				$('li>a.ui-corner-all').each(function(){
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
					for(var j=0;j<commandline.pargs.length;j++){
						consummer=consummer.replace(pargs[j].toUpperCase().replace(/\"/g,""),"<b>"+pargs[j].toUpperCase().replace(/\"/g,"")+"</b>");
						code=code.replace(pargs[j].toUpperCase().replace(/\"/g,""),"<b>"+pargs[j].toUpperCase().replace(/\"/g,"")+"</b>");
						rfc=rfc.replace(pargs[j].toUpperCase().replace(/\"/g,""),"<b>"+pargs[j].toUpperCase().replace(/\"/g,"")+"</b>");
						address=address.replace(pargs[j].toUpperCase().replace(/\"/g,""),"<b>"+pargs[j].toUpperCase().replace(/\"/g,"")+"</b>");
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
/** AUTOCOMPLETE ENDS*/
 
/** COMMAND LINE FUNCTION*/
	function commandLine(){
		//resetClient();
		console.log(productsLog);
		$('#commands').autocomplete('close');
		this.value=$('#commands').val().replace(/^\s\s*/, '').replace(/\s\s*$/, '');		//value
		//clean
		
		//alert("'"+this.value+"'");
		var splited=this.value.split(" ");
		this.command=splited[0];
		//if(command!='@s')$('#resultset').empty();
		this.kind=false;
		this.args=[];								//args
		this.pargs=[];
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
			this.pargs=this.value.match(/[^\s"']+|"([^"]*)"|'([^']*)'/g);
			this.getFromDB=true;
		}
		else if(this.command=='c'){
			this.kind ='client';
			for(var i=1;i<splited.length;i++)if(splited[i]!=""){
				this.args[i-1]=splited[i];
				this.argssize++;
			}
			if(this.argssize>=1)this.getFromDB=true;
			this.pargs=this.value.match(/[^\s"']+|"([^"]*)"|'([^']*)'/g);
			this.pargs.splice(0,1);
			this.getFromDB=true;
		}
		else if(this.command=='a'){
			this.kind ='agent';
			for(var i=1;i<splited.length;i++)if(splited[i]!=""){
				this.args[i-1]=splited[i];
				this.argssize++;
			}
			if(this.argssize>=1)this.getFromDB=true;
			this.pargs=this.value.match(/[^\s"']+|"([^"]*)"|'([^']*)'/g);
			this.pargs.splice(0,1);
			this.getFromDB=true;
		}
		else if(this.command=='@i'||
				this.command=='@o'||
				this.command=='@f'||this.command=='+o'){
			this.kind= 'sample';
			this.args[0]=this.command;
		}
		else if(this.command=='@1'||this.command=='@p'){
			this.kind= 'editproduct';
		}
		else if(this.command=='@2'||this.command=='@c'){
			this.kind= 'editclient';
		}
		else if(this.command=='@a'){
			this.kind= 'editagent';
		}
		else if(this.command=='+f'){
			this.kind="facture";
			for(var i=1;i<splited.length;i++)if(splited[i]!=""){
				this.args[i-1]=splited[i];
				this.argssize++;
			}
		}
		else if(this.command=='@r'){
			this.kind="getinvoice";
			for(var i=1;i<splited.length;i++)if(splited[i]!=""){
				this.args[i-1]=splited[i];
				this.argssize++;
			}
		}
		else if(this.command=='+a'||this.command=='++'){
			this.kind="invoicepayment";
			for(var i=1;i<splited.length;i++)if(splited[i]!=""){
				this.args[i-1]=splited[i];
				this.argssize++;
			}
		}
		//TODO implement justprint
		else if(this.command=='@unimplemented'){
			this.kind="justprint";
			for(var i=1;i<splited.length;i++)if(splited[i]!=""){
				this.args[i-1]=splited[i];
				this.argssize++;
			}
		}
		else if(this.command=='@d'){
			this.kind="discount";
			for(var i=1;i<splited.length;i++)if(splited[i]!=""){
				this.args[i-1]=splited[i];
				this.argssize++;
			}
		}
		else if(this.command=='@s'){
			this.kind="searchinvoices";
			for(var i=1;i<splited.length;i++)if(splited[i]!=""){
				this.args[i-1]=splited[i];
				this.argssize++;
			}
			this.pargs=this.value.replace(/\./g,'').match(/[^\s"']+|"([^"]*)"|'([^']*)'/g);
			this.pargs.splice(0,1);
		}
		else if(this.command=='@j'){
			this.kind="consultthebox";
			alert('consultthebox');
			
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
			this.pargs=this.value.match(/[^\s"']+|"([^"]*)"|'([^']*)'/g);
			this.getFromDB=true;
		}

		

		return this;
	}

	$(function() {
		$("#client-accordion").accordion({
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
		$("#agent-accordion").accordion({
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

	/*$('#editproduct-6').keyup(function(event){
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
	});*/
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
				type:'POST',
				data: {
					client : encodeURIComponent($.toJSON(client)),
					token : TOKEN,
					clientReference: CLIENT_REFERENCE
				},
				success: function(data){
					//console.log(client.consummer +" creado");
					var id=data.id;
					for(var j=0;j<productsLog.length;j++){
						var jsonsrt="["+$.toJSON(productsLog[j])+"]";
						$.ajax({
							index : j,
							url: "getthis",
							type:'POST',
							data: {
								list:encodeURIComponent(jsonsrt),
								id:id,
								token : TOKEN,
		    					clientReference: CLIENT_REFERENCE
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
			$('#editclient').hide('slow');
			
		}
	});
	$('#editagent-9').keyup(function(event){
		if(event.keyCode==$.ui.keyCode.ENTER){
			var e0=$('#editagent-0').val();
			var e1=$('#editagent-1').val();
			var e2=$('#editagent-2').val();
			var e3=$('#editagent-3').val();
			var e4=$('#editagent-4').val();
			var e5=$('#editagent-5').val();
			var e6=$('#editagent-6').val();
			var e7=$('#editagent-7').val();
			var e8=$('#editagent-8').val();
			var e9=$('#editagent-9').val();
			var e10=$('#editagent-10').val();
			
			agent=new setAgent(e0?e0:'-1',e1?e1:'publico',e2?e2:'1',e3?e3:'.',e4?e4:'morelia','mexico',e5?e5:'michoacan','.',e6?e6:'.',e7?e7:'.',e8?e8:'.',e9?e9:'0',e10);

			$.ajax({
				url: 'welcome',
				type:'POST',
				data: {
					client : encodeURIComponent($.toJSON(agent)),
					agent:true,
					token : TOKEN,
					clientReference: CLIENT_REFERENCE
				}
			});
			$('#editagent').hide('slow');
		}
	});
	$('#editclient').hide();
	$('#editagent').hide();
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
				type:'POST',
				data: {
					client : encodeURIComponent($.toJSON(client)),
					token : TOKEN,
					clientReference: CLIENT_REFERENCE
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
							type:'POST',
							data: {
								list:encodeURIComponent(jsonsrt),
								id:id,
								token : TOKEN,
		    					clientReference: CLIENT_REFERENCE
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
					type:'POST',
					data: {
						list:encodeURIComponent(jsonsrt),
						id:id,
						consummerType:selectedValue,
						token : TOKEN,
    					clientReference: CLIENT_REFERENCE
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

	<button type="button" id="lockbutton">lock</button>
	<p class="g-total2">$0</p>
	<p class="g-area-to-print">0 -> 0 hojas</p>
	<div id="editproduct">
		<input id="editproduct-1" /><input id="editproduct-2"/><input id="editproduct-3"/><input id="editproduct-4"/><input id="editproduct-5"/><input id="editproduct-6"/>
	</div>
	<div id="editclient">
		<p>cliente</p>
		<input id="editclient-0"/><input id="editclient-1"/><input id="editclient-2"/><input id="editclient-3"/><input id="editclient-4"/><input id="editclient-5"/><input id="editclient-6"/><input id="editclient-7"/><input id="editclient-8"/><input id="editclient-10"/><input id="editclient-9"/>
	</div>
	<div id="editagent">
		<p>agente</p>
		<input id="editagent-0"/><input id="editagent-1"/><input id="editagent-2"/><input id="editagent-3"/><input id="editagent-4"/><input id="editagent-5"/><input id="editagent-6"/><input id="editagent-7"/><input id="editagent-8"/><input id="editagent-10"/><input id="editagent-9"/>
	</div>
</div>

<div id="client-accordion" style="height: auto;">
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
<div id="agent-accordion" style="height: auto;">
	<p><a href="#" id="agent" class="accordion-e"></a></p>
	<div>
	<div id="agent-address" class="accordion-e"></div>
	<div id="agent-city" class="accordion-e"></div>
	<div id="agent-state" class="accordion-e"></div>
	<div id="agent-cp" class="accordion-e"></div>
	<div id="agent-rfc" class="accordion-e"></div>
	<div id="agent-tel" class="accordion-e"></div>
	<div id="agent-email" class="accordion-e"></div>
	<div id="agent-country" class="accordion-e"></div>

	</div>
</div>

<div style="position: relative; width: 100%">
<div id="log" style="height: 500px; width: 100%; overflow: auto;" class="ui-widget-content"></div>

</div>
<div id="resultset" style="width: 100%;" class=""></div>
<div id="logResultset" style="width: 100%;" class=""></div>


<div id="login-form" title="Login">
    <form>
    <fieldset>
        <label for="name">login</label>
        <input type="text" name="login" id="login" class="text ui-widget-content ui-corner-all" />
        <label for="password">password</label>
        <input type="password"  id="password" value="" class="text ui-widget-content ui-corner-all" />
    </fieldset>
    </form>
</div>

<div id="lock-form" title="Locked">
    <form>
    <fieldset>
    	<label for="name"></label>
        <input type="text" name="logn" id="logn" class="text ui-widget-content ui-corner-all" style="visibility=hidden"/>
        <label for="unlockpassword">password</label>
        <input type="password"  id="unlockpassword" value="" class="text ui-widget-content ui-corner-all" />
    </fieldset>
    </form>
</div>

<div id="verify-form" title="admin password">
    <form>
    <fieldset>
    	<label for="name"></label>
        <input type="text" name="verify" id="verify-" class="text ui-widget-content ui-corner-all" style="visibility=hidden"/>
        <label for="verifypassword">password</label>
        <input type="password"  id="verifypassword" value="" class="text ui-widget-content ui-corner-all" />
    </fieldset>
    </form>
</div>

<div id="register-form" title="Locked">
    <form>
    <fieldset>
    	<label for="newUserName">nombre completo</label>
        <input type="text" name="newUserName" id="newUserName" class="text ui-widget-content ui-corner-all" style="visibility=hidden"/>
        <label for="newUserLogin">login</label>
        <input type="text" name="newUserLogin" id="newUserLogin" class="text ui-widget-content ui-corner-all" style="visibility=hidden"/>
        <label for="newUserPassword">password</label>
        <input type="password"  id="newUserPassword" value="" class="text ui-widget-content ui-corner-all" />
    	<label for="reNewUserPassword">re password</label>
        <input type="password"  id="reNewUserPassword" value="" class="text ui-widget-content ui-corner-all" />
    </fieldset>
    </form>
</div>


<div id="unauthorizedAlert" title="Acceso Denegado">
    <p>
        Escribe correctamente tu login y/o password
    </p>
</div>

</body>

</html>
