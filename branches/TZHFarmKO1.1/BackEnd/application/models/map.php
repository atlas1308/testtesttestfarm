<?php
defined('SYS_PATH') OR die('No direct access allowed.');

/**
 * 地图模块
 *
 * @package Hello
 * @version $Id: map.php 357 2010-08-26 09:19:09Z dabin $
 */
class MapModel extends Model
{
    /**
     * 数据表名
     *
     * @var string
     */
    protected $_name = 'map';
    
    /**
     * 获得用户地图数量
     *
     * @param array $where
     * @return int
     */
    public function getUserMapCount($uid)
    {
        return $this->count('uid', $uid);
    }
    
    /**
     * 获得某个用户的地图列表
     *
     * @param int $uid
     * @return Object
     */
    public function getUserMapsByUid($uid)
    {
    	return $this->getSelectObj('itemid as id, map_x as x, map_y as y, flipped, start_time, animals, products, raw_materials, pollinated, automatic, times_used')
                       ->where('uid', $uid)
                       ->fetchObject();
    }
    
    /**
     * 获得用户的所有植物 （类型为 种子和树）

     * @param $uid
     * @return Object
     */
    public function getUserPlantsByUid($uid)
    {
    	$sqlQuery = 'SELECT m.id, m.uid, m.itemid, m.map_x, m.map_y, m.start_time, s.collect_in
                   FROM ' . $this->getTableName() . ' m
                   LEFT JOIN ' . $this->getTableName('store'). ' s ON m.itemid = s.id
                   WHERE m.uid=? AND s.type=\'trees\' OR s.type=\'seeds\'
               ';
        return $this->getAdapter()->query($sqlQuery, intval($uid))->fetchObject();
    }
    
    /**
     * 新增一个地图
     *
     * @param  array $data
     * @return int
     */
    public function add($data)
    {
    	$map = array(
            'uid'          => $data['uid'],
            'map_x'        => $data['map_x'],
            'map_y'        => $data['map_y'],
            'flipped'      => isset($data['flipped']) ? $data['flipped'] : 0,
            'raw_materials'=> isset($data['raw_materials']) ? $data['raw_materials'] : 0,
            'pollinated'   => isset($data['pollinated']) ? $data['pollinated'] : 0,
            'products'     => isset($data['products']) ? $data['products'] : 0,
            'itemid'       => $data['itemid'],
            'start_time'   => $data['start_time']
        );
        return parent::insert($data);
    }
    
    /**
     * 根据用户id和地块坐标更新地块信息
     * @param $uid
     * @param $map_x
     * @param $map_y
     * @param $setdata
     */
    public function updateMapItem($uid, $map_x , $map_y, $setdata)
    {
    	$updata = array();
        foreach ($setdata as $key => $val) {
           $updata[$key] = addslashes(trim($val)); 
        }
        unset($setdata);
        $where = $this->getAdapter()->bind('uid=? and map_x=? and map_y=?', array($uid, $map_x, $map_y));
        return parent::update($updata, $where);
    }
    
    /**
     * 批量更新地块信息
     * @param $uid
     * @param $itemid
     * @param $coords  地块坐标 array(0 => array('x' =>1,  'y' => 1), 1 => array('x' =>2, 'y' => 2))
     */
    public function batchUpdateMapItem($uid, $itemid, $coords, $starttime = 0 ) 
    {
        $updata = array(
            'itemid'       => $itemid,
            'pollinated '   => 0,
            'start_time'   => $starttime
        );
        $orwhere = array();
        foreach ($coords as $coord) {
            $orwhere[] = 'map_x=' .  intval($coord['x']) . ' AND map_y=' . intval($coord['y']);
        }
        $where = $this->getAdapter()->bind('uid=?', $uid) . ' AND ' . implode(' OR ', $orwhere);
        return parent::update($updata, $where); 
    }
        
