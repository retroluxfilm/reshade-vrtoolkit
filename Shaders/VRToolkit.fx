﻿//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// VR Toolkit 
//
// Combines multiple shaders usable in VR to be processed into one single pass to improve
// performance
//
// by Alexandre Miguel Maia - Retrolux
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#include "ReShade.fxh"

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Preprocessor Settings (to hide prefix with _ or less than 10 characters)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

/**
 * Configures the sharpening/clarity modes
 *
 * Mode:  0 - Disabled sharpening
 *        1 - Filmic Anamorph Sharpening 
 *        2 - AMD FidelityFX Contrast Adaptive Sharpening
 */
#ifndef VRT_SHARPENING_MODE
    #define VRT_SHARPENING_MODE 1 
#endif

/**
 * Configures the color correction modes
 *
 * Mode:  0 - Disabled color correction
 *        1 - Uses a LUT (Look up table) for specialized and complex corrections.
 *        2 - Tonemapping to correct, gamma, exposure and color saturation.
 */
#ifndef VRT_COLOR_CORRECTION_MODE
    #define VRT_COLOR_CORRECTION_MODE 0
#endif

/**
 * Masked Sharpening to reduce pixel count that is processed by the shaders
 *
 * Mode:  0 - Disable sharpening mask
 *        1 - Uses circular sharpening mask to improve shader performance on games rendering on DX10 or higher
 */
#ifndef VRT_USE_SHARPENING_MASK
    #define VRT_USE_SHARPENING_MASK 1
#endif

/**
 * Dithering Noise to reduce color banding on gradients 
 *
 * Mode:  0 - Disable dithering
 *        1 - Enable dithering that adds noise to the image to smoothen out gradients
 */
#ifndef VRT_DITHERING
	#define VRT_DITHERING 0
#endif

/**
 * Sets if the sharpening should work on the gamma corrected image to reduce artifacts.
 * This should be kept enabled and only disabled for debugging if required. 
 */
#ifndef _VRT_SRGB_BACKBUFFER
    #if VRT_SHARPENING_MODE == 2
        #define _VRT_SRGB_BACKBUFFER 1 
    #else
        #define _VRT_SRGB_BACKBUFFER 0
    #endif
#endif

/**
* Discards black pixels in the backbuffer to avoid gpu processing outside the viewble areas (usualy masked black) of the VR headset
* This might cause artifacts on dark scenes that contain black pixel when heavy color corrections are applied.
*/
#ifndef _VRT_DISCARD_BLACK
  #if VRT_USE_SHARPENING_MASK == 0 || VRT_COLOR_CORRECTION_MODE != 0
    	#define _VRT_DISCARD_BLACK 1
    #else
        #define _VRT_DISCARD_BLACK 0
    #endif
#endif

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// UI Elements
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#include "ReShadeUI.fxh"


uniform int VRT_Advanced_help <
	ui_type = "radio"; 
	ui_label = "(?) Usage Help (?)";
	ui_text = 
     "VRToolkit modes & settings:\n"
     "";
     
     ui_tooltip =
    	" Open the \"Preprocess definitions\" section to change the folowing modes.\n"
    	"\n"
		" Sharpening Modes:        0 - Disabled sharpening\n"
        "                          1 - Filmic Anamorph Sharpening\n" 
        "                          2 - AMD FidelityFX Contrast Adaptive Sharpening (CAS)\n"
        "\n"
        " Color Correction Modes:  0 - Disabled color correction\n"
        "                          1 - Uses a LUT (Look up table) for specialized and complex corrections.\n"
        "                          2 - Tonemapping to correct, gamma, exposure and color saturation.\n"
        "\n"
        " Sharpening Masking:      0 - Disabled sharpening masking\n"
        "                          1 - Uses circular sharpening mask to improve shader performance on games rendering on DX10 or higher.\n"
        "\n"
        " Dithering:               0 - Disable dithering\n"
        "                          1 - Enable dithering that adds noise to the image to smoothen out gradients.\n"
        "";
	     
    >;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Variables (Uniform & Static)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

