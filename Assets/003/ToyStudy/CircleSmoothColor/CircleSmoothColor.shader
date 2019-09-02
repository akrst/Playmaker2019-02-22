Shader "TS/CircleSmoothColor"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
                //distance関数でUVの中心()(0.5, 0.5)からの距離rを調べ、step関数で半径radius未満なら0, 以上なら1にしている
                fixed4 radius = 0.3;
                // distance(x, y) は、x - yの値をfloatで返す
                fixed r = distance(i.uv, fixed2(0.5, 0.5));;
                //smoothstep関数はsmoothstep(a,b,x)の形で使います。xの値がa以下のときは0、b以上のときは1、aとbの間のときは0と1の間で線形補間されます。
                return smoothstep(radius,radius+0.05, r);
			}
			ENDCG
		}
	}
}
