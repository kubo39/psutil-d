module psutil.memory.memory;

import std.conv : parse;
import std.stdio : File;
import std.string : split, stripLeft;

private import psutil.memory.common;

///
version(linux)
struct Memory
{
    ulong total;
    ulong free;
    ulong available;
    ulong buffers;
    ulong cached;
    ulong active;
    ulong inactive;
    ulong shmem;
    ulong slab;

    /**
     * Calculate used memory.
     */
    ulong used() @nogc nothrow pure @safe
    {
        auto used = total - free - cached - buffers;
        if (used < 0)
            // In case LCX containers.
            used = total - free;
        return used;
    }
}

/**
 * Returns virtual memory stats.
 */
version(linux)
Memory virtualMemory()
{
    Memory memory;
    foreach (line; File(PROCFS_MEMINFO_PATH).byLine)
    {
        // This cool trick was stolen from heim-rs.
        switch (line[0 .. 2])
        {
        case "Me", "Ac", "In", "Bu", "Ca", "Sh", "Sl":
            break;
        default:
            continue;
        }

        auto pair = line.split(':');
        ulong* field;
        switch (pair[0])
        {
        case "MemTotal":
            field = &memory.total;
            break;
        case "MemFree":
            field = &memory.free;
            break;
        case "MemAvailable":
            field = &memory.available;
            break;
        case "Buffers":
            field = &memory.buffers;
            break;
        case "Cached":
            field = &memory.cached;
            break;
        case "Active":
            field = &memory.active;
            break;
        case "Inactive":
            field = &memory.inactive;
            break;
        case "Shmem":
            field = &memory.shmem;
            break;
        case "Slab":
            field = &memory.slab;
            break;
        default:
            continue;
        }

        *field = pair[1].stripLeft.split(' ')[0].parse!ulong * 1024; /* kilobyte */
    }
    return memory;
}
