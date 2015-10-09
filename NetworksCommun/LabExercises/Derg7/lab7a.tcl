set ns [new Simulator]

Agent/rtProto/Direct set preference_ 200
$ns rtproto DV

set nf [open lab7a.nam w]
$ns namtrace-all $nf
set xf [open lab7a.tr w]
$ns trace-all $xf

$ns color 0 blue
$ns color 1 red

for {set i 0} {$i < 8} {incr i}	{
	set n($i) [$ns node]
} 	

for {set i 0} {$i<8} {incr i}	{
	$ns duplex-link $n($i) $n([expr ($i+1)%8]) 1Mb 20ms DropTail
	$ns cost $n($i) $n([expr ($i+1)%8]) 2
	$ns cost $n([expr ($i+1)%8]) $n($i) 2

}



$ns duplex-link $n(7) $n(1) 1Mb 30ms DropTail
$ns cost $n(7) $n(1) 3
$ns cost $n(1) $n(7) 3

$ns duplex-link $n(7) $n(6) 1Mb 30ms DropTail
$ns cost $n(7) $n(6) 3
$ns cost $n(6) $n(7) 3

$ns duplex-link $n(5) $n(7) 1Mb 50ms DropTail
$ns cost $n(5) $n(7) 5
$ns cost $n(7) $n(5) 5



$ns duplex-link $n(3) $n(1) 1Mb 20ms DropTail
$ns cost $n(3) $n(1) 2
$ns cost $n(1) $n(3) 2

$ns duplex-link $n(5) $n(3) 1Mb 30ms DropTail
$ns cost $n(5) $n(3) 3
$ns cost $n(3) $n(5) 3


proc finish	{}	{
	global ns nf xf
	$ns flush-trace
	close $nf
	close $xf
	exit 0
}

set tcp1 [new Agent/TCP]
$tcp1 set packetSize_ 500
$ns attach-agent $n(0) $tcp1
$tcp1 set fid_ 0

set sink1 [new Agent/TCPSink]
$ns attach-agent $n(5) $sink1
$ns connect $tcp1 $sink1

set tcp2 [new Agent/TCP]
$tcp2 set packetSize_ 500
$ns attach-agent $n(4) $tcp2
$tcp2 set fid_ 1

set sink2 [new Agent/TCPSink]
$ns attach-agent $n(7) $sink2
$ns connect $tcp2 $sink2


set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2



$ns at 0.5 "$ftp1 produce 120"
$ns at 0.8 "$ftp2 produce 120"
$ns at 3 "finish"
$ns run
