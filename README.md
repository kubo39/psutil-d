# psutil for D

A system monitoring library for D, heavily inspired by [psutil](https://github.com/giampaolo/psutil). Currently support Linux only.

Currently implemented:

- cpu.count
- cpu.stats
- cpu.times
- disk.partitions
- memory.memory
- memory.swap
- sensors.battery
- sensors.fan
- sensors.temperature

## Examples

### Cpu

```console
$ dub examples/cpu.d
```

### Disk

```console
$ dub examples/disk.d
```

### Memory

```console
$ dub examples/memory.d
```

### Sensors

```console
$ dub examples/sensors.d
```
