/* SiteCatalyst code version: H.23.4.
Copyright 1996-2010 Adobe, Inc. All Rights Reserved
More info available at http://www.omniture.com */
/* UPDATED August 6th, 2012  J.Wah*/

var s_account="nbcuivsites,nbcuglobal"

/* Tablet Config */
var url=String(window.location);
if (url.match('pressly.com')) {s_account="nbcuivtabletdev";} 
else if (url.match('tablet.ivillage.com')) {s_account="nbcuivtabletprod";} 

/* Mobile Config */
if (!typeof(iv_mobify_mobilesite)==='undefined' && iv_mobify_mobilesite==1) {s_account="nbcuivillagemobile"}

news_code_isLoaded = true;
var s_iv=s_gi(s_account,1)
/************************** CONFIG SECTION **************************/
/* You may add or alter any code config here. */
s_iv.charSet="ISO-8859-1"
/* Conversion Config */
s_iv.currencyCode="USD"
/* Link Tracking Config */
s_iv.trackDownloadLinks=true
s_iv.trackExternalLinks=true
s_iv.trackInlineStats=true
s_iv.linkDownloadFileTypes="exe,zip,wav,mp3,mov,mpg,avi,wmv,doc,pdf,xls"
s_iv.linkInternalFilters="javascript:,ivillage.com,204.12.94.41,greenisuniversal,ivillage.co.uk,astrology.com,dietanotherday.co.uk,momtourage.com,gardenweb.com,neversaydiet.com,webstakes.com,kalimocho.co.uk,healthylivingonline.com,healthvideo.com,healthology.com,petside.com,petside.co.uk,petsidelatino.com,travelskoot.com,ivillagecoupons.com,thepatientchannel.com,newborn.com,dinnertool.com,gardenbazaar.com,voices.gardenweb.com,babynamer.com,ca.astrology.shine.yahoo.net,pressly.com"
s_iv.linkLeaveQueryString=false
s_iv.linkTrackVars="eVar13"
s_iv.linkTrackEvents="None"


/* Plugin Config */

/* Channel Manager Config */
s_iv._channelParameter="SKY|sky>Paid Syndication|psyd>Newsletter|nlcid,enid>Social Media|sm>Partners|PAR>DST|DST";
s_iv._channelDomain="Social Media|facebook.com,twitter.com,t.co,hootsuite.com,tweetdeck.com,tumblr.com,pinterest.com>Referrers|stumbleupon.com>Paid Syndication|paid.outbrain.com,taboolasyndication.com";

s_iv.usePlugins=true
function s_iv_doPlugins(s_iv) {
	
	var url=String(window.location);
	if (url.match('ivillage.com') && !url.match('tablet.ivillage.com') && !url.match('pressly.com') &&
	typeof(iv_mobify_mobilesite)==='undefined') {s_iv.sa(s_account +",nbcuivprod");} 
	if (url.match('greenisuniversal')) {s_iv.sa(s_account +",nbcuivprod");} 
	if (url.match('ivillage.co.uk')) {s_iv.sa(s_account +",nbcuivuk");} 
	if (url.match('momtourage')) {s_iv.sa(s_account +",nbcuivmomtorage");} 
	if (url.match('astrology')) {s_iv.sa(s_account +",nbcuivastrology");} 
	
	if (url.match('gardenweb')) {s_iv.sa(s_account +",nbcuivgardenweb");} 
	if (url.match('nature.net')) {s_iv.sa(s_account +",nbcuivgardenweb");} 
	if (url.match('neversaydiet')) {s_iv.sa(s_account +",nbcuivneversaydiet");} 
	if (url.match('webstakes')) {s_iv.sa(s_account +",nbcuivwebstakes");} 
	if (url.match('dietanotherday')) {s_iv.sa(s_account +",nbcuivukdietanotherday");} 
	
	if (url.match('kalimocho')) {s_iv.sa(s_account +",nbcuivkalimocho");} 
	if (url.match('healthylivingonline')) {s_iv.sa(s_account +",nbcuivprod");} 
	if (url.match('healthvideo')) {s_iv.sa(s_account +",nbcuivhealthvideo");} 
	if (url.match('healthology')) {s_iv.sa(s_account +",nbcuivhealthology");} 
	if (url.match('petside.com')) {s_iv.sa(s_account +",nbcuivpetside");} 
	
	if (url.match('petside.co.uk')) {s_iv.sa(s_account +",nbcuivpetsideuk");} 
	if (url.match('petsidelatino')) {s_iv.sa(s_account +",nbcuivpetsidelatino");} 
	if (url.match('travelskoot')) {s_iv.sa(s_account +",nbcuivtravelskoot");} 
	if (url.match('ivillagecoupons')) {s_iv.sa(s_account +",nbcuivcoupon");} 
	if (url.match('thepatientchannel')) {s_iv.sa(s_account +",nbcuivpatientchannel");} 
	
	if (url.match('newborn')) {s_iv.sa(s_account +",nbcuivnewborn");} 
	if (url.match('dinnertool')) {s_iv.sa(s_account +",nbcuivdinnertool");} 
	if (url.match('yourtotalhealth.com')) {s_iv.sa(s_account +",nbcuivprod");} 
	if (url.match('babynamer.com')) {s_iv.sa(s_account +",nbcuivprod");} 
	if (url.match('ca.astrology.shine.yahoo.net')) {s_iv.sa("nbcuivastrologyyahooshine");} 
	
	s_iv.server=window.location.host.toLowerCase();
	s_iv.campaign=s_iv.getQueryParam('cid,__source',':');
	s_iv.campaign=s_iv.getValOnce(s_iv.campaign,'s_v0',0);
		
	var ev23=s_iv.getQueryParam('par');
	
	/* Channel Manager Plugin */
	s_iv.channelManager('cid,SKY,DST,VTY,PAR,_source,nlcid,sm,psyd,enid',':','s_iv_cm','','1','1');
	s_iv.eVar24=s_iv._campaignID;
	if (s_iv.eVar24 == 'n/a')
		s_iv.eVar24 = '';
	if (s_iv._channel=="Natural Search") {
		var searchDomain=s_iv._referringDomain.split(".");
		s_iv.eVar24='organic:';
		for(i=1;i<searchDomain.length;i++){
			s_iv.eVar24=s_iv.eVar24+searchDomain[i];
			if(i<searchDomain.length-1)
				s_iv.eVar24=s_iv.eVar24+".";
		}
	}
	else if (s_iv._channel=="Paid Syndication" || s_iv._channel=="Social Media") {
		s_iv.eVar24=s_iv._referringDomain;
	}
	s_iv.eVar25=s_iv._keywords;
	if (s_iv.eVar25 == 'n/a')
		s_iv.eVar25 = '';
	s_iv.eVar26=s_iv._channel;
	switch(s_iv.eVar26)
	{
		case 'Typed/Bookmarked':
			s_iv.eVar26='Direct to Site';
			s_iv.eVar27=s_iv.crossVisitParticipation(s_iv.eVar26,'s_iv_ev27','7','5','>','',1);
			break;
		case 'Other Natural Referrers':
			s_iv.eVar26='Referrers';
			s_iv.eVar27=s_iv.crossVisitParticipation(s_iv.eVar26,'s_iv_ev27','7','5','>','',1);
			break;
		default:
			s_iv.eVar27=s_iv.crossVisitParticipation(s_iv.eVar26,'s_iv_ev27','7','5','>','',1);
	} 
	if(s_iv.eVar24) {	s_iv.events=s_iv.apl(s_iv.events,'event11',',',2);	s_iv.ClickThroughCheck1="1"}
		if(!s_iv.eVar24)s_iv.ClickThroughCheck1="2";
		s_iv.ClickThroughCheck2=s_iv.getPreviousValue(s_iv.ClickThroughCheck1,'ctc2','');
	if(!s_iv.eVar24&&s_iv.ClickThroughCheck2=="1") s_iv.events=s_iv.apl(s_iv.events,'event12',',',2);
	s_iv.prop65=s_iv.eVar26;  // Copy channel to prop
	
	//Props	
	if(window.location.href.toLowerCase().indexOf("astrology.com") >= 0) {
		if (s_iv.prop6 == null || s_iv.prop6 == '') {
			s_iv.prop6=unescape(unescape(window.location.href)).split("?")[0].replace(/\d+/g, "");		
		}
	} else if(s_iv.prop6 != null || s_iv.prop6 != '') {s_iv.prop6 = unescape(unescape(window.location.href));}
	if (s_iv.prop6.match(';')) {var iv_c6=s_iv.prop6.split(';');s_iv.prop6=iv_c6[0];}


	if(s_iv.prop7){
		s_iv.prop7=s_iv.prop7.toLowerCase()
		s_iv.eVar6="D=c7";
		var t_search=s_iv.getValOnce(s_iv.eVar6,'s_v6',0)
		if(t_search) {s_iv.events=s_iv.apl(s_iv.events,"event5",",",2)}
	}
	s_iv.prop13=s_iv.getNewRepeat();
	s_iv.prop14='D=c3+":"+ch';			
	s_iv.prop16=s_iv.timeParting('-5');
	s_iv.prop21=s_iv.getQueryParam('nlcid');
	if (s_iv.prop20) {s_iv.prop22 = s_iv.channel +" | "+ s_iv.prop20;}

	if (typeof(s_iv.prop30) == 'undefined' || s_iv.prop30 == '') {
		someVar=document.getElementsByTagName("h1");
		for (var i = 0; i < someVar.length; i++) {if (someVar[i].className == "mbTitle") {s_iv.prop30 = someVar[i].innerHTML; break;}}
		if (typeof(s_iv.prop30) == 'undefined' || s_iv.prop30 == '') {s_iv.prop30 = document.title;}
	}
    
	//eVars
	s_iv.eVar5=s_iv.getQueryParam('vty');s_iv.eVar5=s_iv.getValOnce(s_iv.eVar5,'s_v5',0);
	if(s_iv.eVar13 == null || s_iv.eVar13 == '') {s_iv.eVar13 = s_iv.getQueryParam("ice");}
	if(s_iv.prop21) 	s_iv.eVar14="D=c21";
	s_iv.eVar15=s_iv.getQueryParam('ftr');if(s_iv.eVar15) s_iv.events=s_iv.apl(s_iv.events,"event10",",",2);
	if(s_iv.prop16)		s_iv.eVar16="D=c16";
	s_iv.eVar18 = s_iv.getQueryParam("sky");s_iv.eVar18=s_iv.getValOnce(s_iv.eVar18,'s_v18',0);			
	if(s_iv.pageName) 	s_iv.eVar19="D=pageName";
	s_iv.eVar20=s_iv.getQueryParam('dst');s_iv.eVar20=s_iv.getValOnce(s_iv.eVar20,'s_v20',0);
	if(s_iv.channel) 	s_iv.eVar22="D=ch";
	s_iv.eVar23=ev23;s_iv.eVar23=s_iv.getValOnce(s_iv.eVar23,'s_v23',0);
	
	if (typeof(is_iv_slideshow) == 'undefined') { is_iv_slideshow = false; }
		if (typeof(iv_slideshow_moved) == 'undefined') { iv_slideshow_moved = false; }
		if(is_iv_slideshow && iv_slideshow_moved){s_iv.eVar14 = "";s_iv.eVar24 = "";s_iv.eVar26 = "";}
		
	if(s_iv.prop27)		s_iv.eVar27="D=c27";
	if(s_iv.prop3)		s_iv.eVar28="D=c3";
	if(s_iv.prop14) 	s_iv.eVar29='D=c3+":"+ch';	;
	var ev30=s_iv.getQueryParam("sky");	s_iv.eVar33=s_iv.getAndPersistValue(ev30,'s_cp_persist',0);
	var ev34=s_iv.getQueryParam("intcmp").toLowerCase(); s_iv.eVar34=s_iv.getAndPersistValue(ev34,'temp_e_34',0);
	if(s_iv.prop39)		s_iv.eVar39="D=c39";
	if(s_iv.prop40)		s_iv.eVar40="D=c40";
	if(s_iv.prop41)		s_iv.eVar41="D=c41";
	if(s_iv.prop6)		s_iv.eVar43="D=c6";
	
	s_iv.eVar51 = s_iv.getAndPersistValue(s_iv.eVar24,'temp_e_24', 30);
    
    	if(s_iv.prop20 != null || s_iv.prop20 != '') s_iv.eVar52=s_iv.prop20;
	    if(s_iv.prop30 != null || s_iv.prop30 != '') s_iv.eVar53=s_iv.prop30;
	
	//Events
	s_iv.events=s_iv.apl(s_iv.events,"event6",",",2);
	if ((!document.referrer || document.referrer=="") && s_iv.events.match('event32')) {s_iv.events="event34,event6";}


	//Products	
	if (s_iv.events.match('event30') || s_iv.events.match('event31') || s_iv.events.match('event32')  || s_iv.events.match('event33') || s_iv.events.match('event34') || s_iv.events.match('event35') ){s_iv.products=s_iv.getAndPersistValue(s_iv.products,'s_prod', 300);}
	
	//Hier
	s_iv.hier1=set_h3();

}
s_iv.doPlugins=s_iv_doPlugins
/************************** PLUGINS SECTION *************************/
/* Function - read combined cookies v 0.3 */
if(!s_iv.__ccucr){s_iv.c_rr=s_iv.c_r;s_iv.__ccucr = true;s_iv.c_r=new Function("k","var s=this,d=new Date,v=s_iv.c_rr(k),c=s_iv.c_rr('s_pers'),i,m,e;if(v)return v;k=s_iv.ape(k);i=c.indexOf(' '+k+'=');c=i<0?s_iv.c_rr('s_sess'):"
+"c;i=c.indexOf(' '+k+'=');m=i<0?i:c.indexOf('|',i);e=i<0?i:c.indexOf(';',i);m=m>0?m:e;v=i<0?'':s_iv.epa(c.substring(i+2+k.length,m<0?c.length:m));if(m>0&&m!=e)if(parseInt(c.substring(m+1,e<0?c.length:e"
+"))<d.getTime()){d.setTime(d.getTime()-60000);s_iv.c_w(s_iv.epa(k),'',d);v='';}return v;");}

