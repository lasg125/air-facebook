package com{
	
	import flash.display.MovieClip;
	import flash.html.HTMLLoader;
	import flash.net.URLLoader;
	import flash.events.LocationChangeEvent;
	import flash.events.*;
	import flash.media.StageWebView;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;


	public class facebook extends MovieClip{

		private static const CLIENT_ID:String = "1038257536296018";
		private static const CLIENT_SECRET:String = "b8df46452fbdfbb957862cf0b0801d11";

		private var webView:StageWebView;
		private var code:String;
		private var access_token:String;
		private var accessTokenLoader:URLLoader;
		private var profileLoader:URLLoader;

		public function facebook():void{
			this.addEventListener(MouseEvent.CLICK, initSignIn);
			this.buttonMode = true;
		}

		private function initSignIn(e:MouseEvent):void
		{
		    webView = new StageWebView(true);
		    webView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, changeLocation);
		    webView.stage = this.stage;
		    webView.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
		    webView.loadURL("https://www.facebook.com/dialog/oauth?client_id="+CLIENT_ID+"&redirect_uri=https://www.facebook.com/connect/login_success.html&scope=email");
		}
		
		private function changeLocation(event:LocationChangeEvent):void
		{
			var location:String = webView.location;

			if(location.indexOf("code=") != -1 && location.indexOf("error") == -1){
				webView.dispose();
				code = location.substr(location.indexOf("code=")+5, location.length);
				getAccessToken();
			}           
		}
		
		private function getAccessToken():void
		{               
			var request:URLRequest = new URLRequest("https://graph.facebook.com/v2.8/oauth/access_token?client_id="+CLIENT_ID+"&redirect_uri=https://www.facebook.com/connect/login_success.html&client_secret="+CLIENT_SECRET+"&code="+code);

			accessTokenLoader = new URLLoader();
			accessTokenLoader.addEventListener(Event.COMPLETE, accessTokenReceived);
			accessTokenLoader.load(request);
		}
		
		private function accessTokenReceived(event:Event):void
		{               
			var rawData:Object = JSON.parse(String(event.currentTarget.data));
			access_token = rawData.access_token;

			loadProfileInfo();
		}
		
		private function loadProfileInfo():void
		{
			profileLoader = new URLLoader();
			profileLoader.addEventListener(Event.COMPLETE, profileLoaded);
			profileLoader.load(new URLRequest("https://graph.facebook.com/me/?access_token="+access_token+"&fields=name,email,picture.type(large)"));
		}

		private function profileLoaded(event:Event):void
		{
			trace(event.currentTarget.data);
			share();
		}

		private function share():void{
			var webShare = new StageWebView();
		    webShare.addEventListener(LocationChangeEvent.LOCATION_CHANGE, onLocationChanging);
		    webShare.stage = this.stage;
		    webShare.viewPort = new Rectangle(0, 0, 600, 600);
		    webShare.loadURL("https://www.facebook.com/dialog/feed?app_id="+CLIENT_ID+"&display=popup&caption=An example caption&link=https://developers.facebook.com/docs/");
			
			function onLocationChanging( event:LocationChangeEvent ):void 
			{ 
				event.preventDefault(); 
				var location = event.location;
				if(location.indexOf("close") != -1 && location.indexOf("error") == -1){
					trace("closing");
					webShare.dispose();
				}
			}
		}
	}
}