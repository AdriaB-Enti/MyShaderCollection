Shader "PosPro/Transition"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_TransitionTex("Texture", 2D) = "white" {}
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
			sampler2D _TransitionTex;

			fixed4 frag (v2f i) : SV_Target
			{

				float darkness = tex2D(_TransitionTex, i.uv).x;	//Transition texture has only white-black colors, so we can just take the first value
				fixed4 col;

				if (darkness < sin(_Time.y)) {					//if the color in the transition texture is blacker than the value, that pixel will be black
					col = fixed4(0,0,0,1);
				} else {
					col = tex2D(_MainTex, i.uv);				//if not, show the original color
				}

				return col;
			}
			ENDCG
		}
	}
}
