Shader "Unlit/TransitionShader"
{
    Properties
    {
        _MaskTex ("Mask", 2D) = "black" {}
        _PrimaryColor ("Primary Color", Color) = (1,1,1,1)
        _SecondaryColor ("Secondary Color", Color) = (1,1,1,1)
        _CutLevel ("Cut Level", Range (0, 1)) = 0.5
        _TransitionWidth ("Transition Width", Range(0, 0.3)) = 0
    }
    
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

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

            sampler2D _MaskTex;
            float4 _MaskTex_ST;
            float4 _PrimaryColor;
            float4 _SecondaryColor;
            float _CutLevel;
            float _TransitionWidth;

            float remap_float(float In, float2 InMinMax, float2 OutMinMax)
            {
                return OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }

            float4 remap_float4(float4 In, float2 InMinMax, float2 OutMinMax)
            {
                return OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MaskTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float maskValue = tex2D(_MaskTex, i.uv).x;

                float cutLevel = (_SinTime.a + 1) / 2;
                
                float2 inRange = float2(cutLevel, cutLevel + _TransitionWidth);
                
                maskValue = remap_float(maskValue, inRange,float2(0, 1));
                maskValue = saturate(maskValue);

                return lerp(_PrimaryColor, _SecondaryColor, maskValue);
            }
            ENDCG
        }
    }
}