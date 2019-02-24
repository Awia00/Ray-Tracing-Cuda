#include <iostream>
#include <fstream>
#include <vector>
#include <memory>
#include <limits>
#include "include/vec3.cuh"
#include "include/ray.cuh"
#include "include/sphere.cuh"
#include "include/hitable.cuh"
#include "include/hitable_list.cuh"

#define RM(row,col,w) row*w+col
#define CM(row,col,h) col*h+row

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

rgb color(const ray& r, const std::shared_ptr<hitable>& world) {
	hit_record rec;
	if (world->hit(r, 0.0f, std::numeric_limits<float>::max(), rec)) {
		return (rec.normal + 1.0)*0.5;
	}
	vec3 unit_direction = unit_vector(r.direction());
	float t = 0.5f*(unit_direction.e[1] + 1.0f);
	return vec3(1.0f, 1.0f, 1.0f)*(1.0f - t) + vec3(0.5f, 0.7f, 1.0f)*t;
}

std::vector<rgb> simple_ray_render(int h, int w) {
	auto colors = std::vector<rgb>(w*h);
	vec3 lower_left_corner(-2.0, -1.0, -1.0);
	vec3 horizontal(4.0, 0.0, 0.0);
	vec3 vertical(0.0, 2.0, 0.0);
	vec3 origin(0.0, 0.0, 0.0);
	auto world = std::make_shared<hitable_list>();
	world->add_hitable(std::make_shared<sphere>(vec3(0, 0, -1), 0.5, rgb(1.0, 0, 0)));
	world->add_hitable(std::make_shared<sphere>(vec3(0, -100.5, -1), 100, rgb(0.0, 1.0, 0)));

	for (int i = 0; i < h; i++) {
		for (int j = 0; j < w; j++) {
			float u = float(j) / float(w);
			float v = float(h - i) / float(h);
			ray r(origin, lower_left_corner + (horizontal * u) + (vertical * v));
			colors[RM(i, j, w)] = color(r, world);
		}
	}
	return colors;
}

int main() {
	int h = 100;
	int w = 200;

	auto colors = simple_ray_render(h, w);
	write_ppm_image(colors, h, w, "render");
}