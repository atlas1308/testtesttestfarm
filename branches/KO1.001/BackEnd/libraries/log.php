<?php 
defined('SYS_PATH') or die('No direct script access.');
/**
 * Message logging with observer-based log writing.
 *
 * @package    Ko
 * @author     Ko Team, Eric 
 * @version    $Id: log.php 634 2009-11-10 09:37:31Z wangzh $
 * @copyright  (c) 2008-2009 Ko Team
 * @license    http://kophp.com/license.html
 */
class Log 
{

    /**
     * @var  string  timestamp format
     */
    public static $timestamp = 'Y-m-d H:i:s';

    // Singleton static instance
    private static $_instance;

    // List of added messages
    private $_messages = array();

    // List of log writers
    private $_writers = array();

    /**
     * Get the singleton instance of this class and enable writing at shutdown.
     *
     * @return  Log
     */
    public static function instance()
    {
        if (self::$_instance === NULL) {
            // Create a new instance
            self::$_instance = new self;

            // Write the logs at shutdown
            register_shutdown_function(array(self::$_instance, 'write'));
        }

        return self::$_instance;
    }
    
    /**
     * Attaches a log writer.
     *
     * @param   object  Log_Writer instance
     * @param   array   messages types to write
     * @return  $this
     */
    public function attach(Log_Writer $writer, array $types = NULL)
    {
        $this->_writers["{$writer}"] = array (
            'object' => $writer,
            'types' => $types
        );

        return $this;
    }

    /**
     * Detaches a log writer.
     *
     * @param   object  Log_Writer instance
     * @return  $this
     */
    public function detach(Log_Writer $writer)
    {
        // Remove the writer
        unset($this->_writers["{$writer}"]);

        return $this;
    }

    /**
     * Adds a message to the log.
     *
     * @param   string  type of message
     * @param   string  message body
     * @return  $this
     */
    public function add($type, $message)
    {
        // Create a new message and timestamp it
        $this->_messages[] = array (
            'time' => date(self::$timestamp),
            'type' => $type,
            'body' => $message,
        );
        
        return $this;
    }

    /**
     * Write and clear all of the messages.
     *
     * @return  void
     */
    public function write ()
    {
        if (empty($this->_messages)) {
            // There is nothing to write, move along
            return;
        }
        // Import all messages locally
        $messages = $this->_messages;
        // Reset the messages array
        $this->_messages = array();
        foreach ($this->_writers as $writer) {
            if (empty($writer['types'])) {
                // Write all of the messages
                $writer['object']->write($messages);
            } else {
                // Filtered messages
                $filtered = array();
                foreach ($messages as $message) {
                    if (in_array($message['type'], $writer['types'])) {
                        // Writer accepts this kind of message
                        $filtered[] = $message;
                    }
                }
                // Write the filtered messages
                $writer['object']->write($filtered);
            }
        }
    }

    final private function __construct()
    {
        // Enforce singleton behavior
    }

    private function __clone()
    {
        // Enforce singleton behavior
    }

} // End Log