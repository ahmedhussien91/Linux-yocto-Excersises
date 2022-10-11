#include <fcntl.h> // open()
#include <stdio.h> // printf()
#include "error_functions.h"





int main() {
    int filed = open("aa", 0);
    // negative reporting error
    if(filed < 0){
        // error no. reported is 
        //#define ENOENT  2  /* No such file or directory */ 
        errExit("");
    }
}
