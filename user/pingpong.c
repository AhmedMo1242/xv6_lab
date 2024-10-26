#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int p_parent[2], p_child[2]; pipe(p_parent); pipe(p_child);
  int pid = fork();
  if(pid == 0){
    close(p_parent[1]); 

    char buf[5];
    read(p_parent[0], buf, sizeof(buf));
    printf("%d: received ping\n", getpid());

    close(p_parent[0]);

    close(p_child[0]);
    write(p_child[1], "mo", 2);
    close(p_child[1]);

  }else if(pid >= 1){
    close(p_parent[0]);
    write(p_parent[1], "ahmed", 5);
    close(p_parent[1]);

    wait((int*) 0);

    char buff[2];
    read(p_child[0], buff, sizeof(buff));
    printf("%d: received pong\n", getpid());

    close(p_child[0]);
  }else{
    fprintf(2, "fork error!\n");
    exit(1);
  }

  exit(0);
}
