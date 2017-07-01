function params=readParameters(species,parameters)

% species = 'Mouse';
% parameters = 'Mouse.parameters.xml';

params = struct('rnaSeq','',...
    'cdna','',...
    'ncrna','',...
    'abundantrna','',...
    'transcriptList','',...
    'OligoArray','',...
    'oligos','',...
    'adapters','',...
    'onePCR','',...
    'otherSteps','',...
    'arna','',...
    'probeList','');

tree = xmlread(parameters);
parameters=xmlParse(tree, 'tree', 'parameters');

general=xmlParse(parameters, 'parameters', 'general');
rnaSeq=xmlParse(parameters, 'parameters', 'rnaSeq');
cdna=xmlParse(parameters, 'parameters', 'cdna');
ncrna=xmlParse(parameters, 'parameters', 'ncrna');
abundantrna=xmlParse(parameters, 'parameters', 'abundantrna');
transcriptList=xmlParse(parameters, 'parameters', 'transcriptList');
OligoArray=xmlParse(parameters, 'parameters', 'OligoArray');
oligos=xmlParse(parameters, 'parameters', 'oligos');
adapters=xmlParse(parameters, 'parameters', 'adapters');
onePCR=xmlParse(parameters, 'parameters', 'onePCR');
otherSteps=xmlParse(parameters, 'parameters', 'otherSteps');
arna=xmlParse(parameters, 'parameters', 'arna');
probeList=xmlParse(parameters, 'parameters', 'probeList');

%% Parse general parameters
verbose=xmlParse(general, 'general', 'verbose');
gkey1=xmlParse(general, 'general', 'gkey1');
gkey2=xmlParse(general, 'general', 'gkey2');
gkey3=xmlParse(general, 'general', 'gkey3');
gkey4=xmlParse(general, 'general', 'gkey4');
pnumber=xmlParse(general,'general','number');
plength=xmlParse(general,'general','length');
pgap=xmlParse(general,'general','gap');
gf=xmlParse(general,'general','gf');
grr=xmlParse(general,'general','grr');
T7r=xmlParse(general,'general','T7r');
rRr=xmlParse(general,'general','rRr');
rGr=xmlParse(general,'general','rGr');
rBr=xmlParse(general,'general','rBr');
rIRr=xmlParse(general,'general','rIRr');
parallel=xmlParse(general,'general','parallel');
seqNum=xmlParse(general,'general','seqNum');

%% Parse parameters for rnaSeq
data=xmlParse(rnaSeq, 'rnaSeq', 'data');
if str2double(data.getFirstChild.getData)==0
    dir1=data;
    dir2=data;
elseif str2double(data.getFirstChild.getData)==1
    dir1=xmlParse(rnaSeq, 'rnaSeq', 'dir1');
    dir2=dir1;
elseif str2double(data.getFirstChild.getData)==2
    dir1=xmlParse(rnaSeq, 'rnaSeq', 'dir1');
    dir2=xmlParse(rnaSeq, 'rnaSeq', 'dir2');
end
mRNA=xmlParse(rnaSeq, 'rnaSeq', 'mRNA');
key1=xmlParse(rnaSeq, 'rnaSeq', 'key1');
key2=xmlParse(rnaSeq, 'rnaSeq', 'key2');
thres=xmlParse(rnaSeq, 'rnaSeq', 'thres');

params.rnaSeq = struct('species',species,...
    'verbose',str2double(verbose.getFirstChild.getData),...
    'data',str2double(data.getFirstChild.getData),...
    'dir1',char(dir1.getFirstChild.getData),...
    'dir2',char(dir2.getFirstChild.getData),...
    'mRNA',str2double(mRNA.getFirstChild.getData),...
    'keys',{char(key1.getFirstChild.getData),char(key2.getFirstChild.getData)},...
    'thres',str2double(thres.getFirstChild.getData));

%% Parse parameters for cdna
dir1=xmlParse(cdna, 'cdna', 'dir1');

