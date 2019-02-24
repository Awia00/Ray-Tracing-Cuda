#pragma once
#include <random>
#include "vec3.cuh"
// std::random_device rd;	// Will be used to obtain a seed for the random number engine
std::mt19937 gen(42);		// Standard mersenne_twister_engine seeded with rd()
std::uniform_real_distribution<float> dis(0.0, 1.0);

vec3 random_in_unit_sphere() {
	vec3 p;
	do {
		p = vec3(dis(gen), dis(gen), dis(gen))*2.0 - vec3(1, 1, 1);
	} while (p.squared_length() >= 1.0);
	return p;
}