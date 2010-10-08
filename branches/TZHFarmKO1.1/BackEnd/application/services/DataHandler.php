<?php
/**
 * AMF DataHandler Service.
 * @author Eric
 * @version $Id: DataHandle.php 189 2010-07-21 13:36:27Z wangzh $
 */

class DataHandler
{
	private $input;

	private $uid;

	protected $data_hash;

	protected $debug = true;
	protected $demsg = array();

	const MAX_PRODUCTS = 3;    // 最大产品数
	const HELP_COINS = 20;     // 帮邻居浇地的奖励
	const HELP_XP = 5;
	const HELP_TIME =  86400;  //帮助时间间隔


	/**
	 * AMF DataHandler.
	 *
	 * @param string $method
	 * @param object $data
	 * @param string $channel
	 */
	public function handle($method, $input, $channel){
		$this->input = $input;
		$this->uid = isset($this->input->fb_sig_user) ? (string) $this->input->fb_sig_user : '703118330';

		switch ($method) {
			case 'retrieve_data':
				return $this->retrieveData($channel);
				break;

			case 'execute_batch':
				return $this->executeBatch($channel);
				break;

			case 'load_farm':
				return $this->loadFarm($channel);
				break;

		}
		return null;
	}


	/**

	*/
	private function retrieveData($channel = null)
	{
		$ret = array (
			'channel' => $channel,
			'time' => time(),
		);
		// Load config
		$config = new ConfigModel();
		$ret['config'] = $config->getConfig();
		unset($config);

		// Load levels
		$level = new LevelModel();
		$levels = array();
		foreach($level->getAllLevels() as $level) {
			$levels[$level->level] = array('min' => $level->min_exp, 'max' => $level->max_exp);
		}
		$ret['config']->levels = (object) $levels;
		unset($level, $levels);

		// Load Store Data
		$store = new StoreModel();
		$ret['config']->store = $store->getData();
		unset($store);

		$ret['data'] = new stdClass;
		$ret['data']->state = 'ok';
		$ret['data']->call_id = isset($this->input->call_id) ? substr($this->input->call_id, 4) : microtime();
		$ret['data']->base_url = 'http://farm.lf3g.com/static/';
		$ret['data']->app_url = 'http://apps.facebook.com/countrylife/';
		$ret['data']->assets_urls = array(
            'http://farm.lf3g.com/static/',
		);
		$ret['data']->data_hash = md5(rand(100, 10000));
		Session::instance()->set('data_hash', $ret['data']->data_hash);

		$ret['data']->swf_version =  isset($this->input->swf_version) ? $this->input->swf_version : 85;
		$ret['data']->map = array();
		$ret['data']->storage = array();
		$ret['data']->gift = array();
		$ret['data']->neighbors = array();
		$ret['data']->all_neighbors = array();

		// Check User wether inited.
		$user = new UserModel();
		$userinfo =  $user->getUserById($this->uid);
		if ($userinfo) {
			// Load User Maps
			$ret['data']->map = $this->getUserMaps($this->uid);

			// Load User storage
			$storage = new StorageModel();
			$storages = array();
			foreach($storage->getUserStoragesByUid($this->uid) as $storage) {
				$storages[$storage->itemid] = $storage->num;
			}
			$ret['data']->storage = (object) $storages;
			unset($storage, $storages);

			// Load User Gifts
			$gift = new GiftsModel();
			$ret['data']->gift = $gift->getNewGiftByUid($this->uid);
			unset($gift);

			// Load User Neighbors
			$neighbor = new NeighborsModel();
			$ret['data']->neighbors = $neighbor->getNeighborsByUid($this->uid);
			$allNeighbors = $neighbor->getAllNeighborIdByUid($this->uid);
			$ret['data']->all_neighbors  = array();
			foreach ($allNeighbors as $neighbor) {
				$ret['data']->all_neighbors[] = $neighbor->nuid;
			}
			unset($neighbor, $allNeighbors);

			$ret['data']->show_tutorial = 0;

			//TODO
			$ret['data']->coins = $userinfo->coins;
			$ret['data']->items = array();
			$ret['data']->level = $this->checkUserLevel($this->uid, $userinfo->level, $userinfo->experience);
			$ret['data']->experience = $userinfo->experience;
			$ret['data']->size_x = $userinfo->size_x;
			$ret['data']->size_y = $userinfo->size_x;
			$ret['data']->reward_points = $userinfo->reward_points;
			$ret['data']->op = $userinfo->op;
			$ret['data']->top_map_size = $userinfo->top_map_size;
			$ret['data']->max_work_area_size = $userinfo->max_work_area_size;
			$ret['data']->work_area_size = $userinfo->work_area_size;
			$ret['data']->lottery_coins = $userinfo->lottery_coins;
			$ret['data']->feed_data = false;
			$ret['data']->news = false;
			$ret['data']->show_gifts_page = false;
			$ret['data']->stories = array();

			$ret['data']->items_received = array();
			$ret['data']->ask_for_materials = array();
			$ret['data']->ask_for_help = array();
			$ret['data']->friend_helped =  false;
			$ret['data']->gifts_received = array();
		} else {
			$data = array(
        	   'uid'           => $this->uid,
        	   'uname'         => $this->uid,      //TODO
        	   'email'         => '',
        	   'plat_uid'      => $this->uid,
        	   'level'         => 1,
        	   'experience'    => 0,
        	   'coins'         => 50000, //500, 
        	   'op'            => 0,
        	   'reward_points' => 50000,  //1,
        	   'logintime'     => date('Y-m-d H:i:s'),
        	   'loginip'       => '',
        	   'status'        => 1,
			);
			$user->add($data);
			$ret['data']->show_tutorial = 1;
			//TODO
			$ret['data']->coins = 50000;
			$ret['data']->items = array();
			$ret['data']->level = 1;
			$ret['data']->experience = 0;
			$ret['data']->size_x = 60;
			$ret['data']->size_y = 60;
			$ret['data']->reward_points = 50000;
			$ret['data']->op = 0;
			$ret['data']->top_map_size = 0;
			$ret['data']->max_work_area_size = 1;
			$ret['data']->work_area_size = 1;
			$ret['data']->lottery_coins = 0;
			$ret['data']->feed_data = false;
			$ret['data']->news = false;
			$ret['data']->show_gifts_page = false;
			$ret['data']->stories = array();

			$ret['data']->items_received = array();
			$ret['data']->ask_for_materials = array();
			$ret['data']->ask_for_help = array();
			$ret['data']->friend_helped = false;
			$ret['data']->gifts_received = array();

			//
			$mapData = $this->initUserMapData();
			$ret['data']->map = $mapData;
		}

		unset($model);
		if($this->debug) $ret['demsg'] = $this->demsg;
		return $ret;
	}

