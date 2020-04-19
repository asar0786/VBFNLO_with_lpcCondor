# VBFNLO_with_lpcCondor
This code can produce lhe on lpc condor
- Place your .dat file on eos and change the path in .sh file.
- Make directory where you want to copy .lhe files, and make path change in .sh file.
- You can choose desired lhapdf set while conguting, choice can be bade in vbfnlo.dat file
- run `voms-proxy-init --voms cms --valid 168:00`
- `condor_submit submit_condor.jdl`
