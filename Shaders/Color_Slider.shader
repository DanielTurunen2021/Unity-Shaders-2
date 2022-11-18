Shader "Unlit/Color_Slider"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SomeColor("Color", color) = (1, 0, 0, 1)
        //_someValue("color", color) = (0, 0, 0, 0)
        //_somevalue("somevalue", float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            float4 _SomeColor;

            struct Meshdata
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
            float4 _MainTex_ST;

            v2f vert (Meshdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                return _SomeColor;
            }
            ENDCG
        }
    }
}