	/*
	 * TODO
	 * save_data 数据临时处理
	 */
	private function executeBatch($channel = null)
	{
		$this->data_hash = Session::instance()->get('data_hash');

		$ret = new stdClass();
		$ret->channel = trim($channel);
		$ret->swf_version = $this->input->swf_version;
		if(isset($this->input->data_hash) && $this->data_hash != $this->input->data_hash) {
			$ret->state = 'not ok';
			return ;
		}
		$ret->data_hash = $this->input->data_hash;
		$ret->state = 'ok';
		$ret->call_id = isset($this->input->call_id) ? substr($this->input->call_id, 4) : microtime();
		$ret->feed_data = false;

		$objects_to_update = array();
		$nowTime = time();

		switch (trim($channel)) {
			case 'save_data':
				if( ! $this->input->queue || ! is_array($this->input->queue) ) break;
				foreach ($this->input->queue as $queue) {
					if(isset($queue->data->data_hash) && $this->data_hash != $queue->data->data_hash) {
						$ret->state = 'not ok';
						return ;
					}
					switch ($queue->method) {
						// 增加地块
						case 'add_object':
							// id=1 , y, x, flip, is_gift
							// 获得添加地块信息 价格和奖励经验
							$updata = array(
                                'id'        => $queue->data->id, 
                                'x'         => $queue->data->x, 
                                'y'         => $queue->data->y, 
                                'flip'      => $queue->data->flip,
                                'animals'   => 0
							);

							$store = new StoreModel();
							$item = $store->getStoreById($queue->data->id);
							$exp = isset($item->exp) ? $item->exp : 0;
							$price = isset($item->price) ? $item->price : 0;
							$rp = isset($item->rp_price) ? $item->rp_price : 0;
							if((isset($item->type) && $item->type == "animals") || (isset($item->kind) && $item->kind == "chicken_coop")) {
								$updata['animals'] = 1;
							}
							if(isset($item->type) && $item->type == "trees") {
								$updata['start_time'] = $nowTime;
							}
							$this->debugMsg($store->getLastQuery());
							unset($store, $item);

							// 添加地块
							$map = new MapModel();
							$map->addObject($this->uid, $updata);
							$this->debugMsg($map->getLastQuery());
							unset($map);

							// 更新用户信息
							$user = new UserModel();
							//TODO  by dabin
							$reward_points = (0 - $rp);
							if ($reward_points<0) $reward_points = 0;
							//$user->increaseUserData($this->uid, array('coins' => (0 - $price), 'experience' => $exp, 'reward_points' => (0 - $rp)));
							$user->increaseUserData($this->uid, array('coins' => (0 - $price), 'experience' => $exp, 'reward_points' => $reward_points ));
							$this->debugMsg($user->getLastQuery());

							// TODO is_gift 如果是礼物，则更新用户礼物  is_gift
							break;

							// 删除地块
						case 'remove_object':
							// id 种植物ID, y, x, flip, data_hash
							// 获得卖地及动物的价格，更新用户信息
							$price = $this->getMapItemSellPrice($this->uid, $queue->data->x, $queue->data->y);
							$this->debugMsg('Sell price: ' . $price);
							$user = new UserModel();
							$user->increaseUserData($this->uid, array('coins' => $price));
							$this->debugMsg($user->getLastQuery());
							unset($user);

							$map = new MapModel();
							$map->removeObject($this->uid, $queue->data->x, $queue->data->y);
							$this->debugMsg($map->getLastQuery());
							unset($map);
							break;

							// 移动地块
						case 'move_object':
							// id 种植物ID, data_hash
							// x, y, flip,
							// new_x, new_y, flipped
							$old = array(
        					   'map_x' => $queue->data->x, 
        					   'map_y' => $queue->data->y
							);
							$new = array(
        					   'map_x' => $queue->data->new_x, 
        					   'map_y' => $queue->data->new_y,
        					   'flip'  => $queue->data->flipped,
							);
							$map = new MapModel();
							$map->moveObject($this->uid, $old, $new);
							$this->debugMsg($map->getLastQuery());
							unset($map);
							break;

							// 种地
						case 'add_plant':
							// unique_id, soil_x, soil_y, plant_id 种植物ID
							// + 1xp
							$store = new StoreModel();
							$item = $store->getStoreById($queue->data->plant_id);
							$exp = isset($item->exp) ? $item->exp : 0;
							$price = isset($item->price) ? $item->price : 0;
							unset($item);

							$map = new MapModel();
							$map->addPlant($this->uid, $queue->data->soil_x, $queue->data->soil_y, $queue->data->plant_id, $nowTime);
							$this->debugMsg($map->getLastQuery());
							unset($map);

							// 更新用户信息
							$user = new UserModel();
							$user->increaseUserData($this->uid, array('experience' => $exp, 'coins' => (0 - $price)));
							$this->debugMsg($user->getLastQuery());
							break;

							// 收获
						case 'collect_product':
							// id 种植物ID, unique_id, x, y
							//保存产品(传递的参数为种植物ID，要转化为产品ID)
							$store = new StoreModel();
							$products = $store->getProductsById($queue->data->id);
							if(!$products) break;
							$storage = new StorageModel();
							foreach ($products as $product) {
								$storage->addItemNumByUidAndItemid($this->uid, $product->id, 1);
							}
							unset($storage);

							// TODO 如果是动物或鸡圈
							$row = $store->getStoreById($queue->data->id);
							//if ($row->type == "animals" || $row->kind == "chicken_coop") {
							if((isset($row->type) && $row->type == "animals") || (isset($row->kind) && $row->kind == "chicken_coop")) {
								// 判断是否有饲料，有则更新start_time 为当前时间，否则更新为 0
								$map = new MapModel();
								$item = $map->getMapItem($this->uid, $queue->data->x, $queue->data->y);
								$updata = array();
								$collect_in = $row->collect_in / ($item->animals ? $item->animals : 1);

								$updata = array(
                                    'products' => ($item->products > 0 ? $item->products - 1 : 0), 
                                    'raw_materials' => ($item->products == 0 ? ($item->raw_materials - 1 >= 0 ? $item->raw_materials - 1 : 0) : $item->raw_materials) , 
                                    'start_time' => ($item->products >= self::MAX_PRODUCTS ? $nowTime : ($item->products >0 && $item->products < self::MAX_PRODUCTS ? $item->start_time : $item->start_time + $collect_in))
								);
								$map->updateMapItem($this->uid, $queue->data->x, $queue->data->y, $updata);
								$this->debugMsg($map->getLastQuery());

								// 自动收获扣OP
								if($item->automatic) {
									$user = new UserModel();
									$user->increaseUserData($this->uid, array('reward_points' => -1));
									$this->debugMsg($user->getLastQuery());
									unset($user);
								}
								unset($map, $item);
							}
							if($row->type == "trees") {
								$map = new MapModel();
								$map->updateMapItem($this->uid, $queue->data->x, $queue->data->y, array('start_time' => $nowTime));
								$this->debugMsg($map->getLastQuery());
								unset($map);
								$objects_to_update[$queue->data->unique_id] = array(
                                    'unique_id' => $queue->data->unique_id,
                                    'start_time' => $nowTime
								);
							}
							if($row->type != 'seeds') break;
							//清空地块
							$map = new MapModel();
							$setdata = array(
                                'itemid' => 1,
                                'pollinated' => 0,
                                'start_time' => 0
							);
							$map->updateMapItem($this->uid, $queue->data->x, $queue->data->y, $setdata);
							$this->debugMsg($map->getLastQuery());
							unset($map);
							break;

							// 卖出产品
						case 'sell_storage_item':
							// id:产品ID, qty:数量, data_hash
							//更新用户数据
							$store = new StoreModel();
							$data = $store->getStoreById($queue->data->id);
							$updata = array('coins' => $data->sell_for * $queue->data->qty, 'experience' => $data->exp * $queue->data->qty );
							$user = new UserModel();
							$user->increaseUserData($this->uid, $updata);
							unset($store, $user);

							$storage = new StorageModel();
							$num = $storage->updateItemNumByUidAndItemid($this->uid, $queue->data->id, 0);
							unset($storage);
							break;

							// 卖出全部产品
						case 'sell_all_storage':
							// id:产品ID, qty:数量, data_hash
							// 获得仓库数据
							$storage = new StorageModel();
							$products = $storage->getUserStoragesByUid($this->uid);
							$this->debugMsg($storage->getLastQuery());
							if(!$products) break;
							//更新用户数据
							$itemids = $prodNums = array();
							foreach ($products as $product) {
								$itemids[] = $product->itemid;
								$prodNums[$product->itemid] = $product->num;
							}
							unset($products);
							$store = new StoreModel();
							$items = $store->getStoresByIds($itemids);
							$updata = array('coins' => 0, 'experience' => 0 );
							foreach ($items as $item) {
								if( isset($item->sell_for) && $item->sell_for) {
									$updata['coins'] += $item->sell_for * $prodNums[$item->id];
								}
								if( isset($item->exp) && $item->exp) {
									$updata['experience'] += $item->exp * $prodNums[$item->id];
								}
							}
							unset($item, $items);
							$user = new UserModel();
							$user->increaseUserData($this->uid, $updata);
							$this->debugMsg($user->getLastQuery());
							unset($store, $user);

							// 清空用户仓库
							$storage->updateStorageByUid($this->uid, array('num' => 0));
							$this->debugMsg($storage->getLastQuery());
							unset($storage);
							break;

							// 添加动物
						case 'add_animal':
							// id:动物ID, x, y, is_gift, data_hash
							$map = new MapModel();
							$map->addAnimals($this->uid, $queue->data->x, $queue->data->y);
							$this->debugMsg($map->getLastQuery());
							unset($map);

							// 获取添加的动物的信息（价格/经验值）
							$store = new StoreModel();
							$item = $store->getStoreById($queue->data->id);
							$exp = isset($item->exp) ? $item->exp : 0;
							$price = isset($item->price) ? $item->price : 0;
							$this->debugMsg($user->getLastQuery());
							unset($store, $item);

							// 更新用户信息
							$user = new UserModel();
							$user->increaseUserData($this->uid, array('coins' => (0 - $price), 'experience' => $exp));
							$this->debugMsg($user->getLastQuery());
							//TODO is_gift
							break;

							// 喂养动物
						case 'feed_object':
							// id 动物ID, unique_id, x, y
							$userIncrease = array();
							$map = new MapModel();
							$map->addMaterials($this->uid, $queue->data->x, $queue->data->y);

							// 如果是第一次喂养，更新start_time
							$item = $map->getMapItem($this->uid, $queue->data->x, $queue->data->y);
							if($item->start_time == 0) {
								$map->increaseMapItem($this->uid, $queue->data->x, $queue->data->y, array('start_time' => $nowTime));
								$objects_to_update[$queue->data->unique_id] = array(
	                                'unique_id' => $queue->data->unique_id,
	                                'start_time' => $nowTime
								);
							}
							$this->debugMsg($map->getLastQuery());
							// 自动收获扣OP
							if($item->automatic) {
								$userIncrease['reward_points'] = -1;
							}
							unset($map, $item);

							// 更新用户仓库
							$store = new StoreModel();
							$item = $store->getStoreById($queue->data->id);
							$raw_material = isset($item->raw_material) ? $item->raw_material : 0;
							$userIncrease['experience'] = isset($item->exp) ? $item->exp : 0;
							unset($store, $item);

							$storage = new StorageModel();
							$storage->addItemNumByUidAndItemid($this->uid, $raw_material, -1);
							unset($storage);

							// 更新用户信息 exp
							$user = new UserModel();
							$user->increaseUserData($this->uid, $userIncrease);
							unset($user);
							break;

							// 给好友浇地 更新用户经验和金币，更新邻居的信息 “已浇地”
						case 'water_plants':
							// id = 1056248390 邻居的uid
							$user = new UserModel();
							$user->increaseUserData($this->uid, array('coins' => self::HELP_COINS, 'experience' => self::HELP_XP));
							unset($user);

							$neighbor = new NeighborsModel();
							$neighbor->updateNeighbour($this->uid, (string) $queue->data->id, array('last_help_time' => $nowTime));
							unset($neighbor);
							break;

						case 'pollinate':
							// id , plant_id, plant_x, plant_y, x, y 后两个为蜜蜂的坐标，用来更新饲料数
							$map = new MapModel();
							$map->updateMapItem($this->uid, $queue->data->plant_x, $queue->data->plant_y, array('pollinated' => 1));
							$this->debugMsg($map->getLastQuery());

							$updata = array('raw_materials' => 1);
							// 如果是第一次采蜜，更新start_time
							$item = $map->getMapItem($this->uid, $queue->data->x, $queue->data->y);
							if($item->start_time == 0) {
								$updata['start_time'] = $nowTime;
							}
							$this->debugMsg($map->getLastQuery());
							$map->increaseMapItem($this->uid, $queue->data->x, $queue->data->y, $updata);
							$this->debugMsg($map->getLastQuery());
							unset($map);
							break;

						case 'toggle_automation':
							// id, x, y 后两个为蜜蜂的坐标，用来更新饲料数
							$map = new MapModel();
							$item = $map->getMapItem($this->uid, $queue->data->x, $queue->data->y);
							$automatic = $item->automatic ? 0 : 1;
							$map->updateMapItem($this->uid, $queue->data->x, $queue->data->y, array('automatic' => $automatic));
							$this->debugMsg($map->getLastQuery());
							unset($map, $item);
							break;

							// 批量种植  要扣op的
						case 'plant_seeds':
							$store = new StoreModel();
							$item = $store->getStoreById($queue->data->seed);
							$exp = isset($item->exp) ? $item->exp : 0;
							$price = isset($item->price) ? $item->exp : 0;
							unset($item);

							$map = new MapModel();
							$map->batchUpdateMapItem($this->uid, $queue->data->seed, $queue->data->soil, $nowTime);
							$this->debugMsg($map->getLastQuery());
							unset($map);

							// 更新用户信息
							$num = count($queue->data->soil);
							$user = new UserModel();
							$user->increaseUserData($this->uid, array('experience' => $exp * $num, 'coins' => (0 - $price) * $num, 'op' => ( 0 - $num)));
							$this->debugMsg($user->getLastQuery());
							break;

							// 批量收获  要扣op的
						case 'harvest_plants':
							// 按产品规整
							$itemids = $coords = array();
							foreach ($queue->data->plants as $plant) {
								$itemids[$plant['id']] = isset($itemids[$plant['id']]) ? $itemids[$plant['id']] + 1 : 1;
								$coords[] = array(
        					       'x' => $plant['x'],
        					       'y' => $plant['y']
								);
							}
							unset($queue->data->plants, $plant);

							foreach ($itemid as $itemid => $count){
								// 收货
								$store = new StoreModel();
								$products = $store->getProductsById($queue->data->id);
								if(!$products) break;
								$storage = new StorageModel();
								foreach ($products as $product) {
									$storage->addItemNumByUidAndItemid($this->uid, $product->id, $count);
								}
								unset($storage);
							}

							//清空地块
							$map = new MapModel();
							$map->batchUpdateMapItem($this->uid, 1, $coords);
							$this->debugMsg($map->getLastQuery());
							unset($map);
							// 更新用户
							$num = count($coords);
							$user = new UserModel();
							$user->increaseUserData($this->uid, array('op' => ( 0 - $num)));
							$this->debugMsg($user->getLastQuery());
							break;

						case 'spend_rp':
							// id
							$store = new StoreModel();
							$item = $store->getStoreById($queue->data->id);
							$userIncrease = array();
							switch ($item->type) {
								case 'special_events':
									switch ($item->action){
										case "rain":
											// 缩短所有种子和树的成熟时间  collect_in * $item->percent
											$map = new MapModel();
											$plants = $map->getUserPlantsByUid($this->uid);
											foreach ($plants as $plant) {
												$start_time = $plant->start_time - $plant->collect_in *$item->percent;
												$map->updateMapItem($this->uid, $plant->map_x, $plant->map_y, array('start_time' => $start_time));
											}
											break;
									}
									break;

								case 'expand_ranch':
									$updata = array();
									switch ($item->action){
										case "expand":
											$updata = array(
	                                            'size_x' => $item->size,         	  
	                                            'size_y' => $item->size,         	  
											);
											break;
										case "expand_top_map":
											$updata = array(
	                                            'top_map_size' => $item->size,              
											);
											break;
										case "expand_bottom_map":
											$updata = array(
	                                            'bottom_map_size' => $item->size,              
											);
											break;
									}
									$user = new UserModel();
									$user->updateUser($this->uid, $updata);
									$this->debugMsg($user->getLastQuery());
									break;

								case 'automation':
									// TODO
									$userIncrease['op'] = $item->op;
									break;
							}
							if ($item->action == 'construction'){
								//        						$map = new MapModel();
								//        						//$map->increaseMapItem($this->uid, $queue->data->x, $queue->data->y, $setdata);
								//        						unset($map);
							}
							$userIncrease['reward_points'] = (0 - $item->rp_price);
							$userIncrease['experience'] = $item->exp;

							// 更新用户信息 rp
							$user = new UserModel();
							$user->increaseUserData($this->uid, $userIncrease);
							unset($user);
							break;

							// 施肥	减少作物的成熟等待时间，同时增加肥料使用的次数，若使用次数达到总次数则删除改肥料
						case 'fertilize':
							// data_hash, id, x, y, plant_id, plant_x, plant_y  肥料所在地块/植物
							$store = new StoreModel();
							$items = $store->getStoresByIds(array($queue->data->id, $queue->data->plant_id));
							foreach ($items as $item) {
								if($item->id == $queue->data->id) {
									$percent = $item->percent;
									$uses = $item->uses;
								}
								if($item->id == $queue->data->plant_id)
								$collect_in = $item->collect_in;
							}
							unset($items, $item);
							// 缩短所有种子和树的成熟时间  collect_in * $item->percent
							$map = new MapModel();
							$map->increaseMapItem($this->uid, $queue->data->plant_x, $queue->data->plant_y, array('start_time' => 0 - $percent * $collect_in));
							$this->debugMsg($map->getLastQuery());
							$item = $map->getMapItem($this->uid, $queue->data->x, $queue->data->y);
							if($uses - $item->times_used > 1)
							$map->increaseMapItem($this->uid, $queue->data->x, $queue->data->y, array('times_used' => 1));
							else
							$map->removeObject($this->uid, $queue->data->x, $queue->data->y);
							$this->debugMsg($map->getLastQuery());
							unset($map);
							break;
					}
				}
				break;
		}

		$ret->objects_to_update = array_values($objects_to_update);
		if($this->debug) $ret->demsg = $this->demsg;
		return $ret;
	}

