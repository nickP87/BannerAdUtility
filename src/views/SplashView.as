package views
{
	import flash.display.Sprite;
	import flash.events.Event;
	import com.greensock.TweenLite;
	
	public class SplashView extends RLView
	{
		public function SplashView()
		{
			super();
		}
		
		
		override public function init(e:Event):void {
			super.init(e);
			
			addChild(new mc_splash());
		}
		
		override public function show():void {
			visible = true;
			alpha = 1;
		}
	}
}