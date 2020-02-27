/+dub.sdl:
name "disk"
dependency "psutil" path="../"
+/
import std.stdio;

import psutil.disk.partitions;

void main()
{
    foreach (i, part; partitions())
    {
        writefln("partition %d", i);
        writefln("  device: %s", part.device);
        writefln("  mountpoint: %s", part.mountpoint);
        writefln("  fstype: %s", part.fstype);
        writefln("  options: %s", part.options);
    }
}
