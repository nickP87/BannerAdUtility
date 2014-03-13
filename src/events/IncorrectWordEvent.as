package events
{
	import flash.events.Event;
	
	public class IncorrectWordEvent extends Event
	{
		
		public static const BAD_WORD:String = "badWord";
		
		public var word:String;
		
		
		public function IncorrectWordEvent(type:String, word:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.word = word; // word
			
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new IncorrectWordEvent(type, word, bubbles, cancelable);
		}
	}
}