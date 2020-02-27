/+dub.sdl:
name "disk"
dependency "psutil" path="../"
+/
import std.stdio;

import psutil.disk.partitions;

void main()
{
    foreach (part; partitions())
        writeln(part);
}
