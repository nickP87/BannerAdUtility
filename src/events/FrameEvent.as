package events
{
	import flash.events.Event;
	
	public class FrameEvent extends Event
	{
		
		public static const FRAME_NUM:String = "frameNum";
		
		public var frame:uint;
		
		public function FrameEvent(type:String, frame:uint, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.frame = frame;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new FrameEvent(type, frame, bubbles, cancelable);
		}
	}
}