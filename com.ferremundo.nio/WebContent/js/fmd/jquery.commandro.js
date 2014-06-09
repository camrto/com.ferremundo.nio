
(function ( $ ) {
    $.fn.commandro=function(options){
    	return this.each(function(){
    		var settings = $.extend(true,{
    	       	data:{},
            	render:function(data){
            		var inp=$(this.input);
        			var pos=inp.position();
        			var height=inp[0].offsetHeight;
        			this.renderTo.empty();
    				ret="";
            		for(var i=0;i<data.length;i++){
            			ret+="<div id='menu"+i+"'>";
               			ret+=data[i];
            			ret+="<br></div>";
            		}
            		ret==""?$(this.renderTo).empty():$(this.renderTo).empty().append(ret)
            		.css({'background-color':'#fff','border':'1px','border-style':'outset',
            			//**TODO fix this height thing 
            			top:pos.top+height,left:pos.left,
        				position:'absolute',width:'auto',padding: 0, margin: 0});
            		this.show();
            		this.moveTo(0);
            	},
            	command:function(event){
            		var val=$(this.input).val();
            		if(event.which==13){
            			this.fire['enter'](this.input,this.menu[this.selectedIndex]);
            			this.hidde();
            			$(this.renderTo).empty();
            			this.menu=[];
            			return;
            		}
            		else if(event.which==27||event.keyCode==27){
            			this.fire['escape']();
            			this.hidde();
            			this.moveTo(-1);
            			settings.inputValue=val;
            			return;
            		}
            		if(val==settings.inputValue)
            			return;
            		settings.inputValue=val;
            		if(val==""){
            			this.renderTo.empty();
            			this.hidde();
            			return;
            		}

    				
            		this.source[1](val);
            		
            		
            		
            	},
            	source:{
            		1:function(path){
                		var ret=new Array();
                		var data=settings.data[1];
                		for(var i=0;i<data.length;i++){
                			if(data[i].match(RegExp(path))){
           						ret.push([data[i]]);
                   			}
                		}
                		settings.handleData(ret);
            		}
            	},
            	input:null,
            	fire:{
            		enter:function(input,data){
            			ret="";
            			for(var i=0;i<data.length;i++)
            				ret+=data[i]+(i==data.length-1?"":" ");
            			$(input).val(ret);
            			settings.inputValue=ret;
            		}
            	},
            	menu:null,
            	handleData:function(ret){
            		this.menu=ret;
            		this.render(ret);
            	},
            	htmlMenuElements:function(){return $(this.renderTo).children();},
            	highlight:function(init,end){
					var els=this.htmlMenuElements();
            		els.eq(init).css('background-color','#fff');
            		els.eq(end).css('background-color','#bad0f7');
            	},
            	hidde:function(){this.renderTo.css('visibility','hidden');},
            	show:function(){this.renderTo.css('visibility','visible');},
            	selectedIndex:0,
            	moveTo:function(e){
            		var idx1=this.selectedIndex;
            		if(this._typeOf(e)=='number'){
            			this.selectedIndex=e;
            		}
            		else{
            			if(e.which==40){
                    		this.selectedIndex=
        						(this.selectedIndex+1)>=this.menu.length?
        								0:this.selectedIndex+1;
        				}
        				else if(e.which==38){
        					this.selectedIndex=
        						(this.selectedIndex-1)<0?
        								this.menu.length-1:
        									this.selectedIndex-1;
        				}
            		}
            		//console.log('gong from '+idx1+" to "+this.selectedIndex);
            		this.highlight(idx1,this.selectedIndex);
            	},
            	_typeOf:function(value) {
            	    var s = typeof value;
            	    if (s === 'object') {
            	        if (value) {
            	            if (value instanceof Array) {
            	                s = 'array';
            	            }
            	        } else {
            	            s = 'null';
            	        }
            	    }
            	    return s;
            	},
            	renderTo:$('<div></div>')
       				.appendTo('body')
       				.css({'visibility':'hidden'}),
       			_isDown:false
            }, options );

    		settings._repeat=function(condition,execute,i1,i2){
        		condition?(
        				execute()&
        				(settings._timeout=window.setTimeout(function(){settings._timer=window.setInterval(execute, i1);},i2))
        		):
        			window.clearTimeout(settings._timeout)&window.clearInterval(settings._timer)&(execute?execute():null);
	       	};
	       	//_isDown event.which==40||event.which==38 flag
	       	settings.input=this;
    		$(this).keydown(function(event){
        		if(event.which==40||event.which==38){
        			if(settings._isDown)return;
        			settings._isDown=true;
        			event.preventDefault();
        			//console.log('event.down');
        			settings.show();
        			settings._repeat(true,function(){
        				settings.moveTo(event);
        				//console.log('down');
        			},50,300);
        			return;
        		};
        	})
        	.keyup(function(event){
        		if(event.which==40||event.which==38){
        			settings._isDown=false;
        			event.preventDefault();
        			settings._repeat(false);
        			return;
        		}
        		
				settings.command(event);
        		
        	})
        	.blur(function(event){
        		settings._repeat(false,function(){
        			settings.hidde();
        		});
        	});
    	});
    };
}( jQuery ));