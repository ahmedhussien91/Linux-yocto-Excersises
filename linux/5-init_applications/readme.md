# init programs 

We will follow the data described in [here-ch13-Mastering-Embedded-Linux](https://learning.oreilly.com/library/view/mastering-embedded-linux/9781789530384/B11566_13_Final_NM_ePub.xhtml#_idParaDest-328) 

There are many possible impelmentations of **init** but here we discuss:

- Busybox init
- System V init
- systemd 



## Introduction

The **init** program is the ancestor of all other processes, to show this you can use:

```sh
pstree -gn
```



**init** is used to:

-  During boot, after the kernel transfers control, the init program starts other daemon programs and configures system parameters and other things needed to get the system into a working state.
- Optionally, it launches a login daemon, such as getty, on terminals that allow
  a login shell.
- It adopts processes that become orphaned as a result of their immediate parent terminating and there being no other processes in the thread group.
- It responds to any of the init's immediate children terminating by catching the SIGCHLD signal and collecting the return value to prevent them from becoming zombie processes.
- Optionally, it restarts those daemons that have terminated.
- It handles the system shutdown.

(in short handles the lifecycle of the system from bootup to shutdown)

- in other schools init can also handle other runtime events for ex. new hardware and the loading and unloading of modules. This is what **systemd** does.

![image-20221029130712442](./assets/image-20221029130712442.png)

