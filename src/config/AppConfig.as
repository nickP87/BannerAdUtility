package config
{
	import controller.*;
	
	import events.ViewChangeEvent;
	
	import flash.events.*;
	
	import model.*;
	
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.LogLevel;
	
	import views.*;
	
	public class AppConfig implements IConfig
	{
		
		[Inject]
		public var context:IContext;
		
		[Inject]
		public var eventCommandMap:IEventCommandMap;
		
		[Inject]
		public var mediatorMap:IMediatorMap;
		
		[Inject]
		public var dispatcher:IEventDispatcher;
		
		[Inject]
		public var contextView:ContextView;
		
		
		
		public function AppConfig()
		{
		}
		
		public function configure():void
		{
			//context.logLevel = LogLevel.FATAL;
			
			eventCommandMap.map(Event.INIT).toCommand(MyInitCommand);
			
			//mediatorMap.map(IMessageWriter).toMediator(MessageWriterMediator);
			mediatorMap.map(SplashView).toMediator(SplashMediator);
			mediatorMap.map(MainView).toMediator(MainMediator);
			
			context.injector.map(ExternalSwfModel);
			//context.injector.map(TextAnalyzerModel); // chose to cheat on this one by instantiating it in ExternalSwfModel
			
			context.afterInitializing(init);
		}
		
		private function init():void {
			
			//contextView.view.addChild(new MessageWriterView());
			contextView.view.addChild(new SplashView());
			contextView.view.addChild(new MainView());
			
			dispatcher.dispatchEvent(new Event(Event.INIT));
			
			// dispatch event to show SplashView first
			dispatcher.dispatchEvent(new ViewChangeEvent(ViewChangeEvent.CHANGE, MyViews.V_SPLASH));
		}
	}
}