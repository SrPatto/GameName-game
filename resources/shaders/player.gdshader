shader_type canvas_item;

uniform float hit_effect : hint_range(0,1) = 0.0;
uniform float blink_effect : hint_range(0,1) = 0.0;
uniform float shake_intensity = 10.0;
uniform float flash_speed = 30.0;
uniform vec4 flash_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 blink_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

void vertex() {
    if (hit_effect > 0.0) {
        float time = TIME * 30.0;
        vec2 random_offset = vec2(
            rand(vec2(time, 0.0)) * 2.0 - 1.0,
            rand(vec2(time, 10.0)) * 2.0 - 1.0
        );
        VERTEX += random_offset * shake_intensity * hit_effect;
    }
}

uniform vec4 outline_color : source_color = vec4(1.0);
uniform vec4 sprite_color : source_color = vec4(1.0);

void fragment() {
	vec4 original_color;

	vec2 pixel_size = TEXTURE_PIXEL_SIZE;
	bool within = texture(TEXTURE, UV + pixel_size * vec2(1.0, 0.0)).a > 0.0;
	within = within || texture(TEXTURE, UV + pixel_size * vec2(1.0, 1.0)).a > 0.0;
	within = within || texture(TEXTURE, UV + pixel_size * vec2(1.0, -1.0)).a > 0.0;
	within = within || texture(TEXTURE, UV + pixel_size * vec2(0.0, -1.0)).a > 0.0;
	within = within || texture(TEXTURE, UV + pixel_size * vec2(0.0, 1.0)).a > 0.0;
	within = within || texture(TEXTURE, UV + pixel_size * vec2(-1.0, 1.0)).a > 0.0;
	within = within || texture(TEXTURE, UV + pixel_size * vec2(-1.0, -1.0)).a > 0.0;
	within = within || texture(TEXTURE, UV + pixel_size * vec2(-1.0, 0.0)).a > 0.0;
	bool outline = within && texture(TEXTURE, UV).a == 0.0;
	original_color = mix(COLOR, COLOR * sprite_color, 0.5 - 0.5 * cos(10));
	original_color = float(!outline) * (texture(TEXTURE, UV)) * vec4(1.0,1.0,1.0,1.0) + float(outline) * outline_color;
	//original_color = swap_color(texture(TEXTURE, UV));

	if (hit_effect > 0.0) {
        float flash = sin(TIME * flash_speed) * 0.5 + 0.5;
        flash *= original_color.a;

        vec4 final_color = mix(original_color, flash_color, flash);
        final_color = mix(original_color, final_color, hit_effect);
        final_color.a = original_color.a;

        COLOR = final_color;
    }
	else if (blink_effect > 0.0){
		float flash = sin(TIME * flash_speed) * 0.5 + 0.5;
        flash *= original_color.a;

        vec4 final_color = mix(original_color, blink_color, flash);
        final_color = mix(original_color, final_color, blink_effect);
        final_color.a = original_color.a;

        COLOR = final_color;
	}
	 else {
        COLOR = original_color;
    }
}