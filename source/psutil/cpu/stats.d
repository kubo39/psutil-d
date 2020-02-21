module psutil.cpu.stats;

import std.conv : to;
import std.stdio : File;
import std.string : split;

private import psutil.cpu.common;

///
version(linux)
struct CpuStats
{
    ulong ctxSwitches;
    ulong interrupts;
    ulong softInterrupts;
}

/**
 * Returns various CPU stats.
 */
version(linux)
CpuStats stats()
{
    CpuStats stats;
    foreach (line; File(PROCFS_STAT_PATH).byLine)
    {
        auto pair = line.split(' ');

        string name;
        ulong* field;
        switch (pair[0])
        {
        case "ctxt":
            name = "ctxt";
            field = &stats.ctxSwitches;
            break;
        case "intr":
            name = "intr";
            field = &stats.interrupts;
            break;
        case "softireq":
            name = "softireq";
            field = &stats.softInterrupts;
            break;
        default:
            continue;
        }
        *field = line[1].to!ulong;
    }
    return stats;
}
