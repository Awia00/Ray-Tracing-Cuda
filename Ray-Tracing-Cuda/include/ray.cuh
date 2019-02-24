#pragma once

#include "vec3.cuh"

struct ray {
	vec3 _origin; // origin
	vec3 _direction; // direction

	ray() = default;
	ray(const vec3& origin, const vec3& direction) : _origin(origin), _direction(direction) {
	}
	vec3 origin() const { return _origin; }
	vec3 direction() const { return _direction; }
	vec3 point_at_parameter(float t) const { return _origin + (_direction*t); }
};