module psutil.sensors.battery;

import std.conv : to;
import std.file : exists, isDir, readText;
import std.path : buildPath;
import std.string : chop;
import std.typecons : Nullable, nullable;

private import psutil.sensors.common;

///
version(linux)
struct Battery
{
    float energyNow;
    float powerNow;
    float energyFull;
    bool powerPlugged;
    string technology;

    float percent() @nogc nothrow pure @safe
    {
        return 100.0 * energyNow / energyFull;
    }
}

///
version(linux)
private Nullable!T getMetrics(T)(string path)
{
    if (!exists(path))
        return Nullable!T.init;
    return nullable(path.readText.chop.to!T);
}

/**
 * Returns battery information.
 */
version(linux)
Nullable!Battery battery()
{
    // Get the first available battery.
    auto root = buildPath(SYSFS_POWER_SUPPLY_PATH, "BAT0");
    if (!exists(root) || !isDir(root))
        return typeof(return).init;

    auto energyNow = getMetrics!float(buildPath(root, "energy_now"));
    auto powerNow = getMetrics!float(buildPath(root, "power_now"));
    auto energyFull = getMetrics!float(buildPath(root, "energy_full"));
    if (energyNow.isNull || powerNow.isNull || energyFull.isNull)
        return typeof(return).init;

    // Is AC power cable plugged in?
    bool powerPlugged = false;
    auto online = getMetrics!int(buildPath(SYSFS_POWER_SUPPLY_PATH, "AC0/online"));
    if (!online.isNull)
        powerPlugged = online.get == 1;

    string technology = getMetrics!string(buildPath(root, "technology")).get;

    return nullable(Battery(energyNow.get, powerNow.get, energyFull.get,
                            powerPlugged, technology));
}
