#!/bin/bash
echo "Starting job on " `date` #Date/time of start of job
echo "Running on: `uname -a`" #Condor job is running on this node
echo "System software: `cat /etc/redhat-release`" #Operating System on that node
source /cvmfs/cms.cern.ch/cmsset_default.sh  ## if a bash script, use .sh instead of .csh
export SCRAM_ARCH slc6_amd64_gcc530
eval `scramv1 project CMSSW CMSSW_10_2_18`
cd CMSSW_10_2_18/src/
echo "print pwd: "$PWD
eval `scramv1 runtime -sh` # cmsenv is an alias not on the workers
#source /cvmfs/sft.cern.ch/lcg/releases/LCG_87/gcc/4.9.3/x86_64-slc6/setup.sh
#source /cvmfs/sft.cern.ch/lcg/releases/LCG_87/Python/2.7.10/x86_64-slc6-gcc49-opt/Python-env.sh
mkdir Local
wget https://lhapdf.hepforge.org/downloads/LHAPDF-6.2.0.tar.gz -O- | tar xz      #add desired lhapdf version
cd LHAPDF-6.2.0
./configure --prefix=$PWD/../Local
make -j2 && make install
cd ..
#export PATH=$PWD/local/bin:$PATH
#export LD_LIBRARY_PATH=$PWD/local/lib:$LD_LIBRARY_PATH
#export PYTHONPATH=$PWD/local/lib64/python2.6/site-packages:$PYTHONPATH
#lhapdf list
ls -lah
#eval `scramv1 runtime -sh` # cmsenv is an alias not on the workers
git clone https://github.com/vbfnlo/vbfnlo.git
cd vbfnlo/
autoreconf -vi
echo "==============Copying Files to src directory============="
cd src/
xrdcp -f  root://cmseos.fnal.gov//store/user/asahmed/cuts.dat .		# Keep your card somwhere on eos to copy 
xrdcp  -f root://cmseos.fnal.gov//store/user/asahmed/vbfnlo.dat .
xrdcp  -f root://cmseos.fnal.gov//store/user/asahmed/anomV.dat .
xrdcp  -f root://cmseos.fnal.gov//store/user/asahmed/anom_HVV.dat .
echo "Generating random.dat file"
echo "SEED = $2" > random.dat
echo "=== Display random.dat file"
cat random.dat
echo "=== END display random.dat"
cat vbfnlo.dat
cd ..
echo "==============Before Config following files:=================="
echo
pwd
ls -lah
#./configure --with-root=/cvmfs/cms.cern.ch/slc6_amd64_gcc530/lcg/root/6.08.07/ --prefix=$PWD --with-LHAPDF=$PWD/../Local/
./configure --prefix=$PWD --with-LHAPDF=$PWD/../Local
echo "After config following files:"
echo
pwd
ls -lah
echo "==============================="
pwd
make
make install
cd src/
echo "Files in src after make:"
pwd
ls -lah
./vbfnlo
echo "Files in src after executable"
echo
ls -lah
echo "xrdcp -f event.lhe root://cmseos.fnal.gov//store/user/asahmed/event_${1}_${2}.lhe"
xrdcp -f event.lhe root://cmseos.fnal.gov//store/user/asahmed/VBFNLO_WPhadWMlep_0904/event_${1}_${2}.lhe
xrdcp -f xsection.out root://cmseos.fnal.gov//store/user/asahmed/VBFNLO_WPhadWMlep_0904/xsection_${2}.out
cd ${_CONDOR_SCRATCH_DIR}
echo "End of the cmd"
date