params.cdna = struct('species',species,...
    'verbose',str2double(verbose.getFirstChild.getData),...
    'dir1',char(dir1.getFirstChild.getData),...
    'keys',{char(gkey1.getFirstChild.getData),char(gkey3.getFirstChild.getData)});

%% Parse parameters for ncrna
dir1=xmlParse(ncrna, 'ncrna', 'dir1');
tRNA=xmlParse(ncrna, 'ncrna', 'tRNA');
if str2double(tRNA.getFirstChild.getData)==1
    dirT=xmlParse(ncrna, 'ncrna', 'dirT');
else
    dirT=tRNA;
end

params.ncrna = struct('species',species,...
    'verbose',str2double(verbose.getFirstChild.getData),...
    'dir1',char(dir1.getFirstChild.getData),...
    'tRNA',str2double(tRNA.getFirstChild.getData),...
    'dirT',char(dirT.getFirstChild.getData),...
    'keys',{char(gkey2.getFirstChild.getData),char(gkey3.getFirstChild.getData),...
    char(gkey4.getFirstChild.getData)});

%% Parse parameters for abundantrna
percent=xmlParse(abundantrna, 'abundantrna', 'percent');
key1=xmlParse(abundantrna, 'abundantrna', 'key1');
key2=xmlParse(abundantrna, 'abundantrna', 'key2');
key3=xmlParse(abundantrna, 'abundantrna', 'key3');
key4=xmlParse(abundantrna, 'abundantrna', 'key4');

params.abundantrna = struct('species',species,...
    'verbose',str2double(verbose.getFirstChild.getData),...
    'percent',str2double(percent.getFirstChild.getData),...
    'keys',{char(key1.getFirstChild.getData),char(key2.getFirstChild.getData),...
    char(key3.getFirstChild.getData),char(key4.getFirstChild.getData)});

%% Parse parameters for transcriptList
dir1=xmlParse(transcriptList, 'transcriptList', 'dir1');

params.transcriptList = struct('species',species,...
    'verbose',str2double(verbose.getFirstChild.getData),...
    'dir1',char(dir1.getFirstChild.getData),...
    'length',str2double(plength.getFirstChild.getData)+str2double(pgap.getFirstChild.getData),...
    'number',floor(str2double(pnumber.getFirstChild.getData)/2.0));

%% Parse parameters for OligoArray
minPercentGC=xmlParse(OligoArray, 'OligoArray', 'minPercentGC');
maxPercentGC=xmlParse(OligoArray, 'OligoArray', 'maxPercentGC');
minPercentGC=str2double(minPercentGC.getFirstChild.getData);
maxPercentGC=str2double(maxPercentGC.getFirstChild.getData);
len=str2double(plength.getFirstChild.getData);
gap=str2double(pgap.getFirstChild.getData);

minTm=floor(81.5+0.41*minPercentGC-500/len)-2;
maxTm=ceil(81.5+0.41*maxPercentGC-500/len)+2;
secstructT=minTm;
crosshybeT=minTm;

