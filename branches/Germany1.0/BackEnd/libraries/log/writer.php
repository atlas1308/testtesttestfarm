<?php
defined('SYS_PATH') or die('No direct script access.');

/**
 * Log writer abstract class.
 *
 * @package    Ko
 * @author     Ko Team, Eric 
 * @version    $Id: writer.php 98 2009-10-09 04:03:35Z wangzh $
 * @copyright  (c) 2008-2009 Ko Team
 * @license    http://kophp.com/license.html
 */
abstract class Log_Writer
{
    /**
     * Write an array of messages.
     *
     * @param   array  messages
     * @return  void
     */
    abstract public function write (array $messages);

    /**
     * Allows the object to have a unique key in associative arrays.
     *
     * @return  string
     */
    final public function __toString ()
    {
        return spl_object_hash($this);
    }
} // End Log_Writer