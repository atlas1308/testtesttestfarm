package tzh.core{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
    public class SoundObject {

        protected var soundChannel:SoundChannel;
        protected var isPaused:Boolean = false;
        public var sound:Sound;
        protected var pausePoint:Number = 0;
        public var isMusic:Boolean = false;// 分为music,background sound
		
        public function SoundObject(sound:Sound, soundChannel:SoundChannel){
            this.sound = sound;
            this.soundChannel = soundChannel;
            this.soundChannel.addEventListener(Event.SOUND_COMPLETE, onComplete);
        }
        
        public function get volume():Number{
            return soundChannel.soundTransform.volume;
        }
        
        public function stop(value:Boolean = true):void{
            soundChannel.stop();
            if (value){
                sound.dispatchEvent(new Event(Event.SOUND_COMPLETE));
            }
        }
        
        public function play():void {
        	try {
        		if(isMusic){
	            	soundChannel = sound.play(pausePoint);
	            }else {
	            	soundChannel = sound.play(0,int.MAX_VALUE);
	            }
        	}catch(error:Error){
        		trace("play sound error " + error.message);
        	}
        	
        }
        
        public function set volume(value:Number):void{
            var soundTransform:SoundTransform = new SoundTransform(value, this.pan);
            soundChannel.soundTransform = soundTransform;
        }
        
        public function isPlaying():Boolean{
            return isPaused == false;
        }
        
        public function pause():void{
            if (isPaused == false){
                pausePoint = soundChannel.position;
                soundChannel.stop();
                isPaused = true;
            }
        }
        
        public function set pan(value:Number):void{
            var soundTransform:SoundTransform = new SoundTransform(this.volume, value);
            soundChannel.soundTransform = soundTransform;
        }
        
        public function unpause():void{
            if (isPaused){
                isPaused = false;
                
                pausePoint = 0;
            }
        }
        
        public function get pan():Number{
            return soundChannel.soundTransform.pan;
        }
        
        private function onComplete(event:Event):void{
            sound.dispatchEvent(new Event(Event.SOUND_COMPLETE));
        }
		
		/**
		 * sound.bytesTotal==0 说明加载出错了
		 * sound.bytesLoaded >= sound.bytesTotal 要加载完成时才能播放
		 * sound.bytesLoaded > 0 必须得加载了才能播放
		 */ 
		public static function getEnabled(value:Sound):Boolean {
			var result:Boolean;
			if(value.bytesTotal > 0){
				result = true;
			}
			return result;
		}
    }
}