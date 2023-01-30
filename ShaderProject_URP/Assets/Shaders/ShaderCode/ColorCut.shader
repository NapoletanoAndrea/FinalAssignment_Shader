Shader "Unlit/ColorCut"
{
    Properties
    {
        _FirstColor ("First Color", Color) = (1,1,1,1)
        _SecondColor ("Second Color", Color) = (1,1,1,1)
        _ThirdColor ("Third Color", Color) = (1,1,1,1)
        _CutLevel ("Cut Level", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
        }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha

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

            float4 _FirstColor;
            float4 _SecondColor;
            float4 _ThirdColor;
            float _CutLevel;

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
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                if(i.uv.y < _CutLevel)
                {
                    float botRemapValue = remap_float(i.uv.y, float2(0, _CutLevel), float2(0, 1));
                    return lerp(_FirstColor, _ThirdColor, botRemapValue);
                }
                float topRemapValue = remap_float(i.uv.y, float2(_CutLevel, 1), float2(0, 1));
                return lerp(_ThirdColor, _SecondColor, topRemapValue);
            }
            ENDCG
        }
    }
}