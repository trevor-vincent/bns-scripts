//compile as:
//icc -o ../read_hyvolumedata_h5 read_hyvolumedata_h5.c sds.c -std=c99 -lhdf5

#include <hdf5.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <dirent.h>
#include <regex.h>
#include "sds.h"
#include "sdsalloc.h"
#include "read_hyvolumedata_h5.h"

int match(const char *string, const char *pattern)
{
    regex_t re;
    if (regcomp(&re, pattern, REG_EXTENDED|REG_NOSUB) != 0) return 0;
    int status = regexec(&re, string, 0, NULL, 0);
    regfree(&re);
    if (status != 0) return 0;
    return 1;
}

double*
hyvolumedata_read_dataset
(
 const char* file_name,
 const char* group_name,
 const char* dataset_name,
 int* size
)
{
  hid_t dataset_type = H5T_NATIVE_DOUBLE;
  
  /* Open an existing file. */
  hid_t file_id = H5Fopen(file_name, H5F_ACC_RDWR, H5P_DEFAULT);

  hid_t group_id = H5Gopen2(file_id, group_name, H5P_DEFAULT);
  
  /* Open an existing dataset. */
  hid_t dataset_id = H5Dopen2(group_id, dataset_name, H5P_DEFAULT);
  
  /* int size = H5Dget_storage_size(dataset_id); */
  hid_t dspace = H5Dget_space(dataset_id);

  hsize_t dims;
  H5Sget_simple_extent_dims(dspace, &dims, NULL);

  *size = dims;
  double* dataset = (double*)malloc(dims*sizeof(double));
  
  int err =  H5Dread(dataset_id,
                     dataset_type,
                     H5S_ALL,
                     H5S_ALL,
                     H5P_DEFAULT,
                     dataset);
  if (err < 0){
    printf("Problem reading h5 dataset, filename = %s, dataset = %s.\n", file_name, dataset_name);
    exit(1);
  }
  
  /* Close the dataset. */
  err = H5Dclose(dataset_id);
  if (err < 0){
    printf("Problem closing h5 dataset, filename = %s, dataset = %s.\n", file_name, dataset_name);
    exit(1);
  }

  /* Close the dataset. */
  err = H5Gclose(group_id);
  if (err < 0){
    printf("Problem closing h5 group, filename = %s, dataset = %s.\n", file_name, dataset_name);
    exit(1);
  }

  
  /* Close the file. */
  err = H5Fclose(file_id);
  if (err < 0){
    printf("Problem closing h5 file, filename = %s, dataset = %s.\n", file_name, dataset_name);
    exit(1);
  }
  
  return dataset;
}


int get_number_of_h5_files
()
{
  DIR *dp;
  struct dirent *ep;
  int num = 0;
  dp = opendir ("./");
  if (dp != NULL)
    {
      while (ep = readdir (dp)){
        if (match(ep->d_name, ".h5")){
          num++;
          /* free(dataset); */
        }
      }
      (void) closedir (dp);
    }
  else
    perror ("Couldn't open the directory");

  printf("There are %d .h5 files in this directory \n", num);
  return num;
}

sds* init_file_list(int num){
  return malloc(sizeof(sds)*num);
}

void get_file_list(sds* file_list){
  DIR *dp;
  struct dirent *ep;
  int num = 0;
  dp = opendir ("./");
  if (dp != NULL)
    {
      while (ep = readdir (dp)){
        if (match(ep->d_name, ".h5")){
          file_list[num] = sdsnew(ep->d_name);
          num++;
          /* free(dataset); */
        }
      }
      (void) closedir (dp);
    }
  else
    perror ("Couldn't open the directory");

  /* return num; */
}

void print_file_list(sds* file_list, int num){
  for (int i = 0; i < num; ++i) {
    printf("%s\n", file_list[i]);
  }
}

void destroy_file_list(sds* file_list, int num){
  for (int i = 0; i < num; ++i) {
    sdsfree(file_list[i]);
  }
  free(file_list);
}

/* int main(int argc, char *argv[]) */
/* { */

/*   int num = get_number_of_h5_files(); */
/*   sds* file_list = init_file_list(num); */
/*   get_file_list(file_list); */
/*   print_file_list(file_list,num); */
/*   destroy_file_list(file_list,num); */
  
/*   return 0; */
/* } */
