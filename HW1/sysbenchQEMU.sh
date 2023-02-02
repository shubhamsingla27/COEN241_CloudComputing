outputFile=$1
sync; sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
touch $outputFile
> $outputFile
runCPU(){
	number=$1
	shift
	for i in {1..5}; do
		sysbench --test=cpu --cpu-max-prime=$number run >> $outputFile
		echo "-----------------------------------------------" >> $outputFile
	done
}

runFileIO(){
	size=$1
	mode=$2
	shift
	for i in {1..5}; do
		sysbench --num-threads=16 --test=fileio --file-total-size=$size --file-test-mode=rndrw prepare
		sysbench --num-threads=16 --test=fileio --file-total-size=$size --file-test-mode=rndrw run >> $outputFile
		sysbench --num-threads=16 --test=fileio --file-total-size=$size --file-test-mode=rndrw cleanup
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
runCPU 10000
echo "Prime numbers limit: 20000" >> $outputFile
runCPU 20000
echo "Prime numbers limit: 30000" >> $outputFile
runCPU 30000

echo "<<<=====================================================>>>" >> $outputFile

echo "<<===File IO Tests===>>" >> $outputFile
echo "###### 2G 128Files 16Threads" >> $outputFile
runFileIO 2G
echo "###### 4G 128Files 16Threads" >> $outputFile
runFileIO 4G

