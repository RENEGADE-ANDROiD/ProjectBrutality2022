// Dynamic lights for PB_PhysicalBonuses (1BON shards)
Pulselight APBonusLight
{
	color 0.1 1.0 0.1
	size 10
	secondarySize 30
	interval 0.5
	offset 0 0 0
}

Pulselight HPBonusLight
{
	color 0.1 1.0 1.0
	size 10
	secondarySize 30
	interval 0.5
	offset 0 0 0
}

Object CrueltyBonushealth_
{
	Frame 1BONA { Light HPBonusLight }
}

Object CrueltyBonusArmor_
{
	Frame 1BONB { Light APBonusLight }
}
