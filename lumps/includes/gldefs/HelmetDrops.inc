// PB_HelmetDrops: point lights + brightmaps for 3BON
Pointlight DroppedHelm1
{
	color 1.0 0.0 0.0
	size 5
}

Pointlight DroppedHelm2
{
	color 1.0 0.0 0.0
	size 10
}

Pointlight DroppedHelm3
{
	color 1.0 0.0 0.0
	size 15
}

Pointlight DroppedHelm4
{
	color 1.0 0.0 0.0
	size 30
}

Object PB_DroppedHelmetItem
{
	Frame 3BONB { light DroppedHelm1 }
	Frame 3BONC { light DroppedHelm2 }
	Frame 3BOND { light DroppedHelm3 }
	Frame 3BONE { light DroppedHelm4 }
}

Brightmap Sprite 3BONB0 { map "Brightmaps/HelmetDrops/3BONB0.png" }
Brightmap Sprite 3BONC0 { map "Brightmaps/HelmetDrops/3BONC0.png" }
Brightmap Sprite 3BOND0 { map "Brightmaps/HelmetDrops/3BOND0.png" }
Brightmap Sprite 3BONE0 { map "Brightmaps/HelmetDrops/3BONE0.png" }
