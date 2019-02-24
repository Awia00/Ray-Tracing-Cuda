#pragma once

#include <math.h>
#include <memory>
#include "vec3.cuh"
#include "ray.cuh"
#include "hitable.cuh"

struct sphere : public hitable {
	vec3 _center;
	float _radius;
	std::shared_ptr<material> _material;

	//sphere() = default;
	sphere(const vec3& center, float radius, const std::shared_ptr<material>& material) : _center(center), _radius(radius), _material(material) {
	}

	bool hit(const ray& r, float t_min, float t_max, hit_record& out) const override {
		vec3 oc = r.origin() - _center;
		float a = dot(r.direction(), r.direction());
		float b = dot(oc, r.direction());
		float c = dot(oc, oc) - _radius * _radius;
		float discriminant = b * b - a * c;

		if (discriminant > 0) {
			float temp = (-b - sqrt(b*b - a * c)) / a;
			if (temp < t_max && temp > t_min) {
				out.t = temp;
				out.p = r.point_at_parameter(temp);
				out.normal = (out.p - _center) / _radius;
				out.mat_ptr = _material;
				return true;
			}

			temp = (-b + sqrt(b*b - a * c)) / a;
			if (temp < t_max && temp > t_min) {
				out.t = temp;
				out.p = r.point_at_parameter(temp);
				out.normal = (out.p - _center) / _radius;
				out.mat_ptr = _material;
				return true;
			}
		}
		return false;
	}

	vec3 normal(const vec3& position) const {
		return _center - position;
	}
};