	/**
	 * 加载好友农场
	 *
	 * @param $channel
	 */
	private function loadFarm($channel = 'load_farm')
	{
		// 好友ID
		$uid = (string) $this->input->id;

		$ret = new stdClass();
		$ret->channel = trim($channel);
		$ret->state = 'ok';
		$ret->farm = new stdClass();
		$ret->farm->map = $this->getUserMaps($uid);

		// 获得邻居个人资料
		$user = new UserModel();
		$info = $user->getUserById($uid);
		$ret->farm->size_x = $info->size_x;
		$ret->farm->size_y = $info->size_x;
		$ret->farm->top_map_size = $info->top_map_size;
		unset($user, $info);

		$ret->farm->uid = $uid;
		$ret->farm->helped = true;
		$ret->farm->has_app = true;
		$ret->farm->help_xp = self::HELP_XP;
		$ret->farm->help_coins = self::HELP_COINS;
		// 判断今天是否浇过地
		if($uid != $this->uid) {
			$neighbor = new NeighborsModel();
			$data = $neighbor->getNeighborByUidAndNuid($this->uid, $uid);
			$this->debugMsg($neighbor->getLastQuery());
			if(time() - $data->last_help_time >= self::HELP_TIME) {
				$ret->farm->helped = false;
			}
			unset($neighbor);
		}

		if($this->debug) $ret->demsg = $this->demsg;
		return $ret;
	}

