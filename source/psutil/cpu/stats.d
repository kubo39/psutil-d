module psutil.cpu.stats;

import std.conv : parse;
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

        ulong* field;
        switch (pair[0])
        {
        case "ctxt":
            field = &stats.ctxSwitches;
            break;
        case "intr":
            field = &stats.interrupts;
            break;
        case "softirq":
            field = &stats.softInterrupts;
            break;
        default:
            continue;
        }
        *field = pair[1].parse!ulong;
    }
    return stats;
}
