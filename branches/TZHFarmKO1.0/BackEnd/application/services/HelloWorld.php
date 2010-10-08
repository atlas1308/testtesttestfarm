<?php
/**
 * AMF Helloworld Service. 
 * @author Eric
 * @version $Id: HelloWorld.php 131 2010-07-17 06:52:54Z wangzh $
 */

class HelloWorld
{
    public function say($sMessage){
        return 'You said: ' . $sMessage;
    }

    public function ask ($ask) {
        return 'You ask: ' . $ask;
    }
    
    public function answer ($answer) {
        return 'You anser: ' . $answer;
    }
}
