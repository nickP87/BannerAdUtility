package views
{
	import events.ViewChangeEvent;
	
	import flash.utils.setTimeout;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class SplashMediator extends Mediator implements IRLMediator
	{
		
		[Inject]
		public var view:SplashView;
		
		
		
		public function SplashMediator()
		{
			super();
		}
		
		
		override public function initialize():void {
			
			// on init set timer for 2 seconds
			setTimeout(exitSplash, 1000);
			
			addContextListener(ViewChangeEvent.CHANGE, handleViewChange);
		}
		
		private function exitSplash():void {
			
			dispatch(new ViewChangeEvent(ViewChangeEvent.CHANGE, MyViews.V_MAIN));
		}
		
		
		public function handleViewChange(e:ViewChangeEvent):void {
			
			if (e.scene == MyViews.V_SPLASH) {
				view.show();
			}
			else {
				view.hide();
			}
		};
	}
}