/* Function - write combined cookies v 0.3 */
if(!s_iv.__ccucw){s_iv.c_wr=s_iv.c_w;s_iv.__ccucw = true;s_iv.c_w=new Function("k","v","e","this.new2 = true;var s=this,d=new Date,ht=0,pn='s_pers',sn='s_sess',pc=0,sc=0,pv,sv,c,i,t;d.setTime(d.getTime()-60000);if("
+"s_iv.c_rr(k)) s_iv.c_wr(k,'',d);k=s_iv.ape(k);pv=s_iv.c_rr(pn);i=pv.indexOf(' '+k+'=');if(i>-1){pv=pv.substring(0,i)+pv.substring(pv.indexOf(';',i)+1);pc=1;}sv=s_iv.c_rr(sn);i=sv.indexOf(' '+k+'=');if(i>-1){sv=sv"
+".substring(0,i)+sv.substring(sv.indexOf(';',i)+1);sc=1;}d=new Date;if(e){if(e.getTime()>d.getTime()){pv+=' '+k+'='+s_iv.ape(v)+'|'+e.getTime()+';';pc=1;}}else{sv+=' '+k+'='+s_iv.ape(v)+';';sc=1;}if(sc) s"
+".c_wr(sn,sv,0);if(pc){t=pv;while(t&&t.indexOf(';')!=-1){var t1=parseInt(t.substring(t.indexOf('|')+1,t.indexOf(';')));t=t.substring(t.indexOf(';')+1);ht=ht<t1?t1:ht;}d.setTime(ht);s_iv.c_wr(pn,pv,d);}"
+"return v==s_iv.c_r(s_iv.epa(k));");}

/* Plugin: getNewRepeat 1.0 - Return whether user is new or repeat */
s_iv.getNewRepeat=new Function("var s=this,e=new Date(),cval,ct=e.getTime(),y=e.getYear();e.setTime(ct+30*24*60*60*1000);cval=s_iv.c_r('s_nr');if(cval.length==0){s_iv.c_w('s_nr',ct,e);return 'New';}if(cval.le"
+"ngth!=0&&ct-cval<30*60*1000){s_iv.c_w('s_nr',ct,e);return 'New';}if(cval<1123916400001){e.setTime(cval+30*24*60*60*1000);s_iv.c_w('s_nr',ct,e);return 'Repeat';}else return 'Repeat';");

/* Function - allTrafficSources v 1.1 */
s_iv.allTrafficSources=new Function("a","b","c","d","e","f","g","h","i","j","var s=this,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,T;A=s_iv.referrer?s_iv.referrer:document.referrer;j=j?j:'Typed/Bookmarked';if(!A)B=j"
+";C=A.indexOf('?')>-1?A.indexOf('?'):A.length;D=A.substring(0,C);F=s_iv.split(s_iv.linkInternalFilters,',');E=F.length-1;for(G=0;G<=E;G++){H=D.indexOf(F[G])==-1?'':A;if(H)I=H}J=A.indexOf('//')>-1?A.indexO"
+"f('//')+2:0;if(!I&&!B){f=f?f:'Paid Search';g=g?g:'Natural Search';h=h?h:'Paid Non-Search';i=i?i:'Referrers';J=A.indexOf('//')>-1?A.indexOf('//')+2:0;K=A.indexOf('/',J)>-1?A.indexOf('/',J):C;L=A.sub"
+"string(J,K);M=L;B=N=i;C='.google.|q>.yahoo.|p>.msn.|q>.live.|q>.ask.|q>.aol.|query>.myway.|searchfor>.netscape.|query>.altavista.|q>.lycos.|query>.bing.|q';C=c?C+'>'+c:C;D=s_iv.split(C,'>');E=D.length-1;for(G="
+"0;G<=E;G++){F=D[G];F=s_iv.split(F,'|');O=L.indexOf(F[0]);if(O>-1){P=s_iv.getQueryParam(F[1],'',A);if(P)Q=P}}}R=s_iv.getQueryParam(a);if(R){M=R;if(Q){B=N=f}else{B=N=h}}if(!R&&Q){M=b+L;B=N=g}if(Q)Q=Q.toLowerC"
+"ase();if(M){M=M.toLowerCase();M=s_iv.repl(M,'www.','')}T=Q+M;if(d){C=s_iv.split(d,'>');D=C.length;for(G=0;G<=D;G++){if(C[G]){E=s_iv.split(C[G],'|');F=s_iv.getQueryParam(E[1]);if(F)B=N"
+"=E[0]}}}if(e){C=s_iv.split(e,'>');D=C.length;for(G=0;G<=D;G++){if(C[G]){E=s_iv.split(C[G],'|');F=R.indexOf(E[1]);if(F==0)B=N=E[0]}}}if(T){s_iv.atsCampaign=T?M:'';s_iv.atsKeywords=T?Q:'';s_iv.atsChannel=T?N:''}B=s"
+".getValOnce(B,'cs',0);s_iv.atsChannelStack=B;");

/* Plugin: getPreviousValue_v1.0 - */
s_iv.getPreviousValue=new Function("v","c","el","var s=this,t=new Date,i,j,r='';t.setTime(t.getTime()+1800000);if(el){if(s_iv.events){i=s_iv.split(el,',');j=s_iv.split(s_iv.events,',');for(x in i){for(y in j){if(i["
+"x]==j[y]){if(s_iv.c_r(c)) r=s_iv.c_r(c);v?s_iv.c_w(c,v,t):s_iv.c_w(c,'no value',t);return r}}}}}else{if(s_iv.c_r(c)) r=s_iv.c_r(c);v?s_iv.c_w(c,v,t):s_iv.c_w(c,'no value',t);return r}");

/* Plugin: clickThruQuality -this is an alteration of the original */
s_iv.clickThruQuality=new Function("scp","tcth_ev","cp_ev","cff_ev","cf_th","if(i<=1){var ev=(s_iv.events?s_iv.events+',':'');if(scp){s_iv.events=ev+tcth_ev;if(s_iv.c_r('cf')){var tct=parseInt(s_iv.c_r('cf'))+1;s_iv.c_w("
+"'cf',tct,0);if(tct==cf_th&&cff_ev){s_iv.events=s_iv.events+','+cff_ev;};}else{s_iv.c_w('cf',1,0);}}else{if(s_iv.c_r('cf')>=1){s_iv.c_w('cf',0,0);s_iv.events=ev+cp_ev;}}i++;}");

/* Plugin: TimeParting -this is an alteration of the original */
s_iv.timeParting=new Function("z","var s=this,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r;d = new Date();a=d.getFullYear();if(a=='2009'){b='08';c='01'}if(a=='2010'){b='14';c='07'}if(a=='2011'){b='13';c='06'}if("
+"a=='2012'){b='11';c='04'}if(a=='2013'){b='10';c='03'}if(a=='2014'){b='09';c='02'}if(!b||!c){b='08';c='01'}b='03/'+b+'/'+a;c='11/'+c+'/'+a;e=new Date('1/1/2000');if(e.getDay()!=6||e.getMonth()!=0){r"
+"eturn'Data Not Available'}else{z=parseFloat(z);f=new Date(b);g=new Date(c);fl=g;h=new Date();if(h>f&&h<fl){z=z+1}else{z=z};i=h.getTime()+(h.getTimezoneOffset()*60000);tz=new Date(i + (3600000*z));j"
+"=['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];k=tz.getHours();l=tz.getMinutes();m=tz.getDay();n=j[m];o='AM';p='00';if(l>30){p='30'}if(k>=12){o='PM';k=k-12};if (k==0){k=1"
+"2};q=k+':'+p+o;r=n+' : '+q;r=r.toLowerCase();return r;};");

