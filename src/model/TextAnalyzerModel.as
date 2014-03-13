package model
{
	import com.gskinner.spelling.SPLTag;
	import com.gskinner.spelling.SPLWordListLoader;
	import com.gskinner.spelling.SpellingDictionary;
	import com.gskinner.spelling.SpellingHighlighter;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.text.StaticText;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import events.IncorrectWordEvent;
	
	import fl.text.TLFTextField;
	
	//import flashx.textLayout.container.ContainerController;

	
	/**
	 * broke this class off from ExternalSwfModel to traverse display list for text fields
	 */
	
	public class TextAnalyzerModel extends EventDispatcher
	{
		
		public var externalSwfModel:ExternalSwfModel;
		
		private var _dictionary:SpellingDictionary;
		
		private var _wwl:SPLWordListLoader = new SPLWordListLoader();
		private var _container:DisplayObjectContainer;
		
		private var regs:Vector.<TextField>; 			    // tied to VVVVVVV
		private var reggoTags:Vector.<SpellingHighlighter>; // tied to ^^^^^^^
		
		private var statics:Vector.<StaticText>;
		private var staticTags:Vector.<SPLTag>;
		
		private var tlfs:Vector.<TLFTextField>; // tied to VVVVVVV
		private var tlfTags:Vector.<SPLTag>;    // tied to ^^^^^^^
		
		
		
		public function TextAnalyzerModel(externalSwfModel:ExternalSwfModel, target:IEventDispatcher=null)
		{
			super(target);
			this.externalSwfModel = externalSwfModel;
			
			// create word list loader
			_wwl.url = "wordlists/en_us/en_us.zlib";
			//_wwl.x = 300;
			
			// create spelling dictionary to check words
			_dictionary = SpellingDictionary.getInstance();
			//trace("dictionary:", _dictionary);
		}
		
		
		
		/**
		 * as2 text
		 */
		private var _badWords:Array = [];
		
		public function analyzeText(text:String):Boolean {
			//trace("-------------------------------------------------");
			//trace("checking spelling!");
			var a:Array = _dictionary.checkString(text);
			//trace("misspelled words:", a.length, a);
			
			for each (var obj:Object in a) {
				//trace(obj);
				var used:Boolean = false;
				for each (var s:String in _badWords) {
					if (obj.subString == s) {
						used = true;
					}
				}
				if (!used) {
					_badWords.push(obj.subString);
					externalSwfModel.dispatchEvent(new IncorrectWordEvent(IncorrectWordEvent.BAD_WORD, obj.subString, true));
				}
			}
			
			if (a.length > 0) {
				return true;
			}
			return false;
		}
		
		
		
		
		
		
		/**
		 * as3 analyze
		 */
		public function analyzeLoader():void
		{
			regs = new Vector.<TextField>();
			reggoTags = new Vector.<SpellingHighlighter>();
			
			statics = new Vector.<StaticText>();
			staticTags = new Vector.<SPLTag>();
			
			tlfs = new Vector.<TLFTextField>();
			tlfTags = new Vector.<SPLTag>();
			
			if (_container) _container.removeEventListener(Event.ENTER_FRAME, handleLoop);
			
			_container = externalSwfModel.loader.content as DisplayObjectContainer;
			_container.addEventListener(Event.ENTER_FRAME, handleLoop);
			
			// add word list loader to stage
			_container.addChild(_wwl);
		}
		
		private function handleLoop(e:Event):void {
			
			//var t:Number = flash.utils.getTimer();
			recurseDOC(externalSwfModel.loader.content as DisplayObjectContainer, 0);
			//doTheSpellingThing();
			//var d:Number = (getTimer() - t) / 1000;
			//if (d > 0.05) trace("time:", d, "seconds");
		}
		
		private function recurseDOC(doc:DisplayObjectContainer, indentSpaces:uint):void
		{
			var child:DisplayObject;
			var nc:uint = doc.numChildren;
			var indent:String = " ";
			for (var i:uint = 0; i < indentSpaces; i ++) {
				indent += " ";
			}
			
			for (var c:uint = 0; c < nc; c ++) {
				child = doc.getChildAt(c);
				//trace(indent, child);
				
				if (child is TextField) {
					if (regs.indexOf(child as TextField) == -1) {
						regs.push(child);
						createReggoTag(child);
						//trace(indent, "textfield:", TextField(child).text);
					}
				}
				else if (child is TLFTextField) {
					if (tlfs.indexOf(child as TLFTextField) == -1) {
						tlfs.push(child);
						createSuperSpecialTag(child);
						//trace(indent, "tlf:", TLFTextField(child).text);
					}
				}
				else if (child is StaticText) {
					if (statics.indexOf(child as StaticText) == -1) {
						statics.push(child);
						createStaticTag(child);
						//trace(indent, "static:", StaticText(child).text);
					}
				}
				else if (child is DisplayObjectContainer) {
					//if (flash.utils.getQualifiedClassName(child).toLowerCase().search("tcmtext") >= 0) {}
					recurseDOC(child as DisplayObjectContainer, indentSpaces + 5);
				}
				
				
			}
		}
		
		/*
		private function doTheSpellingThing():void {
			var nt:uint = regs.length;
			for (var n:uint = 0; n < nt; n ++) {
				createReggoTag(DisplayObject(regs[n]));
			}
			
			nt = tlfs.length;
			for (n = 0; n < nt; n ++) {
				createSuperSpecialTag(DisplayObject(tlfs[n]));
			}
			//trace("regs:", regs.length, "tlfs:", tlfs.length);
		}*/
		
		private function createReggoTag(dso:DisplayObject):void {
			//var sph:SpellingHighlighter = new SpellingHighlighter(dso);
			reggoTags[regs.indexOf(dso as TextField)] = new SpellingHighlighter(dso);
		}
		
		private function createStaticTag(dso:DisplayObject):void {
			trace("here is where I WOULD create a tag if the system supported static text fields");
			return;
			var splt:SPLTag = new SPLTag();
			splt.enabled = true;
			splt._targetInstanceName = dso.name;
			splt.x = dso.x;
			splt.y = dso.y;
			dso.parent.addChild(splt);
			staticTags[statics.indexOf(dso as StaticText)] = splt;
		}
		
		private function createSuperSpecialTag(dso:DisplayObject):void {
			var splt:SPLTag = new SPLTag();
			splt.enabled = true;
			splt._targetInstanceName = dso.name;
			splt.x = dso.x;
			splt.y = dso.y;
			dso.parent.addChild(splt);
			tlfTags[tlfs.indexOf(dso as TLFTextField)] = splt;
		}
	}
}