# temperature notes

raw = `cat /sys/bus/iio/devices/iio\:device0/in_temp0_ps_temp_raw`
offset = `cat /sys/bus/iio/devices/iio\:device0/in_temp0_ps_temp_offset`
scale = `cat /sys/bus/iio/devices/iio\:device0/in_temp0_ps_temp_scale`

temperature = (raw + offset) * scale / 1000
