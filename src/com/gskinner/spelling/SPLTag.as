﻿/*
* SPL; AS3 Spelling library for Flash and the Flex SDK. 
* 
* Copyright (c) 2013 gskinner.com, inc.
* 
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
*/
package com.gskinner.spelling {
	
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	
	/**
	 * The SPLTag component provides a visual way to set up a SpellingHighlighter instance
	 * in Flash on the stage, and associate it with a target. For direct instantiation in
	 * ActionScript, please use SpellingHighlighter.as.
	 *
	 * @see com.gskinner.spelling.SpellingHighlighter
	 */
	[IconFile("componentIcon.png")]
	public class SPLTag extends Sprite {
		
		/** @private */
		protected var _spellingHighlighter:SpellingHighlighter;
		
		/** @private */
		protected var __target:String;
		
		/** @private */
		public function SPLTag() {
			_spellingHighlighter = new SpellingHighlighter();
			visible = false;
		}
		
		/** @private */
		[Inspectable()]
		public function set _targetInstanceName(value:String):void {
			__target = value;
			setTimeout(setTarget, 1);
		}
		
		protected function setTarget():void {
			_spellingHighlighter.target = parent.getChildByName(__target);
		}
		
		/** @copy com.gskinner.spelling.SpellingHighlighter#enabled */
		[Inspectable(defaultValue="true", type="Boolean")]	
		public function set enabled(value:Boolean):void {
			_spellingHighlighter.enabled = value;
		}
		
		/**
		 * Returns the SpellingHighlighter instance that was generated by this component. Use this
		 * to change properties or subscribe to events of the SpellingHighlighter.
		 *
		 * @see com.gskinner.spelling.SpellingHighlighter
		 */
		public function get spellingHighlighter():SpellingHighlighter {
			return _spellingHighlighter;
		}
		
	}
	
}