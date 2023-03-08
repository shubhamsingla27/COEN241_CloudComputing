Shubham Singla
COEN 241: Cloud Computing
HW3 Mininet & OpenFlow

----> Task 1: Defining the custom topology <----

        root@c426d94c909b:~# mn --custom binary_tree.py --topo binary_tree
        *** Error setting resource limits. Mininet's performance may be affected.
        *** Creating network
        *** Adding controller
        *** Adding hosts:
        h1 h2 h3 h4 h5 h6 h7 h8
        *** Adding switches:
        s1 s2 s3 s4 s5 s6 s7
        *** Adding links:
        (s1, s2) (s1, s5) (s2, s3) (s2, s4) (s3, h1) (s3, h2) (s4, h3) (s4, h4) (s5, s6) (s5, s7) (s6, h5) (s6, h6) (s7, h7) (s7, h8)
        *** Configuring hosts
        h1 h2 h3 h4 h5 h6 h7 h8
        *** Starting controller
        c0
        *** Starting 7 switches
        s1 s2 s3 s4 s5 s6 s7 ...
        *** Starting CLI:

        mininet> h1 ping h8
        PING 10.0.0.8 (10.0.0.8) 56(84) bytes of data.
        64 bytes from 10.0.0.8: icmp_seq=1 ttl=64 time=15.1 ms
        64 bytes from 10.0.0.8: icmp_seq=2 ttl=64 time=1.43 ms
        64 bytes from 10.0.0.8: icmp_seq=3 ttl=64 time=0.128 ms
        64 bytes from 10.0.0.8: icmp_seq=4 ttl=64 time=0.118 ms
        64 bytes from 10.0.0.8: icmp_seq=5 ttl=64 time=0.206 ms
        64 bytes from 10.0.0.8: icmp_seq=6 ttl=64 time=0.091 ms
        ^C
        --- 10.0.0.8 ping statistics ---
        6 packets transmitted, 6 received, 0% packet loss, time 5082ms
        rtt min/avg/max/mdev = 0.091/2.847/15.111/5.505 ms


        Ques 1. What is the output of “nodes” and “net”
        Ans:
                mininet> nodes
                available nodes are:
                c0 h1 h2 h3 h4 h5 h6 h7 h8 s1 s2 s3 s4 s5 s6 s7

                mininet> net
                h1 h1-eth0:s3-eth2
                h2 h2-eth0:s3-eth3
                h3 h3-eth0:s4-eth2
                h4 h4-eth0:s4-eth3
                h5 h5-eth0:s6-eth2
                h6 h6-eth0:s6-eth3
                h7 h7-eth0:s7-eth2
                h8 h8-eth0:s7-eth3
                s1 lo:  s1-eth1:s2-eth1 s1-eth2:s5-eth1
                s2 lo:  s2-eth1:s1-eth1 s2-eth2:s3-eth1 s2-eth3:s4-eth1
                s3 lo:  s3-eth1:s2-eth2 s3-eth2:h1-eth0 s3-eth3:h2-eth0
                s4 lo:  s4-eth1:s2-eth3 s4-eth2:h3-eth0 s4-eth3:h4-eth0
                s5 lo:  s5-eth1:s1-eth2 s5-eth2:s6-eth1 s5-eth3:s7-eth1
                s6 lo:  s6-eth1:s5-eth2 s6-eth2:h5-eth0 s6-eth3:h6-eth0
                s7 lo:  s7-eth1:s5-eth3 s7-eth2:h7-eth0 s7-eth3:h8-eth0
                c0

        Ques 2. What is the output of “h7 ifconfig”
        Ans:
                mininet> h7 ifconfig
                h7-eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
                        inet 10.0.0.7  netmask 255.0.0.0  broadcast 10.255.255.255
                        inet6 fe80::e88e:82ff:fe2f:22d6  prefixlen 64  scopeid 0x20<link>
                        ether ea:8e:82:2f:22:d6  txqueuelen 1000  (Ethernet)
                        RX packets 88  bytes 6592 (6.5 KB)
                        RX errors 0  dropped 0  overruns 0  frame 0
                        TX packets 14  bytes 1076 (1.0 KB)
                        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

                lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
                        inet 127.0.0.1  netmask 255.0.0.0
                        inet6 ::1  prefixlen 128  scopeid 0x10<host>
                        loop  txqueuelen 1000  (Local Loopback)
                        RX packets 0  bytes 0 (0.0 B)
                        RX errors 0  dropped 0  overruns 0  frame 0
                        TX packets 0  bytes 0 (0.0 B)
                        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0



