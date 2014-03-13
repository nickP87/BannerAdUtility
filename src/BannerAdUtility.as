package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import config.AppConfig;
	
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;
	
	[SWF(width="1024", height="768", frameRate="30", backgroundColor="#000000")]
	/**
	 * author Nick Pinkham
	 */
	public class BannerAdUtility extends Sprite
	{
		
		private var _context:IContext;
		
		
		
		public function BannerAdUtility()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_context = new Context();
			_context.install(MyExtensionBundle);
			_context.configure(AppConfig);
			var cv:ContextView = new ContextView(this);
			
			_context.configure(cv);
		}
	}
}