class BigFlamesIG_SP : BigFlamesIG
{
}

class GolideExplosiveProjectile : ExplosiveProjectile
{
}

class DarkDanmakuProjectile : DanmakuProjectile
{
	default
	{
		damage (10);
	}
}

class WPhosphorusProjectile_Golide : WPhosphorusProjectile
{
	states
	{
		Spawn:
			TNT1 A 0;
			goto Fly;
		Fly:
			"DBAC" A 1 BRIGHT {
				spawnflameFlare(pos);
				SpawnFlameTrail(pos);
			}
			loop;
		Death:
		Crash:
		XDeath:
			TNT1 A 0 {
				if (pos.z < floorz)
					SetZ(floorz);
				A_Explode(10, 36);
				A_SpawnWPSmoke(pos);
				for (int i = 0; i < random(3, 6); i++);
					A_SpawnItemEx("BigFlamesIG_SP", frandom(-15, 15), frandom(-15, 15), frandom(-5, 5), 0, 0, 0, 0, SXF_NOCHECKPOSITION);
				spawnflameFlare(pos, true);
				A_SpawnItemEx("ExplosionFlareSpawner", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
				A_StartSound("FAREXPL", 3);
			}
			stop;
	}
}
