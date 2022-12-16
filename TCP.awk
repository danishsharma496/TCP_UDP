BEGIN {
recvdSize = 0
transSize = 0 startTime = 400 stopTime = 0
}
{
event = $1
time = $3 send_id = $5 rec_id = $7 pkt_size = $11 flow_id = $17 type=$9
# Store start time
if (send_id == "0") { if (time < startTime) { startTime = time
}
if (event == "+") {
# Store transmitted packet's size #transSize += pkt_size transSize+=1
}
}
# Update total received packets' size and store packets arrival time if (event == "r" && rec_id == "4") {
if (time > stopTime) {
 stopTime = time
}
# Store received packet's size if (flow_id == "1") { #recvdSize += pkt_size recvdSize+=1
}
}
}
END {
printf("TCP throughput: %.2f packets/sec\n",recvdSize/stopTime) #printf("%i\t%i\t%.2f\t%.2f\t%.2f\n", transSize, recvdSize, startTime,
stopTime,recvdSize/stopTime) }
