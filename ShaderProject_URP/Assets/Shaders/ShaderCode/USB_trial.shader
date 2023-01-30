Shader "Trial/USB_trial"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
        [KeywordEnum(Off, Red, Blue)]
        _Options ("Color Options", Float) = 0
        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcBlend ("SrcFactor", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstBlend ("DstFactor", Float) = 10
        [Enum(UnityEngine.Rendering.BlendOp)]
        _Operation ("Operation", Float) = 0
        [Enum(UnityEngine.Rendering.CullMode)]
        _Cull ("Cull", Float) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)]
        _ZTest ("ZTest", Float) = 0
        [KeywordEnum(Off, On)]
        _ZWrite ("ZWrite", Float) = 0
    }
    
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent" 
            "Queue"="Transparent"
            "RenderPipeline"="UniversalRenderPipeline"
        }
        
        Blend [_SrcBlend] [_DstBlend]
        BlendOp [_Operation]
        Cull [_Cull]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        LOD 100

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            #pragma multi_compile _OPTIONS_OFF _OPTIONS_RED _OPTIONS_BLUE
            
            #include "HLSLSupport.cginc" 
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _Color;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                #if _OPTIONS_OFF
                    return col * _Color;
                #elif _OPTIONS_RED
                    return col * float4(1, 0, 0, 1);
                #else
                    return col * float4(0, 0, 1, 1);
                #endif
            }
            ENDHLSL
        }
    }
}