/* Plugin: getQueryParam 2.3 */
s_iv.getQueryParam=new Function("p","d","u","var s=this,v='',i,t;d=d?d:'';u=u?u:(s_iv.pageURL?s_iv.pageURL:s_iv.wd.location);if(u=='f')u=s_iv.gtfs().location;while(p){i=p.indexOf(',');i=i<0?p.length:i;t=s_iv.p_gpv(p.s"
+"ubstring(0,i),u+'');if(t){t=t.indexOf('#')>-1?t.substring(0,t.indexOf('#')):t;}if(t)v+=v?d+t:t;p=p.substring(i==p.length?i:i+1)}return v");s_iv.p_gpv=new Function("k","u","var s=this,v='',i=u.indexOf("
+"'?'),q;if(k&&i>-1){q=u.substring(i+1);v=s_iv.pt(q,'&','p_gvf',k)}return v");s_iv.p_gvf=new Function("t","k","if(t){var s=this,i=t.indexOf('='),p=i<0?t:t.substring(0,i),v=i<0?'True':t.substring(i+1);if(p."
+"toLowerCase()==k.toLowerCase())return s_iv.epa(v)}return ''");

/* Plugin: getValOnce 0.2 - get a value once per session or number of days */
s_iv.getValOnce=new Function("v","c","e","var s=this,k=s_iv.c_r(c),a=new Date;e=e?e:0;if(v){a.setTime(a.getTime()+e*86400000);s_iv.c_w(c,v,e?a:0);}return v==k?'':v");

/* Plugin Utility: Determine If A Particular Value Exists Within An Array */
s_iv.ia=new Function("ar","v","for(var i=0;i<ar.length;i++){if(ar[i]==v)return i}return -1");

/* Plugin Utility: Replace v1.0 */
s_iv.repl=new Function("x","o","n","var i=x.indexOf(o),l=n.length;while(x&&i>=0){x=x.substring(0,i)+n+x.substring(i+o.length);i=x.indexOf(o,i+l)}return x");

/* Plugin Utility: split v1.5 - split a string (JS 1.0 compatible) */
s_iv.split=new Function("l","d","var i,x=0,a=new Array;while(l){i=l.indexOf(d);i=i>-1?i:l.length;a[x++]=l.substring(0,i);l=l.substring(i+d.length);}return a");

/* Plugin Utility: apl v1.1 */
s_iv.apl=new Function("L","v","d","u","var s=this,m=0;if(!L)L='';if(u){var i,n,a=s_iv.split(L,d);for(i=0;i<a.length;i++){n=a[i];m=m||(u==1?(n==v):(n.toLowerCase()==v.toLowerCase()));}}if(!m)L=L?L+d+v:v;ret"
+"urn L");

/* Plugin Utility: s_iv.join: 1.0 - s_iv.join(v,p) */
s_iv.join = new Function("v","p","var s = this;var f,b,d,w;if(p){f=p.front?p.front:'';b=p.back?p.back:'';d=p.delim?p.delim:'';w=p.wrap?p.wrap:'';}var str='';for(var x=0;x<v.length;x++){if(typeof(v[x])=="
+"'object' )str+=s_iv.join( v[x],p);else str+=w+v[x]+w;if(x<v.length-1)str+=d;}return f+str+b;");

/*Plugin: getAndPersistValue 0.3 - get a value on every page */
s_iv.getAndPersistValue=new Function("v","c","e","var s=this,a=new Date;e=e?e:0;a.setTime(a.getTime()+e*86400000);if(v)s.c_w(c,v,e?a:0);return s.c_r(c);");


/*Plugin: Gigya */
var gigya_omniture_conf = { 
linkName: 'Gigya Action', 
eventMap : [ 
	{gigEvent:"login",omtrEvents:["event60"],mapVars:["eVar61=user.loginProvider", "eVar60=getAge()", "eVar60=getGender()", "eVar62=getiRank()"]}, 
	{gigEvent:"sendDone",omtrEvents:["event61"],mapVars:["eVar61=providers","products"]}, 
	{gigEvent:"commentSubmitted",omtrEvents:["event62"],mapVars:["eVar61=providerPostIDs","products"]},
	{gigEvent:"reactionClicked",omtrEvents:["event63"],mapVars:["eVar63=reaction.ID","products"]} 	
],
getAge:function(evt) {var a=evt.user['age']; if(typeof(a)=="number"&&a>0){return a;}return '?';},
getGender:function(evt) {var g=evt.user['gender'];if(typeof(g)=="string"&&g.length>0){return g;}return '?';},
getiRank:function(evt) {if(typeof(evt.user['iRank'])=="string"){var r = parseFloat(evt.user['iRank']).toFixed(0);if(r >= 0.0001) return r;} return '?';}
}

function set_h3() {
	h3 = new String(document.location.host + document.location.pathname);
	if(h3.charAt(h3.length-1)=="/") {
		var temp = new String();
		for(var i=0;i<h3.length-1;i++){
			temp += h3.charAt(i);
		}
	h3 = temp;
	}
	var intIndexOfMatch = h3.indexOf("/");
	while (intIndexOfMatch != -1) {
		h3 = h3.replace("/","|");
		intIndexOfMatch = h3.indexOf("/");
	}
	return h3;
}

/*
 * channelManager v2.55 - Tracking External Traffic
 */
s_iv.channelManager=new Function("a","b","c","d","e","f",""
+"var s=this,A,B,g,l,m,p,q,P,h,k,u,S,i,O,T,j,r,t,D,E,F,G,H,N,U,v=0,X,"
+"Y,W,n=new Date;n.setTime(n.getTime()+1800000);if(e){v=1;if(s.c_r(e)"
+")v=0;if(!s.c_w(e,1,n))s.c_w(e,1,0);if(!s.c_r(e))v=0;}g=s.referrer?s"
+".referrer:document.referrer;g=g.toLowerCase();if(!g)h=1;i=g.indexOf"
+"('?')>-1?g.indexOf('?'):g.length;j=g.substring(0,i);k=s.linkInterna"
+"lFilters.toLowerCase();k=s.split(k,',');for(m=0;m<k.length;m++){B=j"
+".indexOf(k[m])==-1?'':g;if(B)O=B;}if(!O&&!h){p=g;U=g.indexOf('//');"
+"q=U>-1?U+2:0;Y=g.indexOf('/',q);r=Y>-1?Y:i;u=t=g.substring(q,r).toL"
+"owerCase();P='Other Natural Referrers';S=s.seList+'>'+s._extraSearc"
+"hEngines;if(d==1){j=s.repl(j,'oogle','%');j=s.repl(j,'ahoo','^');g="
+"s.repl(g,'as_q','*');}A=s.split(S,'>');for(i=0;i<A.length;i++){D=A["
+"i];D=s.split(D,'|');E=s.split(D[0],',');for(G=0;G<E.length;G++){H=j"
+".indexOf(E[G]);if(H>-1){if(D[2])N=u=D[2];else N=t;if(d==1){N=s.repl"
+"(N,'#',' - ');g=s.repl(g,'*','as_q');N=s.repl(N,'^','ahoo');N=s.rep"
+"l(N,'%','oogle');}i=s.split(D[1],',');for(k=0;k<i.length;k++){l=s.g"
+"etQueryParam(i[k],'',g).toLowerCase();if(l)break;}}}}}if(!O||f!='1'"
+"){O=s.getQueryParam(a,b);if(O){u=O;if(N)P='Paid Search';else P='Unk"
+"nown Paid Channel';}if(!O&&N){u=N;P='Natural Search';}}if(h==1&&!O&"
+"&v==1)u=P=t=p='Typed/Bookmarked';g=s._channelDomain;if(g){k=s.split"
+"(g,'>');for(m=0;m<k.length;m++){q=s.split(k[m],'|');r=s.split(q[1],"
+"',');S=r.length;for(T=0;T<S;T++){Y=r[T].toLowerCase();i=j.indexOf(Y"
+");if(i>-1)P=q[0];}}}g=s._channelParameter;if(g){k=s.split(g,'>');fo"
+"r(m=0;m<k.length;m++){q=s.split(k[m],'|');r=s.split(q[1],',');S=r.l"
+"ength;for(T=0;T<S;T++){U=s.getQueryParam(r[T]);if(U)P=q[0];}}}g=s._"
+"channelPattern;if(g){k=s.split(g,'>');for(m=0;m<k.length;m++){q=s.s"
+"plit(k[m],'|');r=s.split(q[1],',');S=r.length;for(T=0;T<S;T++){Y=r["
+"T].toLowerCase();i=O.toLowerCase();H=i.indexOf(Y);if(H==0)P=q[0];}}"
+"}X=P+l+t;c=c?c:'c_m';if(c!='0')X=s.getValOnce(X,c,0);if(X){s._refer"
+"rer=p?p:'n/a';s._referringDomain=t?t:'n/a';s._partner=N?N:'n/a';s._"
+"campaignID=O?O:'n/a';s._campaign=u?u:'n/a';s._keywords=l?l:N?'Keywo"
+"rd Unavailable':'n/a';s._channel=P?P:'n/a';}");

