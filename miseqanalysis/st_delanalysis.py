#!/usr/bin/python
import glob
import os
import subprocess
import re

#amplicon = str('CTTAATGTTCATCTGGCTGTTCTTGTGTTTGTGTTCTTCAGGATCTCTCTGGCTCTATTGACGACCTCCCCACGGGAACAGAAGCAGGTCTCAGTTCAGCCGTCAGCGCTTCAGGCTCTACCAGCAGTCAAGGCGAGCAGAGTAACCCCGCTCAGTCCCCCTTCTCCCCCCACGCCTCACCCAGAGTTCCCAGCATGCGCAGCGGACCCTCGCCCTCCCCAGTTGGATCTCCTGTGGGTTCCAGCCAGTCCCGATCTGGGCCCATATCACCTGCCAGTGGGCCAGGTAAAGGATTATGTGCGAGATGTAATTTTTAAAGGAT')
#fwdpiece = str('GCTGTTCTTGTGTTTGTGTTCTT')
#rvspiece = str('GGGCCAGGTAAAGGATTATG')
#rvspiecervs = str('CATAATCCTTTACCTGGCCC')

amplicons = []
#amplicons.append(["arid1b", 'CTTAATGTTCATCTGGCTGTTCTTGTGTTTGTGTTCTTCAGGATCTCTCTGGCTCTATTGACGACCTCCCCACGGGAACAGAAGCAGGTCTCAGTTCAGCCGTCAGCGCTTCAGGCTCTACCAGCAGTCAAGGCGAGCAGAGTAACCCCGCTCAGTCCCCCTTCTCCCCCCACGCCTCACCCAGAGTTCCCAGCATGCGCAGCGGACCCTCGCCCTCCCCAGTTGGATCTCCTGTGGGTTCCAGCCAGTCCCGATCTGGGCCCATATCACCTGCCAGTGGGCCAGGTAAAGGATTATGTGCGAGATGTAATTTTTAAAGGAT', 'GCTGTTCTTGTGTTTGTGTTCTT', 'CATAATCCTTTACCTGGCCC'])
for miseq in glob.glob('znf*.csv'):
	amps = open(miseq, 'r')
	for line in amps.readlines():
		amplicons.append(str.upper(line.strip()).split(','))

print(amplicons)


