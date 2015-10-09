set ns [new Simulator]
set tf [open lab9.tr w]
$ns trace-all $tf
set nf [open lab9.nam w]
$ns namtrace-all $nf
$ns use-newtrace
$ns trace-all $tf
Agent/rtProto/Direct set preference_ 200
$ns rtproto DV
proc finish {} {
 global ns tf nf
 $ns flush-trace
 close $tf
 close $nf
 exit 0
}
for {set i 0} {$i < 5} {incr i} {
 set n($i) [$ns node]
 $n($i) label "Node $i"
}
for {set i 0} {$i < 5} {incr i} {
 if {$i != 2} {
 $ns duplex-link $n($i) $n(2) 2Mb 20ms DropTail
 $ns queue-limit $n($i) $n(2) 30
 $ns queue-limit $n(2) $n($i) 10
 $ns cost $n($i) $n(2) 2
 $ns cost $n(2) $n($i) 2
 $ns duplex-link-op $n($i) $n(2) label "Queue 2,$i :10,$i->2:30,speed: 2Mb"
 }
}
$ns duplex-link $n(1) $n(4) 1.2Mb 50ms DropTail
$ns cost $n(1) $n(4) 5
$ns cost $n(4) $n(1) 5
$ns queue-limit $n(1) $n(4) 30
$ns queue-limit $n(4) $n(1) 30
$ns queue-limit $n(2) $n(4) 10
$ns duplex-link-op $n(2) $n(0) orient left-up
$ns duplex-link-op $n(2) $n(3) orient right-up
$ns duplex-link-op $n(2) $n(4) orient right-down
$ns duplex-link-op $n(2) $n(1) orient left-down

set udp1 [new Agent/UDP]
$udp1 set fid_ 1
$udp1 set packetSize_ 1500
$ns attach-agent $n(0) $udp1
set null1 [new Agent/Null]
$ns attach-agent $n(3) $null1
$ns connect $udp1 $null1
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set packetSize_ 1500
$cbr1 set rate_ 1.0mb
$cbr1 set random_ off 
set tcp2 [new Agent/TCP]
$tcp2 set packetSize_ 1460
$tcp2 set fid_ 2
$ns attach-agent $n(0) $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $n(4) $sink2
$ns connect $tcp2 $sink2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
set udp3 [new Agent/UDP]
$udp3 set fid_ 3
$udp3 set packetSize_ 1500
$ns attach-agent $n(1) $udp3
set null3 [new Agent/Null]
$ns attach-agent $n(3) $null3
$ns connect $udp3 $null3
set exp3 [new Application/Traffic/Exponential]
$exp3 attach-agent $udp3
$exp3 set packetSize_ 1500
$exp3 set rate_ 1.2mb
set tcp4 [new Agent/TCP]
$tcp4 set packetSize_ 960
$tcp4 set fid_ 4
$ns attach-agent $n(1) $tcp4
set sink4 [new Agent/TCPSink]
$ns attach-agent $n(4) $sink4
$ns connect $tcp4 $sink4
set telnet4 [new Application/Telnet]
$telnet4 attach-agent $tcp4
$telnet4 set interval_ 0.001
$ns color 1 red
$ns color 2 blue
$ns color 3 yellow
$ns color 4 green
# Events
$ns at 0.15 "$cbr1 start"
$ns at 0.3 "$ftp2 start"
$ns at 0.45 "$exp3 start"
$ns at 0.6 "$telnet4 start"
$ns rtmodel-at 1.5 down $n(2) $n(4)
$ns rtmodel-at 3.0 up $n(2) $n(4)
$ns at 4.15 "$cbr1 stop"
$ns at 4.3 "$ftp2 stop" 
$ns at 4.45 "$exp3 stop"
$ns at 4.6 "$telnet4 stop"
$ns at 25.0 "finish"
$ns run 