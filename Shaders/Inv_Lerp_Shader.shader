Shader "Unlit/Inv_Lerp_Shader"
{
    
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ColorA("Start color", color) = (1, 1, 1, 1)
        _ColorB("End color", color) = (1, 1, 1, 1)
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            float4 _ColorA;
            float4 _ColorB;
            

            float InverseLerp(float a, float b, float t)
            {
                return (t-a)/(b-a);
            }
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
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
               float t = InverseLerp(_ColorA, _ColorB, i.uv.x);
                return t;
            }
            ENDCG
        }
    }
}