for gene in amplicons:
	sumfile = open(gene[0] + ".summary", 'w')
	wtfile = open(gene[0] + ".fa", 'w')
	wtfile.write(">" + gene[0] + "_wt" + "\n" + gene[1])
	wtfile.close()
	barcodegrid = []
	mutation_list = []
	allcount = 0
	for fastq0 in glob.glob('*R1*fastq'):
		fastqf = open(fastq0, 'r')
		for line in fastqf.readlines():
			if gene[2] in line: # [2] is fwd chunk
				allcount = allcount + 1
	for fastq in glob.glob('*R1*fastq'):
		fullreads = []
		fastqf = open(fastq, 'r')
		count = 0
		for line in fastqf.readlines():
			if gene[2] in line: # [2] is fwd chunk
				count = count + 1
				fullreads.append(line.strip())
		#print(fastq, count)
		#miseqDec2020_S28_L001_R1_001.fastq
		barcodeid = fastq.split("_")[-4][1:]
		barcodegrid.append((barcodeid, count)) # This will have to change if naming convention ever changes (data from another company, for example)
		# only do on the barcodes that are not noise (anything that is <1% of largest count is not included)
		if(0.1 > (100 * (float(count) / float(allcount)))):
			continue
		fullreadsset = {}
		for x in fullreads:
			if x not in fullreadsset.keys():
				fullreadsset[x] = 1
			else:
				fullreadsset[x] = fullreadsset[x] + 1
		# ignore reads that are very small percents of the total (1 read should be ignored, maybe up to 3 or 5)
		fullreadsset = {k: v for k,v in sorted(fullreadsset.items(), key=lambda item: item[1], reverse = True)}
		#print(fullreadsset.values())
		count2 = 0
		for uniqueread in fullreadsset.keys():
			outfile = open("temp.fa", 'w')
			#print(fullreadsset[uniqueread])
			#print(float(fullreadsset[uniqueread]), float(count))
			#print(str(float(fullreadsset[uniqueread]) / float(count)))
			# ignore those with very low percent of the total reads for this barcode
			if(0.5 > (100 * (float(fullreadsset[uniqueread]) / float(count)))):
				continue
			outfile.write(">" + gene[0] + "_" + str(fullreadsset[uniqueread])+ "_" + str(100 * (float(fullreadsset[uniqueread]) / float(count))) + "\n" + uniqueread)
			outfile.close()
			# call needle
			# needle -outfile test.out -gapopen 50 -gapextend 0 -datafile EDNAFULL -filter <(echo -e ">a\nCAAAAAAAAATTAAAAAAAAAAAAAACCCCCCCTTCCA") -bsequence "test.fa"
			#needle = "needle -outfile test.out -gapopen 50 -gapextend 0 -datafile EDNAFULL -filter <(echo -e \">a\\" + "n" + uniqueread + "\") -bsequence amplicon.fa"
			needle = "/data/project/thymelab/EMBOSS-6.6.0/emboss/needle -outfile temp_" + str(count2) + ".align -gapopen 50 -gapextend 0 -datafile EDNAFULL -asequence temp.fa -bsequence " + gene[0] + ".fa"
			count2 = count2 + 1
			#print(str(needle))
			os.system(str(needle))
			#subprocess.run(str(needle), shell=True)
			#os.system("needle -outfile test.out -gapopen 50 -gapextend 0 -datafile EDNAFULL -asequence " + uniqueread + " -bsequence " + amplicon)
		temps = sorted(glob.glob("temp_*align"), key = lambda x:int(x.split("_")[1].split(".")[0]))
		#print(temps)
		for t in temps:
			allmuts = []
			t2 = open(t, 'r')
			wtseq = ""
			mutseq = ""
			name = ""
			for line in t2.readlines():
				if line.startswith(gene[0]):
					wt = line.split()[0].strip().split("_")[1]
					loc = line.split()[1].strip()
					seq = line.split()[2].strip()
					if wt == "wt":
						wtseq = wtseq + seq
					else:
						name = str(barcodeid) + "-" + line.split()[0].strip()
						mutseq = mutseq + seq
			#print(wtseq.strip("-"))
			#print(wtseq)
			#print(mutseq)
			#print(mutseq.strip("-"))
			wtdelsplit = re.split("-+", wtseq.strip("-"))
			#wtdelsplit = wtseq.strip("-").split("-")
			wtdelindlist = []
			for chunk in wtdelsplit:
				#wtdelindlist.append(wtseq.strip("-").find(chunk))
				wtdelindlist.append(re.search(chunk, wtseq).span())
			#mutdelsplit = mutseq.strip("-").split("-")
			mutdelsplit = re.split("-+", mutseq.strip("-"))
			mutdelindlist = []
			#print(mutdelsplit)
			for chunk2 in mutdelsplit:
				#mutdelindlist.append(len(chunk2))
				#mutdelindlist.append(mutseq.find(chunk2))
				#mutdelindlist.append(mutseq.strip("-").find(chunk2))
				#print (mutseq.find(chunk2))
				mutdelindlist.append(re.search(chunk2, mutseq).span())
				#print(mutdelindlist)
			for m in range(0, len(mutdelindlist)-1):
				#print(mutdelindlist[m])
				#if len(mutdelindlist) > 3:
					#print(mutdelindlist[m], mutdelindlist[m + 3])
				allmuts.append(str((mutdelindlist[m+1][0] - mutdelindlist[m][1])) + "D")
			for w in range(0, len(wtdelindlist)-1):
				allmuts.append(str((wtdelindlist[w+1][0] - wtdelindlist[w][1])) + "I")
			#for w in range(0, len(wtdelindlist)-2, 2):
			#	if len(wtdelindlist) > 3:
			#		allmuts.append(str((wtdelindlist[w + 3] - wtdelindlist[w])) + "I")
			#print(wtdelindlist)
			#print(wtdelsplit)
			print(allmuts)
			#print(mutdelsplit)
			if wtseq.strip("-") != gene[1]:
				print("ERROR, for some reason your WT sequence does not equal the original wt and there are also no insertions in the alignment")
			mutation_list.append((name, allmuts))
		with open(gene[0] + "_" + str(barcodeid) + ".align", "wb") as outfile:
			for f in temps:
				with open(f, "rb") as infile:
					outfile.write(infile.read())
		for f in temps:
			os.system("rm " + f)
		os.system("rm temp.fa")
	barcodegrid = sorted(barcodegrid, key=lambda x: int(x[0]))
	barcodegrid2 = []
	for z in barcodegrid:
		barcodegrid2.append(z[1])
	for i in range(0, len(barcodegrid2), 12):
		sumfile.write(str(barcodegrid2[i:i + 12])+ "\n")
	mutation_list = sorted(mutation_list, key = lambda x:int(x[0].split("-")[0]))
	for y in range(0, len(mutation_list)):
		sumfile.write(mutation_list[y][0] + ": ")
		sumfile.write(str(mutation_list[y][1]) + "\n")
