//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// VR Toolkit Shaderset 
//
// external shader code, modified to work with the VR toolkit.
//
// by Alexandre Miguel Maia - Retrolux
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Radial Mask check for VR
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
/*
from Holger Frydrych VR_CAS_Color.fx shader
*/

#if VRT_USE_CENTER_MASK && (VRT_SHARPENING_MODE != 0 || VRT_ANTIALIASING_MODE != 0) // && __RENDERER__ >= 0xa000 // If DX10 or higher

/**
* Smoothes the circular mask transition
*
* Mode:  0 - Disable mask smoothing
*        1 - Enable mask smoothing to reduce the visiblity of the edge of the mask
*/
#ifndef _MASK_SMOOTH
    #define _MASK_SMOOTH 1
#endif

/**
* Sets the circular mask work on the backbuffer that has both eyes merged into a single texture (left + Right)
* This is the default behaivor from reshade right now.
*
* Mode:  0 - Center Mask per eye
*        1 - Combined masks with a circle for the left eye and one for the right
*/
#ifndef _MASK_COMBINED_EYES
    #define _MASK_COMBINED_EYES 1
#endif


uniform int CircularMaskHelp <
	ui_category = "Circular Masking Mask"; 
	ui_type = "radio"; 
	ui_label = " ";
	ui_text = "IMPORTANT: Adjust \"Circle Radius\" for your VR headset below";
>; 

uniform float iCircularMaskSize <
    ui_category = "Circular Masking Mask";
    ui_type = "slider";
    ui_label = "Circle Radius (?)";
    ui_tooltip = "Adjusts the size of the circle from the center of the screen towards the edges.\n"
                 "This can slightly improve the performance the smaller the radius is.\n\n"
                 "";
    ui_min = 0.0; ui_max = 1.0; ui_step = 0.01;
> = 0.30;

#if _MASK_SMOOTH
uniform float iCircularMaskSmoothness <
    ui_category = "Circular Masking Mask";
    ui_type = "slider";
    ui_label = "Mask Smoothness";
    ui_tooltip = "Increases the smootness of the circular mask to allow smaller masks while reducing the prominence of the edge";
    ui_min = 1.0; ui_max = 10; ui_step = 0.1;
> = 5.0;
#endif

uniform bool iCircularMaskPreview < __UNIFORM_INPUT_BOOL1
	ui_category = "Circular Masking Mask";    
    ui_label = "Mask Preview";
	ui_tooltip = "Preview circular mask for easy adjustments.";
> = false;


float CircularMask( float2 texcoord )
{
    float2 fromCenter;
   
    #if _MASK_COMBINED_EYES
        fromCenter = float2(texcoord.x < 0.5 ? 0.3 : 0.7, 0.5) - texcoord;
    #else
        fromCenter = float2(0.5, 0.5) - texcoord;
    #endif

    //correct aspect ratio of mask circle                   
    fromCenter.x *= ReShade::AspectRatio;

    float distSqr = dot(fromCenter, fromCenter);

    // just apply sharpened image when inside the center mask
    float maskSizeSqr = iCircularMaskSize * iCircularMaskSize;
    if (distSqr < maskSizeSqr){
        #if _MASK_SMOOTH
            float diff = (distSqr/maskSizeSqr);
            return 1 - pow(diff,iCircularMaskSmoothness);
        #else
            return 1;
        #endif
    } else{
        return 0;
    }
}

#endif

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Sharpen Shader (FilmicAnamorphSharpen.fx)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
/*
Filmic Anamorph Sharpen PS v1.4.1 (c) 2018 Jakub Maximilian Fober

This work is licensed under the Creative Commons
Attribution-ShareAlike 4.0 International License.
To view a copy of this license, visit
http://creativecommons.org/licenses/by-sa/4.0/.
*/

#if (VRT_SHARPENING_MODE == 1)

uniform int VRT_SharpeningMode1 <
	ui_category = "Sharpening"; 
	ui_type = "radio"; 
	ui_label = " ";
	ui_text = "MODE 1: Filmic Anamorph Sharpen";
>; 

uniform float Strength < __UNIFORM_SLIDER_FLOAT1
	ui_label = "Strength";
    ui_category = "Sharpening";
    ui_category_closed = false;
	ui_min = 0.0; ui_max = 500; ui_step = 1;
> = 250.0;

uniform float Offset < __UNIFORM_SLIDER_FLOAT1
    ui_label = "Radius";
    ui_tooltip = "High-pass cross offset in pixels";
    ui_category = "Sharpening";
    ui_min = 0.0; ui_max = 2.0; ui_step = 0.01;
> = 0.10;

