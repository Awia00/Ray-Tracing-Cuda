#pragma once
#include "vec3.cuh"
#include "ray.cuh"
#include "hitable.cuh"
#include "random_helpers.cuh"

struct material {
	virtual bool scatter(const ray& r_in, const hit_record& rec, vec3& attenuation, ray& scattered) const = 0;
};

struct lambertian :public material {
	rgb albedo;
	lambertian(const rgb& a) : albedo(a) {
	}

	bool scatter(const ray& r_in, const hit_record& rec, vec3& attenuation, ray& scattered) const override {
		vec3 target = rec.p + rec.normal + random_in_unit_sphere();
		scattered = ray(rec.p, target - rec.p);
		attenuation = albedo;
		return true;
	}
};

struct metal : public material {
	rgb albedo;
	float fuzz;

	metal(const vec3& a, float f) : albedo(a) {
		if (f < 1) { fuzz = f; }
		else {
			fuzz = 1;
		}
	}

	bool scatter(const ray& r_in, const hit_record& rec, vec3& attenuation, ray& scattered) const override {
		vec3 reflected = reflect(unit_vector(r_in.direction()), rec.normal);
		scattered = ray(rec.p, reflected + random_in_unit_sphere()*fuzz);
		attenuation = albedo;
		return dot(scattered.direction(), rec.normal) > 0;
	}
};