----> Task 2: Analyze the “of_tutorial’ controller <----

        Ques 1. Draw the function call graph of this controller. For example, once a packet comes to the
        controller, which function is the first to be called, which one is the second, and so forth?
        Ans:
                (packet comes) -> _handle_PacketIn() -> act_like_hub() -> resend_packet() -> connection.send()(fowrard the msg to port)

        Ques 2. Have h1 ping h2, and h1 ping h8 for 100 times (e.g., h1 ping -c100 p2).
        Ans:
                mininet> h1 ping -c100 h2
                --- 10.0.0.2 ping statistics ---
                100 packets transmitted, 100 received, 0% packet loss, time 99373ms
                rtt min/avg/max/mdev = 1.415/3.096/50.082/5.523 ms

                mininet> h1 ping -c100 h8
                --- 10.0.0.8 ping statistics ---
                100 packets transmitted, 100 received, 0% packet loss, time 99353ms
                rtt min/avg/max/mdev = 4.284/8.155/47.901/5.985 ms

                a. How long does it take (on average) to ping for each case?
                Ans: Average time to ping h2 from h1 is: 3.096 ms
                     Average time to ping h8 from h1 is: 8.155 ms

                b. What is the minimum and maximum ping you have observed?
                Ans: To ping h2 from h1:
                        Minimum: 1.415 ms
                        Maximum: 50.082 ms

                     To ping h8 from h1:
                        Minimum: 4.284 ms
                        Maximum: 47.901 ms

                c. What is the difference, and why?
                Ans: h1 pinging h2 is on average faster than that of pinging h8. It's because of the number of hops that a packet has to take to reach h8 
                is significantly more than to reach h2. To be exact h1 to h2 (h1->s3->h2) have 2 hops and also only one switch 
                whereas h1 to h8 (h1->s3->s2->s1->s5->s7->h8) have 6 hops and multiple switches which leads to additional congestion. 
                So on average there is around 5.059 ms difference in both the pings.

        Ques 3. Run “iperf h1 h2” and “iperf h1 h8”
        Ans: 
                mininet> iperf h1 h2
                *** Iperf: testing TCP bandwidth between h1 and h2
                *** Results: ['9.28 Mbits/sec', '10.8 Mbits/sec']

                mininet> iperf h1 h8
                *** Iperf: testing TCP bandwidth between h1 and h8
                *** Results: ['2.71 Mbits/sec', '3.13 Mbits/sec']

                a. What is “iperf” used for?
                Ans: "iperf" is a tool used to test network performance and bandwidth. It generally create some data stream to measure the 
                throughput between any two nodes. It also helps in tuning the network for better performance as well.

                b. What is the throughput for each case?
                Ans: iperf h1 h2:
                        Output: Results: ['9.28 Mbits/sec', '10.8 Mbits/sec']
                        Average: 10.04 Mbits/sec
                     iperf h1 h8:
                        Output: Results: ['2.71 Mbits/sec', '3.13 Mbits/sec']
                        Average: 2.92 Mbits/sec

                c. What is the difference, and explain the reasons for the difference.
                Ans: The difference between both on average is around 7.12 Mbits/sec. This difference could be because of the custom topology,
                as there is only two hop between h1 and h2 (h1->s3->h2) whereas there are 6 hops between h1 and h8 (h1->s3->s2->s1->s5->s7->h8). 
                Also the more the number of switches there are in a network, the more congested the network will be so comparing h1 and h2; h1 and h8, 
                former has only one switch as compared to 5 for latter, ultimately leading to a congested network.

        Ques 4. Which of the switches observe traffic? Please describe your way for observing such
                traffic on switches (e.g., adding some functions in the “of_tutorial” controller). 
        Ans:
                Ideally switches s1, s2, s3, s5, s7 should observe most traffic as these are the switches that are in the path from h1 to h2 and h1 to h8. However the of_totorial is only acting as a hub, i.e., sending packets to all the ports essentially flooding the whole network, suggests that all the switches are seeing a substantial amount of traffic. This can be confirmed by adding logging functionality in act_like_hub function.



