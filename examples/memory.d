/+dub.sdl:
name "memory"
dependency "psutil" path="../"
+/
import std.stdio;

import psutil.memory;

void main()
{
    writeln(swap());
    writeln(virtualMemory());
}