/* Top 130 */
s_iv.seList="altavista.co|q,r|AltaVista>aol.co.uk,search.aol.co.uk|query"
+"|AOL - United Kingdom>search.aol.com,search.aol.ca|query,q|AOL.com "
+"Search>ask.com,ask.co.uk|ask,q|Ask Jeeves>www.baidu.com|wd|Baidu>da"
+"um.net,search.daum.net|q|Daum>google.co,googlesyndication.com|q,as_"
+"q|Google>google.com.ar|q,as_q|Google - Argentina>google.com.au|q,as"
+"_q|Google - Australia>google.at|q,as_q|Google - Austria>google.com."
+"bh|q,as_q|Google - Bahrain>google.com.bd|q,as_q|Google - Bangladesh"
+">google.be|q,as_q|Google - Belgium>google.com.bo|q,as_q|Google - Bo"
+"livia>google.ba|q,as_q|Google - Bosnia-Hercegovina>google.com.br|q,"
+"as_q|Google - Brasil>google.bg|q,as_q|Google - Bulgaria>google.ca|q"
+",as_q|Google - Canada>google.cl|q,as_q|Google - Chile>google.cn|q,a"
+"s_q|Google - China>google.com.co|q,as_q|Google - Colombia>google.co"
+".cr|q,as_q|Google - Costa Rica>google.hr|q,as_q|Google - Croatia>go"
+"ogle.cz|q,as_q|Google - Czech Republic>google.dk|q,as_q|Google - De"
+"nmark>google.com.do|q,as_q|Google - Dominican Republic>google.com.e"
+"c|q,as_q|Google - Ecuador>google.com.eg|q,as_q|Google - Egypt>googl"
+"e.com.sv|q,as_q|Google - El Salvador>google.ee|q,as_q|Google - Esto"
+"nia>google.fi|q,as_q|Google - Finland>google.fr|q,as_q|Google - Fra"
+"nce>google.de|q,as_q|Google - Germany>google.gr|q,as_q|Google - Gre"
+"ece>google.com.gt|q,as_q|Google - Guatemala>google.hn|q,as_q|Google"
+" - Honduras>google.com.hk|q,as_q|Google - Hong Kong>google.hu|q,as_"
+"q|Google - Hungary>google.co.in|q,as_q|Google - India>google.co.id|"
+"q,as_q|Google - Indonesia>google.ie|q,as_q|Google - Ireland>google."
+"is|q,as_q|Google - Island>google.co.il|q,as_q|Google - Israel>googl"
+"e.it|q,as_q|Google - Italy>google.com.jm|q,as_q|Google - Jamaica>go"
+"ogle.co.jp|q,as_q|Google - Japan>google.jo|q,as_q|Google - Jordan>g"
+"oogle.co.ke|q,as_q|Google - Kenya>google.co.kr|q,as_q|Google - Kore"
+"a>google.lv|q,as_q|Google - Latvia>google.lt|q,as_q|Google - Lithua"
+"nia>google.com.my|q,as_q|Google - Malaysia>google.com.mt|q,as_q|Goo"
+"gle - Malta>google.mu|q,as_q|Google - Mauritius>google.com.mx|q,as_"
+"q|Google - Mexico>google.co.ma|q,as_q|Google - Morocco>google.nl|q,"
+"as_q|Google - Netherlands>google.co.nz|q,as_q|Google - New Zealand>"
+"google.com.ni|q,as_q|Google - Nicaragua>google.com.ng|q,as_q|Google"
+" - Nigeria>google.no|q,as_q|Google - Norway>google.com.pk|q,as_q|Go"
+"ogle - Pakistan>google.com.py|q,as_q|Google - Paraguay>google.com.p"
+"e|q,as_q|Google - Peru>google.com.ph|q,as_q|Google - Philippines>go"
+"ogle.pl|q,as_q|Google - Poland>google.pt|q,as_q|Google - Portugal>g"
+"oogle.com.pr|q,as_q|Google - Puerto Rico>google.com.qa|q,as_q|Googl"
+"e - Qatar>google.ro|q,as_q|Google - Romania>google.ru|q,as_q|Google"
+" - Russia>google.st|q,as_q|Google - Sao Tome and Principe>google.co"
+"m.sa|q,as_q|Google - Saudi Arabia>google.com.sg|q,as_q|Google - Sin"
+"gapore>google.sk|q,as_q|Google - Slovakia>google.si|q,as_q|Google -"
+" Slovenia>google.co.za|q,as_q|Google - South Africa>google.es|q,as_"
+"q|Google - Spain>google.lk|q,as_q|Google - Sri Lanka>google.se|q,as"
+"_q|Google - Sweden>google.ch|q,as_q|Google - Switzerland>google.com"
+".tw|q,as_q|Google - Taiwan>google.co.th|q,as_q|Google - Thailand>go"
+"ogle.bs|q,as_q|Google - The Bahamas>google.tt|q,as_q|Google - Trini"
+"dad and Tobago>google.com.tr|q,as_q|Google - Turkey>google.com.ua|q"
+",as_q|Google - Ukraine>google.ae|q,as_q|Google - United Arab Emirat"
+"es>google.co.uk|q,as_q|Google - United Kingdom>google.com.uy|q,as_q"
+"|Google - Uruguay>google.co.ve|q,as_q|Google - Venezuela>google.com"
+".vn|q,as_q|Google - Viet Nam>google.co.vi|q,as_q|Google - Virgin Is"
+"lands>icqit.com|q|icq>bing.com|q|Microsoft Bing>myway.com|searchfor"
+"|MyWay.com>naver.com,search.naver.com|query|Naver>netscape.com|quer"
+"y,search|Netscape Search>reference.com|q|Reference.com>seznam|w|Sez"
+"nam.cz>abcsok.no|q|Startsiden>tiscali.it|key|Tiscali>virgilio.it|qs"
+"|Virgilio>yahoo.com,search.yahoo.com|p|Yahoo!>ar.yahoo.com,ar.searc"
+"h.yahoo.com|p|Yahoo! - Argentina>au.yahoo.com,au.search.yahoo.com|p"
+"|Yahoo! - Australia>ca.yahoo.com,ca.search.yahoo.com|p|Yahoo! - Can"
+"ada>fr.yahoo.com,fr.search.yahoo.com|p|Yahoo! - France>de.yahoo.com"
+",de.search.yahoo.com|p|Yahoo! - Germany>hk.yahoo.com,hk.search.yaho"
+"o.com|p|Yahoo! - Hong Kong>in.yahoo.com,in.search.yahoo.com|p|Yahoo"
+"! - India>yahoo.co.jp,search.yahoo.co.jp|p,va|Yahoo! - Japan>kr.yah"
+"oo.com,kr.search.yahoo.com|p|Yahoo! - Korea>mx.yahoo.com,mx.search."
+"yahoo.com|p|Yahoo! - Mexico>ph.yahoo.com,ph.search.yahoo.com|p|Yaho"
+"o! - Philippines>sg.yahoo.com,sg.search.yahoo.com|p|Yahoo! - Singap"
+"ore>es.yahoo.com,es.search.yahoo.com|p|Yahoo! - Spain>telemundo.yah"
+"oo.com,espanol.search.yahoo.com|p|Yahoo! - Spanish (US : Telemundo)"
+">tw.yahoo.com,tw.search.yahoo.com|p|Yahoo! - Taiwan>uk.yahoo.com,uk"
+".search.yahoo.com|p|Yahoo! - UK and Ireland>yandex|text|Yandex.ru>s"
+"earch.cnn.com|query|CNN Web Search>search.earthlink.net|q|Earthlink"
+" Search>search.comcast.net|q|Comcast Search>search.rr.com|qs|RoadRu"
+"nner Search>optimum.net|q|Optimum Search";

/*
 *	Plug-in: crossVisitParticipation v1.7 - stacks values from
 *	specified variable in cookie and returns value
 */

s_iv.crossVisitParticipation=new Function("v","cn","ex","ct","dl","ev","dv",""
+"var s=this,ce;if(typeof(dv)==='undefined')dv=0;if(s.events&&ev){var"
+" ay=s.split(ev,',');var ea=s.split(s.events,',');for(var u=0;u<ay.l"
+"ength;u++){for(var x=0;x<ea.length;x++){if(ay[u]==ea[x]){ce=1;}}}}i"
+"f(!v||v==''){if(ce){s.c_w(cn,'');return'';}else return'';}v=escape("
+"v);var arry=new Array(),a=new Array(),c=s.c_r(cn),g=0,h=new Array()"
+";if(c&&c!=''){arry=s.split(c,'],[');for(q=0;q<arry.length;q++){z=ar"
+"ry[q];z=s.repl(z,'[','');z=s.repl(z,']','');z=s.repl(z,\"'\",'');arry"
+"[q]=s.split(z,',')}}var e=new Date();e.setFullYear(e.getFullYear()+"
+"5);if(dv==0&&arry.length>0&&arry[arry.length-1][0]==v)arry[arry.len"
+"gth-1]=[v,new Date().getTime()];else arry[arry.length]=[v,new Date("
+").getTime()];var start=arry.length-ct<0?0:arry.length-ct;var td=new"
+" Date();for(var x=start;x<arry.length;x++){var diff=Math.round((td."
+"getTime()-arry[x][1])/86400000);if(diff<ex){h[g]=unescape(arry[x][0"
+"]);a[g]=[arry[x][0],arry[x][1]];g++;}}var data=s.join(a,{delim:',',"
+"front:'[',back:']',wrap:\"'\"});s.c_w(cn,data,e);var r=s.join(h,{deli"
+"m:dl});if(ce)s.c_w(cn,'');return r;");

/* WARNING: Changing any of the below variables will cause drastic
changes to how your visitor data is collected.  Changes should only be
made when instructed to do so by your account manager.*/
s_iv.visitorNamespace="nbcuniversal"
s_iv.trackingServer="oimg.nbcuni.com"
s_iv.trackingServerSecure="osimg.nbcuni.com"




