set ns [new Simulator]
set nf [open lab4.nam w]
$ns namtrace-all $nf
set trf [open lab4.tr w]
$ns trace-all $trf

proc finish {} {
    global ns nf trf
    $ns flush-trace
    close $nf
    close $trf
    exit 0
}
for {set i 0} {$i < 4} {incr i} {
    set n($i) [$ns node]
}
$ns at 0.0 "$n(0) label GBN_sender"
$ns at 0.0 "$n(3) label GBN_receiver"
$ns at 0.0 "$n(1) label SW_sender"
$ns at 0.0 "$n(2) label SW_receiver"
$ns duplex-link $n(0) $n(3) 3Mb 96ms DropTail
for {set i 0} {$i < 3} {incr i} {
    $ns duplex-link $n($i) $n([expr ($i+1)%4]) 3Mb 48ms DropTail
}
for {set i 0} {$i < 4} {incr i} {
    $ns queue-limit $n($i) $n([expr ($i+1)%4]) 150
    $ns queue-limit $n([expr ($i+1)%4]) $n($i) 150
}
$ns duplex-link-op $n(0) $n(1) orient right
$ns duplex-link-op $n(1) $n(2) orient down
$ns duplex-link-op $n(2) $n(3) orient left
$ns duplex-link-op $n(3) $n(0) orient up

$ns color 0 blue
$ns color 1 orange

set tcp0 [new Agent/TCP/Reno]
$tcp0 set packetSize_ 960
$tcp0 set windows_ 37
$tcp0 set syn_ false
$tcp0 set windowInit_ 37

$tcp0 set fid_ 0
$ns attach-agent $n(0) $tcp0

set sink0  [new Agent/TCPSink]
$ns attach-agent $n(3) $sink0
$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

set tcp1 [new Agent/TCP/Reno]
$tcp1 set packetSize_ 960
$tcp1 set window_ 1
$tcp1 set syn_ false