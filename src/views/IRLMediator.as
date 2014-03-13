package views
{
	import events.ViewChangeEvent;

	public interface IRLMediator
	{
		function handleViewChange(e:ViewChangeEvent):void;
	}
}