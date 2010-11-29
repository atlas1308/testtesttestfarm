package tzh.core
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	public class SoundManager
	{
		protected var sounds:Dictionary = new Dictionary();
		
		private var activeChannels:Array = [];
		
		public function SoundManager()
		{
		}
		
		private static var soundManager:SoundManager;
		
		public static function getInstance():SoundManager {
			if(soundManager == null){
				soundManager = new SoundManager();
			}
			return soundManager;
		}
		
		public function addSound(key:String, path:String):Sound{
            var sound:Sound = sounds[key];
            if (sound == null){
                sound = new Sound();
                sound.addEventListener(Event.COMPLETE,onComplete);
                sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
                sound.load(new URLRequest(path));
                sounds[key] = sound;
            }
            return sound;
        }
        
        public function playSound(key:String,isMusic:Boolean = true):void {
        	var sound:Sound = this.getSoundByKey(key);
        	if(sound == null){
        		trace("please add sound by " + key);
        		return;
        	}
        	var soundObject:SoundObject = this.hasSoundObject(key);
        	if(soundObject){
        		soundObject.play();
        		return;
        	}

        	var soundChannel:SoundChannel;
        	try {
	        	if(isMusic){
	        		soundChannel = sound.play();
	        	}else {
	        		soundChannel = sound.play(0,int.MAX_VALUE);
	        	}
	        	soundObject = new SoundObject(sound,soundChannel);
	        	soundObject.isMusic = isMusic;
	        	var isExist:Boolean = activeChannels.indexOf(soundObject) >= 0;
	        	if(!isExist){
	        		activeChannels.push(soundObject);
	        	}
        	}catch(error:Error){
        		trace(error.message);
        	}
        }
        
        private function hasSoundObject(key:String):SoundObject {
        	var result:SoundObject;
        	var sound:Sound = getSoundByKey(key);
        	for each(var soundObject:SoundObject in activeChannels){
        		if(soundObject.sound.url == sound.url){
        			result = soundObject;
        			break;
        		}
        	}
        	return result;
        }
        	
        public function stopSound(key:String):void {
        	var soundObject:SoundObject;
            var sound:Sound = getSoundByKey(key);
            if(!sound)return;
            var index:int;
            while (index < activeChannels.length) {
                soundObject = activeChannels[index] as SoundObject;
                if (soundObject.sound.url == sound.url){
                    soundObject.stop();
                    break;
                }
                index++;
            }
        }
        
        public function stopAllMusic():void {
        	var soundObject:SoundObject;
            var index:int;
            while (index < activeChannels.length) {
                soundObject = activeChannels[index] as SoundObject;
                if (soundObject){
                    soundObject.stop();
                }
                index++;
            }
            activeChannels = [];
        }
        
        public function getSoundByKey(value:String):Sound {
        	return this.sounds[value] as Sound;
        }
        
        public function onComplete(event:Event):void {
        }
        
        private function onIOError(event:IOErrorEvent):void {
        	trace(event.text);
        }
	}
}