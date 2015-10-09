set ns [new Simulator]
set nf [open lab1b.nam w]
$ns namtrace-all $nf
set xf [open lab1.tr w]
proc record {} {
 global sink xf
 set ns [Simulator instance]
 set time 0.15
 set bw [$sink set bytes_]
 set now [$ns now]
 puts $xf "$now [expr ((($bw/$time)*8)/1000000)]"
 $sink set bytes_ 0
 $ns at [expr $now+$time] "record"
}
proc finish {} {
 global ns nf xf
 $ns flush-trace
 close $nf
 close $xf
 exit 0
}
set n0 [$ns node]
set n1 [$ns node]
$ns duplex-link $n0 $n1 2Mb 10ms DropTail
set agent0 [new Agent/UDP]
$agent0 set packetSize_ 1000
$ns attach-agent $n0 $agent0
set traffic0 [new Application/Traffic/CBR]
$traffic0 set packetSize_ 1000
$traffic0 set interval_ 0.005
$traffic0 attach-agent $agent0
set sink [new Agent/LossMonitor]
$ns attach-agent $n1 $sink
$ns connect $agent0 $sink 
$ns at 0.0 "record"
$ns at 1.0 "$traffic0 start"
$ns at 4.0 "$traffic0 stop"
$ns at 5.0 "finish"
$ns run