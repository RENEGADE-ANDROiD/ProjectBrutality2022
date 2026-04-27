class Nitromite : Actor
{
	int jumpdist;
	int maxledgeheight;
	double diffz;
	double planez;
	vector3 chkpos;
	override void PostBeginPlay()
	{
		jumpdist = 256;			// distance for jump attacks and jumping to ceilings/floors
		maxledgeheight = 64;	// max height of ledges to jump up to and drop down from
		MaxDropOffHeight = maxledgeheight;
		A_AttachLightDef("nml", "Nitromitelight");
		Super.PostBeginPlay();
	}
	
	Default
	{
		//$Category Monsters
		//$Title "Nitromite"
		Health 30;
		PainChance 0;
		Speed 8;
		scale 0.8;
		Radius 13;
		Height 20;
		Mass 50;
		Monster;
		+FLOORCLIP;
		SeeSound "nitromite/see";
		ActiveSound "nitromite/act";
		DeathSound "nitromite/death";
		Obituary "%o was killed by a Nitromite.";
	}
	States
	{
	Spawn:
		NTMT AD 10 A_Look;
		Loop;
	See:
		NTMT AAABBBCCCDDDEEEFFF 1 
		{
			A_Chase();

			//Behavior while on floor
			if (pos.z == floorz)
			{
				
				//jump on ledges
				int zat = GetZAt(radius*3,0,0);
				if (zat > floorz + MaxStepHeight && zat <= floorz + maxledgeheight)
				{
					FLineTraceData ltd;
					bool hit = LineTrace(angle, radius*3, 0, TRF_THRUSPECIES|TRF_SOLIDACTORS, data:ltd);
					if (hit && ltd.HitType == TRACE_HitWall && ltd.LinePart == Side.Bottom) SetStateLabel("JumpOnLedge");
				}
				// jump at target
				if (target && CheckSight(target) && Distance3D(target) <= jumpdist + target.radius) SetStateLabel("JumpAttack");
				// jump to ceiling randomly unless under a sky texture
				if (GetAge() % 70 == 0 && !random(0,2))
				{
					diffz = ceilingz - pos.z;
					let tex = TexMan.CheckForTexture("F_SKY1"); 
					if (diffz >= 64 && diffz <= jumpdist
						&& sector.PointInSector(pos.xy).GetTexture(sector.ceiling) != tex) SetStateLabel("JumpToCeiling");
				}
			}
			//Behavior while on ceiling
			else if (pos.z + height == ceilingz)
			{
				//drop to floor if encountering a ledge on the ceiling or if within reach of a target
				if (GetZAt(radius*2,0,0,GZF_CEILING) != ceilingz
					|| (target && Distance2D(target) < target.radius)) SetStateLabel("JumpToFloor");
				//drop to floor randomly
				if (GetAge() % 70 == 0 && !random(0,2))
				{
					diffz = pos.z + height - floorz;
					if (diffz >= 64 && diffz <= jumpdist) SetStateLabel("JumpToFloor");
				}
			}
			// explode when near target
			A_CheckTargetProximity();
		}
		Loop;
	Wander:
		NTMT AAAABBBBCCCCDDDDEEEEFFFF 1 A_Wander;
		Goto See;
	JumpToCeiling:
		NTMT G 10;
		NTMT H 1
		{
			bNOGRAVITY = true;
			ThrustThingZ(0, diffz * 0.2, bYFLIP, 0);
			A_Startsound("nitromite/jump");
		}
		NTMT HHHHHHHHHI 1
		{
			A_CheckTargetProximity();
			if (ceilingz - pos.z > diffz * 0.667) bYFLIP = true;
			if (pos.z + height == ceilingz) SetStateLabel("Landing");
		}
		Goto JumpToCeiling+11;
	JumpToFloor:
		NTMT G 10;
		NTMT H 1
		{
			bNOGRAVITY = false;
			ThrustThingZ(0, diffz * 0.1, bYFLIP, 0);
			A_Startsound("nitromite/jump");
		}
		NTMT LLLLLLLLLI 1
		{
			A_CheckTargetProximity();
			if (pos.z + height - floorz < diffz * 0.667) bYFLIP = false;
			if (pos.z == floorz) SetStateLabel("Landing");
		}
		Goto JumpToFloor+11;
	JumpAttack:
		NTMT G 10 A_FaceTarget;
		NTMT H 1
		{
			chkpos = pos;
			bNOGRAVITY = false;
			if (target)
			{
				ThrustThingZ(0,clamp(target.height*0.5,0,32),bYFLIP,0);
				A_Recoil(-Distance2D(target) * 0.1);
			}
			A_Startsound("nitromite/jump");
		}
		NTMT HHHHHHHHHI 1
		{
			A_CheckTargetProximity();
			if (ceilingz - pos.z < diffz * 0.667) bYFLIP = false;
			if (pos.z == floorz) SetStateLabel("Landing");
		}
		Goto JumpAttack+11;
	JumpOnLedge:
		NTMT G 10;
		NTMT H 1
		{
			chkpos = pos;
			ThrustThingZ(0,maxledgeheight*0.75,0,0);
			A_Recoil(-maxledgeheight*0.25);
			A_Startsound("nitromite/jump");
		}
		NTMT HHH 3
		{	
			A_Recoil(-1);
			if (pos.z == floorz) SetStateLabel("Landing");
		}
		NTMT I 3
		{
			A_Recoil(-1);
			if (pos.z == floorz) SetStateLabel("Landing");
		}
		Goto JumpOnLedge+5;
	Landing:
		NTMT J 10 
		{
			A_Stop();
			A_Startsound("nitromite/thud");
			if (chkpos == pos) SetStateLabel("Wander");
		}
		Goto See;
	Death:
		NTMT N 3 
		{
			bNoGravity = false;
			A_Scream();
			A_NoBlocking();
		}
		NTMT N 3 A_SpawnDebris("NitromiteGibs");
		NTMT O 5;
		NTMT P 5 
		{
			A_RemoveLight("nml");
			bNOCLIP = true;
		}
		NTMT Q 5;		
		NTMT R 5;
		NTMT S -1;
		Stop;
	XDeath:
		NTMT K 4 Bright
		{
			bNoGravity = true;
			A_NoBlocking();
			A_RemoveLight("nml");
			A_Startsound("nitromite/explode");
			A_Explode(random(30,60),192,XF_NOTMISSILE);
		}
		NTMT X 3 Bright 
		{
			A_Setscale(0.7);
			A_Stop();
		}
		NTMT Y 3 Bright;
		NTMT Z 3 Bright;
		Stop;
	}
	
	void A_CheckTargetProximity()
	{
		if (target && Distance3D(target) < radius*2 + target.radius)
		{
			A_Stop();
			SetStateLabel("XDeath");
		}
	}
}

class NitromiteGibs : Actor
{
	int rolldir;
	Default
	{
		Health 3;
		+THRUACTORS;
		+NOTONAUTOMAP;
		+NOBLOCKMAP;
		+NOTELEPORT;
		+ROLLSPRITE;
		+ROLLCENTER;
		scale 0.7;
	}
	States
	{
	Spawn:
		TNT1 A 0 Nodelay
		{
			rolldir = randompick(-30,-15,15,30) + random(-10,10);
		}
	See:
		NTMT T 1
		{
			roll += rolldir;
			if (pos.z == floorz) SetStateLabel("Explode");
		}
		Loop;
	Explode:
		TNT1 A 0
		{
			A_Stop();
			A_Startsound("nitromite/gibs");
		}
		NTMT T 35;
		NTMT U 3 Bright 
		{
			A_Setscale(0.6);
			A_Startsound("nitromite/explode",pitch:frandom(1.15,1.3));
			A_Explode(random(15,30),96,XF_NOTMISSILE);
		}
		NTMT V 3 Bright;
		NTMT W 3 Bright;
		Stop;
	}
}