#!/usr/bin/env bash

print_greeting() {
    echo "Hello from Bash!"
}

print_vars() {
    local name="Bash"
    local version=5.1
    printf "Using %s version %.1f\n" "$name" "$version"
}

print_escape() {
    printf "This is a newline:\nThis is a tab:\tDone!\n"
    printf "\e[32mGreen text\e[0m and normal text\n"
}

# Call your functions:
print_greeting
print_vars
print_escape
echo Hello world
