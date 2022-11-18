Shader "Unlit/Mega_Shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Texture2("Texture 2", 2D) = "white"{}
        _ParallaxDir1("Parallax direction 1", range(-2.0, 2.0)) = 0.0
        _ParallaxDir2("Parallax direction 2", range(-2.0, 2.0)) = 0.0
        _Dir1("Direction Horizontal or vertical", range(1, 2)) = 1
        _Dir2("Direction Horizontal or vertical", range(1, 2)) = 2
        _TintColor1("Tint color 1", color) = (0, 1, 0, 1)
        //_TintColor2("Tint color 1", color) = (0, 1, 0, 1)
        //_TintColor3("Tint color 1", color) = (0, 1, 0, 1)
        //_TintColor4("Tint color 1", color) = (0, 1, 0, 1)
        _VertexoffsetX("vertex offset X", range(-2, 2)) = 0
        _VertexoffsetY("vertex offset y", range(-2, 2)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        
        //ZWrite off
        
        Pass
        {
           
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

           

            float _ParallaxDir1;
            float _ParallaxDir2;
            int _Dir1;
            int _Dir2;
            float4 _TintColor1;
            //float4 _TintColor2;
            float _VertexoffsetX;
            float _VertexoffsetY;
           

            
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _Texture2;
            float4 _Texture2_ST;

            v2f vert (appdata v)
            {
                v2f o;
                v.vertex.y = v.vertex.y + _VertexoffsetY;
                v.vertex.x = v.vertex.x + _VertexoffsetX;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv2 = TRANSFORM_TEX(v.uv2, _Texture2);
               
                if(_Dir1 == 1)
                {
                     o.uv.x += _Time.y * _ParallaxDir1;
                }
               if(_Dir1 == 2)
               {
                    o.uv.y += _Time.y * _ParallaxDir1;
               }
                if(_Dir2 == 1)
                {
                    o.uv2.x += _Time.y * _ParallaxDir2;
                }
                if(_Dir2 == 2)
                {
                    o.uv2.y += _Time.y * _ParallaxDir2;
                }
               
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv) + _TintColor1;
                fixed4 col2 = tex2D(_Texture2, i.uv2);
                //fixed4 col3 = col  + col2 +_TintColor1;
                return col + col2;
            }
            ENDCG
        }
    }
}
