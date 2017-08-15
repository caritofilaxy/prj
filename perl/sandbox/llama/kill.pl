#!/usr/bin/perl

use v5.022;
use warnings;

# 1) SIGHUP       2) SIGINT       3) SIGQUIT      4) SIGILL       5) SIGTRAP
# 6) SIGABRT      7) SIGBUS       8) SIGFPE       9) SIGKILL     10) SIGUSR1
#11) SIGSEGV     12) SIGUSR2     13) SIGPIPE     14) SIGALRM     15) SIGTERM
#16) SIGSTKFLT   17) SIGCHLD     18) SIGCONT     19) SIGSTOP     20) SIGTSTP
#21) SIGTTIN     22) SIGTTOU     23) SIGURG      24) SIGXCPU     25) SIGXFSZ



sub my_hup { state $n; say "Caught HUP: ", ++$n };
sub my_usr1 { state $n; say "Caught USR1: ", ++$n };
sub my_quit { state $n; say "Caught QUIT: ", ++$n };
sub my_trap { state $n; say "Caught TRAP: ", ++$n };
sub my_int { say "Caught INT, exiting. "; exit };

say "Im $$";

for my $signal (qw(hup int usr1 quit trap)) {
	$SIG{uc $signal} = "my_$signal";
	}

sleep 1 while(1);
