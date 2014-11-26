%% 
%%
%%
% 1:Beginning 2:Middle 3:End
seq = 20; %number of HMM observations in a sequence of a video
n = 40; %number of clusters (visual words)

data = [];
k = 1;

set = 'testing';

for i=1:10
    if i==17 continue; end
    load('./baby_stips/baby_vocab.mat');
    stipname = ['./baby_stips/' set];
    name = [stipname,num2str(i), '.txt'];
    disp(['reading stips: ',name])
    [pos,val,dscr]=readstips_text(name);
    [r,c] = size(dscr);
    
    
    
    counter = round(r/seq);
    init = 1;
    bof = [];
    for j=1:seq
        stop = init + counter;
        
        if((r - stop) > 1)
            b = dscr(init:stop,:);
        else
            b = dscr(init:end,:);
        end
        
        dmat = eucliddist(b,centers1);
        [bins labels] = min(dmat,[],2);
        
        h=histc(labels,1:n);
        bof(j,:) = transpose(h(:)/sqrt(h'*h));
        
        
        init = init + counter;
    end
    data(:,:,k) = bof';
    k = k+1;
end

clearvars -except data;
save negativedata data;