module psutil.sensors.common;

version(linux)
package enum SYSFS_HWMON_PATH = "/sys/class/hwmon/";
version(linux)
package enum SYSFS_POWER_SUPPLY_PATH = "/sys/class/power_supply/";
