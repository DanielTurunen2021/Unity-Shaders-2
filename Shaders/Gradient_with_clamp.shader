Shader "Unlit/Gradient_with_clamp"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _StartValue("Start value", range(0, 1)) = 0
        _EndValue("End Value", range(0, 1)) = 1
        _ColorA("Color A", color) = (1, 1, 1, 1)
        _ColorB("Color B", color) = (1, 1, 1, 1)
        
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
            
            float _StartValue;
            float _EndValue;
            float4 _ColorA;
            float4 _ColorB;

            #include "UnityCG.cginc"

            float InverseLerp(float a, float b, float v)
            {
                return (v - a)/(b - a);
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
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                float t = InverseLerp(_StartValue, _EndValue, i.uv.x);
                float4 c = saturate(lerp(_ColorA, _ColorB, t));
                return c;
            }
            ENDCG
        }
    }
}
