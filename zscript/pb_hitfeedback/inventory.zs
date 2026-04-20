// MIT License
// Copyright (c) 2026 generic name guy
// This file is part of "PB Damage Feedback" (addon)

class PB_HitFeedback_Inventory : Inventory 
{
    /*override void AbsorbDamage(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags)
    {
        
    }*/

    enum EHPCounters {
        P_CURRENT,
        P_OLD
    };

    int playerArmor[2], playerHealth[2];

    override void DoEffect()
    {
        Super.DoEffect();

        playerArmor[P_CURRENT] = owner.CountInv( "BasicArmor" );
        playerHealth[P_CURRENT] = owner.Health;

        int armorDelta = min( 0, playerArmor[P_OLD] - playerArmor[P_CURRENT] );
        int healthDelta = min( 0, playerHealth[P_OLD] - playerHealth[P_CURRENT] );

        if( playerArmor[P_OLD] > playerArmor[P_CURRENT] && playerArmor[P_CURRENT] <= 0 && playerHealth[P_CURRENT] > 0 )
        {
            EventHandler.SendInterfaceEvent( owner.PlayerNumber(), "PB_hf_ShieldBroken", armorDelta + healthDelta );
            owner.A_StartSound( "hud/shieldbreak", flags: CHANF_UI );
        }

        playerArmor[P_OLD] = playerArmor[P_CURRENT];
        playerHealth[P_OLD] = playerHealth[P_CURRENT];
    }
}

