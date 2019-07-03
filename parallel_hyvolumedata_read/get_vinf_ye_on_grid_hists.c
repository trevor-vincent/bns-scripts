// -*- compile-command: "mpicc -o ../get_hists get_vinf_ye_on_grid_hists.c read_hyvolumedata_h5.c sds.c -std=c99 -lhdf5 -lm" -*-
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <math.h>
#include <time.h>
#include "read_hyvolumedata_h5.h"

#ifndef M_PI
#    define M_PI 3.14159265358979323846
#endif

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

double compute_vinf
(
 double rho,
 double minusu_th
)
{
  double A = rho*(minusu_th - 1.);
  double B = rho;
  return  sqrt(1.-1./(1.+A/B)/(1.+A/B));
}

double compute_theta
(
 double x,
 double y,
 double z
)
{
  double r = sqrt(x*x + y*y + z*z);
  return acos(z/r);
}

double deg_to_rad
(
 double theta
)
{
  return (M_PI/180.0)*theta;
}

typedef enum {POLAR, EQUATORIAL} ejecta_type_t;

ejecta_type_t get_ejecta_type
(
 double theta_rad,
 double theta_max_deg
)
{           
  if (theta_rad < deg_to_rad(theta_max_deg) || (theta_rad > deg_to_rad(180 - theta_max_deg))){
    return POLAR;
  }

  else {
    return EQUATORIAL;
  }
}

      /* add_to_bin(ye[i], etype, ye_bins, ye_bin_values, ye_polar_bin_values, ye_equa_bin_values); */

void add_to_bin
(
 double scalar,
 double mass,
 double mass_particle,
 ejecta_type_t etype,
 double* scalar_bins,
 double* scalar_bin_values,
 double* scalar_polar_bin_values,
 double* scalar_equa_bin_values,
 int num_bins
){
  if (mass < mass_particle){
    double prob = mass/mass_particle;
    double dev = rand() / (double)RAND_MAX;
    if (dev > prob){
      return;
    }
  }
  
  for (int i = 0; i < num_bins; i++){
    if(scalar <= scalar_bins[i]){
      scalar_bin_values[i] += mass;
      if (etype == POLAR){
        scalar_polar_bin_values[i] += mass;
      }
      else {
        scalar_equa_bin_values[i] += mass;
      }
      break;
    }
  }  
}


void get_hist
(
 double* x,
 double* y,
 double* z,
 double* ye,
 double* Rho,
 double* Minusu_tH,
 int scalar_size,
 double xbounds,
 double ybounds,
 double zbounds,
 double theta_max_deg,
 double* ye_bins,
 double* ye_bin_values,
 double* ye_polar_bin_values,
 double* ye_equa_bin_values,
 double* vinf_bins,
 double* vinf_bin_values,
 double* vinf_polar_bin_values,
 double* vinf_equa_bin_values,
 double r_min,
 int nx,
 int ny,
 int nz,
 int num_bins
)
{
  for (int i = 0; i < scalar_size; i++){
    if(Minusu_tH[i] > 1.){
      double vinf = compute_vinf(Rho[i], Minusu_tH[i]);
      double theta_rad = compute_theta(x[i],y[i],z[i]);
      ejecta_type_t etype = get_ejecta_type(theta_rad,
                                            theta_max_deg);
      double dV = compute_dV(x[i],y[i],z[i],
                             xbounds,ybounds,zbounds,
                             201,201,101);
      double mass = Rho[i]*dV;
      double r = sqrt(x[i]*x[i] + y[i]*y[i] + z[i]*z[i]);
      
      if (r >= r_min && !is_it_ghost_zone(i,nx,ny,nz)){
      add_to_bin(ye[i], mass, 1e-8, etype, ye_bins, ye_bin_values, ye_polar_bin_values, ye_equa_bin_values, num_bins);
      add_to_bin(vinf, mass, 1e-8, etype, vinf_bins, vinf_bin_values, vinf_polar_bin_values, vinf_equa_bin_values, num_bins);
      }
    }
  }
}

