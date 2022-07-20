Shader "Unlit/StencilMask"
{
    Properties
    {
        [IntRange] _StencilID ("Stencil ID", Range(0, 255)) = 0
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Opaque"
            "RenderPipeline"="UniversalRenderPipeline"
            "Queue"="Geometry"
        }
        LOD 100

        Pass
        {
            Blend Zero One
            
            Stencil
            {
                Ref [_StencilID]
                Comp Always
                Pass Replace
                Fail Keep
            }
            
            //ZTest Less
            //Cull Front
            ZWrite Off
            
            /*HLSLPROGRAM   
            #pragma vertex vert
            #pragma fragment frag

            #include "HLSLSupport.cginc" 
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return 0;
            }
            ENDHLSL*/
        }
        
        /*Pass 
        {

            Stencil {
                Ref [_StencilID]
                Comp Equal
                Pass keep
                Zfail keep
            }

            ZTest Less
            Cull Back
            ZWrite Off

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "HLSLSupport.cginc" 
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            
            struct appdata
            {
                float4 vertex : POSITION;
            };
            
            struct v2f
            {
                float4 vertex : SV_POSITION;
            };
            
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex);
                return o;
            }
            
            half4 frag(v2f i) : SV_Target
            {
                return half4(1,0,0,0.5);
            }
            
            ENDHLSL
        }*/
    }
}
