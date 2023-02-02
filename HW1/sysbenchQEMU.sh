outputFile=$1
sync; sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
touch $outputFile
> $outputFile

fileIoTests(){
	size=$1
	shift
	for i in {1..5}; 
	do
		sysbench --threads=16 --test=fileio --file-total-size=$size --file-test-mode=rndrw prepare
		sysbench --threads=16 --test=fileio --file-total-size=$size --file-test-mode=rndrw run >> $outputFile
		sysbench --threads=16 --test=fileio --file-total-size=$size --file-test-mode=rndrw cleanup
		sync; sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
		echo "-----------------------------------------------" >> $outputFile
	done
}



echo "CPU Configuration" >> $outputFile
sudo lscpu | tee >(grep 'CPU(s):' >> $outputFile) >(grep 'Socket' >> $outputFile) >(grep 'Thread' >> $outputFile)
sleep 3
echo "Memory" >> $outputFile
sudo lshw -c memory | grep capacity >> $outputFile
echo "<<===CPU Tests===>>" >> $outputFile
echo "Prime numbers limit: 10000" >> $outputFile
cpuTests 10000
echo "Prime numbers limit: 20000" >> $outputFile
cpuTests 20000
echo "Prime numbers limit: 30000" >> $outputFile
cpuTests 30000

echo "<<<=====================================================>>>" >> $outputFile

echo "<<===File IO Tests===>>" >> $outputFile
echo "###### 1G 128Files 16Threads" >> $outputFile
fileIoTests 1G
echo "###### 2G 128Files 16Threads" >> $outputFile
fileIoTests 2G


