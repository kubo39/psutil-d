module psutil.memory.common;

version(linux)
{
    package enum PROCFS_VMSTAT_PATH = "/proc/vmstat";
    package enum PROCFS_MEMINFO_PATH = "/proc/meminfo";
}
