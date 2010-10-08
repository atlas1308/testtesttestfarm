<?php
defined('SYS_PATH') or die('No direct script access.');

/**
 * Model base class.
 *
 * @package    Model
 * @author     Ko Team, Eric 
 * @version    $Id: model.php 84 2009-10-30 09:08:01Z eric $
 * @copyright  (c) 2008-2009 Ko Team
 * @license    http://kophp.com/license.html
 */
abstract class Model
{

    /**
     * Database instance
     *
     * @var Database
     */
    protected $db = 'default';

    /**
     * The default table name
     */
    protected $_name = '';

    /**
     * Loads the database.
     *
     * @param   mixed  Database instance object or string
     * @return  void
     */
    public function __construct ($db = NULL)
    {
        if ($db !== NULL) {
            // Set the database instance name
            $this->db = $db;
        }
        if (is_string($this->db)) {
            $this->db = Database::instance($this->db);
        }
    }

    /**
     * Create a new model instance.
     *
     * @param   string   model name
     * @param   mixed    Database instance object or string
     * @return  Model
     */
    public static function factory ($name, $db = NULL)
    {
        return new $name($db);
    }

    /**
     * Count records by where cond.
     *
     * @param array|string $where
     * @return int
     */
    public function count ($where = array())
    {
        if(empty($where)) {
            return $this->db->count($this->_name);
        } else {
            return $this->db->where($where)->count($this->_name);
        }
    }

    /**
     * Return select object
     *
     * @return Database Object of db.
     */
    public function getSelectObj ($column = '*')
    {
        return $this->db->select($column)->from($this->_name);
    }

    /**
     * Insert a row.
     *
     * @param array $set
     * @return int
     */
    public function insert ($set = array())
    {
        return $this->db->insert($this->_name, $set);
    }

    /**
     * Update existing rows.
     *
     * @param array $set
     * @return int  The number affected rows.
     */
    public function update ($set = array(), $where = NULL)
    {
        return $this->db->update($this->_name, $set, $where);
    }

    /**
     * Deletes existing rows.
     *
     * @param  array|string $where SQL WHERE clause(s).
     * @return int          The number of rows deleted.
     */
    public function delete ($where = array())
    {
        return $this->db->delete($this->_name, $where);
    }

    /**
     * Gets the Database Adapter for this particular model object.
     *
     * @return Database
     */
    public function getAdapter ()
    {
        return $this->db;
    }
    
    /**
     * Return the table name.
     *
     * @return string
     */
    public function getTableName($table='')
    {
        return $table ? $this->db->tablePrefix() . $table : $this->db->tablePrefix() . $this->_name;
    }
    
    /**
     * Return the last query.
     *
     * @return string
     */
    public function getLastQuery()
    {
        return $this->db->getLastQuery();
    }
    
} // End Model
