% init2.m
%
% this script demonstrates Nearest-Neighbour and SVM classification
% on a subset of two classes of Hollywood-2 human actions dataset 
% http://www.irisa.fr/vista/actions/hollywood2
%



datapath='./cv/';

%%%%%%%%%%%% TODO
%%%%%%%%%%%%
%%%%%%%%%%%% set the target class by commenting/uncommenting one of the following two lines
%%%%%%%%%%%%

%action='negative'  %-1
%action='neutral';   % 0
action='positive'; % 1

pos = [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 1 1 1 1 1 1 1 1 1 1 1 1 -1 1 -1];

% load training and test annotation
trainfname=[datapath '/' action '_train_sel.txt'];
testfname=[datapath '/' action '_test_sel.txt'];

traingt = [];


[trainids,traingtt]=textread(trainfname,'%s%d');
%[testids,testgt]=textread(testfname,'%s%d');
%fprintf('read annotation for %d training samples with %d samples of class %s\n',length(traingt),length(find(traingt==1)),action)
%fprintf('read annotation for %d test samples with %d samples of class %s\n',length(testgt),length(find(testgt==1)),action)


%%%%%%%%%%%% TODO
%%%%%%%%%%%%
%%%%%%%%%%%% uncomment the following two lines to simulate performance of a random classifier
%%%%%%%%%%%% by randomly permuting training and test labels
%%%%%%%%%%%%

%traingt=traingt(randperm(length(traingt)));
%testgt=testgt(randperm(length(testgt)));

%the leave one out cv - the # that we skip
skip = [1 2];
testgt = [pos(skip)];
testgt = testgt';
if 1 % compute BOF histograms for training and test samples
  
  n=40; % the size of visual vocabulary
  
  % training samples
  %trainbof=zeros(length(trainids),n); % pre-allocate memory;
  fprintf('compute BOF histograms for %d training samples...\n',length(trainids))
  k = 0;
  for i=1:26
      
    if skip(1) == i
        continue;
    end
    
    if skip(2) == i
        continue;
    end
    
    
    k = k+1;
    samplename=[datapath '/histograms/trainhist' num2str(k) '.mat'];
    disp(samplename);
    load(samplename);
    stiplabels=labels2(:,end);
    %%%%%%%% TODO
    %%%%%%%%
    %%%%%%%% compute visual word histograms from 'stiplabels'
    %%%%%%%% hint: use 'histc' function

    % histogram of stip labels
    h=histc(stiplabels,1:n);
    
    % normalize to l2-norm
    trainbof(k,:)=transpose(h(:)/sqrt(h'*h));
    
    traingt = [traingt ; pos(i)];
    
  end

  % test samples
  %testbof=zeros(length(testids),n); % pre-allocate memory;
  fprintf('compute BOF histograms for test samples...\n');
  for i=1:26
      
    if skip(1) ~= i && skip(2) ~= i 
        continue;
    end  
    
   
    samplename=[datapath '/histograms/trainhist' num2str(i) '.mat'];
    disp(samplename);
    load(samplename);
    stiplabels=labels2(:,end);
    
    %%%%%%%% TODO
    %%%%%%%%
    %%%%%%%% compute visual word histograms from 'stiplabels'

    % histogram of stip labels (THE SAME AS ABOVE!)
    %h=...
    h=histc(stiplabels,1:n);
    testbof(i,:)=transpose(h(:)/sqrt(h'*h));
  end
  fprintf('Press a key...\n\n'), pause
end


if 1 % Nearest-Neighbour classification
  
  fprintf('running Nearest-Neighbour classifier...\n')
  dmat=eucliddist(testbof,trainbof);
  [mv,mi]=min(dmat,[],2);
  conf=-mv;
  
  % plot precision-recall curve
  figure(1), clf
  [rec,prec,ap,sortind]=precisionrecall(conf,testgt);
  fprintf(' -> Average Precision for %s: %1.3f\n\n',action,ap)

end

  
if 1 % SVM classification using SVM-light package http://svmlight.joachims.org/
  
  fprintf('running SVM classifier...\n')
  %addpath('svm_mex601')
  %addpath('svm_mex601/bin')
  %addpath('svm_mex601/matlab')
  addpath('./libsvm-3.14/matlab/')
  
  %%%%%%%%% TODO
  %%%%%%%%%
  %%%%%%%%% try SVM classifiers with different C and gamma parameters
  %%%%%%%%% 
  
  x=trainbof;
  y=traingt;
  %model = svmlearn(x,y,'-t 2 -g 1 -c 0.1 -v 0');
  
  %libsvm
  model = svmtrain(y,x,'-t 2 -g 1 -c 0.5');
  
  xtest=testbof;
  ytest=testgt;
  %[err,predictions] = svmclassify(xtest,ytest,model);
  %libSVM
  
  [err,predictions] = svmpredict(ytest,xtest,model);
  % draw precision-recall curve
  figure(2), clf
  [rec,prec,ap,sortind]=precisionrecall(predictions,testgt);
  fprintf(' -> Average Precision for %s: %1.3f\n\n',action,ap)
end


if 0 % GMM classification 
     dag = [ 0 1 1 ; 0 0 1 ; 0 0 0 ];
     discrete_nodes = [1 2];
     nodes = [1 : 3];
     node_sizes=[ 2 2 40];
     bnet = mk_bnet(dag, node_sizes, 'discrete', discrete_nodes);
     bnet.CPD{1} = tabular_CPD(bnet,1);
     bnet.CPD{2} = tabular_CPD(bnet,2);
     bnet.CPD{3} = gaussian_CPD(bnet, 3);
     %bnet.CPD{3} = gaussian_CPD(bnet, 3,'cov_type','diag');
     trainingX = trainbof(1:10,:);
     trainingX(11:20,:) = trainbof(11:20,:);
     trainingC(1:10) = 1;   %% Class 1 is negative
     trainingC(11:20) = 2; %% Class 2 is positive
     testX(1:3,:) = testbof(1:3,:);   %% The first 3 are pos
     testX(4:6,:) = testbof(4:6,:);  %% The next 3 are neg
     training= cell(3,20);
     training(3,:) = num2cell(trainingX',1);
     training(1,:) = num2cell(trainingC,1);
     engine = jtree_inf_engine(bnet);
     maxiter=10;     %% The number of iterations of EM (max)
     epsilon=1e-100; %% A very small stopping criterion
     [bnet2, ll, engine2] = learn_params_em(engine,training,maxiter,epsilon);
     class0= cell(3,1); %% Create an empty cell array for observations
     class1 = class0;
     class2 = class0;
     class1{1} = 1;     %% The class node is observed to be positive
     class2{1} = 2;     %% The class node is observed to be negative
     for i=1:10
       sample1=sample_bnet(bnet2,'evidence',class1);
       sample2=sample_bnet(bnet2,'evidence',class2);
       modelX(i,:)=sample1{3}';
       modelX(i+10,:)=sample2{3}';
     end
     %figure
     %subplot(2,1,1);
     %plot(trainingX);
     %subplot(2,1,2);
     %plot(modelX);
     %evidence=class0;   %% Start out with nothing observed
     for i=1:6
       evidence{3}=testX(i,:)';
       [engine3, ll] = enter_evidence(engine2,evidence);
       marg = marginal_nodes(engine3,1);
       p(i,:)=marg.T';
     end
     figure;
     subplot(2,1,1);
     plot(testX);
     hold
     plot(p(:,1));  %% Plot the output of the positive classifier
     subplot(2,1,2);
     plot(testX);
     hold
     plot(p(:,2));  %% Plot the output of the negative classifier
end
    