----> Task 3: MAC Learning Controller <----

        Ques 1. Describe how the above code works, such as how the "MAC to Port" map is established. 
                You could use a ‘ping’ example to describe the establishment process (e.g., h1 ping h2).
        Ans: 
                In the above code, every time the act_like_switch function gets a packet with unknown source i.e., it's not stored in the mac_to_port dictionary, then the function will store on which port the current packet source is located essentially learning on which port each source is attached. Afterwards, it will look at the destination address of the packet and if that is already stored in the dictionary, the resend_packet function gets called immediately with the exact destination port, otherwise, if the destination is not known, the resend_packet will flood all the port destinations except the source port.
                Example: h1 ping h2, if initially the dictionary is empty, then h1's port will be added to dictionary and all the other ports will be flooded as h2's port is not present in the dictionary. Now if h2 pings h1, h2's port will be added in the dictionary and h1's port which is already in the dictionary, will directly be called using resend_packet function instead of flooding all the ports.

        Ques 2. (Comment out all prints before doing this experiment) Have h1 ping h2, and h1 ping
                h8 for 100 times (e.g., h1 ping -c100 p2).
        Ans:
                mininet> h1 ping -c100 h2
                --- 10.0.0.2 ping statistics ---
                100 packets transmitted, 100 received, 0% packet loss, time 99356ms
                rtt min/avg/max/mdev = 1.413/3.665/10.132/1.031 ms

                mininet> h1 ping -c100 h8
                --- 10.0.0.8 ping statistics ---
                100 packets transmitted, 100 received, 0% packet loss, time 99281ms
                rtt min/avg/max/mdev = 4.975/10.200/23.206/3.054 ms
                
                a. How long does it take (on average) to ping for each case?
                Ans: Average time to ping h2 from h1 is: 3.665 ms
                     Average time to ping h8 from h1 is: 10.200 ms

                b. What is the minimum and maximum ping you have observed?
                Ans: To ping h2 from h1:
                        Minimum: 1.413 ms
                        Maximum: 10.132 ms

                     To ping h8 from h1:
                        Minimum: 4.975 ms
                        Maximum: 23.206 ms

                c. Any difference from Task 2 and why do you think there is a change if there is?
                Ans: On average there is no significant change observed between both the tasks. There's a very slight increase in the average ping times in task 3, which is opposite of what I was expecting. Maybe its because of the small test sample and only the single round that this test is performed. Although the results might be true because when initially h1 pings h2, h1's port will be added to the dictionary but to find the destination h2 every other port will be flooded and same for the h1 pings h8, some time will be save as h1 is already in the dict but still every port will need to be flooded to find the destination. Essentially leading to same results as Task 2. 

        Ques 3. Run “iperf h1 h2” and “iperf h1 h8”.
        Ans:
                mininet> iperf h1 h2
                *** Iperf: testing TCP bandwidth between h1 and h2
                .*** Results: ['40.7 Mbits/sec', '43.8 Mbits/sec']

                mininet> iperf h1 h8
                *** Iperf: testing TCP bandwidth between h1 and h8
                *** Results: ['3.80 Mbits/sec', '4.47 Mbits/sec']
                
                a. What is the throughput for each case?
                Ans: iperf h1 h2:
                        Output: Results: ['40.7 Mbits/sec', '43.8 Mbits/sec']
                        Average: 42.25 Mbits/sec
                     iperf h1 h8:
                        Output: Results: ['3.80 Mbits/sec', '4.47 Mbits/sec']
                        Average: 4.135 Mbits/sec

                b. What is the difference from Task 2 and why do you think there is a change if there is?
                Ans: There is a huge jump in the throughput in case of h1 and h2 and a slight increase in case of h1 and h8. It's mostly because of the port mapping, that made the switches smarter essentially reducing congestion in the network and increasing throughput. Although in case of h1 and h8, there are still multiple switch to switch hops which might have addition complexity associated with them as compare to switch to host.