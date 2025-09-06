# Security Hooks

From here:

https://github.com/backslashxx/KernelSU/issues/20

`CONFIG_KSU_LSM_SECURITY_HOOKS=n` is set

Patched manual security hooks in security/security.c with:

https://github.com/backslashxx/KernelSU/issues/7

# Manual hooks

## scope-minimized manual hooks v1.5

https://github.com/backslashxx/KernelSU/issues/5

🟢 sys_execve hook

(3.10, via sys_execve)
 
🟢 sys_faccessat hook

(4.14 and older)

🟢 sys_newfstatat hook

🟢 sys_read hook

🟢 input hook for safemode

🟢 selinux hook

(3.10 and older)

🟢 walk_component

