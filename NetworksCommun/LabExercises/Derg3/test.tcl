set ns [new Simulator]
set nf [open test.nam w]
$ns namtrace-all $nf

for {set i 0} {$i < 9} {incr i}	{
	set n($i) [$ns node]
} 	

for {set i 0} {$i<4} {incr i}	{
	$ns duplex-link $n($i) $n([expr ($i+1)%7]) 2Mb 40ms DropTail
}

for {set i 4} {$i<7} {incr i}	{
	$ns duplex-link $n($i) $n([expr ($i+1)%7]) 2Mb 10ms DropTail
}


$ns duplex-link $n(7) $n(1) 2Mb 20ms DropTail
$ns duplex-link $n(7) $n(5) 2Mb 10ms DropTail
$ns duplex-link $n(8) $n(5) 2Mb 10ms DropTail
$ns duplex-link $n(8) $n(2) 2Mb 40ms DropTail

proc finish	{}	{
	global ns nf
	$ns flush-trace
	close $nf
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

set cbr3 [new Application/Traffic/CBR]
$cbr3 set packetSize_ 1500
$cbr3 set interval_ 0.015
$cbr3 attach-agent $udp3


$ns at 0.2 "$cbr0 start"
$ns at 0.7 "$cbr3 start"
$ns at 3.7 "$cbr3 stop"
$ns at 4.2 "$cbr0 stop"
$ns at 4.5 "finish"
$ns run