params.OligoArray=struct('species',species,...
    'verbose',str2double(verbose.getFirstChild.getData),...
    'GbMem',16,'maxFragment',1E3,...
    'crosshybeT',crosshybeT,'secstructT',secstructT,...
    'minTm',minTm,'maxTm',maxTm,...
    'minPercentGC',minPercentGC,'maxPercentGC',maxPercentGC,...
    'probeLength',len,...
    'probeLengthMax',len,...
    'minProbeDist',len+gap,...
    'maskedSeq','"GGGGGG;CCCCCC;TTTTTT;AAAAAA"',...
    'oligoArrayPath','C:\OligoArray\','oligoArrayExe','C:\OligoArray\OligoArray2.jar',...
    'blastDbPath','C:\OligoArray\BlastDb\','numParallel',10);

%% Parse parameters for oligos
thres=xmlParse(oligos, 'oligos', 'thres');
blastArgs=xmlParse(oligos, 'oligos', 'blastArgs');
dirST=xmlParse(oligos, 'oligos', 'dirST');

params.oligos = struct('species',species,...
    'verbose',str2double(verbose.getFirstChild.getData),...
    'number',str2double(pnumber.getFirstChild.getData),...
    'seqNum',str2double(seqNum.getFirstChild.getData),...
    'thres',str2double(thres.getFirstChild.getData),...
    'querySize',str2double(plength.getFirstChild.getData),...
    'blastArgs',char(blastArgs.getFirstChild.getData),...
    'parallel',str2double(parallel.getFirstChild.getData),...
    'specialTranscripts',char(dirST.getFirstChild.getData));

%% Parse parameters for adapters
dir1=xmlParse(adapters, 'adapters', 'dir1');

params.adapters = struct('species',species,...
    'verbose',str2double(verbose.getFirstChild.getData),...
    'dir1',char(dir1.getFirstChild.getData),...
    'gf',char(gf.getFirstChild.getData),...
    'grr',char(grr.getFirstChild.getData));

%% Parse parameters for 1stPCR
thres=xmlParse(onePCR, 'onePCR', 'thres');
querySize=xmlParse(onePCR, 'onePCR', 'querySize');
blastArgs=xmlParse(onePCR, 'onePCR', 'blastArgs');

params.onePCR = struct('species',species,...
    'verbose',str2double(verbose.getFirstChild.getData),...
    'seqNum',str2double(seqNum.getFirstChild.getData),...
    'thres',str2double(thres.getFirstChild.getData),...
    'querySize',str2double(querySize.getFirstChild.getData),...
    'blastArgs',char(blastArgs.getFirstChild.getData),...
    'parallel',str2double(parallel.getFirstChild.getData),...
    'gf',char(gf.getFirstChild.getData),...
    'grr',char(grr.getFirstChild.getData));

%% Parse parameters for otherSteps
thres=xmlParse(otherSteps, 'otherSteps', 'thres');
blastArgs1=xmlParse(otherSteps, 'otherSteps', 'blastArgs1');
blastArgs2=xmlParse(otherSteps, 'otherSteps', 'blastArgs2');

params.otherSteps = struct('species',species,...
    'verbose',str2double(verbose.getFirstChild.getData),...
    'thres',str2double(thres.getFirstChild.getData),...
    'querySize',str2double(plength.getFirstChild.getData)+20,...
    'blastArgs1',char(blastArgs1.getFirstChild.getData),...
    'blastArgs2',char(blastArgs2.getFirstChild.getData),...
    'grr',char(grr.getFirstChild.getData),...
    'T7r',char(T7r.getFirstChild.getData),...
    'rRr',char(rRr.getFirstChild.getData),...
    'rGr',char(rGr.getFirstChild.getData),...
    'rBr',char(rBr.getFirstChild.getData),...
    'rIRr',char(rIRr.getFirstChild.getData));

%% Parse parameters for arna
thres=xmlParse(arna, 'arna', 'thres');
querySize=xmlParse(arna, 'arna', 'querySize');
blastArgs=xmlParse(arna, 'arna', 'blastArgs');

params.arna = struct('species',species,...
    'verbose',str2double(verbose.getFirstChild.getData),...
    'seqNum',str2double(seqNum.getFirstChild.getData),...
    'thres',str2double(thres.getFirstChild.getData),...
    'querySize',str2double(querySize.getFirstChild.getData),...
    'blastArgs',char(blastArgs.getFirstChild.getData),...
    'parallel',str2double(parallel.getFirstChild.getData));

%% Parse parameters for probeList
dirST=xmlParse(probeList, 'probeList', 'dirST');

params.probeList = struct('species',species,...
    'verbose',str2double(verbose.getFirstChild.getData),...
    'number',str2double(pnumber.getFirstChild.getData),...
    'specialTranscripts',char(dirST.getFirstChild.getData));

