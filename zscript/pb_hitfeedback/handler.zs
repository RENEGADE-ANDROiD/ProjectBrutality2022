// MIT License
// Copyright (c) 2026 generic name guy
// This file is part of "PB Damage Feedback" (addon)

class PB_HitFeedback_Handler : EventHandler
{
    override void PlayerEntered( PlayerEvent e )
	{
		PlayerPawn player = PlayerPawn( players[e.PlayerNumber].mo );

        if( player )
            player.GiveInventoryType( "PB_HitFeedback_Inventory" );

        cachedOverlays[0] = TexMan.CheckForTexture( "Graphics/visorcrack1.png" );
        cachedOverlays[1] = TexMan.CheckForTexture( "Graphics/crackflash1.png" );
        cachedOverlays[2] = TexMan.CheckForTexture( "Graphics/fuckasscircle.png" );
        S_StartSound("hud/shieldbreak", 0, volume: 0);
	}

    ui float shakeMagnitude;
    ui double animationProgress[2];
    ui int animationTime;
    const ANIM_DURATION = double( floor( 2.0 * TICRATE ) );
    ui vector2 overlayPos[2];
    TextureID cachedOverlays[3];

    override void InterfaceProcess( ConsoleEvent e )
    {
        if( e.name == "PB_hf_ShieldBroken" )
        {
            shakeMagnitude = 1;
            animationProgress[0] = 0.f;
            animationProgress[1] = 0.f;
            animationTime = ANIM_DURATION;
        }
    }

    override void UiTick()
    {
        animationProgress[1] = animationProgress[0];
        animationProgress[0] = 1.f - ( animationTime / ANIM_DURATION );

        overlayPos[1] = overlayPos[0];
        overlayPos[0] = ( cfrandom( -50, 50 ), cfrandom( -50, 50 ) ) * shakeMagnitude;

        shakeMagnitude *= 0.7;

        if( animationTime > 0 ) animationTime--;

    }

    override void RenderUnderlay( RenderEvent e )
    {
        double i_animationProgress = GetTicFracInterpolation( animationProgress[1], animationProgress[0], e.FracTic );
        vector2 i_shake = overlayPos[0];
        //( GetTicFracInterpolation( overlayPos[1].x, overlayPos[0].x, e.FracTic ), GetTicFracInterpolation( overlayPos[1].y, overlayPos[0].y, 1 ) );

        double overlayScale, overlay2Scale, overlay3Scale;
        /*if( i_animationProgress < 0.26 )
            overlayScale = PB_HitFeedback_Math.LinearMapClamped( i_animationProgress, 0.0, 0.1, 1.1, 1.f, 1.f, 1.1 );
        else*/
            overlayScale = PB_HitFeedback_Math.LinearMapClamped( i_animationProgress, 0.26, 1.f, 1.f, 3, 1.f, 3 );

        double overlayAlpha, overlay2Alpha, overlay3Alpha;

        //    overlayAlpha = PB_HitFeedback_Math.LinearMapClamped( i_animationProgress, 0.0, 0.1, 0.f, 1.f, 0.f, 1.f );
            overlayAlpha = PB_HitFeedback_Math.LinearMapClamped( i_animationProgress, 0.26, 1.f, 1.f, 0.f, 0.f, 1.f );

        /*if(i_animationProgress <= 0.07 || ( i_animationProgress >= 0.2 && i_animationProgress <= 0.26 ) || i_animationProgress > 0.3 )
            
        else
            overlay2Alpha = 0;*/

        overlay2Alpha = PB_HitFeedback_Math.LinearMapClamped( i_animationProgress, 0.f, 0.57, 1.f, 0.f, 0.f, 1.f );
        overlay2Scale = PB_HitFeedback_Math.LinearMapClamped( i_animationProgress, 0.f, 0.57, 1.f, 3, 1.f, 3 );

        overlay3Alpha = PB_HitFeedback_Math.LinearMapClamped( i_animationProgress, 0.f, 1, 1.f, 0.f, 0.f, 1.f );
        overlay3Scale = PB_HitFeedback_Math.LinearMapClamped( i_animationProgress, 0.f, 1, 1.f, 4.f, 1.f, 4.f );

        if( animationTime > 0 ) {
            Screen.DrawTexture(
                cachedOverlays[2], false, 
                Screen.GetWidth() / 2.f, Screen.GetHeight() / 2.f,
                DTA_DestWidth, Screen.GetWidth(), DTA_DestHeight, Screen.GetWidth(), 
                DTA_Alpha, overlay3Alpha * 0.1,
                DTA_CenterOffset, true, 
                DTA_ScaleX, overlay3Scale, DTA_ScaleY, overlay3Scale,
                DTA_LegacyRenderStyle, STYLE_Add
            );

            Screen.DrawTexture(
                cachedOverlays[0], false, 
                Screen.GetWidth() / 2.f + i_shake.x, Screen.GetHeight() / 2.f + i_shake.y,
                DTA_DestWidth, Screen.GetWidth(), DTA_DestHeight, Screen.GetHeight(), 
                DTA_Alpha, overlayAlpha * 0.5,
                DTA_CenterOffset, true, 
                DTA_ScaleX, overlayScale + 0.1, DTA_ScaleY, overlayScale + 0.1
            );

            Screen.DrawTexture(
                cachedOverlays[1], false, 
                Screen.GetWidth() / 2.f, Screen.GetHeight() / 2.f,
                DTA_DestWidth, Screen.GetWidth(), DTA_DestHeight, Screen.GetHeight(), 
                DTA_Alpha, (overlayAlpha * overlay2Alpha) * 0.5,
                DTA_CenterOffset, true, 
                DTA_ScaleX, overlay2Scale + 0.1, DTA_ScaleY, overlay2Scale + 0.1,
                DTA_LegacyRenderStyle, STYLE_Add
            );
        }
    }

    ui double GetTicFracInterpolation( double poll1, double poll2, double ticFrac )
    {
        return poll1 * ( 1.f - ticFrac ) + poll2 * ticFrac;
    }
}
