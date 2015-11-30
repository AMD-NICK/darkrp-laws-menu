/*
Title: Government Laws Menu 
Creator: _AMD_, McSniper
Description: Tired of looking for law boards? Well, now all you have to do is type /laws to view the government laws!!!
*/

AddCSLuaFile()

local function law_add()
	Derma_StringRequest(
		"Create New Law",
		"Type the law you want to add without the number",
		"",
		function( text ) RunConsoleCommand("say", "/addlaw" .. " " .. text) end
	)
end

local function law_remove()
	Derma_StringRequest(
		"Delete a Law",
		"Type the NUMBER of the law you want to remove",
		"",
		function( text ) RunConsoleCommand("say", "/removelaw" .. " ".. text) end
	)
end


local function law_menu()
	local lawspls = DarkRP.getLaws()
	local isMayor = LocalPlayer():getJobTable().mayor


	local lmenu = vgui.Create( "DFrame" ) -- Main Menu
	lmenu:SetSize( 530, 380 )
	lmenu:Center()
	lmenu:SetTitle( "Government Laws" )
	lmenu:SetVisible( true )
	lmenu:SetDraggable( true )
	lmenu:ShowCloseButton( false )
	lmenu:MakePopup()
	lmenu:Center()
	lmenu.Paint = function( pnl, w, h ) draw.RoundedBox( 8, 0, 0, w, h, Color( 0, 0, 0, 245 ) ) end


	local lclose = vgui.Create( "DButton", lmenu ) -- Close button
	lclose:SetSize( 60, 25 )
	lclose:SetPos( lmenu:GetWide() - lclose:GetWide(), 0 ) 
	lclose:SetText( "Close" )
	lclose:SetFont("Trebuchet24")
	lclose:SetTextColor( Color( 255, 255, 255 ) )
	lclose.Paint = function( pnl, w, h ) 
		draw.RoundedBoxEx( 8, 0, 0, w, h, Color( 200, 40, 40 ),false,true,false,false)
	end
	lclose.DoClick = function() lmenu:Remove() end


	local llist = vgui.Create("DListView", lmenu)
	llist:SetPos(3, 24 + 3)
	llist:SetSize(lmenu:GetWide() - 6, lmenu:GetTall() - 24 - 6 - 30) -- width 524
	llist:SetMultiSelect(false)
	llist:AddColumn("Number")
	llist:AddColumn("Law")
	llist.Columns[1]:SetWidth(50)
	llist.Columns[2]:SetWidth(llist:GetWide()-llist.Columns[1]:GetWide())
	for k,v in pairs(lawspls) do
		llist:AddLine(k,v).law = k
	end
	llist.OnRowRightClick = function( row, dat )
		if !isMayor then return end

		local law = llist:GetLine(llist:GetSelectedLine()).law
		--local law = dat -- also you can use this method, but i want to do else

		local func = DermaMenu()
			local rem = func:AddOption( "Remove law", function() RunConsoleCommand("say", "/removelaw" .. " ".. law) end):SetIcon( "icon16/cancel.png" )
			local add = func:AddOption( "Add law", function() law_add() end):SetIcon( "icon16/add.png" )
			local res = func:AddOption( "Reset laws", function() RunConsoleCommand("say", "/resetlaws") end):SetIcon( "icon16/arrow_undo.png" )
		func:Open()
	end


	if isMayor then

		local ladd = vgui.Create( "DButton" )
		ladd:SetSize( 150, 25 )
		ladd:SetPos( 0, lmenu:GetTall()-ladd:GetTall() )
		ladd:SetParent( lmenu )	
		ladd:SetText( "Add Law" )
		ladd:SetFont("Trebuchet24")
		ladd:SetTextColor( Color( 255, 255, 255 ) )
		ladd.DoClick = function() law_add() end
		function ladd:Paint( w, h )
			draw.RoundedBoxEx(8,0,0,w,h,Color(30,180,80),false,true,true,false)
		end


		local lreset = vgui.Create( "DButton", lmenu )
		lreset:SetSize( 150, 25 )
		lreset:SetPos( lmenu:GetWide()/2-lreset:GetWide()/2, lmenu:GetTall()-ladd:GetTall() )
		lreset:SetText( "Reset Laws" )
		lreset:SetFont("Trebuchet24")
		lreset:SetTextColor( Color( 255, 255, 255 ) )
		lreset.DoClick = function()
			Derma_Query("Are you sure you want to reset the laws?", "Reset Laws", "Yes" , function() RunConsoleCommand("say", "/resetlaws") end, "No",function() end)
		end
		function lreset:Paint( w, h ) -- Reset Laws Button Color
			draw.RoundedBoxEx(8,0,0,w,h,Color(10,170,200),true,true,false,false)
		end


		local lrem = vgui.Create( "DButton", lmenu )
		lrem:SetSize( 150, 25 )
		lrem:SetPos( lmenu:GetWide()-lrem:GetWide(), lmenu:GetTall()-ladd:GetTall() )
		lrem:SetText( "Remove Law" )
		lrem:SetFont("Trebuchet24")
		lrem:SetTextColor( Color( 255, 255, 255 ) )
		lrem.Paint = function( pnl, w, h ) -- Remove Laws Button Color
			draw.RoundedBoxEx(8,0,0,w,h,Color(200,130,10),true,false,false,true)
		end
		lrem.DoClick = function()
			if not llist:GetSelectedLine() then
				law_remove()
			else
				local law = llist:GetLine(llist:GetSelectedLine()).law
				RunConsoleCommand("say", "/removelaw" .. " ".. law)
			end
		end

	end


	local lref = vgui.Create( "DButton", lmenu ) -- Close button
	lref:SetSize( 25, 25 )
	lref:SetPos( lmenu:GetWide()-lclose:GetWide()-lref:GetWide()-2, 0 ) 
	lref:SetText( "↻" )
	lref:SetFont("Trebuchet24")
	lref:SetTextColor( Color( 255, 255, 255 ) )
	lref.Paint = function( pnl, w, h ) 
		draw.RoundedBoxEx( 8, 0, 0, w, h, Color( 200, 40, 40 ),false,false,true,false)
	end
	-- I know, it's not a good way to reload data,
	-- but I do not know other to refresh it.
	-- Google not help me with that
	lref.DoClick = function()
		lawspls = DarkRP.getLaws()
		llist:Clear()

		for k,v in pairs(lawspls) do
			llist:AddLine(k,v).law = k
		end
	end
end

net.Receive("open_laws_menu_mate", function() law_menu() end)