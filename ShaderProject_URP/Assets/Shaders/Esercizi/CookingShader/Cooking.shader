Shader "Unlit/CookingShader"
{
    Properties
    {
        _BaseTex ("Texture", 2D) = "white" {}
        _BaseColor ("Base Color", Color) = (1,1,1,1)
        _BurnTex ("Texture", 2D) = "white" {}
        _BurnColor ("Burn Color", Color) = (1,1,1,1)
        _BurnThreshold ("Burn Threshold", Range(0, 1)) = 0.7
        _BurnLevel ("Burn Level", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

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

            sampler2D _BaseTex;
            float4 _BaseTex_ST;
            float4 _BaseColor;

            sampler2D _BurnTex;
            float4 _BurnTex_ST;
            float4 _BurnColor;

            float _BurnThreshold;
            float _BurnLevel;

            float remap_float(float In, float2 InMinMax, float2 OutMinMax)
            {
                return OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _BurnTex);
                if (_BurnLevel < _BurnThreshold)
                {
                    o.uv = TRANSFORM_TEX(v.uv, _BaseTex);
                }
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_BurnTex, i.uv) * _BurnColor;

                if (_BurnLevel < _BurnThreshold)
                {
                    col = tex2D(_BaseTex, i.uv);
                    float remappedBurnLevel = remap_float(_BurnLevel, float2(0, _BurnThreshold), float2(0, 1));
                    remappedBurnLevel = saturate(remappedBurnLevel);
                    col *= lerp(_BaseColor, _BurnColor, remappedBurnLevel);
                }
                return col;
            }
            ENDCG
        }
    }
}