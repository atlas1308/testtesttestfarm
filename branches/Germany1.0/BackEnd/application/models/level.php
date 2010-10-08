<?php
defined('SYS_PATH') OR die('No direct access allowed.');

/**
 * 等级模块
 *
 * @package Hello
 * @version $Id: level.php 304 2010-08-14 17:05:34Z wangzh $
 */
class LevelModel extends Model
{
    /**
     * 数据表名
     *
     * @var string
     */
    protected $_name = 'level';
    
    /**
     * 获得等级数量
     *
     * @param array $where
     * @return int
     */
    public function getLevelCount($where = array())
    {
        return $this->count($where);
    }
    
    /**
     * 新增一个等级
     *
     * @param  array $data
     * @return int
     */
    public function add($data)
    {
        $level = array(
            'level'        => $data['level'],
            'min_exp'      => $data['min_exp'],
            'max_exp'      => $data['max_exp']
        );
        return parent::insert($level);
    }

    /**
     * 获得所有等级数据
     * @return OBJECT
     */
    public function getAllLevels()
    {
        return $this->getSelectObj()->fetchObject();
    }
    
    /**
     * 通过EXP获得等级信息
     *
     * @param  int
     * @return Object
     */
    public function getLevelByExp($exp)
    {
        $row = $this->getSelectObj()->where('max_exp > ' . intval($exp))
                                    ->limit(1)
                                    ->order('level', 'ASC')
                                    ->fetchRow();
        return ($row && $row->level > 0) ? $row->level : 1;
            
    }

    /**
     * 更新等级信息
     *
     * @param int $id
     * @param array $setdata
     * @return bool
     */
    public function updateLevel($level, $exp)
    {
        $where = $this->getAdapter()->bind('level=?', $level);
        return parent::update(array('exp' => intval($exp)), $where);
    }
    
}
