Homework 08
===========

## Strace Output

### `duplicate`

% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
100.00    0.000055           2        28        24 open
  0.00    0.000000           0         9           read
  0.00    0.000000           0         7           write
  0.00    0.000000           0         4           close
  0.00    0.000000           0        24        19 stat
  0.00    0.000000           0         2           fstat
  0.00    0.000000           0         8           mmap
  0.00    0.000000           0         3           mprotect
  0.00    0.000000           0         1           munmap
  0.00    0.000000           0         3           brk
  0.00    0.000000           0         1         1 access
  0.00    0.000000           0         1           execve
  0.00    0.000000           0         1           arch_prctl
------ ----------- ----------- --------- --------- ----------------
100.00    0.000055                    92        44 total

### `dd`

% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 34.95    0.000065           1        47        39 open
 29.57    0.000055           2        24        19 stat
 20.43    0.000038          19         2           munmap
 15.05    0.000028           3        10           write
  0.00    0.000000           0        13           read
  0.00    0.000000           0        11           close
  0.00    0.000000           0         7           fstat
  0.00    0.000000           0         1           lseek
  0.00    0.000000           0        17           mmap
  0.00    0.000000           0         7           mprotect
  0.00    0.000000           0         3           brk
  0.00    0.000000           0         6           rt_sigaction
  0.00    0.000000           0         1           rt_sigprocmask
  0.00    0.000000           0         1         1 access
  0.00    0.000000           0         1           dup2
  0.00    0.000000           0         1           execve
  0.00    0.000000           0         1           getrlimit
  0.00    0.000000           0         1           arch_prctl
  0.00    0.000000           0         2         1 futex
  0.00    0.000000           0         1           set_tid_address
  0.00    0.000000           0         1           set_robust_list
------ ----------- ----------- --------- --------- ----------------
100.00    0.000186                   158        60 total

### `search`

% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 38.52    0.001186           0      3784      2118 access
 23.48    0.000723           0      3783           lstat
 20.10    0.000619           1       704           getdents
  6.27    0.000193           0       395        41 open
  4.12    0.000127           5        24        19 stat
  3.93    0.000121           0       354           close
  3.57    0.000110           0       297           write
  0.00    0.000000           0         1           read
  0.00    0.000000           0         3           fstat
  0.00    0.000000           0         9           mmap
  0.00    0.000000           0         3           mprotect
  0.00    0.000000           0         1           munmap
  0.00    0.000000           0         4           brk
  0.00    0.000000           0         1           execve
  0.00    0.000000           0         1           fcntl
  0.00    0.000000           0         1           arch_prctl
------ ----------- ----------- --------- --------- ----------------
100.00    0.003079                  9365      2178 total

### `find`

% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 43.58    0.001316           0      4135           newfstatat
 23.08    0.000697           0      2218      1938 access
  8.48    0.000256           0       793        78 open
  8.25    0.000249           0       707           fchdir
  4.77    0.000144           0       348           write
  4.34    0.000131           0       704           getdents
  4.01    0.000121           0       362           fstat
  3.51    0.000106           0       717           close
  0.00    0.000000           0        10           read
  0.00    0.000000           0        24        19 stat
  0.00    0.000000           0        25           mmap
  0.00    0.000000           0        13           mprotect
  0.00    0.000000           0         4           munmap
  0.00    0.000000           0         5           brk
  0.00    0.000000           0         2           rt_sigaction
  0.00    0.000000           0         1           rt_sigprocmask
  0.00    0.000000           0         2           ioctl
  0.00    0.000000           0         1           execve
  0.00    0.000000           0         1           uname
  0.00    0.000000           0         1           fcntl
  0.00    0.000000           0         1           getrlimit
  0.00    0.000000           0         1           statfs
  0.00    0.000000           0         1           arch_prctl
  0.00    0.000000           0         2         1 futex
  0.00    0.000000           0         1           set_tid_address
  0.00    0.000000           0         1           set_robust_list
------ ----------- ----------- --------- --------- ----------------
100.00    0.003020                 10080      2036 total

## Questions

1. Describe the differences you see between the number and type of system calls
   used by your utilities as compared to the standard Unix programs.

   Our duplicate function used less types of system calls as well as less system
   calls in general than the standard Unix program, dd.

   Our search program is very similar in that it has less total and not as many
   types of system calls as the standard find program.

2. Did you notice anything surprising about the trace of your utilities or the
   trace of the standard Unix programs? Which implementations are faster or
   more efficient?  Explain.

   Having less system calls was probably the main reason that our duplicate
   program performed faster than the standard dd program. However, ours had a
   higher percentage of errors over total system calls than dd did. Another
   difference was that all of the time for our program was spent in the open
   system call, whereas the time for dd was split between open, stat, munmap,
   and write. Also, they both called stat the same number of times, but did not
   call the other system calls the same amount.

   For the second program, the total number of system calls was still higher in
   the standard program than our program, but by a lower percentage of the total
   calls. Also, the times are very similar for the search and find programs,
   although my search program took a little longer than the standard find
   program. Mine also had more errors compared to the find program, but not by
   much.

   For both programs, especially duplicate vs dd, our programs are more
   efficient than the standard ones by using less total system calls, although
   the speed is incrementally slower for search vs find.
