Shader "PosPro/VignettingEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BlackIntensity("Black intensity", Float) = 6.5
		_CircleRadius("CircleRadius", Float) = 0.4

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
			float _BlackIntensity;
			float _CircleRadius;
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv;

				float dist = distance(uv,float2(0.5,0.5));

				float valorInterp = 1.0;
				if (dist > _CircleRadius) {		//Si la distancia és mes gran que el cercle, anem enfosquint
					valorInterp = pow(1.0 + _CircleRadius - dist, _BlackIntensity);
				}

				fixed4 col = valorInterp*tex2D(_MainTex, uv);
				//fixed4 col = fixed4(dist, 0.0, 0.0, 1.0);

				return col;
			}
			ENDCG
		}
	}
}
