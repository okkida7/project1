shader_type canvas_item;

uniform vec2 slice_start;
uniform vec2 slice_end;

void fragment() {
    vec2 dir = normalize(slice_end - slice_start);
    vec2 normal = vec2(-dir.y, dir.x);
    vec2 point_to_pixel = FRAGCOORD.xy - slice_start;
    float distance = dot(point_to_pixel, normal);
    
    if (distance < 0.0) {
        discard;
    }
}