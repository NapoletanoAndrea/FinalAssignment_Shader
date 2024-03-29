Shader "Trial/USB_trial"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
        [KeywordEnum(Off, Red, Blue)]
        _Options ("Color Options", Float) = 0
        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcBlend ("SrcFactor", Float) = 1
         [Enum(UnityEngine.Rendering.BlendMode)]
        _DstBlend ("DstFactor", Float) = 1
        [Enum(UnityEngine.Rendering.CullMode)]
        _Cull ("Cull", Float) = 0
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Opaque" }
        Blend [_SrcBlend] [_DstBlend]
        Cull [_Cull]
        ZTest Less
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            #pragma multi_compile _OPTIONS_OFF _OPTIONS_RED _OPTIONS_BLUE

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _Color;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                #if _OPTIONS_OFF
                    return col * _Color;
                #elif _OPTIONS_RED
                    return col * float4(1, 0, 0, 1);
                #else
                    return col * float4(0, 0, 1, 1);
                #endif
                
            }
            ENDCG
        }
    }
}
