package classes.utils.particles {

    public class SparkleParticle extends Particle {

        public function SparkleParticle(){
            super();
        }
        override protected function init():void{
            particle_skin = 2;
            super.init();
        }

    }
}
