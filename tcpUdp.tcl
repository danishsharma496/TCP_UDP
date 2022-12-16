set ns [new Simulator]

$ns color 1 Blue
$ns color 2 Red

set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {} { 
    global ns nf
    $ns flush-trace
    close $nf
    exec nam out.nam &
    exit 0 }

set n(0) [$ns node]
set n(1) [$ns node]
set n(2) [$ns node]
set n(3) [$ns node]
set n(4) [$ns node]
set n(5) [$ns node]

$ns duplex-link $n(0) $n(2) 2Mb 10ms DropTail
$ns duplex-link $n(1) $n(2) 2Mb 10ms DropTail
$ns simplex-link $n(2) $n(3) 0.3Mb 100ms DropTail
$ns simplex-link $n(3) $n(2) 0.3Mb 100ms DropTail
$ns duplex-link $n(3) $n(4) 0.5Mb 40ms DropTail
$ns duplex-link $n(3) $n(5) 0.5Mb 40ms DropTail


$ns queue-limit $n(2) $n(3) 10

$ns duplex-link-op $n(0) $n(2) orient right
$ns duplex-link-op $n(1) $n(2) orient down
$ns simplex-link-op $n(2) $n(3) orient right 
$ns simplex-link-op $n(3) $n(2) orient left 
$ns duplex-link-op $n(3) $n(4) orient down 
$ns duplex-link-op $n(3) $n(5) orient right


set tcp [new Agent/TCP]
$tcp set packetSize_ 1000 
$ns attach-agent $n(0) 
$tcp set sink [new Agent/TCPSink] 
$ns attach-agent 
$n(4) $sink $ns connect $tcp $sink
$tcp set fid_ 1


set udp [new Agent/UDP] 
$ns attach-agent $n(1) $udp 
set null [new Agent/Null]
$ns attach-agent $n(5) $null 
$ns connect $udp $null $udp set fid_ 2


set ftp1 [new Application/FTP] 
$ftp1 attach-agent $tcp
$ftp1 set type_ FTP
$tcp set packet_size_ 1000 
$ftp1 set rate_ 1mb
$ftp1 set random_ false

set cbr2 [new Application/Traffic/CBR] 
$cbr2 attach-agent $udp
$cbr2 set type_ CBR
$cbr2 set packet_size_ 1000
$cbr2 set rate_ 1mb 
$cbr2 set random_ false

$ns at 0.0 "$ftp1 start" 
$ns at 0.0 "$cbr2 start" 
$ns at 5.0 "$ftp1 stop" 
$ns at 5.0 "$cbr2 stop"

$ns at 4.9 "$ns detach-agent $n(0) $tcp ; $ns detach-agent $n(4) $sink ; $ns detach-agent $n(1) $udp ; $ns detach-agent $n(5) $null"
$ns at 5.0 "finish"
$ns run