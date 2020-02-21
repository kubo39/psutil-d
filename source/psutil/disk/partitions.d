module psutil.disk.partitions;

import std.stdio : File;
import std.string : split, startsWith, strip;
import std.typecons : Nullable;

///
version(linux)
struct Partition
{
    Nullable!string device;
    string mountpoint;
    string fstype;
    string options;
}

/**
 * Returns filesystem types current system supported.
 */
version(linux)
private string[] fstypes()
{
    import std.algorithm : map;

    string[] fstypes;
    foreach (line; File("/proc/filesystems").byLine.map!(strip))
    {
        if (!line.startsWith("nodev"))
        {
            fstypes ~= cast(immutable) line;
        }
        else
        {
            // Ignore all lines starting with "nodev" except "nodev zfs"
            if (line.split('\t')[1] == "zfs")
                fstypes ~= "zfs";
        }
    }
    return fstypes;
}

/**
 * Returns mounted disk partitions.
 */
version(linux)
Partition[] partitions()
{
    Partition[] partitions;
    string[] fstypes = fstypes();
    foreach (line; File("/proc/mounts").byLine)
    {
        Partition partition;

        auto parsed = line.split(' ');

        // ugly...
        partition.device = cast(immutable) parsed[0];
        partition.mountpoint = cast(immutable) parsed[1];
        partition.fstype = cast(immutable) parsed[2];
        partition.options = cast(immutable) parsed[3];

        partitions ~= partition;
    }
    return partitions;
}
