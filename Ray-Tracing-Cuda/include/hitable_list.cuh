#pragma once
#include <vector>
#include <memory>
#include "hitable.cuh"

struct hitable_list : public hitable {
	std::vector<std::shared_ptr<hitable>> _hitables;

	hitable_list() = default;
	hitable_list(const std::vector<std::shared_ptr<hitable>>& list) {
		_hitables = list;
	}

	void add_hitable(const std::shared_ptr<hitable>& elem) {
		_hitables.push_back(elem);
	}

	bool hit(const ray& r, float t_min, float t_max, hit_record& out) const override {
		hit_record temp_closest;
		bool hit_anything = false;
		auto closest_so_far = t_max;
		for (const auto& hitable : _hitables) {
			if (hitable->hit(r, t_min, closest_so_far, temp_closest)) {
				hit_anything = true;
				closest_so_far = temp_closest.t;
				out = temp_closest;
			}
		}
		return hit_anything;
	}
};