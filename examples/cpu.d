/+dub.sdl:
name "cpu"
dependency "psutil" path="../"
+/
import std.stdio;

import psutil.cpu.count;
import psutil.cpu.stats;
import psutil.cpu.times;

void printLogicalCPUs()
{
    writefln("Logical CPUs:\t%d", logicalCount());
    writefln("Physical CPUs:\t%d", physicalCount());
}

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

void printTimes()
{
    auto times = times();
    with (times)
   {
        writefln("user:\t%3f", user);
        writefln("nice:\t%3f", nice);
        writefln("system:\t%3f", system);
        writefln("idle:\t%3f", idle);
        writefln("iowait:\t%3f", iowait);
        writefln("irq:\t%3f", irq);
        writefln("softirq:\t%3f", softirq);
        writefln("steal:\t%3f", steal);
        writefln("guest:\t%3f", guest);
        writefln("guestnice:\t%3f", guestnice);
   }
}

void printPerCpuTimes()
{
    auto perTimes = perTimes();
    foreach (cpu; perTimes)
    {
        with (cpu)
        {
            writefln("user:\t%3f", user);
            writefln("nice:\t%3f", nice);
            writefln("system:\t%3f", system);
            writefln("idle:\t%3f", idle);
            writefln("iowait:\t%3f", iowait);
            writefln("irq:\t%3f", irq);
            writefln("softirq:\t%3f", softirq);
            writefln("steal:\t%3f", steal);
            writefln("guest:\t%3f", guest);
            writefln("guestnice:\t%3f", guestnice);
        }
    }
}

void main()
{
    writeln("===Logical CPU Count===");
    printLogicalCPUs();
    writeln("===CPU Stats===");
    printStats();
    writeln("===CPU Times===");
    printTimes();
    writeln("===Per CPU Times===");
    printPerCpuTimes();
}
