module psutil.sensors.temperature;

import std.algorithm : map, filter;
import std.array : array;
import std.conv : parse;
import std.file : dirEntries, DirEntry, readText, SpanMode;
import std.path : buildPath, dirName;
import std.typecons : Nullable, nullable;
import std.string : chop, endsWith;

private import psutil.sensors.common;

///
struct Temperature
{
    string name;
    string label;
    float current;
    Nullable!float high;
    Nullable!float critical;
}

///
version(linux)
private float readTemperature(DirEntry entry)
{
    auto input = entry.name.readText.chop.dup;
    return parse!float(input) / 1_000.0f;
}

/**
 * Returns hardware temperatures.
 *
 * Implementation notes:
 * - this implementaition relies on /sys/class/hwmon as interface to retrive
 *   these information, and doesn't support old distros.
 */
version(linux)
Temperature[] temperatures()
{
    return dirEntries(SYSFS_HWMON_PATH, SpanMode.shallow, false)
        .filter!(a => !a.name.dirEntries("temp*_*", SpanMode.shallow, false).empty)
        .map!((a) {
                Temperature temp;

                bool first = true;
                foreach (entry; a.name.dirEntries("temp*_*", SpanMode.shallow, false))
                {
                    if (first)
                    {
                        temp.name = buildPath(dirName(entry.name), "name").readText.chop;
                        first = false;
                    }
                    if (entry.name.endsWith("_label"))
                        temp.label = entry.name.readText.chop;
                    else if (entry.name.endsWith("_input"))
                        temp.current = readTemperature(entry);
                    else if (entry.name.endsWith("_crit"))
                        temp.critical = nullable(readTemperature(entry));
                    else if (entry.name.endsWith("_max"))
                        temp.high = nullable(readTemperature(entry));
                }
                return temp;
            })
        .array;
}
