// PB Weapons Pack DC0S / TDS1 hull sprites: SPRITES/WEAPONS/Slot3/CSSG/Casings/

class ShotCaseSpawnDanmaku : RifleCaseSpawn
{
	States
	{
	Spawn:
		TNT1 A 0;
		TNT1 A 1 A_SpawnItemEX("DanmakuCasing", 0, 0, -7, frandom(3, 5), frandom(3, 4), frandom(8, 11));
		Stop;
	}
}

class DanmakuCasing : ShotgunCasing
{
	States
	{
		Spawn:
		TNT1 A 1;
		TNT1 A 0 A_Jump(256, "SpinFast", "SpinMedium", "SpinSlow");
		SpinFast:
				DC0S ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ 2 {
				A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
				A_SetRoll(roll + frandom(-80, -120));
					}
		SpinMedium:
				DC0S ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ 2 {
				A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
				A_SetRoll(roll + frandom(-25, -90));
					}
		SpinSlow:
				DC0S ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ 2 {
				A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
				A_SetRoll(roll + 36);
					}
		Goto Death;

		Death:
		  TNT1 A 0 A_StopSound(2);
		  TNT1 I 0 A_SetRoll(0);
		  TNT1 A 0 A_Jump(256, "Case1", "Case2", "Case3", "Case4", "Case5", "Case6", "Case7", "Case8", "Case9", "Case10");
		Case1:
			DC0S K 1;
			Goto Rest;
		Case2:
			DC0S L 1;
			Goto Rest;
		Case3:
			DC0S M 1;
			Goto Rest;
		Case4:
			DC0S N 1;
			Goto Rest;
		Case5:
			DC0S O 1;
			Goto Rest;
		Case6:
			DC0S P 1;
			Goto Rest;
		Case7:
			DC0S Q 1;
			Goto Rest;
		Case8:
			DC0S R 1;
			Goto Rest;
		Case9:
			DC0S S 1;
			Goto Rest;
		Case10:
			DC0S T 1;
			Goto Rest;
		Rest:
			"####" "###########################################" 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
			"####" "#" -1;
			Stop;
	}
}

class TDoomCasing : ShotgunCasing
{
	States
	{
		Spawn:
		TNT1 A 1;
		TNT1 A 0 A_Jump(256, "SpinFast", "SpinMedium", "SpinSlow");
		SpinFast:
				TDS1 ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ 2 {
				A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
				A_SetRoll(roll + frandom(-80, -120));
					}
		SpinMedium:
				TDS1 ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ 2 {
				A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
				A_SetRoll(roll + frandom(-25, -90));
					}
		SpinSlow:
				TDS1 ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ 2 {
				A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
				A_SetRoll(roll + 36);
					}
		Goto Death;

		Death:
		  TNT1 A 0 A_StopSound(2);
		  TNT1 I 0 A_SetRoll(0);
		  TNT1 A 0 A_Jump(256, "Case1", "Case2", "Case3", "Case4", "Case5", "Case6", "Case7", "Case8", "Case9", "Case10");
		Case1:
			TDS1 K 1;
			Goto Rest;
		Case2:
			TDS1 K 2;
			Goto Rest;
		Case3:
			TDS1 K 8;
			Goto Rest;
		Case4:
			TDS1 K 3;
			Goto Rest;
		Case5:
			TDS1 K 7;
			Goto Rest;
		Case6:
			TDS1 K 4;
			Goto Rest;
		Case7:
			TDS1 K 6;
			Goto Rest;
		Case8:
			TDS1 K 5;
			Goto Rest;
		Case9:
			TDS1 K 1;
			Goto Rest;
		Case10:
			TDS1 K 2;
			Goto Rest;
		Rest:
			"####" "###########################################" 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
			"####" "#" -1;
			Stop;
	}
}

