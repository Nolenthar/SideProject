//--- RandomEncounters ---
// Made by Erxv
class CModRExtra extends CModRandomEncounters
{	
	function getZone() : String
	{
		var pos : Vector;
		var zone : string;
		var currentArea : string;
		
		pos = thePlayer.GetWorldPosition();
		currentArea = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());
		
		if (currentArea == "novigrad")
		{
			if ( (pos.X < 730 && pos.X > 290)  && (pos.Y < 2330 && pos.Y > 1630))
			{
				zone = "novigrad";
			}		
			else if ( (pos.X < 730 && pos.X > 450)  && (pos.Y < 1640 && pos.Y > 1530))
			{
				zone = "novigrad";
			}	
			else if ( (pos.X < 930 && pos.X > 700)  && (pos.Y < 2080 && pos.Y > 1635))
			{
				zone = "novigrad";
			}		
			else if ( (pos.X < 1900 && pos.X > 1600)  && (pos.Y < 1200 && pos.Y > 700))
			{
				zone = "oxenfurt";
			}
			else if ( (pos.X < 315 && pos.X > 95)  && (pos.Y < 240 && pos.Y > 20))
			{
				zone = "crows";
			}
			else if ( (pos.X < 1550 && pos.X > 930)  && (pos.Y < 1320 && pos.Y > 950))
			{
				zone = "swamp";
			}
			else if ( (pos.X < 1400 && pos.X > 940)  && (pos.Y < -460 && pos.Y > -720))
			{
				zone = "swamp";
			}
			else if ( (pos.X < 1790 && pos.X > 1320)  && (pos.Y < -400 && pos.Y > -540))
			{
				zone = "swamp";
			}
			else if ( (pos.X < 2150 && pos.X > 1750)  && (pos.Y < -490 && pos.Y > -1090))
			{
				zone = "swamp";
			}
			else
			{
				zone = "undefined";
			}
		}
		else if (currentArea == "skellige")
		{
			if ( (pos.X < 30 && pos.X > -290)  && (pos.Y < 790 && pos.Y > 470))
			{
				zone = "trolde";
			}		
			else
			{
				zone = "undefined";
			}
		}		
		else if (currentArea == "wyzima_castle" || currentArea == "island_of_mist" || currentArea == "spiral")
		{
			zone = "nospawn";
		}		
		return zone;		
	}	
}















