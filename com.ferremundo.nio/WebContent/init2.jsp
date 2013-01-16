<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="com.ferremundo.Product"%>
<%@page import="java.util.List"%>
<%@page import="com.ferremundo.ProductsStore"%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="js/jquery.sexytable-1.1.js"></script>
<script type="text/javascript" src="js/jquery.editable.js"></script>
<script type="text/javascript" src="js/jquery.caret.1.02.min.js"></script>
<script type="text/javascript" src="js/util.js"></script>
<link rel="stylesheet" type="text/css" href="css/layout.css" />

<script type="text/javascript">
$(document).ready(function(){

	var TAXING=1.17;
	$('.quantity').val('1').focus().select();
	$(document).click(function(){$('#searchcontent').hide();});
	$('.searcher').blur(function(){
		if(mouseOverSearchContent)return;
		$('#searchcontent').hide();
	});
	getimput=function(){
		return $('.searcher').val();
	};

	search=function(arg){
		$.ajax({
			type: "GET",
			url: "port?search="+url.encode(arg)+"&searchrequestid="+(++requestID),
			dataType: "xml",
			success: function(xml){getMenu(xml);}
		});
	};

	getMenu=function(xml){

		//requestID matches last request ? 
		if($(xml).find('req').attr('val')!=requestID)return;
		var pos=$('.searcher').offset();
		var top_=pos.top;
		var height_=$('.searcher').height();
		$('#searchcontent').empty().show().css({position:'absolute',top:top_+height_+4+'px',width:'100%','z-index':10})
		.sexytable({
			row:[
				{content:'cant',width:5},
				{content:'unidad',width:10},
				{content:'descripción',width:40},
				{content:'codigo',width:10},
				{content:'marca',width:10},
				{content:'$ unit',width:10},
				{content:'subt',width:5},
				{content:'total',width:10}
				],animate:0
		});

		
		products={e:[]};
		products.select=-1;
		products.request=$(xml).find('req').attr('val');
		$(xml).find('pr').each(function(){
			var quantity=$(".quantity").val();
			var key=$(this).attr('key');
			var unit=$(this).attr('unit');
			var code=$(this).attr('code');
			var mark=$(this).attr('mark');
			var description=$(this).text();
			var unitprice=$(this).attr('unitprice');
			var subtotal=quantity*unitprice;
			var total=subtotal*TAXING;

			products.e.unshift({
				quantity	:quantity,
				key			:key,
				unit		:unit,
				description	:description,
				code		:code,
				mark		:mark,
				unitprice	:unitprice
				});
			
			$('#searchcontent').sexytable({
				row:[
					{content:quantity,width:5},
					{content:unit,width:10},
					{content:description,width:40},
					{content:code,width:10},
					{content:mark,width:10},
					{content:unitprice,width:10},
					{content:subtotal.toFixed(2),width:5},
					{content:total.toFixed(2),width:10}
					]
				,addRow:true});
		});

		$('#searchcontent').children().hover(
			function(){
				$(this).addClass('hover');
				
				products.select=$('#searchcontent').children().index(this);

				highlightsearch();
			},function(){
				$(this).removeClass('hover');
		});
		// Clicking menu 
		$('#searchcontent').children().click(function(){
				products.select=$('#searchcontent').children().index(this);
				addRowTable(products.e[products.select]);
				$('#searchcontent').hide();
				$('.searcher').val('');
				$('.quantity').val('1').focus().select();
				wishing.unshift(products.e[products.select]);
				styleTable();
				calculate();
					
		}).hover(function() { mouseOverSearchContent = true; $(this).css({cursor:'pointer'}); },
		function() { mouseOverSearchContent = false; $(this).css({cursor:'default'});});
		
		$('#searchcontent').children(':odd').addClass('odd');
		$('#searchcontent').children(':even').addClass('even');
		highlightsearch();

	}
	//// END getMenu
	var mouseOverSearchContent=false;
	var products={e:[]};
	var requestID=0;
	var acceptedChars="abcdefghujklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ1234567890/#-.º'¡";
	var acceptedCodes="9,13,27,38,40,39,37,8,17,20,16,93,18,26,35,33,34,32,192,222,187";
	var wishing=[];

	// HANDLING SEARCHER KEYUP 
	$('.searcher').keyup(function(e){
		var code = (e.keyCode ? e.keyCode : e.which);
		var char_=String.fromCharCode(code);
		//alert(code);
		if(!(acceptedChars.indexOf(char_)>=0||acceptedCodes.indexOf(''+code)>=0))return;
		if(code==13){
			if(products.request!=requestID)return;
			if($('#searchcontent').is(":visible")){
				var addcard=false;
				if(products.e.length>0&&products.select>=0&&products.select<products.e.length){
					addRowTable(products.e[products.select]);
					addcard=true;
				}
				else{
					var input_=$('.searcher').val();
					var matchesinput=false;
					for(var i=0;i<products.e.length;i++)
						if(products.e[i].code==input_.toUpperCase()){
							matchesinput=true;
							products.select=i;
							addRowTable(products.e[products.select]);
							addcard=true;
							break;
						}
				}
				if(addcard){
					$('#searchcontent').hide();
					$('.searcher').val('');
					$('.quantity').val('1').focus().select();
					wishing.unshift(products.e[products.select]);
					styleTable();
					calculate();
				}
			}
			else $('#searchcontent').show();
		}
		else if(code==27){
			$('#searchcontent').hide();
		}
		else if(code==38){
			$('#searchcontent').show();
			if(products.select<=0)products.select=products.e.length-1;
			else products.select--;
			highlightsearch();
		}
		else if(code==40){
			$('#searchcontent').show();
			if(products.select>=products.e.length-1)products.select=0;
			else products.select++;
			highlightsearch();
		}
		// tab and left-right keys
		else if(code==9||code==39||code==37){}
		else if(code==32){
			$('#searchcontent').show();
		}
		//add row for edit unexisting product
		else if(code==192||code==222||code==187||code==110){
			$('#searchcontent').hide();
			quantity=$('.searcher').val('');
			$('.quantity').val('1').focus().select();
			wishing.unshift(products.e[products.select]);
			styleTable();
			calculate();
		}
		else {
			var tosearch=getimput();
			if(tosearch.replace(/\s/g, ""))	search(tosearch);
		}
	});

	///HIGHLIGHT the search content
	highlightsearch=function(){
		$('#searchcontent').children().removeClass('hover').eq(products.select).addClass('hover');
	};
	addRowTable=function(row){
		var subt=row.quantity*row.unitprice;
		var tot=row.quantity*row.unitprice*TAXING;
		addRowToTable(
				"<input class=\"_quantities\" value=\""+(row.unit=='PZA'?Math.round(row.quantity):row.quantity)+"\"/>",
				"<p class=\"_unit editable\">"+row.unit+"</p>",
				"<p class=\"_description editable\">"+row.description+"</p>",
				"<p class=\"_code editable\">"+row.code+"</p>",
				"<p class=\"_mark editable\">"+row.mark+"</p>",
				"<p class=\"_unitprice editable\">"+row.unitprice+"</p>",
				"<p class=\"_subt\">"+subt.toFixed(2)+"</p>",
				"<p class=\"_total\">"+tot.toFixed(2)+"</p>"
				);
	};
	addRowToTable=function(quantity,unit,description,code,mark,unitprice,subt,total){
		$('#table').sexytable({
			row:[
				{content:quantity,width:5},
				{content:unit,width:10},
				{content:description,width:40},
				{content:code,width:10},
				{content:mark,width:10},
				{content:unitprice,width:10},
				{content:subt?subt:unitprice*quantity,width:5},
				{content:total?total:unitprice*quantity*TAXING,width:10}
				],animate:500
			});
		$('.editable').editable();
		$('.editable').attr('tabindex','0');
	};
	addRowToTable('cant','unidad','descripción','codigo','marca','$ unit','subt','<p class=\"bigtotal\">total</p>');

	$('.quantity').keyup(function(e){
		var code = (e.keyCode ? e.keyCode : e.which);
		var char_=String.fromCharCode(code);
		if(code==13||code==39)$('.searcher').focus();
		var numStr=$('.quantity').val();
		var number_='';
		var impure=false;
		var dots=0;
		var decimals=0;
		for(var i=0;i<numStr.length;i++){
			if("1234567890.".indexOf(numStr.charAt(i))>=0){
				//alert(dots+" "+i+" "+numStr.charAt(i));
				if(dots==1)decimals++;
				if(numStr.charAt(i)=='.')dots++;
				if(dots<=1&&decimals<=2)number_+=numStr.charAt(i);
				else impure=true;
				if(decimals>2)impure=true;
			}
			else impure=true;
		}
		if(impure)$('.quantity').val(number_);

	});
	$('.quantity').blur(function(){$('.quantity').trigger('keyup');});

	styleTable=function(){
		$('#table').children().hover(function(){$(this).addClass('hover2');},function(){$(this).removeClass('hover2');})
		$('#table').children().removeClass('odd2 even2').unbind('mousedown');
		$('#table').children(':odd').addClass('odd2');
		$('#table').children(':even').addClass('even2');
		// Remove by middle mouse button click
		$('#table').children().mousedown(function(e){
			if(e.which==2){
				wishing.splice($('#table').children().index(this),1);
				$('#table').sexytable({'removeRow':true,'index':this}).sexytable({render:true});
				$('#table').children().removeClass('odd2 even2');
				$('#table').children(':odd').addClass('odd2');
				$('#table').children(':even').addClass('even2');
			}
		}).last().unbind('mousedown');
		$('._quantities').keyup(function(e){
			var code = (e.keyCode ? e.keyCode : e.which);
			var char_=String.fromCharCode(code);
			if(code==13||code==39)$('.searcher').focus();
			var numStr=$(this).val();
			var number_='';
			var impure=false;
			var dots=0;
			var decimals=0;
			for(var i=0;i<numStr.length;i++){
				if("1234567890.".indexOf(numStr.charAt(i))>=0){
					//alert(dots+" "+i+" "+numStr.charAt(i));
					if(dots==1)decimals++;
					if(numStr.charAt(i)=='.')dots++;
					if(dots<=1&&decimals<=2)number_+=numStr.charAt(i);
					else impure=true;
					if(decimals>2)impure=true;
				}
				else impure=true;
			}
			if(number_=='')number_=1;
			var index_=$('._quantities').index(this);
			wishing[index_].quantity=wishing[index_].unit=='PZA'?Math.round(parseFloat(number_)):parseFloat(number_);
			if(impure)$(this).val(wishing[index_].quantity);
			var unitprice=parseFloat($('._unitprice:eq('+index_+')').text());
			$('._subt:eq('+index_+')').text((wishing[index_].quantity*unitprice).toFixed(2));
			$('._total:eq('+index_+')').text((wishing[index_].quantity*unitprice*TAXING).toFixed(2));
			calculate();
		}).blur(function(){$(this).trigger('keyup');});
		
	};
	calculate=function(){
		var total=0;
		for(var i=0;i<wishing.length;i++){
			var q=$('._quantities:eq('+i+')').val();
			var pu=parseFloat($('._unitprice:eq('+i+')').text());
			total+=q*pu*TAXING;
		}
		$('.bigtotal').text("$ "+total.toFixed(2));
	}

	makeAWish=function(){
		$.ajax({
			type: 'POST',
			url: "wishing",
			data: {'xml':url.encode(wishingToXML())},
			success: function(xml){
				alert("succes");
			},
			dataType: "xml"
		});
	}

	
	wishingToXML=function(){
		var index_=0;
		$('#table').children().each(function(){
			if($(this).equals($('#table').children().last()))return;
			var code=$('._code',this).text();
			var unit=$('._unit',this).text();
			var mark=$('._mark',this).text();
			var unitprice=$('._unitprice',this).text();
			var description=$('._description',this).text();
			var quantities=$('._quantities',this).val();
			alert(code);
			wishing[index_].code=code;
			wishing[index_].unit=unit;
			wishing[index_].mark=mark;
			wishing[index_].unitprice=unitprice;
			wishing[index_].description=description;
			wishing[index_].quantities=parseFloat(quantities);
			index_++			
		});
		var xml="<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n<prs>\n";
		for(var i=wishing.length-1;i>=0;i--){
			xml+="<pr "+
			"key=\""+wishing[i].key+"\" "+
			"code=\""+wishing[i].code+"\" "+
			"unit=\""+wishing[i].unit+"\" "+
			"mark=\""+wishing[i].mark+"\" "+
			"unitprice=\""+wishing[i].unitprice+"\" "+
			"_quantities=\""+wishing[i].quantities+"\""+
			">"+wishing[i].description+"</pr>\n";
		}
		xml+="</prs>\n";
		return xml;
	}

	$('.wishing').click(function(){
		var answer=confirm("is correct?\n"+wishingToXML());
		if(answer)makeAWish();
	});

});
</script>

<title>Ferremundo - pedidos</title>
</head>
<body>
<input class="quantity" style="z-index: 1">
<input class="searcher" style="z-index: 1">
<input class="wishing" type="button" value="hacer pedido" style="z-index: 1">
<div id='searchcontent' style='position: relative'></div>
<div id='table' style='position: relative'></div>
</body>

</html>