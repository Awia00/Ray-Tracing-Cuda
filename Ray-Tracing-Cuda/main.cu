#include <iostream>
#include <fstream>
#include <vector>
#include <memory>
#include <limits>
#include <random>
#include "include/vec3.cuh"
#include "include/ray.cuh"
#include "include/sphere.cuh"
#include "include/hitable.cuh"
#include "include/hitable_list.cuh"
#include "include/camera.cuh"

#define RM(row,col,w) row*w+col
#define CM(row,col,h) col*h+row

// std::random_device rd;	// Will be used to obtain a seed for the random number engine
std::mt19937 gen(42);		// Standard mersenne_twister_engine seeded with rd()
std::uniform_real_distribution<float> dis(0.0, 1.0);

void write_ppm_image(std::vector<rgb> colors, int h, int w, std::string filename) {
	std::ofstream myfile;
	myfile.open(filename + ".ppm");
	myfile << "P3\n" << w << " " << h << "\n255\n";
	for (int i = 0; i < h; i++) {
		for (int j = 0; j < w; j++) {
			auto color = colors[RM(i, j, w)];
			myfile << color.r()*255.99 << " " << color.g()*255.99 << " " << color.b()*255.99 << std::endl;
		}
	}
	myfile.close();
}

std::vector<rgb> hello_world_render(int h, int w) {
	auto colors = std::vector<rgb>(w*h);
	for (int i = 0; i < h; i++) {
		for (int j = 0; j < w; j++) {
			colors[RM(i, j, w)].r(j / float(w));
			colors[RM(i, j, w)].g(h - i / float(h));
			colors[RM(i, j, w)].b(0.2f);
		}
	}
	return colors;
}

vec3 random_in_unit_sphere() {
	vec3 p;
	do {
		p = vec3(dis(gen), dis(gen), dis(gen))*2.0 - vec3(1, 1, 1);
	} while (p.squared_length() >= 1.0);
	return p;
}

rgb color(const ray& r, const std::shared_ptr<hitable>& world) {
	hit_record rec;
	if (world->hit(r, 0.001f, std::numeric_limits<float>::max(), rec)) {
		auto target = rec.p + rec.normal + random_in_unit_sphere();
		return color(ray(rec.p, target - rec.p), world)*0.5;
	}
	vec3 unit_direction = unit_vector(r.direction());
	float t = 0.5f*(unit_direction.e[1] + 1.0f);
	return vec3(1.0f, 1.0f, 1.0f)*(1.0f - t) + vec3(0.5f, 0.7f, 1.0f)*t;
}

std::vector<rgb> simple_ray_render(int h, int w, int samples) {
	auto colors = std::vector<rgb>(w*h);
	auto c = camera();
	auto world = std::make_shared<hitable_list>();
	world->add_hitable(std::make_shared<sphere>(vec3(0, 0, -1), 0.5, rgb(1.0, 0, 0)));
	world->add_hitable(std::make_shared<sphere>(vec3(0, -100.5, -1), 100, rgb(0.0, 1.0, 0)));

	for (int i = 0; i < h; i++) {
		for (int j = 0; j < w; j++) {
			rgb pix(0, 0, 0);
			for (int s = 0; s < samples; s++) {
				float u = float(j + dis(gen)) / float(w);
				float v = float(h - i + dis(gen)) / float(h);
				ray r = c.get_ray(u, v);
				pix += color(r, world);
			}
			pix /= float(samples);
			pix = pix.v_sqrt(); // gamma correct (gamma 2)
			colors[RM(i, j, w)] = pix;
		}
	}
	return colors;
}

int main() {
	int h = 200;
	int w = 400;
	int s = 10;

	auto colors = simple_ray_render(h, w, s);
	write_ppm_image(colors, h, w, "render");
}