package
{
	import flash.display.Loader;
	import flash.display.MovieClip
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import citrus.core.starling.StarlingCitrusEngine;
	[SWF(frameRate = "60", height="600", width="1200")]
	
	public class NelliganGame extends StarlingCitrusEngine
	{
		// class poroperties - the keyword 'private' means it is only available to the code iniside this class
		private var loader:Loader;
		//constructor
		public function NelliganGame()
		{
			sound.addSound('jump',{sound:"../assets/sounds/heroJump.mp3"})
			sound.addSound('bgScore',{sound:"../assets/sounds/katiesScore.mp3", loops:-1, volume:0.5});
			setUpStarling(true);// to see the statics for memory usage and frame rate of the game--- set it to 'false' before making your game public
			loader = new Loader();// Loader is the displayContainer that can load external assets like png,jpg images and swf files.
			loader.load(new URLRequest("../flash/level.swf"));// giving it the path to the swf file location relative to this file position
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, start);//When the uploading of the swf file is completed then we execute the 'start' method
			// loading sound
			
				
			
		}
		
		protected function start(event:Event):void
		{
			state = new StartGame(MovieClip(event.target.content));// our custom made class requires one parameter of dataType MovieClip (swf) that we imported through Loader
			//some clean of the memory
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, start);
			loader.unloadAndStop(true);
		}
	}
}