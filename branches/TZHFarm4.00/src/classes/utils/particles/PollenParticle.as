package classes.utils.particles {

    public class PollenParticle extends Particle {

        public function PollenParticle(){
            super();
        }
        override protected function init():void{
            if (int((Math.random() * 2)) == 1){
                particle_skin = 9;
            } else {
                particle_skin = 10;
            };
            max_angle_delta = (Math.PI / 2);
            min_angle_delta = ((Math.PI / 2) - (Math.PI / 8));
            min_scale = 1;
            max_scale = 1.5;
            super.init();
            gravity = -2;
            time_scale = 1;
            life_time = 1000;
        }

    }
}
