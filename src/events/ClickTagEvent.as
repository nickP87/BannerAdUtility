
package events
{
	import flash.events.Event;
	
	public class ClickTagEvent extends Event
	{
		
		public static const CLICKTAG:String = "click_tag";
		
		public var url:String;
		
		
		public function ClickTagEvent(type:String, url:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.url = url;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new ClickTagEvent(type, url, bubbles, cancelable);
		}
	}
}