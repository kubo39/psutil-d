module psutil.cpu.common;

version(linux)
package enum PROCFS_STAT_PATH = "/proc/stat";
