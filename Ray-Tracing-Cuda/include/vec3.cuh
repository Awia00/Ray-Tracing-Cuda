#pragma once
#include <math.h>

struct vec3 {
	float e[3];
	vec3() = default;
	vec3(float e0, float e1, float e2) {
		e[0] = e0;
		e[1] = e1;
		e[2] = e2;
	}

	// unary operators
	inline const vec3& operator+() const { return *this; }
	inline vec3 operator-() const { return vec3(-e[0], -e[1], -e[2]); }
	inline float operator[](int i) const { return e[i]; }
	inline float& operator[](int i) { return e[i]; }

	// binary operators
	inline vec3& operator+=(const vec3 &v) {
		e[0] += v.e[0];
		e[1] += v.e[1];
		e[2] += v.e[2];
		return *this;
	}

	inline vec3& operator-=(const vec3 &v) {
		e[0] -= v.e[0];
		e[1] -= v.e[1];
		e[2] -= v.e[2];
		return *this;
	}

	inline vec3& operator*=(const vec3 &v) {
		e[0] *= v.e[0];
		e[1] *= v.e[1];
		e[2] *= v.e[2];
		return *this;
	}

	inline vec3& operator/=(const vec3 &v) {
		e[0] /= v.e[0];
		e[1] /= v.e[1];
		e[2] /= v.e[2];
		return *this;
	}

	inline vec3& operator*=(const float t) {
		e[0] *= t;
		e[1] *= t;
		e[2] *= t;
		return *this;
	}

	inline vec3& operator/=(const float t) {
		e[0] /= t;
		e[1] /= t;
		e[2] /= t;
		return *this;
	}

	inline float length() const {
		return sqrt(e[0] * e[0] + e[1] * e[1] + e[2] * e[2]);
	}

	inline vec3& v_sqrt() {
		e[0] = sqrt(e[0]);
		e[1] = sqrt(e[1]);
		e[2] = sqrt(e[2]);
		return *this;
	}

	inline float squared_length() const {
		return e[0] * e[0] + e[1] * e[1] + e[2] * e[2];
	}

	inline vec3& make_unit_vector() {
		float k = 1.0f / length();
		e[0] *= k;
		e[1] *= k;
		e[2] *= k;
		return *this;
	}
};

inline vec3 operator+(const vec3 & v1, const vec3 & v2) {
	return vec3(v1[0] + v2[0], v1[1] + v2[1], v1[2] + v2[2]);
}

inline vec3 operator-(const vec3 & v1, const vec3 & v2) {
	return vec3(v1[0] - v2[0], v1[1] - v2[1], v1[2] - v2[2]);
}

inline vec3 operator*(const vec3 & v1, const vec3 & v2) {
	return vec3(v1[0] * v2[0], v1[1] * v2[1], v1[2] * v2[2]);
}

inline vec3 operator/(const vec3 & v1, const vec3 & v2) {
	return vec3(v1[0] / v2[0], v1[1] / v2[1], v1[2] / v2[2]);
}

inline vec3 cross(const vec3 & v1, const vec3 & v2) {
	return vec3(
		v1[1] * v2[2] - v1[2] * v2[1],
		v1[0] * v2[2] - v1[2] * v2[0],
		v1[0] * v2[1] - v1[1] * v2[0]
	);
}

inline float dot(const vec3 & v1, const vec3 & v2) {
	return v1[0] * v2[0] + v1[1] * v2[1] + v1[2] * v2[2];
}

inline vec3 operator+(const vec3 & v1, const float t) {
	return vec3(v1[0] + t, v1[1] + t, v1[2] + t);
}

inline vec3 operator-(const vec3 & v1, const float t) {
	return vec3(v1[0] - t, v1[1] - t, v1[2] - t);
}

inline vec3 operator*(const vec3 & v1, const float t) {
	return vec3(v1[0] * t, v1[1] * t, v1[2] * t);
}

inline vec3 operator/(const vec3 & v1, const float t) {
	return vec3(v1[0] / t, v1[1] / t, v1[2] / t);
}

inline vec3 unit_vector(vec3 v) {
	return v / v.length();
}

inline vec3 reflect(const vec3& v, const vec3& n) {
	return v - n * (2 * dot(v, n));
}

inline bool refract(const vec3& v, const vec3& n, float ni_over_nt, vec3& refracted) {
	vec3 uv = unit_vector(v);
	float dt = dot(uv, n);
	float discriminant = 1.0 - ni_over_nt * ni_over_nt*(1 - dt * dt);
	if (discriminant > 0) {
		refracted = (uv - n * dt)*ni_over_nt - n * sqrt(discriminant);
		return true;
	}
	return false;
}

inline std::istream& operator>>(std::istream& is, vec3 &t) {
	is >> t.e[0] >> t.e[1] >> t.e[2];
	return is;
}

inline std::ostream& operator<<(std::ostream& is, vec3 &t) {
	is << t.e[0] << " " << t.e[1] << " " << t.e[2];
	return is;
}

// Specific versions

struct rgb : public vec3 {
	rgb() = default;
	rgb(float e0, float e1, float e2) {
		e[0] = e0;
		e[1] = e1;
		e[2] = e2;
	}
	rgb(const vec3& v) {
		e[0] = v[0];
		e[1] = v[1];
		e[2] = v[2];
	}
	inline float r() const { return e[0]; }
	inline void r(float v) { e[0] = v; }
	inline float g() { return e[1]; }
	inline void g(float v) { e[1] = v; }
	inline float b() { return e[2]; }
	inline void b(float v) { e[2] = v; }
};