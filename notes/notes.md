# Development Notes

Ideas

```odari
include './notes' as notes // future idea

include 'std/memory' as mem
include 'std/io' as io

int var_name = 0 // variable declaration
int var_name = default // uses default type values
ptr ptr_to_var = !var_name
int deref_var = ptr_to_var!

arrayptr allocated_array = mem.allocate(int, 100) // allocates array with size 100, stored in vm memory as [id, size, sizeof(type), values...]
defer mem.free(allocated_array) // free memory of allocated array
mem.set(allocated_array, 0)

io.print("%d, %04x", allocated_array[0], allocated_array)

pub func printhi() -> void {
    io.print("Hello World!")
}

pub func printstring(string str) -> void {
    syscall(4, 2, &str[0], strlen(str))
}

printhi()

pub func return23() -> int {
    ret 23
}

_ = return23() // discard value of 23

pub func greaterthan10(i32 value) -> bool {
    if value > 10 {
        ret true
    } else {
        ret false
    }

    // can also be written as
    // if value > 10 then ret true
    // else then ret false
}

{ // create scope
    
}

```