/************* DO NOT ALTER ANYTHING BELOW THIS LINE ! **************/
var s_code='',s_objectID;function s_gi(un,pg,ss){var c="s.version='H.23.4';s.an=s_an;s.logDebug=function(m){var s=this,tcf=new Function('var e;try{console.log(\"'+s.rep(s.rep(m,\"\\n\",\"\\\\n\"),\""
+"\\\"\",\"\\\\\\\"\")+'\");}catch(e){}');tcf()};s.cls=function(x,c){var i,y='';if(!c)c=this.an;for(i=0;i<x.length;i++){n=x.substring(i,i+1);if(c.indexOf(n)>=0)y+=n}return y};s.fl=function(x,l){retur"
+"n x?(''+x).substring(0,l):x};s.co=function(o){if(!o)return o;var n=new Object,x;for(x in o)if(x.indexOf('select')<0&&x.indexOf('filter')<0)n[x]=o[x];return n};s.num=function(x){x=''+x;for(var p=0;p"
+"<x.length;p++)if(('0123456789').indexOf(x.substring(p,p+1))<0)return 0;return 1};s.rep=s_rep;s.sp=s_sp;s.jn=s_jn;s.ape=function(x){var s=this,h='0123456789ABCDEF',i,c=s.charSet,n,l,e,y='';c=c?c.toU"
+"pperCase():'';if(x){x=''+x;if(s.em==3)x=encodeURIComponent(x);else if(c=='AUTO'&&('').charCodeAt){for(i=0;i<x.length;i++){c=x.substring(i,i+1);n=x.charCodeAt(i);if(n>127){l=0;e='';while(n||l<4){e=h"
+".substring(n%16,n%16+1)+e;n=(n-n%16)/16;l++}y+='%u'+e}else if(c=='+')y+='%2B';else y+=escape(c)}x=y}else x=escape(''+x);x=s.rep(x,'+','%2B');if(c&&c!='AUTO'&&s.em==1&&x.indexOf('%u')<0&&x.indexOf('"
+"%U')<0){i=x.indexOf('%');while(i>=0){i++;if(h.substring(8).indexOf(x.substring(i,i+1).toUpperCase())>=0)return x.substring(0,i)+'u00'+x.substring(i);i=x.indexOf('%',i)}}}return x};s.epa=function(x)"
+"{var s=this;if(x){x=s.rep(''+x,'+',' ');return s.em==3?decodeURIComponent(x):unescape(x)}return x};s.pt=function(x,d,f,a){var s=this,t=x,z=0,y,r;while(t){y=t.indexOf(d);y=y<0?t.length:y;t=t.substri"
+"ng(0,y);r=s[f](t,a);if(r)return r;z+=y+d.length;t=x.substring(z,x.length);t=z<x.length?t:''}return ''};s.isf=function(t,a){var c=a.indexOf(':');if(c>=0)a=a.substring(0,c);c=a.indexOf('=');if(c>=0)a"
+"=a.substring(0,c);if(t.substring(0,2)=='s_')t=t.substring(2);return (t!=''&&t==a)};s.fsf=function(t,a){var s=this;if(s.pt(a,',','isf',t))s.fsg+=(s.fsg!=''?',':'')+t;return 0};s.fs=function(x,f){var"
+" s=this;s.fsg='';s.pt(x,',','fsf',f);return s.fsg};s.si=function(){var s=this,i,k,v,c=s_gi+'var s=s_gi(\"'+s.oun+'\");s.sa(\"'+s.un+'\");';for(i=0;i<s.va_g.length;i++){k=s.va_g[i];v=s[k];if(v!=unde"
+"fined){if(typeof(v)!='number')c+='s.'+k+'=\"'+s_fe(v)+'\";';else c+='s.'+k+'='+v+';'}}c+=\"s.lnk=s.eo=s.linkName=s.linkType=s.wd.s_objectID=s.ppu=s.pe=s.pev1=s.pev2=s.pev3='';\";return c};s.c_d='';"
+"s.c_gdf=function(t,a){var s=this;if(!s.num(t))return 1;return 0};s.c_gd=function(){var s=this,d=s.wd.location.hostname,n=s.fpCookieDomainPeriods,p;if(!n)n=s.cookieDomainPeriods;if(d&&!s.c_d){n=n?pa"
+"rseInt(n):2;n=n>2?n:2;p=d.lastIndexOf('.');if(p>=0){while(p>=0&&n>1){p=d.lastIndexOf('.',p-1);n--}s.c_d=p>0&&s.pt(d,'.','c_gdf',0)?d.substring(p):d}}return s.c_d};s.c_r=function(k){var s=this;k=s.a"
+"pe(k);var c=' '+s.d.cookie,i=c.indexOf(' '+k+'='),e=i<0?i:c.indexOf(';',i),v=i<0?'':s.epa(c.substring(i+2+k.length,e<0?c.length:e));return v!='[[B]]'?v:''};s.c_w=function(k,v,e){var s=this,d=s.c_gd"
+"(),l=s.cookieLifetime,t;v=''+v;l=l?(''+l).toUpperCase():'';if(e&&l!='SESSION'&&l!='NONE'){t=(v!=''?parseInt(l?l:0):-60);if(t){e=new Date;e.setTime(e.getTime()+(t*1000))}}if(k&&l!='NONE'){s.d.cookie"
+"=k+'='+s.ape(v!=''?v:'[[B]]')+'; path=/;'+(e&&l!='SESSION'?' expires='+e.toGMTString()+';':'')+(d?' domain='+d+';':'');return s.c_r(k)==v}return 0};s.eh=function(o,e,r,f){var s=this,b='s_'+e+'_'+s."
+"_in,n=-1,l,i,x;if(!s.ehl)s.ehl=new Array;l=s.ehl;for(i=0;i<l.length&&n<0;i++){if(l[i].o==o&&l[i].e==e)n=i}if(n<0){n=i;l[n]=new Object}x=l[n];x.o=o;x.e=e;f=r?x.b:f;if(r||f){x.b=r?0:o[e];x.o[e]=f}if("
+"x.b){x.o[b]=x.b;return b}return 0};s.cet=function(f,a,t,o,b){var s=this,r,tcf;if(s.apv>=5&&(!s.isopera||s.apv>=7)){tcf=new Function('s','f','a','t','var e,r;try{r=s[f](a)}catch(e){r=s[t](e)}return "
+"r');r=tcf(s,f,a,t)}else{if(s.ismac&&s.u.indexOf('MSIE 4')>=0)r=s[b](a);else{s.eh(s.wd,'onerror',0,o);r=s[f](a);s.eh(s.wd,'onerror',1)}}return r};s.gtfset=function(e){var s=this;return s.tfs};s.gtfs"
+"oe=new Function('e','var s=s_c_il['+s._in+'],c;s.eh(window,\"onerror\",1);s.etfs=1;c=s.t();if(c)s.d.write(c);s.etfs=0;return true');s.gtfsfb=function(a){return window};s.gtfsf=function(w){var s=thi"
+"s,p=w.parent,l=w.location;s.tfs=w;if(p&&p.location!=l&&p.location.host==l.host){s.tfs=p;return s.gtfsf(s.tfs)}return s.tfs};s.gtfs=function(){var s=this;if(!s.tfs){s.tfs=s.wd;if(!s.etfs)s.tfs=s.cet"
+"('gtfsf',s.tfs,'gtfset',s.gtfsoe,'gtfsfb')}return s.tfs};s.mrq=function(u){var s=this,l=s.rl[u],n,r;s.rl[u]=0;if(l)for(n=0;n<l.length;n++){r=l[n];s.mr(0,0,r.r,r.t,r.u)}};s.flushBufferedRequests=fun"
+"ction(){};s.mr=function(sess,q,rs,ta,u){var s=this,dc=s.dc,t1=s.trackingServer,t2=s.trackingServerSecure,tb=s.trackingServerBase,p='.sc',ns=s.visitorNamespace,un=s.cls(u?u:(ns?ns:s.fun)),r=new Obje"
+"ct,l,imn='s_i_'+(un),im,b,e;if(!rs){if(t1){if(t2&&s.ssl)t1=t2}else{if(!tb)tb='2o7.net';if(dc)dc=(''+dc).toLowerCase();else dc='d1';if(tb=='2o7.net'){if(dc=='d1')dc='112';else if(dc=='d2')dc='122';p"
+"=''}t1=un+'.'+dc+'.'+p+tb}rs='http'+(s.ssl?'s':'')+'://'+t1+'/b/ss/'+s.un+'/'+(s.mobile?'5.1':'1')+'/'+s.version+'/'+sess+'?AQB=1&ndh=1'+(q?q:'')+'&AQE=1';if(s.isie&&!s.ismac)rs=s.fl(rs,2047)}if(s."
+"d.images&&s.apv>=3&&(!s.isopera||s.apv>=7)&&(s.ns6<0||s.apv>=6.1)){if(!s.rc)s.rc=new Object;if(!s.rc[un]){s.rc[un]=1;if(!s.rl)s.rl=new Object;s.rl[un]=new Array;setTimeout('if(window.s_c_il)window."
+"s_c_il['+s._in+'].mrq(\"'+un+'\")',750)}else{l=s.rl[un];if(l){r.t=ta;r.u=un;r.r=rs;l[l.length]=r;return ''}imn+='_'+s.rc[un];s.rc[un]++}im=s.wd[imn];if(!im)im=s.wd[imn]=new Image;im.s_l=0;im.onload"
+"=new Function('e','this.s_l=1;var wd=window,s;if(wd.s_c_il){s=wd.s_c_il['+s._in+'];s.mrq(\"'+un+'\");s.nrs--;if(!s.nrs)s.m_m(\"rr\")}');if(!s.nrs){s.nrs=1;s.m_m('rs')}else s.nrs++;if(s.debugTrackin"
+"g){var d='AppMeasurement Debug: '+rs,dl=s.sp(rs,'&'),dln;for(dln=0;dln<dl.length;dln++)d+=\"\\n\\t\"+s.epa(dl[dln]);s.logDebug(d)}im.src=rs;if((!ta||ta=='_self'||ta=='_top'||(s.wd.name&&ta==s.wd.na"
+"me))&&rs.indexOf('&pe=')>=0){b=e=new Date;while(!im.s_l&&e.getTime()-b.getTime()<500)e=new Date}return ''}return '<im'+'g sr'+'c=\"'+rs+'\" width=1 height=1 border=0 alt=\"\">'};s.gg=function(v){va"
+"r s=this;if(!s.wd['s_'+v])s.wd['s_'+v]='';return s.wd['s_'+v]};s.glf=function(t,a){if(t.substring(0,2)=='s_')t=t.substring(2);var s=this,v=s.gg(t);if(v)s[t]=v};s.gl=function(v){var s=this;if(s.pg)s"
+".pt(v,',','glf',0)};s.rf=function(x){var s=this,y,i,j,h,p,l=0,q,a,b='',c='',t;if(x&&x.length>255){y=''+x;i=y.indexOf('?');if(i>0){q=y.substring(i+1);y=y.substring(0,i);h=y.toLowerCase();j=0;if(h.su"
+"bstring(0,7)=='http://')j+=7;else if(h.substring(0,8)=='https://')j+=8;i=h.indexOf(\"/\",j);if(i>0){h=h.substring(j,i);p=y.substring(i);y=y.substring(0,i);if(h.indexOf('google')>=0)l=',q,ie,start,s"
+"earch_key,word,kw,cd,';else if(h.indexOf('yahoo.co')>=0)l=',p,ei,';if(l&&q){a=s.sp(q,'&');if(a&&a.length>1){for(j=0;j<a.length;j++){t=a[j];i=t.indexOf('=');if(i>0&&l.indexOf(','+t.substring(0,i)+',"
+"')>=0)b+=(b?'&':'')+t;else c+=(c?'&':'')+t}if(b&&c)q=b+'&'+c;else c=''}i=253-(q.length-c.length)-y.length;x=y+(i>0?p.substring(0,i):'')+'?'+q}}}}return x};s.s2q=function(k,v,vf,vfp,f){var s=this,qs"
+"='',sk,sv,sp,ss,nke,nk,nf,nfl=0,nfn,nfm;if(k==\"contextData\")k=\"c\";if(v){for(sk in v) {if((!f||sk.substring(0,f.length)==f)&&v[sk]&&(!vf||vf.indexOf(','+(vfp?vfp+'.':'')+sk+',')>=0)){nfm=0;if(nf"
+"l)for(nfn=0;nfn<nfl.length;nfn++)if(sk.substring(0,nfl[nfn].length)==nfl[nfn])nfm=1;if(!nfm){if(qs=='')qs+='&'+k+'.';sv=v[sk];if(f)sk=sk.substring(f.length);if(sk.length>0){nke=sk.indexOf('.');if(n"
+"ke>0){nk=sk.substring(0,nke);nf=(f?f:'')+nk+'.';if(!nfl)nfl=new Array;nfl[nfl.length]=nf;qs+=s.s2q(nk,v,vf,vfp,nf)}else{if(typeof(sv)=='boolean'){if(sv)sv='true';else sv='false'}if(sv){if(vfp=='ret"
+"rieveLightData'&&f.indexOf('.contextData.')<0){sp=sk.substring(0,4);ss=sk.substring(4);if(sk=='transactionID')sk='xact';else if(sk=='channel')sk='ch';else if(sk=='campaign')sk='v0';else if(s.num(ss"
+")){if(sp=='prop')sk='c'+ss;else if(sp=='eVar')sk='v'+ss;else if(sp=='list')sk='l'+ss;else if(sp=='hier'){sk='h'+ss;sv=sv.substring(0,255)}}}qs+='&'+s.ape(sk)+'='+s.ape(sv)}}}}}}if(qs!='')qs+='&.'+k"
+"}return qs};s.hav=function(){var s=this,qs='',l,fv='',fe='',mn,i,e;if(s.lightProfileID){l=s.va_m;fv=s.lightTrackVars;if(fv)fv=','+fv+','+s.vl_mr+','}else{l=s.va_t;if(s.pe||s.linkType){fv=s.linkTrac"
+"kVars;fe=s.linkTrackEvents;if(s.pe){mn=s.pe.substring(0,1).toUpperCase()+s.pe.substring(1);if(s[mn]){fv=s[mn].trackVars;fe=s[mn].trackEvents}}}if(fv)fv=','+fv+','+s.vl_l+','+s.vl_l2;if(fe){fe=','+f"
+"e+',';if(fv)fv+=',events,'}if (s.events2)e=(e?',':'')+s.events2}for(i=0;i<l.length;i++){var k=l[i],v=s[k],b=k.substring(0,4),x=k.substring(4),n=parseInt(x),q=k;if(!v)if(k=='events'&&e){v=e;e=''}if("
+"v&&(!fv||fv.indexOf(k)>=0)&&k!='linkName'&&k!='linkType'){if(k=='timestamp')q='ts';else if(k=='dynamicVariablePrefix')q='D';else if(k=='visitorID')q='vid';else if(k=='pageURL'){q='g';v=s.fl(v,255)}"
+"else if(k=='referrer'){q='r';v=s.fl(s.rf(v),255)}else if(k=='vmk'||k=='visitorMigrationKey')q='vmt';else if(k=='visitorMigrationServer'){q='vmf';if(s.ssl&&s.visitorMigrationServerSecure)v=''}else i"
+"f(k=='visitorMigrationServerSecure'){q='vmf';if(!s.ssl&&s.visitorMigrationServer)v=''}else if(k=='charSet'){q='ce';if(v.toUpperCase()=='AUTO')v='ISO8859-1';else if(s.em==2||s.em==3)v='UTF-8'}else i"
+"f(k=='visitorNamespace')q='ns';else if(k=='cookieDomainPeriods')q='cdp';else if(k=='cookieLifetime')q='cl';else if(k=='variableProvider')q='vvp';else if(k=='currencyCode')q='cc';else if(k=='channel"
+"')q='ch';else if(k=='transactionID')q='xact';else if(k=='campaign')q='v0';else if(k=='resolution')q='s';else if(k=='colorDepth')q='c';else if(k=='javascriptVersion')q='j';else if(k=='javaEnabled')q"
+"='v';else if(k=='cookiesEnabled')q='k';else if(k=='browserWidth')q='bw';else if(k=='browserHeight')q='bh';else if(k=='connectionType')q='ct';else if(k=='homepage')q='hp';else if(k=='plugins')q='p';"
+"else if(k=='events'){if(e)v+=(v?',':'')+e;if(fe)v=s.fs(v,fe)}else if(k=='events2')v='';else if(k=='contextData'){qs+=s.s2q('c',s[k],fv,k,0);v=''}else if(k=='lightProfileID')q='mtp';else if(k=='ligh"
+"tStoreForSeconds'){q='mtss';if(!s.lightProfileID)v=''}else if(k=='lightIncrementBy'){q='mti';if(!s.lightProfileID)v=''}else if(k=='retrieveLightProfiles')q='mtsr';else if(k=='deleteLightProfiles')q"
+"='mtsd';else if(k=='retrieveLightData'){if(s.retrieveLightProfiles)qs+=s.s2q('mts',s[k],fv,k,0);v=''}else if(s.num(x)){if(b=='prop')q='c'+n;else if(b=='eVar')q='v'+n;else if(b=='list')q='l'+n;else "
+"if(b=='hier'){q='h'+n;v=s.fl(v,255)}}if(v)qs+='&'+s.ape(q)+'='+(k.substring(0,3)!='pev'?s.ape(v):v)}}return qs};s.ltdf=function(t,h){t=t?t.toLowerCase():'';h=h?h.toLowerCase():'';var qi=h.indexOf('"
+"?');h=qi>=0?h.substring(0,qi):h;if(t&&h.substring(h.length-(t.length+1))=='.'+t)return 1;return 0};s.ltef=function(t,h){t=t?t.toLowerCase():'';h=h?h.toLowerCase():'';if(t&&h.indexOf(t)>=0)return 1;"
+"return 0};s.lt=function(h){var s=this,lft=s.linkDownloadFileTypes,lef=s.linkExternalFilters,lif=s.linkInternalFilters;lif=lif?lif:s.wd.location.hostname;h=h.toLowerCase();if(s.trackDownloadLinks&&l"
+"ft&&s.pt(lft,',','ltdf',h))return 'd';if(s.trackExternalLinks&&h.substring(0,1)!='#'&&(lef||lif)&&(!lef||s.pt(lef,',','ltef',h))&&(!lif||!s.pt(lif,',','ltef',h)))return 'e';return ''};s.lc=new Func"
+"tion('e','var s=s_c_il['+s._in+'],b=s.eh(this,\"onclick\");s.lnk=s.co(this);s.t();s.lnk=0;if(b)return this[b](e);return true');s.bc=new Function('e','var s=s_c_il['+s._in+'],f,tcf;if(s.d&&s.d.all&&"
+"s.d.all.cppXYctnr)return;s.eo=e.srcElement?e.srcElement:e.target;tcf=new Function(\"s\",\"var e;try{if(s.eo&&(s.eo.tagName||s.eo.parentElement||s.eo.parentNode))s.t()}catch(e){}\");tcf(s);s.eo=0');"
+"s.oh=function(o){var s=this,l=s.wd.location,h=o.href?o.href:'',i,j,k,p;i=h.indexOf(':');j=h.indexOf('?');k=h.indexOf('/');if(h&&(i<0||(j>=0&&i>j)||(k>=0&&i>k))){p=o.protocol&&o.protocol.length>1?o."
+"protocol:(l.protocol?l.protocol:'');i=l.pathname.lastIndexOf('/');h=(p?p+'//':'')+(o.host?o.host:(l.host?l.host:''))+(h.substring(0,1)!='/'?l.pathname.substring(0,i<0?0:i)+'/':'')+h}return h};s.ot="
+"function(o){var t=o.tagName;if(o.tagUrn||(o.scopeName&&o.scopeName.toUpperCase()!='HTML'))return '';t=t&&t.toUpperCase?t.toUpperCase():'';if(t=='SHAPE')t='';if(t){if((t=='INPUT'||t=='BUTTON')&&o.ty"
+"pe&&o.type.toUpperCase)t=o.type.toUpperCase();else if(!t&&o.href)t='A';}return t};s.oid=function(o){var s=this,t=s.ot(o),p,c,n='',x=0;if(t&&!o.s_oid){p=o.protocol;c=o.onclick;if(o.href&&(t=='A'||t="
+"='AREA')&&(!c||!p||p.toLowerCase().indexOf('javascript')<0))n=s.oh(o);else if(c){n=s.rep(s.rep(s.rep(s.rep(''+c,\"\\r\",''),\"\\n\",''),\"\\t\",''),' ','');x=2}else if(t=='INPUT'||t=='SUBMIT'){if(o"
+".value)n=o.value;else if(o.innerText)n=o.innerText;else if(o.textContent)n=o.textContent;x=3}else if(o.src&&t=='IMAGE')n=o.src;if(n){o.s_oid=s.fl(n,100);o.s_oidt=x}}return o.s_oid};s.rqf=function(t"
+",un){var s=this,e=t.indexOf('='),u=e>=0?t.substring(0,e):'',q=e>=0?s.epa(t.substring(e+1)):'';if(u&&q&&(','+u+',').indexOf(','+un+',')>=0){if(u!=s.un&&s.un.indexOf(',')>=0)q='&u='+u+q+'&u=0';return"
+" q}return ''};s.rq=function(un){if(!un)un=this.un;var s=this,c=un.indexOf(','),v=s.c_r('s_sq'),q='';if(c<0)return s.pt(v,'&','rqf',un);return s.pt(un,',','rq',0)};s.sqp=function(t,a){var s=this,e=t"
+".indexOf('='),q=e<0?'':s.epa(t.substring(e+1));s.sqq[q]='';if(e>=0)s.pt(t.substring(0,e),',','sqs',q);return 0};s.sqs=function(un,q){var s=this;s.squ[un]=q;return 0};s.sq=function(q){var s=this,k='"
+"s_sq',v=s.c_r(k),x,c=0;s.sqq=new Object;s.squ=new Object;s.sqq[q]='';s.pt(v,'&','sqp',0);s.pt(s.un,',','sqs',q);v='';for(x in s.squ)if(x&&(!Object||!Object.prototype||!Object.prototype[x]))s.sqq[s."
+"squ[x]]+=(s.sqq[s.squ[x]]?',':'')+x;for(x in s.sqq)if(x&&(!Object||!Object.prototype||!Object.prototype[x])&&s.sqq[x]&&(x==q||c<2)){v+=(v?'&':'')+s.sqq[x]+'='+s.ape(x);c++}return s.c_w(k,v,0)};s.wd"
+"l=new Function('e','var s=s_c_il['+s._in+'],r=true,b=s.eh(s.wd,\"onload\"),i,o,oc;if(b)r=this[b](e);for(i=0;i<s.d.links.length;i++){o=s.d.links[i];oc=o.onclick?\"\"+o.onclick:\"\";if((oc.indexOf(\""
+"s_gs(\")<0||oc.indexOf(\".s_oc(\")>=0)&&oc.indexOf(\".tl(\")<0)s.eh(o,\"onclick\",0,s.lc);}return r');s.wds=function(){var s=this;if(s.apv>3&&(!s.isie||!s.ismac||s.apv>=5)){if(s.b&&s.b.attachEvent)"
+"s.b.attachEvent('onclick',s.bc);else if(s.b&&s.b.addEventListener)s.b.addEventListener('click',s.bc,false);else s.eh(s.wd,'onload',0,s.wdl)}};s.vs=function(x){var s=this,v=s.visitorSampling,g=s.vis"
+"itorSamplingGroup,k='s_vsn_'+s.un+(g?'_'+g:''),n=s.c_r(k),e=new Date,y=e.getYear();e.setYear(y+10+(y<1900?1900:0));if(v){v*=100;if(!n){if(!s.c_w(k,x,e))return 0;n=x}if(n%10000>v)return 0}return 1};"
+"s.dyasmf=function(t,m){if(t&&m&&m.indexOf(t)>=0)return 1;return 0};s.dyasf=function(t,m){var s=this,i=t?t.indexOf('='):-1,n,x;if(i>=0&&m){var n=t.substring(0,i),x=t.substring(i+1);if(s.pt(x,',','dy"
+"asmf',m))return n}return 0};s.uns=function(){var s=this,x=s.dynamicAccountSelection,l=s.dynamicAccountList,m=s.dynamicAccountMatch,n,i;s.un=s.un.toLowerCase();if(x&&l){if(!m)m=s.wd.location.host;if"
+"(!m.toLowerCase)m=''+m;l=l.toLowerCase();m=m.toLowerCase();n=s.pt(l,';','dyasf',m);if(n)s.un=n}i=s.un.indexOf(',');s.fun=i<0?s.un:s.un.substring(0,i)};s.sa=function(un){var s=this;s.un=un;if(!s.oun"
+")s.oun=un;else if((','+s.oun+',').indexOf(','+un+',')<0)s.oun+=','+un;s.uns()};s.m_i=function(n,a){var s=this,m,f=n.substring(0,1),r,l,i;if(!s.m_l)s.m_l=new Object;if(!s.m_nl)s.m_nl=new Array;m=s.m"
+"_l[n];if(!a&&m&&m._e&&!m._i)s.m_a(n);if(!m){m=new Object,m._c='s_m';m._in=s.wd.s_c_in;m._il=s._il;m._il[m._in]=m;s.wd.s_c_in++;m.s=s;m._n=n;m._l=new Array('_c','_in','_il','_i','_e','_d','_dl','s',"
+"'n','_r','_g','_g1','_t','_t1','_x','_x1','_rs','_rr','_l');s.m_l[n]=m;s.m_nl[s.m_nl.length]=n}else if(m._r&&!m._m){r=m._r;r._m=m;l=m._l;for(i=0;i<l.length;i++)if(m[l[i]])r[l[i]]=m[l[i]];r._il[r._i"
+"n]=r;m=s.m_l[n]=r}if(f==f.toUpperCase())s[n]=m;return m};s.m_a=new Function('n','g','e','if(!g)g=\"m_\"+n;var s=s_c_il['+s._in+'],c=s[g+\"_c\"],m,x,f=0;if(!c)c=s.wd[\"s_\"+g+\"_c\"];if(c&&s_d)s[g]="
+"new Function(\"s\",s_ft(s_d(c)));x=s[g];if(!x)x=s.wd[\\'s_\\'+g];if(!x)x=s.wd[g];m=s.m_i(n,1);if(x&&(!m._i||g!=\"m_\"+n)){m._i=f=1;if((\"\"+x).indexOf(\"function\")>=0)x(s);else s.m_m(\"x\",n,x,e)}"
+"m=s.m_i(n,1);if(m._dl)m._dl=m._d=0;s.dlt();return f');s.m_m=function(t,n,d,e){t='_'+t;var s=this,i,x,m,f='_'+t,r=0,u;if(s.m_l&&s.m_nl)for(i=0;i<s.m_nl.length;i++){x=s.m_nl[i];if(!n||x==n){m=s.m_i(x"
+");u=m[t];if(u){if((''+u).indexOf('function')>=0){if(d&&e)u=m[t](d,e);else if(d)u=m[t](d);else u=m[t]()}}if(u)r=1;u=m[t+1];if(u&&!m[f]){if((''+u).indexOf('function')>=0){if(d&&e)u=m[t+1](d,e);else i"
+"f(d)u=m[t+1](d);else u=m[t+1]()}}m[f]=1;if(u)r=1}}return r};s.m_ll=function(){var s=this,g=s.m_dl,i,o;if(g)for(i=0;i<g.length;i++){o=g[i];if(o)s.loadModule(o.n,o.u,o.d,o.l,o.e,1);g[i]=0}};s.loadMod"
+"ule=function(n,u,d,l,e,ln){var s=this,m=0,i,g,o=0,f1,f2,c=s.h?s.h:s.b,b,tcf;if(n){i=n.indexOf(':');if(i>=0){g=n.substring(i+1);n=n.substring(0,i)}else g=\"m_\"+n;m=s.m_i(n)}if((l||(n&&!s.m_a(n,g)))"
+"&&u&&s.d&&c&&s.d.createElement){if(d){m._d=1;m._dl=1}if(ln){if(s.ssl)u=s.rep(u,'http:','https:');i='s_s:'+s._in+':'+n+':'+g;b='var s=s_c_il['+s._in+'],o=s.d.getElementById(\"'+i+'\");if(s&&o){if(!o"
+".l&&s.wd.'+g+'){o.l=1;if(o.i)clearTimeout(o.i);o.i=0;s.m_a(\"'+n+'\",\"'+g+'\"'+(e?',\"'+e+'\"':'')+')}';f2=b+'o.c++;if(!s.maxDelay)s.maxDelay=250;if(!o.l&&o.c<(s.maxDelay*2)/100)o.i=setTimeout(o.f"
+"2,100)}';f1=new Function('e',b+'}');tcf=new Function('s','c','i','u','f1','f2','var e,o=0;try{o=s.d.createElement(\"script\");if(o){o.type=\"text/javascript\";'+(n?'o.id=i;o.defer=true;o.onload=o.o"
+"nreadystatechange=f1;o.f2=f2;o.l=0;':'')+'o.src=u;c.appendChild(o);'+(n?'o.c=0;o.i=setTimeout(f2,100)':'')+'}}catch(e){o=0}return o');o=tcf(s,c,i,u,f1,f2)}else{o=new Object;o.n=n+':'+g;o.u=u;o.d=d;"
+"o.l=l;o.e=e;g=s.m_dl;if(!g)g=s.m_dl=new Array;i=0;while(i<g.length&&g[i])i++;g[i]=o}}else if(n){m=s.m_i(n);m._e=1}return m};s.voa=function(vo,r){var s=this,l=s.va_g,i,k,v,x;for(i=0;i<l.length;i++){"
+"k=l[i];v=vo[k];if(v||vo['!'+k]){if(!r&&(k==\"contextData\"||k==\"retrieveLightData\")&&s[k])for(x in s[k])if(!v[x])v[x]=s[k][x];s[k]=v}}};s.vob=function(vo){var s=this,l=s.va_g,i,k;for(i=0;i<l.leng"
+"th;i++){k=l[i];vo[k]=s[k];if(!vo[k])vo['!'+k]=1}};s.dlt=new Function('var s=s_c_il['+s._in+'],d=new Date,i,vo,f=0;if(s.dll)for(i=0;i<s.dll.length;i++){vo=s.dll[i];if(vo){if(!s.m_m(\"d\")||d.getTime"
+"()-vo._t>=s.maxDelay){s.dll[i]=0;s.t(vo)}else f=1}}if(s.dli)clearTimeout(s.dli);s.dli=0;if(f){if(!s.dli)s.dli=setTimeout(s.dlt,s.maxDelay)}else s.dll=0');s.dl=function(vo){var s=this,d=new Date;if("
+"!vo)vo=new Object;s.vob(vo);vo._t=d.getTime();if(!s.dll)s.dll=new Array;s.dll[s.dll.length]=vo;if(!s.maxDelay)s.maxDelay=250;s.dlt()};s.track=s.t=function(vo){var s=this,trk=1,tm=new Date,sed=Math&"
+"&Math.random?Math.floor(Math.random()*10000000000000):tm.getTime(),sess='s'+Math.floor(tm.getTime()/10800000)%10+sed,y=tm.getYear(),vt=tm.getDate()+'/'+tm.getMonth()+'/'+(y<1900?y+1900:y)+' '+tm.ge"
+"tHours()+':'+tm.getMinutes()+':'+tm.getSeconds()+' '+tm.getDay()+' '+tm.getTimezoneOffset(),tcf,tfs=s.gtfs(),ta=-1,q='',qs='',code='',vb=new Object;s.gl(s.vl_g);s.uns();s.m_ll();if(!s.td){var tl=tf"
+"s.location,a,o,i,x='',c='',v='',p='',bw='',bh='',j='1.0',k=s.c_w('s_cc','true',0)?'Y':'N',hp='',ct='',pn=0,ps;if(String&&String.prototype){j='1.1';if(j.match){j='1.2';if(tm.setUTCDate){j='1.3';if(s"
+".isie&&s.ismac&&s.apv>=5)j='1.4';if(pn.toPrecision){j='1.5';a=new Array;if(a.forEach){j='1.6';i=0;o=new Object;tcf=new Function('o','var e,i=0;try{i=new Iterator(o)}catch(e){}return i');i=tcf(o);if"
+"(i&&i.next)j='1.7'}}}}}if(s.apv>=4)x=screen.width+'x'+screen.height;if(s.isns||s.isopera){if(s.apv>=3){v=s.n.javaEnabled()?'Y':'N';if(s.apv>=4){c=screen.pixelDepth;bw=s.wd.innerWidth;bh=s.wd.innerH"
+"eight}}s.pl=s.n.plugins}else if(s.isie){if(s.apv>=4){v=s.n.javaEnabled()?'Y':'N';c=screen.colorDepth;if(s.apv>=5){bw=s.d.documentElement.offsetWidth;bh=s.d.documentElement.offsetHeight;if(!s.ismac&"
+"&s.b){tcf=new Function('s','tl','var e,hp=0;try{s.b.addBehavior(\"#default#homePage\");hp=s.b.isHomePage(tl)?\"Y\":\"N\"}catch(e){}return hp');hp=tcf(s,tl);tcf=new Function('s','var e,ct=0;try{s.b."
+"addBehavior(\"#default#clientCaps\");ct=s.b.connectionType}catch(e){}return ct');ct=tcf(s)}}}else r=''}if(s.pl)while(pn<s.pl.length&&pn<30){ps=s.fl(s.pl[pn].name,100)+';';if(p.indexOf(ps)<0)p+=ps;p"
+"n++}s.resolution=x;s.colorDepth=c;s.javascriptVersion=j;s.javaEnabled=v;s.cookiesEnabled=k;s.browserWidth=bw;s.browserHeight=bh;s.connectionType=ct;s.homepage=hp;s.plugins=p;s.td=1}if(vo){s.vob(vb)"
+";s.voa(vo)}if((vo&&vo._t)||!s.m_m('d')){if(s.usePlugins)s.doPlugins(s);var l=s.wd.location,r=tfs.document.referrer;if(!s.pageURL)s.pageURL=l.href?l.href:l;if(!s.referrer&&!s._1_referrer){s.referrer"
+"=r;s._1_referrer=1}s.m_m('g');if(s.lnk||s.eo){var o=s.eo?s.eo:s.lnk;if(!o)return '';var p=s.pageName,w=1,t=s.ot(o),n=s.oid(o),x=o.s_oidt,h,l,i,oc;if(s.eo&&o==s.eo){while(o&&!n&&t!='BODY'){o=o.paren"
+"tElement?o.parentElement:o.parentNode;if(!o)return '';t=s.ot(o);n=s.oid(o);x=o.s_oidt}oc=o.onclick?''+o.onclick:'';if((oc.indexOf(\"s_gs(\")>=0&&oc.indexOf(\".s_oc(\")<0)||oc.indexOf(\".tl(\")>=0)r"
+"eturn ''}if(n)ta=o.target;h=s.oh(o);i=h.indexOf('?');h=s.linkLeaveQueryString||i<0?h:h.substring(0,i);l=s.linkName;t=s.linkType?s.linkType.toLowerCase():s.lt(h);if(t&&(h||l))q+='&pe=lnk_'+(t=='d'||"
+"t=='e'?s.ape(t):'o')+(h?'&pev1='+s.ape(h):'')+(l?'&pev2='+s.ape(l):'');else trk=0;if(s.trackInlineStats){if(!p){p=s.pageURL;w=0}t=s.ot(o);i=o.sourceIndex;if(s.gg('objectID')){n=s.gg('objectID');x=1"
+";i=1}if(p&&n&&t)qs='&pid='+s.ape(s.fl(p,255))+(w?'&pidt='+w:'')+'&oid='+s.ape(s.fl(n,100))+(x?'&oidt='+x:'')+'&ot='+s.ape(t)+(i?'&oi='+i:'')}}if(!trk&&!qs)return '';s.sampled=s.vs(sed);if(trk){if(s"
+".sampled)code=s.mr(sess,(vt?'&t='+s.ape(vt):'')+s.hav()+q+(qs?qs:s.rq()),0,ta);qs='';s.m_m('t');if(s.p_r)s.p_r();s.referrer=s.lightProfileID=s.retrieveLightProfiles=s.deleteLightProfiles=''}s.sq(qs"
+");}else{s.dl(vo);}if(vo)s.voa(vb,1);s.lnk=s.eo=s.linkName=s.linkType=s.wd.s_objectID=s.ppu=s.pe=s.pev1=s.pev2=s.pev3='';if(s.pg)s.wd.s_lnk=s.wd.s_eo=s.wd.s_linkName=s.wd.s_linkType='';return code};"
+"s.trackLink=s.tl=function(o,t,n,vo){var s=this;s.lnk=s.co(o);s.linkType=t;s.linkName=n;s.t(vo)};s.trackLight=function(p,ss,i,vo){var s=this;s.lightProfileID=p;s.lightStoreForSeconds=ss;s.lightIncre"
+"mentBy=i;s.t(vo)};s.jsLoaded=function(){var s=this,x;if(s.lmq)for(i=0;i<s.lmq.length;i++){x=s.lmq[i];s.loadModule(x.n,x.u,x.d)}if(s.onLoad)s.onLoad(s);if(s.tq)for(i=0;i<s.tq.length;i++)s.t(s.tq[i])"
+"};s.wd=window;s.ssl=(s.wd.location.protocol.toLowerCase().indexOf('https')>=0);s.d=document;s.b=s.d.body;if(s.d.getElementsByTagName){s.h=s.d.getElementsByTagName('HEAD');if(s.h)s.h=s.h[0]}s.n=navi"
+"gator;s.u=s.n.userAgent;s.ns6=s.u.indexOf('Netscape6/');var apn=s.n.appName,v=s.n.appVersion,ie=v.indexOf('MSIE '),o=s.u.indexOf('Opera '),i;if(v.indexOf('Opera')>=0||o>0)apn='Opera';s.isie=(apn=='"
+"Microsoft Internet Explorer');s.isns=(apn=='Netscape');s.isopera=(apn=='Opera');s.ismac=(s.u.indexOf('Mac')>=0);if(o>0)s.apv=parseFloat(s.u.substring(o+6));else if(ie>0){s.apv=parseInt(i=v.substrin"
+"g(ie+5));if(s.apv>3)s.apv=parseFloat(i)}else if(s.ns6>0)s.apv=parseFloat(s.u.substring(s.ns6+10));else s.apv=parseFloat(v);s.em=0;if(s.em.toPrecision)s.em=3;else if(String.fromCharCode){i=escape(St"
+"ring.fromCharCode(256)).toUpperCase();s.em=(i=='%C4%80'?2:(i=='%U0100'?1:0))}if(s.oun)s.sa(s.oun);s.sa(un);s.vl_l='dynamicVariablePrefix,visitorID,vmk,visitorMigrationKey,visitorMigrationServer,vis"
+"itorMigrationServerSecure,ppu,charSet,visitorNamespace,cookieDomainPeriods,cookieLifetime,pageName,pageURL,referrer,currencyCode';s.va_l=s.sp(s.vl_l,',');s.vl_mr=s.vl_m='charSet,visitorNamespace,co"
+"okieDomainPeriods,cookieLifetime,contextData,lightProfileID,lightStoreForSeconds,lightIncrementBy';s.vl_t=s.vl_l+',variableProvider,channel,server,pageType,transactionID,purchaseID,campaign,state,z"
+"ip,events,events2,products,linkName,linkType,contextData,lightProfileID,lightStoreForSeconds,lightIncrementBy,retrieveLightProfiles,deleteLightProfiles,retrieveLightData';var n;for(n=1;n<=75;n++){s"
+".vl_t+=',prop'+n+',eVar'+n;s.vl_m+=',prop'+n+',eVar'+n}for(n=1;n<=5;n++)s.vl_t+=',hier'+n;for(n=1;n<=3;n++)s.vl_t+=',list'+n;s.va_m=s.sp(s.vl_m,',');s.vl_l2=',tnt,pe,pev1,pev2,pev3,resolution,color"
+"Depth,javascriptVersion,javaEnabled,cookiesEnabled,browserWidth,browserHeight,connectionType,homepage,plugins';s.vl_t+=s.vl_l2;s.va_t=s.sp(s.vl_t,',');s.vl_g=s.vl_t+',trackingServer,trackingServerS"
+"ecure,trackingServerBase,fpCookieDomainPeriods,disableBufferedRequests,mobile,visitorSampling,visitorSamplingGroup,dynamicAccountSelection,dynamicAccountList,dynamicAccountMatch,trackDownloadLinks,"
+"trackExternalLinks,trackInlineStats,linkLeaveQueryString,linkDownloadFileTypes,linkExternalFilters,linkInternalFilters,linkTrackVars,linkTrackEvents,linkNames,lnk,eo,lightTrackVars,_1_referrer,un';"
+"s.va_g=s.sp(s.vl_g,',');s.pg=pg;s.gl(s.vl_g);s.contextData=new Object;s.retrieveLightData=new Object;if(!ss)s.wds();if(pg){s.wd.s_co=function(o){s_gi(\"_\",1,1).co(o)};s.wd.s_gs=function(un){s_gi(u"
+"n,1,1).t()};s.wd.s_dc=function(un){s_gi(un,1).t()}}",
w=window,l=w.s_c_il,n=navigator,u=n.userAgent,v=n.appVersion,e=v.indexOf('MSIE '),m=u.indexOf('Netscape6/'),a,i,x,s;if(un){un=un.toLowerCase();if(l)for(i=0;i<l.length;i++){s=l[i];x=s._c;if((!x||x=='s_c'||x=='s_l')&&(s.oun==un||(s.fs&&s.sa&&s.fs(s.oun,un)))){if(s.sa)s.sa(un);if(x=='s_c')return s}else s=0}}w.s_an='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
w.s_sp=new Function("x","d","var a=new Array,i=0,j;if(x){if(x.split)a=x.split(d);else if(!d)for(i=0;i<x.length;i++)a[a.length]=x.substring(i,i+1);else while(i>=0){j=x.indexOf(d,i);a[a.length]=x.subst"
+"ring(i,j<0?x.length:j);i=j;if(i>=0)i+=d.length}}return a");
w.s_jn=new Function("a","d","var x='',i,j=a.length;if(a&&j>0){x=a[0];if(j>1){if(a.join)x=a.join(d);else for(i=1;i<j;i++)x+=d+a[i]}}return x");
w.s_rep=new Function("x","o","n","return s_jn(s_sp(x,o),n)");
w.s_d=new Function("x","var t='`^@$#',l=s_an,l2=new Object,x2,d,b=0,k,i=x.lastIndexOf('~~'),j,v,w;if(i>0){d=x.substring(0,i);x=x.substring(i+2);l=s_sp(l,'');for(i=0;i<62;i++)l2[l[i]]=i;t=s_sp(t,'');d"
+"=s_sp(d,'~');i=0;while(i<5){v=0;if(x.indexOf(t[i])>=0) {x2=s_sp(x,t[i]);for(j=1;j<x2.length;j++){k=x2[j].substring(0,1);w=t[i]+k;if(k!=' '){v=1;w=d[b+l2[k]]}x2[j]=w+x2[j].substring(1)}}if(v)x=s_jn("
+"x2,'');else{w=t[i]+' ';if(x.indexOf(w)>=0)x=s_rep(x,w,t[i]);i++;b+=62}}}return x");
w.s_fe=new Function("c","return s_rep(s_rep(s_rep(c,'\\\\','\\\\\\\\'),'\"','\\\\\"'),\"\\n\",\"\\\\n\")");
w.s_fa=new Function("f","var s=f.indexOf('(')+1,e=f.indexOf(')'),a='',c;while(s>=0&&s<e){c=f.substring(s,s+1);if(c==',')a+='\",\"';else if((\"\\n\\r\\t \").indexOf(c)<0)a+=c;s++}return a?'\"'+a+'\"':"
+"a");
w.s_ft=new Function("c","c+='';var s,e,o,a,d,q,f,h,x;s=c.indexOf('=function(');while(s>=0){s++;d=1;q='';x=0;f=c.substring(s);a=s_fa(f);e=o=c.indexOf('{',s);e++;while(d>0){h=c.substring(e,e+1);if(q){i"
+"f(h==q&&!x)q='';if(h=='\\\\')x=x?0:1;else x=0}else{if(h=='\"'||h==\"'\")q=h;if(h=='{')d++;if(h=='}')d--}if(d>0)e++}c=c.substring(0,s)+'new Function('+(a?a+',':'')+'\"'+s_fe(c.substring(o+1,e))+'\")"
+"'+c.substring(e+1);s=c.indexOf('=function(')}return c;");
c=s_d(c);if(e>0){a=parseInt(i=v.substring(e+5));if(a>3)a=parseFloat(i)}else if(m>0)a=parseFloat(u.substring(m+10));else a=parseFloat(v);if(a<5||v.indexOf('Opera')>=0||u.indexOf('Opera')>=0)c=s_ft(c);if(!s){s=new Object;if(!w.s_c_in){w.s_c_il=new Array;w.s_c_in=0}s._il=w.s_c_il;s._in=w.s_c_in;s._il[s._in]=s;w.s_c_in++;}s._c='s_c';(new Function("s","un","pg","ss",c))(s,un,pg,ss);return s}


