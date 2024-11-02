#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

// Recursive function in which it goes for all the files in the directory and subdirectories to find a specific file
void find(char *directory_path, char *target_file)
{
  char path_buffer[512], *path_pointer;
  int directory_fd;
  struct dirent directory_entry;
  struct stat stat_buffer;

  // Try to open the directory, if it fails, print an error and return
  if((directory_fd = open(directory_path, O_RDONLY)) < 0){
    fprintf(2, "search_file: cannot open %s\n", directory_path);
    return;
  }

  // Get the status of the directory to verify if it's valid 
  if(fstat(directory_fd, &stat_buffer) < 0){
    fprintf(2, "search_file: cannot stat %s\n", directory_path);
    close(directory_fd);
    return;
  }

  // Ensure the provided path is a directory
  if(stat_buffer.type != T_DIR){
    fprintf(2, "search_file: first argument must be a directory\n");
    close(directory_fd);
    return;
  }

  // Copy the directory path into the buffer and prepare to append file names by using / as a separator
  strcpy(path_buffer, directory_path);
  path_pointer = path_buffer + strlen(path_buffer);
  *path_pointer++ = '/';

  // Read directory entries one by one and search for the target file
  while(read(directory_fd, &directory_entry, sizeof(directory_entry)) == sizeof(directory_entry)){
    if(directory_entry.inum == 0) continue; // Skip invalid entries

    // Copy the current directory entry name into the buffer
    memmove(path_pointer, directory_entry.name, DIRSIZ);
    path_pointer[DIRSIZ] = 0;

    // Get the status of the current file/directory
    if(stat(path_buffer, &stat_buffer) < 0){
      printf("search_file: cannot stat %s\n", path_buffer);
      continue;
    }

    // If it's a directory, and not "." or "..", recursively search inside it and it will make the same stuff above to solve it
    if(stat_buffer.type == T_DIR && strcmp(path_pointer, ".") != 0 && strcmp(path_pointer, "..") != 0){
      find(path_buffer, target_file);
    }
    // If it's a file and matches the target file name, print its path 
    else if(stat_buffer.type == T_FILE && strcmp(path_pointer, target_file) == 0){
      printf("%s\n", path_buffer);
    }
  }
  close(directory_fd);
}

int main(int argc, char *argv[])
{
  if(argc != 3){
    fprintf(2, "Usage: search_file <directory> <file>\n");
    exit(1);
  }

  find(argv[1], argv[2]);
  
  exit(0);
}

