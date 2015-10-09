# Παράμετροι ασύρματου δικτύου
set opt(chan) Channel/WirelessChannel
set opt(prop) Propagation/TwoRayGround
set opt(ant) Antenna/OmniAntenna
set opt(ll) LL
set opt(ifq) Queue/DropTail/PriQueue
set opt(ifqlen) 25
set opt(netif) Phy/WirelessPhy
set opt(mac) Mac/802_11
set opt(rp) AODV
set opt(nn) 4
set opt(gridx) 600
set opt(gridy) 400
$opt(mac) set basicRate_ 1Mb
$opt(mac) set dataRate_ 11Mb



set ns [new Simulator]

$ns color 1 blue
$ns color 2 red
$ns color 3 green
$ns color 4 yellow

$ns use-newtrace
set tf [open lab9.tr w]
$ns trace-all $tf
set nf [open lab9.nam w]
$ns namtrace-all-wireless $nf $opt(gridx) $opt(gridy)
proc finish {} {
 global ns tf nf
 $ns flush-trace
 close $tf
 close $nf
 exit 0
}

set topo [new Topography]
$topo load_flatgrid $opt(gridx) $opt(gridy)
create-god $opt(nn)
$ns node-config -adhocRouting $opt(rp) \
-llType $opt(ll) \
-macType $opt(mac) \
-ifqType $opt(ifq) \
-ifqLen $opt(ifqlen) \
-antType $opt(ant) \
-propType $opt(prop) \
-phyType $opt(netif) \
-channel [new $opt(chan)] \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON \
-macTrace OFF \
-movementTrace OFF

# Τοποθέτηση κόμβων στην τοπολογία
set n(0) [$ns node]
$n(0) random-motion 0
$n(0) set X_ 300.0
$n(0) set Y_ 200.0
$n(0) set Z_ 0.0
set n(1) [$ns node]
$n(1) random-motion 0
$n(1) set X_ 100.0
$n(1) set Y_ 200.0
$n(1) set Z_ 0.0
set n(2) [$ns node]
$n(2) random-motion 0
$n(2) set X_ 300.0
$n(2) set Y_ 0.0
$n(2) set Z_ 0.0
set n(3) [$ns node]
$n(3) random-motion 0
$n(3) set X_ 500.0
$n(3) set Y_ 200.0
$n(3) set Z_ 0.0
set n(4) [$ns node]
$n(4) random-motion 0
$n(4) set X_ 300.0
$n(4) set Y_ 400.0
$n(4) set Z_ 0.0

for {set i 0} {$i < $opt(nn) } {incr i} {
set node_x [$n($i) set X_]
set node_y [$n($i) set Y_]
puts "node($i) at position ($node_x, $node_y)"
}
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
set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $udp3
$cbr3 set packetSize_ 1500
$cbr3 set rate_ 1.2mb
$cbr1 set random_ off
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

for {set i 0} {$i < $opt(nn) } {incr i} {
$ns initial_node_pos $n($i) 20 }

# Events
$ns at 0.15 "$cbr1 start"
$ns at 0.3 "$ftp2 start"
$ns at 0.45 "$cbr3 start"
$ns at 0.6 "$telnet4 start"
$ns at 4.15 "$cbr1 stop"
$ns at 4.3 "$ftp2 stop" 
$ns at 4.45 "$cbr3 stop"
$ns at 4.6 "$telnet4 stop"
$ns at 25.0 "finish"
$ns run 
