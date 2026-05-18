//Dummy actors containing blood colors needed for Doom monsters. *Special thanks to inkoalawetrust

Class AD_BloodDummyBase : Actor
{
	override void PostBeginPlay() //Prevents spawning outside of intended purpose
	{
		Destroy();
	}
}

Class AD_BlueBloodDummy : AD_BloodDummyBase
{
	Default
	{
		BloodColor "Blue";
	}
}

Class AD_GreenBloodDummy : AD_BloodDummyBase
{
	Default
	{
		BloodColor "0 60 0";
	}
}

Class AD_DarkRedBloodDummy : AD_BloodDummyBase
{
	Default
	{
		BloodColor "80 10 10";
	}
}

Class AD_YellowBloodDummy : AD_BloodDummyBase
{
	Default
	{
		BloodColor "Yellow";
	}
}

Class AD_RedBloodDummy : AD_BloodDummyBase
{
	Default
	{
		BloodColor "Red";
	}
}

Class AD_LimeGreenBloodDummy : AD_BloodDummyBase
{
	Default
	{
		BloodColor "LimeGreen";
	}
}
