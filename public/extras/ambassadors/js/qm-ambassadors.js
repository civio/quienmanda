if("undefined"==typeof jQuery)throw new Error("Bootstrap's JavaScript requires jQuery");+function(t){"use strict";var e=t.fn.jquery.split(" ")[0].split(".");if(e[0]<2&&e[1]<9||1==e[0]&&9==e[1]&&e[2]<1||e[0]>2)throw new Error("Bootstrap's JavaScript requires jQuery version 1.9.1 or higher, but lower than version 3")}(jQuery),+function(t){"use strict";function e(e){return this.each(function(){var i=t(this),n=i.data("bs.tooltip"),s="object"==typeof e&&e;(n||!/destroy|hide/.test(e))&&(n||i.data("bs.tooltip",n=new o(this,s)),"string"==typeof e&&n[e]())})}var o=function(t,e){this.type=null,this.options=null,this.enabled=null,this.timeout=null,this.hoverState=null,this.$element=null,this.inState=null,this.init("tooltip",t,e)};o.VERSION="3.3.6",o.TRANSITION_DURATION=150,o.DEFAULTS={animation:!0,placement:"top",selector:!1,template:'<div class="tooltip" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>',trigger:"hover focus",title:"",delay:0,html:!1,container:!1,viewport:{selector:"body",padding:0}},o.prototype.init=function(e,o,i){if(this.enabled=!0,this.type=e,this.$element=t(o),this.options=this.getOptions(i),this.$viewport=this.options.viewport&&t(t.isFunction(this.options.viewport)?this.options.viewport.call(this,this.$element):this.options.viewport.selector||this.options.viewport),this.inState={click:!1,hover:!1,focus:!1},this.$element[0]instanceof document.constructor&&!this.options.selector)throw new Error("`selector` option must be specified when initializing "+this.type+" on the window.document object!");for(var n=this.options.trigger.split(" "),s=n.length;s--;){var r=n[s];if("click"==r)this.$element.on("click."+this.type,this.options.selector,t.proxy(this.toggle,this));else if("manual"!=r){var p="hover"==r?"mouseenter":"focusin",a="hover"==r?"mouseleave":"focusout";this.$element.on(p+"."+this.type,this.options.selector,t.proxy(this.enter,this)),this.$element.on(a+"."+this.type,this.options.selector,t.proxy(this.leave,this))}}this.options.selector?this._options=t.extend({},this.options,{trigger:"manual",selector:""}):this.fixTitle()},o.prototype.getDefaults=function(){return o.DEFAULTS},o.prototype.getOptions=function(e){return e=t.extend({},this.getDefaults(),this.$element.data(),e),e.delay&&"number"==typeof e.delay&&(e.delay={show:e.delay,hide:e.delay}),e},o.prototype.getDelegateOptions=function(){var e={},o=this.getDefaults();return this._options&&t.each(this._options,function(t,i){o[t]!=i&&(e[t]=i)}),e},o.prototype.enter=function(e){var o=e instanceof this.constructor?e:t(e.currentTarget).data("bs."+this.type);return o||(o=new this.constructor(e.currentTarget,this.getDelegateOptions()),t(e.currentTarget).data("bs."+this.type,o)),e instanceof t.Event&&(o.inState["focusin"==e.type?"focus":"hover"]=!0),o.tip().hasClass("in")||"in"==o.hoverState?void(o.hoverState="in"):(clearTimeout(o.timeout),o.hoverState="in",o.options.delay&&o.options.delay.show?void(o.timeout=setTimeout(function(){"in"==o.hoverState&&o.show()},o.options.delay.show)):o.show())},o.prototype.isInStateTrue=function(){for(var t in this.inState)if(this.inState[t])return!0;return!1},o.prototype.leave=function(e){var o=e instanceof this.constructor?e:t(e.currentTarget).data("bs."+this.type);return o||(o=new this.constructor(e.currentTarget,this.getDelegateOptions()),t(e.currentTarget).data("bs."+this.type,o)),e instanceof t.Event&&(o.inState["focusout"==e.type?"focus":"hover"]=!1),o.isInStateTrue()?void 0:(clearTimeout(o.timeout),o.hoverState="out",o.options.delay&&o.options.delay.hide?void(o.timeout=setTimeout(function(){"out"==o.hoverState&&o.hide()},o.options.delay.hide)):o.hide())},o.prototype.show=function(){var e=t.Event("show.bs."+this.type);if(this.hasContent()&&this.enabled){this.$element.trigger(e);var i=t.contains(this.$element[0].ownerDocument.documentElement,this.$element[0]);if(e.isDefaultPrevented()||!i)return;var n=this,s=this.tip(),r=this.getUID(this.type);this.setContent(),s.attr("id",r),this.$element.attr("aria-describedby",r),this.options.animation&&s.addClass("fade");var p="function"==typeof this.options.placement?this.options.placement.call(this,s[0],this.$element[0]):this.options.placement,a=/\s?auto?\s?/i,l=a.test(p);l&&(p=p.replace(a,"")||"top"),s.detach().css({top:0,left:0,display:"block"}).addClass(p).data("bs."+this.type,this),this.options.container?s.appendTo(this.options.container):s.insertAfter(this.$element),this.$element.trigger("inserted.bs."+this.type);var h=this.getPosition(),f=s[0].offsetWidth,c=s[0].offsetHeight;if(l){var u=p,d=this.getPosition(this.$viewport);p="bottom"==p&&h.bottom+c>d.bottom?"top":"top"==p&&h.top-c<d.top?"bottom":"right"==p&&h.right+f>d.width?"left":"left"==p&&h.left-f<d.left?"right":p,s.removeClass(u).addClass(p)}var v=this.getCalculatedOffset(p,h,f,c);this.applyPlacement(v,p);var g=function(){var t=n.hoverState;n.$element.trigger("shown.bs."+n.type),n.hoverState=null,"out"==t&&n.leave(n)};t.support.transition&&this.$tip.hasClass("fade")?s.one("bsTransitionEnd",g).emulateTransitionEnd(o.TRANSITION_DURATION):g()}},o.prototype.applyPlacement=function(e,o){var i=this.tip(),n=i[0].offsetWidth,s=i[0].offsetHeight,r=parseInt(i.css("margin-top"),10),p=parseInt(i.css("margin-left"),10);isNaN(r)&&(r=0),isNaN(p)&&(p=0),e.top+=r,e.left+=p,t.offset.setOffset(i[0],t.extend({using:function(t){i.css({top:Math.round(t.top),left:Math.round(t.left)})}},e),0),i.addClass("in");var a=i[0].offsetWidth,l=i[0].offsetHeight;"top"==o&&l!=s&&(e.top=e.top+s-l);var h=this.getViewportAdjustedDelta(o,e,a,l);h.left?e.left+=h.left:e.top+=h.top;var f=/top|bottom/.test(o),c=f?2*h.left-n+a:2*h.top-s+l,u=f?"offsetWidth":"offsetHeight";i.offset(e),this.replaceArrow(c,i[0][u],f)},o.prototype.replaceArrow=function(t,e,o){this.arrow().css(o?"left":"top",50*(1-t/e)+"%").css(o?"top":"left","")},o.prototype.setContent=function(){var t=this.tip(),e=this.getTitle();t.find(".tooltip-inner")[this.options.html?"html":"text"](e),t.removeClass("fade in top bottom left right")},o.prototype.hide=function(e){function i(){"in"!=n.hoverState&&s.detach(),n.$element.removeAttr("aria-describedby").trigger("hidden.bs."+n.type),e&&e()}var n=this,s=t(this.$tip),r=t.Event("hide.bs."+this.type);return this.$element.trigger(r),r.isDefaultPrevented()?void 0:(s.removeClass("in"),t.support.transition&&s.hasClass("fade")?s.one("bsTransitionEnd",i).emulateTransitionEnd(o.TRANSITION_DURATION):i(),this.hoverState=null,this)},o.prototype.fixTitle=function(){var t=this.$element;(t.attr("title")||"string"!=typeof t.attr("data-original-title"))&&t.attr("data-original-title",t.attr("title")||"").attr("title","")},o.prototype.hasContent=function(){return this.getTitle()},o.prototype.getPosition=function(e){e=e||this.$element;var o=e[0],i="BODY"==o.tagName,n=o.getBoundingClientRect();null==n.width&&(n=t.extend({},n,{width:n.right-n.left,height:n.bottom-n.top}));var s=i?{top:0,left:0}:e.offset(),r={scroll:i?document.documentElement.scrollTop||document.body.scrollTop:e.scrollTop()},p=i?{width:t(window).width(),height:t(window).height()}:null;return t.extend({},n,r,p,s)},o.prototype.getCalculatedOffset=function(t,e,o,i){return"bottom"==t?{top:e.top+e.height,left:e.left+e.width/2-o/2}:"top"==t?{top:e.top-i,left:e.left+e.width/2-o/2}:"left"==t?{top:e.top+e.height/2-i/2,left:e.left-o}:{top:e.top+e.height/2-i/2,left:e.left+e.width}},o.prototype.getViewportAdjustedDelta=function(t,e,o,i){var n={top:0,left:0};if(!this.$viewport)return n;var s=this.options.viewport&&this.options.viewport.padding||0,r=this.getPosition(this.$viewport);if(/right|left/.test(t)){var p=e.top-s-r.scroll,a=e.top+s-r.scroll+i;p<r.top?n.top=r.top-p:a>r.top+r.height&&(n.top=r.top+r.height-a)}else{var l=e.left-s,h=e.left+s+o;l<r.left?n.left=r.left-l:h>r.right&&(n.left=r.left+r.width-h)}return n},o.prototype.getTitle=function(){var t,e=this.$element,o=this.options;return t=e.attr("data-original-title")||("function"==typeof o.title?o.title.call(e[0]):o.title)},o.prototype.getUID=function(t){do t+=~~(1e6*Math.random());while(document.getElementById(t));return t},o.prototype.tip=function(){if(!this.$tip&&(this.$tip=t(this.options.template),1!=this.$tip.length))throw new Error(this.type+" `template` option must consist of exactly 1 top-level element!");return this.$tip},o.prototype.arrow=function(){return this.$arrow=this.$arrow||this.tip().find(".tooltip-arrow")},o.prototype.enable=function(){this.enabled=!0},o.prototype.disable=function(){this.enabled=!1},o.prototype.toggleEnabled=function(){this.enabled=!this.enabled},o.prototype.toggle=function(e){var o=this;e&&(o=t(e.currentTarget).data("bs."+this.type),o||(o=new this.constructor(e.currentTarget,this.getDelegateOptions()),t(e.currentTarget).data("bs."+this.type,o))),e?(o.inState.click=!o.inState.click,o.isInStateTrue()?o.enter(o):o.leave(o)):o.tip().hasClass("in")?o.leave(o):o.enter(o)},o.prototype.destroy=function(){var t=this;clearTimeout(this.timeout),this.hide(function(){t.$element.off("."+t.type).removeData("bs."+t.type),t.$tip&&t.$tip.detach(),t.$tip=null,t.$arrow=null,t.$viewport=null})};var i=t.fn.tooltip;t.fn.tooltip=e,t.fn.tooltip.Constructor=o,t.fn.tooltip.noConflict=function(){return t.fn.tooltip=i,this}}(jQuery),+function(t){"use strict";function e(e){return this.each(function(){var i=t(this),n=i.data("bs.popover"),s="object"==typeof e&&e;(n||!/destroy|hide/.test(e))&&(n||i.data("bs.popover",n=new o(this,s)),"string"==typeof e&&n[e]())})}var o=function(t,e){this.init("popover",t,e)};if(!t.fn.tooltip)throw new Error("Popover requires tooltip.js");o.VERSION="3.3.6",o.DEFAULTS=t.extend({},t.fn.tooltip.Constructor.DEFAULTS,{placement:"right",trigger:"click",content:"",template:'<div class="popover" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>'}),o.prototype=t.extend({},t.fn.tooltip.Constructor.prototype),o.prototype.constructor=o,o.prototype.getDefaults=function(){return o.DEFAULTS},o.prototype.setContent=function(){var t=this.tip(),e=this.getTitle(),o=this.getContent();t.find(".popover-title")[this.options.html?"html":"text"](e),t.find(".popover-content").children().detach().end()[this.options.html?"string"==typeof o?"html":"append":"text"](o),t.removeClass("fade top bottom left right in"),t.find(".popover-title").html()||t.find(".popover-title").hide()},o.prototype.hasContent=function(){return this.getTitle()||this.getContent()},o.prototype.getContent=function(){var t=this.$element,e=this.options;return t.attr("data-content")||("function"==typeof e.content?e.content.call(t[0]):e.content)},o.prototype.arrow=function(){return this.$arrow=this.$arrow||this.tip().find(".arrow")};var i=t.fn.popover;t.fn.popover=e,t.fn.popover.Constructor=o,t.fn.popover.noConflict=function(){return t.fn.popover=i,this}}(jQuery);;jQuery(document).ready(function($) {
  var default_img, qm_data, setupVisualization;
  qm_data = [
    {
      name: 'Rajoy',
      label: 'pp',
      year: '(2011-Actualidad)',
      img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/31/icon_225px-Mariano_Rajoy__diciembre_de_2011_.jpg',
      description: 'Ha confiado en más de 170 personas para representar a España ante organismos internacionales o países extranjeros. Dos de sus exministros y uno de Aznar fueron premiados con embajadas en Washington, Londres y París.',
      items: [
        {
          name: "Pedro Morenés",
          short_name: 'Morenés',
          position: "Ministro de Defensa entre 2011 y 2016",
          year: '2017',
          countries: "Estados Unidos",
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/125/icon_ministro-Morenes.jpg',
          link: 'pedro-morenes'
        }, {
          name: "José Ignacio Wert",
          short_name: 'Wert',
          position: "Ministro de Educación entre 2011 y 2015",
          year: '2015',
          countries: "OCDE (París)",
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/128/icon_origin_9087107686.jpg',
          link: 'jose-ignacio-wert'
        }, {
          name: "Federico Trillo",
          short_name: 'Trillo',
          position: "Fue ministro de Defensa de Aznar",
          year: '2012-2017',
          countries: "Reino Unido",
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14072/icon_Captura_de_pantalla_2015-09-30_a_las_10.00.28.png',
          link: 'federico-trillo'
        }
      ]
    }, {
      name: 'Zapatero',
      label: 'psoe',
      year: '(2004-2011)',
      img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/30/icon_Zapatero_ceja_4.jpg',
      description: 'Es el presidente que más embajadores "políticos" ha nombrado. De los 248 embajadores con los que contó, 11 no pertenecían al servicio diplomático.',
      items: [
        {
          name: "Silvia Iranzo",
          short_name: 'Iranzo',
          position: "Secretaria de Estado de Comercio entre 2008 y 2010",
          year: '2010-2012',
          countries: "Bélgica",
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14409/icon_Captura_de_pantalla_2017-04-04_a_las_16.37.52.png',
          link: 'silvia-iranzo-gutierrez'
        }, {
          name: "Cristina Narbona",
          short_name: 'Narbona',
          position: "Ministra de Medio Ambiente entre 2004 y 2008",
          year: '2008-2011',
          countries: "OCDE (París)",
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/166/icon_Cristina_Narbona_300912.jpg_1232443110.jpg',
          link: 'cristina-narbona'
        }, {
          name: "Javier Sancho",
          short_name: "Sancho",
          position: "Director del gabinete de M.Á. Moratinos hasta 2008",
          year: '2008-2012',
          countries: "Organización de Estados Americanos",
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14411/icon_Captura_de_pantalla_2017-04-04_a_las_19.03.43.png',
          link: 'javier-sancho-velazquez'
        }, {
          name: "Joan Clos",
          short_name: "Clos",
          position: "Exministro de Industria y exalcalde de Barcelona",
          year: '2008-2010',
          countries: "Turquía y Azarbaiyán",
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/10424/icon_perfil.JPG',
          link: 'joan-clos'
        }, {
          name: "Miguel Ángel Cortizo",
          short_name: "Cortizo",
          position: "Diputado en el parlamento de Galicia entre 1990 y 2004",
          year: '2007-2011',
          countries: "Paraguay",
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14413/icon_Captura_de_pantalla_2017-04-04_a_las_19.25.15.png',
          link: 'miguel-angel-cortizo-nieto'
        }, {
          name: "María Jesús San Segundo",
          short_name: "San Segundo",
          position: "Ministra de Educación y Ciencia entre 2004 y 2006",
          year: '2006-2010',
          countries: "UNESCO (París)",
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14417/icon_Captura_de_pantalla_2017-04-06_a_las_11.18.15.png',
          link: 'maria-jesus-san-segundo-gomez-de-cadinanos'
        }, {
          name: "Rafael Estrella",
          short_name: "Estrella",
          position: "Diputado y senador del PSOE",
          year: '2006-2012',
          countries: "Argentina",
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/11897/icon_images.jpg',
          link: 'rafael-estrella'
        }, {
          name: "Francisco José Vázquez",
          short_name: "Vázquez",
          position: "Alcalde de A Coruña entre 1983 y 2006",
          year: '2006-2011',
          countries: "Santa Sede y en la Soberana y Militar Orden de Malta",
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14418/icon_Captura_de_pantalla_2017-04-06_a_las_11.54.11.png',
          link: 'francisco-jose-vazquez-vazquez'
        }, {
          name: "Luis Planas",
          short_name: "Planas",
          position: "Diputado del PSOE",
          year: '2004-2011',
          countries: "la Unión Europea y Marruecos",
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14419/icon_Captura_de_pantalla_2017-04-06_a_las_11.57.25.png',
          link: 'luis-planas-puchades'
        }, {
          name: "Fernando Ballestero",
          short_name: "Ballestero",
          position: "Fue asesor económico de J.L. Zapatero",
          year: '2004-2008',
          countries: "OCDE (París)",
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14420/icon_6544392a568a5035b1adf291fe609614b0da3d08.jpg',
          link: 'fernando-ballestero-diaz'
        }, {
          name: "Raúl Morodo",
          short_name: "Morodo",
          position: "Confundador del Partido Socialista Popular con Enrique Tierno Galván",
          year: '2004-2007',
          countries: "Venezuela, Trinidad y Tobago, Guyana y Surinam",
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png',
          link: 'raul-morodo-leoncio'
        }, {
          name: "Germán Bejarano",
          short_name: "Bejarano",
          position: "Técnico Comercial y Economista del Estado",
          year: '2004-2007',
          countries: "Malasia y Brunei",
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png',
          link: 'german-bejarano-garcia'
        }
      ]
    }, {
      name: 'Aznar',
      label: 'pp',
      year: '(1996-2004)',
      img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/4/icon_aznar.jpg',
      description: 'En sus dos legislaturas nombró a 182 embajadores, que se alternaron entre varias embajadas. Solo dos personas de las designadas no eran miembros del cuerpo diplomático.',
      items: [
        {
          name: "María Elena Pisonero",
          short_name: "Pisonero",
          position: "Secretaria de Estado de Comercio con el PP",
          year: '2000-2004',
          countries: "OCDE (París)",
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/9749/icon_Captura_de_pantalla_2017-04-06_a_las_12.14.23.png',
          link: 'elena-pisonero-ruiz'
        }, {
          name: "José Luis Feito",
          short_name: "Feito",
          position: "Técnico Comercial y Economista del Estado",
          year: '1996-2000',
          countries: "OCDE (París)",
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/6495/icon_2293-0291.jpg',
          link: 'jose-luis-feito-higueruela'
        }
      ]
    }, {
      name: 'González',
      label: 'psoe',
      year: '(1982-1996)',
      description: 'A lo largo de sus 14 años en el cargo nombró a 223 embajadores. De todos ellos, 10 no pertenecían a la carrera diplomática.',
      img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/3/icon_origin_2259454273.jpg',
      items: [
        {
          name: "Claudio Aranzadi",
          short_name: "Aranzadi",
          position: "Ministro de Industria entre 1988 y 1993",
          year: '1993-1996',
          countries: "OCDE (París)",
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/12975/icon_CE2.JPG',
          link: 'claudio-aranzadi'
        }, {
          name: "Alberto de Armas",
          short_name: "de Armas",
          position: "Exsenador del PSOE",
          year: '1990-1993',
          countries: "Venezuela, Guyana, Trinidad y Tobago y Surinam",
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14422/icon_S4138.gif',
          link: 'alberto-de-armas-garcia'
        }, {
          name: "Julián Santamaría",
          short_name: "Santamaría",
          position: "Exdirector del CIS",
          year: '1987-1990',
          countries: "Estados Unidos",
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png',
          link: 'julian-santamaria-ossorio'
        }, {
          name: "Fernando Álvarez de Miranda",
          short_name: "Á. de Miranda",
          position: "Presidente del Congreso (UCD)",
          year: '1986-1989',
          countries: "El Salvador",
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14424/icon_Captura_de_pantalla_2017-04-06_a_las_12.28.00.png',
          link: 'fernando-alvarez-de-miranda-torres'
        }, {
          name: "Raúl Morodo",
          short_name: "Morodo",
          position: "Confundador del Partido Socialista Popular con Enrique Tierno Galván",
          year: '1983-1985 y 1995-1999',
          countries: "UNESCO (París) y Portugal",
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png',
          link: 'raul-morodo-leoncio'
        }, {
          name: "Emilio Menéndez",
          short_name: "Menéndez",
          position: "Tras ser embajador fue eurodiputado del PSOE",
          year: '1983-1994',
          countries: "Jordania, Italia, San Marino y Albania",
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14426/icon_4348.jpg',
          link: 'emilio-menendez-del-valle'
        }, {
          name: "Eduardo Foncillas",
          short_name: "Foncillas",
          position: "Militante del PSP de Tierno Galván",
          year: '1983-1991',
          countries: "República Federal de Alemania",
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png',
          link: 'eduardo-foncillas-casaus'
        }, {
          name: "Jorge de Esteban",
          short_name: "de Esteban",
          position: "Catedrático de derecho constitucional",
          year: '1983-1987',
          countries: "Italia",
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14428/icon_Captura_de_pantalla_2017-04-06_a_las_12.34.46.png',
          link: 'jorge-de-esteban-alonso'
        }, {
          name: "Fernando Baeza",
          short_name: "Baeza",
          position: "Exsenador del PSOE",
          year: '1983-1987',
          countries: "el Consejo de Europa",
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14429/icon_S1013.gif',
          link: 'fernando-baeza-martos'
        }, {
          name: "Joan Reventós",
          short_name: "Reventós",
          position: "Fundador del PSC",
          year: '1983-1986',
          countries: "Francia",
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png',
          link: 'joan-raventos-carner'
        }
      ]
    }
  ];
  default_img = 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png';
  setupVisualization = function() {
    var $el, $item, $items, $term, item, popoverContent, term, _i, _j, _len, _len1, _ref;
    console.log('setupVisualization', qm_data);
    $el = $('#qm-ambassadors');
    for (_i = 0, _len = qm_data.length; _i < _len; _i++) {
      term = qm_data[_i];
      $term = $('<div class="qm-ambassador-term"></div>');
      $term.append('<div class="qm-ambassador-picture qm-ambassador-picture-term ' + term.label + '" style="background-image: url(' + term.img + '")"></div><h3>' + term.name + '<small>' + term.year + '</small></h3><p>' + term.description + '</p>');
      $items = $('<div class="qm-ambassadors-container"></div>');
      $items.append('<span class="qm-ambassadors-container-title">' + term.items.length + ' embajadores sin carrera diplomática</span>');
      _ref = term.items;
      for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
        item = _ref[_j];
        popoverContent = item.position + '.<br/>Embajador/a en ' + item.countries + ' (' + item.year + ')';
        $item = $('<div class="qm-ambassador"></div>');
        $item.append('<a href="http://quienmanda.es/people/' + item.link + '" title="' + item.name + '" role="button" data-toggle="popover" data-placement="top" data-content="' + popoverContent + '"><div class="qm-ambassador-picture ' + term.label + '" style="background-image: url(' + item.img + '")"></div><h4>' + item.short_name + '</h4></a>');
        $items.append($item);
      }
      $term.append($items);
      $el.append($term);
    }
    return $('.qm-ambassador a').popover({
      trigger: 'hover',
      html: true
    });
  };
  return setupVisualization();
});