void
write_hist_to_file(const char* file_name, double* bins, double* bin_values, int num_bins)
{
  FILE *f = fopen(file_name, "w");
  if (f == NULL)
    {
      printf("Error opening file!\n");
      exit(1);
    }
  for (int i = 0; i < num_bins; i++){
    fprintf(f, "%.15f %.15f\n", bins[i], bin_values[i]);
  }
  fclose(f); 
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

  int num_bins = 20;

  double vinf_bin_values [20];
  double vinf_polar_bin_values [20];
  double vinf_equa_bin_values [20];

  double ye_bin_values [20];
  double ye_polar_bin_values [20];
  double ye_equa_bin_values [20];

  double vinf_bin_values_reduced [20];
  double vinf_polar_bin_values_reduced [20];
  double vinf_equa_bin_values_reduced [20];

  double ye_bin_values_reduced [20];
  double ye_polar_bin_values_reduced [20];
  double ye_equa_bin_values_reduced [20];

  for (int i = 0; i < 20; i++){
    ye_bin_values[i] = 0;
    ye_polar_bin_values[i] = 0;
    ye_equa_bin_values[i] = 0;
    vinf_bin_values[i] = 0;
    vinf_polar_bin_values[i] = 0;
    vinf_equa_bin_values[i] = 0;
    ye_bin_values_reduced[i] = 0;
    ye_polar_bin_values_reduced[i] = 0;
    ye_equa_bin_values_reduced[i] = 0;
    vinf_bin_values_reduced[i] = 0;
    vinf_polar_bin_values_reduced[i] = 0;
    vinf_equa_bin_values_reduced[i] = 0;
  }

  
  double vinf_bins [] =
    {
     0.05,
     0.1,
     0.15,
     0.2,
     0.25,
     0.3,
     0.35,
     0.4,
     0.45,
     0.5,
     0.55,
     0.6,
     0.65,
     0.7,
     0.75,
     0.8,
     0.85,
     0.9,
     0.95,
     1.
    };

  double ye_bins [] =
    {
     0.,
     0.02777778,
     0.05555556,
     0.08333333,
     0.11111111,
     0.13888889,
     0.16666667,
     0.19444444,
     0.22222222,
     0.25,
     0.27777778,
     0.30555556,
     0.33333333,
     0.36111111,
     0.38888889,
     0.41666667,
     0.44444444,
     0.47222222,
     0.5,
     0.52777778
    };


  if (argc != 5){
    printf("get_hist_exe <xbounds> <ybounds> <zbounds> <r_min>\n");
    exit(1);
  }
  printf("xbounds, ybounds, zbounds = %.15f %15f %.15f\n", atof(argv[1]), atof(argv[2]), atof(argv[3]));
  
  for (int i = start; i <= end; i++){

    sds file = file_list[i];
    printf("Parsing file %d = %s\n", i, file);
    int scalar_size = -1;
    int extents [3];
    double* Rho = hyvolumedata_read_dataset(file, "/Rho/Step000000", "scalar", &scalar_size, extents);
    double* Ye = hyvolumedata_read_dataset(file, "Ye/Step000000", "scalar", &scalar_size,NULL);
    double* Minusu_tH = hyvolumedata_read_dataset(file, "Minusu_tH/Step000000", "scalar", &scalar_size,NULL);
   double* x = hyvolumedata_read_dataset(file, "GridToInertialFD--MappedCoords/Step000000", "x", &scalar_size, NULL);
    double* y = hyvolumedata_read_dataset(file, "GridToInertialFD--MappedCoords/Step000000", "y", &scalar_size, NULL);
    double* z = hyvolumedata_read_dataset(file, "GridToInertialFD--MappedCoords/Step000000", "z", &scalar_size, NULL);

    get_hist
      (
       x,
       y,
       z,
       Ye,
       Rho,
       Minusu_tH,
       scalar_size,
       atof(argv[1]),//double xbounds,
       atof(argv[2]),//double ybounds,
       atof(argv[3]),//double zbounds,
       30,//double theta_max_deg,
       &ye_bins[0],
       &ye_bin_values[0],
       &ye_polar_bin_values[0],
       &ye_equa_bin_values[0],
       &vinf_bins[0],
       &vinf_bin_values[0],
       &vinf_polar_bin_values[0],
       &vinf_equa_bin_values[0],
       atof(argv[4]), /* rmin */
       extents[0],
       extents[1],
       extents[2],
       num_bins
      );
    
    free(Rho);
    free(Ye);
    free(Minusu_tH);
    free(x);
    free(y);
    free(z);
  }

  MPI_Reduce(&ye_bin_values[0], &ye_bin_values_reduced[0], 20,MPI_DOUBLE,MPI_SUM, 0, MPI_COMM_WORLD);
  MPI_Reduce(&ye_polar_bin_values[0], &ye_polar_bin_values_reduced[0], 20,MPI_DOUBLE,MPI_SUM, 0, MPI_COMM_WORLD);
  MPI_Reduce(&ye_equa_bin_values[0], &ye_equa_bin_values_reduced[0], 20,MPI_DOUBLE,MPI_SUM, 0, MPI_COMM_WORLD);
  MPI_Reduce(&vinf_bin_values[0], &vinf_bin_values_reduced[0], 20,MPI_DOUBLE,MPI_SUM, 0, MPI_COMM_WORLD);
  MPI_Reduce(&vinf_polar_bin_values[0], &vinf_polar_bin_values_reduced[0], 20,MPI_DOUBLE,MPI_SUM, 0, MPI_COMM_WORLD);
  MPI_Reduce(&vinf_equa_bin_values[0], &vinf_equa_bin_values_reduced[0], 20,MPI_DOUBLE,MPI_SUM, 0, MPI_COMM_WORLD);

  if (world_rank == 0){
    write_hist_to_file("ye_on_grid_hyvolumedata_theta_30_all.dat", &ye_bins[0], &ye_bin_values_reduced[0], num_bins);
    write_hist_to_file("ye_on_grid_hyvolumedata_theta_30_polar.dat", &ye_bins[0], &ye_polar_bin_values_reduced[0], num_bins);
    write_hist_to_file("ye_on_grid_hyvolumedata_theta_30_equa.dat", &ye_bins[0], &ye_equa_bin_values_reduced[0], num_bins);
    write_hist_to_file("vinf_on_grid_hyvolumedata_theta_30_all.dat", &vinf_bins[0], &vinf_bin_values_reduced[0], num_bins);
    write_hist_to_file("vinf_on_grid_hyvolumedata_theta_30_polar.dat", &vinf_bins[0], &vinf_polar_bin_values_reduced[0], num_bins);
    write_hist_to_file("vinf_on_grid_hyvolumedata_theta_30_equa.dat", &vinf_bins[0], &vinf_equa_bin_values_reduced[0], num_bins);
  }  

  
  destroy_file_list(file_list,num);
  MPI_Finalize();
    
  return 0;
}
