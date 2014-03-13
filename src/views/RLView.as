package views
{
	import flash.display.Sprite;
	import flash.events.Event;
	import com.greensock.TweenLite;
	
	public class RLView extends Sprite implements IRLView
	{
		public function RLView()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			alpha = 0;
			visible = false;
		}
		
		public function show():void
		{
			visible = true;
			TweenLite.to(this, 0.25, { alpha:1, delay:0.25 } );
		}
		
		public function hide():void
		{
			TweenLite.to(this, 0.25, { alpha:0, onComplete:hide2 } );
		}
		private function hide2():void {
			visible = false;
		}
	}
}