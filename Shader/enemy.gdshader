shader_type canvas_item;

uniform bool is_damaged = false;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    if (is_damaged) {
        tex.rgb = mix(tex.rgb, vec3(1.0, 0.0, 0.0), 0.4);
    }

    COLOR = tex;
}
