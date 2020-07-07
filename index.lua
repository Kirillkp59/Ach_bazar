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
		JSONLocal = function(path,arg)
			local json = util.TableToJSON(arg)
			file.Write( path, json)
			print('Hex: сохранено локально')
		end,    
		alertNotify = function(alert_img,text)
			local notify = vgui.Create("DNotify")
			notify:SetPos(15, 15)
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
	},
	tagsValue = 7,
	tagsWhile = {
	'Правда',
	'Мингбаг',
	'Взлом жопы',
	'Секта',
	'Легкий старт',
	'Далекий 2007',
	'Убийца?'
	}                 
}
base.func.JSON(base.tags);
base.func.JSONLocal('ach/ach_local.txt',base.tagsWhile)
if CLIENT then
	net.Receive('ach.alert_1',function(len) 
		chat.AddText(unpack(net.ReadTable()))
	end)
	net.Receive('ach.alert_2',function(len) 
		base.func.alertNotify(net.ReadString(),net.ReadString())
	end)
	net.Receive('ach.sekta',function(len) 
		sound.PlayURL('https://cdn.discordapp.com/attachments/707018593581137921/729802431797395476/Bazar_-_Sekta2.mp3','3d',function(station)
			if IsValid(station) then
				timer.Create('ach.timer1',0,0,function() 
					station:SetPos(LocalPlayer():GetPos())
				end)
				station:Play()
			end
		end)
	end)
	local function menu() // ach menu
		local fl = file.Read('ach/tags.txt','DATA')
		local json = util.JSONToTable(fl)
		local fl2 = file.Read('ach/ach_local.txt','DATA')
		local jsonLocal = util.JSONToTable(fl2)
		
		local Y = 28
		local i = 0
		local win = vgui.Create('DFrame')
		win:SetSize(500,600)
		win:Center()
		win:MakePopup()
		win:SetTitle('')
		win.Paint = function(self,w,h)
			draw.RoundedBox(3,0,0,w,h,color_white)
			draw.RoundedBox(3,2,2,w-4,h-4,color_black)
		end
		while i<base.tagsValue do
			local pnl = vgui.Create('DPanel',win)
			pnl:SetPos(0,Y)
			pnl:SetSize(win:GetWide(),40)
			Y = Y + pnl:GetTall() * 1.2
			i = i + 1
			pnl.Paint = function(self,w,h)
				if pnl:IsHovered() then
					clrs = math.sin(CurTime()%360*3)*255
					draw.RoundedBox(3,0,0,w,h,Color(clrs,255,clrs))
				else
					draw.RoundedBox(3,0,0,w,h,color_white)
				end
			end
			local lbl = vgui.Create('DLabel',pnl)
			lbl:SetPos(10,-15)
			lbl:SetSize(164,64)
			lbl:SetFont('GModNotify')
			if json[jsonLocal[i]] == 1 then
				lbl:SetText(jsonLocal[i]..' ✓')
			else
				lbl:SetText(jsonLocal[i]..' ✕')
			end
			lbl:SetTextColor(color_black)
		end
	end // ach menu
	concommand.Add('HexMenu',menu)
end
if SERVER then
	util.AddNetworkString('ach.alert_1')
	util.AddNetworkString('ach.alert_2')
	util.AddNetworkString('ach.sekta')
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
		if string.lower(text) == 'аткес' and base.tags['Секта'] == 0 then
			base.func.alert({
				Color(255,255,0),'[HexSystem]: ', ply:Nick(),
				Color(200,200,200), ' Выполнил секретную ачивку -  Секта'
			});
			base.tags['Секта'] = 1
			base.func.JSON(base.tags)
			base.func.alertToPlayer(ply,'vgui/spawnmenu/npc','Секретная секта')
			net.Start('ach.sekta')
			net.Send(ply)
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
		if victim:IsPlayer() and victim != attacker and base.tags['Легкий старт'] == 0  then
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
		if ent:GetClass() == 'sent_ball' and base.tags['Далекий 2007'] == 0 then
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