uniform float Clamp < __UNIFORM_SLIDER_FLOAT1
    ui_label = "Clamping";
    ui_category = "Sharpening";
    ui_min = 0.5; ui_max = 1.0; ui_step = 0.001;
> = 0.525;

uniform bool Preview < __UNIFORM_INPUT_BOOL1
    ui_label = "Preview sharpen layer";
	ui_category = "Sharpening";    
	ui_tooltip = "Preview sharpen layer and mask for adjustment.\n"
    		     "If you don't see red strokes,\n"
        	     "try changing Preprocessor Definitions in the Settings tab.";
    
> = false;



// RGB to YUV709 Luma
static const float3 LumaCoefficient = float3(0.2126, 0.7152, 0.0722);

// Overlay blending mode
float Overlay(float LayerA, float LayerB)
{
    float MinA = min(LayerA, 0.5);
    float MinB = min(LayerB, 0.5);
    float MaxA = max(LayerA, 0.5);
    float MaxB = max(LayerB, 0.5);
    return 2.0 * (MinA * MinB + MaxA + MaxB - MaxA * MaxB) - 1.5;
}

// Overlay blending mode for one input
float Overlay(float LayerAB)
{
    float MinAB = min(LayerAB, 0.5);
    float MaxAB = max(LayerAB, 0.5);
    return 2.0 * (MinAB * MinAB + MaxAB + MaxAB - MaxAB * MaxAB) - 1.5;
}

// Sharpen pass
float3 FilmicAnamorphSharpenPS(float4 backBuffer, float4 pos : SV_Position, float2 UvCoord : TEXCOORD0) : COLOR
{
    // Sample display image
    float3 Source = backBuffer.rgb;

    // Get pixel size
	float2 Pixel = BUFFER_PIXEL_SIZE * Offset;

    float2 NorSouWesEst[4] = {
        float2(UvCoord.x, UvCoord.y + Pixel.y),
        float2(UvCoord.x, UvCoord.y - Pixel.y),
        float2(UvCoord.x + Pixel.x, UvCoord.y),
        float2(UvCoord.x - Pixel.x, UvCoord.y)
    };

    // Luma high-pass color
    float HighPassColor = 0.0;
    
	[unroll]
    for(int s = 0; s < 4; s++)
        HighPassColor += dot(tex2D(backBufferSamplerScalable, NorSouWesEst[s]).rgb, LumaCoefficient);
    
	HighPassColor = 0.5 - 0.5 * (HighPassColor * 0.25 - dot(Source, LumaCoefficient));

    // Sharpen strength
    HighPassColor = lerp(0.5, HighPassColor, Strength);

    // Clamping sharpen
    HighPassColor = (Clamp != 1.0) ? max(min(HighPassColor, Clamp), 1.0 - Clamp) : HighPassColor;

    float3 Sharpen = float3(
        Overlay(Source.r, HighPassColor),
        Overlay(Source.g, HighPassColor),
        Overlay(Source.b, HighPassColor)
    );

    // Preview mode ON
    return Preview ? HighPassColor : Sharpen;
}
#endif

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// AMD FidelityFX Contrast Adaptive Sharpening (CAS.fx)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
/* Copyright (c) 2017-2019 Advanced Micro Devices, Inc. All rights reserved. */

#if (VRT_SHARPENING_MODE == 2)

uniform int VRT_SharpeningMode2 <
	ui_category = "Sharpening"; 
	ui_type = "radio"; 
	ui_label = " ";
	ui_text = "MODE 2: AMD Fidelity FX (CAS)";
>;

uniform float Contrast <
	ui_type = "slider";
    ui_label = "Contrast Adaptation";
    ui_tooltip = "Adjusts the range the shader adapts to high contrast (0 is not all the way off).  Higher values = more high contrast sharpening.";
    ui_category = "Sharpening";
    ui_category_closed = false;
	ui_min = 0.0; ui_max = 1.0;  ui_step = 0.01;
> = 0.0;

uniform float Sharpening <
	ui_type = "slider";
    ui_label = "Sharpening intensity";
    ui_tooltip = "Adjusts sharpening intensity by averaging the original pixels to the sharpened result.  1.0 is the unmodified default.";
    ui_category = "Sharpening";
	ui_min = 0.0; ui_max = 5.0; ui_step = 0.01;
> = 1.0;


// RGB to YUV709 Luma
static const float2 pixelOffset = BUFFER_PIXEL_SIZE * 0.5;