	/**
	 * 获得用户地图
	 * @param $uid
	 */
	public function getUserMaps($uid)
	{
		$map = new MapModel();
		$maps = $map->getUserMapsByUid($uid);
		$this->debugMsg($map->getLastQuery());
		if(!$maps) return array();
		foreach ($maps as & $map) {
			$update = $this->checkHarvestItem($uid, $map);
			if($update) {
				$map->start_time = isset($update['start_time']) ? $update['start_time'] : 0;
				$map->products += isset($update['products']) ? $update['products'] : 0;
				$map->raw_materials += isset($update['raw_materials']) ? $update['raw_materials'] : 0;
			}
			if($map->start_time == 0)
			unset($map->start_time);
			if($map->flipped == 0)
			unset($map->flipped);
			if($map->animals == 0)
			unset($map->animals);
			if($map->products == 0)
			unset($map->products);
			if($map->raw_materials == 0)
			unset($map->raw_materials);
			if($map->pollinated == 0)
			unset($map->pollinated);
			if($map->automatic == 0)
			unset($map->automatic);
			if($map->times_used == 0)
			unset($map->times_used);
		}
		return $maps;
	}

	/**
	 * 初始化用户地块信息
	 */
	public function initUserMapData()
	{
		//$initMap = KO::config('initmap');

		//TODO  KO::config('initmap'); 出现问题，flash客户端访问出服务器500 错误，临时改为以下方式， 20100828 by dabin
		
		$initMap = array (
			0 => array (
	            'id' => 4,
	            'pollinated' => 0,
	            'x' => 28,
	            'y' => 18,
			),
			1 => array (
	            'id' => 4,
	            'pollinated' => 0,
	            'x' => 28,
	            'y' => 22,
			),
			2 => array (
	            'id' => 5,
	            'products' => 0,
	            'raw_materials' => 0,
	            'start_time' => 0,
	            'x' => 29,
	            'y' => 29,
			),
			3 => array (
	            'id' => 4,
	            'pollinated' => 0,
	            'x' => 18,
	            'y' => 18,
			),
			4 => array (
	            'id' => 4,
	            'pollinated' => 0,
	            'x' => 22,
	            'y' => 18,
			),
			5 => array (
	            'id' => 4,
	            'pollinated' => 0,
	            'x' => 22,
	            'y' => 22,
			),
			6 => array (
	            'id' => 4,
	            'pollinated' => 0,
	            'x' => 22,
	            'y' => 26,
			),
			7 => array (
	            'id' => 4,
	            'pollinated' => 0,
	            'x' => 18,
	            'y' => 26,
			),
			8 => array (
	            'id' => 4,
	            'pollinated' => 0,
	            'x' => 18,
	            'y' => 22,
			),
			9 => array (
	            'id' => 3,
	            'x' => 12,
	            'y' => 28,
			),
			10 => array (
	            'id' => 3,
	            'x' => 12,
	            'y' => 24,
			),
			11 => array (
	            'id' => 3,
	            'x' => 12,
	            'y' => 20,
			),
			12 => array (
	            'id' => 3,
	            'x' => 12,
	            'y' => 16,
			),
			13 => array (
	            'id' => 3,
	            'x' => 16,
	            'y' => 12,
			),
			14 => array (
	            'id' => 3,
	            'x' => 20,
	            'y' => 12,
			),
			15 => array (
	            'id' => 3,
	            'x' => 24,
	            'y' => 12,
			),
			16 => array (
	            'id' => 3,
	            'x' => 28,
	            'y' => 12,
			),
			17 => array (
	            'id' => 3,
	            'x' => 12,
	            'y' => 12,
			),
			18 => array (
	            'id' => 1,
	            'x' => 22,
	            'y' => 40,
			),
			19 => array (
	            'id' => 1,
	            'x' => 22,
	            'y' => 36,
			),
			20 => array (
	            'id' => 1,
	            'x' => 22,
	            'y' => 32,
			),
			21 => array (
	            'id' => 1,
	            'x' => 18,
	            'y' => 32,
			),
			22 => array (
	            'id' => 1,
	            'x' => 18,
	            'y' => 36,
			),
			23 => array (
	            'id' => 1,
	            'x' => 18,
	            'y' => 40,
			),
			24 => array (
	            'id' => 3,
	            'x' => 12,
	            'y' => 40,
			),
			25 => array (
	            'id' => 3,
	            'x' => 12,
	            'y' => 36,
			),
			26 => array (
	            'id' => 3,
	            'x' => 12,
	            'y' => 32,
			),
			27 => array (
	            'id' => 4,
	            'pollinated' => 0,
	            'x' => 36,
	            'y' => 18,
			),
			28 => array (
	            'id' => 4,
	            'pollinated' => 0,
	            'x' => 32,
	            'y' => 18,
			),
			29 => array (
	            'id' => 4,
	            'pollinated' => 0,
	            'x' => 32,
	            'y' => 22,
			),
			30 => array (
	            'id' => 4,
	            'pollinated' => 0,
	            'x' => 36,
	            'y' => 22,
			),
			31 => array (
	            'id' => 3,
	            'x' => 32,
	            'y' => 12,
			),
			32 => array (
	            'id' => 3,
	            'x' => 36,
	            'y' => 12
			)
		);





		if(empty($initMap)) return;
		$map = new MapModel();
		 
		foreach ($initMap as $key => $value) {
			//@todo 临时加入start_time
			if(empty($value['start_time']) || isset($initMap[$key]['start_time']) ){
				if($value['id'] == 2){
					$initMap[$key]['start_time'] = time() - 57600;
				} elseif($value['id'] == 3) {
					$initMap[$key]['start_time'] = time() - 43200;
				} elseif($value['id'] == 4) {
					$initMap[$key]['start_time'] = time() - 14400;
				} elseif($value['id'] == 5) {
					$initMap[$key]['start_time'] = time() - 60;
				}
			}
		}

		foreach ($initMap as $map_item) {
			$map->add(array(
                'uid'       =>  $this->uid,
                'itemid'    =>  isset($map_item['id']) ? $map_item['id'] : 0,
                'map_x'     =>  isset($map_item['x']) ? $map_item['x'] : 0,
                'map_y'     =>  isset($map_item['y']) ? $map_item['y'] : 0,
                'flipped'   =>  isset($map_item['flipped']) ? $map_item['flipped'] : 0,
                'raw_materials' => isset($map_item['raw_materials']) ? $map_item['raw_materials'] : 0,
                'pollinated'    => isset($map_item['pollinated']) ? $map_item['pollinated'] : 0,
                'start_time'    => isset($map_item['start_time']) ? $map_item['start_time'] : 0,
			));
		}
		return $initMap;
	}

