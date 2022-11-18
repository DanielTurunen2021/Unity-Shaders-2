Shader "Unlit/Wave_Shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Magnitude("Magnitude", range(0, 0.5)) = 0.1
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
            #define TAU 6.28

            float4 _ColorA;
            float4 _ColorB;
            float _Magnitude;

            float InverseLerp(float a, float b, float v)
            {
                return (v-a)/(b-a);
            }

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
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                float wave = cos(v.uv.x * TAU * 5 + _Time.y);
                v.vertex.y = wave * _Magnitude;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                
                
               
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
               float t = cos(i.uv.x * TAU * 5 + _Time.y);
                float4 lerpColor = lerp(_ColorA, _ColorB, t);
                return lerpColor;
            }
            ENDCG
        }
    }
}