static const float GAMMA_SRGB_FACTOR = 1/2.2;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Textures & Sampler
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// normal backbuffer that is not scalable but works with SGSSA 
sampler backBufferSampler {
    Texture = ReShade::BackBufferTex;
    //point filter for SGSSAA to avoid blur
	MagFilter = POINT; MinFilter = POINT;
    #if _VRT_SRGB_BACKBUFFER 
       SRGBTexture = true;
    #endif
};

// scalable version of the backbuffer
sampler backBufferSamplerScalable {
    Texture = ReShade::BackBufferTex;
	#if _VRT_SRGB_BACKBUFFER 
       SRGBTexture = true;
    #endif
};


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Shader stages
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#include "VRToolkitShaders.fxh"

// sharpening step
float3 SharpeningStep(float4 backBuffer, float4 position , float2 texcoord ){

    // Sharpening Step
    #if (VRT_SHARPENING_MODE == 1)
        // use filmic sharpening 
        return FilmicAnamorphSharpenPS(backBuffer, position, texcoord);
    #elif (VRT_SHARPENING_MODE == 2)
        // use CAS sharpening
        return CASPass(backBuffer,position,texcoord);	
    #endif

}

// color correction step
float3 ColorCorrectionStep(float4 backBuffer, float4 position , float2 texcoord ){

    #if (VRT_COLOR_CORRECTION_MODE == 1)
        // LUT shader
        return PS_LUT_Apply(backBuffer, position, texcoord);
    #elif (VRT_COLOR_CORRECTION_MODE == 2)
        // Tonemapping
        return TonemapPass(backBuffer, position, texcoord);
    #endif

}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Main VRCombine Shader
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


void CombineVRShaderPS(in float4 position : SV_Position, in float2 texcoord : TEXCOORD, out float4 color : SV_Target) {

    // fetch initial unmodified back buffer
	float4 backBuffer = tex2D(backBufferSampler, texcoord.xy);
  	
    #if _VRT_DISCARD_BLACK 
		// discards black pixels which are usually the ones masked outside the HMD visible area
		if (!any(backBuffer.rgb))
	    {
	        discard;
	    }
    #endif

    #if VRT_DITHERING
        // apply dithering before any post processing is done
		backBuffer.rgb += ScreenSpaceDither(position.xy);
    #endif
			
	#if (VRT_SHARPENING_MODE != 0)
              
        #if VRT_USE_SHARPENING_MASK && __RENDERER__ >= 0xa000 // If DX10 or higher
         
            float radialSharpeningMask = RadialSharpeningMask(texcoord);
         
            // only apply sharpen when the mask is not black
            if(radialSharpeningMask != 0){
                 //backBuffer.rgb = SharpeningStep(backBuffer,position,texcoord);
                float3 sharpeningResult = SharpeningStep(backBuffer,position,texcoord);
	            #if _MASK_SMOOTH
                	backBuffer.rgb = lerp(backBuffer.rgb,sharpeningResult,radialSharpeningMask);
                #else
                	backBuffer.rgb = sharpeningResult;
                #endif
              
            } 
        #else
	        // directly apply sharpening without mask
	        backBuffer.rgb = SharpeningStep(backBuffer,position,texcoord);
	    #endif
    #endif

        
   // Color Correction Step
    #if (VRT_COLOR_CORRECTION_MODE != 0)
    
        // convert backbuffer into linear mode for color corrections!
        #if (_VRT_SRGB_BACKBUFFER )
            // convert from sRGB gamma back to linear 1/2.2
            backBuffer.rgb = pow(backBuffer.rgb,GAMMA_SRGB_FACTOR);
        #endif     
	     
        backBuffer.rgb = ColorCorrectionStep(backBuffer,position,texcoord);
    #endif
       
    // pass in the modified back buffer to the output
    color.rgb = backBuffer.rgb;
    // force opaque post shader regardless of the input backbuffer
    color.a = 1;
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Technique
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
technique VRToolkit  <ui_tooltip = "This shader combines multiple shaders tailored to be usable in VR into one render pass"; >
{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = CombineVRShaderPS;

		#if (_VRT_SRGB_BACKBUFFER && VRT_COLOR_CORRECTION_MODE == 0)
           SRGBWriteEnable = true;
        #endif

	}
}