float3 CASPass(float4 backBuffer, float4 vpos : SV_Position, float2 texcoord : TexCoord) : COLOR
{
	// fetch a 3x3 neighborhood around the pixel 'e',
	//  a b c
	//  d(e)f
	//  g h i
	
	float3 b = tex2Doffset(backBufferSampler, texcoord, int2(0, -1)).rgb;
	float3 d = tex2Doffset(backBufferSampler, texcoord, int2(-1, 0)).rgb;
 
#if __RENDERER__ >= 0xa000 // If DX10 or higher
	float4 red_efhi = tex2DgatherR(backBufferSampler, texcoord + pixelOffset);
	
	//float3 e = float3( red_efhi.w, red_efhi.w, red_efhi.w);
	float3 e = backBuffer.rgb;
	float3 f = float3( red_efhi.z, red_efhi.z, red_efhi.z);
	float3 h = float3( red_efhi.x, red_efhi.x, red_efhi.x);
	float3 i = float3( red_efhi.y, red_efhi.y, red_efhi.y);
	
	float4 green_efhi = tex2DgatherG(backBufferSampler, texcoord + pixelOffset);
	
	//e.g = green_efhi.w;
	f.g = green_efhi.z;
	h.g = green_efhi.x;
	i.g = green_efhi.y;
	
	float4 blue_efhi = tex2DgatherB(backBufferSampler, texcoord + pixelOffset);
	
	//e.b = blue_efhi.w;
	f.b = blue_efhi.z;
	h.b = blue_efhi.x;
	i.b = blue_efhi.y;


#else // If DX9
	float3 e = backBuffer.rgb;
	float3 f = tex2Doffset(backBufferSampler, texcoord, int2(1, 0)).rgb;

	float3 h = tex2Doffset(backBufferSampler, texcoord, int2(0, 1)).rgb;
	float3 i = tex2Doffset(backBufferSampler, texcoord, int2(1, 1)).rgb;

#endif

	float3 g = tex2Doffset(backBufferSampler, texcoord, int2(-1, 1)).rgb; 
	float3 a = tex2Doffset(backBufferSampler, texcoord, int2(-1, -1)).rgb;
	float3 c = tex2Doffset(backBufferSampler, texcoord, int2(1, -1)).rgb;
   

	// Soft min and max.
	//  a b c             b
	//  d e f * 0.5  +  d e f * 0.5
	//  g h i             h
    // These are 2.0x bigger (factored out the extra multiply).
    float3 mnRGB = min(min(min(d, e), min(f, b)), h);
    float3 mnRGB2 = min(mnRGB, min(min(a, c), min(g, i)));
    mnRGB += mnRGB2;

    float3 mxRGB = max(max(max(d, e), max(f, b)), h);
    float3 mxRGB2 = max(mxRGB, max(max(a, c), max(g, i)));
    mxRGB += mxRGB2;

    // Smooth minimum distance to signal limit divided by smooth max.
    float3 rcpMRGB = rcp(mxRGB);
    float3 ampRGB = saturate(min(mnRGB, 2.0 - mxRGB) * rcpMRGB);

    // Shaping amount of sharpening.
    ampRGB = rsqrt(ampRGB);

    float peak = -3.0 * Contrast + 8.0;
    float3 wRGB = -rcp(ampRGB * peak);

    float3 rcpWeightRGB = rcp(4.0 * wRGB + 1.0);

    //                          0 w 0
    //  Filter shape:           w 1 w
    //                          0 w 0
    float3 window = (b + d) + (f + h);
    float3 outColor = saturate((window * wRGB + e) * rcpWeightRGB);

    // saturate the end result to avoid artifacts 
	return saturate(lerp(e, outColor, Sharpening));
}

#endif


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// LUT shader (LUT.fx)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
/*
Marty's LUT shader 1.0 for ReShade 3.0
Copyright © 2008-2016 Marty McFly
*/

#if (VRT_COLOR_CORRECTION_MODE == 1)

#ifndef fLUT_TextureName
    #define fLUT_TextureName "lut.png"
#endif

#ifndef _fLUT_TileSizeXY
    #define _fLUT_TileSizeXY 32
#endif

#ifndef _fLUT_TileAmount
    #define _fLUT_TileAmount 32
#endif

// texel size of the lut
static const float2 LUT_TEXEL_SIZE = float2(1.0 /_fLUT_TileSizeXY / _fLUT_TileAmount, 1.0 /_fLUT_TileSizeXY);

texture texLUT < source = fLUT_TextureName; > { Width = _fLUT_TileSizeXY*_fLUT_TileAmount; Height = _fLUT_TileSizeXY; Format = RGBA8; };
sampler	SamplerLUT 	{ Texture = texLUT; };

