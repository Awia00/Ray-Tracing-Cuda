#include <iostream>
#include <fstream>
#include <vector>
#include "include/vec3.cuh"

#define RM(row,col,w) row*w+col
#define CM(row,col,h) col*h+row


void write_ppm_image(std::vector<RGB> colors, int h, int w, std::string filename) {
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

std::vector<RGB> hello_world_render(int h, int w) {
	auto colors = std::vector<RGB>(w*h);
	for (int i = 0; i < h; i++) {
		for (int j = 0; j < w; j++) {
			colors[RM(i, j, w)].r(j / float(w));
			colors[RM(i, j, w)].g(h - i / float(h));
			colors[RM(i, j, w)].b(0.2f);
		}
	}
	return colors;
}

int main() {
	int h = 100;
	int w = 200;

	auto colors = hello_world_render(h, w);
	write_ppm_image(colors, h, w, "render");
}