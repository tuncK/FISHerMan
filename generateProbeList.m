function probeList=generateProbeList(probeHeader,probeSequence,varargin)

if length(varargin) >= 1
    params = varargin{1};
else
    params = struct('species','Mouse','verbose',1,'number',48);
end

if params.verbose
    disp('generating the list of probes to order');
    disp('  removing transcripts without enough oligos');
end

pos = regexp(probeHeader, 'ENS\w*T\d*', 'end');
trimHeader = {};
for n = 1:length(probeHeader)
    trimHeader{end+1} = probeHeader{n,1}(1:pos{n,1});
end
trimHeader = trimHeader';
uniqueHeader = unique(trimHeader, 'stable');

indexTotal = zeros(length(trimHeader),1);
for n = 1:length(uniqueHeader)
    index = ismember(trimHeader, uniqueHeader{n,1});
    if sum(index) < params.number
        indexTotal = indexTotal+index;
        if params.verbose
            disp(['  transcript ' uniqueHeader{n,1} ...
                ' has less than ' num2str(params.number) ' probes']);
        end
    end
end

indexTotal = logical(indexTotal);
probeHeader(indexTotal) = [];
probeSequence(indexTotal) = [];

disp('  saving the list of probes');
probeList = [params.species '.probes.fas'];
if exist(probeList, 'file')
    delete(probeList);
end
fastawrite(probeList,probeHeader,probeSequence);