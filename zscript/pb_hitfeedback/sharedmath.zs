// MIT License
// Copyright (c) 2026 generic name guy
// This file is part of "PB Damage Feedback" (addon)

class PB_HitFeedback_Math abstract {
    clearscope static double LinearMapClamped( double val, double o_Min, double o_Max, double n_Min, double n_Max, double ret_Min, double ret_Max ) 
    {
        return clamp( PB_HitFeedback_Math.LinearMap( val, o_Min, o_Max, n_Min, n_Max ), ret_Min, ret_Max );
    }

    //[inkoalawetrust] Written by Agent_Ash, makes the Val ranging from O_Min to O_Man be crushed down to the range of N_Min and N_Max.
	//Useful for example for compressing distances to a range of 0 to 1.0.
	ClearScope Static Double LinearMap (Double Val, Double O_Min, Double O_Max, Double N_Min, Double N_Max) 
	{
		Return (Val - O_Min) * (N_Max - N_Min) / (O_Max - O_Min) + N_Min;
	}

    static double Lerp(double a, double b, double lerpFactor)
	{
		double result = ((1.f - lerpFactor) * a) + (lerpFactor * b);
		return result;
	}
}