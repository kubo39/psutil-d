module psutil.sensors.fan;

import std.algorithm : map, filter;
import std.array : array;
import std.conv : to;
import std.file : dirEntries, readText, SpanMode;
import std.path : buildPath, dirName;
import std.string : chop, endsWith;

private import psutil.sensors.common;

///
struct Fan
{
    string name;
    string label;
    ulong current;
}

/**
 * Returns hardware fans information.
 *
 * Implementation notes:
 * - This only relies on /sys/class/hwmon as interface to retrieve these
 *   information, and doesn't support old distros.
 */
version(linux)
Fan[] fans()
{
    return dirEntries(SYSFS_HWMON_PATH, SpanMode.shallow, false)
        .filter!(a => !a.name.dirEntries("fan*_*", SpanMode.shallow, false).empty)
        .map!((a) {
                Fan fan;

                bool first = true;
                foreach (entry; a.name.dirEntries("fan*_*", SpanMode.shallow, false))
                {
                    if (first)
                    {
                        fan.name = buildPath(dirName(entry.name), "name").readText.chop;
                        first = false;
                    }
                    if (entry.name.endsWith("_label"))
                        fan.label = entry.readText.chop;
                    else if (entry.name.endsWith("_input"))
                        fan.current = entry.readText.chop.to!ulong;
                }
                return fan;
            })
        .array;
}