	/**
	 * 检查地块上物品是否成熟（比如鸡蛋、牛奶等）
	 * @param $uid
	 * @param $data Map record
	 */
	private function checkHarvestItem($uid, $data)
	{
		if(!$data || !$data->raw_materials) {
			return;
		}

		$store = new StoreModel();
		$item = $store->getStoreById($data->id);
		$collect_in = $item->collect_in / ( $data->animals ? $data->animals : 1);
		$num = min(self::MAX_PRODUCTS - $data->products, min($data->raw_materials, floor((time() - $data->start_time) / $collect_in)));
		$this->debugMsg('New Products: ' . $num);
		if ($num <= 0) return;

		// 没有饲料了 或者 存储位已满 开始时间为 0
		if($data->raw_materials == $num || $num + $data->products >= self::MAX_PRODUCTS) {
			$updata = array('products' => $num, 'raw_materials' => (0 - $num), 'start_time' => (0 - $data->start_time));
		}
		// 否则 开始时间为增加已用时间
		else {
			$updata = array('products' => $num, 'raw_materials' => (0 - $num), 'start_time' => $num * $collect_in);
		}

		// 更新地图
		$map = new MapModel();
		$ret = $map->increaseMapItem($uid, $data->x, $data->y, $updata);
		$this->debugMsg($map->getLastQuery());
		return $ret;
	}