    /**
     * 根据用户id和地块坐标增量更新地块信息
     * @param $uid
     * @param $map_x
     * @param $map_y
     * @param $setdata
     */
    public function increaseMapItem($uid, $map_x , $map_y, $setdata)
    {
    	if(!is_array($setdata)) return false;
    	$updata = array();
    	foreach ($setdata as $filed => $val) {
    		$updata[] = '`' . $filed . '`=`' . $filed . '`+\'' . $val . '\'';
    	}
    	$where = $this->getAdapter()->bind('uid=? and map_x=? and map_y=?', array($uid, $map_x, $map_y));
    	$sql = 'UPDATE `' . $this->getTableName() . '` SET ' . implode(',', $updata) . ' WHERE ' . $where;
    	$this->getAdapter()->query($sql);
    	return $setdata;
    }
    
    /**
     * 删除一个地图
     *
     * @param  array $uids
     * @return int 一般情况下是1
     */
    public function getMapItem($uid, $map_x , $map_y)
    {
    	$where = $this->getAdapter()->bind('uid=? and map_x=? and map_y=?', array($uid, $map_x, $map_y));
    	return $this->getSelectObj('itemid as id, map_x as x, map_y as y, flipped, start_time, animals, products, raw_materials, automatic, times_used')
                       ->where($where)
                       ->fetchRow();
    }

    /**
     *  增加地块
     * @param array $data 
     * @param string $uid
     * 
     */
    public function addObject($uid, $setdata) 
    {
    	$data = array(
    	    'uid'          =>  $uid,
    	    'map_x'        =>  $setdata['x'],
    	    'map_y'        =>  $setdata['y'], 
    	    'flipped'      =>  $setdata['flip'], 
    	    'animals'      =>  $setdata['animals'], 
    	    'itemid'       =>  isset($setdata['id']) && $setdata['id'] ? $setdata['id'] : 1,
    	    'start_time'   =>  isset($setdata['start_time']) && $setdata['start_time'] ? $setdata['start_time'] : 0,
    	);
    	return $this->add($data);
    }
    
    /**
     * 删除地块
     * 
     * @param $uid
     * @param $map_x
     * @param $map_y
     */
    public function removeObject($uid, $map_x, $map_y) 
    {
    	$where = $this->getAdapter()->bind('uid=? and map_x=? and map_y=?', array($uid, $map_x, $map_y));
    	return parent::delete($where);
    }
    
    /**
     * 移动地块
     * @param $uid
     * @param $oldCoor 旧坐标及属性
     * @param $newCoor
     */
    public function moveObject($uid, $oldCoor, $newCoor)
    {
        $updata = array(
            'map_x'     => $newCoor['map_x'],
            'map_y'     => $newCoor['map_y'],
            'flipped'   => $newCoor['flip']           
        );
        $where = $this->getAdapter()->bind('uid=? and map_x=? and map_y=?', array($uid, $oldCoor['map_x'], $oldCoor['map_y']));
        unset($oldCoor, $newCoor);
        return parent::update($updata, $where); 
    }
    
    /**
     * 种植作物
     * @param $uid
     * @param $map_x
     * @param $map_y
     * @param $itemid
     */
    public function addPlant($uid, $map_x, $map_y, $itemid, $start_time = 0) 
    {
        $updata = array(
            'itemid'       => $itemid,
            'start_time'   => $start_time
        );
        $where = $this->getAdapter()->bind('uid=? and map_x=? and map_y=?', array($uid, $map_x, $map_y));
    	return parent::update($updata, $where); 
    }
    
    /**
     * 添加动物
     * @param $uid
     * @param $map_x
     * @param $map_y
     * @param $num
     */
    public function addAnimals($uid, $map_x, $map_y, $num = 1) 
    {
    	return $this->increaseMapItem($uid, $map_x, $map_y, array('animals' => $num));         
    }
    
    /**
     * 添加饲料
     * @param $uid
     * @param $map_x
     * @param $map_y
     * @param $num
     */
    public function addMaterials($uid, $map_x, $map_y, $num = 1) 
    {
        return $this->increaseMapItem($uid, $map_x, $map_y, array('raw_materials' => $num));       
    }
    
    /**
     * 添加产品
     * @param $uid
     * @param $map_x
     * @param $map_y
     * @param $num
     */
    public function addProducts($uid, $map_x, $map_y, $num = 1) 
    {
        return $this->increaseMapItem($uid, $map_x, $map_y, array('products' => $num));        
    }

}