extend class WhitePShellCasing
{
	States
	{
		Spawn:
		TNT1 A 1;
		TNT1 A 0 A_Jump(256,"SpinFast","SpinMedium","SpinSlow");
		SpinFast:
				WCS1 ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ 2 {
				A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
				A_SetRoll(roll+frandom(-80,-120));
					}
		SpinMedium:
				WCS1 ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ 2 {
				A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
				A_SetRoll(roll+frandom(-25,-90));
					}
		SpinSlow:
				WCS1 ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ 2 {
				A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
				A_SetRoll(roll+36);
					}
		Goto Death;

		Death:
		  TNT1 A 0 A_StopSound(2);
		  TNT1 I 0 A_SetRoll(0);
		  TNT1 A 0 A_Jump(256,"Case1","Case2","Case3","Case4","Case5","Case6","Case7","Case8","Case9","Case10");
		Case1:
			WCS1 K 1;
			Goto Rest;
		Case2:
			WCS1 L 1;
			Goto Rest;
		Case3:
			WCS1 M 1;
			Goto Rest;
		Case4:
			WCS1 N 1;
			Goto Rest;
		Case5:
			WCS1 O 1;
			Goto Rest;
		Case6:
			WCS1 P 1;
			Goto Rest;
		Case7:
			WCS1 Q 1;
			Goto Rest;
		Case8:
			WCS1 R 1;
			Goto Rest;
		Case9:
			WCS1 S 1;
			Goto Rest;
		Case10:
			WCS1 T 1;
			Goto Rest;
		Rest:
			"####" "###########################################" 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
			"####" "#" -1;
			Stop;
	}
}

extend class ExplosiveShellCasing
{
	States
	{
		Spawn:
		TNT1 A 1;
		TNT1 A 0 A_Jump(256,"SpinFast","SpinMedium","SpinSlow");
		SpinFast:
				XCS1 ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ 2 {
				A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
				A_SetRoll(roll+frandom(-80,-120));
					}
		SpinMedium:
				XCS1 ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ 2 {
				A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
				A_SetRoll(roll+frandom(-25,-90));
					}
		SpinSlow:
				XCS1 ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ 2 {
				A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
				A_SetRoll(roll+36);
					}
		Goto Death;

		Death:
		  TNT1 A 0 A_StopSound(2);
		  TNT1 I 0 A_SetRoll(0);
		  TNT1 A 0 A_Jump(256,"Case1","Case2","Case3","Case4","Case5","Case6","Case7","Case8","Case9","Case10");
		Case1:
			XCS1 K 1;
			Goto Rest;
		Case2:
			XCS1 L 1;
			Goto Rest;
		Case3:
			XCS1 M 1;
			Goto Rest;
		Case4:
			XCS1 N 1;
			Goto Rest;
		Case5:
			XCS1 O 1;
			Goto Rest;
		Case6:
			XCS1 P 1;
			Goto Rest;
		Case7:
			XCS1 Q 1;
			Goto Rest;
		Case8:
			XCS1 R 1;
			Goto Rest;
		Case9:
			XCS1 S 1;
			Goto Rest;
		Case10:
			XCS1 T 1;
			Goto Rest;
		Rest:
			"####" "###########################################" 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
			"####" "#" -1;
			Stop;
	}
}

extend class FlakShellCasing
{
	States
	{
		Spawn:
		TNT1 A 1;
		TNT1 A 0 A_Jump(256,"SpinFast","SpinMedium","SpinSlow");
		SpinFast:
				CAS9 ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ 2 {
				A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
				A_SetRoll(roll+frandom(-80,-120));
					}
		SpinMedium:
				CAS9 ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ 2 {
				A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
				A_SetRoll(roll+frandom(-25,-90));
					}
		SpinSlow:
				CAS9 ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ 2 {
				A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
				A_SetRoll(roll+36);
					}
		Goto Death;

		Death:
		  TNT1 A 0 A_StopSound(2);
		  TNT1 I 0 A_SetRoll(0);
		  TNT1 A 0 A_Jump(256,"Case1","Case2","Case3","Case4","Case5","Case6","Case7","Case8","Case9","Case10");
		Case1:
			CAS9 K 1;
			Goto Rest;
		Case2:
			CAS9 L 1;
			Goto Rest;
		Case3:
			CAS9 M 1;
			Goto Rest;
		Case4:
			CAS9 N 1;
			Goto Rest;
		Case5:
			CAS9 O 1;
			Goto Rest;
		Case6:
			CAS9 P 1;
			Goto Rest;
		Case7:
			CAS9 Q 1;
			Goto Rest;
		Case8:
			CAS9 R 1;
			Goto Rest;
		Case9:
			CAS9 S 1;
			Goto Rest;
		Case10:
			CAS9 T 1;
			Goto Rest;
		Rest:
			"####" "###########################################" 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
			"####" "#" -1;
			Stop;
	}
}

