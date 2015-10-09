set ns [new Simulator]

set nf [open lab3a.nam w]
$ns namtrace-all $nf
set f0 [open out0.tr w]
set f3 [open out3.tr w]

proc record {} {
	global sink0 sink3 f0 f3
	set ns [Simulator instance]
	set time 0.015
	set bw0 [$sink3 set bytes_]
	set bw3 [$sink0 set bytes_]
	set now [$ns now]
	puts $f0 "$now [expr (($bw0/$time)*8)/1000000]"
	puts $f3 "$now [expr (($bw3/$time)*8)/1000000]"
	$sink0 set bytes_ 0
	$sink3 set bytes_ 0
	$ns at [expr $now +$time] "record"
}

for {set i 0} {$i < 9} {incr i}	{
	set n($i) [$ns node]
} 	

for {set i 0} {$i<7} {incr i}	{
	$ns duplex-link $n($i) $n([expr ($i+1)%7]) 2Mb 40ms DropTail
}

$ns duplex-link $n(7) $n(1) 2Mb 20ms DropTail
$ns duplex-link $n(7) $n(5) 2Mb 10ms DropTail
$ns duplex-link $n(8) $n(5) 2Mb 10ms DropTail
$ns duplex-link $n(8) $n(2) 2Mb 40ms DropTail

proc finish	{}	{
	global ns nf f0 f3
	$ns flush-trace
	close $nf
	close $f0
	close $f3
	exit 0
}

set udp0 [new Agent/UDP]
$udp0 set packetSize_ 1500
$ns attach-agent $n(0) $udp0
$udp0 set fid_ 0
$ns color 0 green
set sink0 [new Agent/LossMonitor]
$ns attach-agent $n(0) $sink0

set udp3 [new Agent/UDP]
$udp3 set packetSize_ 1500
$ns attach-agent $n(3) $udp3
$udp3 set fid_ 3
$ns color 3 yellow
set sink3 [new Agent/LossMonitor]
$ns attach-agent $n(3) $sink3

$ns connect $udp0 $sink3
$ns connect $udp3 $sink0

set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 1500
$cbr0 set interval_ 0.015
$cbr0 attach-agent $udp0

set Exponential3 [new Application/Traffic/Exponential]
$Exponential3 set packetSize_ 1500
$Exponential3 set rate_ 800k
$Exponential3 attach-agent $udp3

$ns at 0.0 "record"
$ns at 0.2 "$cbr0 start"
$ns at 0.7 "$Exponential3 start"
$ns at 23.7 "$Exponential3 stop"
$ns at 24.2 "$cbr0 stop"
$ns at 26.5 "finish"
$ns run

