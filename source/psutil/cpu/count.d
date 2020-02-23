module psutil.cpu.count;


private __gshared ulong NUM_PROCESSORS_ONLINE;

/**
 * Returns the number of logical CPUs in the system.
 */
version(linux)
ulong logicalCount() @nogc nothrow
{
    return NUM_PROCESSORS_ONLINE;
}

/**
 * Returns the number of physical cores in the system.
 */
version(linux)
ulong physicalCount()
{
    import std.algorithm : filter, map, sort, uniq;
    import std.array : array;
    import std.conv : to;
    import std.file : dirEntries, readText, SpanMode;
    import std.path : baseName, buildPath;
    import std.regex : ctRegex, matchFirst;
    import std.string : chop;

    auto ids = dirEntries("/sys/devices/system/cpu", SpanMode.shallow)
        .filter!(entry => entry.name.baseName.matchFirst(ctRegex!`cpu[0-9?]`))
        .map!(entry => buildPath(entry.name, "topology/core_id"))
        .map!(path => path.readText.chop.to!ulong)
        .array;
    ids.sort();
    auto count = ids.uniq.array.length;
    if (count > 0)
        return count;
    return 1;
}

///
shared static this()
{
    import core.sys.posix.unistd;
    NUM_PROCESSORS_ONLINE = sysconf(_SC_NPROCESSORS_ONLN);
}
