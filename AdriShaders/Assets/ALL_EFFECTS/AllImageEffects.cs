using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class AllImageEffects : MonoBehaviour {

    public enum ChosenEffect
    {
        Pixelation,
        Vignetting,
        HeatWaves,
        Transitions
    }

    public Material[] imageEffectMaterials;
    public ChosenEffect currentEffect = ChosenEffect.Pixelation;

	void Start () {

	}
	
	void Update () {


        //si estem a transitions, passar algun valor?

	}

    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        int effectIndex = (int)currentEffect;
        Graphics.Blit(src, dst, imageEffectMaterials[effectIndex]);
    }
}
