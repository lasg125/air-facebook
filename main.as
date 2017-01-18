package {
	import flash.display.*;
	import flash.events.Event;
	import com.facebook;

	public class main extends Sprite{
		
		public var facebook:com.facebook;
		
		public function main():void{
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		public function init(e:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
	}
}