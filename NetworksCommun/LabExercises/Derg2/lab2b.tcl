set ns [new Simulator]
$ns rtproto DV 
set nf [open lab2b.nam w]

$ns namtrace-all $nf
set f0 [open lab2b.tr w]

proc record {} {
global sink0 f0
set ns [Simulator instance]
# Ορισµός της χρονικής περιόδου που θα ξανακληθεί η διαδικασία
set time 0.1
# Καταγραφή των bytes
set bw0 [$sink0 set bytes_]
# Ορισμός του χρόνου της τρέχουσας καταγραφής
set now [$ns now]
# Υπολογισµός του bandwidth και καταγραφή αυτού στο αρχείο
puts $f0 "$now [expr $bw0/$time*8/1000000]"
# Κάνει την τιµή bytes_ 0
$sink0 set bytes_ 0
# Επαναπρογραµµατισµός της διαδικασίας
$ns at [expr $now+$time] "record"
}

proc finish {} {
 global ns nf f0
 $ns flush-trace
 close $nf
 close $f0
 exit 0
}
for {set i 0} {$i < 10} {incr i} {
 set n($i) [$ns node]
}
for {set i 0} {$i < 10} {incr i} {
 $ns duplex-link $n($i) $n([expr ($i+1)%10]) 1Mb 10ms DropTail
}
set udp0 [new Agent/UDP]
$ns attach-agent $n(0) $udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 1000
$cbr0 set interval_ 0.02
$cbr0 attach-agent $udp0
set sink0 [new Agent/LossMonitor]
$ns attach-agent $n(4) $sink0
$ns connect $udp0 $sink0

$ns at 0.0 "record"
$ns at 0.5 "$cbr0 start"
$ns rtmodel-at 1.5 down $n(2) $n(3)
$ns rtmodel-at 3.0 up $n(2) $n(3) 
$ns at 4.5 "$cbr0 stop"
$ns at 5.0 "finish"
$ns run