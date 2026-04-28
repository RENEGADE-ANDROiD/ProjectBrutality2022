class CSSGEvent : EventHandler
{	
	//basically, just type in console "NetEvent CM_AllShells" and voila, you got all the upgrades of this
	override void NetworkProcess(ConsoleEvent e)
	{
		if (!e) return;
		if (e.player < 0 || e.player >= MAXPLAYERS) return;
		if (!playeringame[e.player]) return;
		let pm = players[e.player].mo;
		if(!pm)
			return;
			
		if (e.Name ~== "CM_AllShells")
		{
			pm.GiveInventory("ExplosiveShellsUpgrade", 1);
			pm.GiveInventory("WPShellsUpgrade", 1);
			pm.GiveInventory("DoomShellsUpgrade", 1);
			pm.GiveInventory("DragonBreathUpgrade", 1);
			pm.GiveInventory("DanmakuUpgrade", 1);
		}
		
	}
}