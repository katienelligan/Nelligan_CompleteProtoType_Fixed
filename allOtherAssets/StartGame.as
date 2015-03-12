
package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import Box2D.Dynamics.Contacts.b2PolygonContact;
	
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Coin;
	import citrus.objects.platformer.box2d.Crate;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.MovingPlatform;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2D;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.utils.objectmakers.ObjectMaker2D;
	
	import dragonBones.Armature;
	import dragonBones.factorys.StarlingFactory;

//need this for the total area that a camera can cover 
	
	// The decleartion of the class
	public class StartGame extends StarlingState	{
		// class properties also known as varialbes
		private var hero:Hero;
		private var p:Box2D;
		private var sensor:Sensor;
		
		private var flashSwfFile:MovieClip; // Because this variable is decleared outside of any function, it is availabe to all the functions and code in this class
		
		
		//importing and embedding dragonbones animation file
		[Embed(source="../assets/dragonBones/birdyDragonBonesAnimation.png", mimeType="application/octet-stream")]
		private var heroPngXml:Class;
		// constructor function -- this function is the first one that gets executed when a new instance of this class is created--> in the Main class we 
		//made an instance of this class as --- state = new TestState(MovieClip(event.target.content));
		private var setHeroOrigPos:Boolean = false;
		
		public function StartGame(movieClipVarable:MovieClip)// Here we are passing an argument (parameter) whose dataType is MovieClip to the constructor method
		{
			super();// the parent consturctor is executed
			flashSwfFile = movieClipVarable;// This will make the flashSwfFile is used in the code to be treated as (or equal to ) the constructor parameter movieClipVariable
			var objDefinition:Array  =[Hero,Sensor,MovingPlatform,Platform,CitrusSprite,Coin,Crate];//
			
		}
		override public function initialize():void{
			super.initialize();// runs the super class initalize() method ---> StarlingState.initialize() and sets eveything like Timer, tick animation, updating etc
			
			//Form this onward we are creating our own instructions for the intialize method and thus tailiroing it to our needs.
			
			// starting the physics world fo Box2D	
			p = new Box2D('p' );
			add(p);// adding it to the DisplayList
			//p.visible = true; // Turning off the default Box2D objects view. To see the default view overlayed on the game graphics set it to true
			//trace("physics is working"); 
			
			ObjectMaker2D.FromMovieClip(flashSwfFile);
			
			
			//hero = getFirstObjectByType(Hero) as Hero;// If we have decleared the instance name for the Hero symbol, we can access it through getObjectByName(instanceName:String) method
			hero = Hero(getObjectByName('birdy'));
			hero.maxVelocity = 5;
			
			
			
			//Adding DragonBone animation -note: we are using inline function here
			var armature:Armature; // the dragonbone armature
			var factory:StarlingFactory = new StarlingFactory();
			factory.parseData(new heroPngXml);
			factory.addEventListener(Event.COMPLETE, function(event:Event):void{
				armature = factory.buildArmature("allAnimation"); // passing the name of our animation file in parameter
				
				hero.view = armature;
			});
			
			
			//playing sound
			_ce.sound.playSound('bgScore');
			
			hero.onJump.add(function():void{
						_ce.sound.playSound('jump');
						trace("jpmp");  
			});
			
			//setting up the camera so it is always traveling with the hero in the middle
			view.camera.setUp(hero,new Rectangle(0,0,2000,800),new Point(.5,.5),new Point(0.5,0.025));
			
			// to reset the hero position when it falls down to where it started, we use teleporter
			
			
			// Resetting the hero position when it comes in contact with Sensor object
			sensor = Sensor(getObjectByName('ground'));
			sensor.onBeginContact.add(heroReset);
			
		}
		
		private function heroReset(cb:b2PolygonContact):void   
		{
			if(Box2DUtils.CollisionGetOther(sensor,cb) is Hero  ){
			setHeroOrigPos = true;
			}
			
		}//end of initialize method
		// things to do when hero jumps
		
		override public function update(timeDelta:Number):void{
			super.update(timeDelta);
			if (setHeroOrigPos){
				hero.x = 337;
				hero.y = -70;
			}
			setHeroOrigPos = false;
			
		}
	}//end of class body
}// end of package


