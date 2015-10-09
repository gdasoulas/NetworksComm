set ns [new Simulator]
Agent/rtProto/Direct set preference_ 200
$ns rtproto DV

$ns color 0 blue
$ns color 1 red

set nf [open lab7b.nam w]
$ns namtrace-all $nf
set xf1 [open lab7b1.tr w]
set xf2 [open lab7b2.tr w]
$ns trace-all $xf1



for {set i 0} {$i < 4} {incr i}	{
	set n($i) [$ns node]
} 	

for {set i 1} {$i<3} {incr i}	{
	$ns duplex-link $n($i) $n([expr ($i+1)]) 15Mb 10ms DropTail
}
$ns duplex-link $n(3) $n(1) 1.2Mb 10ms DropTail
$ns duplex-link $n(0) $n(1) 1.2Mb 10ms DropTail



proc record {} {
global sink0 sink1 xf1 xf2
set ns [Simulator instance]
set time 0.15
set bw0 [$sink0 set bytes_]
set bw1 [$sink1 set bytes_]
set now [$ns now]
puts $xf1 "$now [expr $bw0/$time*8/1000000]"
puts $xf2 "$now [expr $bw1/$time*8/1000000]"
$sink0 set bytes_ 0
$sink1 set bytes_ 0
$ns at [expr $now+$time] "record"
}

proc finish	{}	{
	global ns nf xf1 xf2
	$ns flush-trace
	close $nf
	close $xf1
	close $xf2
	exit 0
}

set udp2 [new Agent/UDP]
$udp2 set packetSize_ 500
$ns attach-agent $n(2) $udp2
$udp2 set fid_ 0


set sink0 [new Agent/LossMonitor]
$ns attach-agent $n(0) $sink0
$ns connect $udp2 $sink0

set udp3 [new Agent/UDP]
$udp3 set packetSize_ 500
$ns attach-agent $n(3) $udp3
$udp3 set fid_ 1


set sink1 [new Agent/LossMonitor]
$ns attach-agent $n(1) $sink1
$ns connect $udp3 $sink1

set cbr2 [new Application/Traffic/CBR]
$cbr2 set packetSize_ 500
$cbr2 set interval_ 0.005
$cbr2 attach-agent $udp2

set cbr3 [new Application/Traffic/CBR]
$cbr3 set packetSize_ 500
$cbr3 set interval_ 0.005
$cbr3 attach-agent $udp3


$ns at 0.0 "record"
$ns at 0.25 "$cbr2 start"
$ns at 0.25 "$cbr3 start"
$ns rtmodel-at 1 down $n(0) $n(1)
$ns rtmodel-at 1.5 up $n(0) $n(1)
$ns at 3 "$cbr2 stop"
$ns at 3 "$cbr3 stop"
$ns at 3.5 "finish"
$ns run
