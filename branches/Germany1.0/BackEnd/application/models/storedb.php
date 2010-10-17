<?php
defined('SYS_PATH') OR die('No direct access allowed.');

/**
 * 商店模块
 *
 * @package Hello
 * @version $Id: storedb.php 325 2010-08-21 10:36:19Z wangzh $
 */
class StoreDBModel extends Model
{
    /**
     * 数据表名
     *
     * @var string
     */
    protected $_name = 'store';
    
    /**
     * 获得所有商品
     *
     * @return Object
     */
    public function getAllItems()
    {
        return $this->getSelectObj('*')
                       ->fetchObject();
                       
    }
    
    /**
     * 获得所有可以购买的商品
     *
     * @return Object
     */
    public function getAllBuyableItems()
    {
        return $this->getSelectObj('*')
                       ->where('buyable', 1)
                       ->fetchObject();
    }

    /**
     * 获得多个商品信息
     *
     * @param  str $id
     * @return Object
     */
    public function getStoresByIds($ids)
    {
        return $this->getSelectObj()->where('id', $ids)
                                    ->fetchObject();
    }

    /**
     * 获得某个商品信息
     *
     * @param  str $id
     * @return Object
     */
    public function getStoreById($id)
    {
        return $this->getSelectObj()->where('id', $id)
                                    ->fetchRow();
    }

    /**
     * 获得某个商品的二代商品（产物）
     *
     * @param  str $id
     * @return Object
     */
    public function getProductsById($id)
    {
    	$store = $this->getStoreById($id);
    	if(!$store || !$store->product) 
    	   return false;
        return $this->getSelectObj()->where('id', (array) $store->product)
                                    ->fetchObject();
    }


		/**
	 * 增加商品
	 *
	 * @param array $data
	 * @return 
	 */
	public function add($data){
		$store=array(
		    'id'           =>      $data['id'],
		    'name'         =>      $data['name'],
		    'type'         =>      $data['type'],
		    'kind'         =>      $data['kind'],
		    'desc'         =>      $data['desc'],
		    'url'          =>      $data['url'],
		    'exp'          =>      $data['exp'],
		    'level'        =>      $data['level'],
		    'map_object'   =>      $data['map_object'],
		    'buyable'      =>      $data['buyable'],
		    'price'        =>      $data['price'],
		    'size_x'       =>      $data['size_x'],
		    'size_y'       =>      $data['size_y'],
		    'sell_price'   =>      $data['sell_price'],
		    'collect_in'   =>      $data['collect_in'],
		    'buy_gift'     =>      $data['buy_gift'],
		    'stages'       =>      $data['stages'],
		    'constructible'=>      $data['constructible'],
		    'depth'        =>      $data['depth'],
		    'flipable'     =>      $data['flipable'],
		    'friends_needed'=>     $data['friends_needed'],
		    'giftable'     =>      $data['giftable'],
		    'gift_level'   =>      $data['gift_level'],
		    'gift_priority'=>      $data['gift_priority'],
		    'growing_percent'=>    $data['growing_percent'],
		    'is_multi`'    =>      $data['is_multi`'],
		    'is_tall'      =>      $data['is_tall'],
		    'need_animals' =>      $data['need_animals'],
		    'animal'       =>      $data['animal'],
		    'raw_material' =>      $data['raw_material'],     //raw_material
		    'max_animals'  =>      $data['max_animals'],
		    'max_instances'=>      $data['max_instances'],
		    'neighbors'    =>      $data['neighbors'],
		    'not_in_popup' =>      $data['not_in_popup'],
		    'object_needed'=>      $data['object_needed'],
		    'op'           =>      $data['op'],
		    'percent'      =>      $data['percent'],
		    'producer'     =>      $data['producer'],
		    'product_name' =>      $data['product_name'],
		    'materials'    =>      $data['materials'],
		    'product'      =>      $data['product'],          //product
		    'rp_price'     =>      $data['rp_price'],
		    'sell_for'     =>      $data['sell_for'],
		    'show_name'    =>      $data['show_name'],
		    'sprinkler'    =>      $data['sprinkler'],
		    'store_pos'    =>      $data['store_pos'],
		    'story'        =>      $data['story'],
		    'tall_object'  =>      $data['tall_object'],
		    'trade_for'    =>      $data['trade_for'],
		    'tree_spacing' =>      $data['tree_spacing'],
		    'upgradeable'  =>      $data['upgradeable'],
		    'upgrade_levels'=>     $data['upgrade_levels'],
		    'uses'         =>      $data['uses'],
		    'action'       =>      $data['action'],
		    'add_on'       =>      $data['add_on'],
		    'size'         =>      $data['size'],
		    'complete_size_x'=>    $data['complete_size_x'],
		    'complete_size_y'=>    $data['complete_size_y'],
 		);
 		return parent::insert($store);
	}
	
	/**
	 * 删除商品
	 *
	 * @param smallint(5) $id
	 * @return
	 */
	public function deleteStoreById($id){
		return parent::delete($this->getAdapter()->bind('id = ?',$id));
	}
	
	/**
	 * 更新商品信息
	 *
	 * @param smallint(5) $id
	 * @param array $setdata
	 * @return 
	 */
	public function updateStore($id, $setdata){
		$update=array();
		foreach ($setdata as $key => $val) {
			$update['key'] = addslashes(trim($val));
		}
		unset($setdata);
		$where=$this->getAdapter()->bind('id = ?',$id);
		return parent::update($update,$where);
	}

	/**
	 * 获取使用特定材料的物品
	 * @param $id
	 */
	public function getStoreWhoHasMaterial($id)
	{
		$where = $this->getAdapter()->bind('NOT ISNULL(materials)', null);
        $rows = $this->getSelectObj()->where($where)->fetchObject();
        if(! $rows) return false;
        foreach ($rows as $row) {
            $materials = unserialize($row->materials);
            foreach ($materials as $material) {
                if($material->id == $id)
                    return $row;
            }
        }
        return false;
	}
	
}
