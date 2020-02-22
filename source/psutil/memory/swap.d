module psutil.memory.swap;

import std.conv : parse;
import std.stdio : File;
import std.string : split, stripLeft;

private import psutil.memory.common;

///
version(linux)
struct VmStat
{
    ulong swapIn;
    ulong swapOut;
}

/**
 * Gets swap_in/swap_out vis /proc/vmstat.
 */
VmStat vmstat()
{
    VmStat stat;

    foreach (line; File(PROCFS_VMSTAT_PATH).byLine)
    {
        switch (line[0 .. 2])
        {
        case "ps":
            break;
        default:
            continue;
        }

        auto pair = line.split(' ');
        ulong* field;
        switch(pair[0])
        {
        case "pswpin":
            field = &stat.swapIn;
            break;
        case "pswpout":
            field = &stat.swapOut;
            break;
        default:
            continue;
        }

        // values are expressed in 4 kilo bytes.
        *field = pair[1].stripLeft.split(' ')[0].parse!ulong * 1024 * 4;
    }

    return stat;
}


///
version(linux)
struct Swap
{
    ulong total;  // SwapTotal
    ulong free;   // SwapFree
    VmStat vmStat;

    ulong used() @nogc nothrow pure @safe
    {
        return total - free;
    }
}

/**
 * Returns swap memory metrics.
 */
version(linux)
Swap swap()
{
    Swap swap;

    // prefer /proc/meminfo over sysinfo(2), it's better for linux containers.
    foreach (line; File(PROCFS_MEMINFO_PATH).byLine)
    {
        switch (line[0 .. 2])
        {
        case "Sw":
            break;
        default:
            continue;
        }

        auto pair = line.split(':');
        ulong* field;
        switch(pair[0])
        {
        case "SwapTotal":
            field = &swap.total;
            break;
        case "SwapFree":
            field = &swap.free;
            break;
        default:
            continue;
        }

        *field = pair[1].stripLeft.split(' ')[0].parse!ulong * 1024; /* kilobyte */
    }
    swap.vmStat = vmstat();
    return swap;
}
