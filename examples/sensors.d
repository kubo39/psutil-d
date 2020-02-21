/+dub.sdl:
name "sensors"
dependency "psutil" path="../"
+/
import std.stdio;

import psutil.sensors.fan;
import psutil.sensors.temperature;

void main()
{
    writeln(fans());
    writeln(temperatures());
}
