/+dub.sdl:
name "cpu"
dependency "psutil" path="../"
+/
import std.stdio;

import psutil.cpu.stats;

void printStats()
{
    auto stats = stats();
    with (stats)
    {
        writefln("context switch:\t%d", ctxSwitches);
        writefln("interrupts:\t%d", interrupts);
        writefln("soft interrupts:\t%d", softInterrupts);
    }
}

void main()
{
    writeln("===CPU Stats===");
    printStats();
}
