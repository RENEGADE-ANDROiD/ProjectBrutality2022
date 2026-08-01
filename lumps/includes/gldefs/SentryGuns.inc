PointLight PB_SentryMediumOrange { Color 1.0 0.25 0.0 Size 60 }
FlickerLight PB_SentryMissile1
{
	Color 1 0.7 0
	Size 36
	SecondarySize 44
	Chance 0.2
}
Object PB_SentryGun { Frame SENTB { Light ZOMBIEATK } }
Object PB_SentryGun_Heavy { Frame TTR2 { Light ZOMBIEATK } }
Object PB_Sentry_NapalmBall { Frame WARN { Light PB_SentryMediumOrange } }
Object PB_Sentry_Pulverizer { Frame HRODA { Light PB_SentryMissile1 } }
