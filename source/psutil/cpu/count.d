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

///
shared static this()
{
    import core.sys.posix.unistd;
    NUM_PROCESSORS_ONLINE = sysconf(_SC_NPROCESSORS_ONLN);
}