uniform int VRT_ColorCorrectionMode1 <
	ui_category = "Color Correction"; 
	ui_type = "radio"; 
	ui_label= "(?) Important Note (?)";
	ui_text = "MODE 1: LUT (image based Look Up Table)";
	ui_tooltip =
		"NOTE: For the LUT to work you need to define a proper lut texture in\n"
        "the \"Preprocessor definitions\" other than the default \"lut.png\"!";
>;

uniform float fLUT_AmountChroma < __UNIFORM_SLIDER_FLOAT1
    ui_min = 0.00; ui_max = 1.00;
    ui_label = "LUT chroma amount";
    ui_tooltip = "Intensity of color/chroma change of the LUT.";
    ui_category = "Color Correction";
> = 1.00;

uniform float fLUT_AmountLuma < __UNIFORM_SLIDER_FLOAT1
    ui_min = 0.00; ui_max = 1.00;
    ui_label = "LUT luma amount";
    ui_tooltip = "Intensity of luma change of the LUT.";
    ui_category = "Color Correction";
> = 1.00;

float3 PS_LUT_Apply(float4 backbuffer, float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : COLOR
{
    float3 color = backbuffer.rgb;
    
    float3 lutcoord = float3((color.xy*_fLUT_TileSizeXY-color.xy+0.5)*LUT_TEXEL_SIZE.xy,color.z*_fLUT_TileSizeXY-color.z);
    float lerpfact = frac(lutcoord.z);
    lutcoord.x += (lutcoord.z-lerpfact)*LUT_TEXEL_SIZE.y;

    float3 lutcolor = lerp(tex2D(SamplerLUT, lutcoord.xy).xyz, tex2D(SamplerLUT, float2(lutcoord.x+LUT_TEXEL_SIZE.y,lutcoord.y)).xyz,lerpfact);

   // only process linear interpolation when needed 
   if( fLUT_AmountChroma != 1 || fLUT_AmountLuma != 1){
     	color.xyz = lerp(normalize(color.xyz), normalize(lutcolor.xyz), fLUT_AmountChroma) *
    	            lerp(length(color.xyz),    length(lutcolor.xyz),    fLUT_AmountLuma);
    	
        return color.xyz;    
	}else{
    	return lutcolor;
    }
}
#endif


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Tonemap shader (Tonemap.fx)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
/**
 * Tonemap version 1.1
 * by Christian Cann Schuldt Jensen ~ CeeJay.dk
 */

#if (VRT_COLOR_CORRECTION_MODE == 2)

uniform int VRT_ColorCorrectionMode2 <
	ui_category = "Color Correction"; 
	ui_type = "radio"; 
	ui_label = " ";
	ui_text = "MODE 2: Tonemapping";
>;

uniform float Gamma < __UNIFORM_SLIDER_FLOAT1
	ui_min = 0.0; ui_max = 2.0;ui_step = 0.01;
	ui_tooltip = "Adjust midtones. 1.0 is neutral. This setting does exactly the same as the one in Lift Gamma Gain, only with less control.";
    ui_category = "Color Correction";
> = 1.0;
uniform float Exposure < __UNIFORM_SLIDER_FLOAT1
	ui_min = -1.0; ui_max = 1.0;ui_step = 0.01;
	ui_tooltip = "Adjust exposure";
    ui_category = "Color Correction";
> = 0.0;
uniform float Saturation < __UNIFORM_SLIDER_FLOAT1
	ui_min = -1.0; ui_max = 1.0;ui_step = 0.01;
	ui_tooltip = "Adjust saturation";
    ui_category = "Color Correction";
> = 0.0;

float3 TonemapPass(float4 backBuffer, float4 position : SV_Position, float2 texcoord : TexCoord) : COLOR
{
	float3 color = backBuffer.rgb;
	
    color *= pow(2.0f, Exposure); // Exposure
	color = pow(abs(color), Gamma); // Gamma

	float3 middlegray = dot(color, (1.0 / 3.0));
	float3 diffcolor = color - middlegray;
	color = (color + diffcolor * Saturation) / (1 + (diffcolor * Saturation)); // Saturation
	
	return color;
}
#endif

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Simple Dithering shader
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
/*
 from Valve Advanced VR GDC 2015 presentation
*/

#if VRT_DITHERING 

uniform float iDitheringStrength <
    ui_category = "Dithering";
    ui_type = "slider";
    ui_label = "Dithering Strength";
    ui_tooltip = "Adjusts the dithering strength to reduce banding artifacts";
    ui_min = 0.00; ui_max = 1.0;ui_step = 0.001;
> = 0.375;

uniform float timer < source = "timer"; >;

float3 ScreenSpaceDither(float2 vScreenPos: SV_Position)
{
    //Iestyn's RGB dither (7 asm instructions) from Portal2 X360 , slightly modified for VR
    float3 vDither=dot(float2(171.0,231.0),vScreenPos.xy + (timer * 0.001)).xxx;
    vDither.rgb = frac(vDither.rgb/float3(103.0,71.0,97.0)) - float3(0.5,0.5,0.5);
    return (vDither.rgb/255) * iDitheringStrength;

}
#endif

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// FXAA 3.11 Shader
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
/*  NVIDIA FXAA 3.11 by TIMOTHY LOTTES */


#if (VRT_ANTIALIASING_MODE == 1)

uniform int VRT_AntialiasingMode1 <
	ui_category = "Antialiasing"; 
	ui_type = "radio"; 
	ui_label= " ";
	ui_text = "MODE 1: FXAA";
>;

uniform float Subpix < __UNIFORM_SLIDER_FLOAT1
	ui_category = "Antialiasing"; 
	ui_min = 0.0; ui_max = 1.0;ui_step = 0.05;
	ui_tooltip = "Amount of sub-pixel aliasing removal. Higher values makes the image softer/blurrier.";
> = 1.0;

uniform float EdgeThreshold < __UNIFORM_SLIDER_FLOAT1
	ui_category = "Antialiasing"; 
	ui_min = 0.0; ui_max = 1.0;ui_step = 0.005;
	ui_label = "Edge Detection Threshold";
	ui_tooltip = "The minimum amount of local contrast required to apply algorithm.";
> = 0.125;
uniform float EdgeThresholdMin < __UNIFORM_SLIDER_FLOAT1
	ui_category = "Antialiasing"; 
	ui_min = 0.0; ui_max = 1.0;ui_step = 0.01;
	ui_label = "Darkness Threshold";
	ui_tooltip = "Pixels darker than this are not processed in order to increase performance.";
> = 0.0;

//------------------------------ Non-GUI-settings -------------------------------------------------

#ifndef FXAA_QUALITY__PRESET
	// Valid Quality Presets
	// 10 to 15 - default medium dither (10=fastest, 15=highest quality)
	// 20 to 29 - less dither, more expensive (20=fastest, 29=highest quality)
	// 39       - no dither, very expensive
	#define FXAA_QUALITY__PRESET 12
#endif


#ifndef FXAA_GREEN_AS_LUMA
	#define FXAA_GREEN_AS_LUMA 1
#endif

//-------------------------------------------------------------------------------------------------

#if (__RENDERER__ == 0xb000 || __RENDERER__ == 0xb100 || __RENDERER__ >= 0x10000)
	#define FXAA_GATHER4_ALPHA 1
	#if (__RESHADE__ < 40800)
		#define FxaaTexAlpha4(t, p) tex2Dgather(t, p, 3)
		#define FxaaTexOffAlpha4(t, p, o) tex2Dgatheroffset(t, p, o, 3)
		#define FxaaTexGreen4(t, p) tex2Dgather(t, p, 1)
		#define FxaaTexOffGreen4(t, p, o) tex2Dgatheroffset(t, p, o, 1)
	#else
		#define FxaaTexAlpha4(t, p) tex2DgatherA(t, p)
		#define FxaaTexOffAlpha4(t, p, o) tex2DgatherA(t, p, o)
		#define FxaaTexGreen4(t, p) tex2DgatherG(t, p)
		#define FxaaTexOffGreen4(t, p, o) tex2DgatherG(t, p, o)
	#endif
#endif

#define FXAA_PC 1
#define FXAA_HLSL_3 1

#include "FXAA.fxh"


float4 FXAAPixelShader(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : COLOR
{
	return FxaaPixelShader(
		texcoord, // pos
		0, // fxaaConsolePosPos
		backBufferSamplerScalable, // tex
		backBufferSamplerScalable, // fxaaConsole360TexExpBiasNegOne
		backBufferSamplerScalable, // fxaaConsole360TexExpBiasNegTwo
		BUFFER_PIXEL_SIZE, // fxaaQualityRcpFrame
		0, // fxaaConsoleRcpFrameOpt
		0, // fxaaConsoleRcpFrameOpt2
		0, // fxaaConsole360RcpFrameOpt2
		Subpix, // fxaaQualitySubpix
		EdgeThreshold, // fxaaQualityEdgeThreshold
		EdgeThresholdMin, // fxaaQualityEdgeThresholdMin
		0, // fxaaConsoleEdgeSharpness
		0, // fxaaConsoleEdgeThreshold
		0, // fxaaConsoleEdgeThresholdMin
		0 // fxaaConsole360ConstDir
	);
}
#endif
