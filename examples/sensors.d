/+dub.sdl:
name "sensors"
dependency "psutil" path="../"
+/
import std.stdio;

import psutil.sensors.battery;
import psutil.sensors.fan;
import psutil.sensors.temperature;

void printBatteryInfo()
{
    auto battery = battery.get;
    with (battery)
    {
        writefln("energy now:\t%3f", energyNow);
        writefln("power now:\t%3f", powerNow);
        writefln("energy full:\t%3f", energyFull);
        writefln("percent:\t%3f %%", percent);
        writefln("power plugged:\t%s", powerPlugged);
        writefln("technology:\t%s", technology);
    }
}

void printFanInfo()
{
    foreach (fan; fans())
    {
        with (fan)
        {
            writefln("name:\t%s", name);
            writefln("label:\t%s", label);
            writefln("current:\t%d", current);
        }
    }
}

void printTemperatureInfo()
{
    foreach (temp; temperatures())
    {
        with (temp)
        {
            writefln("name:\t%s", name);
            writefln("label:\t%s", label);
            writefln("current:\t%3f", current);
        }
    }
}

void main()
{
    writeln("===Battery===");
    printBatteryInfo();
    writeln("===Fan===");
    printFanInfo();
    writeln("===Temperature===");
    printTemperatureInfo();
}
