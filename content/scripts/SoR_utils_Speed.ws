
exec function setSlow(val : float){

thePlayer.SetAnimationSpeedMultiplier(val);

}

exec function calcSpeed2(){

	calcSpeed();
}




function calcSpeed():void{

		var item : SItemUniqueId;
		var encumbrance 	: float;
		var armors : array<SItemUniqueId>;
		var light, medium, heavy,undefined :float;
                            var i, cnt : int;
		var armorType : EArmorType;
		var witcher : W3PlayerWitcher;
		var speedMulti : float;
		var p:float;
	
		witcher = GetWitcherPlayer();
		armors.Resize(4);
		
		if(witcher.inv.GetItemEquippedOnSlot(EES_Armor, item))
			armors[0] = item;
			
		if(witcher.inv.GetItemEquippedOnSlot(EES_Boots, item))
			armors[1] = item;
			
		if(witcher.inv.GetItemEquippedOnSlot(EES_Pants, item))
			armors[2] = item;
			
		if(witcher.inv.GetItemEquippedOnSlot(EES_Gloves, item))
			armors[3] = item;
		undefined=0;
		light = 0;
		medium = 0;
		heavy = 0;
		for(i=0; i<armors.Size(); i+=1)
		{
			if(i==0){ p=0.5;}
                                           if(i==1){ p=0.125;}
                                           if(i==2){ p=0.25;}
                                           if(i==3){ p=0.125;}
				
                                       armorType = witcher.inv.GetArmorType(armors[i]);
			if(armorType == EAT_Light)
				 light += p;
			else if(armorType == EAT_Medium)
				medium += p;
			else if(armorType == EAT_Heavy)
				heavy += p;
                                            else if(armorType == EAT_Undefined)
				undefined += p;
		}



speedMulti=(1+(0.35*undefined))*(1-(0.01*medium))*(1-(0.20*heavy));

encumbrance = witcher.GetEncumbrance();
if(encumbrance>0&& encumbrance<=20){speedMulti=speedMulti*1.1;}
if(encumbrance>20&& encumbrance<=40){speedMulti=speedMulti*1;}
if(encumbrance>40&& encumbrance<=60){speedMulti=speedMulti*0.95;}
if(encumbrance>60&& encumbrance<=100){speedMulti=speedMulti*0.90;}
/*if(encumbrance>80&& encumbrance<=100){speedMulti=speedMulti*0.85;}*/
if(encumbrance>100&& encumbrance<=120){speedMulti=speedMulti*0.85;}
if(encumbrance>120&& encumbrance<=140){speedMulti=speedMulti*0.80;}
if(encumbrance>140){speedMulti=speedMulti*0.70;}
/*speedMulti=(1+(0.0625*undefined))*(1-(0.0375*medium))*(1-(0.0625*heavy));*/
//theGame.GetGuiManager().ShowUserDialogAdv(0, "Speed", speedMulti+" M:"+medium+" H:"+heavy+" U:"+undefined+" E:"+encumbrance, false, UDB_Ok);
thePlayer.SetAnimationSpeedMultiplier(speedMulti);
}