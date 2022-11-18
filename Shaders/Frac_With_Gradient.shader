
Shader "Unlit/Frac_With_Gradient_Shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ColorA("Color A", color) = (1, 1, 1, 1)
        _ColorB("Color A", color) = (1, 1, 1, 1)
        _StartValue("Start value",range(0, 1)) = 0
        _EndValue("End value", range(0, 1)) = 1
        _Offset("Offset", range(0,1)) = 0
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

            float4 _ColorA;
            float4 _ColorB;
            float _StartValue;
            float _EndValue;
            float _Offset;

            float InverseLerp(float a, float b, float v)
            {
                return (v - a)/(b - a);
            }
            
            
            #include "UnityCG.cginc"

            

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normals : NORMAL;
            };

            struct Interpolators
            {
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.normal = UnityObjectToWorldNormal(v.normals); 
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //o.normal = v.normals; Normals in local space.
                o.normal = UnityObjectToWorldNormal(v.normals); //Normals in world space.
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (Interpolators i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

                float t = InverseLerp(_StartValue, _EndValue, i.uv.x);
                t = frac(t);

                //return t;
                float4 OutputColor = lerp(_ColorA, _ColorB, t);
                return OutputColor;
                
                //return float4(i.uv, 0, 1);
                //return float4(i.normal, 1);
            }
            ENDCG
        }
    }
}
