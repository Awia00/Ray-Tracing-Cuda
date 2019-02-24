#pragma once

#include "vec3.cuh"
#include "ray.cuh"

struct sphere {
	vec3 _center;
	float _radius;

	sphere() = default;
	sphere(const vec3& center, float radius) : _center(center), _radius(radius) {
	}

	bool hit(const ray& r) const {
		vec3 oc = r.origin() - _center;
		float a = dot(r.direction(), r.direction());
		float b = 2.0 * dot(oc, r.direction());
		float c = dot(oc, oc) - _radius * _radius;
		float discriminant = b * b - 4 * a*c;
		return discriminant > 0;
	}

	rgb color() const {
		return vec3(1, 0, 0); // todo
	}
};