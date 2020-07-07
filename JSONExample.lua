local base= {
	tags = {
	['Правда'] = 0,
	['Мингбаг'] = 0,
	['Взлом жопы'] = 0,
	['Секта'] = 1,
	['Легкий старт'] = 1,
	['Далекий 2007'] = 0,
	['Убийца?'] = 1,
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
local function menu()
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
		if base.tags[base.tagsWhile[i]] == 1 then
		lbl:SetText(base.tagsWhile[i]..' ✓')
		elseif base.tags[base.tagsWhile[i]] == 0 then
		lbl:SetText(base.tagsWhile[i]..' ✕')
		end
		lbl:SetTextColor(color_black)
	end
	
end
menu()                                                            
