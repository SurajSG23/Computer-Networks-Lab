set ns [new Simulator]

set tracefile [open name11.tr w]
$ns trace-all $tracefile
set namfile [open name11.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile 1500 1500

set topo [new Topography]
$topo load_flatgrid 1500 1500

$ns node-config -adhocRouting DSDV \
-llType LL \
-ifqType Queue/DropTail \
-ifqLen 20 \
-macType Mac \
-phyType Phy/WirelessPhy \
-channelType Channel/WirelessChannel \
-propType Propagation/TwoRayGround \
-antType Antenna/OmniAntenna \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON

proc finish {} {
global ns tracefile namfile
$ns flush-trace
close $tracefile
close $namfile

exec nam name11.nam &
exec echo "Number of packets dropped is:" & 
exec grep -c "^D" name11.tr &
exit 0
}

create-god 6

set n0 [$ns node]
$n0 set X_ 600
$n0 set Y_ 500
$n0 set Z_ 0.0
$ns initial_node_pos $n0 20
set n1 [$ns node]
$n1 set X_ 450
$n1 set Y_ 350
$n1 set Z_ 0.0
$ns initial_node_pos $n1 20
set n2 [$ns node]
$n2 set X_ 750
$n2 set Y_ 350
$n2 set Z_ 0.0
$ns initial_node_pos $n2 20
set n3 [$ns node]
$n3 set X_ 300
$n3 set Y_ 200
$n3 set Z_ 0.0
$ns initial_node_pos $n3 20
set n4 [$ns node]
$n4 set X_ 600
$n4 set Y_ 200
$n4 set Z_ 0.0
$ns initial_node_pos $n4 20
set n5 [$ns node]
$n5 set X_ 900
$n5 set Y_ 200
$n5 set Z_ 0.0
$ns initial_node_pos $n5 20

set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set null0 [new Agent/Null]
$ns attach-agent $n4 $null0
$ns connect $udp0 $null0
$udp0 set packetSize_ 1500

set tcp0 [new Agent/TCP]
$ns attach-agent $n3 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n5 $sink0
$ns connect $tcp0 $sink0

set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 1000
$cbr0 set rate_ 1Mb
$cbr0 set random_ null
$cbr0 attach-agent $udp0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0


$ns at 1.0 "$cbr0 start"
$ns at 2.0 "$ftp0 start"
$ns at 180.0 "$ftp0 stop"
$ns at 200.0 "$cbr0 stop"
$ns at 200.0 "finish"
$ns at 70 "$n4 set dest 100 60 20"
$ns at 100 "$n4 set dest 700 300 20"
$ns at 150 "$n4 set dest 900 200 20"
$ns run

# ns 04.tcl

# awk -f 11b.awk 11b.tr
