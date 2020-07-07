// весь скрипт подвязан под локал игрока
local base= {
	tags = {
	['Правда'] = 0,
	['Мингбаг'] = 0,
	['Взлом жопы'] = 0,
	['Секта'] = 0,
	['Легкий старт'] = 0,
	['Далекий 2007'] = 0,
	['Убийца?'] = 0,
	},
	func = {
		alert = function(arg)
			net.Start('ach.alert_1')
			net.WriteTable(arg)
			net.Broadcast() 
		end,
		alertToPlayer = function(target,arg,arg2)
			net.Start('ach.alert_2')
			net.WriteString(arg)
			net.WriteString(arg2)
			net.Send(target) 
		end,
		JSON = function(arg)
			local json = util.TableToJSON(arg)
			file.Write( "ach/tags.txt", json)
			print('Hex: сохранено')
		end,
		alertNotify = function(alert_img,text)
			local notify = vgui.Create("DNotify")
			notify:SetPos(185, 15)
			notify:SetSize(150, 210)
			
			local bg = vgui.Create("DPanel", notify)
			bg:Dock(FILL)
			bg.Paint = function(self,w,h)
				draw.RoundedBox(3,0,0,w,h,color_white)
				draw.RoundedBox(3,2,2,w-4,h-4,color_black)
			end
	
			local img = vgui.Create("DImage", bg)
			img:SetPos(11, 11)
			img:SetSize(128, 128)
			img:SetImage(alert_img)
			
			local lbl = vgui.Create("DLabel", bg)
			lbl:SetPos(11, 136)
			lbl:SetSize(128, 72)
			lbl:SetText(text)
			lbl:SetTextColor(color_white)
			lbl:SetFont("GModNotify")
			lbl:SetWrap(true)
			notify:AddItem(bg)
		end
	}
}
base.func.JSON(base.tags);
if CLIENT then
	net.Receive('ach.alert_1',function(len) 
		chat.AddText(unpack(net.ReadTable()))
	end)
	net.Receive('ach.alert_2',function(len) 
		base.func.alertNotify(net.ReadString(),net.ReadString())
	end)
end
if SERVER then
	util.AddNetworkString('ach.alert_1')
	util.AddNetworkString('ach.alert_2')
	hook.Add('PlayerSay','ach.chat',function(ply,text)
		if string.lower(text) == 'вутка гей' and base.tags['Правда'] == 0 then
			base.func.alert({
				Color(255,255,0),'[HexSystem]: ', ply:Nick(),
				Color(200,200,200), ' Выполнил ачивку -  Правда'
			});
			base.tags['Правда'] = 1
			base.func.JSON(base.tags)
			base.func.alertToPlayer(ply,'gui/colors.png','Вутка гей')
			return false;
		end
	end)
	hook.Add('PlayerSpawnProp','ach.prop',function(ply,model)
		if not IsValid(ply) then return end
		if model == 'models/props_c17/FurnitureFireplace001a.mdl' and base.tags['Мингбаг'] == 0 then
			base.func.alert({
				Color(255,255,0),'[HexSystem]: ', ply:Nick(),
				Color(200,200,200), ' Выполнил ачивку -  Мингбаг'
			});
			base.tags['Мингбаг'] = 1
			base.func.alertToPlayer(ply,'vgui/face/smile','Мингбаг')
			base.func.JSON(base.tags)     
		end
	end)
	hook.Add('PlayerSpawnSENT','ach.prop',function(ply,class)
		if not IsValid(ply) then return end
		if class == 'sent_deployableballoons' and base.tags['Взлом жопы'] == 0 then
			base.func.alert({
				Color(255,255,0),'[HexSystem]: ', ply:Nick(),
				Color(200,200,200), ' Выполнил ачивку -  Взлом жопы'
			});
			base.tags['Взлом жопы'] = 1
			base.func.alertToPlayer(ply,'weapons/swep','Взлом жопы')
			base.func.JSON(base.tags)     
		end
	end)
	hook.Add( "PlayerShouldTakeDamage", "ach.damage", function( ply, attacker )
		if not IsValid(ply) then return end
		if attacker:IsPlayer() and base.tags['Убийца?'] == 0  then
			base.func.alert({
				Color(255,255,0),'[HexSystem]: ', attacker:Nick(),
				Color(200,200,200), ' Выполнил ачивку -  Убийца?'
			});
			base.tags['Убийца?'] = 1
			base.func.alertToPlayer(attacker,'hud/killicons/default','Убийца?')
			base.func.JSON(base.tags)         
		end
	end)
	hook.Add('PlayerDeath','ach.death',function( victim, inflictor, attacker )
		if not IsValid(victim) then return end
		if victim:IsPlayer() and base.tags['Легкий старт'] == 0  then
			base.func.alert({
				Color(255,255,0),'[HexSystem]: ', attacker:Nick(),
				Color(200,200,200), ' Выполнил ачивку -  Легкий старт'
			});
			base.tags['Легкий старт'] = 1
			base.func.alertToPlayer(attacker,'gui/gmod_logo','Легкий старт')
			base.func.JSON(base.tags)         
		end         
	end)
	hook.Add('PlayerUse','ach.use',function(ply,ent)
		if not IsValid(ply) then return end
		if ent == 'sent_ball' and base.tags['Далекий 2007'] == 0 then
			base.func.alert({
				Color(255,255,0),'[HexSystem]: ', ply:Nick(),
				Color(200,200,200), ' Выполнил ачивку -  Далекий 2007'
			});
			base.tags['Далекий 2007'] = 1
			base.func.alertToPlayer(ply,'sprites/sent_ball','Далекий 2007')
			base.func.JSON(base.tags)     
		end
	end)               
end                                                                                                                                            
