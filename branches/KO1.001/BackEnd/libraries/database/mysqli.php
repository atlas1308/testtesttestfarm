<?php
defined('SYS_PATH') or die('No direct access allowed.');

require_once 'driver.php';
/**
 * MySQLi Database connection
 *
 * @package    Core
 * @author     Ko Team
 * @version    $Id: mysqli.php 498 2009-10-21 16:38:26Z wangzh $
 * @copyright  (c) 2008-2009 Ko Team
 * @license    http://kophp.com/license.html
 */
class Database_Mysqli extends Database_Driver
{

    // Database connection link
    protected $link;

    protected $db_config;

    protected $statements = array();

    /**
     * Sets the config for the class.
     *
     * @param  array  database configuration
     */
    public function __construct ($config)
    {
        $this->db_config = $config;
    }

    /**
     * Closes the database connection.
     */
    public function __destruct ()
    {
        is_object($this->link) and $this->link->close();
    }

    public function connect ()
    {
        // Check if link already exists
        if (is_object($this->link))
            return $this->link;
            // Import the connect variables
        extract($this->db_config['connection']);
        // Build the connection info
        $host = isset($host) ? $host : $socket;
        // Make the connection and select the database
        if ($this->link = new mysqli($host, $username, $password, $database, $port)) {
            if ($charset = $this->db_config['charset']) {
                $this->setCharset($charset);
            }
            // Clear password after successful connect
            $this->db_config['connection']['pass'] = NULL;
            return $this->link;
        }
        return FALSE;
    }

    public function query ($sql)
    {
        return new Mysqli_Result($this->link, $this->db_config['object'], $sql);
    }

    public function setCharset ($charset)
    {
        if ($this->link->setCharset($charset) === FALSE)
            throw new KoException('database.error', $this->show_error());
    }

    public function escape_str ($str)
    {
        is_object($this->link) or $this->connect();
        return $this->link->real_escape_string($str);
    }

    public function show_error ()
    {
        return $this->link->error;
    }
} // End Database_Mysqli_Driver Class

/**
 * MySQLi Result
 */
class Mysqli_Result extends Database_Result
{

    // Database connection
    protected $link;

    // Data fetching types
    protected $fetch_type = 'mysqli_fetch_object';

    protected $return_type = MYSQLI_ASSOC;

    /**
     * Sets up the result variables.
     *
     * @param  object    database link
     * @param  boolean   return objects or arrays
     * @param  string    SQL query that was run
     */
    public function __construct ($link, $object = TRUE, $sql)
    {
        $this->link = $link;
        if (! $this->link->multi_query($sql)) {
            // SQL error
            throw new KoException('database.error', $this->link->error . ' - ' . $sql);
        } else {
            $this->result = $this->link->store_result();
            // If the query is an object, it was a SELECT, SHOW, DESCRIBE, EXPLAIN query
            if (is_object($this->result)) {
                $this->current_row = 0;
                $this->total_rows = $this->result->num_rows;
                $this->fetch_type = ($object === TRUE) ? 'fetch_object' : 'fetch_array';
            } elseif ($this->link->error) {
                // SQL error
                throw new KoException('database.error', $this->link->error . ' - ' . $sql);
            } else {
                // Its an DELETE, INSERT, REPLACE, or UPDATE query
                $this->insert_id = $this->link->insert_id;
                $this->total_rows = $this->link->affected_rows;
            }
        }
        // Set result type
        $this->result($object);
        // Store the SQL
        $this->sql = $sql;
    }

    /**
     * Magic __destruct function, frees the result.
     */
    public function __destruct ()
    {
        if (is_object($this->result)) {
            $this->result->free_result();
            // this is kinda useless, but needs to be done to avoid the "Commands out of sync; you
            // can't run this command now" error. Basically, we get all results after the first one
            // (the one we actually need) and free them.
            if (is_resource($this->link) and $this->link->more_results()) {
                do {
                    if ($result = $this->link->store_result()) {
                        $result->free_result();
                    }
                } while ($this->link->next_result());
            }
        }
    }

    public function result ($object = TRUE, $type = MYSQLI_ASSOC)
    {
        $this->fetch_type = ((bool) $object) ? 'fetch_object' : 'fetch_array';
        // This check has to be outside the previous statement, because we do not
        // know the state of fetch_type when $object = NULL
        // NOTE - The class set by $type must be defined before fetching the result,
        // autoloading is disabled to save a lot of stupid overhead.
        if ($this->fetch_type == 'fetch_object') {
            $this->return_type = (is_string($type) and Ko::autoload($type)) ? $type : 'stdClass';
        } else {
            $this->return_type = $type;
        }
        return $this;
    }

    public function result_array ($object = NULL, $type = MYSQLI_ASSOC)
    {
        $rows = array();
        if (is_string($object)) {
            $fetch = $object;
        } elseif (is_bool($object)) {
            if ($object === TRUE) {
                $fetch = 'fetch_object';
                // NOTE - The class set by $type must be defined before fetching the result,
                // autoloading is disabled to save a lot of stupid overhead.
                $type = (is_string($type) and Ko::autoload($type)) ? $type : 'stdClass';
            } else {
                $fetch = 'fetch_array';
            }
        } else {
            // Use the default config values
            $fetch = $this->fetch_type;
            if ($fetch == 'fetch_object') {
                $type = (is_string($type) and Ko::autoload($type)) ? $type : 'stdClass';
            }
        }
        if ($this->result->num_rows) {
            // Reset the pointer location to make sure things work properly
            $this->result->data_seek(0);
            while ($row = $this->result->$fetch($type)) {
                $rows[] = $row;
            }
        }
        return isset($rows) ? $rows : array();
    }

    public function list_fields ()
    {
        $field_names = array();
        while ($field = $this->result->fetch_field()) {
            $field_names[] = $field->name;
        }
        return $field_names;
    }

    public function seek ($offset)
    {
        if ($this->offsetExists($offset) and $this->result->data_seek($offset)) {
            // Set the current row to the offset
            $this->current_row = $offset;
            return TRUE;
        }
        return FALSE;
    }

    public function offsetGet ($offset)
    {
        if (! $this->seek($offset))
            return FALSE;
            // Return the row
        $fetch = $this->fetch_type;
        return $this->result->$fetch($this->return_type);
    }
} // End Mysqli_Result Class

/**
 * MySQLi Prepared Statement (experimental)
 */
class Mysqli_Statement
{

    protected $link = NULL;

    protected $stmt;

    protected $var_names = array();

    protected $var_values = array();

    public function __construct ($sql, $link)
    {
        $this->link = $link;
        $this->stmt = $this->link->prepare($sql);
        return $this;
    }

    public function __destruct ()
    {
        $this->stmt->close();
    }

    // Sets the bind parameters
    public function bind_params ($param_types, $params)
    {
        $this->var_names = array_keys($params);
        $this->var_values = array_values($params);
        call_user_func_array(array($this->stmt , 'bind_param'), array_merge($param_types, $var_names));
        return $this;
    }

    public function bind_result ($params)
    {
        call_user_func_array(array($this->stmt , 'bind_result'), $params);
    }

    // Runs the statement
    public function execute ()
    {
        foreach ($this->var_names as $key => $name) {
            $$name = $this->var_values[$key];
        }
        $this->stmt->execute();
        return $this->stmt;
    }
}
