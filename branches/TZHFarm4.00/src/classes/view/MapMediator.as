package classes.view
{
    import classes.*;
    import classes.model.*;
    import classes.view.components.*;
    import classes.view.components.map.*;
    import classes.view.components.popups.UnderConstructionPopup;
    
    import flash.display.DisplayObject;
    import flash.events.*;
    
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    
    import tzh.core.TutorialManager;

    public class MapMediator extends Mediator implements IMediator
    {
        public static var NAME:String = "MapMediator";

        public function MapMediator(value:Object)
        {
            super(NAME, value);
        }

        private function showUnderConstructionPopup(event:Event) : void
        {
            sendNotification(ApplicationFacade.SHOW_UNDER_CONSTRUCTION_POPUP, event.target.event_data);
        }

        private function mapObjectsUpdated(event:Event) : void
        {
            app_data.update_map_objects(event.target.objects_updated);
        }

        private function feedMapObject(event:Event) : void
        {
            sendNotification(ApplicationFacade.FEED_MAP_OBJECT, event.target.event_data);
        }

        private function showConfirmError(event:Event) : void
        {
            app_data.report_confirm_error(event.target.event_data as String);
        }

        private function processComplete(event:Event) : void
        {
            if (event.target.current_process_loader.auto_mode)
            {
                app_data.auto_process(event.target.current_process_loader.pid);
            }
            else
            {
                app_data.process_queue();
            }
        }

        private function installIrrigation(event:Event) : void
        {
            sendNotification(ApplicationFacade.INSTALL_IRRIGATION, event.target.event_data);
        }

        private function addPlant(event:Event) : void
        {
            sendNotification(ApplicationFacade.ADD_PLANT, event.target.event_data);
        }

        private function toggleAutomation(event:Event) : void
        {
            sendNotification(ApplicationFacade.TOGGLE_AUTOMATION, event.target.event_data);
        }

        private function autoRefill(event:Event) : void
        {
            sendNotification(ApplicationFacade.AUTO_REFILL, event.target.map_obj);
        }

        private function showUpgradePopup(event:Event) : void
        {
            sendNotification(ApplicationFacade.SHOW_UPGRADE_POPUP, event.target.event_data);
        }

        private function flipMapObject(event:Event) : void
        {
            sendNotification(ApplicationFacade.FLIP_MAP_OBJECT, event.target.event_data);
        }

        private function onPollinate(event:Event) : void
        {
            sendNotification(ApplicationFacade.POLLINATE, event.target.swarm);
        }

        protected function get map_proxy() : MapProxy
        {
            return facade.retrieveProxy(MapProxy.NAME) as MapProxy;
        }

        private function selectRawMaterial(event:Event) : void
        {
            map_proxy.set_map_object(event.target.event_data);
            sendNotification(ApplicationFacade.SHOW_SELECT_RAW_MATERIAL_POPUP, event.target.event_data);
        }

        private function showChristmasPresents(event:Event) : void
        {
            sendNotification(ApplicationFacade.SHOW_CHRISTMAS_PRESENTS, event.target.event_data);
        }

        private function removeMapObject(event:Event) : void
        {
            var mapObject:MapObject = event.target.event_data as MapObject;
            map_proxy.remove_map_object_popup(mapObject, app_data.get_sell_price(mapObject.id, mapObject.grid_x, mapObject.grid_y));
        }

        private function addMapObject(event:Event) : void
        {
            sendNotification(ApplicationFacade.ADD_MAP_OBJECT, event.target.event_data);
        }

        protected function can_zoom() : Boolean
        {
            return !map_proxy.friend_mode;
        }

        protected function get map() : Map
        {
            return viewComponent as Map;
        }

        private function deactivateMultiTool(event:Event) : void
        {
            sendNotification(ApplicationFacade.DEACTIVATE_MULTI_TOOL);
        }

        override public function listNotificationInterests() : Array
        {
            return [ApplicationFacade.USE_PLOW_TOOL,ApplicationFacade.TUTORIAL_COMPLETED, ApplicationFacade.TUTORIAL_STARTED,ApplicationFacade.UPDATE_OBJECTS, ApplicationFacade.MAP_OBJECT_ADDED, ApplicationFacade.MAP_OBJECT_MOVED, ApplicationFacade.MAP_OBJECT_REMOVED, ApplicationFacade.MAP_OBJECT_FED, ApplicationFacade.MAP_OBJECT_COLLECTED, ApplicationFacade.USE_MOVE_TOOL, ApplicationFacade.USE_REMOVE_TOOL, ApplicationFacade.USE_MULTI_TOOL, ApplicationFacade.USE_AUTOMATION_TOOL, ApplicationFacade.PLACE_MAP_OBJECT, ApplicationFacade.ZOOM_IN, ApplicationFacade.ZOOM_OUT, ApplicationFacade.SHOW_FARM, ApplicationFacade.BACK_TO_MY_RANCH, ApplicationFacade.RAIN_APPLIED, ApplicationFacade.ESCAPE_PRESSED, ApplicationFacade.USE_SHOP_ITEM, ApplicationFacade.ANIMAL_ADDED, ApplicationFacade.MAP_ADD_OBJECT, ApplicationFacade.SHOW_PROCESS_LOADER, ApplicationFacade.CANCEL_PROCESS_LOADER, ApplicationFacade.MAP_REFRESH_DEPTH, ApplicationFacade.CENTER_MAP, ApplicationFacade.STAGE_RESIZE, ApplicationFacade.EXPAND_RANCH, ApplicationFacade.CROPS_FERTILIZED, ApplicationFacade.TOGGLE_ALPHA, ApplicationFacade.ACTIVATE_SNAPSHOT_MODE, ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE, ApplicationFacade.CHECK_AUTOMATION, ApplicationFacade.AUTOMATION_TOGGLED, ApplicationFacade.INCREASE_OBTAINED_MATERIAL, ApplicationFacade.IRRIGATION_INSTALLED];
        }

        private function collectProduct(event:Event) : void
        {
            sendNotification(ApplicationFacade.COLLECT_PRODUCT, event.target.event_data);
        }

        private function updateObject(event:Event) : void
        {
            app_data.update_plant(Plant(event.target.map_obj));
        }

        private function applyRain(event:Event) : void
        {
            sendNotification(ApplicationFacade.APPLY_RAIN, event.target.event_data);
        }

        private function moveMapObject(event:Event) : void
        {
            sendNotification(ApplicationFacade.MOVE_MAP_OBJECT, event.target.event_data);
        }

        private function refillMapObject(event:Event) : void
        {
            sendNotification(ApplicationFacade.REFILL_MAP_OBJECT, event.target.event_data);
        }

        private function showShopAndAddPlant(event:Event) : void
        {
        	var showTutorialEnd:Boolean = TutorialManager.getInstance().end;
        	if(!showTutorialEnd){
        		return;
        	}
            map_proxy.set_soil_to_plant(event.target.event_data);
            sendNotification(ApplicationFacade.SHOW_SHOP_AND_ADD_PLANT);
        }

        private function fertilize(event:Event) : void
        {
            sendNotification(ApplicationFacade.FERTILIZE, event.target.event_data);
            map.check_bees();
        }

        override public function onRegister() : void
        {
            map.addEventListener(Map.ADD_MAP_OBJECT, addMapObject);
            map.addEventListener(Map.MOVE_MAP_OBJECT, moveMapObject);
            map.addEventListener(Map.REMOVE_MAP_OBJECT, removeMapObject);
            map.addEventListener(Map.ADD_PLANT, addPlant);
            map.addEventListener(Map.SHOW_SHOP_AND_ADD_PLANT, showShopAndAddPlant);
            map.addEventListener(Map.COLLECT_PRODUCT, collectProduct);
            map.addEventListener(Map.FEED_MAP_OBJECT, feedMapObject);
            map.addEventListener(Map.REFILL_MAP_OBJECT, refillMapObject);
            map.addEventListener(Map.APPLY_RAIN, applyRain);
            map.addEventListener(Map.ADD_ANIMAL, addAnimal);
            map.addEventListener(Map.PROCESS_COMPLETE, processComplete);
            map.addEventListener(Map.MAP_OBJECTS_UPDATED, mapObjectsUpdated);
            map.addEventListener(Map.SHOW_CONFIRM_ERROR, showConfirmError);
            map.addEventListener(Map.FERTILIZE, fertilize);
            map.addEventListener(Map.FLIP_MAP_OBJECT, flipMapObject);
            map.addEventListener(Map.ON_POLLINATE, onPollinate);
            map.addEventListener(Map.SELECT_RAW_MATERIAL, selectRawMaterial);
            map.addEventListener(Map.AUTO_REFILL, autoRefill);
            map.addEventListener(Map.AUTO_COLLECT, autoCollect);
            map.addEventListener(Map.TOGGLE_AUTOMATION, toggleAutomation);
            map.addEventListener(Map.SHOW_CHRISTMAS_PRESENTS, showChristmasPresents);
            map.addEventListener(Map.SHOW_UNDER_CONSTRUCTION_POPUP, showUnderConstructionPopup);
            map.addEventListener(Map.UPDATE_OBJECT, updateObject);
            map.addEventListener(Map.INSTALL_IRRIGATION, installIrrigation);
            map.addEventListener(Map.SHOW_UPGRADE_POPUP, showUpgradePopup);
            map.addEventListener(Map.DEACTIVATE_MULTI_TOOL, deactivateMultiTool);
            map.addEventListener(Plant.FRIEND_HELPED_FERTILIZE,friendHelpedFertilize);
        }
        
        private function friendHelpedFertilize(event:Event):void {
        	sendNotification(ApplicationFacade.FERTILIZE_FRIEND_HELPED,event.target.event_data);
        }

        override public function handleNotification(value:INotification) : void
        {
            var body:Object = null;
            var flipped:Boolean = false;
            var item:Object = null;
            var temp:Object = null;
            switch(value.getName())
            {
            	case ApplicationFacade.TUTORIAL_STARTED:
            		//map.enabled = false;
            		break;
            	case ApplicationFacade.TUTORIAL_COMPLETED:
            		map.enabled = true;
            		break;
                case ApplicationFacade.USE_PLOW_TOOL:
                {
                    map.set_tool("add_MO", app_data.get_item_data(1));
                    break;
                }
                case ApplicationFacade.UPDATE_OBJECTS:
                {
                    body = value.getBody();
                    if (body.map)
                    {
                        map.set_zoom(map_proxy.get_grid_size());
                        map.update(app_data.get_map_data());
                        map.set_tool("multi_tool");
                    }
                    if (body.objects_to_update)
                    {
                        map.update_objects(app_data.get_objects_to_update());
                    }
                    break;
                }
                case ApplicationFacade.MAP_OBJECT_ADDED:
                {
                    map.tool_action_confirmed();
                    break;
                }
                case ApplicationFacade.MAP_OBJECT_MOVED:
                {
                    map.tool_action_confirmed();
                    break;
                }
                case ApplicationFacade.MAP_OBJECT_REMOVED:
                {
                    map.tool_action_confirmed();
                    map.map_object_removed(value.getBody() as MapObject);
                    break;
                }
                case ApplicationFacade.MAP_OBJECT_FED:
                case ApplicationFacade.MAP_OBJECT_COLLECTED:
                {
                    map.tool_action_confirmed(value.getBody());
                    break;
                }
                case ApplicationFacade.USE_MOVE_TOOL:
                {
                    map.set_tool("move");
                    break;
                }
                case ApplicationFacade.USE_REMOVE_TOOL:
                {
                    map.set_tool("remove");
                    break;
                }
                case ApplicationFacade.USE_MULTI_TOOL:
                {
                    map.set_tool("multi_tool");
                    break;
                }
                case ApplicationFacade.PLACE_MAP_OBJECT:
                {
                    flipped = value.getBody().flipped as Boolean;
                    var id:Number = value.getBody().item as Number;
                    item = app_data.get_item_data(id);
                    if (flipped)
                    {
                        item.flipped = true;
                        item.flipped_from_store = true;
                    }
                    if (item.type == "seeds")
                    {
                        if (map_proxy.has_soil_to_plant())
                        {
                            item.soil_to_plant = map_proxy.soil_to_plant;
                            map_proxy.soil_to_plant = null;
                        }
                        map.set_tool("multi_tool", {subtool:{type:"soil"}});
                        map.tool_action_confirmed(item);
                    }
                    else
                    {
                        map.set_tool("add_MO", item);
                    }
                    break;
                }
                case ApplicationFacade.ZOOM_IN:
                {
                    if (!can_zoom())
                    {
                        return;
                    }
                    if (map_proxy.zoom_in())
                    {
                        map.set_zoom(map_proxy.get_grid_size());
                        map_proxy.call_garbage_collector();
                    }
                    break;
                }
                case ApplicationFacade.ZOOM_OUT:
                {
                    if (!can_zoom())
                    {
                        return;
                    }
                    if (map_proxy.zoom_out())
                    {
                        map.set_zoom(map_proxy.get_grid_size());
                        map_proxy.call_garbage_collector();
                    }
                    break;
                }
                case ApplicationFacade.SHOW_FARM:
                {
                    app_data.clear_process_queue();
                    map.cancel_process_loader();
                    map.clear();
                    map.visible = false;
                    break;
                }
                case ApplicationFacade.BACK_TO_MY_RANCH:
                {
                    app_data.cancel_help_popup();
                    app_data.clear_process_queue();
                    map.visible = true;
                    map.update(app_data.get_map_data());
                    map.set_tool("multi_tool");
                    break;
                }
                case ApplicationFacade.RAIN_APPLIED:
                {
                    map.apply_rain(value.getBody() as Number);
                    break;
                }
                case ApplicationFacade.ESCAPE_PRESSED:
                {
                    map.escape_pressed();
                    break;
                }
                case ApplicationFacade.USE_SHOP_ITEM:
                {
                    map.set_tool("use_shop_item", value.getBody());
                    break;
                }
                case ApplicationFacade.ANIMAL_ADDED:
                {
                    map.tool_action_confirmed(value.getBody());
                    break;
                }
                case ApplicationFacade.MAP_ADD_OBJECT:
                {
                    map.add_object(value.getBody() as MapObject);
                    break;
                }
                case ApplicationFacade.SHOW_PROCESS_LOADER:
                {
                    map.show_process_loader(value.getBody());
                    break;
                }
                case ApplicationFacade.CANCEL_PROCESS_LOADER:
                {
                    map.cancel_process_loader();
                    break;
                }
                case ApplicationFacade.MAP_REFRESH_DEPTH:
                {
                    map.refresh_objects_depth();
                    break;
                }
                case ApplicationFacade.CENTER_MAP:
                {
                    map.center_map();
                    break;
                }
                case ApplicationFacade.STAGE_RESIZE:
                {
                    map.refresh_viewport();
                    map.center_map();
                    break;
                }
                case ApplicationFacade.EXPAND_RANCH:
                {
                    map.expand(value.getBody());
                    break;
                }
                case ApplicationFacade.CROPS_FERTILIZED:
                {
                    map.tool_action_confirmed();
                    break;
                }
                case ApplicationFacade.TOGGLE_ALPHA:
                {
                    map.toggle_alpha();
                    break;
                }
                case ApplicationFacade.ACTIVATE_SNAPSHOT_MODE:
                {
                    map.set_tool("");
                    break;
                }
                case ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE:
                {
                    map.set_tool("multi_tool");
                    break;
                }
                case ApplicationFacade.CHECK_AUTOMATION:
                {
                    map.check_automation(value.getBody() as String);
                    break;
                }
                case ApplicationFacade.USE_AUTOMATION_TOOL:
                {
                    map.set_tool("automation");
                    break;
                }
                case ApplicationFacade.AUTOMATION_TOGGLED:
                {
                    map.tool_action_confirmed();
                    break;
                }
                case ApplicationFacade.INCREASE_OBTAINED_MATERIAL:
                {
                    temp = value.getBody();
                    var mapObject:MapObject = map.increase_obtained_material(temp.mo, temp.material);
                    var popup:DisplayObject = this.map.stage.getChildByName("underConstructionPopup");
                    if(popup && popup is UnderConstructionPopup){
                    	if(mapObject is Greenhouse && mapObject.constructionOK){// 先暂时做这么一个判断
                    		UnderConstructionPopup(popup).remove();
                    	}else {
                			UnderConstructionPopup(popup).refreshData(app_data.get_under_construction_popup_data(mapObject));
                		}
                	}
                    break;
                }
                case ApplicationFacade.IRRIGATION_INSTALLED:
                {
                    map.tool_action_confirmed(value.getBody());
                    break;
                }
                default:
                {
                    break;
                }
            }
        }

        protected function get app_data() : AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }

        private function autoCollect(event:Event) : void
        {
            sendNotification(ApplicationFacade.AUTO_COLLECT, event.target.map_obj);
        }

        private function addAnimal(event:Event) : void
        {
            sendNotification(ApplicationFacade.ADD_ANIMAL, event.target.event_data);
        }

    }
}
