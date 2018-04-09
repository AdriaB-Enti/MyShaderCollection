Shader "PostPro/HeatEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DisplaceText("Displacement texture", 2D) = "white" {}
		_Magnitude("Magnitude",Range(0,0.1)) = 1
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

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

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _DisplaceText;
			float _Magnitude;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 displacement = tex2D(_DisplaceText, _Time.x*2+i.uv).xy;		//Red and green (future x & y displacement), range [0..1]
				displacement = ((displacement * 2) - 1) * _Magnitude;				//Transform to range [-1..1] and scale with magnitude var (0->no displacement)

				fixed4 col = tex2D(_MainTex, i.uv + displacement);					//add displacement to uv coords

				return col;
			}
			ENDCG
		}
	}
}
