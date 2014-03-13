package events
{
	import flash.events.Event;
	
	public class ViewChangeEvent extends Event
	{
		
		public static const CHANGE:String = "viewChange";
		public var scene:uint;
		
		
		public function ViewChangeEvent(type:String, scene:uint, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.scene = scene;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new ViewChangeEvent(type, scene, bubbles, cancelable);
		}
	}
}