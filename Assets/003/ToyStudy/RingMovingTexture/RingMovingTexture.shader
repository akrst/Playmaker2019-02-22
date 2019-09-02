Shader "TS/RingMovingTexture"
{
	Properties
	{
		_Tex001 ("Texture001", 2D) = "white" {}
		[NoScaleOffset]_Tex002 ("Texture002", 2D) = "Black" {}
        _Frequency("Frequency", Float) = 4
        _RingWidth("RingWidth", Range(0, 0.999)) = 0.999
        _Speed("Speed", Float) = 2
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

			sampler2D _Tex001;
			float4 _Tex001_ST;
            sampler2D _Tex002;
            float _Frequency;
            float _RingWidth;
            float _Speed;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _Tex001);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
                fixed4 col001 = tex2D(_Tex001, i.uv);
                fixed4 col002 = tex2D(_Tex002, i.uv);
                fixed length = distance(i.uv, fixed2(0.5, 0.5)) - _Time * _Speed;
                return lerp(col001, col002, step(_RingWidth, sin(length * _Frequency)));
			}
			ENDCG
		}
	}
}
