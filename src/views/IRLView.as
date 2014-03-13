package views
{
	import flash.events.Event;
	
	/**
	 * RobotLegs standard view
	 */
	public interface IRLView
	{
		function init(e:Event):void;
		function show():void;
		function hide():void;
	}
}