	/**
	 * 获得物品的卖出价格
	 */
	private function getMapItemSellPrice($uid, $map_x, $map_y)
	{
		$map = new MapModel();
		$item = $map->getMapItem($uid, $map_x, $map_y);
		if(!$item) return 0;
		$store = new StoreModel();
		$row = $store->getStoreById($item->id);
		if(!$row) return 0;

		$price = $row->sell_price;
		if($row->need_animals) {
			$animal = $store->getStoreById($row->animal);
			$price = $row->sell_price + ($animal->sell_price * $item->animals);
		}
		return $price;
	}

	/**
	 * 检查用户是否升级
	 * @param $level
	 * @param $experience
	 */
	private function checkUserLevel($uid, $level, $experience)
	{
		$model = new LevelModel();
		$new_level = $model->getLevelByExp($experience);
		if($new_level != $level) {
			$user = new UserModel();
			$user->updateUser($uid, array('level' => $new_level));
			unset($user);
		}
		return $new_level;
	}

	/**
	 * 记录调试信息
	 * @param $msg
	 */
	protected function debugMsg($msg = '')
	{
		if($this->debug == false) return;
		if(is_array($msg) || is_object($msg))
		$msg = var_export($msg, true);
        $this->demsg[] = $msg;
        return;
	}
	
} //End class
