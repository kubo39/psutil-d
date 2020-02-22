/+dub.sdl:
name "sensors"
dependency "psutil" path="../"
+/
import std.stdio;

import psutil.sensors.battery;
import psutil.sensors.fan;
import psutil.sensors.temperature;

void main()
{
    writeln(battery().get);
    writeln(fans());
    writeln(temperatures());
}
