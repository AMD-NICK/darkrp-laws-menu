/*
Title: Government Laws Menu 
Creator: _AMD_, McSniper 
Description: Tired of looking for law boards? Well, now all you have to do is type /laws to view the government laws!!!
*/

util.AddNetworkString( "open_laws_menu_mate" )

hook.Add( "PlayerSay", "law_command_function", function( ply, txt )

	if string.sub( string.lower(txt), 1, 5 ) == "/laws"
	|| string.sub( string.lower(txt), 1, 4 ) == "/law" then

		net.Start("open_laws_menu_mate") --Tells client to open menu
		net.Send( ply )

		return ""
	end

end)