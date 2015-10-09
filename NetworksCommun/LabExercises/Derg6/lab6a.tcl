set opt(nam) "lab6a.nam" ;# Αρχείο NAM 
set opt(tr) "lab6a.tr" ;# Αρχείο trace
set opt(seed) 0 ;# Παράμετρος για τη γεννήτρια
 ;# τυχαίων αριθμών
set opt(starttraf) 0.20 ;# Έναρξη παραγωγής δεδομένων(sec)
set opt(stoptraf) 1.20 ;# Λήξη παραγωγής δεδομένων (sec)
set opt(stopsim) 2.40 ;# Διάρκεια προσομοίωσης (sec)
set opt(node) 20 ;# Αριθμός σταθμών στο LAN
set opt(qsize) 250 ;# Μέγεθος ουράς σε κάθε σταθμό
set opt(bw) 10000000 ;# Ρυθμός μετάδοσης (bps)
set opt(delay) 0.0000256 ;# Καθυστέρηση μετάδοσης (sec)
set opt(packetsize) 64 ;# Μέγεθος πακέτου (byte)
set opt(rate) [expr 3*$opt(bw)/$opt(node)] ;# Ρυθμός παραγωγής δεδομένων
 ;# κάθε σταθμού (bps)
### Παράμετροι του LAN
set opt(ll) LL
set opt(ifq) Queue/DropTail
set opt(mac) Mac/802_3
set opt(chan) Channel 


# Δημιουργία τοπολογίας δικτύου
proc create-topology {} {
 global ns opt
 global lan node
 set num $opt(node)
 # Δημιουργία σταθμών του LAN
 for {set i 0} {$i < $num} {incr i} {
 set node($i) [$ns node]
 lappend nodelist $node($i)
 }
 ### Δημιουργία του LAN
 set lan [$ns newLan $nodelist $opt(bw) $opt(delay) \-llType $opt(ll) -ifqType $opt(ifq) \ -macType $opt(mac) -chanType $opt(chan)]
}

# Δημιουργία κίνησης μεταξύ των σταθμών
proc create-connections {} {
 global ns opt
 global node udp sink cbr
 for {set i 1} {$i < $opt(node)} {incr i} {
 set udp($i) [new Agent/UDP]
 $udp($i) set packetSize_ $opt(packetsize)
 $ns attach-agent $node($i) $udp($i)
 set sink($i) [new Agent/Null]
 $ns attach-agent $node(0) $sink($i)
 $ns connect $udp($i) $sink($i)
 set cbr($i) [new Application/Traffic/CBR]
 $cbr($i) set rate_ $opt(rate)
 $cbr($i) set packetSize_ $opt(packetsize)
 $cbr($i) set random_ 1
 $cbr($i) attach-agent $udp($i)
 $ns at $opt(starttraf) "$cbr($i) start"
 $ns at $opt(stoptraf) "$cbr($i) stop"
 }
} 

# Δημιουργία αρχείου NAM
proc create-nam-trace {} { 
 global ns opt
 set namf [open $opt(nam) w]
 $ns namtrace-all $namf
 return $namf

} 


# Δημιουργία αρχείου trace
proc create-trace {} {
 global ns opt
 set trf [open $opt(tr) w]
 $ns trace-all $trf
 return $trf
}
# Διαδικασία τερματισμού
proc finish {} {
 global ns trf namf

 $ns flush-trace
 close $trf
 close $namf
 exit 0
}

set ns [new Simulator] 
set trf [create-trace]
set namf [create-nam-trace]
create-topology
create-connections
$ns at $opt(stopsim) "finish"
$ns run 




