package views
{
	import flash.events.MouseEvent;
	
	import events.ClickTagEvent;
	import events.FrameEvent;
	import events.IncorrectWordEvent;
	import events.SWFLoadedEvent;
	import events.ViewChangeEvent;
	
	import model.ExternalSwfModel;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class MainMediator extends Mediator implements IRLMediator
	{
		
		[Inject]
		public var view:MainView;
		
		[Inject]
		public var swfModel:ExternalSwfModel;
		
		
		
		public function MainMediator()
		{
			super();
		}
		
		
		override public function initialize():void {
			
			addContextListener(ViewChangeEvent.CHANGE, handleViewChange);
			//addContextListener(SWFLoadedEvent.SWF_LOADED, handleSwfLoaded);
			swfModel.addEventListener(SWFLoadedEvent.SWF_LOADED, handleSwfLoaded);
			swfModel.addEventListener(FrameEvent.FRAME_NUM, handleFrameNumber);
			swfModel.addEventListener(ClickTagEvent.CLICKTAG, handleClickTag);
			swfModel.addEventListener(IncorrectWordEvent.BAD_WORD, handleIncorrectWord);
			//swfModel.addEventListener(SnapshotEvent.SNAPSHOT_REQUEST, handleSnapshotRequest);
			
			addViewListener(MouseEvent.CLICK, handleMouseClick);
		}
		
		
		/**
		 * mouse clicks
		 */
		private function handleMouseClick(e:MouseEvent):void {
			
			switch(e.target.name) {
				
				case "btn_load_swf":
					swfModel.loadSWF();
					break;
				
				case "btn_play":
					swfModel.playSWF();
					break;
				
				case "btn_pause":
					swfModel.pauseSWF();
					break;
				
				case "btn_restart":
					swfModel.restartSWF();
					break;
				
				case "btn_save_image":
					if (view.swfLoaded) {
						swfModel.saveSnapshot(view.takeSnapshot());
					}
					break;
			}
		}
		
		
		/**
		 * swf loaded, put it on stage here
		 */
		private function handleSwfLoaded(e:SWFLoadedEvent):void {
			
			view.addSWF(swfModel.loader, swfModel.swfWidth, swfModel.swfHeight, swfModel.swfColor, swfModel.swfSize, swfModel.swfRate, swfModel.swfFilename);
		}
		
		
		/**
		 * frame number
		 */
		private function handleFrameNumber(e:FrameEvent):void {
			view.frameNumber(e.frame);
		}
		
		
		/**
		 * click tag
		 */
		private function handleClickTag(e:ClickTagEvent):void {
			view.clickTag(e.url);
		}
		
		
		/**
		 * incorrect word
		 */
		private function handleIncorrectWord(e:IncorrectWordEvent):void {
			view.incorrectWord(e.word);
		}
		
		
		/**
		 * snapshot
		 
		private function handleSnapshotRequest(e:SnapshotEvent):void {
			swfModel.takeSnapshot(view.takeSnapshot());
		}*/
		
		
		/**
		 * view change
		 */
		public function handleViewChange(e:ViewChangeEvent):void {
			
			if (e.scene == MyViews.V_MAIN) {
				view.show();
			}
			else {
				view.hide();
			}
		};
	}
}