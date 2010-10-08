<?php
defined('SYS_PATH') OR die('No direct access allowed.');

/**
 * 商店模块
 *
 * @package Hello
 * @version $Id: store.php 265 2010-08-07 16:58:18Z wangzh $
 */
class StoreModel
{
    /**
     * 数据
     *
     * @var string
     */
    private $data = array();
    
    /**
     * 获得所有商品
     *
     * @return Object
     */
    public function getData()
    {
    	if ($this->data) 
    	   return (object) $this->data;
    	
    	$data =  Ko::config('store');
    	$this->data = (array) $data;
    	return $data;
    }

    /**
     * 获得某个商品信息
     *
     * @param  str $id
     * @return Object
     */
    public function getStoreById($id)
    {
    	$this->data || $this->getData();
    	
    	return isset($this->data[$id]) ? $this->data[$id] : null;
    }
    
    /**
     * 获得多个商品信息
     *
     * @param  str $id
     * @return Object
     */
    public function getStoresByIds($ids)
    {
        $this->data || $this->getData();
        $ret = array();
        foreach ((array) $ids as $id) {
        	if( ! isset($this->data[$id])) continue;
        	$ret[$id] = $this->data[$id];
        }
        return $ret;
    }
    
    /**
     * 获得某个商品的二代商品（产物）
     *
     * @param  str $id
     * @return Object
     */
    public function getProductsById($id)
    {
    	$this->data || $this->getData();
    	
    	$store = $this->getStoreById($id);
    	if(!$store || !isset($store->product)) 
    	   return false;
    	   
    	return $this->getStoresByIds((array) $store->product);
    }
}
