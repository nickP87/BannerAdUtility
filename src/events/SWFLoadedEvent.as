package events
{
	import flash.events.Event;
	
	public class SWFLoadedEvent extends Event
	{
		
		public static const SWF_LOADED:String = "swfLoaded";
		
		
		public function SWFLoadedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}