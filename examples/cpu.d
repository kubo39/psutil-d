/+dub.sdl:
name "cpu"
dependency "psutil" path="../"
+/
import std.stdio;

import psutil.cpu.stats;

void main()
{
    writeln(stats());
}
