// -*- compile-command: "mpicc -o ../get_hists get_vinf_ye_on_grid_hists.c read_hyvolumedata_h5.c sds.c -std=c99 -lhdf5 -lm" -*-
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <math.h>
#include <time.h>
#include "read_hyvolumedata_h5.h"

double compute_dV
(
 double x,
 double y,
 double z,
 double xbounds,
 double ybounds,
 double zbounds,
 double xextents,
 double yextents,
 double zextents
)
{
  double dx = 2*xbounds/(xextents - 1);
  double dy = 2*ybounds/(yextents - 1);
  double dz = 2*zbounds/(zextents - 1);
  double dV = dx*dy*dz;
  
  if ((x >= -xbounds && x <= xbounds) &&
      (y >= -ybounds && y <= ybounds) &&
      (z >= -zbounds && z <= zbounds)){
    return dV;
  }
  else if ((x >= -2*xbounds && x <= 2*xbounds) &&
      (y >= -2*ybounds && y <= 2*ybounds) &&
      (z >= -2*zbounds && z <= 2*zbounds)){
    return 8*dV; /* 2*dx*2*dy*2*dz */
  }
  else {
    return 64*dV; /* 4*dx*4*dy*4*dz */
  }
}



void
print_subdomain
(
 double* x,
 double* y,
 double* z,
 int scalar_size
)
{
  for (int i = 0; i < scalar_size; i++){
      printf("i x y z = %d %f %f %f\n", i, x[i], y[i], z[i]);
  }
}


void
get_ijk
(
 int index,
 int* i,
 int* j,
 int* k,
 int nx,
 int ny,
 int nz
)
{  
  *i = index % nx;
  *j = ((index - *i)/nx) % ny;
  *k = (((index -*i)/nx) - *j)/ny;
}


int
is_it_ghost_zone
(
 int index,
 int nx,
 int ny,
 int nz
)
{
  int i,j,k;
  get_ijk(index, &i, &j, &k, nx, ny, nz);
  int icond = (i == 0 || i == 1 || i == 2 || i == nx - 1 || i == nx - 2 || i == nx - 3);
  int jcond = (j == 0 || j == 1 || j == 2 || j == ny - 1 || j == ny - 2 || j == ny - 3);
  int kcond = (k == 0 || k == 1 || k == 2 || k == nz - 1 || k == nz - 2 || k == nz - 3);
  if (icond || jcond || kcond){
    return 1;
  }
  else {
    return 0;
  }
}

double
get_mass_above_radius
(
 double* x,
 double* y,
 double* z,
 double* rho,
 double* minusu_th,
 int scalar_size,
 double xbounds,
 double ybounds,
 double zbounds,
 double r_min,
 int nx,
 int ny,
 int nz
)
{
  double mass = 0.;
  for (int i = 0; i < scalar_size; i++){
    if(minusu_th[i] > 1.){
      double r = sqrt(x[i]*x[i] + y[i]*y[i] + z[i]*z[i]);
      /* printf("i x y z = %d %f %f %f\n", i, x[i], y[i], z[i]); */
      double dV = compute_dV(x[i],y[i],z[i],
                             xbounds,ybounds,zbounds,
                             201,201,101);
      if (r >= r_min && !is_it_ghost_zone(i,nx,ny,nz)){
        mass += rho[i]*dV;
      }
    }
  }
  return mass;
}


int main(int argc, char *argv[])
{
  // Initialize the MPI environment
  MPI_Init(NULL, NULL);

  // Get the number of processes
  int world_size;
  MPI_Comm_size(MPI_COMM_WORLD, &world_size);

  // Get the rank of the process
  int world_rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

  srand(time(NULL));   // should only be called once
  int num = get_number_of_h5_files();
  sds* file_list = init_file_list(num);
  get_file_list(file_list);
  print_file_list(file_list,num);

  int dnum = ceil(num/(double)world_size);

  printf("num = %d\n", num);
  printf("dnum = %d\n", dnum);

  int start = world_rank*dnum;
  int end = (((start + dnum) > num - 1) || (world_rank == world_size - 1)) ? num - 1 : start + dnum;
  printf("this process will handle = %d - %d\n", start, end);

  if (argc != 5){
    printf("get_hist_exe <xbounds> <ybounds> <zbounds> <r_min>\n");
    exit(1);
  }
  printf("xbounds, ybounds, zbounds = %.15f %15f %.15f\n", atof(argv[1]), atof(argv[2]), atof(argv[3]));

  double mass = 0.;

  for (int i = start; i <= end; i++){

    int extents [3];
    sds file = file_list[i];
    printf("Parsing file %d = %s\n", i, file);
    int scalar_size = -1;
    double* rho = hyvolumedata_read_dataset(file, "/Rho/Step000000", "scalar", &scalar_size, &extents[0]);
    double* minusu_th = hyvolumedata_read_dataset(file, "Minusu_tH/Step000000", "scalar", &scalar_size, NULL);
    double* x = hyvolumedata_read_dataset(file, "GridToInertialFD--MappedCoords/Step000000", "x", &scalar_size, NULL);
    double* y = hyvolumedata_read_dataset(file, "GridToInertialFD--MappedCoords/Step000000", "y", &scalar_size, NULL);
    double* z = hyvolumedata_read_dataset(file, "GridToInertialFD--MappedCoords/Step000000", "z", &scalar_size, NULL);

    printf("extents = %d, %d, %d\n", extents[0],extents[1],extents[2]);

    /* for (int ind = 0; ind < scalar_size; ind++){ */
    /*   int i1,j1,k1; */

    /*   get_ijk */
    /*     ( */
    /*      ind, */
    /*      &i1, */
    /*      &j1, */
    /*      &k1, */
    /*      extents[0], */
    /*      extents[1], */
    /*      extents[2] */
    /*     ); */

    /*   printf("ind, i,j,k = %d, %d,%d,%d\n", ind, i1,j1,k1); */

    /* } */
    
    mass += get_mass_above_radius
      (
       x,
       y,
       z,
       rho,
       minusu_th,
       scalar_size,
       atof(argv[1]),//double xbounds,
       atof(argv[2]),//double ybounds,
       atof(argv[3]),//double zbounds,
       atof(argv[4]),
       extents[0],
       extents[1],
       extents[2]
       );

    /* print_subdomain */
      /* (x,y,z,scalar_size); */

    /* break; */
    
    free(rho);
    free(minusu_th);
    free(x);
    free(y);
    free(z);
  }

  double xmax = 4.*atof(argv[1]);
  double ymax = 4.*atof(argv[2]);
  double zmax = 4.*atof(argv[3]);
  double rmax = sqrt(xmax*xmax + ymax*ymax + zmax*zmax);

  double global_mass;
  MPI_Reduce(&mass, &global_mass, 1, MPI_DOUBLE,MPI_SUM, 0, MPI_COMM_WORLD);

  if (world_rank == 0){
    printf("xmax, zmax, rmax, rmin, mass = %f %f %f %f %f\n", xmax, zmax, rmax, atof(argv[4]), global_mass);
  }
  
  destroy_file_list(file_list,num);
  MPI_Finalize();
    
  return 0;
}