extend class BuckShellCasing
{
	States
	{
		Spawn:
		TNT1 A 1;
		TNT1 A 0 A_Jump(256,"SpinFast","SpinMedium","SpinSlow");
		SpinFast:
				CASX ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ 2 {
				A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
				A_SetRoll(roll+frandom(-80,-120));
					}
		SpinMedium:
				CASX ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ 2 {
				A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
				A_SetRoll(roll+frandom(-25,-90));
					}
		SpinSlow:
				CASX ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ 2 {
				A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
				A_SetRoll(roll+36);
					}
		Goto Death;

		Death:
		  TNT1 A 0 A_StopSound(2);
		  TNT1 I 0 A_SetRoll(0);
		  TNT1 A 0 A_Jump(256,"Case1","Case2","Case3","Case4","Case5","Case6","Case7","Case8","Case9","Case10");
		Case1:
			CASX K 1;
			Goto Rest;
		Case2:
			CASX L 1;
			Goto Rest;
		Case3:
			CASX M 1;
			Goto Rest;
		Case4:
			CASX N 1;
			Goto Rest;
		Case5:
			CASX O 1;
			Goto Rest;
		Case6:
			CASX P 1;
			Goto Rest;
		Case7:
			CASX Q 1;
			Goto Rest;
		Case8:
			CASX R 1;
			Goto Rest;
		Case9:
			CASX S 1;
			Goto Rest;
		Case10:
			CASX T 1;
			Goto Rest;
		Rest:
			"####" "###########################################" 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
			"####" "#" -1;
			Stop;
	}
}

extend class FlechetShellCasing
{
	States
	{
		Spawn:
		TNT1 A 1;
		TNT1 A 0 A_Jump(256,"SpinFast","SpinMedium","SpinSlow");
		SpinFast:
				CAF8 ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ 2 {
				A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
				A_SetRoll(roll+frandom(-80,-120));
					}
		SpinMedium:
				CAF8 ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ 2 {
				A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
				A_SetRoll(roll+frandom(-25,-90));
					}
		SpinSlow:
				CAF8 ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ 2 {
				A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
				A_SetRoll(roll+36);
					}
		Goto Death;

		Death:
		  TNT1 A 0 A_StopSound(2);
		  TNT1 I 0 A_SetRoll(0);
		  TNT1 A 0 A_Jump(256,"Case1","Case2","Case3","Case4","Case5","Case6","Case7","Case8","Case9","Case10");
		Case1:
			CAF8 K 1;
			Goto Rest;
		Case2:
			CAF8 L 1;
			Goto Rest;
		Case3:
			CAF8 M 1;
			Goto Rest;
		Case4:
			CAF8 N 1;
			Goto Rest;
		Case5:
			CAF8 O 1;
			Goto Rest;
		Case6:
			CAF8 P 1;
			Goto Rest;
		Case7:
			CAF8 Q 1;
			Goto Rest;
		Case8:
			CAF8 R 1;
			Goto Rest;
		Case9:
			CAF8 S 1;
			Goto Rest;
		Case10:
			CAF8 T 1;
			Goto Rest;
		Rest:
			"####" "###########################################" 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
			"####" "#" -1;
			Stop;
	}
}
