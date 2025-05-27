# PP6

## Goal

In this exercise you will:

* Learn how to produce text output to the terminal in four different environments:

  1. **Bash** shell scripting
  2. **GNU Assembler** (GAS) using system calls
  3. **C** via the standard library
  4. **Python 3** using built‑in printing functions

**Important:** Start a stopwatch when you begin and work uninterruptedly for **90 minutes**. When time is up, stop immediately and record exactly where you paused.

---

> **⚠️ WARNING:** The **workflow** steps have been **updated** for PP6. Please review the new workflow below carefully before proceeding.

## Workflow

1. **Fork** this repository on GitHub
2. **Clone** your fork to your local machine
3. Create a **solutions** directory at the repository root: `mkdir solutions`
4. For each task, add your solution file into `./solutions/` (e.g., `[solutions/print.sh](./solutions/print.sh)`)
5. **Commit** your changes locally, then **push** to GitHub
6. **Submit** your GitHub repository link for review

---

## Prerequisites

* Several starter repos are available here:
  [https://github.com/orgs/STEMgraph/repositories?q=SSH%3A](https://github.com/orgs/STEMgraph/repositories?q=SSH%3A)

---

> **Note:** Place all your solution files under the `solutions/` directory in your cloned repo.

## Tasks

### Task 1: Bash Printing & Shell Prompt

**Objective:** Use both `echo` and `printf` to format and display text and variables, and customize your shell prompt and login/logout messages.

1. In `./solutions/`, create a file named `print.sh` based on the template below.
2. At the top of `print.sh`, add the shebang:

   ```bash
   #!/usr/bin/env bash
   ```
3. Implement at least three functions:

   * `print_greeting`: prints `Hello from Bash!` using `echo`.
   * `print_vars`: declares two variables (e.g., `name="Bash"`, `version=5.1") and prints them with `printf\` using format specifiers.
   * `print_escape`: demonstrates escape sequences: newline (`\n`), tab (`\t`), and ANSI color codes (e.g., `\e[32m` for green).
4. Make the script executable and verify it runs:

   ```bash
   chmod +x solutions/print.sh
   ./solutions/print.sh
   ```
5. Modify your **`~/.bashrc`** on your local machine to:

   * Change the `PS1` prompt to include your username and current directory (e.g., `export PS1="[\u@\h \W]\$ "`).
   * Display a **welcome** message on login (e.g., `echo "Welcome, $(whoami)!"`).
   * Display a **goodbye** message on logout (add a `trap` for `EXIT` to echo `Goodbye!`).
6. Reload your shell (`source ~/.bashrc`) and demonstrate the prompt, greeting, and exit message.

**Template for `solutions/print.sh`**

```bash
#!/usr/bin/env bash

print_greeting() {
    # TODO: echo "Hello from Bash!"
}

print_vars() {
    local name="Bash"
    local version=5.1
    # TODO: printf "Using %s version %.1f\n" "$name" "$version"
}

print_escape() {
    # TODO: printf "This is a newline:\nThis is a tab:\tDone!\n"
    # TODO: printf "\e[32mGreen text\e[0m and normal text\n"
}

# Call your functions:
print_greeting
print_vars
print_escape
```

**Solution Reference**
Place your completed `print.sh` in `solutions/` and commit. Then link it here:

```
[print.sh](https://github.com/YOUR_USERNAME/REPO_NAME/blob/main/solutions/print.sh)
```

#### Reflection Questions

1. **What is the difference between `printf` and `echo` in Bash?**
Use echo for simple printing; use printf when you need precise control over output format.

3. **What is the role of `~/.bashrc` in your shell environment?**
   ~/.bashrc is a shell script that runs every time you start a new interactive non-login Bash shell (like opening a new terminal window).

It typically contains user-specific shell configuration, such as:

Environment variables

Aliases

Functions

Prompt customization (like PS1)

Commands to run at shell start (welcome messages, etc.)
5. **Explain the difference between sourcing (`source ~/.bashrc`) and executing (`./print.sh`).**
Sourcing (source ~/.bashrc or . ~/.bashrc):

Runs the script inside the current shell.

Environment changes (variables, aliases, functions) persist in your current shell.

Used to apply configuration files immediately without starting a new shell.

Executing (./print.sh):

Runs the script in a new, separate shell process.

Environment changes inside the script do NOT affect the current shell.

Used to run standalone scripts or programs.

---

### Task 2: GAS Printing (32‑bit Linux)

**Objective:** Use the Linux `sys_write` and `sys_exit` system calls in GAS to write text, while ensuring your repo only contains source files.

1. At the repository root, create a file named `.gitignore` that ignores:

   * Object files (`*.o`)
   * Binaries/executables (e.g., `print`, `print_c`)
   * Any editor or OS-specific files
     Commit this `.gitignore` file.
     **Explain:** Why should compiled artifacts and binaries not be committed to a Git repository?
2. In `./solutions/`, create a file named `print.s` using the template below.
3. Define a message in the `.data` section (e.g., `msg: .ascii "Hello from GAS!\n"`, `len = . - msg`).
4. In the `.text` section’s `_start` symbol, invoke `sys_write` (syscall 4) and then `sys_exit` (syscall 1) via `int $0x80`.
5. Assemble and link in 32‑bit mode:

   ```bash
   as --32 -o print.o solutions/print.s
   ld -m elf_i386 -o print print.o
   ```
6. Run `./print` and verify it outputs your message.

**Template for `solutions/print.s`**

```asm
    .section .data
msg:    .ascii "Hello from GAS!\n"
len = . - msg

    .section .text
    .global _start
_start:
    movl $4, %eax        # sys_write
    movl $1, %ebx        # stdout
    movl $msg, %ecx
    movl $len, %edx
    int $0x80

    movl $1, %eax        # sys_exit
    movl $0, %ebx        # status 0
    int $0x80
```

**Solution Reference**

```
[print.s](https://github.com/YOUR_USERNAME/REPO_NAME/blob/main/solutions/print.s)
```

#### Reflection Questions

1. **What is a file descriptor and how does the OS use it?**
  File Descriptor (FD) is a small, non-negative integer used by the OS to uniquely identify an open file or input/output resource (like files, pipes, sockets, terminals).

When a program opens a file or socket, the OS returns a file descriptor to refer to that resource.

The OS uses the file descriptor as an index into a per-process table that stores info about open files (file position, access mode, etc.).
3. **How can you obtain or duplicate a file descriptor for another resource (e.g., a file or socket)?**
You get a file descriptor by:

Opening a file: using system calls like open().

Creating a socket: using socket().

To duplicate a file descriptor (e.g., redirect stdout), use:

dup() or dup2() system calls, which create a copy of an existing FD with a new number
4. **What might happen if you use an invalid file descriptor in a syscall?**
The syscall will fail and typically return an error (e.g., -1).

errno is set to indicate the error, often EBADF (Bad file descriptor).

The operation won’t complete, so no data is read/written.

Using invalid FDs can cause bugs or crashes if not handled properly.


---

### Task 3: C Printing

**Objective:** Use `printf` and `puts` from `<stdio.h>` to display formatted data.

1. In `./solutions/`, create `print.c` based on the template below.
2. Implement `main()` to print a greeting, an integer, a float, and a string via `printf`, then use `puts`.
3. Compile and run:

   ```bash
   gcc -std=c11 -Wall -o print_c solutions/print.c
   ./print_c
   ```

**Template for `solutions/print.c`**

```c
#include <stdio.h>

int main(void) {
    printf("Hello from C!\n");
    printf("Integer: %d, Float: %.2f, String: %s\n", 42, 3.14, "test");
    puts("This is puts output");
    return 0;
}
```

**Solution Reference**

```
[print.c](https://github.com/YOUR_USERNAME/REPO_NAME/blob/main/solutions/print.c)
```

#### Reflection Questions

1. **Use `objdump -d` on `print_c` to find the assembly instructions corresponding to your `printf` calls.**
2. **Why is the syntax written differently from GAS assembly? Compare NASM vs. GAS notation.**
   The syntax you're seeing here is GAS-style (AT&T) because objdump uses AT&T syntax by default.

Differences:

Registers have a % prefix (e.g., %rdi)

Source comes before destination in instructions

Instructions often end in size suffixes (e.g., movq, addl, etc.)



4. **How could you use `fprintf` to write output both to `stdout` and to a file instead? Provide example code.**
The fprintf() function in C allows you to send formatted output to any file stream — not just stdout. You can use it to print to both the console and a file simultaneously.

   

---

### Task 4: Python 3 Printing

**Objective:** Use Python’s `print()` function with various parameters and f‑strings.

1. In `./solutions/`, create `print.py` using the template below.
2. Implement `main()` to print a greeting, multiple values with custom `sep`/`end`, and an f‑string expression.
3. Make it executable and run:

   ```bash
   chmod +x solutions/print.py
   ./solutions/print.py
   ```

**Template for `solutions/print.py`**

```python
#!/usr/bin/env python3

def main():
    print("Hello from Python3!")
    print("A", "B", "C", sep="-", end=".\n")
    value = 2 + 2
    print(f"Two plus two equals {value}")

if __name__ == "__main__":
    main()
```

**Solution Reference**

```
[print.py](https://github.com/YOUR_USERNAME/REPO_NAME/blob/main/solutions/print.py)
```

#### Reflection Questions

1. **Is Python’s print behavior closer to Bash, Assembly, or C? Explain.**
   Closest to: Bash

Explanation:

Python’s print() is high-level and automatically handles output formatting, like Bash’s echo or printf.

Unlike C, you don’t have to manage format strings or manually handle newline characters (unless customizing).

It's abstracted far away from Assembly-level details like registers and system calls.
3. **Can you inspect a Python script’s binary with `objdump`? Why or why not?**
No, you cannot inspect a Python script directly with objdump.

Why?

objdump is for compiled binaries (like ELF executables).

Python scripts (.py) are interpreted text files, not compiled to machine code.

If compiled with tools like pyinstaller or cython, then the resulting binary can be inspected with objdump.

---

**Remember:** Stop working after **90 minutes** and document where you stopped.
