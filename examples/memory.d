/+dub.sdl:
name "memory"
dependency "psutil" path="../"
+/
import std.stdio;

import psutil.memory;

void printSwapInfo()
{
    auto swap = swap();
    with (swap)
    {
        writefln("swap total:\t%d", total);
        writefln("swap free:\t%d", free);
        writefln("swap used:\t%d", used);
        writefln("swap in:\t%d", vmstat.swapIn);
        writefln("swap out:\t%d", vmstat.swapOut);
    }
}

void printVirtualMemoryInfo()
{
    auto vmem = virtualMemory();
    with (vmem)
    {
        writefln("vmem total\t%d", total);
        writefln("vmem free\t%d", free);
        writefln("vmem used\t%d", used);
        writefln("vmem available\t%d", available);
        writefln("vmem buffers\t%d", buffers);
        writefln("vmem cached\t%d", cached);
        writefln("vmem active\t%d", active);
        writefln("vmem inactive\t%d", inactive);
        writefln("vmem shmem\t%d", shmem);
        writefln("vmem slab\t%d", slab);
    }
}

void main()
{
    writeln("===SWAP===");
    printSwapInfo();
    writeln("===VIRTUAL MEMORY===");
    printVirtualMemoryInfo();
}
