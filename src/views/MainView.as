package views
{
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	public class MainView extends RLView
	{
		
		// public
		public var swfContainer:Sprite = new Sprite();
		
		public var swfLoaded:Boolean = false;
		
		private var swfWidth:Number;
		private var swfHeight:Number;
		
		// private
		private var _feedbackMC:MovieClip;
		private var _tf_filename:TextField;
		private var _tf_frame_num:TextField;
		private var _tf_frame_rate:TextField;
		private var _tf_file_size:TextField;
		private var _tf_clicktag:TextField;
		private var _tf_incorrect_words:TextField;
		
		private var _feedbackX:Number;
		private var _feedbackY:Number;
		
		
		public function MainView() {
			super();
		}
		
		override public function init(e:Event):void {
			
			super.init(e);
			
			var mc:MovieClip = new mc_main();
			addChild(mc);
			
			_feedbackMC = MovieClip(mc.getChildByName("mc_feedback_text"));
			
			_feedbackX = _feedbackMC.x;
			_feedbackY = _feedbackMC.y;
			
			_tf_filename = _feedbackMC.getChildByName("txt_filename") as TextField;
			_tf_filename.text = "";
			_tf_frame_num = _feedbackMC.getChildByName("txt_frame_num") as TextField;
			_tf_frame_rate = _feedbackMC.getChildByName("txt_frame_rate") as TextField;
			_tf_file_size = _feedbackMC.getChildByName("txt_file_size") as TextField;
			_tf_clicktag = _feedbackMC.getChildByName("txt_clicktag") as TextField;
			_tf_clicktag.text = "";
			_tf_incorrect_words = _feedbackMC.getChildByName("txt_incorrect_words") as TextField;
			_tf_incorrect_words.text = "";
			
			addChild(swfContainer);
			swfContainer.x = spX;
			swfContainer.y = spY;
			
			_feedbackMC.visible = false;
		}
		
		/**
		 * fill swf container with swf
		 */
		
		// constants
		public static const spX:Number = 15;
		public static const spY:Number = 95;
		
		public function addSWF(ldr:Loader, w:uint, h:uint, c:uint, size:uint, framerate:uint, filename:String):void {
			
			_feedbackMC.visible = true;
			if (w > 650) {
				_feedbackMC.y = spY + h + 15;
			} else {
				_feedbackMC.y = _feedbackY;
			}
			
			swfWidth = w;
			swfHeight = h;
			
			swfContainer.removeChildren();
			
			//ldr.x = spX;
			//ldr.y = spY;
			swfContainer.addChild(ldr);
			
			var bg:Shape = new Shape();
			bg.graphics.lineStyle();
			bg.graphics.beginFill(c);
			bg.graphics.drawRect(0, 0, w, h);
			bg.graphics.endFill();
			swfContainer.addChildAt(bg, 0);
			
			var mask:Shape = new Shape();
			mask.graphics.lineStyle();
			mask.graphics.beginFill(c);
			mask.graphics.drawRect(0, 0, w, h);
			mask.graphics.endFill();
			swfContainer.addChild(mask);
			ldr.mask = mask;
			
			_tf_incorrect_words.text = "";
			
			fileName(filename);
			frameRate(framerate);
			fileSize(size);
			
			swfLoaded = true;
		}
		
		
		/**
		 * fill in text fields
		 */
		public function fileName(f:String):void {
			_tf_filename.text = f;
		}
		
		public function frameNumber(f:Number):void {
			_tf_frame_num.text = String(f);
		}
		
		public function frameRate(f:Number):void {
			_tf_frame_rate.text = String(f);
		}
		
		public function fileSize(f:Number):void {
			_tf_file_size.text = bytesToString(f);
		}
		private var _levels:Array = ['bytes', 'Kb', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
		private function bytesToString(bytes:Number):String {
			var index:uint = Math.floor(Math.log(bytes)/Math.log(1024));
			return (bytes/Math.pow(1024, index)).toFixed(2) + this._levels[index];
		}		
		public function clickTag(url:String):void {
			_tf_clicktag.text = url;
		}
		
		public function incorrectWord(w:String):void {
			_tf_incorrect_words.appendText(w + "\n");
			_tf_incorrect_words.scrollV = _tf_incorrect_words.maxScrollV;
		}
		
		
		/**
		 * take snapshot
		 */
		public function takeSnapshot():BitmapData {
			var bitmapData:BitmapData = new BitmapData(swfWidth, swfHeight, true, 0x000000);
			swfContainer.x = swfContainer.y = 0;
			bitmapData.draw(swfContainer, null, null, null, new Rectangle(0, 0, swfWidth, swfHeight));
			swfContainer.x = spX;
			swfContainer.y = spY;
			
			return bitmapData;
		}
	}
}