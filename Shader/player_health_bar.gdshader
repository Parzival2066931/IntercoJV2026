shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 1.0;
uniform float tip_px = 26.0;
uniform float bar_width_px = 220.0;
uniform bool keep_full_tip = true;

void fragment() {
	float w = max(bar_width_px, 1.0);
	float tip = clamp(tip_px, 0.0, w);

	// largeur visible selon la vie
	float vis = clamp(progress, 0.0, 1.0) * w;

	// Option: garder la pointe complète dès qu'il reste > 0 hp
	if (keep_full_tip) {
		vis = max(vis, tip);
	}

	// x en pixels le long de la barre
	float x = UV.x * w;

	// mask: 1 si pixel dans la partie visible, sinon 0
	// (si progress est 0, vis peut être tip si keep_full_tip=true; si tu veux cacher à 0, gère-le dans le script)
	float inside = step(x, vis);

	// Début de la pointe dans l'espace visible
	float tip_start = max(0.0, vis - tip);

	// Remapping UV
	float sample_x;

	if (x < tip_start && tip_start > 0.0001) {
		// zone body -> [0 .. w-tip]
		float t = x / tip_start;
		sample_x = t * (w - tip);
	} else {
		// zone tip -> [w-tip .. w]
		float denom = max(vis - tip_start, 0.0001); // ~ tip
		float t = (x - tip_start) / denom;
		sample_x = (w - tip) + t * tip;
	}

	vec2 suv = vec2(sample_x / w, UV.y);
	vec4 tex = texture(TEXTURE, suv);

	// applique le mask (hors zone -> alpha 0)
	COLOR = tex * COLOR * inside;
}
