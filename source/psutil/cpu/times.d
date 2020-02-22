module psutil.cpu.times;

import std.conv : parse, to;
import std.range : dropOne;
import std.stdio : File, readln;
import std.string : split;
import std.typecons : Nullable, nullable;

private import psutil.cpu.common;

__gshared size_t CLOCK_TICKS;

///
version(linux)
struct Times
{
    double user;
    double nice;
    double system;
    double idle;
    double iowait;
    double irq;
    double softirq;
    double steal;
    Nullable!double guest;
    Nullable!double guestnice;
}

/**
 * Returns system-wide CPU times.
 */
version(linux)
Times times()
{
    Times times;

    // cumulative time is always the first line.
    auto values = File(PROCFS_STAT_PATH).readln.split.dropOne;
    foreach (i, part; values)
    {
        auto value = part.parse!uint.to!double / CLOCK_TICKS;

        switch (i)
        {
        case 0:
            times.user = value;
            break;
        case 1:
            times.nice = value;
            break;
        case 2:
            times.idle = value;
            break;
        case 3:
            times.system = value;
            break;
        case 4:
            times.iowait = value;
            break;
        case 5:
            times.irq = value;
            break;
        case 6:
            times.softirq = value;
            break;
        case 7:
            times.steal = value;
            break;
        case 8:
            times.guest = Nullable!double(value);
            break;
        case 9:
            times.guestnice = Nullable!double(value);
            break;
        default:
            continue;  // should fix?
        }
    }

    return times;
}

///
shared static this()
{
    import core.sys.posix.unistd;

    // Time units in USER HZ or Jiffies.
    CLOCK_TICKS = sysconf(_SC_CLK_TCK);
}
