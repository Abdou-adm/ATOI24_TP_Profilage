#include <stdio.h>
#include <complex.h>
#include <math.h>
#include "ppm.h"

#define TRSH 2.0
#define ITER 1024

#define SIZEX 1620
#define SIZEY 1080

double cx(int x)
{
	/* -2 ---> 1 */
	static const double qx = 3.0 / (double)SIZEX;
	return -2.0 + x * qx;
}

double cy(int y)
{
	/* -1 ---> 1 */
	static const double qy = 2.0 / (double)SIZEY;
	return -1.0 + y * qy;
}

int main(void)
{
	struct ppm_image im;
	ppm_image_init(&im, SIZEX, SIZEY);

	double colref = 255.0 / log(ITER);

	for (int i = 0; i < SIZEX; ++i) {
		for (int j = 0; j < SIZEY; ++j) {
			double complex c = cx(i) + cy(j) * I;
			double complex z = 0;

			int iter;
			for (iter = 0; iter < ITER; ++iter) {
				double mod = cabs(z);

				if (mod > TRSH)
					break;

				z = z*z + c;
			}

			int grey = (int)(colref * log((double)iter));
			ppm_image_setpixel(&im, i, j, grey, grey, grey);
		}
	}

	ppm_image_dump(&im, "m.ppm");
	ppm_image_release(&im);

	return 0;
}
