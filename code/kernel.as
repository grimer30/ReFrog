﻿package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.geom.Vector3D;
	import flash.utils.getDefinitionByName;
	
	public class kernel extends MovieClip {
		
		public var tiles = [];
		
		public function kernel() {
			// constructor code
			
			trace("Hello World (Kernel Constructor)");
			
			
			addEventListener(Event.ADDED_TO_STAGE, Loaded);
		}
		
		function Loaded(e:Event) {
			
			trace("Kernel Loaded!");
			
			this.removeEventListener(Event.ADDED_TO_STAGE, Loaded); // ensure Loaded events loads just once
			
			
			//create 2d array for tiles
			for (var i:int = 0; i < 11; i++) {
				tiles[i] = [];
			}
			
			GenerateLevel();
			
			//game timer
			var _period:Number = 1000/60;
			var gameTimer:Timer = new Timer(_period);
			
			gameTimer.addEventListener(TimerEvent.TIMER, Update);
			gameTimer.start();
		}
		
		function Update(e:Event){
			
			for (var y:int = 0; y < 10; y++) {
				for (var x:int = 0; x < 10; x++) {
					if (tiles[x][y].y < tiles[x][y].properPosition.y){
						tiles[x][y].y+= 10;
					}
				}
			}
			
		}
		
		function ToIsometric(inputX: Number, inputY: Number, yOffset: Number = 0){
			return new Vector3D(50+(inputX*0.6 + inputY*0.6)*100, (stage.stageHeight-400)-(inputX*-0.35 + inputY*0.35)*100, 0);
		}
		
		function PlaceTile(x: Number, y: Number, tileTypeName: String = "grassTile"){
			if (tiles[x][y]){
				stage.removeChild(tiles[x][y]);
				tiles[x][y]=null;
			}
			var tileTypeClass: Class = getDefinitionByName(tileTypeName) as Class;
			tiles[x][y] = new tileTypeClass();	
			tiles[x][y].x = ToIsometric(x, y).x;
			tiles[x][y].y = ToIsometric(x, y).y;
			
			tiles[x][y].SetProperPosition();
			tiles[x][y].y -= 1000;
			
			tiles[x][y].width = 120;
			tiles[x][y].height = 114.4;
			stage.addChild(tiles[x][y]);
		}
		
		function PlaceRiver(y: Number){
			for (var x:int = 0; x < 10; x++) {
				PlaceTile(x, y, "waterTile");
			}
		}
		
		function GenerateLevel(){
			var numberOfRivers: Number = Math.round(Math.random()*2)+1; //should be a number between 1 and 3
			for (var y:int = 0; y < 10; y++) {
				for (var x:int = 0; x < 10; x++) {
					PlaceTile(x, y, "grassTile");
				}
			}
			
			for (var y:int = 2; y < 8; y++) {//random between 2 and 7
				if(Math.random()>0.5){
					if(Math.random()>0.5){
						PlaceRiver(y);
					} else {
						//place road :)
					}
				}
				
			}
			//for (var r:int = 0; r < numberOfRivers; r++) {
			//	PlaceRiver(RandomNumberBetween(2, 7)); //places random rivers between y 2 and 7
			//}
			
			ArrangeTiles();
		}
		
		function ArrangeTiles(){
			for (var y:int = 0; y < 10; y++) {
				for (var x:int = 0; x < 10; x++) {
					if (tiles[x][y]){
						stage.setChildIndex(tiles[x][y], x);
					}
				}
			}
		}
		
		function RandomNumberBetween(Min: Number, Max: Number){
			return Math.round(Math.random()*(Max-Min))+Min;
		}
		
	}
	
}