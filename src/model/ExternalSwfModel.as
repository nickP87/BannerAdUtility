package model
{
	import com.adobe.images.JPGEncoder;
	import com.senocular.utils.SWFReader;
	
	import flash.display.AVM1Movie;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.LocalConnection;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import events.ClickTagEvent;
	import events.FrameEvent;
	import events.SWFLoadedEvent;
	
	public class ExternalSwfModel extends EventDispatcher
	{
		
		private var textAnalyzerModel:TextAnalyzerModel;
		
		private var _loader:Loader;
		private var _as2Loader:Loader;
		private var _url:String;
		
		// swf data
		public var swfFilename:String;
		public var swfWidth:Number;
		public var swfHeight:Number;
		public var swfColor:uint;
		public var swfSize:uint = 0;
		public var swfRate:uint = 0;
		
		// textfields
		
		
		public function ExternalSwfModel()
		{
			textAnalyzerModel = new TextAnalyzerModel(this);
		}
		
		/**
		 * executed when "load swf" button is pressed
		 */
		public function loadSWF():void {
			var file:File = new File();
			var swfFilter:FileFilter = new FileFilter("SWF", "*.swf");
			file.addEventListener(Event.SELECT, handleFileSelected);
			file.addEventListener(Event.CANCEL, handleCancelFileSelect);
			file.browseForOpen("Please select a SWF", [swfFilter]);
		}
		// user cancels the file load
		private function handleCancelFileSelect(e:Event):void {
			trace("cancel");
		}
		// user selects a swf file
		private function handleFileSelected(e:Event):void
		{
			// load the file into a bytearray
			var file:File = e.target as File;
			_url = file.url;
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, flash.filesystem.FileMode.READ);
			var bytes:ByteArray = new ByteArray();
			fileStream.readBytes(bytes);
			fileStream.close();
			
			// get swf data
			var fileStream2:FileStream = new FileStream();
			fileStream2.open(file, flash.filesystem.FileMode.READ);
			var bytes2:ByteArray = new ByteArray();
			fileStream2.readBytes(bytes2);
			var swfreader:SWFReader = new SWFReader(bytes2);
			
			// set vars from swf data
			swfFilename = file.name;
			swfWidth = swfreader.width;
			swfHeight = swfreader.height;
			swfColor = swfreader.backgroundColor;
			swfSize = swfreader.fileSize;
			swfRate = swfreader.frameRate;
			
			if (_loader != null) {
				_loader.unloadAndStop();
				_loader = null;
			}

			// bring loaded bytes into Loader object
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.allowCodeImport = true;
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
			_loader.loadBytes(bytes, loaderContext);
		}
		
		private function loaderComplete(e:Event):void {
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderComplete);
			if (_loader.content is AVM1Movie) {
				loadAS2();
			}
			else {
				loadAS3();
			}
		}
		
		
		
		
		/**
		 * save a bitmap of the ad
		 */
		public function saveSnapshot(bitmapData:BitmapData):void {
			if (!_loader) return;
			
			var jpgEncoder:JPGEncoder = new JPGEncoder(60);
			var byteArray:ByteArray = jpgEncoder.encode(bitmapData);
			
			var fileRef:FileReference = new FileReference();
			fileRef.save(byteArray, ".jpg");
		}
		
		
		
		
		
		/**
		 * as 2 loader
		 */
		private var _lcInited:Boolean = false;
		private var _as2:Boolean = false;
		private var lcGet:LocalConnection;
		private var lcRec:LocalConnection;
		
		private function loadAS2():void {
			
			if (_as2 == true && _lcInited == true) {
				// already have it loaded, just send it the url again
				handleAS2LoaderComplete();
				return;
			}
			
			// load in localconnection bridge
			initLC();
			
			_as2 = true;
			var file:File = File.applicationDirectory.resolvePath("as2bridge.swf");
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.allowCodeImport = true;
			_as2Loader = new Loader();
			_as2Loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleAS2LoaderComplete);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, flash.filesystem.FileMode.READ);
			var bytes:ByteArray = new ByteArray();
			fileStream.readBytes(bytes);
			fileStream.close();
			_as2Loader.loadBytes(bytes, loaderContext);
			//addChild(as2loader);
			//as2loader.mask = _mask;
		}
		private function initLC():void {
			if (_lcInited) return;
			_lcInited = true;
			lcGet = new LocalConnection();
			lcGet.addEventListener(StatusEvent.STATUS, handleLocalConnectionStatus);
			
			lcRec = new LocalConnection();
			lcRec.connect('fromAs2');
			var myClient:Object = new Object();
			lcRec.client = myClient;
			myClient.callingBackToAs3 = function (e:*):void {
				//trace(e, "is the call back from as2");
			};
			myClient.callingWithWords = function (e:*):void {
				if (e is String && String(e).length > 1) {
					//e = e.replace(/[\u000d\u000a\u0008]+/g, " "); // change line breaks to spaces
					
					// if there are incorrect words in this here string:
					if (textAnalyzerModel.analyzeText(e)) {
						lcGet.send('as2bridge', 'command', 'incorrectWords', e);
					}
				}
			}
			myClient.frameCount = function (e:*):void {
				if (e is Number) {
					dispatchEvent(new FrameEvent(FrameEvent.FRAME_NUM, e));
				}
			}
			myClient.sendClickTag = function (e:*):void {
				//trace("incoming click tag!", e);
				if (e is String) {
					dispatchEvent(new ClickTagEvent(ClickTagEvent.CLICKTAG, e));
				}
			}
		}
		
		private function handleAS2LoaderComplete(e:Event = null):void {
			// some kinda delay in there, so here's some duct tape:
			flash.utils.setTimeout(sendToAs2Bridge, 1000);
		}

		private function sendToAs2Bridge():void {
			lcGet.send('as2bridge', 'command', 'loadOldSchoolMovie', _url);
			
			// I think it's ready...
			dispatchEvent(new SWFLoadedEvent(SWFLoadedEvent.SWF_LOADED, true));
		}
		
		private function handleLocalConnectionStatus(e:StatusEvent):void {
			//trace("status event:", e.code, e);
		}

		public function playSWF():void {
			if (_lcInited) {
				lcGet.send('as2bridge', 'command', 'playOldSchoolMovie');
			}
		}
		
		public function pauseSWF():void {
			if (_lcInited) {
				lcGet.send('as2bridge', 'command', 'pauseOldSchoolMovie');
			}
		}
		
		public function restartSWF():void {
			if (_lcInited) {
				lcGet.send('as2bridge', 'command', 'restartOldSchoolMovie');
			}
		}
		
		
		
		/**
		 * as 3 loader
		 */
		private function loadAS3():void {
			
			_as2 = false;
			
			setTimeout(textAnalyzerModel.analyzeLoader, 1000);
			
			// tell main menu view to show the swf
			dispatchEvent(new SWFLoadedEvent(SWFLoadedEvent.SWF_LOADED, true));
			
		}
		
		
		
		
		
		
		
		/**
		 * public get
		 */
		public function get loader():Loader {
			if (_as2) {
				return _as2Loader;
			}
			return _loader;
		}
	}
}