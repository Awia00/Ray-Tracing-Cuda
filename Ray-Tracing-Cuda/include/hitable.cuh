#pragma once
#include "ray.cuh"

// forward decleration
struct material;

struct hit_record {
	float t;
	vec3 p;
	vec3 normal;
	std::shared_ptr<material> mat_ptr;
};

struct hitable {
	virtual bool hit(const ray& r, float t_min, float t_max, hit_record& out) const = 0;
};